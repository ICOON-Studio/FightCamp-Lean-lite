#!/usr/bin/env python
"""Q77's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q77_check.py

Q70 adjudicated where every KICK lands. Q77 adjudicates the other 200 standing-strike
candidates Q70's census ruled not-a-kick: which of them strike at all, and where each
strike lands. This gate does not decide either question - that is the adjudication.
It checks the table COVERS every candidate, agrees with itself and with the catalogue,
holds the anchors no reading of the sport can dispute, and names every row that
disagrees with the locational key its node already carries.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
TARGETS = ("head", "body", "leg", "spread")
CONFIDENCE = ("high", "medium", "low")
STRIKE_KINDS = ("punch", "elbow", "knee", "kick", "headbutt", "mixed", "none")
# What each explicit key already says, in FightMoves._regions_for's own terms.
KEY_TARGET = {"head_damage": "head", "body_damage": "body", "clinch_damage": "body",
              "leg_damage": "leg", "lowline_damage": "leg"}
# Anchors: no reading of the sport disputes these.
MUST_TARGET = {
    "muay_thai_horizontal_elbow": "head",
    "muay_thai_up_elbow": "head",
    "muay_thai_spinning_elbow": "head",
    "muay_thai_clinch_knees": "body",
}
MUST_KIND = {
    "karate_kizami_maegeri": "kick",
    "taekwondo_back_kick_counter": "kick",
    "muay_thai_horizontal_elbow": "elbow",
    "muay_thai_straight_knee": "knee",
}
MUST_NOT_STRIKE = ("boxing_pivot_footwork", "boxing_distance_read", "kickboxing_switch_step_read",
                   "taekwondo_footwork_switch", "savate_assaut_footwork", "sanda_inside_sweep")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    q70 = json.load(open(os.path.join(RESEARCH, "Q70_kick_targets.json"), encoding="utf-8"))
    candidates = sorted(e["id"] for e in q70["census"] if e.get("is_kick") is False)
    catalogue = json.load(open(os.path.join(ROOT, "Godot", "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    nodes = {}
    for discipline in catalogue["disciplines"]:
        for node in discipline["nodes"]:
            nodes[node["id"]] = (discipline["id"], node)

    json_path = os.path.join(RESEARCH, "Q77_strike_targets.json")
    md_path = os.path.join(RESEARCH, "Q77_STRIKE_TARGETS.md")
    check(os.path.exists(json_path), "Q77_strike_targets.json exists")
    check(os.path.exists(md_path), "Q77_STRIKE_TARGETS.md exists")
    if failures:
        return 1
    try:
        table = json.load(open(json_path, encoding="utf-8"))
        rows = table["rows"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads and carries `rows` (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    check(bool(str(table.get("catalogue_commit", "")).strip()), "`catalogue_commit` names the catalogue that was read")
    check(str(table.get("catalogue_commit", "@@")) in report, "the report states the same catalogue commit")

    ids = [r.get("id") for r in rows]
    missing = [i for i in candidates if i not in ids]
    extra = [i for i in ids if i not in candidates]
    doubled = sorted({i for i in ids if ids.count(i) > 1})
    check(not missing, "every one of the %d non-kick candidates has a row (missing=%d %s)" % (len(candidates), len(missing), missing[:6]))
    check(not extra, "no row outside Q70's non-kick census (extra=%s)" % extra[:6])
    check(not doubled, "no candidate adjudicated twice (%s)" % doubled[:6])
    check(ids == sorted(ids, key=lambda i: (nodes.get(i, ("", {}))[0], i)), "rows are sorted by discipline, then id")

    fields = ("id", "discipline", "kind", "role", "effects", "is_strike", "strike_kind", "target", "confidence", "reason")
    for field in fields:
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    if failures:
        return 1

    by_id = {r["id"]: r for r in rows}
    wrong_meta = [r["id"] for r in rows if r["id"] in nodes and (
        r["discipline"] != nodes[r["id"]][0]
        or r["kind"] != nodes[r["id"]][1].get("kind")
        or r["role"] != (nodes[r["id"]][1].get("match") or {}).get("role")
        or r["effects"] != ((nodes[r["id"]][1].get("match") or {}).get("effects") or {}))]
    check(not wrong_meta, "discipline / kind / role / effects match the catalogue as authored (wrong=%s)" % wrong_meta[:6])
    check(all(isinstance(r["is_strike"], bool) for r in rows), "`is_strike` is a boolean on every row")
    check(all(r["strike_kind"] in STRIKE_KINDS for r in rows), "every strike_kind is one of %s" % (STRIKE_KINDS,))
    check(all(r["confidence"] in CONFIDENCE for r in rows), "every confidence is one of %s" % (CONFIDENCE,))
    check(all(str(r["reason"]).strip() for r in rows), "every row has a reason")

    strikes = [r for r in rows if r["is_strike"] is True]
    blows = [r for r in rows if r["is_strike"] is False]
    check(all(r["strike_kind"] != "none" and r["target"] in TARGETS for r in strikes),
          "every strike names a strike_kind and a target in %s" % (TARGETS,))
    check(all(r["strike_kind"] == "none" and r["target"] is None for r in blows),
          "every non-strike has strike_kind `none` and target null")
    limb = [r["id"] for r in strikes if r["strike_kind"] in ("punch", "elbow", "headbutt") and r["target"] == "leg"]
    check(not limb, "no punch, elbow or headbutt lands on a leg (%s)" % limb[:6])

    for tid, target in MUST_TARGET.items():
        check(by_id.get(tid, {}).get("target") == target, "%s lands on the %s" % (tid, target))
    for tid, kind in MUST_KIND.items():
        check(by_id.get(tid, {}).get("strike_kind") == kind, "%s is a %s" % (tid, kind))
    for tid in MUST_NOT_STRIKE:
        check(by_id.get(tid, {}).get("is_strike") is False, "%s is not a strike" % tid)

    counts = {"strikes": len(strikes), "not_strikes": len(blows)}
    for target in TARGETS:
        counts[target] = sum(1 for r in strikes if r["target"] == target)
    for key, value in counts.items():
        check(table.get("summary", {}).get(key) == value, "summary.%s=%s equals the rows (%d)" % (key, table.get("summary", {}).get(key), value))

    upper = report.upper()
    disagree = sorted(r["id"] for r in strikes
                      if {KEY_TARGET[k] for k in r["effects"] if k in KEY_TARGET}
                      and r["target"] not in {KEY_TARGET[k] for k in r["effects"] if k in KEY_TARGET})
    check("DISAGREES WITH ITS KEY" in upper, "the report has a DISAGREES WITH ITS KEY section")
    unnamed = [i for i in disagree if i not in report]
    check(not unnamed, "every strike whose target disagrees with its own locational key is named (%d; unnamed=%s)" % (len(disagree), unnamed[:6]))
    check("SEQUENCES" in upper, "the report has a SEQUENCES section saying how a chain's target was judged")
    check("karate_kizami_maegeri" in report and "taekwondo_back_kick_counter" in report,
          "the report names both kicks Q70's census missed")

    print("Q77_CHECK candidates=%d strikes=%d not_strikes=%d head=%d body=%d leg=%d spread=%d disagree=%d failures=%d"
          % (len(candidates), counts["strikes"], counts["not_strikes"], counts["head"], counts["body"],
             counts["leg"], counts["spread"], len(disagree), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
