# TRAININGB2 - the curve says what it is, and the pads list is a table

Still: `docs/mockups/s429/trainingb2/23e_training_tab_real.png` (hidden desktop, 1920x1080, nothing on a monitor).

## What each mark asked

1. Pads list (the box on the right): the punch names sat on the left and the mastery, the word, and the + / Drill / − controls sat about 800 px away, so a row did not read as one row. The bare number under the title had no unit. ("What raw means?" is already fixed on main: under 30 the word is Learning.)
2. The curve strip above the seven days: a line, dots, a dashed red line, a shield, and the numbers 80 and 48, with no title, no day, and no words for what 80 means. The dots did not read as the days underneath.

## What changed

- The strip is titled "Tiredness this week", with the peak beside it in words from the curve's own points ("peaks Wednesday evening at 52" on Lucy's camp week). Each evening number sits on that day's card. The line at 80 reads "80: too tired, injuries rise". A dot at 80 or more is red. When nothing reaches 80, the right side says how far the peak is under it ("28 under the line"). Hovering a column shows that morning and that evening. The strip stays 220 px tall.
- The pads header is the glove, "Pads", and "240 min tonight" on one row. Each drill is one row: name (same left edge as the glove), mastery now and after tonight (or the number alone when tonight does not move it), the word (Learning, New, ...), then + / − / Drill at the right. The "Held at N by the ..." line stays under its row, on the name column. DropDrill, DrillIt, Held, and Drill_<card> are unchanged.

WeekBoard.gd was not grown. The new drawing is in WeekTired.gd. WeekTiles.gd was left as it is: the strip reads the day tiles' rects.

## Rects the test printed

Curve, Lucy's camp week before any edit (1804 x 220):

- title "Tiredness this week" 28px `[P: (66.0, 224.0), S: (248.0, 34.0)]`
- peak "peaks Wednesday evening at 52" `[P: (330.0, 225.0), S: (365.0, 32.0)]`
- danger "80: too tired, injuries rise" centre y 301.6, line y 301.6, off 0.0 `[P: (98.0, 288.1), S: (245.0, 27.0)]`
- "28 under the line" `[P: (1691.0, 288.1), S: (161.0, 27.0)]`
- day numbers, centre x on the day card (off 0.0): 45 at 181.7, 46 at 441.1, 52 at 700.6, 50 at 960.0, 47 at 1219.4, 45 at 1478.9, 37 at 1738.3

Pads editor, after the week test's rest click and back on the pads night:

- "240 min tonight" `[P: (984.0, 612.0), S: (182.0, 32.0)]`
- glove `[P: (829.0, 595.0), S: (48.0, 48.0)]`
- Drill_combo_1-1 name `[P: (829.0, 663.0), S: (88.0, 29.0)]` mastery `[P: (929.0, 663.0), S: (77.0, 30.0)]` gap 12, column 100
- Drill_combo_1-2-3 name `[P: (829.0, 772.0), S: (88.0, 29.0)]` mastery `[P: (929.0, 773.0), S: (77.0, 27.0)]` gap 12, column 100
- Drill_combo_1-2-3-2 name `[P: (829.0, 879.0), S: (88.0, 29.0)]` mastery `[P: (929.0, 880.0), S: (77.0, 27.0)]` gap 12, column 100

Names start at the glove's left edge. The mastery column is the same x on every row.

## Pass lines

```
RESULT: tests/week_b_test.gd -> WEEK_B failures=0
RESULT: tests/drill_card_test.gd -> DRILL_CARD PASS
RESULT: tests/hover_ghosts_test.gd -> HOVER_GHOSTS PASS
RESULT: tests/plan_tray_test.gd -> PLAN_TRAY PASS
RESULT: tests/week_slate_test.gd -> WEEK_SLATE failures=0
RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0
RESULT: tests/no_pronoun_test.gd -> NO_PRONOUN failures=0
```

## S432 collect (Claude, by diff, with the S431 review's fixes: ops/research/TRAININGB2_REVIEW_S431.md)
- Numbers sit above their dots on dark plates (never on the dot or the curve); a number under 80 never sits above the line.
- The line's words ("80: too tired, injuries rise", "N under the line") sit just over the dashes: never struck through.
- One reading: words floor the value (79.6 reads 79, "1 under the line"); red from the raw value; LINE = WeekPlan.OVERREACHED.
- Hover: one read-out on a plate, with "From 80 a morning trains at 60%"; the dead tooltips went; label tooltips can open.
- The "Held at 48" line and its "Drill the Cross" button sit ON the drill's row: two held drills no longer push the
  bottom row (Do it, Leave, Start week) past the 1080 edge (a fault already on main since WEEKTESTS1).
- week_b_test: numbers checked against the plan (WeekBoard.tired_days), peak and "under" against the week's top, each number
  off its dot, Start week whole on the screen; the column_center tautology removed.
- Tests: WEEK_B failures=0, DRILL_CARD PASS, HOVER_GHOSTS PASS, PLAN_TRAY PASS, EVENING_EDITS PASS, WEEK_SLATE failures=0.
- Still: docs/mockups/s432/trainingb2_23e_real.png (hidden desktop, 1920x1080, opened and read).
