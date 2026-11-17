# TASK HEADSPLIT1 - a ruler that splits each head jump into what moved it, and compares two films fairly

Status: OPEN (S507, Claude main). Discipline: boxing. Model: Qwen (qwen4-max), default.

## Why now
Fight motion week, HEADJUMP1. S506 read "head jumps 77 -> 91" between two films and blamed the new layers. S507 found the
two films play the same clips frame for frame only until ~48 s of film time, then the bout drifts (one frame late, then
different punches): the 14 extra jumps were mostly a different bout. Counted per punch clip and per reaction clip the
real changes are small (punch 0.132 -> 0.168 jumps a punch clip, reaction 0.94 -> 1.06). Every film comparison from now
on needs: (1) the rate per clip kind, (2) the jumps inside the part both films share, (3) for each jump, which part of
the body moved the head (the root sliding, the hips on the root, the trunk bending, the neck/head on the chest).

## What to build
1. `scripts/rules/HeadSplit.gd` (new, pure static, ZERO preloads). `analyse(rows: Array) -> Dictionary` over shown.csv
   rows (Strings; columns `frame`, `film_s`, `who`, `clip`, `clip_t`, and `<Bone>_x/_y/_z` world metres for `node`,
   `Hips`, `UpperChest`, `Head`). Rows of both boxers are interleaved per frame: group by `who`, sort by `frame`, and
   only pair rows whose frames are consecutive (frame b = frame a + 1).
2. A JUMP: the head's world travel between two consecutive rows of one boxer is over JUMP_CM = 12.0. Per jump:
   `head_cm`; `root_cm` = |node(b) - node(a)|; `hips_cm` = |(Hips - node)(b) - (Hips - node)(a)|;
   `trunk_cm` = |(UpperChest - Hips)(b) - (UpperChest - Hips)(a)|; `neck_cm` = |(Head - UpperChest)(b) - (Head - UpperChest)(a)|
   (all cm); `kind` of row b's clip: `react` when the clip starts with `pro_hit`, `react_` or `mc_hit`; else `punch` when
   it contains jab / cross / hook / uppercut / body_shot / kidney; else `other`; `cause`: `change` when the clip of row
   a differs from row b, else `inside`; `film_s`, `who`, `clip`.
3. Clip counts: per boxer, every time the clip differs from that boxer's previous row is one clip start; count starts by
   kind (`react` / `punch` / `other`, same rule).
4. Summary: `jumps`, `by_kind` {kind: jumps}, `starts` {kind: clip starts}, `per_punch` = punch jumps / punch starts,
   `per_react` = react jumps / react starts (0.0 when no starts), the medians `root_p50`, `hips_p50`, `trunk_p50`,
   `neck_p50`, and `worst`: the 5 biggest jumps (film_s, who, clip, head_cm, root_cm, hips_cm, trunk_cm, neck_cm).
5. `shared_until(rows_a: Array, rows_b: Array) -> int`: the clip-start sequences of both films (per boxer, as in 3, each
   start = (frame, who, clip), in frame order, both boxers merged and ordered by frame then who) compared element by
   element; returns the `frame` of the first start that differs (the earlier of the two), or the last frame of the shorter
   film when one sequence is a prefix of the other. `analyse(rows, until_frame)` with a second optional argument counts
   only jumps and starts whose row b frame is < until_frame (default: no limit).
6. `tools/head_split_probe.gd -- csv=<a> [csv2=<b>]`: with one csv, one line per worst jump then the last line exactly
   `HEAD_SPLIT jumps=<n> punch=<p> react=<r> other=<o> per_punch=<x.xxx> per_react=<y.yyy> root=<a.a> hips=<b.b> trunk=<c.c> neck=<d.d>`.
   With two: first `HEAD_SPLIT_SHARED until=<frame>`, then for each film the HEAD_SPLIT line of the shared part prefixed
   `A ` / `B `, then the whole-film HEAD_SPLIT lines prefixed `A_ALL ` / `B_ALL `.
7. `tests/head_split_test.gd`: fixtures built in code (String values, as the csv writes them): a head that moves 15 cm in
   one frame with the root still (trunk + neck carry it); a head that moves 15 cm because the root slid 15 cm (root_cm 15,
   trunk/neck ~0); a 10 cm move (not a jump); a jump across a clip change (cause change); a frame gap (frames 10 -> 12:
   never a jump); both boxers interleaved; a react, a punch and an other clip; two films identical for 5 starts then
   different (shared_until = the 6th start's frame) and `analyse(rows, until)` counting only before it; an empty input.
   Print `HEAD_SPLIT_TEST failures=<n>`; quit(1) on failures.

## Contract
OWNS: scripts/rules/HeadSplit.gd, tests/head_split_test.gd, tools/head_split_probe.gd
RED_TEST: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines. Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's output for `-- csv=E:/FightCamp/tmp/fightweek/s505b/shown.csv csv2=E:/FightCamp/tmp/fightweek/s506a/shown.csv`.
Expected roughly (S507 hand count, Python): s505b 77 jumps (punch 40, react 34, other 3; 302 punch / 36 react starts),
s506a 91 (punch 50, react 38, other 3; 298 / 36); the films share their clip starts until about frame 1434.

## Prior research
`scripts/rules/HookPast.gd` and `scripts/rules/PunchEnd.gd` (csv rows, runs per who), `tools/fight_motion_rulers.py`
(JUMP_M 0.12, the same kind words), `ops/research/S506_DIGEST.md`. `ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
An animator scrubbing a pop asks "what moved": the whole man, his hips, his back, or his neck - and only compares two
takes over the part where both men do the same thing.

## Prefab check
None: loops over csv rows like HookPast.

## The one trap
Both boxers are interleaved per frame - pair rows per `who`, never across boxers. Csv values are Strings - `float()` each.
