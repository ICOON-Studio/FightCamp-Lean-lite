# TASK FIGHTERMODEL4H - CURSOR (Grok 4.7 High) - the camp's three levels mean something again on the new fighter model

Status: OPEN (S413, Claude main; the same brief as FIGHTERMODEL4G, cut off by the PC restart). Discipline: boxing. Model: grok-4.7-high.
FIRST: merge origin/main into this branch.
Start every Godot run through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`.

## Contract
BASE: cursor/fightermodel4f
OWNS: scripts/rules/BoutRules.gd, scripts/state/CampForecast.gd, scripts/rules/WeekPlan.gd
RED_TEST: tests/camp_protocol_test.gd -> CAMP_PROTOCOL failures=0
REGRESSION: plan_bots_test, bout_read_test, golden_path_test, week_read_test
VISUAL: no

## Prior research
PR 124's body (FIGHTERMODEL4F) has the numbers. ops/research/TASK_FIGHTERMODEL4F.md. Main is green on this test, so the new fighter model moved it. ops/research/GDSCRIPT_TRAPS.md. scripts/rules/BoutRules.gd holds PROTOCOLS and the comment on why the drill is per night.

## What would a human do?
Ask a coach: does a harder camp teach more than a normal one, and a normal one more than an easy one? Is a hard camp more dangerous? If the answer on paper is no, find out why before touching a number.

## Prefab check
Nothing to find. tests/camp_protocol_test.gd prints a line per camp: start from it.

## The job
PR 124's run left two checks red, on a 25-day technique camp:
1. Technique gain: Light +2.14, Standard +1.65, Hard +2.52. The bar is Hard over Standard and Standard over Light by at least 0.025 per day each. Hard minus Standard clears it. Standard minus Light is -0.48. Light's plain pad work trains technique at a 0.20 share and Standard's drill share is 0.115, which may be the cause: confirm it by reading the code, then say so.
2. Injury: Hard 3.2%, Standard 2.7%, bar Hard above 1.5x Standard for a power camp. Peaks were 61.2 and 56.1, under the fatigue line of 72. The PR's seat says recovery sits about five above conditioning and clears fatigue faster.
For each: is the game wrong, or is the check reading something that no longer means the same? Write that down first, in the PR body. Then fix the game. The levels have to differ in the way the player is told: harder means more gain, more tiredness, more risk.

Do not change a bar or a number inside tests/camp_protocol_test.gd. If you are sure a bar is measuring the wrong thing, leave it red and say why in the PR body.

## The one trap
Raising Standard's drill share until the check passes moves every camp's gains and the plan bots' balance. Run plan_bots_test and bout_read_test after any number change and name what moved. Seeded world results must not change unless you say why.

## Result lines (PR body)
RESULT: tests/camp_protocol_test.gd -> CAMP_PROTOCOL failures=0
