# TASK MENUMONEY1 - CURSOR (Grok 4.7 High) - the Money page, built from the approved mockup

Status: OPEN (S403, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/areas/Money.gd, scripts/ui/areas/ClubSpend.gd, scripts/ui/CashChart.gd, scripts/ui/MoneyTags.gd, scripts/ui/MoneyPanels.gd, scripts/rules/CashForecast.gd, tests/menu_money_test.gd, tests/cash_forecast_test.gd
RED_TEST: tests/menu_money_test.gd -> MENU_MONEY failures=0
REGRESSION: cash_forecast_test, kit_icon_test, game_money_test, money_close_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/money.html and money.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's page: scripts/ui/areas/Money.gd, ClubSpend.gd, CashChart.gd.

## Prior research
`python ops/Tools/prior_research.py money books`. S400: an earlier Money page was reverted because it was not from an approved mockup, so follow this one and add nothing. S397: money must keep mattering.

## What would a human do?
A gym owner opens the books on a Monday and asks three things: how long the cash lasts, what is coming, and what is worth buying now.

## Prefab check
WarmKit, KitIcon, CashChart already exist. Nothing new to find.

## Build
1. Header row: cash, members of places (break-even in its tooltip), runway weeks, net a week, next bills date and amount. Tabs: The books, Cashbook. The two ledger lists move to Cashbook, with the repairs (`_facilities`) as a third section there (rule 6).
2. Chart: past weeks, then 8 weeks forward dotted, numbered known events. New pure `scripts/rules/CashForecast.gd`, using the game's real billing. It must agree with what `Sim` will really charge: test that by playing 8 weeks and comparing.
3. In a week and Out a week lines, from `Sim.weekly_income` and `Sim.weekly_costs`, each column summing to its total, a Stipends line, then the circled net.
4. Price tags on a board: what fits now first (pure rank in a function with a test: affordable and earning first, then cheaper, grey ones last). Each tag: picture icon, price, one line of effect, `runway` icon with weeks after, payback where it earns. Grey with reason and no red pin when it cannot be bought or would not help (a full gym). The tags are today's ClubSpend items. A cage is not built.
5. Fighters and money: every fighter on the books, stipend state, what the fighter earns the gym, next money.
6. Right column: Contract talks (one line each, Open the talk, the answer lives elsewhere), Coaches (not built: one header mark, disciplines, moves, faces of who it helps), the bills, sponsors, staff.
7. Chalkboards: dues bands with their weekly effect, Cheap grey when full; kit budget.

## Do
1. tests/menu_money_test.gd FIRST, printing `MENU_MONEY failures=<n>`, on a real career (`main.act("quick")`). It must fail on main. Cover: panels exist by name; In and Out rows sum to the totals shown; the top bar's cash equals the page's cash; the first tag is one the gym can afford and the worst is last; a greyed tag has a reason and no pin; Coaches header has the `warn` icon and its buttons are disabled; every action on today's page is still reachable.
2. Build inside OWNS.
3. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_money_test.gd -> MENU_MONEY failures=0`, the not-built list, and what moved.

## The one trap
`c.accrued` and the monthly bill: the forecast must not count a week's costs twice. Read `GameMoney` and `Sim` before writing it.
