# TASK LUDO-GYMUI1 - Ludo's gym screen: roster left, week right, active fighter + ADVANCE DAY (V12) - Cursor

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/LUDOGYMUI1, branch cursor/ludo-gymui1 from master. Push the branch; never master.
Never open a window, image viewer or browser on the operator's screens. Windowed Godot ONLY through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`. Look at stills with your FILE tool only.

## Owned files
- `Godot/scripts/LudoGymHud.gd` (NEW, Control - the overlay)
- `Godot/scripts/GymHallPanel.gd` (595 lines; anchors: `rebuild()` ~53, `_build_hud2_pieces()` ~117, `end_day()` ~453 - read those
  windows, not the whole file) - mount the overlay behind the switch, wire ADVANCE DAY to `end_day()`
- `Godot/tests/ludo_gym_hud_test.gd` (NEW)
- `Godot/tools/ludo_gym_stills.gd` (NEW, copy the mounting pattern of `Godot/tools/gym_club_stills.gd`)
- `previews/ludo_gymui1/*.png` (NEW)
Read-only: `Godot/scripts/UIKit.gd` (`UIKit.tip`), `Godot/scripts/UITokens.gd`, `Godot/scripts/LudoFightHud.gd` (house style of the
fight HUD you built - same card look), `Godot/scripts/FightWeek.gd` IF it is on master (LUDO-WEEK1A, Arena) - otherwise a local 6-day
list mon..sat.

## Prior research
- Ludo (lead designer), approved by the operator as V12: `research/LUDO_ROUND4_S190.md` section "C) Gym Screen Layout" and the
  mock-up `previews/ludo_s190/01_gym_screen.png` (read the LAYOUT; its text is AI-garbled): LEFT a roster drawer of fighter
  cards (portrait, name, 2-3 status icons); RIGHT a vertical week list (one row per day, a coloured status dot each: done / today /
  warning amber / locked); BOTTOM-CENTRE the active fighter (portrait between two bars: stamina and strain); BOTTOM-RIGHT a big gold
  ADVANCE DAY button; TOP a thin bar (gym, funds, a title, play/pause). The painted colour routes on the floor are a SEPARATE task
  (CLUBROUTES1) - not here.
- Operator rules: icons over text, every icon has a tooltip via `UIKit.tip`; the gym floor is a TRAINING floor (S177) - the overlay
  must not cover the stations in the middle; HUD2 (S186) already removed the top bar's Continue/END DAY duplication - keep ONE advance
  control (ADVANCE DAY = the existing `end_day()`).

## What would a human do?
Build the overlay as one Control over the existing 3D club, behind a switch, fed by what the panel already reads; check it on the club's
own camera with stills.

## Prefab check
N/A - our UI kit is the house style.

## Spec
- Switch `ludo_gym` DEFAULT OFF: `OS.get_cmdline_user_args().has("ludo_gym")` or `career.ludo_gym`; OFF = today's screen untouched.
- Roster drawer (left, <= 240 px wide): one card per signed fighter + the house sparring partner (if any); click selects the active fighter.
- Week list (right, <= 240 px wide): the 6 days of the current week with status dot + day name + the day's one-word plan (from the
  panel's existing week/program read); the fight day reads FIGHT.
- Active fighter bar (bottom centre): portrait/initials, name, stamina bar, strain/fatigue bar (both with icons + tips).
- ADVANCE DAY (bottom right, gold, >= 200 x 56): calls `end_day()`; disabled with a tip while a visit is running (GymClub3D `running`).
- The middle of the screen (the floor) stays clear: test that no overlay rect covers the central 50% x 50% of the viewport.

## Done = (tier: script edited - parse, focused test, related run)
1. `python Godot/tools/check_scripts.py Godot/scripts/LudoGymHud.gd Godot/scripts/GymHallPanel.gd Godot/tests/ludo_gym_hud_test.gd Godot/tools/ludo_gym_stills.gd`
2. `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/ludo_gym_hud_test.gd`
   (NEVER the _console exe) -> `LUDO_GYM_HUD_TEST FAILS=0`. Cases: switch OFF mounts nothing new; ON mounts the 4 parts; centre clear;
   every icon has a UIKit tip; nothing clips at 1920x1080 and 1280x720; ADVANCE DAY calls end_day (spy). Write it RED first, paste the count.
3. `python Godot/tools/run_tests.py --only gym_hall --jobs 2` and `--only hud2 --jobs 2` -> 0 fails.
4. STILLS on the club's own camera (the same camera `gym_club_stills.gd` uses - never a custom close-up): `ludo_gym_stills.gd -- as_game
   gym4_club ludo_gym` -> `01_morning.png`, `02_mid_day.png` (a fighter at a station), `03_off.png` (switch OFF). Every still must show
   the WHOLE floor with the ring and stations visible; open each with your file tool and fix anything that clips, overlaps or covers the
   floor before you finish.
Commit + push cursor/ludo-gymui1. Final message: red count, green, the still paths.

## The one trap
The mock-up's words are garbled AI lettering - copy its LAYOUT only, use our real data and words.
