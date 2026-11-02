"""C108 gate (Claude's): the ruleset sweep at the ruleset's own round length, opt-in.

python research/C108_check.py --before <log> --default <log> --ruleset <log>

Fails on: any SCRIPT ERROR; a run without 'SWEEP complete'; a default run whose result table moved from the
pre-edit run; a ruleset run that prints no ROUNDS line for an authored ruleset or prints a length that is not
that ruleset's own (read from combat_rulesets.json HERE, independently of the tool); a ruleset run whose
table is byte-identical to the default (the flag did nothing); and a default run that prints ROUNDS lines.
"""
import argparse
import json
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
RULESETS = os.path.join(os.path.dirname(HERE), "assets", "data", "combat_rulesets.json")
FAILS = []


def fail(msg):
    FAILS.append(msg)
    print("FAIL " + msg)


def read(path):
    with open(path, "rb") as f:
        return f.read().decode("utf-8", errors="replace")


def table(text):
    lines = text.splitlines()
    start = next((i for i, l in enumerate(lines) if l.startswith("ruleset ") and "population" in l), None)
    if start is None:
        return None
    out = []
    for line in lines[start:]:
        if "msec" in line or line.startswith("GODOT_RUN") or line.startswith("ROUNDS "):
            continue
        out.append(line.rstrip())
        if line.startswith("SWEEP complete"):
            break
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--before", required=True)
    ap.add_argument("--default", required=True)
    ap.add_argument("--ruleset", required=True)
    a = ap.parse_args()
    runs = {"before": read(a.before), "default": read(a.default), "ruleset": read(a.ruleset)}
    for name, text in runs.items():
        if "SCRIPT ERROR" in text:
            fail("%s: SCRIPT ERROR" % name)
        if "SWEEP complete" not in text:
            fail("%s: no 'SWEEP complete'" % name)
    tb, td, tr = table(runs["before"]), table(runs["default"]), table(runs["ruleset"])
    if tb is None or td is None or tr is None:
        fail("a result table is missing")
    else:
        if tb != td:
            fail("the DEFAULT run's table moved from the pre-edit run - the flag is not opt-in")
        if tr == td:
            fail("the ruleset_rounds run is identical to the default - the flag changed nothing")
    if "ROUNDS " in runs["default"]:
        fail("the default run prints ROUNDS lines")

    data = json.load(open(RULESETS, encoding="utf-8"))
    bucket = data.get("rulesets", data)
    authored = {}
    if isinstance(bucket, list):
        for r in bucket:
            if isinstance(r, dict) and "round_seconds" in r:
                authored[str(r.get("id"))] = r
    elif isinstance(bucket, dict):
        for k, r in bucket.items():
            if isinstance(r, dict) and "round_seconds" in r:
                authored[k] = r
    printed = {}
    for m in re.finditer(r"^ROUNDS ruleset=(\S+) round_seconds=([0-9.]+) rest_seconds=([0-9.]+)", runs["ruleset"], re.M):
        printed[m.group(1)] = (float(m.group(2)), float(m.group(3)))
    if not printed:
        fail("the ruleset run printed no ROUNDS lines")
    for rid, (rs, rest) in printed.items():
        if rid not in authored:
            fail("ROUNDS for %s, which combat_rulesets.json does not author" % rid)
            continue
        want = (float(authored[rid]["round_seconds"]), float(authored[rid].get("rest_seconds", 60)))
        if (rs, rest) != want:
            fail("%s printed %.1f/%.1f s, the ruleset says %.1f/%.1f" % (rid, rs, rest, want[0], want[1]))
    if FAILS:
        print("C108_CHECK FAIL (%d)" % len(FAILS))
        return 1
    print("C108_CHECK PASS rulesets=%d" % len(printed))
    return 0


if __name__ == "__main__":
    sys.exit(main())
