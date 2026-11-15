# TASK FILMPATTERN1 - the film game's rules: what can be marked, the coach's check, the words and figures, which claim finds which tell (pure module + test)

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Why now
The owner approved the fight analysis page (board Q-S294-256, "Yes, build it"). Map: ops/research/FIGHTFILM1_MAP_V3_S495.md
- read sections 3.1 to 3.6 WHOLE before writing; this module is its section 7 row "scripts/rules/FilmPattern.gd". The page,
the film night and the corner minute call this module; nothing else decides whether a marked pattern is real.

## What to build: scripts/rules/FilmPattern.gd (no class_name; static funcs only; preload nothing; under 400 lines)

### Constants (exact values, from the map)
- `WHENS` (9, in this order, ids then words): jab "their jab", cross "their cross", hook "their hook", combo "their
  combination lands", hurt "they are hurt", last_min "the last minute of a round", round1 "round 1", after_body "the 30
  seconds after a body shot lands on them", walked "an exchange where the other walks them down".
- `THENS` (8): right_low "right hand low", lunged "lunged in", stood "stood still", to_body "throws to the body", wild
  "single wild right", countered "the other's counter lands", fewer "throws fewer", outlanded "gets out-landed".
- Bars: `PASS_Z := 2.33`, `MAYBE_Z := 1.28`, `PASS_K := 3`, `MAYBE_K := 2`, `MIN_N := 3`.
- Figures: `ONE_FILM := 0.70`, `TWO_FILMS := 0.85`, `MAYBE_ONE := 0.30`, `MAYBE_POOLED := 0.20`, `ALONE := 0.30`.
- Checks a night by coach: no assistant 2; rating < 60 -> 2; 60-79 -> 3; 80+ -> 4. `PER_FILM_CAP := 2` (an opponent's cap =
  2 x their films, across the whole fight week or camp). `COACH_SECOND_TELL := 70` (a coach rated 70+ opens two tells on
  his own watch, one below).

### Functions
1. `static func claims() -> Array` - the 72 WHEN x THEN pairs as `{when, then, words}` ("their jab -> right hand low").
2. `static func checks(coach_rating: int, has_coach: bool, used_on_opp: int, opp_films: int) -> int` - tonight's checks:
   min(the rating's checks, 2 x opp_films - used_on_opp), never below 0.
3. `static func after_moment(k: int, n: int, rest_k: int, rest_n: int) -> Dictionary` - the "fact after a moment" bar
   (map 3.3): rate_rest = rest_k / max(rest_n, 1); E = n x rate_rest; spread = sqrt(E + E x n / max(rest_n, 1)) (the
   rest's count taken as at least 1); z = (k - E) / spread (spread 0 -> z = 0 when k == E, else 99.0). Word: n < MIN_N ->
   "not_enough"; k >= PASS_K and z >= PASS_Z -> "pass"; k >= MAYBE_K and z >= MAYBE_Z -> "maybe"; else "nothing".
   Return `{word, k, n, e, z}`.
4. `static func throws_fewer(inside: int, inside_min: float, outside: int, outside_min: float, slowdown: float) -> Dictionary`
   - E = (outside / max(outside_min, 0.01)) x inside_min x slowdown; spread = sqrt(E + E*E / max(outside, 1)); z = (E -
   inside) / spread (DOWNWARDS); the same words and bars, with k = E - inside rounded for the PASS_K/MAYBE_K tests and
   n = inside + outside for the MIN_N test. Return `{word, k, n, e, z}`.
5. `static func outlanded(in_landed: int, in_min: float, out_landed: int, out_min: float) -> Dictionary` - the other
   corner's landed a minute inside against outside: E = out_landed / max(out_min, 0.01) x in_min; spread = sqrt(E + E*E /
   max(out_landed, 1)); z = (in_landed - E) / spread (UPWARDS); same words; k = in_landed - E rounded; n = in_landed +
   out_landed.
6. `static func pool(a: Dictionary, b: Dictionary) -> Dictionary` - two films' raw counts added key by key (k, n, rest_k,
   rest_n, inside, outside, minutes...): numbers add, anything else from a.
7. `static func report_game(mode_counts: Dictionary) -> Dictionary` - the game with most exchanges; word "pass" when its
   share >= 0.40, else "nothing". `{word, game, share}`.
8. `static func report_weapon(clean_counts: Dictionary) -> Dictionary` - the punch landing clean most; "pass" when >= 3 AND
   strictly more than any other; else "nothing". `{word, punch, count}`.
9. `static func figure(word: String, films: int, alone: bool) -> float` - pass: 0.70 one film, 0.85 two or more; maybe:
   0.30 one film, 0.20 pooled; alone (no coach check, own read): 0.30 only when word is "pass" else 0.0; nothing or
   not_enough: 0.0.
10. `static func word_text(word: String, pronoun: String) -> String` - "That's her" / "That's him" (pronoun "her"/"him"),
    "Maybe", "Not enough moments", "Nothing there".
11. `static func matches(habits: Array, weak: String, claim: Dictionary) -> String` - which real tell a claim finds (map
    3.6), "" for noise. habits are FighterProfile habit ids. Table:
    jab+right_low -> "habit:drops_right_after_jab"; jab+lunged -> "habit:lunges_with_jab"; combo+stood ->
    "habit:admires_her_work"; hurt+to_body -> "habit:digs_body_when_hurt"; hurt+wild -> "habit:loads_up_when_hurt";
    last_min+fewer -> "habit:fades_late" if that habit is in habits, else "weakness" when weak contains "fade" or
    "legs late"; round1+fewer -> "habit:slow_starter" if present, else "weakness" when weak contains "slow to start" or
    "round 1"; after_body+fewer -> "weakness" when weak contains "body"; walked+outlanded -> "weakness" when weak contains
    "backed up", "backs straight" or "pressure". A habit row returns its id only when the habit is in habits. Every other
    claim returns "".
12. `static func coach_watch(tells_in_order: Array, rating: int) -> Array` - "let the coach watch": the first one (rating
    < 70) or two (70+) hidden tells in tape order, each `{id, figure: 0.70}`.

## The test: tests/film_pattern_test.gd (extends SceneTree; preload res://scripts/rules/FilmPattern.gd only)
- claims() has 72 unique pairs; checks() over every rating band, the per-opponent cap, never negative.
- after_moment: hand-worked cases for each word (write the arithmetic in a comment), rest_n 0 (no division by zero),
  n < 3 -> not_enough even with a huge z.
- throws_fewer and outlanded: one pass, one maybe, one nothing each, worked by hand in comments.
- pool adds; report_game at 0.39 / 0.40; report_weapon tie -> nothing, 3 clear -> pass, 2 -> nothing.
- figure for every word x films 1/2 x alone; word_text both pronouns.
- matches: every row of the table true AND false (habit absent / weak word absent), and 10 noise claims -> "".
- THE NOISE RATE (map 3.4/6): with a seeded RandomNumberGenerator (seed 495), simulate 1,000 films per claim for each
  after-moment claim with NO true tell: n ~ 25-35 moments, rest_n ~ 120-160, the fact's base rate 0.10-0.25 drawn per film,
  k and rest_k each binomial at that same rate (draw per moment). Count passes. Assert the average pass rate over those
  claims < 0.03 and the worst claim < 0.08. Print the two rates.
Print `FILM_PATTERN failures=<n> noise_avg=<x> noise_worst=<x>` and quit(1 if failures > 0 else 0).

GDSCRIPT TRAPS: never `var x := <an Array or Dictionary element>` (write `var x: int = int(d["k"])`); Array has no join();
no `sort_custom` with a static Callable in a script without class_name; a ternary is `a if cond else b`; a literal percent
in a format string is `%%`; `sqrt` of a negative is NaN - clamp first.

## Contract
OWNS: scripts/rules/FilmPattern.gd, tests/film_pattern_test.gd
RED_TEST: tests/film_pattern_test.gd -> FILM_PATTERN failures=0
REGRESSION: film_truth, mode_tells, opp_file
VISUAL: no
NOT YOURS: every other file (do not wire it; Claude wires it). Under 500 lines each. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --path . --script res://tests/film_pattern_test.gd` (Godot 4.7.2).
PR body: `RESULT: tests/film_pattern_test.gd -> FILM_PATTERN failures=0` plus the two noise numbers it printed.

## Prior research
ops/research/FIGHTFILM1_MAP_V3_S495.md sections 3.1-3.6 (the numbers were measured by tools/film_check_probe.py, 1,000 films
a claim); scripts/rules/FilmTruth.gd, ModeTells.gd (ALL_FILMS_SHARE 0.4), OppFile.gd (HABIT_WORDS, WEAKNESS_ANSWERS),
FighterProfile.gd HABITS.

## What would a human do?
A video analyst does not call a habit from two moments: they count how often it follows the trigger against how often it
follows anything else, and only call it when the gap is too big for chance. This module is that count, with the bars fixed.

## Prefab check
None: a one-sided z test on counts needs no library.
