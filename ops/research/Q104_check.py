"""Q104 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q104_check.py

Pins Qwen's reaction-direction measurement:
- every seed of the realism population is measured, with a contact count in the range the production probe finds
  (tools/probe_reaction_sync.gd found 387 hand-strike contacts on seed 94301: 300-480 per seed is the same room),
- rows are physical: cos in [-1, 1], head_move_m in [0, 0.6] m, and the pairs are strike -> react_head / react_body,
- a direction is only counted where the head moved: the median head_move_m of every pair with >= 5 rows is >= 0.02 m,
- by_pair medians agree with the rows they summarise (recomputed here, 0.02 tolerance),
- the digest opens with DECISIONS.
Never edit this file to pass. If it cannot pass: no commit, send BLOCKED."""
import json
import os
import statistics
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
R = os.path.join(ROOT, "research")
SEEDS = ["94301", "51227", "77003"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


for name in ("Q104_reaction_direction.json", "Q104_REACTION_DIRECTION.md"):
    if not os.path.exists(os.path.join(R, name)):
        fail("missing research/" + name)
if fails:
    print("Q104_CHECK FAIL %d" % len(fails))
    sys.exit(1)
try:
    d = json.load(open(os.path.join(R, "Q104_reaction_direction.json"), encoding="utf-8"))
except ValueError as err:
    fail("JSON does not parse: %s" % err)
    print("Q104_CHECK FAIL %d" % len(fails))
    sys.exit(1)
for seed in SEEDS:
    n = (d.get("contacts") or {}).get(seed)
    if not isinstance(n, int) or not 300 <= n <= 480:
        fail("seed %s: %r hand-strike contacts - the production probe finds ~387 per seed" % (seed, n))
rows = d.get("rows") or []
if len(rows) < 100:
    fail("only %d rows" % len(rows))
groups = {}
for r in rows:
    try:
        cos = float(r["cos"])
        move = float(r["head_move_m"])
    except (KeyError, TypeError, ValueError):
        fail("row without numeric cos/head_move_m: %r" % r)
        continue
    if not -1.0001 <= cos <= 1.0001:
        fail("cos %r out of [-1, 1]" % cos)
    if not 0.0 <= move <= 0.6:
        fail("head_move_m %r is not a head reacting" % move)
    react = str(r.get("react_take", "")).split("#")[0]
    if react not in ("react_head", "react_body"):
        fail("row reaction %r is not react_head/react_body" % r.get("react_take"))
    groups.setdefault("%s -> %s" % (r.get("role"), react), []).append((cos, move))
by_pair = d.get("by_pair") or {}
for key, vals in groups.items():
    if len(vals) < 5:
        continue
    moves = [v[1] for v in vals]
    if statistics.median(moves) < 0.02:
        fail("%s: median head_move_m %.3f - the head did not move, a direction here is noise" % (key, statistics.median(moves)))
    entry = by_pair.get(key)
    if not entry:
        fail("by_pair has no %s (%d rows)" % (key, len(vals)))
        continue
    cos_med = statistics.median([v[0] for v in vals])
    if abs(float(entry.get("cos_p50", 99)) - cos_med) > 0.02:
        fail("%s: by_pair cos_p50 %r, its rows give %.3f" % (key, entry.get("cos_p50"), cos_med))
    if int(entry.get("n", -1)) != len(vals):
        fail("%s: by_pair n %r, rows %d" % (key, entry.get("n"), len(vals)))
lines = open(os.path.join(R, "Q104_REACTION_DIRECTION.md"), encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 20:
    fail("digest is %d lines, 20 at most" % len(lines))
if fails:
    print("Q104_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q104_CHECK PASS rows=%d" % len(rows))
