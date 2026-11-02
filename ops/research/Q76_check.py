#!/usr/bin/env python
"""Q76's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q76_check.py

Checks the delivery's claims about the code against the code (golden score, shido, the
functions it names), its anchors against the lines they cite, and the option shape.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
SHARES = ("ippon", "waza_ari_at_time", "golden_score", "shido")
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def main():
    scripts = os.path.join(ROOT, "Godot", "scripts")
    sim = open(os.path.join(scripts, "FightSimulation.gd"), encoding="utf-8").read()
    scoring = open(os.path.join(scripts, "RoundScoring.gd"), encoding="utf-8").read()
    engine = sim + "\n" + scoring
    has_golden = re.search(r"golden", engine, re.I) is not None
    has_shido = re.search(r"shido|hansoku", engine, re.I) is not None

    json_path = os.path.join(ROOT, "research", "Q76_judo_decisions.json")
    md_path = os.path.join(ROOT, "research", "Q76_JUDO_AT_TIME.md")
    check(os.path.exists(json_path), "Q76_judo_decisions.json exists")
    check(os.path.exists(md_path), "Q76_JUDO_AT_TIME.md exists")
    if failures:
        return
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        mechanism = delivery["mechanism"]
        anchors = delivery["anchors"]
        options = delivery["options"]
        recommend = delivery["recommend"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads with mechanism / anchors / options / recommend (%s)" % error)
        return

    check(mechanism.get("golden_score") is has_golden, "golden_score is %s, as FightSimulation/RoundScoring really are" % has_golden)
    check(mechanism.get("shido") is has_shido, "shido is %s, as FightSimulation/RoundScoring really are" % has_shido)
    check(isinstance(mechanism.get("decides_at_time"), list) and len(mechanism["decides_at_time"]) >= 2, "decides_at_time names at least two counters")
    check(bool(str(mechanism.get("level_points", "")).strip()) and bool(str(mechanism.get("judo_board", "")).strip()), "level_points and judo_board are answered")

    check(isinstance(anchors, list) and len(anchors) >= 4, "at least four J26 endings anchors")
    for anchor in anchors if isinstance(anchors, list) else []:
        path = os.path.join(ROOT, str(anchor.get("file", "")).replace("/", os.sep))
        quote = str(anchor.get("quote", "")).strip()
        line_no = int(anchor.get("line", 0) or 0)
        ok = False
        if os.path.exists(path) and quote and line_no > 0:
            lines = open(path, encoding="utf-8", errors="replace").read().splitlines()
            ok = line_no <= len(lines) and quote in lines[line_no - 1]
        check(ok, "anchor %r: the quote is on %s:%s" % (anchor.get("metric"), anchor.get("file"), anchor.get("line")))

    check(isinstance(options, list) and len(options) >= 3, "at least three options")
    ids = []
    for option in options if isinstance(options, list) else []:
        ids.append(option.get("id"))
        check(bool(str(option.get("rule", "")).strip()), "option %s states its rule" % option.get("id"))
        touches = option.get("touches", [])
        exists = isinstance(touches, list) and touches and all(("func %s(" % t) in engine or t in ("combat_rulesets.json", "JudoBoard.gd") for t in touches)
        check(bool(exists), "option %s touches only functions or files that exist (%s)" % (option.get("id"), touches))
        predict = option.get("predict", {})
        check(set(predict) == set(SHARES) and all(v in ("up", "down", "same") for v in predict.values()),
              "option %s predicts up/down/same for %s" % (option.get("id"), ", ".join(SHARES)))
    check(recommend in ids, "recommend names one of the options")
    memo = open(md_path, encoding="utf-8").read()
    check("_finish_fight" in memo and "round_points" in memo, "memo traces _finish_fight and round_points")
    check(len(memo.split()) >= 350, "memo is a memo, not a stub (>= 350 words)")


if __name__ == "__main__":
    main()
    print("Q76_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)
