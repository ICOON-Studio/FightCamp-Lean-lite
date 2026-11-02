"""C106 gate (Claude's; the agent never edits it).

python research/C106_check.py --sweep-before <log> --sweep-after <log> --r103-after <log> --impact-after <log>

Fails on: any SCRIPT ERROR, a missing end marker, a sweep result table that moved by one byte,
a missing POPULATION line, or a POPULATION line whose two men carry the same stats.
"""
import argparse
import re
import sys

FAILS = []


def fail(msg):
    FAILS.append(msg)
    print("FAIL " + msg)


def read(path):
    with open(path, "rb") as f:
        return f.read().decode("utf-8", errors="replace")


def no_errors(name, text):
    if "SCRIPT ERROR" in text:
        fail("%s: SCRIPT ERROR in the log" % name)


def sweep_table(text):
    """The result rows and everything after them, minus timing noise."""
    lines = text.splitlines()
    start = None
    for i, line in enumerate(lines):
        if line.startswith("ruleset ") and "population" in line:
            start = i
            break
    if start is None:
        return None
    keep = []
    for line in lines[start:]:
        if "msec" in line or " ms" in line or line.startswith("rc=") or "Godot Engine" in line:
            continue
        keep.append(line.rstrip())
        if line.startswith("SWEEP complete"):
            break
    return keep


def populations(name, text, want_rulesets):
    rows = [l for l in text.splitlines() if l.startswith("POPULATION ")]
    if not rows:
        fail("%s: no POPULATION line" % name)
        return
    seen = set()
    for row in rows:
        m = re.search(r"ruleset=(\S+)", row)
        if not m:
            fail("%s: POPULATION line names no ruleset: %s" % (name, row[:120]))
            continue
        seen.add(m.group(1))
        halves = row.split("|")
        if len(halves) != 2:
            fail("%s: POPULATION line is not 'a ... | b ...': %s" % (name, row[:120]))
            continue
        stats = []
        for half in halves:
            s = re.search(r"stats=(\{.*?\})", half)
            if not s:
                fail("%s: a side prints no stats=: %s" % (name, half[:120]))
                break
            stats.append(s.group(1))
        if len(stats) == 2:
            if stats[0] == stats[1]:
                fail("%s: IDENTICAL stats for ruleset %s" % (name, m.group(1)))
            if stats[0] in ("{}", "{ }"):
                fail("%s: empty stats for ruleset %s" % (name, m.group(1)))
    for r in want_rulesets:
        if r not in seen:
            fail("%s: no POPULATION line for ruleset %s" % (name, r))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--sweep-before", required=True)
    ap.add_argument("--sweep-after", required=True)
    ap.add_argument("--r103-after", required=True)
    ap.add_argument("--impact-after", required=True)
    a = ap.parse_args()

    before = read(a.sweep_before)
    after = read(a.sweep_after)
    r103 = read(a.r103_after)
    impact = read(a.impact_after)

    for name, text in (("sweep-before", before), ("sweep-after", after), ("r103", r103), ("impact", impact)):
        no_errors(name, text)
    if "SWEEP complete" not in before:
        fail("sweep-before: no 'SWEEP complete' - the baseline run did not finish")
    if "SWEEP complete" not in after:
        fail("sweep-after: no 'SWEEP complete'")
    if "IMPACT done" not in impact:
        fail("impact: no 'IMPACT done'")
    if "R103" not in r103 or "FAIL:" in r103:
        fail("r103: the probe banner is missing or it printed FAIL:")

    tb = sweep_table(before)
    ta = sweep_table(after)
    if tb is None or ta is None:
        fail("sweep: result table not found in one of the logs")
    elif tb != ta:
        for i, (x, y) in enumerate(zip(tb, ta)):
            if x != y:
                fail("sweep table MOVED at row %d:\n  before: %s\n  after:  %s" % (i, x, y))
                break
        else:
            fail("sweep table length moved: %d -> %d rows" % (len(tb), len(ta)))

    populations("r103", r103, ["boxing"])
    populations("impact", impact, ["boxing", "kickboxing", "muay_thai", "mma"])

    if FAILS:
        print("C106_CHECK FAIL (%d)" % len(FAILS))
        return 1
    print("C106_CHECK PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
