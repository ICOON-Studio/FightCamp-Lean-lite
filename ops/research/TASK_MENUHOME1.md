# TASK MENUHOME1 - CURSOR (Grok 4.7 High) - the Home page, built from the approved mockup

Status: OPEN (S405, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/areas/Home.gd, scripts/ui/HomeMatch.gd, scripts/ui/HomeNeeds.gd, scripts/ui/HomeRows.gd, scripts/ui/HomeSide.gd, scripts/ui/HomePanels.gd, tests/menu_home_test.gd
RED_TEST: tests/menu_home_test.gd -> MENU_HOME failures=0
REGRESSION: home_look_test, home_row_injured_test, kit_icon_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/home.html and home.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's page: scripts/ui/areas/Home.gd with the four Home*.gd files.

## Prior research
`python ops/Tools/prior_research.py home monday needs`. Operator S275: nothing opens by itself. Operator S398: only what the player can act on. Critic round 4: Home scored 7.

## What would a human do?
A gym owner walks in on Monday and asks: who needs me today, who fights next, how is everyone, and is the gym all right.

## Prefab check
WarmKit and KitIcon exist. Nothing new to find.

## Build
1. Needs you, and Can wait, as two groups: each row one line, one button that goes where the answer lives. The week review is a Can wait row with Open. It never pops up by itself.
2. Next fight card: name, rules, opponent, date, win chance as the game already reads it, and a Fight prep button.
3. Your fighters table: filter chips All, Need me, Camp, Injured, Free; columns as the mockup; a state icon per row from KitIcon; freshness bar with the reason in its tooltip; This week; one action per row.
4. Since last Monday: at most the mockup's count of lines, each with its cause and one action. All news and mail is the link under it.
5. The club: members, break-even in the tooltip, reputation, bills, Open the books.
6. Coming up: dated list.
7. The table scrolls inside its panel when the roster is long.

## Do
1. tests/menu_home_test.gd FIRST, printing `MENU_HOME failures=<n>`, on a real career (`main.act("quick")`). It must fail on main. Cover: panels exist by name; no modal is open when Home first shows after a week ends; each Needs you row's button reaches a real page; the filter chips change the row count; cash and members equal the top bar and Career.
2. Build inside OWNS. Split a panel into scripts/ui/HomePanels.gd rather than growing a page.
3. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_home_test.gd -> MENU_HOME failures=0`, one RESULT line per REGRESSION test, the not-built list, and what moved.

## The one trap
The week review has to stay reachable: once it stops opening by itself, the first week's guide and first_week_test still have to find it. Read FirstWeekStrip.gd and first_week_test before moving it.
