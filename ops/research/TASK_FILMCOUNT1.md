# TASK FILMCOUNT1 - count any marked pattern on a film (the coach's check), and re-measure the film game on FilmBout's real tapes

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Why now
The owner approved the fight analysis page (board Q-S294-256, "Yes, build it"; map ops/research/FIGHTFILM1_MAP_V3_S495.md,
read sections 3.1-3.6 WHOLE). Three modules are on main: `scripts/rules/FightLog.gd` (beats -> lines),
`scripts/rules/FilmBout.gd` (an opponent's past bout rebuilt punch by punch), `scripts/rules/FilmPattern.gd` (the bars,
words, figures, which claim finds which tell). Missing: the step between them - given a film and a claim ("their jab ->
right hand low"), the raw counts FilmPattern judges. This task builds it, adds what FilmBout lacks for three of the
moments, and re-measures the noise and find rates on FilmBout's real output (map 7b item 8: the old figures came from a
Python model, `tools/film_check_probe.py`).

## 1. NEW scripts/rules/FilmCount.gd (no class_name; static funcs; preload only FightLog.gd and FilmPattern.gd; under 400 lines)
A film = `FilmBout.build(...)` output: `{exchanges: [{i, round, at, mode, a_mode, place, pinned, won, landed, beats}], ...}`.
Corner "b" is the boxer on film, "a" the one they met. Absolute time of a beat = `round_index * 180 + at + t` (rounds of
three minutes; use that for every window so moments never cross rounds). A PUNCH beat = move in `FightLog.PUNCH` and
result != "none". `punch word` = FightLog.PUNCH[move][1] (jab / cross / hook / uppercut); target = [2] (head / body).

### The moments (WHEN), Claude's definitions
- jab / cross / hook: each "b" punch beat of that word (hook = lead_hook, rear_hook, body_hook). A point moment.
- combo: a "b" punch that LANDS within 1.5 s after another "b" punch landed (the second landing). A point moment.
- hurt: an "a" punch that lands with big true. A point moment.
- last_min: the window [120, 180) s of each round.
- round1: the window = all of round 1.
- after_body: the window [t, t + 30) after each "a" punch landing to the body (target body), merged, inside its round.
- walked: the window = every exchange whose `a_mode` is "press" (30 s each).

### The facts (THEN)
- right_low / lunged / stood (AFTER facts): for a point moment that is a "b" punch, the fact is that beat's own `after`
  key; for any other point moment, the `after` of the first "b" punch beat starting within 2 s after it (none -> no fact).
- to_body: the first "b" punch within 2 s after the moment has target body (for a "b" punch moment: the NEXT "b" punch).
- wild: that first "b" punch within 2 s is a hook or cross whose result is "misses" with def "" (a wide miss).
- countered: an "a" punch LANDS within 2 s after the moment.
- fewer: a throw rate. With a window WHEN: "b" punches inside the window against outside (minutes from the windows'
  lengths). With a point WHEN: the window is [t, t + 2 s) after each moment, merged.
- outlanded: "a" LANDED punches a minute inside the window against outside (point WHENs: the same 2 s windows).

### Functions
1. `static func count(film: Dictionary, claim: Dictionary, seen_only: bool = false) -> Dictionary` - the raw counts for
   one claim `{when, then}`:
   - AFTER-type THENs (right_low, lunged, stood, to_body, wild, countered) with a point WHEN: `{kind: "after", k, n,
     rest_k, rest_n}` where n = the moments, k = moments followed by the fact, rest_n = every "b" punch beat that is NOT a
     moment (for punch WHENs) or every "b" punch beat not inside 2 s after a moment (other point WHENs), rest_k = those
     followed by the fact by the same rule. With a window WHEN, the moments are the "b" punches inside the window and the
     rest the "b" punches outside it.
   - fewer: `{kind: "fewer", inside, inside_min, outside, outside_min, slowdown}`; slowdown = 0.9 for last_min (FilmBout's
     late drop, map 3.3), else 1.0.
   - outlanded: `{kind: "outlanded", in_landed, in_min, out_landed, out_min}`.
   - seen_only true: AFTER facts count only on beats with `seen` true (the screen's camera counts); n and rest_n still
     count every moment.
2. `static func judge(counts: Dictionary) -> Dictionary` - routes to FilmPattern.after_moment / throws_fewer / outlanded and
   returns its `{word, k, n, e, z}`.
3. `static func pooled(a: Dictionary, b: Dictionary) -> Dictionary` - two films' counts for the same claim:
   `FilmPattern.pool(a, b)`; minutes add.
4. `static func check(films: Array, claim: Dictionary) -> Dictionary` - one or more films (pool them in order), judged:
   `{word, k, n, e, z, films}`.

## 2. FilmBout.gd additions (it is yours for this task; keep everything the brief S495 asked and its test green)
- `a_mode` on every exchange: the corner they met boxes an even mix of `["press", "range", "counter"]` (a club boxer),
  drawn from the bout's one rng AFTER everything already drawn for that exchange (so existing beats stay where they are
  as far as possible; the determinism test still holds).
- Weakness against pressure: when the opponent's `weak` (lowercase it) contains "backed up", "backs straight" or
  "pressure" and `a_mode` is "press", the exchange's "a" side lands more: turn up to 2 "a" beats with result "misses" or
  "blocked" into "lands" (def "") - then recount `landed`.
- Hurt habits only after a real hurt: call `HabitBeats.apply` with the opponent's habits MINUS "digs_body_when_hurt" and
  "loads_up_when_hurt"; then FilmBout fires those two itself, after each "a" punch that lands with big true (at most 2 a
  round): digs_body -> the next "b" punch within 2 s becomes "body_hook"; loads_up -> it becomes "lead_hook", result
  "misses", def "" (a wide miss). (HabitBeats in the live fight is unchanged - it is not yours.)
- "a" big landings: mark an "a" landing big with p 1/12, so a film has about 2-3 hurt moments (the map's "about 2"); the
  test prints the mean.

## 3. FilmPattern.gd: one word
THEN "wild": words "single wild right" -> "a wild swing" (the habit throws a wild lead hook, not a right). Update any test
line that asserts the old words. Nothing else in FilmPattern changes.

## 4. The test: tests/film_count_test.gd (extends SceneTree)
- Hand-built films (a few exchanges, beats placed by hand) for EVERY WHEN and EVERY THEN kind: assert k, n, rest_k,
  rest_n / inside, outside, minutes exactly, with the arithmetic in a comment. seen_only drops unseen facts only.
- Real tapes, seeded (RandomNumberGenerator seed 495 for the opponents): build opponents that DIFFER (style from
  Exchanges.STYLE_MODES keys, threat from the five punches, rating 55-75, sex "f"/"m" - never identical fighters).
  a) NOISE: 1,000 opponents with NO habits and an empty `weak`, one film each (row: random d, win, how from
     RivalPast.DECISIONS or "stopped in round N"): judge all 72 claims with `check`. Assert the average pass rate over the
     72 < 0.03 and the worst claim < 0.08; print both.
  b) FINDS: for each of the 9 true tells (map 3.6), 300 opponents carrying it (habit in `habits`, or the weak words), one
     film and two films pooled: print the pass rate per tell (one film | two films). Floors (assert): the two jab habits
     >= 0.50 on one film; admires (combo -> stood) >= 0.40 on one film; every tell >= 0.15 on two films.
  c) Print the mean hurt moments a film (expect about 2-3) and assert it is between 1.0 and 5.0.
- Print `FILM_COUNT failures=<n> noise_avg=<x> noise_worst=<x>` and the FINDS table; quit(1 if failures > 0 else 0).
If a floor cannot be reached without breaking the noise bars, do NOT lower it: stop, and put the measured table and what
you tried in the PR body (Claude retunes the rates).

## Contract
OWNS: scripts/rules/FilmCount.gd, tests/film_count_test.gd, scripts/rules/FilmBout.gd, tests/film_bout_test.gd, scripts/rules/FilmPattern.gd, tests/film_pattern_test.gd
RED_TEST: tests/film_count_test.gd -> FILM_COUNT failures=0 (red on main: the file does not exist)
REGRESSION: tests/film_bout_test.gd, tests/film_pattern_test.gd, tests/fight_log_test.gd, tests/habit_beats_test.gd, tests/round_script_test.gd
VISUAL: no
NOT YOURS: every other file (HabitBeats.gd, RoundScript.gd, LiveRound.gd included; Claude wires the page). Under 500 lines each.
Never delete or weaken a test (the S495 bar change in film_bout_test 0.30 -> 0.25 is Claude's and stays).
Run one test: `godot --headless --audio-driver Dummy --path . --script res://tests/<name>.gd` (Godot 4.7.2). Never tools/run_tests.sh.
PR body: `RESULT: tests/film_count_test.gd -> FILM_COUNT failures=0 noise_avg=<x> noise_worst=<x>`, the FINDS table, and a
RESULT line for each regression test.

GDSCRIPT TRAPS: never `var x := <an Array or Dictionary element>` (write `var x: int = int(d["k"])`); Array has no join();
no `sort_custom` with a static Callable in a script without class_name; a ternary is `a if cond else b`; `%%` for a literal
percent; `sqrt` of a negative is NaN - clamp first; a 1,000-film loop must stay under ~3 minutes headless (print the time).

## Prior research
ops/research/FIGHTFILM1_MAP_V3_S495.md (3.1-3.6, 7b item 8); tools/film_check_probe.py (the Python model it replaces);
scripts/rules/HabitBeats.gd (how habits fire); scripts/rules/RivalPast.gd (DECISIONS, the how words); OppFile.gd (weak words).

## What would a human do?
A video analyst counts how often the fact follows the moment against how often it follows anything else, on every punch
of the tape - then checks the counting on tapes where nothing is there, to know how often it cries wolf.

## Prefab check
None: our own fight records.
