"""Q99 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q99_check.py

Checks Qwen's R3-SOURCE report lines against the R3 rule they split, and against physics:
- the buckets add up to R3 exactly (frames, and the frames-weighted mean skate),
- per bucket the triangle inequality holds (|toe| <= |body| + |root| on every frame, so on the means too),
- no body slides faster than the room's own cap (STEP_MPS / 2, read from FightWorldLiveScreen.gd - never typed),
- the test only GAINED lines, none of them a rule, and every RULE line is byte-identical before and after,
- the baseline really is a run without the report (it holds no R3-SOURCE line) and both are real runs.
Never edit this file to pass: fix the test or re-run it.
"""
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
BASE = os.path.join(RESEARCH, "Q99_realism_baseline.txt")
RUN = os.path.join(RESEARCH, "Q99_realism_run.txt")
DIGEST = os.path.join(RESEARCH, "Q99_R3_SOURCES.md")
TEST = "Godot/tests/fight_stage_realism_test.gd"
ROOM = os.path.join(ROOT, "Godot", "scripts", "FightWorldLiveScreen.gd")
BUCKETS = ["join", "take", "walk", "finished"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def read(path):
    if not os.path.exists(path):
        fail("missing %s" % path)
        return ""
    with open(path, encoding="utf-8", errors="replace") as fh:
        return fh.read()


def rule_block(text):
    """Every line of every RULE block (header plus its indented study/real/bound/label/measured lines)."""
    out = []
    keep = False
    for line in text.splitlines():
        if line.startswith("RULE "):
            keep = True
            out.append(line)
            continue
        if keep and re.match(r"^\s+(study|real|bound|label|measured):", line):
            out.append(line)
            continue
        keep = False
    return out


base = read(BASE)
run = read(RUN)
digest = read(DIGEST)

if base and "R3-SOURCE" in base:
    fail("the baseline already holds R3-SOURCE lines - it is not a run of the unedited test")
if run and "R3-SOURCE" not in run:
    fail("the after-run holds no R3-SOURCE line")
for label, text in (("baseline", base), ("run", run)):
    if text and not re.search(r"seed \d+: \d+ frames stepped in \d+ ms", text):
        fail("%s has no 'frames stepped' line - not a real run" % label)
    if text and "SCRIPT ERROR" in text:
        fail("%s has a SCRIPT ERROR" % label)

if base and run:
    rb, rr = rule_block(base), rule_block(run)
    if not rb:
        fail("no RULE lines in the baseline")
    if rb != rr:
        fail("RULE blocks differ between baseline and run (%d v %d lines)" % (len(rb), len(rr)))
        for a, b in zip(rb, rr):
            if a != b:
                print("   baseline: " + a[:160])
                print("   run:      " + b[:160])
                break

# --- R3 itself -------------------------------------------------------------------------------------------------
m = re.search(r"RULE R3 planted_foot_skate.*?measured: mean ([0-9.]+) m/s, p95 ([0-9.]+) m/s over (\d+) planted frames",
              run, re.S)
if not m:
    fail("cannot read R3's measured line in the run")
    r3_mean, r3_frames = None, None
else:
    r3_mean, r3_frames = float(m.group(1)), int(m.group(3))

rows = {}
for line in run.splitlines():
    mm = re.match(r"^R3-SOURCE (\w+) \| (\d+) \| ([0-9.]+) \| ([0-9.]+) \| ([0-9.]+) \| ([0-9.]+) \| ([0-9.]+)\s*$", line)
    if mm:
        rows[mm.group(1)] = dict(frames=int(mm.group(2)), share=float(mm.group(3)), total=float(mm.group(4)),
                                 body=float(mm.group(5)), root=float(mm.group(6)), max_root=float(mm.group(7)))
for b in BUCKETS + ["all"]:
    if b not in rows:
        fail("no R3-SOURCE row for bucket '%s' (format: bucket | frames | share | 4 floats)" % b)

step = None
room = read(ROOM)
sm = re.search(r"const STEP_MPS\s*:?=\s*([0-9.]+)", room)
if sm:
    step = float(sm.group(1))
else:
    fail("cannot read STEP_MPS from FightWorldLiveScreen.gd")

if all(b in rows for b in BUCKETS + ["all"]) and r3_frames is not None:
    n = sum(rows[b]["frames"] for b in BUCKETS)
    if n != rows["all"]["frames"]:
        fail("bucket frames sum to %d, the all row says %d" % (n, rows["all"]["frames"]))
    if rows["all"]["frames"] != r3_frames:
        fail("all frames %d != R3's %d planted frames" % (rows["all"]["frames"], r3_frames))
    share = sum(rows[b]["share"] for b in BUCKETS)
    if abs(share - 1.0) > 0.004:
        fail("shares sum to %.3f" % share)
    if n > 0:
        weighted = sum(rows[b]["frames"] * rows[b]["total"] for b in BUCKETS) / n
        if abs(weighted - rows["all"]["total"]) > 0.002:
            fail("frames-weighted bucket mean %.4f != all mean %.3f" % (weighted, rows["all"]["total"]))
    if abs(rows["all"]["total"] - r3_mean) > 0.0015:
        fail("all mean_total %.3f != R3 mean %.3f" % (rows["all"]["total"], r3_mean))
    for b in BUCKETS + ["all"]:
        r = rows[b]
        if r["frames"] == 0:
            continue
        if r["total"] > r["body"] + r["root"] + 0.002:
            fail("%s: mean total %.3f > body %.3f + root %.3f (triangle inequality)" % (b, r["total"], r["body"], r["root"]))
        if r["body"] > r["total"] + r["root"] + 0.002:
            fail("%s: mean body %.3f > total %.3f + root %.3f (triangle inequality)" % (b, r["body"], r["total"], r["root"]))
        if step is not None and r["max_root"] > step * 0.5 + 0.01:
            fail("%s: a body slid at %.3f m/s, above the room's cap STEP_MPS/2 = %.3f" % (b, r["max_root"], step * 0.5))

role_rows = [l for l in run.splitlines() if l.startswith("R3-SOURCE-ROLE ") and not l.startswith("R3-SOURCE-ROLE bucket")]
by_bucket = {}
for line in role_rows:
    mm = re.match(r"^R3-SOURCE-ROLE (\w+) \| (.+?) \| (\d+) \| ([0-9.]+) \| ([0-9.]+) \| ([0-9.]+)\s*$", line)
    if not mm:
        fail("bad R3-SOURCE-ROLE line: %s" % line[:120])
        continue
    b = mm.group(1)
    if b not in BUCKETS:
        fail("R3-SOURCE-ROLE names unknown bucket %s" % b)
        continue
    by_bucket.setdefault(b, []).append((int(mm.group(3)), float(mm.group(6))))
for b, lst in by_bucket.items():
    if len(lst) > 6:
        fail("%s has %d role rows, the task says top 6" % (b, len(lst)))
    if b in rows and sum(f for f, _ in lst) > rows[b]["frames"]:
        fail("%s role frames exceed the bucket's" % b)
    sums = [s for _, s in lst]
    if sums != sorted(sums, reverse=True):
        fail("%s role rows are not sorted by sum_total descending" % b)

# --- the test only gained lines, and none is a rule --------------------------------------------------------------
try:
    base_commit = subprocess.run(["git", "merge-base", "HEAD", "master"], cwd=ROOT, capture_output=True,
                                 text=True).stdout.strip()
    head = subprocess.run(["git", "rev-parse", "HEAD"], cwd=ROOT, capture_output=True, text=True).stdout.strip()
    diff_args = ["git", "diff", base_commit, "--", TEST]
    if base_commit == head:
        ## On master after the merge the branch point is HEAD itself: judge the Q99 branch's own change, merge^1...merge^2.
        merge = subprocess.run(["git", "log", "--merges", "--format=%H %s", "-n", "200"], cwd=ROOT, capture_output=True,
                               text=True).stdout.splitlines()
        q99 = [l.split()[0] for l in merge if "Merge Q99" in l]
        if q99:
            diff_args = ["git", "diff", "%s^1...%s^2" % (q99[-1], q99[-1]), "--", TEST]
    diff = subprocess.run(diff_args, cwd=ROOT, capture_output=True, text=True).stdout
    removed = [l for l in diff.splitlines() if l.startswith("-") and not l.startswith("---")]
    added = [l for l in diff.splitlines() if l.startswith("+") and not l.startswith("+++")]
    if not added:
        fail("the test has no added lines against %s" % base_commit[:8])
    if removed:
        fail("the test LOST %d line(s) - add only. First: %s" % (len(removed), removed[0][:120]))
    if any("_rule(" in l or '"RULE' in l for l in added):
        fail("an added line creates a rule - report lines only")
except Exception as exc:  # noqa: BLE001
    fail("git diff failed: %s" % exc)

if digest:
    if not digest.lstrip().startswith("## DECISIONS") and "## DECISIONS" not in digest.splitlines()[0:3]:
        fail("the digest does not open with ## DECISIONS")
    if len(digest.splitlines()) > 25:
        fail("the digest is %d lines, 25 at most" % len(digest.splitlines()))

print("Q99_check: %s (%d failure(s))" % ("PASS" if not fails else "FAIL", len(fails)))
sys.exit(0 if not fails else 1)
