#!/usr/bin/env python
"""Q70's acceptance gate. Written by Claude after two deliveries missed the same
four corrections. Run it from the repo root; commit only when it exits 0.

    python research/Q70_check.py

It does not decide what is a kick - that is the adjudication Q70 exists to make.
It checks that the adjudication COVERS every candidate, agrees with itself and
with the catalogue, and says the things the review found false no longer.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
LOCATIONAL = ("head_damage", "body_damage", "leg_damage", "lowline_damage", "clinch_damage", "ground_damage")
TARGETS = ("head", "body", "leg", "spread")
CONFIDENCE = ("high", "medium", "low")
MUST_BE_KICKS = ("tkd_dollyochagi", "tkd_naeryochagi", "tkd_apchagi", "savate_fouette",
                 "savate_chasse_bas", "capoeira_armada", "capoeira_meialua", "kickboxing_roundhouse")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def r137_is_kick_id(tid):
    """tools/measure_kick_funnel.gd:219, transcribed exactly - including its knee."""
    probe = tid.lower()
    for marker in ("kick", "teep", "low_kick", "high_kick", "roundhouse", "switch_kick", "hook_kick", "axe_kick", "knee"):
        if marker in probe and "elbow" not in probe:
            return True
    return False


def main():
    candidates = json.load(open(os.path.join(RESEARCH, "Q70_candidates.json"), encoding="utf-8"))
    table = json.load(open(os.path.join(RESEARCH, "Q70_kick_targets.json"), encoding="utf-8"))
    report = open(os.path.join(RESEARCH, "Q70_KICK_TARGETS.md"), encoding="utf-8").read()
    catalogue = json.load(open(os.path.join(ROOT, "Godot", "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    effects = {n["id"]: (n.get("match") or {}).get("effects") or {}
               for d in catalogue["disciplines"] for n in d["nodes"]}

    cand_ids = [c["id"] for c in candidates]
    census = table.get("census")
    check(isinstance(census, list), "Q70_kick_targets.json has a `census` list (one entry per candidate)")
    census = census if isinstance(census, list) else []
    by_id = {}
    for entry in census:
        by_id.setdefault(entry.get("id"), []).append(entry)
    missing = [i for i in cand_ids if i not in by_id]
    extra = [i for i in by_id if i not in cand_ids]
    doubled = [i for i, v in by_id.items() if len(v) > 1]
    check(not missing, "every one of the %d candidates is adjudicated (missing=%d %s)" % (len(cand_ids), len(missing), missing[:6]))
    check(not extra, "no census entry outside the candidate list (extra=%s)" % extra[:6])
    check(not doubled, "no candidate adjudicated twice (%s)" % doubled[:6])
    check(all(isinstance(e.get("is_kick"), bool) for e in census), "every census entry has a boolean `is_kick`")
    check(all(isinstance(e.get("r137_is_kick"), bool) for e in census), "every census entry has a boolean `r137_is_kick`")

    kicks = {e["id"] for e in census if e.get("is_kick") is True}
    for tid in MUST_BE_KICKS:
        check(tid in kicks, "%s is adjudicated a kick" % tid)
    boxing = [c["id"] for c in candidates if c["discipline"] == "boxing"]
    check(not (set(boxing) & kicks), "boxing contributes zero kicks")
    knees = [i for i in kicks if "knee" in i]
    check(not knees, "no knee is adjudicated a kick (%s)" % knees[:6])

    wrong_r137 = [e["id"] for e in census if e.get("r137_is_kick") != r137_is_kick_id(e.get("id", ""))]
    check(not wrong_r137, "`r137_is_kick` reproduces measure_kick_funnel.gd:219 exactly (wrong=%s)" % wrong_r137[:6])
    disagreements = sorted(e["id"] for e in census if e.get("is_kick") != r137_is_kick_id(e.get("id", "")))
    check(str(len(disagreements)) in report and "RECONCILIATION" in report.upper(),
          "the report has a RECONCILIATION section stating the %d disagreements with R137" % len(disagreements))
    listed = [i for i in disagreements if i not in report]
    check(not listed, "every disagreement with R137 is named in the report (unnamed=%s)" % listed[:6])

    rows = table.get("rows") or []
    row_ids = [r.get("id") for r in rows]
    check(sorted(row_ids) == sorted(kicks), "`rows` holds exactly one row per adjudicated kick (rows=%d kicks=%d)" % (len(row_ids), len(kicks)))
    for field in ("id", "discipline", "effects", "sim_today", "moves_today", "target", "confidence", "reason"):
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    check(all(r.get("target") in TARGETS for r in rows), "every target is one of %s" % (TARGETS,))
    check(all(r.get("confidence") in CONFIDENCE for r in rows), "every confidence is one of %s" % (CONFIDENCE,))
    check(all(str(r.get("reason", "")).strip() for r in rows), "every row has a reason")
    check(all(r.get("effects") == effects.get(r.get("id")) for r in rows), "every row's effects match the catalogue as authored")
    unlocated = sum(1 for i in kicks if not set(effects.get(i, {})) & set(LOCATIONAL))
    check(table.get("kicks_total") == len(kicks), "kicks_total=%s equals the census (%d)" % (table.get("kicks_total"), len(kicks)))
    check(table.get("unlocated") == unlocated, "unlocated=%s equals kicks with no explicit locational key (%d)" % (table.get("unlocated"), unlocated))

    lowered = report.lower()
    check("shrink" not in lowered, "the report no longer blames a catalogue shrink (R137's shadow IS master's 696 nodes)")
    check("dead code" not in lowered, "the report no longer calls the arm branch dead code")
    check("1431" in report, "the report cites FightSimulation.gd:1431, where _technique_target_region IS called")

    print("Q70_CHECK candidates=%d kicks=%d unlocated=%d r137_disagreements=%d failures=%d"
          % (len(cand_ids), len(kicks), unlocated, len(disagreements), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
