# TASK MENUMONEY2 - CURSOR (Grok 4.7 High) - the Money page, round 2: the bills bug and the fit

Status: OPEN (S405, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.
BASE: cursor/menumoney1

## Contract
OWNS: scripts/rules/CashForecast.gd, scripts/rules/WeekRead.gd, scripts/ui/areas/Money.gd, scripts/ui/areas/ClubSpend.gd, scripts/ui/CashChart.gd, scripts/ui/MoneyTags.gd, scripts/ui/MoneyPanels.gd, scripts/ui/AreaHead.gd, tests/menu_money_test.gd, tests/cash_forecast_test.gd
RED_TEST: tests/menu_money_test.gd -> MENU_MONEY failures=0
REGRESSION: cash_forecast_test, week_read_test, kit_icon_test, game_money_test, money_close_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/money.html and money.png (the spec), and PR #97's page on your BASE.

## Prior research
Round 1 is PR #97; Claude rendered it at 1920x1080 on day 40 (a Saturday) and compared it with the mockup. Your tests passed because they looked at a Monday and never measured height.

## What would a human do?
A gym owner opening the books on a Saturday expects the same answer as on Monday, and expects the whole page on one screen.

## Prefab check
Nothing new: this round fixes round 1.

## Faults, in order

### 1. Mid-week the forecast has no bills (a real bug)
`CashForecast.project` does `copy.day += 7` from today. `GameMoney.is_bill_day` needs `day % 28 == 0`. From day 40 the steps are 47, 54, 61: never a bill day. Round 1's page shows "Next bills Mon 5 Jan, $0" in week 6, the chart climbs to $24,513 while the page says net -$325 a week, and "grows in hand" sits beside it.
- Start the steps from the week boundary: the first step lands on the next multiple of 7 (day 40 goes 42, 49, 56). Sim ends a week on those days.
- `WeekRead.runway` has the same fault (`day + 7 * w`): fix it the same way. A call made on a boundary day must return exactly what it returns today.
- `bill_split` must never show day 0 or $0 when a bill is coming inside the forecast. Extend the forecast if needed so the next bill is always found.

### 2. The page must fit 1920x1080 with no page scroll (rule 8)
Today the board runs off the bottom and the chalkboards are below the fold.
- The Club heading and its tabs take about 120 px. Put CLUB and People, Money, Records on one row of at most 48 px on this page.
- With the first-week guide strip hidden, the page's content height must be at most the visible height: nothing scrolls.
- Price tags: each at most 130 px tall, 2 columns, as in the mockup. Round 1's are about 165 px with empty space inside.
- "Fighters and money" scrolls inside its own panel.
- The two chalkboards (Dues, Kit budget) sit under the price tags, as in the mockup, on screen.
- 1280x720 may scroll the page but nothing overlaps.

### 3. Chart
The numbered events are missing. Numbered circles on the line for each known event inside the forecast (bills, purses already booked), and the numbered list under the chart, as in the mockup. Gridlines with $ labels, the $0 line red and dashed, a Today marker.

### 4. Tags
Pins sit at the card's top-left corner, as in the mockup, not at top-centre.

## Do
1. Add to the tests FIRST, on your BASE; they must fail there:
   - cash_forecast_test: from days 40 and 41 the forecast holds a bill on day 56 with amount > 0, and the cash on day 56 matches what Sim really does when you play to that day.
   - week_read_test: `runway` from day 40 with net negative returns weeks >= 0, not "grows". From a boundary day it is unchanged.
   - menu_money_test: from a mid-week day, the page's next bill date is after today and its amount is > 0; with the guide strip hidden, the page's content height <= the visible height at 1920x1080; the chalkboard panels are inside the visible rect; every price tag is <= 130 px tall; the chart has one numbered mark per event in the list.
2. Fix inside OWNS. Files under 500 lines.
3. Run REGRESSION. Do not edit an existing test's numbers.

## Rules for this seat
Godot only through godot_slot, headless, `--audio-driver Dummy`. Parse check before any test. Nothing opens on the owner's monitors. You cannot see images: name panels and measure rects in the test.

## PR body
`RESULT: tests/menu_money_test.gd -> MENU_MONEY failures=0`, one RESULT line per REGRESSION test.

## The one trap
Headless windows may report a different size. Set the root size to 1920x1080 in the test before measuring, or the height check proves nothing. A change to AreaHead must leave every other area's heading exactly as it is: do it with an argument used only by Money.
