"""C133 gate (Claude, 2026-09-15). Prints `C133_CHECK PASS` or FAIL lines. Run from the repo root.

Same shape as C132's gate and for the same reason: a reading task is only as good as its citations, so every Evidence
row's quote is re-found in the cited file within 3 lines of the cited line number, independently of the digest's own
wording. C133 also has to answer "nothing" honestly in places, so the absence rows are checked too.
"""
import os
import re
import subprocess
import sys

DIGEST = "research/C133_ENGINE_POSITION_STANCE_DEFENCE.md"
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def norm(s):
    return re.sub(r"\s+", " ", s).strip()


for path in ["Godot/scripts", "Godot/tests", "Godot/assets/data", "research/C133_check.py"]:
    r = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", path])
    if r.returncode != 0:
        fail("%s has uncommitted changes - C133 edits nothing but its digest" % path)

if not os.path.exists(DIGEST):
    fail("%s is missing" % DIGEST)
    print("C133_CHECK FAIL (%d)" % len(fails))
    sys.exit(1)

text = open(DIGEST, encoding="utf-8").read()
lines = text.splitlines()
if len(lines) > 130:
    fail("the digest has %d lines - 130 at most" % len(lines))
for head in (
    "# C133 - what the engine has for position, stance, defence, feints and the gaps",
    "## ANSWERS",
    "## Evidence",
    "## Where a change goes",
    "## Open",
):
    if head not in text:
        fail("the digest has no '%s'" % head)


def section(name):
    part = text.split(name, 1)[-1] if name in text else ""
    return part.split("\n## ", 1)[0]


answers = section("## ANSWERS")
for q in range(1, 8):
    if not re.search(r"(^|\n)\s*(\*\*)?Q%d\.(\*\*)?\s+\S" % q, answers):
        fail("## ANSWERS has no line starting 'Q%d.'" % q)

rows = re.findall(
    r"^- `(Godot/(?:scripts|assets/data)/[A-Za-z0-9_/]+\.(?:gd|json)):(\d+)` \"(.+?)\" - (.+)$",
    section("## Evidence"),
    flags=re.M,
)
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
        fail('%s:%s - the quote "%s" is not within 3 lines of that line' % (path, line_no, quote[:80]))
    else:
        files.add(os.path.basename(path))

print("C133_CHECK evidence rows %d, verified files %s" % (len(rows), sorted(files)))
if len(rows) < 18:
    fail('## Evidence has %d well-formed rows - at least 18 (format: - `Godot/scripts/X.gd:N` "quote" - why)' % len(rows))
if len(files) < 7:
    fail("verified quotes come from %d files - at least 7" % len(files))
for must in ("RingSpace.gd", "FightIntent.gd", "FightRealtime.gd"):
    if must not in files:
        fail("## Evidence needs a verified row from %s" % must)

# An honest "nothing" is an answer this task expects, and it has to be searchable rather than asserted: the digest
# records the rg pattern it ran. Without this the easy failure is a confident "there is no stance model" with no
# evidence of having looked.
if not re.search(r"`rg[^`]+`", text):
    fail("no `rg ...` pattern is recorded - an absence is only evidence if the search that found it is written down")

where = section("## Where a change goes")
for behaviour in ("ring", "stance", "defence", "feint", "between"):
    row = next((l for l in where.splitlines() if l.startswith("|") and behaviour in l.lower()), None)
    if row is None:
        fail("## Where a change goes has no row for '%s'" % behaviour)
        continue
    if not re.search(r"[A-Za-z_]+\.gd:\d+", row):
        fail("the '%s' row names no File.gd:N" % behaviour)
    if not re.search(r"[a-z0-9_]+_test\.gd", row):
        fail("the '%s' row names no test file" % behaviour)

if len([l for l in section("## Open").splitlines() if l.strip()]) > 8:
    fail("## Open is longer than 8 lines")

print("C133_CHECK PASS" if not fails else "C133_CHECK FAIL (%d)" % len(fails))
sys.exit(0 if not fails else 1)
