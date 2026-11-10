# TASK TRAININGB1 - CURSOR (Grok 4.7 High) - the Training tab rebuilt as approach B, with A's tiredness curve on top

Status: OPEN (S422, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator approved B painted (Q-S294-166: "Yes, build this") and then (Q-S294-169): "B, with A's tiredness curve on
top". Before that, on the built week page: "i do no tlike much the design ... your fonts are small too", "this needs to be
displayed difrfentely" (the seven little tiredness bars), "toomuch text cut uncessary".

## Contract
OWNS: scripts/ui/WeekBoard.gd, scripts/ui/WeekTired.gd, scripts/ui/WeekTiles.gd, scripts/ui/WeekEditors.gd, tests/week_b_test.gd
RED_TEST: tests/week_b_test.gd -> WEEK_B failures=0
REGRESSION: week_board_clarity_test, week_slate_test, week_plan_test, week_coach_test, training_week_test, weekend_plan_test, golden_path_test
VISUAL: yes

## The picture (open both; you cannot see images, so read the layout from the numbers below too)
- docs/mockups/s419/training_b_painted_ludo.png: THE LAYOUT (B). The painter garbled some small words; the real words are in
  docs/mockups/s419/training_b.html.
- docs/mockups/s419/training_a.png and training_a.html: ONLY its tiredness curve (the top panel) is taken.

Top to bottom at 1920x1080 under the page tabs:
1. TIREDNESS CURVE (new scripts/ui/WeekTired.gd, a Control that draws in `_draw`), full width, about 230 px tall: the week's
   tiredness as ONE smooth line over 14 points (each morning and each night, 0-100), the area under it filled, a dashed red line
   at 80 with a hatched band above it and "80" with a warning icon at the left, the peak marked with its number in a box
   (A's "82"), a point per session. Seven columns, lined up EXACTLY with the day tiles below (same x for each day). No seven
   little bars anywhere on the page any more.
2. SEVEN DAY TILES (new scripts/ui/WeekTiles.gd): Mon..Sun, each a wooden tile with the morning icon and the evening icon side by
   side and the intensity pips (1-3) under the morning; rest days show the bed / sleep icon; fight day the bell and the glove, red
   frame. The selected day has the gold frame. A click on a tile selects that day (static WeekBoard.picking = "fid|dow").
3. TWO EDITORS for the selected day (new scripts/ui/WeekEditors.gd): left the MORNING (session name 40 px, the day, Light /
   Normal / Hard as three big wooden buttons each with its tiredness cost and its gain under it, the row of session icons to swap
   the session, the goal attribute's line "Stamina 64.2 -> 66" with the week's gain); right the EVENING (Pads / Sparring /
   Film / Rest as four icon buttons; on a pad night the minutes split bar and the drill cards with + / - minutes, the mastery
   step and its gain; the tray of cards to add under them). Reuse DrillCard / DrillTray / WeekPops code paths: the editors
   replace the popovers as the way to edit, they do not change what an edit does.
4. BOTTOM BAR (in WeekBoard.gd): the coach's face, his one change with its effect ("Tue -> pads, tired 82 -> 74"), Do it /
   Leave; with a fight booked the weight and Hold / Cut; the red Start week button at the right.

## The job
- WeekBoard.gd keeps `make(main, career, fighter)`, `goal_of`, `plan_of`, `picking` and `picking_eve` and every action string it
  sends to main (grep `main.act` in it and in WeekCards / WeekPops before you move anything). It becomes the frame that stacks
  the four parts; the numbers each part shows come from the SAME functions the page reads today (the plan, the projections,
  the tiredness array `tired` in `_build`). Change no rule module and no number.
- Type: nothing under 20 px; anything the player acts on 26 px or more; headings 40 px. At most 70 words on the page outside
  session and move names and numbers; words that explain go in tooltips.
- The look is the shared one: WoodKit.slate() panels, WoodKit.PIECE buttons, the ink pass; no new colours (WoodKit.INK, SOFT,
  HEAD, BLUE and UI.GREEN / RED / AMBER). The icons: reuse what WeekCards uses today for each session; name any missing one in
  the PR body, do not draw new art.
- WeekCards.gd is already 552 lines: do NOT add to it. If you stop using a part of it, leave it (another task deletes it).
- No file over 500 lines.

## tests/week_b_test.gd (write it first, red on main)
Headless, modelled on tests/week_board_clarity_test.gd and tests/week_slate_test.gd: a career with a boxer and a booked fight,
open the Training tab, settle 3 frames. Check, printing each number:
- a WeekTired node exists and sits ABOVE seven WeekTiles day tiles (its rect bottom <= the tiles' top);
- each day tile's centre x is within 12 px of the curve's column centre for that day;
- the curve's peak value equals max(tired) from the same plan the page builds, and the 80 line is drawn (expose it as a property);
- clicking Wed's tile sets WeekBoard.picking to that day and the MORNING editor's title is Wed's session name;
- setting Wed's evening to Rest from the editor lowers the curve's Wed night point (read before / after);
- every Label and Button text on the page is >= 20 px (font_size override or theme), and no Label is clipped (its minimum
  width <= its width);
- `for fault in SlateWalk.faults(page): fail` (SlateWalk = preload("res://tests/slate_walk.gd")).
Print `WEEK_B failures=N`. Write no check that can only pass: run each once against main and say in the PR body which went red.

## Prior research
ops/research/TRAINING_TAB_BRIEF_S419.md (what the player does on this tab), ops/research/CRITIC_PACK.md sections 4.1 and 4.2,
scripts/ui/WeekBoard.gd header, scripts/ui/WoodKit.gd, `git show bbc6cbbd` (LOOKSLATE1, the week page on slate),
ops/research/MENU_BUILD_RULES.md, ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
Lay the seven days out as big tiles you click, draw the week's tiredness once as a mountain above them, and edit the clicked day
in two big panels underneath, the way a coach's whiteboard reads.

## Prefab check
None: our own page from our own pieces (WoodKit, DrillCard, DrillTray).

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who cursor -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). You cannot see images: Claude renders the page and judges it. Never "he" or "she" in text: the boxer's name or "the boxer".

## The one trap
The curve and the tiles are two nodes: a column lined up by eye drifts. Compute both from ONE column width (WeekBoard owns it and
passes it to both) and test it (the 12 px check above).

## Result lines (PR body)
RESULT: tests/week_b_test.gd -> WEEK_B failures=0
RESULT: tests/week_board_clarity_test.gd -> the test's own pass line
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
