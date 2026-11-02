# TASK NIGHTLY10 - 13 tests newly red in the first cloud nightly: find which commit broke each, fix the cause (S264, Cursor)

Seat: Cursor (cloud agent on a GitHub runner via issue label `cursor`; S264: the Grok Bot app timed out). Model: Cursor default. Discipline: BOXING (demo) - anything that turns
out MMA-only (a kick, a takedown, a ground strike) you skip with one line in the PR. One branch + PR per test:
`cursor/nightly10-<test stem>`, PR to master; Claude merges by diff. Same method as NIGHTLY8/NIGHTLY9.

## The reds
Nightly 2026-10-19 @61ca511a (GitHub runners, 16 shards: SUITE total=943 fails=17) vs the last full night 2026-10-17 @5b92bef2
(885/16). NEWLY red (13), each with the failing line from its shard log:
1. `composure_live_test.gd` - FAIL OFF byte-identical to master log hash
2. `doctor_live_test.gd` - FAIL: master log hash seed 1/2/3/8 (8 failures)
3. `pad_chain_fight_test.gd` - FAIL switch OFF byte-identical to master round log
4. `fight_strike_whole_test.gd` - hang; before it: FAIL OFF boxing events and verdict byte-identical to baseline, FAIL R16 ON boxing
   hashes the S159 R16 pin
5. `human2_test.gd` - FAIL a/b OFF equals recorded master pose digest
6. `switch_gate_hold_pair_geometry_test.gd` - FAIL hold_pair_geometry: relative-place error p90 ON 2.502 < OFF 2.365
7. `q226_strands_test.gd` - FAIL technique specialist paired CI lower bound clears the real floor (diff 1.37 pp [0.33, 2.42], floor 0.50)
8. `rig_convention_contract_test.gd` - FAIL bound RamsterZ posed bones byte-identical (import_fighter_clip.gd:142 - may be an LFS
   asset missing on the runner: if so, one PR comment line and skip)
9. `mixamo_s215_test.gd` - FAIL catalogue has 121 rows, got 115 (+ batch 2 categories corner_rest / count_stand missing)
10-13. hangs (timeout): `fight_strike_speed_test.gd` (_run_room_take4 :173), `first_corner_test.gd` (_scorebug_plan_and_call :132),
   `fight_grapple_seam_test.gd` (_test_ground_strike :242 - ground strike = MMA: check, likely skip), `fight_room_positions_test.gd`
   (_room :164). Run each alone with a 900 s timeout first - if it completes green alone, it is a runner-speed hang: say so and skip.

THE COMMON CAUSE TO CHECK FIRST (1-5): an "OFF byte-identical" pin goes red when a change leaks into the switch-OFF path. Between the
two nights 82 commits touched Godot/scripts (`git log --oneline 5b92bef2..61ca511a -- Godot/scripts`), among them: S258 single root
solver 8f6ba01f, S259 punch_retime 9db6c74b, S260 attributes in the bout 9d79a7bf/3e6c4521/2375713d/72e4897a/e948b77c, S255 punch
timing af5a68e3/335ed9d3, S253-S251 FIGHTLINK (bout_wear f3ddb4c5, corner_shouts 8b4e5a10, sharpness b0cd1daf), S256 counter window
19664ddd. Bisect each pin to the commit that moved it (`git bisect run` with the test alone).
- If the commit's change runs while its switch is OFF -> that is the DEFECT: gate it behind its switch (GameSwitches.on("<name>")), so
  the OFF arm is byte-identical again. This is the preferred fix.
- If the commit deliberately changed shared, always-on behaviour that an operator ruling approved (name the commit + the ruling quote
  from its message), the pin is genuinely stale: re-record ONLY that pin, flag it at the top of the PR. Never re-pin without the bisect.

## Do, per test
1. Run it alone on master: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd` - paste its FAIL line.
2. Bisect to the breaking commit; name it in the PR.
3. Fix the GAME (gate the leak) or, per the rule above only, re-pin. Never delete, skip or weaken an assertion.
4. Green: the test alone prints its pass line; parse gate `python Godot/tools/check_scripts.py <touched .gd>`; plus
   `python Godot/tools/run_tests.py --only <the touched system's test names> --jobs 2` unchanged-or-better vs master.
5. PR body: `RESULT: tests/<name>.gd -> <exact pass line>` and `BROKEN BY: <sha> <subject>`.

## Contract
OWNS: Godot/scripts/FightStagePlayer.gd, Godot/scripts/FightRealtime.gd, Godot/scripts/rules/Attributes.gd, Godot/scripts/FightWorldLiveScreen.gd, Godot/scripts/animation/PunchRetime.gd
OWNS: Godot/tests/composure_live_test.gd, Godot/tests/doctor_live_test.gd, Godot/tests/pad_chain_fight_test.gd, Godot/tests/human2_test.gd
RED_TEST: tests/composure_live_test.gd -> COMPOSURE_LIVE checks=268 failures=0
REGRESSION: composure_live_test, doctor_live_test, pad_chain_fight_test, fight_strike_whole_test, human2_test
VISUAL: no

## VISUAL GATE
Not a visual task: the fixes restore the OFF control arm's pins; no body/animation/look change ships. If a fix changes what the ON
game shows (pose digest of the ON arm), stop and say so in the PR - Claude takes it through .claude/skills/visual-gate.

## Rules
research/GDSCRIPT_TRAPS.md. GameState.gd, GymHall3D.gd, FightRealtime.gd are huge - grep + sed -n windows, never whole.
New features ship ON (GameSwitches.GAME_ON); plain --script tests are the OFF control arm. Never test identical fighters.
THE ONE TRAP: never delete or weaken a test to go green - a red test that is right stays red and you report it.

## Prior research
roadmap NIGHTLY1 row, TASK_NIGHTLY8.md, S258_DIGEST.md (root solver), S259/S260 digests (punch_retime, attributes),
AgentComms/nightly/latest.txt, AgentComms/nightly/revert_2026-10-19.log (the 13 listed as newly red).

## What would a human do?
Bisect each red to its commit, put the leaked change back behind its switch, prove it with the test alone, small PRs.

## Prefab check
None - regressions in our own code.
