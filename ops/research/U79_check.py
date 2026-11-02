#!/usr/bin/env python
"""U79's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U79_check.py

S2's sweep found `boxing_distance_read`, `boxing_step_in_out` and both circles LANDING as
strikes - about a fifth of boxing's landed total is footwork. FightMoves.move_from_node
admits any setup / damage / counter node that carries none of GRAPPLE_EFFECTS. U79 is the
census of everything it admits that delivers no blow. This gate transcribes the admission
rule from FightMoves.gd at run time, derives the admitted set for the four realtime
rulesets, and checks the census covers it; it does not decide what is a blow.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
REALTIME = ("boxing", "kickboxing", "muay_thai", "mma")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def const_list(text, name):
    found = re.search(r"const %s := \[(.*?)\]" % name, text, re.S)
    return re.findall(r'"([^"]+)"', found.group(1))


def main():
    moves = open(os.path.join(GODOT, "scripts", "FightMoves.gd"), encoding="utf-8").read()
    strike_roles = const_list(moves, "STRIKE_ROLES")
    grapple = set(const_list(moves, "GRAPPLE_EFFECTS"))
    aliases = dict(re.findall(r'"(\w+)"\s*:\s*"(\w+)"', re.search(r"const DISCIPLINE_TAG_ALIASES := \{(.*?)\}", moves, re.S).group(1)))
    catalogue = json.load(open(os.path.join(GODOT, "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    known = [d["id"] for d in catalogue["disciplines"]]
    rulesets = {r["id"]: r for r in json.load(open(os.path.join(GODOT, "assets", "data", "combat_rulesets.json"), encoding="utf-8"))["rulesets"]}
    drawn = set()
    for rid in REALTIME:
        for tag in rulesets[rid].get("discipline_tags", []):
            resolved = aliases.get(tag, tag)
            if resolved in known:
                drawn.add(resolved)

    def weapon_only(phases):
        return bool(phases) and all(p.startswith("weapon") for p in phases)

    admitted = {}
    for discipline in catalogue["disciplines"]:
        if discipline["id"] not in drawn:
            continue
        for node in discipline["nodes"]:
            match = node.get("match") or {}
            if match.get("role") not in strike_roles:
                continue
            if set(match.get("effects") or {}) & grapple:
                continue
            phases = match.get("phases") or []
            if not phases or weapon_only(phases):
                continue
            admitted[node["id"]] = (discipline["id"], node)

    json_path = os.path.join(RESEARCH, "U79_admitted_strikes.json")
    md_path = os.path.join(RESEARCH, "U79_ONLY_A_BLOW_LANDS.md")
    check(os.path.exists(json_path), "U79_admitted_strikes.json exists")
    check(os.path.exists(md_path), "U79_ONLY_A_BLOW_LANDS.md exists")
    if failures:
        return 1
    try:
        rows = json.load(open(json_path, encoding="utf-8"))["rows"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads and carries `rows` (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    ids = [r.get("id") for r in rows]
    missing = sorted(set(admitted) - set(ids))
    extra = sorted(set(ids) - set(admitted))
    check(not missing, "every node move_from_node admits for a realtime ruleset has a row (%d; missing=%d %s)" % (len(admitted), len(missing), missing[:6]))
    check(not extra, "no row outside the admitted set (extra=%s)" % extra[:6])
    for field in ("id", "discipline", "tier", "role", "effects", "delivers_blow", "reason", "source"):
        check(all(field in r for r in rows), "every row carries `%s`" % field)
    if failures:
        return 1
    wrong = [r["id"] for r in rows if r["id"] in admitted and (
        r["discipline"] != admitted[r["id"]][0]
        or r["tier"] != admitted[r["id"]][1].get("tier")
        or r["role"] != (admitted[r["id"]][1].get("match") or {}).get("role")
        or r["effects"] != (admitted[r["id"]][1].get("match") or {}).get("effects"))]
    check(not wrong, "discipline / tier / role / effects match the catalogue (wrong=%s)" % wrong[:6])
    check(all(isinstance(r["delivers_blow"], bool) for r in rows), "`delivers_blow` is a boolean on every row")
    check(all(r["source"] in ("Q70", "Q77", "U79") for r in rows), "every row's source is Q70, Q77 or U79 (your own adjudication)")

    q70 = {e["id"]: e for e in json.load(open(os.path.join(RESEARCH, "Q70_kick_targets.json"), encoding="utf-8"))["census"]}
    q77 = {r["id"]: r for r in json.load(open(os.path.join(RESEARCH, "Q77_strike_targets.json"), encoding="utf-8"))["rows"]}
    disagree = []
    for r in rows:
        if q70.get(r["id"], {}).get("is_kick") is True and r["delivers_blow"] is not True:
            disagree.append(r["id"])
        if r["id"] in q77 and q77[r["id"]].get("is_strike") is not r["delivers_blow"]:
            disagree.append(r["id"])
    unnamed = [i for i in disagree if i not in report]
    check(not unnamed, "every row that overrules Q70 or Q77 is named in the report (%s)" % unnamed[:6])
    for anchor in ("boxing_distance_read", "boxing_step_in_out"):
        check(any(r["id"] == anchor and r["delivers_blow"] is False for r in rows), "%s delivers no blow" % anchor)
    for anchor in ("boxing_jab", "boxing_cross"):
        check(any(r["id"] == anchor and r["delivers_blow"] is True for r in rows), "%s delivers a blow" % anchor)

    upper = report.upper()
    for section in ("THE ADMISSION RULE", "DEFAULT ARSENAL", "WHAT CHANGES", "OPTIONS"):
        check(section in upper, "the report has a %s section" % section)

    blows = sum(1 for r in rows if r["delivers_blow"])
    print("U79_CHECK admitted=%d blows=%d not_blows=%d overrules=%d failures=%d" % (len(rows), blows, len(rows) - blows, len(disagree), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
