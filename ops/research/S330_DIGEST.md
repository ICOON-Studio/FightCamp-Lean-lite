# S330 digest - Lean update 32: HOME and FIGHTERS as pictures (2026-11-01, same session as S329, operator: "Keep going here")

## Board
- No answers yet to Q-S294-47 / 48 / 49 (updates 29, 30, 31). They stay open beside the update 32 question.

## What now works (Lean main, exported as update 32)
- MENULOOK1, first step, from the operator's C150 note on a page of rows ("can be improved"):
  - `scripts/ui/FighterTile.gd` (new): a fighter as a card - name, record in the display font, rank + mood chips (mood
    tooltip = why it moved), four `NeedRing`s: WEIGHT (to her limit; amber/red over), CONDITION (100 - fatigue), GOAL
    (days left, filled by Sim.goal_read share, coloured by its status), NEXT BOUT (days to go, the ring filling over the
    last 42 days; red OUT with the injury line when she is out); the season line (Champs.home_line) under them.
  - HOME (`Home.gd`): YOUR FIGHTERS = tiles; new card THE NEXT 4 WEEKS = `WeekStrip.gd` (28 days from today, week bands
    with Monday dates; markers for her bouts, weigh-ins, championship dates and the month's bills with an estimate =
    owed so far + this week's costs x weeks to the bill day; labels stack and sit on a backing so no stem crosses a word);
    the money card carries the CashChart of the last 8 weeks (`CashChart.height`, 120 on HOME).
  - FIGHTERS > Roster: the 8-column table became tiles, two to a row (`Roster` grid; tiles `Tile_<id>`).
- `tools/pages_now_still.gd` renders HOME, FIGHTERS roster/training and her page from the nationals jump career.

## Decisions (developer)
- Rings, not bars, for the tile: four values read at a glance side by side; the same NeedRing as the Nationals page,
  so the pages share one picture language (road, ring, bracket, timeline).
- No body portrait on the tile: the baked portraits are keyed to the 3D model chosen at fight time, which the pages do
  not know; a wrong body is worse than none.
- Week reviews left off the timeline (one every Monday cluttered it; the Monday dates already mark the weeks).
- Stopped after HOME + roster to ask him whether this is the look for every page before converting GYM, MONEY, FIGHTS
  and the fighter page (taste call).

## Defect fixed
- injuries_test's fights-hurt case ran on a random career seed; the bout's own injury roll (InjuryRoll.bout_roll on
  c.seed) added a fresh fight injury about 1 run in 12 (until_day 51 vs 47) and turned the first update 32 export red.
  The case now fixes h.seed = 1 (5/5 green); the game logic was right.

## Evidence
- golden_path_test (roster tiles Tile_lucy/Tile_kira, Mood_kira chip word), test_jump_test, champs_test PASS; full suite
  via export.sh (see the Lean log); stills before/after in S330_stills/ opened and checked (now_* vs new_*).
