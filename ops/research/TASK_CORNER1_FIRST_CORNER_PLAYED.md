# TASK CORNER1 - the first corner is played, the plan is the default order, SIM TO RESULT asks once (design review finding 2)

Model: Cursor (Godot gameplay/UI scripts). Worktree E:/FightCamp/wt/GYM4G (has the Godot import cache), branch cursor/corner1 from origin/master.
Tier: scripts edited + new test -> parse gate + the new test + `run_tests.py --only corner --only fight_night --only scorebug --jobs 2`.

## Prior research
`python Tools/prior_research.py first corner tutorial bell` -> topics/plans_corner.md, J52 (tutorials teach by doing the first one with
you). DEMO_DESIGN_REVIEW_S172.md finding 2: "the corner is optional and silent. The heart of the game can be skipped without a word. Fix
for the demo: the FIRST fight always stops at the first bell for one corner card (tutorial), the camp's plan is the default instruction
(no more 'NO INSTRUCTION' after a camp), and SIM TO RESULT asks once ('skip the corner?')."
Already built (do not rebuild): S159 CORNER2 `corner_holds_clock()` holds the clock while the WIRED pit-stop card is open
(FightWorldLiveScreen.gd ~5299); the plain `CornerPanel` opens at every break (`_update_corner_panel`, ~5306) but does NOT hold the clock.

## What would a human do?
A coach's first fight with a new fighter: the coach always talks at the first bell. And a fighter goes out with the camp's plan -
nobody walks out with "no instruction".

## Prefab check
None: three behaviour changes in existing screens.

## Owned files
- `Godot/scripts/FightWorldLiveScreen.gd` (6,144 lines - read ONLY `sed -n 5290,5345p`, `sed -n 5165,5180p`, `sed -n 5495,5510p`, `sed -n 5581,5592p`, `sed -n 4896,4930p`):
  1. `corner_holds_clock()` ALSO returns true while the plain `_corner_panel` is visible and not yet sent/skipped, when this is the
     player's FIRST career bout (`first_bout` flag set by whoever starts the bout - add `var first_bout := false` + a setter; the fight
     screen sets it from GameState: the player's fighter has 0 bouts in both `record` and `amateur_record`). Only round 1's break.
  2. The order shown on the scorebug before any corner call: the player's fight plan name (`_fighter("a")` carries the plan id; name via
     `FightPlans.plan_by_id(id)` - read FightPlans for the name key), as "PLAN: <NAME>"; "NO INSTRUCTION" only when there is no plan.
  3. `sim_to_result()` unchanged; add `sim_needs_confirm() -> bool` = not yet confirmed this bout.
- `Godot/scripts/FightNightScreen.gd` (1,762 lines, `sed -n 990,1015p`): SIM TO RESULT, on the first press of the bout, shows a small
  confirm ("Skip the corner? The engine decides the rest." with SKIP / KEEP WATCHING buttons, UIKit styles, icons with tooltips per the
  glossary) instead of simming; SKIP sims, KEEP WATCHING closes. Set `first_bout` on the arena from GameState when the bout starts (find
  where `_arena` is set up in this file).
- `Godot/scripts/CornerPanel.gd` (284 lines): on the first-bout hold, a one-line caption above the options: "Your first corner. Pick one
  call - he goes out with it." Nothing else changes.
- NEW `Godot/tests/first_corner_test.gd`.

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/first_corner_test.gd` -> `FIRST CORNER PASS`, rc 0:
- a live screen with `first_bout = true` pumped to the end of round 1: `corner_holds_clock()` is true and the engine clock does NOT advance
  over 3 s of pumping; after the corner's instruction is applied (or skipped) it is false and the clock moves. Copy the screen setup of an
  existing corner test (`ls Godot/tests | grep corner` - e.g. the CORNER2 wired test) rather than inventing one.
- the same with `first_bout = false`: no hold at the plain card (today's behaviour).
- before any call the scorebug order reads "PLAN: " + the plan's name; after a call it reads the call's label.
- FightNightScreen: first SIM TO RESULT press -> confirm visible, bout NOT finished; KEEP WATCHING -> confirm gone, still running; SKIP
  -> bout finished.
- MUTANT: make `corner_holds_clock()` ignore `first_bout` -> the test goes red. Say in the commit that you ran it.
Parse gate first: `python Godot/tools/check_scripts.py scripts/FightWorldLiveScreen.gd scripts/FightNightScreen.gd scripts/CornerPanel.gd tests/first_corner_test.gd`.

## The one trap
FightWorldLiveScreen.gd, FightRealtime.gd and GameState.gd are never read whole - windows only. Headless Godot ONLY with
`Godot_v4.7.2-stable_win64.exe --headless` (never `_console.exe`). Open no images, browsers or windows. Commit with
`git add -- <paths>`, push your branch, stop. Claude reviews and merges.
