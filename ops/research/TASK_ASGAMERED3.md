# TASK ASGAMERED3 - three fight-wiring tests red in their `-- as_game` arm on master

Model: Cursor (cloud). Discipline: BOXING (demo) - the bout and what training feeds into it.
Same job as ASGAMERED1/2 (read `git show 4f52e822 -- Godot/tests` for the pattern), three fight tests.
`FightRealtime.gd` (~10,270 lines) and `GameState.gd` are shared: grep + `sed -n` windows only, never read them whole.
S277 just landed ATTRWIRE1 (d5fe4376): the bout's force reads ko_leverage (power .70 + technique .30), damage taken reads
damage_mitigation, knockdowns read trauma_threshold (rules/FightLink.gd attr_mult / ko_leverage_power) - read that diff first.

## The three (each passes plain, fails with `-- as_game` on master - also BEFORE d5fe4376, so not caused by it)
attribute_wire_test, mastery_wire_test, bout_wear_wire_test.
Run one: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/<name>.gd -- as_game`.

## Likely causes (verify each - do not assume)
The game arm turns on the S268-S277 switches (GameSwitches.GAME_ON): clips-only fight base, rokoko/mocap clips, stripped_start (a new
career's gym is EMPTY: no zones, no ring until bought - `career["club_ring_owned"] = false`; S277 also makes the money model read only
what is built), training_rotation, no_interrupts. A test that builds a career and expects stations, a ring, a coach or a starter
roster may need the built-gym fixture (`career.erase("club_zones_placed")`, `erase("club_zone_store")`, `erase("club_ring_owned")`,
`erase("club_rooms_built")`, then `GymClubLayout.reload()`), or the GAME may be wrong - decide per check.

## Do
1. For each test: run it as_game on master, copy its FAIL lines into the PR body, decide (a) the GAME is wrong (fix the code) or
   (b) the test pins a design the operator replaced (name the switch + the ruling quoted in GameSwitches.gd) - port the as_game arm.
   Never delete a check, never loosen a bound; a check with no new-design equivalent moves to the plain arm with a comment.
2. All three green plain AND as_game; regression set green both arms.

## Contract
OWNS: Godot/tests/attribute_wire_test.gd, Godot/tests/mastery_wire_test.gd, Godot/tests/bout_wear_wire_test.gd
RED_TEST: Godot/tests/attribute_wire_test.gd -> as_game arm green
REGRESSION: fightlink_wire_test, attribute_wiring_e2e_test
VISUAL: no

## Prior research
TASK_ATTRWIRE1.md + d5fe4376; TASK_ASGAMERED1.md / 4f52e822; GDSCRIPT_TRAPS.md.

## What would a human do?
Sort "the game broke" from "the test checks the old setup", fix the first, port the second with the ruling cited.

## Prefab check
None - project tests.

## The one trap
Agents have loosened checks to go green before. The PR body lists every changed assertion, old vs new, with the switch/ruling.

## Output
PR from cursor/issue-<n> with `RESULT: tests/<x>_test.gd -> <pass line>` for each (plain + as_game) and the regression set.
