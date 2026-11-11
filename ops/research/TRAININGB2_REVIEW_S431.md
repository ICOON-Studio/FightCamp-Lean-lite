# TRAININGB2 review (S431): two readers of branch cursor/trainingb2 (PR 194)

Verdict (Claude, S431): no finding blocks the collect; every fix is small and inside the owned files. NOT collected in S431
(usage and context). Collect by diff, apply the fixes below, parse, week_b_test + the regression set, render, read.

## Reader summary
Lens: the test and the claims. Read-only; nothing changed, no Godot started. Read: the brief, the whole of tests/week_b_test.gd, scripts/ui/WeekTired.gd and scripts/ui/WeekEditors.gd on the branch, main's WeekTired.gd, the WeekEditors diff, the result page, PR 194's body and checks, the seat's output file, the still (whole and three enlarged crops), and the S428 still it answers.

VERDICT: collectable after two small fixes in WeekTired.gd and one re-run. The test builds the real screen and its new checks would be red on main, but (a) it cannot see the fault the still shows (lines drawn through the words and numbers), (b) three of the six regression results are unproven, (c) red on main was never shown.

DOES THE TEST BUILD THE REAL SCREEN: yes. It loads scenes/Main.tscn at 1920x1080, TestJump "camp", main.act("fighter") + act("ftab","3"), and reads the same WeekBoard / WeekTired / DayTile_n / EveningEditor nodes the game shows; clicks go through the tiles' and buttons' own pressed signals. No stand-in. One helper is seat-made: danger_y() (WeekTired.gd:61), which shares _y(80) with _draw, so it is honest today.

RED ON MAIN: not shown anywhere (result page, PR body, seat output E:/FightCamp/wt/TRAININGB2_dispatch_out.txt hold only green lines). By reading main's files the new checks 1-5 must be red there (main has no "Tiredness this week" label, no DayNum_n, no "too tired" label, no DrillName/DrillMastery, no "min tonight"); check 6 (overlap) and the 230 px height check would be green on main.

CHECK BY CHECK (week_b_test.gd), mutation that turns it red / what it misses:
- title + "peaks" (140-144): red if either label is removed or the title drops under 26 px. Misses: wrong day, morning/evening or number in the peak sentence (only "contains peaks").
- seven day numbers over their cards (168-178): red if a label is missing, off its card by more than 6 px, or under 22 px. Misses: the VALUE (the default text "0" passes is_valid_int), the label's height against its dot, visibility.
- "too tired" on the line (147-155): red if the label moves more than 14 px off _y(80). Misses: the line drawn through the words (it is, in the still), and a change of the drawn line's y that also changes danger_y.
- "under the line" (159-167): red if the label is missing while nothing reaches 80. Misses: the number, and the label staying up at 80+.
- pads rows (210-255): red if name/mastery nodes are missing, names leave the icon's x, the mastery column moves between rows, or a spacer returns between name and mastery. Misses: the word and button columns, the Held indent, the header baseline, the minutes value, "number alone when no change". The measured "gap" is between label BOXES (fixed width), so it is always the HBox's 12.
- overlap (258-274): Labels against Labels only; red if two words collide. Misses everything drawn (curve, dots, dashed line), and the test state (peak 52) never brings a number near a word.
- old check 53-57 (curve.column_center vs tile centre) is now a tautology: column_center returns that tile's own centre.

BRIEF, ITEM BY ITEM:
A1 title 26+ px and peak in words from the data: DELIVERED (28 px; still "peaks Friday evening at 48", Friday's number is 48). Text not checked against data by the test.
A2 columns from the tile rects: DELIVERED (_col_box reads DayTile rects, WeekTired.gd:285). Seven evening numbers 22 px: DELIVERED but each sits on its dot with the curve through the digits (still). "Today's column lit": PARTLY - it lights the SELECTED day (as main did), no check.
A3 "80: too tired, injuries rise" on the line, 22 px: DELIVERED but struck through by the dashes (still). Red dot at 80+: in code (WeekTired.gd:133, 346-347), never exercised. "N under the line" at the right: DELIVERED (still "32 under the line" = 80-48), also struck through.
Hover shows morning and evening: in code (_gui_input, WeekTired.gd:238-260), NOT tested.
Strip at most 230 px: DELIVERED (220, checked).
B header glove, "Pads", "240 min tonight": DELIVERED in one row; bottom-aligned boxes, not one baseline (the smaller text sits about 3 px lower in the still); no check.
B one row per drill, columns name | mastery | word | buttons, numbers beside the name: DELIVERED (still; fixed widths from the widest text). Number alone when no change: DELIVERED (still "1-1 27", "1-2 0"). Held line under its row on the name column: DELIVERED (still). Node names DropDrill, DrillIt, Held, Drill_<card>: kept.
Test checks 1-6: all six written as the brief worded them.
Owned files only: yes (WeekTired.gd 353 lines, WeekEditors.gd 383, test 305; WeekBoard.gd and WeekTiles.gd untouched).

RESULT PAGE AGAINST THE CODE: every rect and number re-derived and consistent (strip at x 58, y 220, 1804 x 220; line y 301.6 = 220 + 208 - 0.8 x 158; danger x 98 = 58 + 40; "28 under the line" x 1691 = 58 + 1804 - 161 - 10; 80 - 52 = 28; day-card pitch 259.4). The page's numbers are the test's camp week (peak Wednesday 52); the still is a different week (peak Friday 48, other drills) - both are internally consistent, the page says which is which. Three of its seven pass lines are the seat's word only (finding 2).

### [fix_at_collect] The test passes while the still shows lines drawn through the words and through six of the seven day numbers
File: scripts/ui/WeekTired.gd:196
What: Each day number is centred ON its dot (line 196: cy - l.size.y * 0.5), and the danger label and the 'N under the line' label are centred ON the dashed line (lines 175 and 178). The test's overlap check (tests/week_b_test.gd:258-274) compares Labels with Labels only, and its line check (152) accepts 0 px off, so nothing drawn can fail it.
Failure: In docs/mockups/s429/trainingb2/23e_training_tab_real.png the red dashes run straight through '80: too tired, injuries rise' and through '32 under the line' (they read as struck out), and the white curve crosses the digits of 34, 43, 42, 48, 46 and 39 ('34' reads like '3/'). The mark this task answers was 'i do not learn information by looking at them'; WEEK_B failures=0 all the same.
Fix: Line 196: put the number above its dot, `l.position = Vector2(cx - l.size.x * 0.5, cy - l.size.y - 6.0)` (the existing nudge loop keeps it off the title). Lines 175 and 178: sit both labels on top of the line, `y - _danger.size.y` and `y - _under.size.y` (centre 13.5 px off, still inside the test's 14). Add one check to the test: each DayNum label's bottom is at or above curve._y(night(i)) and the danger label's bottom is at or above danger_y().

### [fix_at_collect] Three of the six regression results are not proven: the dispatcher captured an engine line, and CI was cancelled
File: docs/TRAININGB2_RESULT.md:42
What: The result page lists 'DRILL_CARD PASS', 'HOVER_GHOSTS PASS' and 'PLAN_TRAY PASS'. In PR 194's body the dispatcher's own run of those three reads 'RESULT: tests/drill_card_test.gd ->    at: clear (core/io/resource.cpp:822)' (the same for hover_ghosts and plan_tray): it kept the last output line, a resource-leak line, not the pass line. The PR's ci 'tests' job is CANCELLED. Only the 'seat says' lines claim a pass.
Failure: drill_card_test walks the very rows this diff rebuilt (Drill_* rows, '+', DropDrill, Held's first child, SplitBar, which is now only added with two or more drills). If one of them is red, nothing in the PR shows it.
Fix: At collect run the three by name (headless, through godot_slot) and read each test's own last line: 'DRILL_CARD PASS', 'HOVER_GHOSTS PASS', 'PLAN_TRAY PASS'. Separately, seat_dispatch should keep the line that matches the brief's pass pattern, not the last line.

### [fix_at_collect] The day-number check passes on the labels' starting text '0'
File: tests/week_b_test.gd:171
What: `_check(lab != null and str(lab.text).is_valid_int(), ...)` is the only check on what the seven numbers say. WeekTired.gd:80 creates every label with the text "0".
Failure: If _sync_text stopped filling the numbers, or filled them with the morning value or the wrong day, all seven would still be valid integers and the test stays green. The same holds for the peak sentence (line 141 only looks for the word 'peaks') and for 'N under the line' (line 165 only looks for the words).
Fix: Compare with the plan, not the curve: `var tired := WeekBoard.tired_days(WeekBoard.plan_of(main.career, main.career.fighter()))`, then `lab.text == str(roundi(float(tired[i][1])))`; the peak label must contain the day name and the rounded maximum of that array; the under label must start with `str(80 - roundi(max))`.

### [note] The new checks were never shown red on main
File: docs/TRAININGB2_RESULT.md:38
What: The brief says 'the new checks must be RED on today's main'. The result page, the PR body and the seat's output file hold only green lines; no red run is quoted.
Failure: A check that could only pass would not have been caught by the seat's own process. By reading origin/main's WeekTired.gd and WeekEditors.gd I can say checks 1 to 5 must fail there (none of the labels or node names exist); the overlap check and the 230 px height check would be green on main.
Fix: Nothing to change in the code. If proof is wanted: run the branch's tests/week_b_test.gd against main's two scripts once and keep the FAIL lines in the result page.

### [note] An older alignment check became a tautology
File: tests/week_b_test.gd:57
What: Lines 53-57 compare each tile's centre x with curve.column_center(i). On the branch column_center (WeekTired.gd:48-51) returns `t.get_global_rect().get_center().x` of that same DayTile, so the gap is always 0.0.
Failure: On main this check measured the curve's own column maths against the tiles. Now it can only pass. Where the dots are drawn (_px, WeekTired.gd:303-306, 0.32 and 0.50 of the column) is checked by nothing: moving the evening dot to 0.80 leaves the test green with every number away from its dot.
Fix: Either delete lines 53-57 (the DayNum check replaces them for the labels) or expose the evening dot's x (a small `dot_x(i)` that returns global_position.x + _px(i * 2 + 1), used by _draw) and compare that with the tile centre.

### [note] Brief items in the code that no check exercises
File: tests/week_b_test.gd:120
What: Not tested: the hover read-out (WeekTired.gd:238-260); a dot and its number turning red at 80 or more (133, 346-347) - the camp week peaks at 52, so that branch never runs; the 'under the line' label hiding at 80+; the lit column (it lights the SELECTED day, the brief said today's); the word column and the buttons column sharing an x on every row; the Held line's indent; the header on one baseline; the mastery number alone when tonight changes nothing.
Failure: Each of these can be removed or broken with WEEK_B still at failures=0. In the still the header's '240 min tonight' sits about 3 px below the baseline of 'Pads' (both boxes are bottom-aligned, the fonts are 40 and 26 px).
Fix: Cheapest three: (1) call curve.setup with a points array holding one 85 and assert DayNum's font colour is UI.RED and UnderLine is hidden; (2) send an InputEventMouseMotion to curve._gui_input over day 2 and assert HoverRead is visible with 'Morning N, evening M' from tired_days; (3) in _pads_rows collect DrillWord's left x per row the way mast_x is collected.

### [note] Just under 80 the strip contradicts itself
File: scripts/ui/WeekTired.gd:146
What: The words use the rounded value (`roundi(peak)`, lines 126 and 143; `roundi(v)`, line 132) while the red test uses the raw value (`float(p) >= 80.0`, lines 133, 148, 346).
Failure: A peak of 79.6 prints 'peaks ... at 80', a white '80' at the dot and '0 under the line', next to the red line that says '80: too tired'. No test state comes near 80.
Fix: Use one reading everywhere: `roundi(v) >= 80` at lines 133, 148 and 346 (or floor the printed numbers instead of rounding them).

### [note] The still is another week than the result page's numbers, and its bottom row is cut by the screen edge
File: docs/mockups/s429/trainingb2/23e_training_tab_real.png:?
What: The result page's rects come from the test's camp week (peak Wednesday 52, drills 1-1 / 1-2-3 / 1-2-3-2); the still is the snapshot tool's week (peak Friday 48, Uppercut / 1-1 / 1-2 / 1-1-2). In the still the bottom bar ('Do it', 'Leave', 'Start week') starts at about y 1058 and is cut off by the 1080 edge; on the S428 still it sat whole at y 1003-1055.
Failure: With two 'Held at 48 by the Cross' lines the pads editor ends at about y 1040 and pushes the bar off the picture. This diff does not cause it (it removes one line of height: the lone '240' row; _held_line is unchanged from main), but no check sees it: SlateWalk.faults (tests/slate_walk.gd:30-33) tests only x past 1920, never y past 1080.
Fix: Outside this branch's owned work: note it for the page's owner. A one-line guard for week_b_test: the 'Start week' button's global rect ends at or above 1080.

## Reader summary
Code lens on PR 194 (cursor/trainingb2): not ready to show as rendered, but every fix is small and inside the owned files. I read the brief, both scripts whole, the test, the result page and the still (plus zoomed crops); I ran no Godot.

Clean: only the five expected files changed, and main has not moved under them. Line counts are 353 / 383 / 305, and WeekBoard.gd is untouched at 471. No reused variable names, no Variant `:=`, no stray `%`. Every text is 22 px or more. Peak, day numbers and "N under the line" come from the curve's own points. A week with no pads and a rest/sparring/film night are safe (`inp["week"]` always exists, `night_minutes` has a default). Columns read the DayTile rects.

What is wrong in the still:
- The seven evening numbers sit exactly on their dots and on the curve, so the line runs through them; 43, 42, 48 and 46 are hard to read.
- "80: too tired, injuries rise" and "32 under the line" are struck through by the dashed line.
- The bottom row (coach line, Do it, Leave, Start week) is cut off at the bottom of the screen. This comes from the two "Held at 48 by the Cross" lines already on main, not from this diff, which saved one line of height.
- The mastery numbers (27, 0, 19 → 27) have no word naming them, and their tooltips cannot open.

Also in the still, not from this diff: the guide bubble covers the morning editor's goal line.

The still shows an ordinary week (peak Friday 48), while the result page's rects are from the test's camp week (peak Wednesday 52, other drills), so they do not describe this picture. No still shows a day at 80 or more, so the red dot and red number are unseen.

The brief says "today's column lit"; the code lights the selected day, as main did, matching the gold tile below. No jargon or pronouns found in the new text.

### [fix_at_collect] Day numbers are printed on top of their own dot and the curve
File: scripts/ui/WeekTired.gd:196
What: `_place_num` centres each number on (column centre, `_y(night(i))`), which is exactly where the evening dot is drawn (`_px` puts evening at 0.50 of the column, line 305) and where the 3.5 px curve passes. Line 133 also paints the selected day's number gold (WoodKit.HEAD) on the gold-lit column over the amber fill.
Failure: In the still the curve runs through all seven numbers: 43, 42, 48 and 46 are hard to read, and Monday's 35 is gold on gold. Every evening dot is hidden under its number, so a red dot at 80 or more would never be seen. The test only checks each number's centre x.
Fix: Line 196: `l.position = Vector2(cx - l.size.x * 0.5, cy - l.size.y - 8.0)` so the number sits above its dot. In `_draw`, after the curve, draw a dark plate behind each number (`draw_rect(l.get_rect().grow(3), Color(0.08, 0.07, 0.06, 0.92))`, the colour main's peak box used). Line 133: keep WoodKit.INK for the selected day. Re-render the still.

### [fix_at_collect] The danger words and "32 under the line" are struck through by the dashed line
File: scripts/ui/WeekTired.gd:175
What: `_danger` (line 175) and `_under` (line 178) are centred vertically on `_y(80)`, and `_draw` paints the 2.5 px red dashes and the hatch across the full width (lines 320-326), straight through both labels.
Failure: In the still "80: too tired, injuries rise" reads as crossed-out red text on a red line, and "32 under the line" has the dashes through it. The test asks only that the label centre is within 14 px of the line, so it passes.
Fix: In `_draw`, right after the dash loop, paint a dark plate behind both labels: `for l in [_danger, _under]: if l.visible: draw_rect(l.get_rect().grow(4), Color(0.08, 0.07, 0.06, 0.92))`. The labels stay on the line and the test still passes.

### [fix_at_collect] A high Monday or Sunday number is pushed below the 80 line by the line's own label
File: scripts/ui/WeekTired.gd:200
What: The danger label spans local x 40..285 and Monday's column centre is about x 124 (result page rects), so Monday's number hits it whenever Monday evening is roughly 65 to 95. The fallback loop tries downward first (`for dir in [1.0, -1.0]`) in 4 px steps until clear. "N under the line" on the right does the same to Sunday at about 65 to 79.
Failure: A Monday evening of 85 is printed about 24 px under the red line, at the height of a value near 64, on the one day the strip exists to warn about. Nothing in the test checks a number's y. Not seen in the still (its week tops out at 48); this is from the code and the printed rects.
Fix: Line 200: try up first (`[-1.0, 1.0]`) and skip any step that would carry the number across `_y(80.0)` to the wrong side of the line. Or leave `_danger` and `_under` out of the numbers' blockers once they have plates (line 181).

### [fix_at_collect] A day at 79.5 to 79.9 prints "80" in plain ink with "0 under the line"
File: scripts/ui/WeekTired.gd:126
What: The text uses `roundi` (lines 126, 132, 143) but the red colour, the red dot and `_reaches_80` compare the raw float to 80.0 (lines 133, 148, 346).
Failure: With a peak of 79.6 the strip says "peaks ... at 80", prints a non-red 80 beside the label "80: too tired", draws a non-red dot and shows "0 under the line".
Fix: Display with `floori` instead of `roundi` on lines 132, 143 and 157-158, and make the gap `ceili(80.0 - peak)`. 79.6 then reads 79 and "1 under the line".

### [fix_at_collect] Mastery numbers stand bare and their tooltips cannot open
File: scripts/ui/WeekEditors.gd:269
What: `UI.label` sets MOUSE_FILTER_IGNORE (UI.gd line 270) and `_fixed` never changes it. So the tooltips on DrillMastery (line 289), DrillName (285), DrillWord (292) and the header's PadMinutes (184) can never show. Other screens set MOUSE_FILTER_PASS on labels that carry a tooltip. The name and word tooltips were already dead on main; this branch adds two more.
Failure: In the still "27", "0" and "19 → 27" have no word saying they are mastery, and the tooltip that would say so is unreachable.
Fix: In `_fixed` add `l.mouse_filter = Control.MOUSE_FILTER_PASS`, and the same for `unit` at line 183. A 22 px "Mastery" caption over the column is the alternative if a visible word is wanted.

### [fix_at_collect] The bottom row with Start week is cut off the screen in the still
File: scripts/ui/WeekEditors.gd:314
What: Each "Held at 48 by the Cross" line with its button (`_held_line`, unchanged by this diff, from WEEKTESTS1) adds about 53 px to the evening editor. With two of them the editor's Combo bar ends near y 1030 and the row under the editors is pushed past 1080. This branch did not cause it: merging "240" into the header saved about 45 px.
Failure: In the still the coach line, Do it, Leave and Start week show only their top 15 px at the bottom edge. In the S428 still (ops/Feedback/2026-11-11-05/original.png) the same row sat fully visible at about y 1005 to 1050. The page's main button cannot be read at 1920x1080 in this state.
Fix: Outside this brief's ask, but it must not reach the operator like this. Smallest: put the held words on the row itself (in place of the mastery word) with "Drill the Cross" replacing the row's "Drill" button. Or wrap the tray in a ScrollContainer with a fixed maximum height. Then re-render.

### [note] The 80 line is typed by hand in eight places; the rule has a constant
File: scripts/ui/WeekTired.gd:74
What: `WeekPlan.OVERREACHED := 80.0` and `TIRED_GAIN := 0.6` exist (WeekPlan.gd lines 77-78; WeekPlan calls 80 "an ESTIMATE, playtest it"). WeekTired writes 80 at lines 62, 74, 126, 133, 148, 169, 318 and 346, and "60%" at line 75. Main also hard-coded it, but in two places.
Failure: If the threshold is tuned, the label, the red dots, the line's height and "N under the line" all keep saying 80.
Fix: `const WeekPlan := preload("res://scripts/rules/WeekPlan.gd")`, `const LINE := WeekPlan.OVERREACHED`, and build the label as `"%d: too tired, injuries rise" % int(LINE)`.

### [note] Hover shows the same sentence twice; three tooltips in the strip are dead
File: scripts/ui/WeekTired.gd:260
What: `_show_hover` fills the in-strip HoverRead label and also sets the strip's own `tooltip_text` to the same text (line 260), so the engine tooltip opens beside it. HoverRead has no backing and is placed over the curve. The DayNum tooltips (line 135) and `_danger.tooltip_text` ("From 80 a morning trains at 60%.", line 75) sit on MOUSE_FILTER_IGNORE labels and never show.
Failure: Hovering a day shows "Morning 30, evening 35" twice, one copy possibly crossed by the curve. What 80 does to training is unreachable (it was on main too). Not visible in the still; from the code.
Fix: Keep one: drop line 260, give HoverRead a plate in `_draw`, and add "From 80 a morning trains at 60%." as a second line of that hover. Delete the dead tooltip lines.

### [note] Leftover lines that do nothing
File: scripts/ui/WeekEditors.gd:238
What: `_split` is now called only with two or more entries (line 200), so its `entries.size() < 2` branch (lines 238-242, a second node named PadMinutes) is unreachable. `head.alignment = ALIGNMENT_END` (line 172) and `h.alignment = ALIGNMENT_CENTER` (line 280) act along the row's width, and each row has an expanding spacer, so they have no effect. The vertical alignment comes from the SHRINK_END / SHRINK_CENTER flags.
Failure: No visible fault; it misleads the next reader into thinking the header is baseline-aligned by that line.
Fix: Delete lines 238-242, 172 and 280.
