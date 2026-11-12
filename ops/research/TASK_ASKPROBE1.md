# TASK ASKPROBE1 - QWEN (qwen3-coder) - Ask for a fight: two pure rule modules, their tests, and the probe that decides the prices

Status: OPEN (S442, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: ASK FOR A FIGHT, mechanic 1 of the owner's order. Spec: ops/research/ASKFIGHT_MAP_S441.md (v2: READ IT FIRST, whole;
sections 2 to 5 are the rules, section 4's table is the probe's cases). Two critics said: no drawing before a probe shows that
no answer is always best. THIS task is the rules and the probe only: no screen, no wiring into Bouts or any menu.

## Contract
OWNS: scripts/rules/FightLearn.gd, scripts/rules/AskBout.gd, tests/fight_learn_test.gd, tests/ask_bout_test.gd,
tools/ask_probe.gd, docs/ASKPROBE1_RESULT.md
RED_TEST: tests/fight_learn_test.gd -> FIGHT_LEARN failures=0 ; tests/ask_bout_test.gd -> ASK_BOUT failures=0
REGRESSION: amateur_booking_test, rank_line_test, next_offer_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit: scripts/rules/Matchmaking.gd (332 lines: GROW_* constants 43-48, apply_result
229-270 is the pro model this copies, stop_chance 272), scripts/rules/AmateurBooking.gd (34: novice rule, lead weeks, fight_day),
scripts/rules/RankLine.gd (144: the table's order and the line a result earns), scripts/rules/NextOffer.gd (23),
scripts/state/Bouts.gd (offers 116-147, legal_index 167-181, accept 184-198, AFTER_FIGHT 44), scripts/state/Region.gd
(rankings 168-190, RANK_MIN_WINS 16), scripts/rules/BoutRead.gd (likely 410, rating_range 84), scripts/rules/BoutRules.gd
(TICKET_CUT, the win/loss member and reputation numbers 88-99), tools/adapt_probe.gd (how a probe plays the game's REAL bout
headless: copy its bout loop, do not invent one).

## 1. scripts/rules/FightLearn.gd (pure, static, under 80 lines; preloads Matchmaking only)
`teach(gap, won, stopped) -> float`: exactly Matchmaking.apply_result's growth, read from ITS constants (never retype a number):
GROW_BASE + GROW_PER_POINT x clamp(gap, 0, LEARN_GAP) when gap > -SOFT_GAP, else GROW_SOFT; a loss adds GROW_LOSS when gap <=
LEARN_GAP and not stopped; a stoppage loss subtracts STOP_COST. gap = opponent rating minus ours.
`word(expected: float) -> String`: "teaches little" / "teaches some" / "teaches a lot" (cut points as constants with a comment
that ASKPROBE1 sets them); `stop_word(chance) -> String`: "unlikely" / "possible" / "a real risk".

## 2. scripts/rules/AskBout.gd (pure, static, under 300 lines; preloads AmateurBooking, RankLine, FightLearn)
Inputs are plain Dictionaries and Arrays (the caller reads the career): fighter {id, w, l, d, rank, booked, offer_waiting, fit,
in_nationals, last_bout_day, weight, limit}, division rows [{name, club, w, l, rating, style, ours}], next_in_turn (the sheet's
name), day, show days.
- `open(f, day) -> Dictionary` {open: bool, why: String, opens_day: int}: map section 5, each closed reason in plain words.
- `show_day(day, show_days, taken_by_ours: Array) -> Dictionary` {day, days_away, why}: the next show at least MIN_LEAD_DAYS (14,
  a constant) away that none of ours already holds; why names the fighter who holds the nearer one.
- `answers(f, rows, next_in_turn) -> Array` of {kind: "sheet"|"step_up"|"name", names: [...], gate: bool}: map section 2 exactly:
  the sheet name; the step up (nearest ABOVE by RankLine's order; unranked: nearest better record inside the novice rule); the
  picked names = up to 4 places either side, NEVER the sheet name or the step-up name, only when the fighter has
  RANK_MIN_WINS wins (pass it in). A kind with no legal name is ABSENT from the array. Every name obeys
  AmateurBooking.experience_match_ok.
- `strip(f, show, forecast_kg, camp_min_days := 21) -> Dictionary` {days_away, camp: bool, weight_risk: bool, road: String}.
- `card(f, opp, kind) -> Dictionary`: the raw facts only (name, club, record, place words from RankLine or "unranked",
  style word, gate words): NO teaching number, NO summed score.
No pronoun in any string; "Coach" never a surname.

## 3. Tests FIRST (each extends SceneTree, prints its `... failures=N` line, quits with N; red on main: the preload fails)
fight_learn_test: teach equals Matchmaking's own arithmetic for 8 hand cases computed IN THE TEST from Matchmaking's constants
(even win, step up win, points loss up, stoppage loss, soft win, gap past LEARN_GAP); a points loss to a better boxer teaches
more than a win over a soft one; words are monotonic; MUTANT: a copy without GROW_LOSS fails.
ask_bout_test: two DIFFERENT fighters (an unranked 1-0 novice and a ranked 6-1) over one division of 12 rows shaped like
Data's; the picked list never holds the sheet or step-up name; the unranked fighter gets no "name" answer; a novice is never
offered a boxer over the novice limit; closed reasons for each of section 5's cases with the right opening day; show_day skips
a show under 14 days and a show one of ours holds; with only the sheet name legal answers() has ONE entry; card() holds no key
named teach, worth, score or best; MUTANT: a copy of answers that lets the step-up name into the picked list fails.

## 4. tools/ask_probe.gd (headless SceneTree; plays the game's REAL bout as tools/adapt_probe.gd does)
For cases A to G of the map and for 60 generated fighters (records 0-0 to 8-2, a spread of ratings, moods, cash, days to the
nationals' close): for each legal answer play 200 bouts against that answer's opponent and record win %, stoppage-loss %,
FightLearn.teach mean, members and reputation change, money. Then score each answer for THREE players and print who wins:
RECORD (wins and place), GROWTH (teach), SAFE SEASON (no stoppage, bouts toward 5). Print a table: per case the winner for each
player; over the 60, how often each answer wins for each player and overall (a fighter's own player = the one its situation
names: near the pro offer RECORD, a novice GROWTH, short of the nationals SAFE SEASON).
PASS LINE: `ASK_PROBE spread ok: no answer wins more than 6 in 10` or `ASK_PROBE DOMINANT: <answer> wins N of 60`.
Name the population in the output. Never test identical fighters. Write docs/ASKPROBE1_RESULT.md from the run: the two
tables, and if an answer dominates, which lever moves it (what a step up teaches first, the gate second) with a re-run.

## Traps
- ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`).
- The one trap: do not retype Matchmaking's numbers; read its constants, so a re-tune there moves this too.
- Do NOT delete or weaken any existing test. Write the PR body last, from the final run.

## Prior research
ops/research/ASKFIGHT_MAP_S441.md (v2), ASKFIGHT_CRITIC_S442_KALLI.md and _JOHN.md (what failed in v1), R37_MAP_S439.md section 2
(the code facts table: where offers, leads, waits, ranks and stoppages live).
## What would a human do?
A club coach rings the matchmaker: "who have you got at 60 kilos on the 28th?" and takes the fair kid, asks for the better kid
to test a prospect, or pays a favour to get one particular name.
## Prefab check
None: the growth rule is the game's own pro model; the rest is a filter over the division table.

Test commands: `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script
res://tests/fight_learn_test.gd` (and ask_bout_test.gd; the plain win64 exe, never the console one). Parse first with --check-only.
RESULT lines for the PR body: `RESULT: tests/fight_learn_test.gd -> FIGHT_LEARN failures=0`, `RESULT: tests/ask_bout_test.gd ->
ASK_BOUT failures=0`, `RESULT: tools/ask_probe.gd -> <the pass line>`.
