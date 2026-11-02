#!/usr/bin/env python
"""Q79's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q79_check.py

S2 roughly doubles the share of strikes that land on a leg. Q79 is the census of what a
landed leg strike DOES, in both engines, so a moved number after S2 can be read. This gate
does not judge the census. It checks every consequence cites a real file:line holding its
token, that both engines and the named consumers are covered, and the report's sections.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
ENGINES = ("simulation", "realtime")
KINDS = ("damage", "body_condition", "mobility", "stamina", "knockdown", "stoppage", "scoring", "presentation", "injury", "other")
MUST_FILES = ("FightSimulation.gd", "FightRealtime.gd", "ImpactModel.gd", "FightBeatAdapter.gd", "RealtimeRoundStats.gd")

failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


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


def main():
    json_path = os.path.join(RESEARCH, "Q79_leg_strike_consequences.json")
    md_path = os.path.join(RESEARCH, "Q79_WHAT_A_LEG_KICK_DOES.md")
    check(os.path.exists(json_path), "Q79_leg_strike_consequences.json exists")
    check(os.path.exists(md_path), "Q79_WHAT_A_LEG_KICK_DOES.md exists")
    if failures:
        return 1
    try:
        rows = json.load(open(json_path, encoding="utf-8"))["consequences"]
    except Exception as error:  # noqa: BLE001
        check(False, "the JSON loads and carries `consequences` (%s)" % error)
        return 1
    report = open(md_path, encoding="utf-8").read()

    for field in ("engine", "kind", "file", "line", "token", "what", "bounded_by"):
        check(all(field in r for r in rows), "every consequence carries `%s`" % field)
    if failures:
        return 1
    bad = ["%s:%s %s" % (r["file"], r["line"], r["token"]) for r in rows if not cited(r)]
    check(rows and not bad, "every consequence cites a real file:line holding its token (bad=%s)" % bad[:4])
    check(all(r["engine"] in ENGINES + ("both",) for r in rows), "every engine is simulation, realtime or both")
    check(all(r["kind"] in KINDS for r in rows), "every kind is one of %s" % (KINDS,))
    for engine in ENGINES:
        check(sum(1 for r in rows if r["engine"] in (engine, "both")) >= 3, "at least three consequences in the %s engine" % engine)
    for name in MUST_FILES:
        check(any(str(r["file"]).endswith(name) for r in rows), "a consequence is cited in %s" % name)

    upper = report.upper()
    for section in ("SIMULATION", "REALTIME", "WHAT MOVES WHEN LEGS DOUBLE", "ANCHORS ON DISK"):
        check(section in upper, "the report has a %s section" % section)

    print("Q79_CHECK consequences=%d simulation=%d realtime=%d failures=%d"
          % (len(rows), sum(1 for r in rows if r["engine"] in ("simulation", "both")),
             sum(1 for r in rows if r["engine"] in ("realtime", "both")), len(failures)))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
