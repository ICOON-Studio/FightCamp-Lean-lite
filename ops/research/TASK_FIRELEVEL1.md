# TASK FIRELEVEL1 - QWEN (qwen3-coder) - a plan line fires as well as it is drilled: a switched-off rule, measured

Status: OPEN (S425, Claude main). Discipline: boxing. Model: qwen3-coder. Start AFTER READBACK2 is on main (both touch
scripts/state/LiveRound.gd).
Source: measured S425 (tools/pads_for_two_probe.gd): a plan answer she cannot do yet costs 2 to 14 wins in 100, but once
it is usable (mastery 30) more drilling buys almost nothing (combinations at 60 to 70: 1 point). So pad time dies
half-way through a camp. The week design (ops/research/WEEK_DESIGN_V2_S425.md) answers with one rule, and both critics
name it as the rule the whole design depends on: a planned line FIRES more reliably the better it is drilled (usable,
sharp 60, signature 85). This task adds that rule SWITCHED OFF (no bout key = the game exactly as today) and measures it.

## Contract
OWNS: scripts/rules/FireLevel.gd, scripts/state/LiveRound.gd, tests/fire_level_test.gd, tools/fire_level_probe.gd, docs/FIRELEVEL1_RESULT.md
RED_TEST: tests/fire_level_test.gd -> FIRE_LEVEL failures=0
REGRESSION: plan_fight_test, plan_read_test, read_back_test, fight_flow_test, golden_path_test, file_limits_test
VISUAL: no

## The job
1. Read how a planned line is picked and what its mastery gates today: PlanFight.choose / can_do / card_mean, and the
   place in LiveRound where a pick is marked `planned` (near the ReadBack call). Write in the result what you read.
2. New pure module scripts/rules/FireLevel.gd (static, under 100 lines): `share(level_shares, mastery)` -> the share of
   uses on which a planned line counts as planned, by its tier (under 30: as today, it cannot be planned; 30 to 59
   usable; 60 to 84 sharp; 85+ signature); `fires(level_shares, mastery, roll)` -> bool. The bout key `fire_level`
   ({"usable": 0.6, "sharp": 0.8, "signature": 1.0}); absent = 1.0 at every tier = today. A line that does not fire
   falls back to what the bout does today with no planned answer at that moment. One line in LiveRound calls it; LiveRound
   must stay at or under the line count it has when you start (tests/file_limits). The roll comes from the bout's own
   seeded dice so runs stay paired.
3. tests/fire_level_test.gd (pure): no key -> 1.0 at 30, 60, 85; the tiers' edges (29, 30, 59, 60, 84, 85); fires() true
   below the share and false above; print `FIRE_LEVEL failures=<n>`. Red before FireLevel exists.
4. tools/fire_level_probe.gd, 400 paired bouts a cell, Lucy against Maria Ortega with the GOOD plan (as
   tools/read_back_probe.gd sets it up). CONTROL FIRST: no key must give the plain plan's 41.3% to the decimal; if not,
   stop and say so. Then with shares A (0.6 / 0.8 / 1.0) and B (0.5 / 0.75 / 1.0), every plan line's mastery set to 35,
   then 65, then 90 (set the move and combination mastery the plan reads; say which fields); then one line at a time at
   35 with the others at 65. Table: cell -> bouts won.
5. docs/FIRELEVEL1_RESULT.md: the tables, then five sentences: what sharp is worth over usable and signature over sharp
   under A and B; whether the rule makes an UNDRILLED plan worse than today's game by more than 5 points (a risk for new
   players: say so plainly); which single line is worth sharpening most; what you could not measure. Never tune the
   shares to hit a target: report A and B.
   The design keeps the rule if sharp is worth at least 3 points over usable and signature at least 1.5 over sharp.

## Prior research
docs/READBACK1_RESULT.md, tools/pads_for_two_probe.gd (the 1-point finding), ops/research/WEEK_DESIGN_V2_S425.md,
ops/research/GDSCRIPT_TRAPS.md. Trap from S420: a test that can only pass proves nothing; show the red run.

## What would a human do?
A boxer who has drilled a counter a hundred times throws it when the opening comes; one who learned it last week
hesitates half the time. The rule is that hesitation.

## Prefab check
No asset or library applies: one small rule and a measurement on the game's own bout.

Every Godot job through the queue: `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver
Dummy --path . --script res://<file> [-- 400]` (never the _console.exe). Only the tests named here.
RESULT lines for the PR body: `RESULT: tests/fire_level_test.gd -> FIRE_LEVEL failures=0`, one per regression test, and
`RESULT: tools/fire_level_probe.gd -> control <x> A usable <..> sharp <..> signature <..>`.
