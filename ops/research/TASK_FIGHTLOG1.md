# TASK FIGHTLOG1 - the punch list of the fight analysis page: beats -> lines, filters, the count line, the live-log line (pure module + test)

Status: OPEN (S495, Claude main). Discipline: boxing. Model: Qwen (qwen3-coder), default.

## Why now
The owner approved the fight analysis page (board Q-S294-256, "Yes, build it"; map ops/research/FIGHTFILM1_MAP_V3_S495.md,
sections 2.1 THE PUNCHES, 4 the live fight log, 7 the build table: "scripts/rules/FightLog.gd ... pure + test, Qwen"). Every
other piece (the page, the live log, the film game) reads its lines from this module, so it comes first.

## What to build: scripts/rules/FightLog.gd (no class_name; static funcs only; preload nothing; under 300 lines)

### Input (the game's own records; read them, do not change them)
An EXCHANGE record (scripts/state/LiveRound.gd, the `rec` built near line 332) - the keys this module uses:
`i` (0-5, the exchange in the round), `at` (float, seconds into the round when it starts; 30 s an exchange,
Exchanges.EX_SECONDS), `mode` (the opponent's game, a string such as "pressure", "long", "body", "calm"), `place`
(int: 0 long, 1 pocket, 2 inside - scripts/rules/Duels.gd PLACES), `pinned` (bool: on the ropes), `won` (bool, our corner
"a" won it), `landed` (Array [a, b] punches landed), and NEW `beats` (Array of beats; another task stores them - when the key
is missing, treat it as []).
A BEAT (scripts/rules/RoundScript.gd `_beat`, line ~253): `{t (float s), who ("a" = your boxer, "b" = the opponent), move,
result ("lands" / "misses" / "blocked" / "none"), big (bool), def ("" / "block" / "slip" / "weave" / "pull"), caption}`
plus two NEW optional keys a later task writes: `after` (one of "guard_up", "right_low", "left_low", "lunged", "stood",
"threw_on", or "") and `seen` (bool, the ringside camera saw the AFTER fact; missing = false).

### Functions
1. `static func lines(exchanges: Array, round_n: int) -> Array` - one line per PUNCH beat, in time order (sort by
   `at + t` ascending; ties keep input order). A punch beat = move in PUNCH (below). Skip every other beat ("say", "step_in",
   "step_out", result "none"). Each line is a Dictionary:
   `{t: float (at + beat t, seconds into the round), round: round_n, who: "a"|"b", hand: "lead"|"rear", punch: "jab"|"cross"|
   "hook"|"uppercut", target: "head"|"body", result: "Landed"|"Clean"|"Blocked"|"Slipped"|"Missed", range: "long"|"mid"|
   "inside"|"ropes", after: <word or "">, sit: <the exchange's mode>, ex: <the exchange's i>}`.
   - PUNCH := {"jab": [lead, jab, head], "cross": [rear, cross, head], "lead_hook": [lead, hook, head], "body_hook": [lead,
     hook, body], "rear_uppercut": [rear, uppercut, head], "lead_uppercut": [lead, uppercut, head], "rear_hook": [rear,
     hook, head], "body_cross": [rear, cross, body]} (a const Dictionary; moves not in it are skipped).
   - result: "lands" and big -> "Clean"; "lands" -> "Landed"; "blocked" or def "block" -> "Blocked"; "misses" with def in
     ["slip", "weave", "pull"] -> "Slipped"; any other "misses" -> "Missed".
   - range: "ropes" when the exchange is pinned, else ["long", "mid", "inside"][place] (clamp place to 0-2).
   - after: only for who "b" AND seen true: AFTER_WORDS[after] where AFTER_WORDS := {"guard_up": "guard up", "right_low":
     "right low", "left_low": "left low", "lunged": "lunged in", "stood": "stood still", "threw_on": "threw on"}; else "".
2. `static func clock(t: float) -> String` - "m:ss" (0.0 -> "0:00", 95.4 -> "1:35"; floor the seconds).
3. `static func words(line: Dictionary) -> String` - the list's text, e.g. `1:35  rear cross to the head - Clean`
   (clock, two spaces, hand + " " + punch + " to the " + target, " - ", result; with an after word append "  (" + after + ")").
   No names anywhere (owner S448).
4. `static func filter(all: Array, picks: Dictionary) -> Array` - SHOW ME. picks keys (each optional; "" or missing = any):
   "corner" ("a"/"b"), "hand", "punch", "target", "result", "range", "round" (int, 0 = any), "game" (matches sit),
   "after" (matches the after word). Keeps order.
5. `static func count_line(shown: Array, all: Array) -> String` -
   `"<shown> lines of <all> - landed <L> of <shown>, clean <C>"` where L counts shown lines with result Landed or Clean
   and C counts Clean. Example: 36 shown, 164 all, 9 landed (2 of them clean) -> "36 lines of 164 - landed 9 of 36, clean 2".
6. `static func seen_count(all: Array, when_punch: String, after: String) -> Dictionary` - the camera-seen counts the page
   shows with an After filter: over the opponent's lines (who "b"), `{k: lines with punch == when_punch and after == after,
   n: lines with punch == when_punch, k_other: other punches with that after, n_other: other punches}`; `after` is the word
   ("right low").
7. `static func exchange_line(rec: Dictionary, game_word: String) -> String` - the live log's line for one exchange:
   `clock(rec.at) + " " + game_word + " - " + ("you won it, " if won else "they won it, ") + "<a> to <b>"` using landed
   [a, b] in that order when you won, [b, a] when they won (the winner's count first). Example: at 90, "They walked you
   down", won, landed [4, 2] -> "1:30 They walked you down - you won it, 4 to 2".

## The test: tests/fight_log_test.gd (extends SceneTree; preload res://scripts/rules/FightLog.gd only)
Hand-built exchanges (two exchanges, at 0 and 30; one pinned, one at place 2) with at least 10 beats covering: each PUNCH
move, every result rule (lands+big, lands, blocked, def block on a miss, slip, weave, pull, plain miss), "say"/"step_in"
beats that must be skipped, an unknown move, a "b" beat with after+seen, a "b" beat with after but seen false, an "a" beat
with after (must stay ""), out-of-order t inside an exchange. Assert every field of at least four lines, the order, the
clock (0, 59.99, 95.4, 180), words(), every filter key alone and two together, count_line on the example numbers above,
seen_count, exchange_line won and lost, and that `lines([], 1)` and an exchange with no `beats` key give []. Print
`FIGHT_LOG failures=<n>` and quit(1 if n > 0 else 0).

GDSCRIPT TRAPS (each cost an earlier PR a fix): never `var x := <an Array or Dictionary element>` (untyped Variant ->
parse error: write `var x: int = int(d["k"])`); Array has no join() (build the string in a loop); no `sort_custom` with a
static Callable in a script without class_name (sort an index array with a lambda, or insertion-sort by hand); a ternary is
`a if cond else b`; `%` with one value needs no array, a literal percent is `%%`.

## Contract
OWNS: scripts/rules/FightLog.gd, tests/fight_log_test.gd
RED_TEST: tests/fight_log_test.gd -> FIGHT_LOG failures=0
REGRESSION: round_script_test, habit_beats_test
VISUAL: no
NOT YOURS: every other file (do not wire it anywhere; Claude wires it). Under 500 lines each. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --path . --script res://tests/fight_log_test.gd` (Godot 4.7.2).
PR body: `RESULT: tests/fight_log_test.gd -> FIGHT_LOG failures=0`.

## Prior research
ops/research/FIGHTFILM1_MAP_V3_S495.md (sections 1, 2.1, 4, 7); scripts/rules/RoundScript.gd (beats), scripts/rules/
RoundStyle.gd `defend` (the def words), scripts/rules/Duels.gd PLACES, scripts/state/LiveRound.gd (the exchange record).

## What would a human do?
A boxing analyst's strike log (CompuBox-style) is one row a punch: time, fighter, punch type, target, landed or not; the
filters and the "x of y" counts are what a coach reads. Build exactly that row from what the game already settles.

## Prefab check
None fits: our own fight records.
