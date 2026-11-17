# TASK HEADSPLIT3 - the head-jump ruler counts a combo's next punch as "after a hit", not "before"

Status: OPEN (S509, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
Fight motion week, HEADJUMP1. HEADSPLIT2 (S508, your PR 350, merged S509) gives every head jump a phase: pre / contact /
post / late / none. You found its blind spot yourself: the punch clip cuts soon after contact, so a jump 1..12 frames after
a landed punch is counted `pre` when it falls in her NEXT punch clip (a combo: e.g. who 1 f380 `pro_right_cross_c`, two
frames after her `pro_right_hook` contact at f378). On s506a that is 8 of 41 `pre` punch jumps. S509 showed the remaining
jumps are mostly landed punches at full hold and the frame after the hit, so this split decides what we fix next.

## What to build (extend the HEADSPLIT2 files; keep every existing output line, key and test unchanged)
1. `scripts/rules/HeadSplit.gd` (pure static, ZERO preloads): every jump dict gains `since_prev_hit` (int): frames from that
   boxer's most recent contact start (hold "0" -> "1", same rule as `_contact_offsets`) that happened while she was in a
   PUNCH clip (kind `punch`), counted ACROSS clip changes; -1 when none. A contact start inside a reaction clip (kind
   `react`: the hit boxer's own hold rows) never counts.
2. A new phase word `combo`: a jump whose HEADSPLIT2 phase is `pre` AND whose since_prev_hit is 1..POST_FRAMES becomes
   `combo` instead of `pre`. Every other phase is unchanged. PHASES gains "combo" (by_phase carries six zeroes on an empty film).
3. `tools/head_split_probe.gd`: the HEAD_SPLIT_PHASE line gains ` combo=<n>` right after `pre=<n>` (same prefixes as now).
4. `tests/head_split_test.gd`: new fixture cases (String values as the csv writes them): a hook clip with a contact, then a
   cross clip whose jump 2 frames later is `combo`; the same at 15 frames is `pre`; a contact inside a react clip then a
   punch-clip jump 2 frames later stays `pre`; two boxers interleaved, only one with a previous hit; the empty film reports
   combo=0. Every existing case stays green unchanged except where it reads the whole by_phase dictionary (add combo: 0).

## Contract
OWNS: scripts/rules/HeadSplit.gd, tests/head_split_test.gd, tools/head_split_probe.gd
RED_TEST: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0
REGRESSION: file_limits_test
VISUAL: no - a measuring tool; no game code changes.
NOT YOURS: every other file (the brief too). Never delete or weaken a test. Own branch, commit, push, never merge.
Each file under 500 lines (the test is at 496: first fold the existing fixture rows into compact helpers so the new cases
fit; keep every assertion). Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's
monitors. One test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`.
PR body: `RESULT: tests/head_split_test.gd -> HEAD_SPLIT_TEST failures=0`, `RESULT: tests/file_limits_test.gd -> ...`,
and the probe's output for `-- csv=E:/FightCamp/tmp/fightweek/s508c/shown.csv csv2=E:/FightCamp/tmp/fightweek/s509b/shown.csv`.

## Prior research
`scripts/rules/HeadSplit.gd` (HEADSPLIT1 + 2), your PR 350 body (the blind spot), `tools/fight_motion_rulers.py`
(contacts = hold 0 -> 1), `ops/research/S508_DIGEST.md`, `ops/research/GDSCRIPT_TRAPS.md`.

## What would a human do?
An animator scrubbing a combo says "that pop is the second punch coming off the first hit" - not "before a punch". This
is that note, counted.

## Prefab check
None: our own csv and ruler; nothing to download.
