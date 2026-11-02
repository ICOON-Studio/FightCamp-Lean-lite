# TASK PROFILE2B - the full fighter profile OVERVIEW screen, 1920x1080 (Ludo round 37), behind switch `profile2`

Model: Cursor (composer) or Codex luna. Tier: new UI script + one edited script -> parse, the new focused test, then
`python Godot/tools/run_tests.py --jobs 2 --only profile` and `--only quick_look`.

## Why
The operator approved Ludo's real design (board Q-S201-1: "approve all - build A then B then C"). A = the 410 px quick-look
card is DONE (496033ce: `Godot/scripts/ui/QuickLookCard.gd`, `Godot/scripts/rules/QuickLook.gd`). B is the full screen its
OPEN FULL PROFILE button opens. Today that button routes to the old `fighter_card`; after this task, with `profile2` ON, it
opens the new OVERVIEW.

## Prior research (read these, in this order)
1. `research/LUDO_ROUND37_VERDICT_S202.md` - Claude's verdict, approved: what to TAKE and the CORRECTIONS. Binding.
2. `research/LUDO_ROUND37_S202_reply2a.txt` lines 1-261 (330 lines total) - s1.1-1.8: grid, colour tokens, type
   styles, every panel's x/y/w/h at 1920x1080. The mockup image: `previews/ludo_r37/01_profile_overview_mockup_screen.jpg`
   (direction only; its text is garbled).
3. Pure modules to feed it (do not re-implement): `Godot/scripts/rules/FighterReadout.gd` (headlines, with_delta, regions,
   composure_band), `Godot/scripts/rules/QuickLook.gd` (bout line, morale band, worst wear), `Godot/scripts/rules/ProfileForm.gd`
   (form badges, streak, camp line), `Godot/scripts/rules/ScoutFidelity.gd` (band colours, 20-tick fill, radar - may still be in
   flight on an arena/ branch; if it is not on master, copy only its `band()` + `filled_ticks()` maths into your screen with a
   `# TODO ScoutFidelity` note), and `Godot/scripts/rules/ProfileLayout.gd` (S204, merged: `panels()`, `attribute_card(i)`,
   `tick_segments(card)`, `radar_points(values)`, `radar_ring(level)` - take EVERY rect/point from it, never retype a number).

## What would a human do?
Football Manager's player profile: one dense screen, three columns, no scrolling, every number traceable to the game.

## Prefab check
None for the layout. The 3D portrait reuses the game's own fighter model loader - find how `Godot/scripts/GymHall3D.gd`
builds the fighter body (`grep -n "_set_body\|load_models" Godot/scripts/GymHall3D.gd`), never a new model.

## Build (one new script + its test + a 10-line hook)
- NEW `Godot/scripts/ui/ProfileOverview.gd` (`extends Control`, `static func build(athlete: Dictionary, ctx: Dictionary) -> Control`).
  It RENDERS, it never reads GameState: the caller passes `ctx` = {"bout": get_fight_week_card(id), "camp": get_camp_summary(id),
  "history": athlete.fight_history, "month_ago": <athlete dict or {}>, "coach_name": str, "load_models": bool}.
  Panels (reply2a s1.4-1.8, at its exact x/y/w/h):
  - top bar: back button (emits `back`), breadcrumb `ROSTER > NAME`, tabs OVERVIEW / TECHNIQUES / MEDICAL / TRAINING PLAN
    (only OVERVIEW active; the other three are drawn but disabled with tooltip "PROFILE2C"). NO compare / scout-report buttons
    yet (no system behind them).
  - identity banner: NAME in Chakra Petch Bold 32 + nickname in gold; slices AGE / DIVISION / RECORD / STANCE only with the
    fields the athlete holds (`age`, `weight_class`, `record` via `UIKit.record_text`, `stance`); morale chip
    (QuickLook.morale) and composure chip (FighterReadout.composure_band). NO date of birth, reach, weight-cut, contract, gym cut.
  - left: a 460x440 SubViewport portrait of the fighter's own body (chest up, warm key #FFF4E6, cool fill #93C5FD, gold rim
    #D69E2E per s1.6), skipped (an empty panel with his name) when `load_models` is false so headless tests stay fast; under it
    the 6-region body diagram: two simple silhouettes drawn with `draw_polygon`, each region filled by wear band colour
    (reply2a s1.2 WEAR_* tokens), pulsing outline above 50%, and the table HEAD 08% PRISTINE etc. NO recovery days.
  - centre: the 9 attribute cards 268x148 at the s1.7 pitch: title, big number coloured by band, delta (only when month_ago is
    given), the 20-segment tick bar (10 px segments, 2 px gaps, band colour, inactive #1F2637). NO sub-attribute footnotes.
    Under them the radar with ALL 9 axes (CHIN included - Ludo's list drops it; the verdict puts it back), gold fill 25% alpha,
    rings at 25/50/75/100. The potential/ceiling half is OMITTED (no system).
  - right: NEXT BOOKED BOUT (QuickLook.bout_line + venue/event from ctx.bout, "FIGHT IN N DAYS"), camp panel (coach name, the camp
    line from ProfileForm), form strip (ProfileForm.form, 36 px circles, tips) + streak. NO contract / purse / patience panel.
  - fonts: Chakra Petch (words) + JetBrains Mono (numbers) only, as QuickLookCard.gd preloads them. Colours: reply2a s1.2 tokens.
  - every panel whose data is absent is not drawn (no placeholder value anywhere - verdict).
- HOOK: in `Godot/scripts/GymHallPanel.gd` `_on_quick_look_open_full` (grep it): when `career.profile2` is true (default OFF;
  read it like `_use_profile_drawer` does), mount `ProfileOverview` full-screen over the hall (club time stays paused) instead of
  pushing `fighter_card`; its `back` signal closes it and resumes. Never edit `GameState.gd`.
- NEW TEST `Godot/tests/profile_overview_test.gd`: build with a rich fixture (stats, area_wear 72 on one arm, morale, a booked
  bout card, a camp, 6 history rows incl. 1 amateur) and a bare one. Check: 9 cards at the s1.7 positions (+-1 px); card POWER 78
  has 15 lit ticks in #22C55E; radar has 9 points; arm region drawn in WEAR_SEVERE and listed "72%"; form shows 5 pro badges; the
  bare fixture draws NO bout panel, NO form strip, NO morale chip; no Label anywhere contains "£", "DOB", "REACH", "CONTRACT",
  "CEILING" (the invented fields); the hook: profile2 OFF -> OPEN FULL routes to fighter_card, ON -> ProfileOverview mounted and
  `back` resumes club time. The test must go RED on master before your change (it fails to load the missing script).

## Gates
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- Test: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/profile_overview_test.gd`
  (never `_console.exe`); then the two `--only` subsets above.
- A still is Claude's job (game camera, as_game) - do not shoot one; never open a window, viewer or browser.

## The one trap
Ludo's spec is full of numbers the game does not have (purse, reach, DOB, gameplan mastery %, recovery days, ceiling, peak age,
sub-attributes). Building any of them is a FAIL even if it looks right - the verdict's "no invented numbers" is the acceptance bar.
GDScript: `var x := <call>` fails on a Variant return - type it.
