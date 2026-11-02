#!/usr/bin/env python
"""Q80's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q80_check.py

S2 gave every kick an explicit target and the realtime leg share barely moved. The sweep's
per-technique breakdown says why: FightMoves.select weights a technique by its ROLE (and
range fit) only, so every live technique of a role is about equally likely, and the leg
share becomes the share of leg techniques in the palette. Q80 is the research the next
stage needs: how selection really weights, what the palette holds, and what real-bout
technique frequencies are ON DISK. This gate recomputes the palette table from the
catalogue and checks citations and sections; it does not judge the options.
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
    return re.findall(r'"([^"]+)"', re.search(r"const %s := \[(.*?)\]" % name, text, re.S).group(1))


def cited(entry):
    path = os.path.join(ROOT, str(entry.get("file", "")))
    if not os.path.isfile(path):
        return False
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    line = int(entry.get("line", 0) or 0)
    token = str(entry.get("token", ""))
    if not token or line < 1 or line > len(lines):
        return False
    return any(token in lines[i] for i in range(max(0, line - 3), min(len(lines), line + 2)))


def palette():
    moves = open(os.path.join(GODOT, "scripts", "FightMoves.gd"), encoding="utf-8").read()
    strike_roles = const_list(moves, "STRIKE_ROLES")
    grapple = set(const_list(moves, "GRAPPLE_EFFECTS"))
    aliases = dict(re.findall(r'"(\w+)"\s*:\s*"(\w+)"', re.search(r"const DISCIPLINE_TAG_ALIASES := \{(.*?)\}", moves, re.S).group(1)))
    max_tier = int(re.search(r"const DEFAULT_ARSENAL_MAX_TIER := (\d+)", moves).group(1))
    catalogue = json.load(open(os.path.join(GODOT, "assets", "data", "technique_catalog.json"), encoding="utf-8"))
    known = [d["id"] for d in catalogue["disciplines"]]
    rulesets = {r["id"]: r for r in json.load(open(os.path.join(GODOT, "assets", "data", "combat_rulesets.json"), encoding="utf-8"))["rulesets"]}
    out = {}
    for rid in REALTIME:
        drawn = []
        for tag in rulesets[rid].get("discipline_tags", []):
            resolved = aliases.get(tag, tag)
            if resolved in known and resolved not in drawn:
                drawn.append(resolved)
        row = {"nodes": 0, "names_leg": 0, "only_leg": 0, "unnamed": 0}
        for discipline in catalogue["disciplines"]:
            if discipline["id"] not in drawn:
                continue
            for node in discipline["nodes"]:
                match = node.get("match") or {}
                phases = match.get("phases") or []
                if (match.get("role") not in strike_roles or set(match.get("effects") or {}) & grapple
                        or not phases or all(p.startswith("weapon") for p in phases) or int(node.get("tier", 99)) > max_tier):
                    continue
                target = match.get("target_region") or []
                row["nodes"] += 1
                row["names_leg"] += "leg" in target
                row["only_leg"] += target == ["leg"]
                row["unnamed"] += not target
        out[rid] = row
    return out


def main():
    json_path = os.path.join(RESEARCH, "Q80_flat_palette.json")
    md_path = os.path.join(RESEARCH, "Q80_THE_FLAT_PALETTE.md")
    check(os.path.exists(json_path), "Q80_flat_palette.json exists")
    check(os.path.exists(md_path), "Q80_THE_FLAT_PALETTE.md exists")
    if failures:
        return 1
    try:
        table = json.load(open(json_path, encoding="utf-8"))
        selection = table["selection"]
        rows = table["palette"]
        evidence = table["frequency_evidence"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads with selection / palette / frequency_evidence (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    bad = ["%s:%s %s" % (e.get("file"), e.get("line"), e.get("token")) for e in selection if not cited(e)]
    check(selection and not bad, "every selection factor cites a real file:line holding its token (bad=%s)" % bad[:4])
    for token in ("select", "role_weights", "throw_share"):
        check(any(token in str(e.get("token", "")) for e in selection), "a selection factor cites `%s`" % token)

    want = palette()
    got = {r.get("ruleset"): {k: r.get(k) for k in ("nodes", "names_leg", "only_leg", "unnamed")} for r in rows if isinstance(r, dict)}
    for rid in REALTIME:
        check(got.get(rid) == want[rid], "palette row for %s recomputes from the catalogue (%s)" % (rid, want[rid]))

    for e in evidence:
        path = os.path.join(ROOT, str(e.get("file", "")))
        ok = os.path.isfile(path) and str(e.get("quote", "@@")) in open(path, encoding="utf-8", errors="replace").read()
        check(ok, "frequency evidence quote is verbatim in %s" % e.get("file"))
    check(isinstance(table.get("not_on_disk"), list) and table.get("not_on_disk"), "`not_on_disk` lists what an outside query would have to find")

    upper = report.upper()
    for section in ("HOW A TECHNIQUE IS CHOSEN", "THE PALETTE", "WHAT REAL BOUTS SAY", "OPTIONS"):
        check(section in upper, "the report has a %s section" % section)
    check(str(table.get("recommend", "")) in ("a", "b", "c"), "`recommend` is a, b or c")

    print("Q80_CHECK selection=%d palette=%d evidence=%d failures=%d" % (len(selection), len(rows), len(evidence), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
