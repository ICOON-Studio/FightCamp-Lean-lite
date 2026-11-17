# TASK ASKDATES1 - Ask for a fight: two shows side by side, what each date leaves time for, why a card is missing

Status: OPEN (S512, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Contract
OWNS: scripts/rules/AskDates.gd, tests/ask_dates_test.gd
RED_TEST: tests/ask_dates_test.gd -> ASK_DATES failures=0
REGRESSION: ask_bout_test, fight_learn_test, fight_week_test
VISUAL: no

## Prior research
Map v4: `ops/research/ASKFIGHT_CRITIC_S511_BRIEF.md` (sections 2-7). Round-4 critics, both 7/7:
`ops/research/ASKFIGHT_CRITIC_S511_DOLA.md` and `ops/research/ASKFIGHT_CRITIC_S511_GOOSE.md` - their shared first change is
the one this task builds: show the next TWO club shows side by side (the soonest = fight week only, the next = full prep).
Owner: "Yes, build it" (S512).

## What would a human do?
A coach picking a date asks: how many days do I get, can we spar, can we watch film, can the week before be used?
Each date answers that in plain checkmarks; the coach picks the trade.

## Prefab check
None: game rules over the game's own constants.

## The job: NEW `scripts/rules/AskDates.gd` (pure, static funcs, no class_name, under 300 lines)
Preload only rules modules: `scripts/rules/AskBout.gd`, `scripts/rules/FightWeek.gd`, `scripts/rules/BoutRules.gd`,
`scripts/rules/FighterProfile.gd` (read them first). NEVER hardcode a number the game has as a constant: read it.
1. `shows(day: int, show_days: Array, taken_by_ours: Array, fmt: Callable, count: int = 2) -> Array` - the next `count`
   club shows a fighter can be asked onto: the first show whose days away >= BoutRules.CAMP_MIN_DAYS (a fight week fits),
   then the following ones. Each: {day, days_away, date_words (fmt.call(day)), holder (the name of ours already on that
   night, "" if free - reuse AskBout's holder logic), prep (item 2)}. A night held by one of ours is still listed, with the
   holder, so the screen can say why.
2. `prep(away: int) -> Dictionary` - what the date leaves time for, from the fight-week rules (read FightWeek.gd and
   scripts/state/FightWeekPlan.gd for WHEN_WEEK_BEFORE / SPAR_WEEK_BEFORE_DAYS / SPAR_READY_MAX, and how a film evening is
   placed in the fight week - grep FilmNight / evenings): {fight_week: bool, week_before: bool, spar_nights: int (most
   that fit), film_evening: bool, camp_words: AskBout.camp_words(away), checks: Array of {words, on} in this order:
   "Fight week", "A sparring night the week before", "Sparring nights: N", "A film evening"}. Words plain, no numbers
   the player can sort by except the night count.
3. `absent(f: Dictionary, rows: Array, next_in_turn: String, min_wins: int) -> Array` - for each answer AskBout.answers
   does NOT return, {kind, why}: sheet -> "No name on the sheet is legal for this fighter now."; step_up -> "Nobody with a
   better record inside the novice rule." (ranked: "Nobody above on the ladder is free."); name -> "Names open at <N> wins
   (now <w>)." when not on the ladder (N = min_wins), else "No other legal name up to <PICK_REACH> places above or level.".
   Match AskBout.answers' own rules exactly (call it; never re-implement legality).
4. `trade(kind: String) -> Array` - the record trade as words from the game's constants (find where a win/loss moves
   members and reputation: BoutRules / FighterProfile / Membership): e.g. "Win: +8 members, +5 reputation", "Loss: -1
   member", "Stopped: 2 members, 30 days out". And `wait_words() -> String`: "Wait for the sheet: likely in 2 to 4 weeks,
   date unknown. A month without a fight costs morale (<FighterProfile month_no_fight>)." - read every number.
Game text never says he, she, her or him.

## Do
`tests/ask_dates_test.gd` (extends SceneTree; prints `ASK_DATES failures=<n>`; quit(1) on any failure): shows() at day 0
with shows every 14 days from day 3 -> the first is day 17 when 3 is under CAMP_MIN_DAYS... (work the real numbers);
a held night lists its holder; prep() at 6/7/8/14/21 days matches FightWeek's rules (check each against the constant,
not a literal); absent() for an unranked 1-0, a ranked fighter with nobody above free, and a fighter at min_wins-1;
trade() numbers equal the constants they come from. Prove the test bites: two mutants (break prep's week_before
threshold; drop a holder) must turn it red - say so in the PR body.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/ask_dates_test.gd` and the
REGRESSION tests. PR body: `RESULT: tests/ask_dates_test.gd -> ASK_DATES failures=0` and each regression's pass line.

## Rules for this seat
Add only the two OWNS files. Do not edit AskBout.gd or any other file (Claude wires the screens meanwhile). No LFS.

## The one trap
"Days away" counts from today to the show night; the fight week is the last 7 days INCLUDING fight night's eve - read
FightWeekPlan's own day arithmetic and use it, do not invent an off-by-one.
