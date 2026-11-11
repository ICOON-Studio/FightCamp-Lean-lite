# TASK TRAININGB2 - CURSOR (Grok 4.7 High) - the Training tab: a tiredness curve that says something, and the pads list in straight rows

Status: OPEN (S429, Claude main). Discipline: boxing. Model: grok-4.7-high.
Source: the operator's marks on the S428 Training tab still (ops/Feedback/2026-11-11-05/README.md, marked.png; C284 to C286):
1. On the Pads editor's list (a box at 40.6%,53.9%, size 12.0 x 33.3% of the 1920x1080 picture): "check alignement on the
   texts/icons. What raw means ?" (The word is already fixed on main: under 30 it now reads "Learning".)
2. On the curve strip above the seven days (a box at 2.5%,19.1%, size 94.8 x 20.8%): "what are these , i do not learn
   information by looking at them"
You cannot see pictures: work from the description and the rectangles below.

## Contract
OWNS: scripts/ui/WeekTired.gd, scripts/ui/WeekEditors.gd, scripts/ui/WeekTiles.gd, scripts/ui/WeekBoard.gd, tests/week_b_test.gd, docs/TRAININGB2_RESULT.md
RED_TEST: tests/week_b_test.gd -> WEEK_B failures=0
REGRESSION: drill_card_test, hover_ghosts_test, plan_tray_test, week_slate_test, file_limits_test, no_pronoun_test
VISUAL: yes

## What is on screen today (from the still)
- The curve strip: a wide slate box (about x 48..1868, y 207..430). Inside: a pale line with dots, a filled area under it, a
  dashed red line near the top with a small shield and "80" at the left, one boxed number "48" above one dot, faint vertical
  lines. NO title, NO day names, NO scale, no word saying what the line is or what 80 means. Its dots do not line up with
  the seven day cards under it (the day cards are at about x 60..1860, each 245 wide).
- The Pads editor (right half, about x 820..1850, y 585..985): a glove icon and "Pads" as the title, "240" alone under it,
  then four names down the LEFT edge (Uppercut, 1-1-2, 1-2, 1-1) and, about 800 px away at the RIGHT edge, each row's
  "19 -> 27 Learning", "+", "Drill", "-" controls. The names and their controls do not read as one row, the "240" has no
  unit, and the title icon and the names start at different x.

## What it must be
A. THE CURVE TELLS THREE THINGS AT A GLANCE (WeekTired.gd):
   1. A title at the top left, 26 px or more: "Tiredness this week" and, beside it, the week's highest point in words:
      "peaks Thursday evening at 48" (the day and the number from the curve's own data).
   2. Each day's column is exactly above that day's card (same x and width as DayTile_0..6; read the tiles' rects, do not
      hard-code), with the day's evening number printed at its dot (seven numbers, 22 px or more), today's column lit.
   3. The danger line says what it is: on the line itself, "80: too tired, injuries rise" (22 px or more), and any dot
      at 80 or more is drawn red. If no day reaches 80 the strip also says, at the right, how far the peak is under it:
      "32 under the line".
   Hovering a day's column still shows the morning and evening numbers. Nothing in the strip is unlabelled.
   The strip may be at most 230 px tall (it is about 223 now).
B. THE PADS LIST IS A TABLE (WeekEditors.gd `_drill_row` and its header):
   - Header row: the glove icon, "Pads", then "240 min tonight" (the number with its unit and word), all on one baseline.
   - Each drill is ONE row inside one container, columns in this order, every column's left edge the same on every row:
     name (starts at the same x as the header's icon) | mastery now -> after tonight ("19 -> 27") | the word (Learning,
     Usable...) | the + / - / Drill buttons at the right. The gap between the name and its numbers is at most 40 px:
     the numbers sit next to the name, not at the far edge. A row with no change tonight shows its mastery number alone.
   - The "Held at N by the <punch>" line (WEEKTESTS1) stays under its row, indented to the name column.
   Keep every node name the tests use (DropDrill, DrillIt, Held, Drill_<card>).

## The test first (tests/week_b_test.gd, extend it; the new checks must be RED on today's main)
Build Training tab B for Lucy the way the test already does, at 1920x1080, and add:
1. The strip has a Label whose text starts "Tiredness this week" and one that contains "peaks".
2. Seven day-number Labels exist in the strip; each one's centre x is within 6 px of the centre x of its DayTile.
3. A Label containing "too tired" exists and its centre y is within 14 px of the danger line's y.
4. In the Pads editor: for every drill row, the name Label's left x equals (within 2 px) the header icon's left x; the
   mastery Label's left x is the same (within 2 px) on every row; name and mastery share a centre y within 4 px; the gap
   between the name's right edge and the mastery's left edge is under 40 px or the mastery column starts at one fixed x
   no further than 320 px from the name column.
5. A Label containing "min tonight" exists in the Pads header.
6. No two visible Labels inside the strip or the Pads editor overlap by more than 4 px in both directions.

## Stills (you render, Claude reads them)
`python ops/Tools/godot_slot.py run --who cursor -- python tools/hidden_desktop.py run --timeout=180 <godot.exe> --path .
--windowed --resolution 1920x1080 --log-file <log> --script res://tools/layout_snapshot.gd -- <out_dir>` and copy
23e_training_tab_real.png to docs/mockups/s429/trainingb2/ (the plain win64 exe, never the console one; nothing on a
monitor). docs/TRAININGB2_RESULT.md: what each mark asked, what changed, the rects the test printed, the pass lines.

## Prior research
docs/mockups/s419 Training tab approaches and ops/research/TRAINING_SCREEN_S381.md (why the curve is there: the week's
load decides injuries and the fight-night tank), memory rules: only actionable information on screen (S398: "unless the
player can really do something about it"), graphics not paragraphs (S416), game words not jargon (S422).

## What would a human do?
A coach's wall chart of the week has the days written under it, the line he must not cross marked and named, and the worst
day circled. A list of drills is ruled in columns: the punch, where it stands, what tonight adds.

## Prefab check
WeekTired.gd, the day tiles and the drill rows exist: this task labels and aligns them. No new asset.

Rules: no script over 500 lines (WeekBoard.gd is 471: do not grow it; put new drawing in WeekTired.gd). No he / she in any
script text. Parse before testing. Every Godot job through `python ops/Tools/godot_slot.py run --who cursor -- ...`.
RESULT lines for the PR body: `RESULT: tests/week_b_test.gd -> WEEK_B failures=0` and one line per regression test.
