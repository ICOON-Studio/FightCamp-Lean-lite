"""C132 gate (Claude, 2026-09-14). Prints `C132_CHECK PASS` or FAIL lines. Run from the repo root.

A reading task is only as good as its citations: every Evidence row's quote is re-found in the cited file within 3
lines of the cited line number, independently of the digest's own wording.
"""
import os
import re
import subprocess
import sys

DIGEST = "research/C132_JAB_TYPES_IN_ENGINE.md"
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def norm(s):
    return re.sub(r"\s+", " ", s).strip()


for path in ["Godot/scripts", "Godot/tests", "Godot/assets/data", "research/C132_check.py"]:
    r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", path])
    if r.returncode != 0:
        fail("%s has uncommitted changes - C132 edits nothing but its digest" % path)

if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
    print("C132_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)
text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if len(lines) > 110:
    fail("the digest has %d lines - 110 at most" % len(lines))
for head in ("# C132 - the three jabs in the engine", "## ANSWERS", "## Evidence", "## What the room shows", "## Open"):
    if head not in text:
        fail("the digest has no '%s'" % head)


def section(name):
    part = text.split(name, 1)[-1] if name in text else ""
    return part.split("\n## ", 1)[0]


answers = section("## ANSWERS")
for q in range(1, 7):
    if not re.search(r"(^|\n)\s*(\*\*)?Q%d\.(\*\*)?\s+\S" % q, answers):
        fail("## ANSWERS has no line starting 'Q%d.'" % q)

rows = re.findall(r"^- `(Godot/scripts/[A-Za-z0-9_]+\.gd):(\d+)` \"(.+?)\" - (.+)$", section("## Evidence"), flags=re.M)
files = set()
cache = {}
for path, line_no, quote, _why in rows:
    if not os.path.exists(path):
        fail("Evidence cites %s, which does not exist" % path)
        continue
    if path not in cache:
        cache[path] = open(path, encoding="utf-8", errors="replace").read().splitlines()
    src = cache[path]
    n = int(line_no)
    window = " ".join(src[max(0, n - 4):min(len(src), n + 3)])
    if norm(quote) not in norm(window):
        fail("%s:%s - the quote \"%s\" is not within 3 lines of that line" % (path, line_no, quote[:80]))
    else:
        files.add(os.path.basename(path))
print("C132_CHECK evidence rows %d, verified files %s" % (len(rows), sorted(files)))
if len(rows) < 14:
    fail("## Evidence has %d well-formed rows - at least 14 (format: - `Godot/scripts/X.gd:N` \"quote\" - why)" % len(rows))
if len(files) < 5:
    fail("verified quotes come from %d files - at least 5" % len(files))
for must in ("FightStagePlayer.gd", "FightRealtime.gd"):
    if must not in files:
        fail("## Evidence needs a verified row from %s" % must)

room = section("## What the room shows")
for tech in ("boxing_jab", "boxing_distance_read", "boxing_feint"):
    row = next((l for l in room.splitlines() if l.startswith("|") and tech in l), None)
    if row is None:
        fail("## What the room shows has no table row for %s" % tech)
    elif not re.search(r"[A-Za-z]+\.gd:\d+", row):
        fail("the %s row cites no file:line" % tech)
if len([l for l in section("## Open").splitlines() if l.strip()]) > 8:
    fail("## Open is longer than 8 lines")

print("C132_CHECK PASS" if not fails else "C132_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
