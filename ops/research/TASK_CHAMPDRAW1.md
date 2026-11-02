# TASK CHAMPDRAW1 - QWEN - the championship draw: seeds, byes, who meets whom, the other bouts (Lean, update 30)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/champdraw1). Commit there; do not push.

## Why
Update 30 (the road to the National Amateur Championships, operator S323 "Build it") needs the draws: SeasonPath (on main,
scripts/rules/SeasonPath.gd - read, do not change) says WHEN her bouts are; this module says WHO she meets and how the rest
of the draw goes. Her own bout is decided by the game's fight; every other bout here, by rating. Claude wires it.

## Owned files (create both; touch nothing else)
- `scripts/rules/ChampDraw.gd` (new, under 140 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/champ_draw_test.gd` (new, `extends SceneTree`, same shape as `tests/season_path_test.gd`; prints
  `CHAMP_DRAW failures=<n>`; quit(1 if failures else 0))

## The module
```
const BYE := "BYE"
const RATING_SCALE := 8.0   # 8 rating points = e times the odds

## Entrants' ids best first: rating high to low, ties by id A-Z. entrants = [{"id": String, "rating": float}, ...].
static func seeds(entrants: Array) -> Array

## The standard seed order for a draw of P slots (P a power of two): order(1) = [1]; order(2P) = for each s in order(P),
## append s then 2P + 1 - s. So order(2) = [1, 2], order(4) = [1, 4, 2, 3], order(8) = [1, 8, 4, 5, 2, 7, 3, 6]
## (seeds 1 and 2 can only meet in the final).
static func order(p: int) -> Array

## First-round pairs: P = the smallest power of two >= entrants.size() (at least 2); walk order(P) two at a time; a seed
## above the entrant count is BYE. Returns [[id_or_BYE, id_or_BYE], ...] (P / 2 pairs). [] for no entrants.
static func first_round(entrants: Array) -> Array

## The chance a beats b: 1 / (1 + exp(-(ra - rb) / RATING_SCALE)).
static func win_chance(ra: float, rb: float) -> float

## Her opponent in this round's pairs: the other id in her pair (BYE included), "" when she is in no pair.
static func opponent(pairs: Array, her_id: String) -> String

## The round's winners, one per pair, in pair order: a BYE loses to anyone (BYE v BYE -> BYE); her pair -> her_id when
## her_won else the other id; every other pair by win_chance with ONE RandomNumberGenerator seeded `seed`, drawing ONE
## randf() per contested non-her pair in pair order (a wins when randf() < win_chance(ra, rb)).
## ratings = {id: rating}.
static func winners(pairs: Array, ratings: Dictionary, her_id: String, her_won: bool, seed: int) -> Array

## The next round's pairs from this round's winners: [[w0, w1], [w2, w3], ...]; [] when fewer than 2 winners.
static func next_round(winners: Array) -> Array
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): order(8) == [1, 8, 4, 5, 2, 7, 3, 6].
2. order(1) == [1]; order(2) == [1, 2]; order(4) == [1, 4, 2, 3]; order(16).size() == 16 and order(16)[0] == 1 and
   order(16)[1] == 16.
3. seeds: [{"id":"c","rating":60},{"id":"a","rating":70},{"id":"b","rating":60}] -> ["a", "b", "c"].
4. first_round of 6 entrants e1..e6 with ratings 90, 80, 70, 60, 50, 40 -> P = 8, pairs
   [["e1","BYE"],["e4","e5"],["e2","BYE"],["e3","e6"]].
5. first_round of 2 -> [["e1","e2"]]; of 1 -> [["e1","BYE"]]; of 0 -> [].
6. win_chance(60, 60) == 0.5; win_chance(68, 60) is about 0.731 (abs diff < 0.001); win_chance(a,b) + win_chance(b,a) == 1.
7. opponent(test-4 pairs, "e4") == "e5"; opponent(test-4 pairs, "e1") == "BYE"; opponent(test-4 pairs, "zz") == "".
8. winners(test-4 pairs, ratings, "e4", true, 7): [0] == "e1", [1] == "e4", [2] == "e2", [3] in ["e3","e6"];
   with her_won false: [1] == "e5". Same seed -> same list; BYE v BYE -> "BYE".
9. Over seeds 1..400: in pair ["e1","e6"] (90 v 40) e1 wins at least 390 times; in ["x","y"] (60 v 60) x wins 160-240 times.
10. next_round(["a","b","c","d"]) == [["a","b"],["c","d"]]; next_round(["a"]) == [].
11. No function changes its inputs (deep-compare entrants/pairs/ratings before and after).

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/champ_draw_test.gd
```
Use exactly that exe (never the console variant). Output must show `CHAMP_DRAW failures=0` and no `SCRIPT ERROR`. No output in
60 s = a script error. Regression (must stay green): `tests/season_path_test.gd` -> `SEASON_PATH failures=0`.
Read `E:\FightCamp\Game\research\GDSCRIPT_TRAPS.md` first (Variant `:=`, `%%`, integer division).

## Prior research
searched: national championships amateur entry regional (S325). Game `research/C52_THE_TOURNAMENT_AND_THE_GRADE.md`
(store the organiser's format and a variable bout count - draws of any size with byes); Lean `scripts/rules/SeasonPath.gd`
(when the rounds are; read only).

## What would a human do?
A championship's draw secretary seeds the entrants by ranking, places seeds 1 and 2 in opposite halves, gives the top seeds
the byes, and publishes the bracket; the results of each session decide the next session's pairs.

## Prefab check
Nothing to buy: a few static functions over our own data (the standard seeding order is public knowledge).

## Contract
OWNS: scripts/rules/ChampDraw.gd, tests/champ_draw_test.gd (Lean repo)
RED_TEST: tests/champ_draw_test.gd (fails before the module exists - test 1)
REGRESSION: tests/season_path_test.gd
VISUAL: none (pure rules)

## When done
Commit both files on qwen/champdraw1, message ending `RESULT: tests/champ_draw_test.gd -> CHAMP_DRAW failures=0`, and
paste the last 25 lines of the test run in your final answer. Leave this brief uncommitted.
