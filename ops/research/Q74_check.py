#!/usr/bin/env python
"""Q74's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q74_check.py

It does not decide a family for any contested node. It recomputes the submission
census and the engine's region resolver from disk, so the delivery cannot agree
with itself; it checks anchors that no nomenclature disputes; and it requires a
reason wherever the delivery overrules the catalogue's own effect keys.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
FAMILIES = {"neck", "arm", "leg", "body", "unspecified"}
MECHANISMS = {"choke", "joint_lock", "compression", "generic"}
REGIONS = {"head_neck", "torso_core", "arm", "leg", "random_role_roll"}
FAMILY_REGION = {"neck": "head_neck", "arm": "arm", "leg": "leg", "body": "torso_core"}
# Unambiguous under Kodokan / IBJJF / FIAS naming. The two substring traps are here
# on purpose: an "arm" id that is a choke and a "sankaku" id that is an armlock.
ANCHORS = {
    "bjj_rnc": "neck", "bjj_triangle": "neck", "bjj_guillotine": "neck", "bjj_arm_triangle": "neck",
    "bjj_armbar": "arm", "bjj_kimura": "arm", "bjj_americana": "arm",
    "brazilian_jiu_jitsu_heel_hook": "leg", "bjj_kneebar": "leg", "sambo_straight_ankle": "leg",
    "judo_hadakajime": "neck", "judo_okurierijime": "neck", "judo_jujigatame": "arm",
    "judo_udegarami": "arm", "judo_udehishigisankakugatame": "arm", "judo_dojime": "body",
    "mma_mount_finish": "arm",
}
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def engine_region(effects):
    """FightSimulation._technique_target_region, :2156-2186, without the plan bias."""
    head = body = leg = arm = 0.0
    for key, value in effects.items():
        weight = abs(float(value))
        if "head" in key:
            head += weight
        elif "leg" in key:
            leg += weight
        elif "body" in key or "liver" in key or "torso" in key:
            body += weight
        elif "arm" in key or "shoulder" in key:
            arm += weight
    best = max(head, body, leg, arm)
    if best <= 0.0:
        return "random_role_roll"
    if head == best:
        return "head_neck"
    if body == best:
        return "torso_core"
    if leg == best:
        return "leg"
    return "arm"


def main():
    catalogue = json.load(open(os.path.join(ROOT, "Godot", "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    expected = {}
    for discipline in catalogue["disciplines"]:
        for node in discipline["nodes"]:
            if str(node.get("match", {}).get("role", "")) == "submission":
                expected[node["id"]] = (discipline["id"], node)
    print("catalogue submission nodes: %d" % len(expected))

    json_path = os.path.join(RESEARCH, "Q74_submission_targets.json")
    md_path = os.path.join(RESEARCH, "Q74_SUBMISSION_TARGETS.md")
    check(os.path.exists(json_path), "Q74_submission_targets.json exists")
    check(os.path.exists(md_path), "Q74_SUBMISSION_TARGETS.md exists")
    if failures:
        return
    try:
        rows = json.load(open(json_path, encoding="utf-8"))["rows"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads and has a rows list (%s)" % error)
        return
    ids = [str(row.get("id", "")) for row in rows]
    check(len(ids) == len(set(ids)), "no duplicate rows")
    check(set(ids) == set(expected), "rows cover exactly the catalogue's submission nodes (missing %s, extra %s)"
          % (sorted(set(expected) - set(ids)), sorted(set(ids) - set(expected))))

    mismatches = 0
    for row in rows:
        node_id = str(row.get("id", ""))
        if node_id not in expected:
            continue
        discipline_id, node = expected[node_id]
        effects = node["match"].get("effects", {})
        family = row.get("family")
        check(row.get("discipline") == discipline_id, "%s discipline is %s" % (node_id, discipline_id))
        check(row.get("name") == node.get("name"), "%s name is verbatim from the catalogue" % node_id)
        check(family in FAMILIES, "%s family %r is allowed" % (node_id, family))
        check(row.get("mechanism") in MECHANISMS, "%s mechanism %r is allowed" % (node_id, row.get("mechanism")))
        region = engine_region(effects)
        check(row.get("engine_region_today") == region, "%s engine_region_today is %s (got %r)" % (node_id, region, row.get("engine_region_today")))
        should_match = FAMILY_REGION.get(family) == region
        check(row.get("matches") is should_match, "%s matches is %s" % (node_id, should_match))
        if not should_match:
            mismatches += 1
        check(bool(str(row.get("source", "")).strip()), "%s cites a source" % node_id)
        own = "arm" if any("arm" in k or "shoulder" in k for k in effects) else ("leg" if any("leg" in k for k in effects) else "")
        if own and family in FAMILY_REGION and family != own:
            check(bool(str(row.get("note", "")).strip()), "%s overrules its own %s effect key, so it carries a note" % (node_id, own))
        if node_id in ANCHORS:
            check(family == ANCHORS[node_id], "anchor %s is %s (got %r)" % (node_id, ANCHORS[node_id], family))

    memo = open(md_path, encoding="utf-8").read()
    check(re.search(r"mismatches\s*=\s*%d\b" % mismatches, memo) is not None, "memo states mismatches=%d, the checker's own count" % mismatches)
    check("RingStagePanel.gd:465" in memo, "memo cites where the player sees the region (RingStagePanel.gd:465)")
    check(len(memo.split()) >= 250, "memo is a memo, not a stub (>= 250 words)")


if __name__ == "__main__":
    main()
    print("Q74_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)
