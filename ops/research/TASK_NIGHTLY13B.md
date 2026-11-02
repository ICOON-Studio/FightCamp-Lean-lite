# TASK NIGHTLY13B - ROUND 2 of NIGHTLY13 (S285, Claude) - read this first, then the brief below

Round 1 = Arena PR #339, branch `arena/18a3658c-fightcamp-lite`, commit 0d42f3fa (Arena had no Godot; Claude ran it on GitHub
runners, cloud-tests runs 39805081696 / 39805086874 / 39805093191):
- GREEN: mastery_select_wire_test, fight_identity_test, q226_strands_test, equipment_training_rows_test, fightlink_wire_test.
- RED, WORSE than master: camp_pays_test 2/14 -
  `(a) camped jab landed 32.5% [30.8, 34.3] beats uncamped 32.4% [30.8, 34.0], CIs apart (both men, crossover)` and
  `(a) boxer Y's own camp lands his jab more than his own no-camp (33.1% vs 33.5%)`. On master (nightly 10-22) it was 33.4% vs 30.4%.
  So the camp edge is GONE with the round-1 gate. Likely: the camp itself seats attributes on the camped man (or reads fl_stats), so
  `_attr_layer_seated` now switches levers on for one side of the A/B and off for the other - or the camp's own effect flows through
  the levers that the gate now turns off. Find which, with prints, in tools/camppay_measure.gd and FightRealtime `_attr_layer_seated`.
- attribute_wiring_e2e_test: `hang (timeout)` on the runner, but its log was still printing OK lines - it is long (the nightly runs
  with `--timeout 1200`). Run it with `python3 Godot/tools/run_tests.py --only attribute_wiring_e2e_test --jobs 1 --timeout 1200`
  and report its pass line; it must stay green (it proves the levers act in the game).

## Do (round 2)
1. Start from Arena's commit: `git fetch origin arena/18a3658c-fightcamp-lite && git cherry-pick 0d42f3fa` onto your branch
   (origin/master first).
2. Run camp_pays_test on master AND on that commit; find why the camp edge vanished; fix the GAME so the camp edge is back
   (CIs apart, both checks) while the other five stay green. Never re-seed, widen a CI, lower a floor, or delete a check.
3. Run the whole list: camp_pays_test, mastery_select_wire_test, fight_identity_test, q226_strands_test,
   equipment_training_rows_test, fightlink_wire_test, attribute_wiring_e2e_test (`--timeout 1200`), plain arm; then
   attribute_wiring_e2e_test and camp_pays_test with `--as-game`.

---

# TASK NIGHTLY13 - five tests that went red in the 2026-10-21 cloud nightly (d2e7be87), green on 10-20 (bb2108dc)

Model: Qwen (cloud, label qwen) - round 2 after Arena round 1. Discipline: BOXING (demo) - every test below plays the boxing bout or the gym kit.
Still red in the 2026-10-22 nightly (c4dc03a0). FAIL lines from the cloud logs (nightly run 39745719867):

| Test | FAIL line on master |
|---|---|
| camp_pays_test | `(a) camped jab landed 33.4% [31.7, 35.1] beats uncamped 30.4% [28.8, 32.0], CIs apart (both men, crossover)` (1/14) |
| mastery_select_wire_test | `a SIGNATURE jab (M90) is thrown more often than a USABLE one (+2.8% relative, floor 5%)` |
| fight_identity_test | `rivalry heat costs stamina spent per live tick cold 0.00363 hot 0.00356` (1/9) |
| q226_strands_test | `conditioning specialist finishes with more stamina 40-seed paired means cond 90.2 bal 90.4` (1/6) |
| equipment_training_rows_test | `reception_desk has a day-lap row` (EQUIP2B total=3561 fails=1) |

The first four are the SAME shape: a bout lever (camp, mastery, rivalry heat, conditioning) still points the right way but its effect
shrank below the test's floor in one night. One commit between the two nightlies most likely flattened them all.

## Suspects (commits bb2108dc..d2e7be87 that touch the bout)
- d5fe4376 ATTRWIRE1: ko_leverage / damage_mitigation / trauma_threshold reach the bout (`Godot/scripts/FightRealtime.gd` +39,
  `Godot/scripts/rules/FightLink.gd` +64). Prime suspect: a new multiplier that is not 1.0 at neutral attributes, or one that
  scales stamina/landing for BOTH corners and so compresses every A/B gap.
- c68cfd66 FIGHTLINK2B: MoveMastery select_mult at FightMoves.select stage 2 (mastery_select_wire_test was written with it).
- 3791ce96 / c82c2897 rent (should not touch the bout), 31524154 treatment table on fight injuries (after the bout).
- equipment_training_rows: 42710b57 / 3013afbd (GYMBUILD A/B) added `reception_desk` as a buyable item; the test requires every
  item to have a day-lap row - either the item is missing its row in the equipment data, or reception_desk is not training kit and
  the test must exclude non-training furniture by an existing category field (say which field, never a hard-coded name list).

## Do
1. Merge origin/master. Run each test on master and read its FAIL line:
   `godot --headless --path Godot --script tests/<name>.gd` (same as the nightly: plain arm, no user args).
2. Bisect the four bout tests between bb2108dc and d2e7be87 (`git checkout <sha> -- Godot/scripts` in a scratch tree is fine;
   name the commit that turned each red in the PR body).
3. Decide per test: (a) the GAME is wrong - fix the game with the smallest change (a neutral-attribute fighter must play exactly as
   before ATTRWIRE1; the new levers may only move fighters whose attributes are not neutral), or (b) a deliberate, approved change
   moved the effect - then say which commit and why, and keep the test able to read worse (never lower a floor until it cannot fail,
   never delete a check, never wrap a check in a guard).
4. equipment_training_rows: add the missing row or the category exclusion as above.

## Contract
OWNS: Godot/scripts/rules/FightLink.gd, Godot/scripts/FightMoves.gd, Godot/scripts/rules/MoveMastery.gd, Godot/tests/camp_pays_test.gd, Godot/tests/mastery_select_wire_test.gd, Godot/tests/fight_identity_test.gd, Godot/tests/q226_strands_test.gd, Godot/tests/equipment_training_rows_test.gd
OWNS: Godot/scripts/FightRealtime.gd
RED_TEST: Godot/tests/camp_pays_test.gd -> camp_pays_test 14/14
REGRESSION: camp_pays_test, mastery_select_wire_test, fight_identity_test, q226_strands_test, equipment_training_rows_test, attribute_wiring_e2e_test, fightlink_wire_test
VISUAL: no

`FightRealtime.gd` is ~10k lines: grep + `sed -n` windows only, never read whole. If the fix needs an equipment data file
(Godot/assets/data/*.json) say so in the PR body - that file is allowed too.

## Prior research
`research/topics/attributes_skill.md` (attributes in the bout), `research/FIGHTLINK2B_ARENA_REPORT.md` (mastery
select measurements: +5.7% jab share at M90 on an unsaturated plan), TASK_ATTRWIRE1.md, research/GDSCRIPT_TRAPS.md.

## What would a human do?
Run all four bout tests at the commit before and after ATTRWIRE1; if all four flip on the same commit, fix that one commit's
neutral point instead of retuning four tests.

## Prefab check
None - project tests and project bout code.

## The one trap
These are statistical A/B tests: re-seeding until green, widening a CI, or lowering a floor is dodging the instrument. The fix is in
the game unless a commit plus a reason says otherwise.

## Output
PR from qwen/issue-<n> (the workflow pushes; never merge). PR body: one row per test (commit that turned it red, cause a/b,
change, file:line) and these lines, copied from your own run:
`RESULT: tests/camp_pays_test.gd -> camp_pays_test 14/14`
`RESULT: tests/mastery_select_wire_test.gd -> MASTERY_SELECT failures=0`
`RESULT: tests/fight_identity_test.gd -> FIGHT_IDENTITY_TEST checks=9 failures=0`
`RESULT: tests/q226_strands_test.gd -> Q226_STRANDS_TEST checks=6 failures=0`
`RESULT: tests/equipment_training_rows_test.gd -> EQUIP2B total=<n> fails=0`
Plus `attribute_wiring_e2e_test` and `fightlink_wire_test` still green. Zero SCRIPT ERROR lines.
