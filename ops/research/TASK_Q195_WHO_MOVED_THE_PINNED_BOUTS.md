# TASK Q195 - WHO MOVED THE PINNED BOUTS?
Owner: qwen. Assigned 2026-09-27 (S93). Model: qwen3-coder, medium effort (the qwen_task.cmd pin).
Branch: `qwen/q195-pin-drift` from `origin/master` (e6690fe8 or later), worktree `Temp/FightCamp-Q164`.

## Why
Three tests that passed in the nightly at `9847dd13` now fail on master (Claude re-ran them S93 on master AND with
Q194 applied - same three fails both ways, so Q194 is cleared):
- `judge_panel_test.gd` - T4/T8R: nine pinned seeded bouts across four rulesets no longer score as S2 re-pinned them
  (boxing_11, boxing_7, boxing_9, boxing_20, mma_11, mma_5, kickboxing_13/14/186/19, muay_thai_17 all moved);
  T11: kickboxing seed 40 is no longer a SPLIT and boxing seed 677 no longer a MAJORITY.
- `fight_realtime_test.gd` - rc=1.
- `grapple_adapter_test.gd` - rc=1.
Pinned bouts only move when the engine's behaviour or its RNG draw order changes. Some commit between `9847dd13` and
`e6690fe8` did that without re-pinning. Candidates touching the engine (from `git log 9847dd13..HEAD -- Godot/scripts/Fight*.gd`):
792e84e4 Q192, 02bd2b9f U183, c0e49849 S88/U182+Q190, 18f5ab30 S87, 7849fed6 Q189 sharp_edge, 8cbf4c1a/f312c42a Q188
spar intensity, fdda6144/14c1955f Q186 KB head damage, 42eee748 U178B, 527486ff U178 re-merge.

## What would a human do?
A QA engineer handed "the regression tests went red overnight" bisects: find the first commit that turns them red,
read that commit's intent, and decide - was the drift the INTENDED effect of that change (then the pins are re-pinned
with the commit named as the reason, and the other anchors that change was meant to keep are checked), or a side
effect nobody meant (then it is a defect and the change is scoped so the pinned rulesets are untouched, as Q194 did
for plan roles)? They never re-pin blind to make the board green.

## Do
1. `git bisect` between `9847dd13` (good) and `e6690fe8` (bad) using ONLY `judge_panel_test.gd` as the probe
   (one Godot boot per step, ~7 steps). Then confirm `fight_realtime_test` and `grapple_adapter_test` go red at the
   SAME commit (if not, bisect each separately).
2. Read the first-bad commit's digest (`research/<ID>_DIGEST.md`) and say what it meant to change.
3. Decide per test: INTENDED drift -> re-pin, naming the commit in the test comment; UNINTENDED -> fix the scope
   (e.g. a mode flag that leaked into default bouts, an extra RNG draw on a path the default bout takes).
   Q188 spar intensity and Q189 sharp_edge are MODES - a default bout must be byte-identical with the mode off.
4. For any re-pin: the T11 split/majority must be re-FOUND by a sweep (as Q170 did), never tuned back.

## Owned files
The three tests, the first-bad commit's own files ONLY where the fix is a scope fix, `Godot/tools/q195_*.gd`,
`research/Q195_DIGEST.md`. `FightRealtime.gd` is ~14k lines - never open it whole; `grep -n` then `sed -n` windows.

## Gate (a CEILING - better is welcome, say so)
- The first-bad commit named, with the bisect log in the digest.
- `python Godot/tools/run_tests.py --jobs 2 --only judge_panel,fight_realtime,grapple_adapter` -> 3 pass, OR each
  remaining red explained with the evidence.
- If a scope fix touches the engine: run `--only fight_,judge,broadcast,knockdown,grapple` on master AND branch and
  print both SUITE lines; no test green on master may go red on the branch.
- Population named in every measurement output (the fighters and rulesets the pinned bouts use).

## Deliver
Commit with explicit paths, push `qwen/q195-pin-drift`, write the digest, one line with
`python Tools/agent_comms.py send --agent qwen ...`. Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** `git bisect` in a worktree moves HEAD - run `git bisect reset` before you commit, and never bisect in the
shared checkout. Also: Q194's worktree run showed EVERY fight test failing on master due to a stale worktree - pull
master into your worktree first and prove `broadcast_read_test` passes before you trust any red.
