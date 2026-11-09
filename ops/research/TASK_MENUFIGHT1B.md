# TASK MENUFIGHT1B - CURSOR (Grok 4.7 High) - Fight night's corner and result, built from the approved mockup

Status: OPEN (S411 re-brief, Claude main). Discipline: boxing now, MMA parts drawn as not built. Model: grok-4.7-high.

## Contract
OWNS: scripts/ui/modals/FightNight.gd, scripts/ui/FightCornerPage.gd, scripts/ui/FightResultPage.gd, scripts/ui/Broadcast.gd, scripts/ui/ReadPanel.gd, scripts/ui/CallButtons.gd, scripts/ui/CornerJobsRow.gd, scripts/ui/WhyCard.gd, tests/menu_fight_test.gd
RED_TEST: tests/menu_fight_test.gd -> MENU_FIGHT failures=0
REGRESSION: fight_flow_test, fight_why_test, corner_card_test, corner_jobs_test, corner_stats_test, corner_trust_test, kit_icon_test, first_week_test, golden_path_test, save_load_test, plain_words_test, no_pronoun_test
VISUAL: stills, opened by Claude after landing

## Read first
ops/research/MENU_BUILD_RULES.md (binding), docs/mockups/s403/fight_night.html and fight_night.png (the spec), scripts/ui/WarmKit.gd, scripts/ui/KitIcon.gd, and today's FightNight.gd with the files listed in OWNS.

## Prior research
`python ops/Tools/prior_research.py corner minute fight result why`. Operator S396, on the corner and the result: "we can keep and improve" (big why numbers, big next-step button, costs visible, fewer tiny choices). Critic round 4: Fight night scored 7; its corner minute was overloaded in round 3 and has been cut since.

## What would a human do?
In the corner a coach has a minute: look at the fighter, pick at most two fixes, say one thing, send the fighter out. After the bout the coach wants to know why it went that way and what to drill next.

## Prefab check
WarmKit, KitIcon, RoundGraphics, FlowView exist. Nothing new to find.

## Build: the corner page
1. Top line: Fight night, corner clock, round of rounds, Throw in the towel.
2. Both fighters' faces and records, the round's verdict and your card's score, the opponent's read as one line.
3. Where the fight is, and last round: damage by body part, energy, what lands. Control and position rows belong to the ground game: draw them not built.
4. In the corner: fixes, pick up to two, with the used counter: Habit, Plan, Talk. Each option shows its effect from the game's own rules.
5. Recover: the free jobs row as today. Cutman choices stay where the game has them today; the mockup's cutman card arrives with row R28, so draw it not built.
6. Once the round starts: position calls, Pace, Aim, Say nothing. One big button: Start round N with this plan.
7. The "she has adapted" line arrives with row R25: draw it not built, never a made-up sentence.

## Build: the result page
1. The decision and the three judges, both records.
2. Why: heading from FightWhy's grade; Your plan, Against you, What decided it, Next, each from `FightWhy.read` with no new rule here. One big next-step button.
3. Body report and injury line as the game has them today.
4. Round by round score table, The plan lit up with each line's score, See the flow, Back home.
5. The floor-game line is drawn not built for a boxing bout.

## Do
1. tests/menu_fight_test.gd FIRST, printing `MENU_FIGHT failures=<n>`, on a real career (`main.act("quick")`) playing one bout to its result. It must fail on main. Cover: panels exist by name on both pages; a third fix cannot be picked; the judges' totals equal the round table's sums; each Why field shows the text `FightWhy.read` returns; every action on today's page is still reachable.
2. Split the corner and result pages into scripts/ui/FightCornerPage.gd and scripts/ui/FightResultPage.gd. FightNight.gd stays the shell.
3. Run REGRESSION. Do not edit an existing test's numbers.

## PR body
`RESULT: tests/menu_fight_test.gd -> MENU_FIGHT failures=0`, one RESULT line per REGRESSION test, the not-built list, and what moved.

## S411 UPDATE: the look, and fewer words (operator Q-S294-135: "Yes, but with fewer words and bigger pictures, like Fighters")
This section overrides the faults above wherever they disagree. Read MENU_BUILD_RULES items 14-22 first. Worked examples on main: scripts/ui/RosterCards.gd (the Fighters cards), scripts/ui/VersusPanel.gd (the versus screen). Measure with `tools/page_ink.gd`: `const PageInk := preload("res://tools/page_ink.gd")`, `PageInk.read(root)`, at 1920x1080 with the guide off (`c.guide = ""`).
Your test prints one line: `FIGHT_INK words=<n> pictures=<p> tallest=<h>` and fails if a bar below is missed. No bar may be met by cramming: nothing runs past 1080 px and text stays 16 px or more (14 only inside a tile).

BARS, each read on its page: CORNER words <= 130, tallest >= 600 px. RESULT words <= 100, tallest >= 700 px. Both pages end above 1080. Print one FIGHT_INK line per page.
Do this on the versus screen's model (scripts/ui/VersusPanel.gd), with `MenuFx.set_wall(main, VersusPanel.BACKDROP)`.
CORNER: both boxers stand on the page, one each side, facing in (`RosterCards.body`, `VersusPanel.kit_stem`), so the choices sit between them. The second's points are one line under 12 words. ONE CHANGE is the only row of big cards: an icon, two or three words, the effect on hover. Set-up, Talk, Recover and Cutman fold behind one "More" with the coach's defaults kept. Damage reads off the two bodies: the body read's numbers sit by each figure, no table. Control and position rows are not built: one line with the triangle, or left off if there is no room.
RESULT: the winner stands large (at least 700 px), the loser smaller. The decision in the brush font, the three judges as three tiles. WHY is the heading plus one line and the one big next-step button. Your plan, Against you, What decided it are on hover of that panel, or behind Full report with the round table, the plan lit up, See the flow and the body report. All the FightWhy.read text stays reachable and each field is still tested. Keep the order of calls from the one trap below.

## The one trap
FightNight.gd drives the 3D fight's beats through `build()` and `Broadcast.frame`. Move the drawing and leave the order of calls alone, or golden_path passes while the live fight shows the wrong page: the fight must still reach the corner page after each round when played with a picture.

## Update S406: ONE CHANGE is built
The corner's fix row is now ONE CHANGE (scripts/rules/Adaptation.gd; card["adapts"], CallButtons.fix_row). Keep that one slot and its numbers: Elbows in, Gloves high, the habit fix, Leave it. Where the mockup says Fix, draw ONE CHANGE. Fold Set-up and Talk behind one "More" line with the coach's default kept: the minute should read the second's points, ONE CHANGE, the plan. tests/adaptation_test.gd joins REGRESSION.
