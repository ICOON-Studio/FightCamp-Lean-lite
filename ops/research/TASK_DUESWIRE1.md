# TASK DUESWIRE1 - CURSOR (Grok 4.7 High) - the dues choice and the youth section show on every menu they touch

Model: Grok 4.7 High
Discipline: boxing (the demo).

## The operator's words (S430)
"you added the youth picture on the board , but have you implemented the mechanic accross all menus properly ?"
Answer today: no. The three painted price boards exist (Club > Money > Dues, `scripts/ui/DuesBoards.gd`), the price moves
members and money (`scripts/rules/Membership.gd`), and it sets the chance a junior passes a trial
(`Membership.intake_chance`, read by `scripts/state/HomeJuniors.gd`). The other menus of the design map
(`ops/research/DUES_DESIGN_MAP_S423.md`, "Where it happens") were never built, and no test walks the mechanic end to end.
His rule (S425): a mechanic is done only when every menu it appears on shows it in the .exe and one golden-path test
walks it.

## Contract
OWNS: scripts/ui/modals/WeekReview.gd (one new block only), scripts/ui/areas/Home.gd, scripts/ui/HomeNeeds.gd (one row, in whichever of the two draws the needs rows),
scripts/ui/areas/Money.gd (the month's report line only), scripts/state/HomeJuniors.gd (the words of its lines only, no
number), tests/dues_wire_test.gd (new), tests/golden_path_test.gd (one added step), docs/DUESWIRE1_RESULT.md (new)
RED_TEST: tests/dues_wire_test.gd -> DUES_WIRE failures=0   (red on main first: paste both runs)
REGRESSION: dues_card_test, golden_path_test, words_on_screens_test, no_pronoun_test, plain_words_test, home_look_test
VISUAL: yes
Run one test: `python ops/Tools/godot_slot.py run --who cursor -- "%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`
Parse first: the same command with `--check-only --script res://<file>`. No script over 500 lines (WeekReview.gd is long:
put the new block in a small new file under scripts/ui/ if it would pass 500).

## Build, one menu at a time (each a picture and a number, words on the hover; no paragraphs; no text under 20 px)
1. WEEK REVIEW (Monday), on the week a junior asks for a trial: a card with the junior's face slot, "Came up through the
   youth section", the pass chance as a number with the dues board's own picture for the price in force (cheap: 1 in 2,
   standard: about 1 in 3, premium: 1 in 5; read the numbers from `Membership.intake_chance`, never type them), and the
   result (passed: on trial / not this time). The player must see the price choice pay or cost.
2. HOME: one row two weeks before each intake (January and September): "Juniors' trial in 14 days: 1 in 3 at today's
   dues", with one button that opens Club > Money > Dues. No row when there is no youth section.
3. CLUB > MONEY, the month's report: the dues line carries the mark of the price in force (the same small picture as the
   board in force) and, on the month a change takes effect, "from this month: Cheap" with the members it brought or lost.
4. THE DUES BOARDS: each board's "home-grown boxers in 5 years" number links to the next intake date ("next trial: 5
   January"). Without a youth section the number reads 0 and the hover says how to open one (Club spending).
5. GOLDEN PATH: one added step in `tests/golden_path_test.gd`: open the Dues tab, pick another price, advance to the month
   start, see the change in force, and reach one intake with its week-review card.

## Not in this task
The numbers. Premium still earns most in 9 of 9 clubs tested (S424, the design map's last section): that is a rules task
with its own measurement, and it comes after John's research on what funds a cheap community club. Change no number here.

## Stills
Cursor cannot see pictures: Claude renders and reads the real screens at collect. Give exact rects of every new control at
1920x1080 in the result page and assert in the test that none overlaps or leaves the screen.

## Prior research
`python ops/Tools/prior_research.py dues juniors youth intake` first. `ops/research/DUES_CHOICE_S422.md`,
`ops/research/DUES_DESIGN_MAP_S423.md`, `tests/dues_card_test.gd`.

## What would a human do?
A club owner who cuts the dues to fill the kids' class waits for the first lad to come through and wants to be told it was
the cheap dues that did it. Show the cause where the effect lands.

## Prefab check
Nothing to fetch: the boards' pictures and the juniors' lines are in the repo.

## The one trap
A test that calls the rules and never opens the screens proves nothing here: walk the real Home, Money and Week review
through `Main.act`, the way `tests/golden_path_test.gd` does.

End the PR body with `RESULT: tests/dues_wire_test.gd -> DUES_WIRE failures=0`.
