# TASK FILMBAR2 - film-night patterns: compare two rates exactly (round 2 of FILMBAR1)

Status: OPEN (S502, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
FILMBAR1 (PR 333, branch `qwen/filmbar1`) added an exact Fisher tail for `after_moment` and exact Poisson tails for
`throws_fewer` / `outlanded`. Claude's S501 check did NOT merge it:
- `tests/film_exact_test.gd` -> green (keep it).
- `tests/film_count_test.gd` -> `FILM_COUNT failures=2 noise_avg=0.0105 noise_worst=0.1330`. Still over the 8 % bar:
  "round 1 -> gets out-landed" 13.3 %, "after a body shot -> out-landed" 11.1 %, "last minute -> throws fewer" 10.2 %,
  "jab -> wild swing" 8.8 %. And a NEW red: the real find `admires_her_work` one_film must be >= 0.40, got 0.293.
- `tests/film_pattern_test.gd` (green on main) -> FAIL `after_moment maybe: k=4,n=20,rest_k=10,rest_n=100`.

The cause: the Poisson tails treat the expected count E as KNOWN, but E is itself estimated from the rest of the same
film (a few minutes, a handful of punches). Two noisy counts are being compared as if one were exact.

## What to build
0. Start from round 1: `git checkout origin/qwen/filmbar1 -- scripts/rules/FilmPattern.gd tests/film_exact_test.gd`
   (your branch starts from main, which does not have them).
1. In `scripts/rules/FilmPattern.gd`, `throws_fewer` and `outlanded`: replace the Poisson-against-E word with an exact
   CONDITIONAL BINOMIAL test of two rates. Given `total = inside + outside` counts over `inside_min` and `outside_min`
   minutes, under "no habit" the inside count is Binomial(total, q) with q = inside_min * r0 / (inside_min * r0 +
   outside_min) where r0 is the null ratio of the inside rate to the outside rate (1.0 for `outlanded`; for
   `throws_fewer` the ratio the `slowdown` argument already implies - read how today's code builds E from it and keep
   that meaning). Pure static `binom_tail_low(k, n, q)` = P(X <= k) and `binom_tail_high(k, n, q)` = P(X >= k), summed
   term by term in log space (reuse `_lnfact`). Word: "pass" when the count gate holds (PASS_K / MIN_N as today) and
   p <= PASS_P; "maybe" at MAYBE_K and p <= MAYBE_P; else "nothing". Keep `e` and `z` byte-for-byte as main returns
   them; `"p"` in the dictionary is the new p.
2. `after_moment`: make `film_pattern_test`'s `after_moment maybe: k=4,n=20,rest_k=10,rest_n=100` pass again. Read that
   check first: if it asserts "maybe" and the exact Fisher p for those counts is above MAYBE_P, say so with the number
   in the PR body and ask Claude (do not edit that test, do not loosen MAYBE_P). If round 1 changed the gate order or a
   threshold by mistake, put it back.
3. `tests/film_exact_test.gd`: add hand-worked checks for the two binomial tails (e.g. n=4, q=0.5: P(X >= 4) = 0.0625,
   P(X <= 0) = 0.0625; n=10, q=0.2: P(X >= 5) about 0.0328) and the luck case that fails today: inside 3 landed in
   1 min against outside 6 in 2 min (same rate) must be "nothing".

## Contract
OWNS: scripts/rules/FilmPattern.gd, tests/film_exact_test.gd
RED_TEST: tests/film_count_test.gd -> FILM_COUNT failures=0
REGRESSION: film_pattern_test, film_exact_test, file_limits_test
VISUAL: no - a pure rule; Claude wires the film night afterwards.
NOT YOURS: every other file, `tests/film_count_test.gd` and `tests/film_pattern_test.gd` included. Never delete or weaken
a test. Work on your own branch, open a PR into main, never merge. FilmPattern.gd stays under 500 lines (round 1 is 392).
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2).
Never `tools/run_tests.sh`. Never run Godot windowed. Nothing may open on the owner's monitors.
PR body: `RESULT: tests/film_count_test.gd -> FILM_COUNT failures=0`, `RESULT: tests/film_pattern_test.gd ->
FILM_PATTERN failures=0`, `RESULT: tests/film_exact_test.gd -> FILM_EXACT failures=0`,
`RESULT: tests/file_limits_test.gd -> FILE_LIMITS failures=0`, plus noise_avg / noise_worst before and after and the
`admires_her_work` one_film figure.

## Prior research
TASK_FILMBAR1.md (round 1 brief), PR 333 and its S501 comment (the numbers above), `ops/research/S498_DIGEST.md`,
`tests/film_count_test.gd` `_test_noise` (how chance films are made) and `_test_finds`, `scripts/rules/FilmCount.gd`
`judge()` (the only caller). `ops/research/GDSCRIPT_TRAPS.md` before writing GDScript.

## What would a human do?
A coach comparing "he lands more in round 1" against the rest of the fight knows both numbers are small samples. He
asks: of all the punches he landed, is the share in round 1 more than round 1's share of the minutes? That is the
conditional binomial test - the standard exact way to compare two Poisson rates.

## Prefab check
None needed: a binomial tail is a dozen lines; no GDScript stats library.

## The one trap
If a hand-built film or real-tape find stops passing, do NOT loosen PASS_P/MAYBE_P and do not touch the tests: report
the find, its counts and its p in the PR body. A lost find is design information; a loosened bar brings the luck back.
