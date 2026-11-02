#!/usr/bin/env python
"""U78's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U78_check.py

S4 makes the 3D room take a booked bout. U78 is the census S4 starts from: every
hardcode in FightWorldLiveScreen, where a booked bout lives today, which body a career
athlete gets, which arena each ruleset needs. This gate does not judge the proposal. It
checks every cited file:line holds the token it claims, recomputes the arena table and
the fighter-file table from disk, and checks the report's sections.
"""
import glob
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
MUST_HARDCODES = ("94301", "f01_m_box_welter_rigged.glb", "f02_m_box_heavy_rigged.glb", "\"boxing\"")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def cited(entry):
    """True when `file` exists under the repo and `token` sits within 2 lines of `line`."""
    path = os.path.join(ROOT, str(entry.get("file", "")))
    if not os.path.isfile(path):
        return False
    lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
    line = int(entry.get("line", 0) or 0)
    token = str(entry.get("token", ""))
    if not token or line < 1 or line > len(lines):
        return False
    return any(token in lines[i] for i in range(max(0, line - 3), min(len(lines), line + 2)))


def main():
    json_path = os.path.join(RESEARCH, "U78_booked_bout_census.json")
    md_path = os.path.join(RESEARCH, "U78_THE_ROOM_TAKES_A_REAL_FIGHT.md")
    check(os.path.exists(json_path), "U78_booked_bout_census.json exists")
    check(os.path.exists(md_path), "U78_THE_ROOM_TAKES_A_REAL_FIGHT.md exists")
    if failures:
        return 1
    try:
        table = json.load(open(json_path, encoding="utf-8"))
        hardcodes = table["hardcodes"]
        route = table["route"]
        arenas = table["arenas"]
        bodies = table["bodies"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads with hardcodes / route / arenas / bodies (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    entries = [e for e in hardcodes if isinstance(e, dict)] + [e for e in route if isinstance(e, dict)]
    bad = [("%s:%s %s" % (e.get("file"), e.get("line"), e.get("token"))) for e in entries if not cited(e)]
    check(entries and not bad, "every hardcode and route entry cites a real file:line holding its token (bad=%s)" % bad[:4])
    screen = [e for e in hardcodes if str(e.get("file", "")).endswith("FightWorldLiveScreen.gd")]
    for token in MUST_HARDCODES:
        check(any(token in str(e.get("token", "")) for e in screen), "the hardcodes name FightWorldLiveScreen's %s" % token)

    rulesets = json.load(open(os.path.join(GODOT, "assets", "data", "combat_rulesets.json"), encoding="utf-8"))["rulesets"]
    want = {r["id"]: r.get("arena_profile") for r in rulesets}
    got = {a.get("ruleset"): a.get("arena_profile") for a in arenas if isinstance(a, dict)}
    check(got == want, "arenas lists every ruleset with its arena_profile from combat_rulesets.json")
    check(all(isinstance(a.get("built_today"), bool) for a in arenas), "every arena says whether the room can build it today (`built_today`)")

    files = sorted(os.path.basename(p) for p in glob.glob(os.path.join(GODOT, "assets", "models", "fighters", "*_rigged.glb")))
    named = sorted(b.get("file") for b in bodies if isinstance(b, dict))
    check(named == files, "bodies lists every rigged fighter file on disk (%d)" % len(files))
    check(all(b.get("sex") in ("m", "f") and str(b.get("discipline", "")) and str(b.get("weight", "")) for b in bodies),
          "every body carries the sex, discipline and weight its file name encodes")

    upper = report.upper()
    for section in ("HARDCODES", "WHERE A BOOKED BOUT LIVES", "WHICH BODY", "WHICH ARENA", "THE ENTRY CONTRACT", "GAPS"):
        check(section in upper, "the report has a %s section" % section)
    check("C98" in report, "the report says what C98's two 1.00 m fighters mean for body selection")

    print("U78_CHECK hardcodes=%d route=%d arenas=%d bodies=%d failures=%d"
          % (len(hardcodes), len(route), len(arenas), len(bodies), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
