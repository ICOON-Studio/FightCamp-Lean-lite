# TASK MENUWEEK2 - CURSOR (Grok 4.7 High) - the Fighter Week page, round 2: to the mockup, on one screen

Status: OPEN (S408, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
BASE: cursor/menuweek1
OWNS: scripts/ui/WeekBoard.gd, scripts/ui/WeekCards.gd, scripts/ui/WeekCardsPick.gd, scripts/ui/WeekCamp.gd, scripts/ui/WeekDay.gd, scripts/ui/WeekPops.gd, scripts/ui/WeekReadRows.gd, tests/menu_week_test.gd
RED_TEST: tests/menu_week_test.gd -> MENU_WEEK failures=0
REGRESSION: grey_reason_test, kit_icon_test, week_plan_test, training_week_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), ops/research/TASK_MENUWEEK1.md (the full OWNS list: check it with `git diff --stat origin/main...HEAD` and tell me if a file you need is missing above), docs/mockups/s403/fighter_week.html (the spec; open the html, you cannot see the png). Worked examples on main: scripts/ui/areas/World.gd (wall), scripts/ui/WorldLadder.gd (bars that do not stretch). ops/research/GDSCRIPT_TRAPS.md.

## Prior research
Claude rendered this branch (23e_training_tab) and compared it with the mockup. The list below is what that showed.

## What would a human do?
Plan the week on one board, seeing the camp's shape and the seven days together, and change a slot without losing sight of the rest.

## Prefab check
None needed: WarmKit and KitIcon are the parts.

## Faults to fix (each seen on the render)
1. WALL: the page sits on the old blue. Use WarmKit.wall() on the holder as World.gd build() does; the page fills the holder's height.
2. ONE SCREEN: at 1920x1080 with the guide hidden, the board ends above the bottom of the screen. Today the session picker alone runs off it. Test: board bottom <= 1080.
3. THE CAMP CHART: the mockup's chart with Build, Peak and Taper bands, the 80 overreached line, the peak marker and the fight marker. Today it is a thin line. Day axis under it, lined up with the day columns when the weeks shown allow.
4. DAY CARDS as the mockup: compact, one icon, name, what it raises, intensity dots, fatigue flame. No large coloured icon tiles and no per-day fatigue bar row. PM slots the same height as AM. Rest slots are tinted and say "Fatigue goes down".
5. THE PICKER is the mockup's chip grid, opening under the chosen day with a notch pointing at it: Conditioning, Striking, Grappling (not built: warning triangle, no fake numbers), and it stands in place of today's three full-width button columns. Intensity lives on the dots, not a Light/Normal/Hard bar across the page.
6. THE BOTTOM ROW: coach's line with Do it and Open Fight prep, weight and focus chips, the twist sticky, Learn on the pads with the coach's pad nights, and All eight weeks as a fighter strip. Whatever has no real data yet: full colour with a warning triangle, per MENU_BUILD_RULES.
7. HEADER: "Coach runs it / I run it" and "This week / Next week" are two segmented pills, and the stat goal bar sits top right.
8. grey_reason_test CRASHES on this branch (exit 9). Read its first error and fix the cause; the test keeps its meaning.

## Rules
Do not change WeekPlan, TrainingWeek or what gets saved. No file over 500 lines. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
A render on the hidden desktop is 1009 px tall. Test the fit at 1920x1080 in the test, not by the picture.

## Result lines (PR body)
RESULT: tests/menu_week_test.gd -> MENU_WEEK failures=0
RESULT: tests/grey_reason_test.gd -> PASS
