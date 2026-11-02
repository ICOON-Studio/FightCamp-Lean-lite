#!/usr/bin/env python
"""Q75's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q75_check.py

Checks the delivery against the disk: the measured fixture numbers Claude handed over,
the stand-up formula quoted from INSIDE _resolve_escape_attempt, anchor quotes on the
lines they name, and a usable option set. It does not pick an option.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
FIXTURES = [
    ("bjj", 1420, 94, 56, 512, 5),
    ("mma_grappler_striker", 803, 120, 81, 74, 0),
    ("mma_thai_jiujitsu", 983, 138, 80, 173, 0),
    ("judo", 258, 82, 50, 0, 0),
    ("sambo", 555, 0, 0, 278, 21),
]
FIELDS = ("ground_exchanges", "escapes_landed", "stand_ups", "submission_lands", "submission_finishes")
MATCHUPS = [f[0] for f in FIXTURES]
failures = []


def check(ok, message):
    print("%s  %s" % ("PASS" if ok else "FAIL", message))
    if not ok:
        failures.append(message)


def function_body(source, name):
    match = re.search(r"^static func %s\(.*?(?=^static func |\Z)" % re.escape(name), source, re.S | re.M)
    return match.group(0) if match else ""


def main():
    json_path = os.path.join(ROOT, "research", "Q75_escape_options.json")
    md_path = os.path.join(ROOT, "research", "Q75_WHAT_RESISTS_A_STAND_UP.md")
    check(os.path.exists(json_path), "Q75_escape_options.json exists")
    check(os.path.exists(md_path), "Q75_WHAT_RESISTS_A_STAND_UP.md exists")
    if failures:
        return
    try:
        delivery = json.load(open(json_path, encoding="utf-8"))
        fixtures = delivery["fixtures"]
        mechanism = delivery["mechanism"]
        anchors = delivery["anchors"]
        options = delivery["options"]
        recommend = delivery["recommend"]
    except Exception as error:  # noqa: BLE001
        check(False, "JSON loads with fixtures / mechanism / anchors / options / recommend (%s)" % error)
        return

    check([str(r.get("matchup")) for r in fixtures] == MATCHUPS, "fixtures are the five matchups in order")
    for row, want in zip(fixtures, FIXTURES):
        for field, value in zip(FIELDS, want[1:]):
            check(row.get(field) == value, "%s %s = %d (got %r)" % (want[0], field, value, row.get(field)))

    source = open(os.path.join(ROOT, "Godot", "scripts", "FightSimulation.gd"), encoding="utf-8").read()
    body = function_body(source, "_resolve_escape_attempt")
    formula = str(mechanism.get("stand_up_formula", "")).strip()
    check(bool(body), "_resolve_escape_attempt exists in FightSimulation.gd")
    check(bool(formula) and formula in body, "the stand-up formula quoted is inside _resolve_escape_attempt (%r)" % formula)
    for key in ("land_roll_terms", "stand_up_roll_terms", "top_man_terms"):
        check(isinstance(mechanism.get(key), list) and len(mechanism.get(key)) >= 1, "mechanism.%s lists at least one term" % key)

    check(isinstance(anchors, list) and len(anchors) >= 2, "at least two anchors")
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
        check(isinstance(touches, list) and touches and all(("static func %s(" % t) in source for t in touches),
              "option %s touches only functions that exist (%s)" % (option.get("id"), touches))
        predict = option.get("predict", {})
        check(set(predict) == set(MATCHUPS) and all(v in ("up", "down", "same") for v in predict.values()),
              "option %s predicts up/down/same for all five matchups" % option.get("id"))
        check(predict.get("judo") == "same", "option %s leaves judo alone (osaekomi is Claude's, in S1e)" % option.get("id"))
    check(recommend in ids, "recommend names one of the options")

    memo = open(md_path, encoding="utf-8").read()
    check("_resolve_escape_attempt" in memo, "memo names _resolve_escape_attempt")
    check(len(memo.split()) >= 350, "memo is a memo, not a stub (>= 350 words)")


if __name__ == "__main__":
    main()
    print("Q75_CHECK failures=%d" % len(failures))
    sys.exit(1 if failures else 0)
