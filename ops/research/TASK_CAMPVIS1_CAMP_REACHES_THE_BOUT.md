# TASK CAMPVIS1 - the camp reaches the bout the player watches, and the player sees what it bought (design review finding 1, CRITICAL)

Model: Cursor (Godot gameplay scripts) - next on the Cursor seat after CORNER1. Worktree E:/FightCamp/wt/GYM4G, branch cursor/campvis1 from origin/master.
Tier: engine + screens edited -> parse gate + new test + `run_tests.py --only camp --only fight_night --only realtime --only determinism --jobs 2`.

## Prior research
DEMO_DESIGN_REVIEW_S172.md finding 1: "the camp pays nothing visible ... investigate first: is it a display gap or a real disconnect."
S182 INVESTIGATION (Claude, read on the tree at 7b2501c0) - BOTH:
- REAL DISCONNECT: the camp's bout edges live on `athlete["fight_camp_edges"]` (strike_success, defense_bonus, stamina_discount,
  head_damage_taken, composure, duel_drill, opponent_reads, takedown_mult, ...; written GameState.gd ~1480-1936). Only the OLD engine
  reads them (`FightSimulation.gd:1127` copies them to `fighter["camp"]`, used at 1178-1293). The LIVE engine that settles a career bout
  (`FightRealtime.gd`, 8,343 lines) has ZERO reads of "camp" - `grep -n camp scripts/FightRealtime.gd scripts/FightBeatAdapter.gd`
  is empty. The only camp effect reaching it is indirect: opponent_reads + film depth raise the plan-setup `overall` fit
  (GameState.gd 1095-1135 -> FightRealtime `_apply_plan_setup`, line 1742, which sets `ps_contact`, `ps_defence`, `ps_volume`).
- DISPLAY GAP: `get_fight_camp_report` (GameState.gd 1779) is read only by FightCampPanel; fight week, the scorebug and the result
  screen never say what the camp bought; the week review prints "Nobody trained this week" (WeekReviewPanel.gd 939) for a fighter in camp.

## What would a human do?
A camp is why a fighter wins: the commentator says "he drilled the jab all camp and it shows - 40% of them landing". The game must
(a) make the camp change the fight, by a modest bounded amount, and (b) say so at fight week, on the scorebug line and on the result.

## Prefab check
None: it reuses the plan-setup levers the live engine already has.

## Owned files
- `Godot/scripts/FightRealtime.gd` (NEVER read whole: `sed -n 1725,1790p` and `grep -n "ps_contact\|ps_defence\|stamina_scale" `):
  a new option `camp` = `{"a": edges, "b": edges}` applied right after `_apply_plan_setup` by a new `_apply_camp(state, camp)`:
  `ps_contact += CAMP_CONTACT_PER_EDGE * strike_success`, `ps_defence += CAMP_DEFENCE_PER_EDGE * defense_bonus`, stamina drain scaled by
  `1.0 - stamina_discount` (find the drain site with the grep), each named const, each clamped so a full camp moves contact/defence by
  at most the plan-fit edge (PLAN_FIT_EDGE_MAX). Absent option = byte-identical fight (the determinism tests must stay green).
  Behind switch `camp_live` (assets/data switches - copy how an existing switch is read), default OFF until Claude measures it.
- `Godot/scripts/FightNightScreen.gd` (`sed -n 245,275p`): beside the plan_setup entry, pass `camp` from `athlete["fight_camp_edges"]`
  when the switch is ON.
- Fight week / result: the fight-week card and the result screen show up to 2 plain-words lines of what the camp bought, from
  `FightCamp.edge_lines` reworded to whole numbers ("Jab drilled: lands more often", "Gas tank: tires 8% slower") - find the fight-week
  panel with `grep -ln "FIGHT WEEK" Godot/scripts`. Icons with tooltips (UIKit.tip).
- `Godot/scripts/WeekReviewPanel.gd` (`sed -n 925,945p`): a fighter in an active camp counts as trained ("In camp for <opponent>, week N of M").
- NEW `Godot/tests/camp_reaches_bout_test.gd`.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/camp_reaches_bout_test.gd` -> `CAMP REACHES BOUT PASS`, rc 0:
- two DIFFERENT fighters (stats, plan - never identical), 40 seeds each arm: arm CAMP (edges of a full 8-week striking camp) vs arm
  NONE: the camped side's landed% is higher by a bounded amount (> 1 point, < 10 points) and its win share does not exceed 75%.
- no `camp` option -> the log is identical to today's for 3 fixed seeds (hash compare).
- the week review read for an in-camp fighter is not the "Nobody trained" line.
- MUTANT: drop the `_apply_camp` call -> red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py` on every touched .gd.

## The one trap
FightRealtime.gd and GameState.gd are never read whole - windows and greps only. A new key on the fighter dict can break byte-identity
even at zero (S141 lesson): set the keys ONLY when the option is present. Headless Godot ONLY with
`Godot_v4.7.2-stable_win64.exe --headless` (never `_console.exe`). Open no windows. Commit with `git add -- <paths>`, push, stop.
