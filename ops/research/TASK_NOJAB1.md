# TASK NOJAB1 (S219) - boxers never throw the jab to the head

Model: cloud Codex (label `codex`). Branch `codex/issue-<n>` from master. Never master. Open a PR. No LFS assets in CI: work with
the pure simulation (FightRealtime / FightMoves), never the 3D room.

## Primary source (Claude S219)
A probe (`Godot/tools/probe_pair_beats.gd`, the live room's default bout, first 120 s) listed every action beat on 4 seeds
(810039, 12345, 777001, 424242): 58-86 actions per seed and **0 `boxing_jab`** on every seed. Thrown instead: boxing_step_in_out,
boxing_circle_lead, boxing_cross / cross_body, boxing_rear_hook, boxing_slip_counter, boxing_one_two(_hook), boxing_catch_counter,
a few boxing_jab_body. The jab is in the certified palette (`certified_moves.json`) and in technique_catalog.json. In real boxing
the jab is the most thrown punch (CompuBox averages: jabs ~40-50% of punches thrown). A fight with no jab is a realism defect, and
it is why `fight_pair_live_test` has been red since at least 2026-10-02 (its authored pair plays on a landed head jab; there is none).

## What would a human do?
Trace one decision: pick a fighter in a seeded bout, log the selection stage by stage (role pick -> live move set for that role ->
technique+region weights) for the "jab" role, and find where boxing_jab drops out or gets weight 0 (candidates: FightMoves
`moves_for` line 948 and the two-stage selection ~line 530-600; `jab_usage_mult`; the certified-palette restriction
`FightMoves.restrict_to_certified`; technique mastery / TECHSTAGE / training strands; the role mapping that may file boxing_jab
under a role the plans never weight; step_in_out / circle_lead taking the jab role's whole share).

## Do
1. Reproduce headless with the pure sim (no room): 20 seeds, the default fixture pair + 2 career-generated boxers + 2 women
   (different stats, styles - never identical fighters), both with game switches OFF and with FightRealtime.DEMO_SWITCHES ON.
   Print per bout: actions, boxing_jab count, jab share of strikes, head jab share. Paste the RED numbers (0 jabs) before any fix.
2. Find the cause, fix it in the right place (no special-casing of the test). Keep every other technique selectable.
3. New test `Godot/tests/jab_share_test.gd` (prints JAB_SHARE_TEST PASS): over the 20 seeds x both switch arms, the jab (head +
   body) is 25-55% of thrown strikes and the head jab >= 15%; every bout has >= 1 head jab in its first 120 s; a control arm with the
   jab role weight forced to 0 must read red (proves the instrument). Bound values, never exact counts.
4. Run the dependents headless that do not need LFS: `python Godot/tools/run_tests.py --jobs 2 --only fight_moves,selection,
   certified,technique,plan,q226,boxing_output,role` (parse gate first: `python Godot/tools/check_scripts.py <touched .gd>`).
   Claude runs fight_pair_live (needs the meshes) on the PC after the merge.

## VISUAL GATE
Not a visual task (selection logic). Claude checks the live fight on the game camera after the merge.

## Prior research
Q113/Q194 (two-stage role selection), D27 (certified palette), Q226 (technique strands), BOXING_OUTPUT notes in FightRealtime.

## Prefab check
None - our own engine.

## The one trap
Do not just multiply the jab weight up until the test passes: find why it is zero. If a design rule removed it on purpose, report the
rule and the commit instead of reverting it.
