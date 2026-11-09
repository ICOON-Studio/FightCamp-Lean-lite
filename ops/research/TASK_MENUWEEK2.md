# TASK MENUWEEK2 - CURSOR (Grok 4.7 High) - the Fighter Week page, round 2: to the mockup, on one screen

Status: OPEN (S411 re-brief, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
BASE: claude/menuweek1-main
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

## S411 UPDATE: the look, and fewer words (operator Q-S294-135: "Yes, but with fewer words and bigger pictures, like Fighters")
This section overrides the faults above wherever they disagree. Read MENU_BUILD_RULES items 14-22 first. Worked examples on main: scripts/ui/RosterCards.gd (the Fighters cards), scripts/ui/VersusPanel.gd (the versus screen). Measure with `tools/page_ink.gd`: `const PageInk := preload("res://tools/page_ink.gd")`, `PageInk.read(root)`, at 1920x1080 with the guide off (`c.guide = ""`).
Your test prints one line: `WEEK_INK words=<n> pictures=<p> tallest=<h>` and fails if a bar below is missed. No bar may be met by cramming: nothing runs past 1080 px and text stays 16 px or more (14 only inside a tile).

BARS: words <= 170, tallest >= 620 px, board bottom <= 1080. Measured on main today: 326 words, one 64 px face.
1. WALL: `MenuFx.set_wall(main, RosterCards.BACKDROP)`.
2. THE FIGHTER STANDS ON THE PAGE: a column of about 300 px at the left, `RosterCards.body` at least 620 px tall, the name in the brush font over the painting, and under the figure two tiles: fatigue and weight. Tabs stay.
3. DAY CARDS: icon, session name, intensity dots. What it raises and its fatigue go in the tooltip. Rest cards say only Rest.
4. CAMP CHART: bands, markers and the fatigue line, no sentences. The band names are the only words on it; the numbers are on hover.
5. PICKER: chips with an icon and one word, closed until a slot is picked, and it opens over the page rather than pushing it.
6. LEARN ON THE PADS: picture cards. The move or combo picture large (assets/ui/moves), the name, one progress bar. "Held at 51 by the Jab" and the mastery numbers go on hover; the Drill button stays when one is due.
7. COACH: one line, under 12 words, with Do it. PLAN TOTALS and GOAL: icon tiles, one row. THE ROAD (Skills Awards) and anything else below the fold moves behind one button in the header that opens it in place.

## The one trap
A render on the hidden desktop is 1009 px tall. Test the fit at 1920x1080 in the test, not by the picture.

## Result lines (PR body)
RESULT: <the page's ink line, words, pictures, tallest>
RESULT: tests/menu_week_test.gd -> MENU_WEEK failures=0
RESULT: tests/grey_reason_test.gd -> PASS
