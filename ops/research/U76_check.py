#!/usr/bin/env python
"""U76's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U76_check.py

S1e taught the engine that a defence answers some ACTIONS, not all of them. S2 gives a
strike a TARGET. U76 adjudicates the next step: which target regions each striking
defence node answers. This gate does not decide an answer. It derives the node list from
the catalogue and the vocabulary, checks coverage, enums and the catalogue columns, holds
anchors no reading of the sport disputes, and checks the report names the consumers.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
REGIONS = ("head", "body", "leg")
CONFIDENCE = ("high", "medium", "low")
MUST_INCLUDE = {"kickboxing_kick_check": "leg", "savate_lowline_read": "leg", "boxing_slip": "head",
                "boxing_bob_weave": "head", "muay_thai_teep_defense": "body"}
MUST_EXCLUDE = {"savate_lowline_read": "head", "boxing_slip": "leg", "boxing_bob_weave": "leg"}

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    vocabulary = json.load(open(os.path.join(GODOT, "assets", "data", "technique_vocabulary.json"), encoding="utf-8"))
    catalogue = json.load(open(os.path.join(GODOT, "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    strike_keys = {k for k, classes in vocabulary["defense_answers"].items() if "strike" in classes}
    nodes = {}
    for discipline in catalogue["disciplines"]:
        for node in discipline["nodes"]:
            match = node.get("match") or {}
            if match.get("role") == "defense" and set(match.get("effects") or {}) & strike_keys:
                nodes[node["id"]] = (discipline["id"], node)

    json_path = os.path.join(RESEARCH, "U76_defence_regions.json")
    md_path = os.path.join(RESEARCH, "U76_DEFENCE_BY_REGION.md")
    check(os.path.exists(json_path), "U76_defence_regions.json exists")
    check(os.path.exists(md_path), "U76_DEFENCE_BY_REGION.md exists")
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
    missing = sorted(set(nodes) - set(ids))
    extra = sorted(set(ids) - set(nodes))
    check(not missing, "every one of the %d striking defence nodes has a row (missing=%d %s)" % (len(nodes), len(missing), missing[:6]))
    check(not extra, "no row outside the striking defence nodes (extra=%s)" % extra[:6])
    check(len(ids) == len(set(ids)), "no node adjudicated twice")
    for field in ("id", "discipline", "phases", "effects", "answers", "confidence", "reason"):
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    if failures:
        return 1

    wrong = [r["id"] for r in rows if r["id"] in nodes and (
        r["discipline"] != nodes[r["id"]][0]
        or r["phases"] != (nodes[r["id"]][1].get("match") or {}).get("phases")
        or r["effects"] != (nodes[r["id"]][1].get("match") or {}).get("effects"))]
    check(not wrong, "discipline / phases / effects match the catalogue as authored (wrong=%s)" % wrong[:6])
    bad = [r["id"] for r in rows if not (isinstance(r["answers"], list) and r["answers"]
                                         and len(set(r["answers"])) == len(r["answers"])
                                         and all(a in REGIONS for a in r["answers"]))]
    check(not bad, "every `answers` is a non-empty list of distinct regions from %s (bad=%s)" % (REGIONS, bad[:6]))
    check(all(r["confidence"] in CONFIDENCE for r in rows), "every confidence is one of %s" % (CONFIDENCE,))
    check(all(str(r["reason"]).strip() for r in rows), "every row has a reason")

    by_id = {r["id"]: r for r in rows}
    for tid, region in MUST_INCLUDE.items():
        check(region in (by_id.get(tid, {}).get("answers") or []), "%s answers the %s" % (tid, region))
    for tid, region in MUST_EXCLUDE.items():
        check(region not in (by_id.get(tid, {}).get("answers") or [region]), "%s does not answer the %s" % (tid, region))

    all_three = sum(1 for r in rows if sorted(r["answers"]) == sorted(REGIONS))
    summary = table.get("summary", {})
    check(summary.get("nodes") == len(rows), "summary.nodes equals the rows")
    check(summary.get("all_regions") == all_three, "summary.all_regions=%s equals the rows answering all three (%d)" % (summary.get("all_regions"), all_three))
    for region in REGIONS:
        count = sum(1 for r in rows if region in r["answers"])
        check(summary.get(region) == count, "summary.%s=%s equals the rows answering it (%d)" % (region, summary.get(region), count))

    upper = report.upper()
    for section in ("CONSUMERS", "ORDER OF OPERATIONS", "OPTIONS"):
        check(section in upper, "the report has a %s section" % section)
    for token in ("_defender_defense_factor", "guard_arsenal", "_technique_target_region"):
        check(token in report, "the report names `%s`" % token)

    print("U76_CHECK nodes=%d all_regions=%d head=%d body=%d leg=%d failures=%d"
          % (len(rows), all_three, sum(1 for r in rows if "head" in r["answers"]),
             sum(1 for r in rows if "body" in r["answers"]), sum(1 for r in rows if "leg" in r["answers"]), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
