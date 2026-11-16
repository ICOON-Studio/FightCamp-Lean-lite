# TASK FILMBAR1 - a film-night pattern never passes by luck (an exact test for small counts)

Status: OPEN (S499, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
FIGHTFILM1 (the film night: the player marks a pattern on the opponent's tape, "when X, then Y", and the coach's count
says pass / maybe / nothing). `tests/film_count_test.gd` is RED on main on purpose: on 1,000 films made by pure chance,
five claims come back "pass" far more often than the 8 % bar (worst: "their jab -> a wild swing", 26.5 %). The film
night cannot be wired until a "pass" means something. Run the test first and read its `NOISY claim ...` lines: they
name the five.

The cause is in the judge, `scripts/rules/FilmPattern.gd`: `after_moment`, `throws_fewer` and `outlanded` turn small
counts into a z score with a normal approximation (`z = (k - E) / spread`, pass at `k >= PASS_K and z >= PASS_Z`).
When the expected count E is tiny (a rare THEN, a short film) the spread is tiny too, so k = 3 gives a huge z by luck.
A normal approximation is not valid for counts this small.

## What to build
1. In `scripts/rules/FilmPattern.gd`, a pure static exact tail and its use for the word:
   - `static func tail_p(k: int, n: int, rest_k: int, rest_n: int) -> float`: the one-sided Fisher exact probability
     (hypergeometric tail) of seeing `k` or more of the THEN in the `n` moments, given `k + rest_k` THENs among
     `n + rest_n` moments in all. Use log-factorials (a small `_lnfact(i)` with a running sum or `lgamma`-free loop:
     counts stay under a few thousand) so nothing overflows. `tail_p(0, n, ...)` is 1.0; any empty side returns 1.0.
   - `const PASS_P := 0.01` and `const MAYBE_P := 0.10` (what z 2.33 and z 1.28 stand for).
   - `after_moment`: the word is "pass" when `k >= PASS_K and tail_p <= PASS_P`, "maybe" when `k >= MAYBE_K and
     tail_p <= MAYBE_P`, else "nothing". `MIN_N` stays. Keep returning `e` and `z` exactly as today (screens print them)
     and ADD `"p": tail_p` to the dictionary.
   - `throws_fewer` and `outlanded` (rates per minute, a DOWNWARD and an UPWARD count against an expected count E):
     replace the z test for the WORD with the exact Poisson tail of the observed count against E
     (`poisson_tail_low(obs, E)` = P(X <= obs), `poisson_tail_high(obs, E)` = P(X >= obs), both pure static, summed
     term by term), same PASS_P / MAYBE_P, same PASS_K / MAYBE_K / MIN_N gates, `e`/`z` kept, `"p"` added.
   - `pool(a, b)`: read it; if it re-derives a word from z, give it the same rule (the pooled p from the pooled counts).
2. `tests/film_exact_test.gd` (new, `extends SceneTree`, prints PASS/FAIL lines and `FILM_EXACT failures=<n>`,
   `quit(1 if failures > 0 else 0)`): `tail_p` against hand-worked values (e.g. k=3, n=3, rest_k=0, rest_n=97 ->
   3/100 * 2/99 * 1/98 = 6.18e-6; k=1, n=10, rest_k=9, rest_n=90 -> about 0.651; k=0 -> 1.0), monotone in k, the two
   Poisson tails against hand-worked sums (E = 2: P(X >= 5) = 0.0527, P(X <= 0) = 0.1353), and the luck case that is
   wrong today: k = 3, n = 4 with rest_k = 30, rest_n = 60 must NOT be "pass".
3. `tests/film_count_test.gd` must go GREEN without being edited: noise average under 3 %, worst under 8 %, and every
   hand-built film and every real-tape find (`_test_hand_built`, `_test_finds`) still passing.

## Contract
OWNS: scripts/rules/FilmPattern.gd, tests/film_exact_test.gd
RED_TEST: tests/film_count_test.gd -> FILM_COUNT failures=0
REGRESSION: film_pattern_test, film_exact_test, file_limits_test
VISUAL: no - a pure rule; Claude wires the film night afterwards.
NOT YOURS: every other file, `tests/film_count_test.gd` and `tests/film_pattern_test.gd` included. Never delete or weaken
a test. Work on your own branch, open a PR into main, never merge.
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors.
PR body: `RESULT: tests/film_count_test.gd -> FILM_COUNT failures=0`, `RESULT: tests/film_pattern_test.gd ->
FILM_PATTERN failures=0`, `RESULT: tests/film_exact_test.gd -> FILM_EXACT failures=0` and
`RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`, plus the noise_avg / noise_worst numbers before and after.

## Prior research
`ops/research/S498_DIGEST.md` (FILMCOUNT1 collected: the five claims over the bar), `tests/film_count_test.gd`
(`_test_noise`: how the chance films are made), `scripts/rules/FilmCount.gd` `judge()` (the only caller of the three
judge functions on a film). `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript (typed `:=` from a Dictionary read
is a parse error: write `var x: float = float(d[k])`).

## What would a human do?
A coach who sees a thing happen three times does not call it a habit if the boxer does that thing all the time anyway,
or if three times is what luck gives on a short tape. He asks how often it would happen with no habit at all, counts
honestly, and says "not sure yet" when the tape is too short. Statisticians use an exact test, not a bell curve, for
counts under about five.

## Prefab check
None needed: Fisher's exact test and the Poisson tail are a dozen lines each; no library in GDScript.

## The one trap
If the exact test makes a hand-built film or a real-tape find in `film_count_test.gd` stop passing, do NOT loosen
PASS_P and do not touch the test: say which find was lost and its counts (k, n, rest_k, rest_n, p) in the PR body. A
lost find is information for the design; a loosened bar brings the luck back. `film_pattern_test.gd` has its own noise
check and exact-value checks on `e` and `z`: keep `e` and `z` byte-for-byte as they are.
