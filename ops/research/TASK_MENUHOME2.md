# TASK MENUHOME2 - CURSOR (Grok 4.7 High) - Home, round 2: the Needs-you board as drawn

Status: OPEN (S408, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
BASE: cursor/menuhome1
OWNS: scripts/ui/areas/Home.gd, scripts/ui/HomeMatch.gd, scripts/ui/HomeNeeds.gd, scripts/ui/HomePanels.gd, tests/menu_home_test.gd, tests/home_look_test.gd
RED_TEST: tests/menu_home_test.gd -> MENU_HOME failures=0
REGRESSION: home_look_test, home_row_injured_test, kit_icon_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/home.html (the spec; open the html, you cannot see the png). Worked examples on main: scripts/ui/areas/World.gd (wall), scripts/ui/WorldCompare.gd ChanceBar (the win band). ops/research/GDSCRIPT_TRAPS.md. Check the real file list with `git diff --stat origin/main...HEAD` and tell me if a file you need is not in OWNS.

## Prior research
Claude rendered this branch (13b_home_booked_settled) and compared it with the mockup. The list below is what that showed.

## What would a human do?
Pin each thing that needs the owner on the board as a note, most urgent first, and leave it there until it is dealt with.

## Prefab check
WarmKit has the pieces: panel("board"), box("sticky"), the magnet. Use them.

## Faults to fix (each seen on the render)
1. BOARD CLIPPED: the "Needs you" heading and the last row are drawn over the aluminium frame, because the rows are taller than the panel. Everything sits inside the frame's content margins. Test: every child's rect is inside the board's rect minus the "board" slice margins.
2. NOTES AS DRAWN: the mockup is a 3-across grid of sticky notes with a magnet on top, not rows. Each note: title in the hand font, date tag, one line, one button that opens the real page. Red magnet = this week, amber = later, dark = can wait, with the one-line legend above the board as in the mockup. At most 6 notes; more than 6 shows a "+N more" note that opens the list. The week review stays a note with Open and never opens by itself.
3. WALL: the plaster stops where the content stops and the old blue shows below. The page fills the holder's height (size_flags_vertical = SIZE_EXPAND_FILL). Test: the wall's bottom reaches the bottom of the screen.
4. WIN CHANCE: the next-fight card uses the same band as World (Compare.ChanceBar), hatched while not scouted, with the range and the reason after it. No dot meter.
5. NEXT FIGHT layout as the mockup: days to the fight large in the hand font at the centre, then date, Fight prep and the rounds chip.
6. THE JOB panel is the old white style and takes 120 px above the board. It is not in the mockup. Move its two lines into the first-hour guide while the guide shows; after that, drop the panel. Keep the owner's portrait card out of Home unless the mockup has it. The first-hour guide's own tests stay green.

## Rules
Keep every action wired to the real page. No file over 500 lines. Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. Nothing opens on the monitors.

## The one trap
A render on the hidden desktop is 1009 px tall. Test the fit at 1920x1080 in the test, not by the picture.

## Result lines (PR body)
RESULT: tests/menu_home_test.gd -> MENU_HOME failures=0
