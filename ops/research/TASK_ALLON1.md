# TASK ALLON1 (S222) - a 16-week career with EVERY game mechanic switched ON must run clean (headless soak test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests (no models, no .glb/.fbx, no fight scenes). Do not delete or shorten any existing test.
Operator (S222, verbatim): "we need a playable version soon with all mechanics on". Operator (S221): "everything new built i want it
defualted to on" - every built feature is in `GameSwitches.GAME_ON` (Godot/scripts/GameSwitches.gd, ~70 lines).

## Why
Plain `--script` tests run with the switches OFF (the control arm). Nobody has run a long career with ALL of them ON together - the
game the player gets. This test is that run: it must catch a mechanic that errors, stalls the week, or drives money/state to nonsense
when combined with the others.

## Prior research
- `Godot/tests/career_loop_walk_test.gd` (154 lines) - begin/finalize a career, read roster, offers, weigh-in, `advance_week()`.
- `Godot/tests/first_fight_for_every_fighter_test.gd` - sign a fighter, tick weeks, `book_fight(fighter_id, offer_id)`.
- `Godot/tests/playable_loop_test.gd` - how a booked bout is got past (`_play_second_bout`) - copy the NON-visual way it resolves.
- `Godot/scripts/GameSwitches.gd` `on(name)`: a key present in `GameState.career` overrides everything - that is how a test turns a
  switch ON (`gs.career[name] = true`), the same way `first_fight_for_every_fighter_test.gd` sets `club_show_novices`.

## What would a human do?
A QA lead plays four months of a career on the shipping build and watches for errors, a stuck week, cash going NaN, a fighter in two
places, an event that never fires.

## Prefab check
None needed - GDScript test in the repo's own pattern (`extends SceneTree`, `_check`, `quit(1)` on any failure).

## Owned files
- NEW `Godot/tests/all_mechanics_on_soak_test.gd` (the test).
- If - and only if - the test exposes a REAL defect: the smallest fix in the script that causes it, named in the PR body with the
  failing line it fixed. Never weaken, skip or loosen a check to go green. `Godot/scripts/GameState.gd` is 20,000+ lines: NEVER
  read it whole - grep for the function and read +-40 lines.

## Do
1. Two arms, two DIFFERENT gyms and rosters (house rule: never test identical fighters): arm A = story start
   (`begin_new_career(1)` + `generate_starter_boxing_floor` + `finalize_new_career("Cyprus","Nicosia",...)`), arm B = a sandbox start
   in another city with the story switched off the way `GameState` reads it (grep `is_story_campaign_on`). Print the population
   (gym, city, roster names + stats) in the output.
2. After finalize: for every key of `GameSwitches.GAME_ON` set `gs.career[key] = true`; check `GameSwitches.on(key)` reads true for each.
3. 16 weekly ticks per arm. Each week: book one spar (`book_spar`) when two roster members exist; from week 2 book one bout from
   `get_fight_offers()` / amateur bouts for a fighter with none booked (`book_fight`); get past a due bout the way playable_loop does;
   resolve any blocking decision the week loop returns (debt decision, floor event `resolve_floor_event`) with its FIRST option and log it.
4. Checks every week: `advance_week()` advanced the week counter (or returned a named blocker that step 3 then resolved, and the next
   call advanced it - no week may stay stuck twice); cash is finite (not NaN/INF); every roster fighter id is unique; every booked bout's
   opponent is a different person and the same sex; no fighter is booked twice on the same day.
5. Checks at the end: at least 1 bout was fought per arm; at least 4 spars ran; the save round-trips (`save_current_career()` then
   load it back, week + cash + roster size equal).
6. Print `ALLON1 arm=<A|B> weeks=16 bouts=<n> spars=<n> blockers=<list> cash_start=<x> cash_end=<y>` and `ALLON1 PASS checks=<n>`.

## Acceptance
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/all_mechanics_on_soak_test.gd` exits 0, prints `ALLON1 PASS`,
no `SCRIPT ERROR`. Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`. CI on your branch green.

## The one trap
`advance_week()` can return early on purpose (a booked fight due, a blocking decision) - that is not a stall. A stall is the SAME
blocker twice after you resolved it. Do not "fix" a by-design early return.
