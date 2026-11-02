#!/usr/bin/env python
"""U77's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U77_check.py

Karate and taekwondo score a kick and a punch to the same place differently, and the
kickboxing and muay thai profiles weight body kicks and leg kicks above body punches.
Which limb landed is decided in FightSimulation and FightRange by id/name SUBSTRING,
and in the realtime record not at all. U77 measures both against the adjudicated census
(Q70 kicks, Q77 every other standing strike). This gate transcribes both classifiers
from the code at run time and recomputes every row; it does not judge the options.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
KINDS = ("kick", "knee", "elbow", "punch", "headbutt", "mixed", "none")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def markers(rel):
    text = open(os.path.join(GODOT, rel), encoding="utf-8").read()
    found = re.search(r"const KICK_MARKERS := \[([^\]]*)\]", text)
    return re.findall(r'"([^"]+)"', found.group(1))


def main():
    sim_markers = markers("scripts/FightSimulation.gd")
    range_markers = markers("scripts/FightRange.gd")

    def sim_is_kick(probe):
        if "elbow" in probe:
            return False
        return any(m in probe for m in sim_markers)

    def range_is_kick(probe):
        if "elbow" in probe or "knee" in probe:
            return False
        return any(m in probe for m in range_markers)

    catalogue = json.load(open(os.path.join(GODOT, "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    nodes = {n["id"]: n for d in catalogue["disciplines"] for n in d["nodes"]}
    q70 = json.load(open(os.path.join(RESEARCH, "Q70_kick_targets.json"), encoding="utf-8"))
    q77 = {r["id"]: r for r in json.load(open(os.path.join(RESEARCH, "Q77_strike_targets.json"), encoding="utf-8"))["rows"]}
    expected = {}
    for entry in q70["census"]:
        tid = entry["id"]
        if entry.get("is_kick") is True:
            kind = "kick"
        else:
            row = q77.get(tid, {})
            kind = row.get("strike_kind", "none") if row.get("is_strike") else "none"
        probe = (tid + " " + str(nodes[tid].get("name", ""))).lower()
        expected[tid] = {"kind": kind, "sim": sim_is_kick(probe), "range": range_is_kick(probe)}

    json_path = os.path.join(RESEARCH, "U77_limb_census.json")
    md_path = os.path.join(RESEARCH, "U77_THE_LIMB_THAT_SCORES.md")
    check(os.path.exists(json_path), "U77_limb_census.json exists")
    check(os.path.exists(md_path), "U77_THE_LIMB_THAT_SCORES.md exists")
    if failures:
        return 1
    try:
        table = json.load(open(json_path, encoding="utf-8"))
        rows = table["rows"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads and carries `rows` (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    ids = [r.get("id") for r in rows]
    check(sorted(ids) == sorted(expected) and len(ids) == len(set(ids)),
          "one row per Q70 census candidate (%d; rows=%d)" % (len(expected), len(ids)))
    for field in ("id", "adjudicated", "sim_is_kick", "range_is_kick"):
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    if failures:
        return 1
    wrong = [r["id"] for r in rows if r["id"] in expected and (
        r["adjudicated"] != expected[r["id"]]["kind"]
        or r["sim_is_kick"] is not expected[r["id"]]["sim"]
        or r["range_is_kick"] is not expected[r["id"]]["range"])]
    check(not wrong, "every row's adjudicated kind and both classifiers' answers recompute from code and census (wrong=%s)" % wrong[:6])
    check(all(r["adjudicated"] in KINDS for r in rows), "every adjudicated kind is one of %s" % (KINDS,))

    def disagrees(classifier, row):
        is_kick = expected[row]["kind"] == "kick"
        return expected[row][classifier] != is_kick and expected[row]["kind"] != "none"

    sim_wrong = sorted(i for i in expected if disagrees("sim", i))
    range_wrong = sorted(i for i in expected if disagrees("range", i))
    summary = table.get("summary", {})
    check(summary.get("sim_wrong") == len(sim_wrong), "summary.sim_wrong=%s equals the strikes FightSimulation._is_kick mislabels (%d)" % (summary.get("sim_wrong"), len(sim_wrong)))
    check(summary.get("range_wrong") == len(range_wrong), "summary.range_wrong=%s equals the strikes FightRange._is_kick mislabels (%d)" % (summary.get("range_wrong"), len(range_wrong)))
    unnamed = [i for i in sorted(set(sim_wrong) | set(range_wrong)) if i not in report]
    check(not unnamed, "every mislabelled strike is named in the report (unnamed=%d %s)" % (len(unnamed), unnamed[:6]))

    upper = report.upper()
    for section in ("CONSUMERS", "THE REALTIME RECORD", "OPTIONS"):
        check(section in upper, "the report has a %s section" % section)
    for token in ("_credit_zone_hit", "REGION_TO_ZONE", "RealtimeRoundStats", "FightRange"):
        check(token in report, "the report names `%s`" % token)
    check(str(table.get("recommend", "")) in ("a", "b", "c"), "`recommend` is a, b or c")

    print("U77_CHECK candidates=%d sim_wrong=%d range_wrong=%d failures=%d" % (len(expected), len(sim_wrong), len(range_wrong), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
