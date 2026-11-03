# TASK KNOCKDOWN1 - QWEN - standing counts, knockdowns and stoppages as a pure rule module (Lean, fight model step 2)
Status: DONE (S300 5a2f1670)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_KNOCKDOWN1 (branch qwen/knockdown1). Commit there; do not push.

## Why
Today a bout only ends on the cards. The agreed fight model (Lean `docs/FIGHT_MODEL.md`, read it, 78 lines) says:
knockdowns are decided in the simulation from power and damage against chin, heart decides the count, and there is a
stoppage path. Real target rates for women's amateurs are being researched; until they land the constants are tunable and
the test BOUNDS the rates (never an exact count). Claude wires the module into Bouts after you land.

## Owned files (create both; touch nothing else)
- `scripts/rules/Knockdowns.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/knockdowns_test.gd` (new, `extends SceneTree`, same shape as `tests/round_script_test.gd`: `failures`, `_check`,
  print `KNOCKDOWNS failures=<n>`, `quit(1 if failures else 0)`)

## The module (exact API; every constant at the top with a one-line comment)
```
## Amateur rule: three counts in one round or four in the bout and the referee stops it (RSC).
const COUNTS_ROUND_STOP := 3
const COUNTS_BOUT_STOP := 4
const BASE_COUNT := 0.09          # chance of a count for the loser of a CLEAR round between equals (tunable)
const MARGIN_FACTOR := {"close": 0.3, "clear": 1.0, "dominant": 2.2}
const POWER_CHIN_SCALE := 12.0    # every 12 points of winner power over loser chin multiplies the chance by e
const DAMAGE_SCALE := 60.0        # accumulated head damage 60 doubles the chance
const DAMAGE_PER_ROUND := {"close": 4.0, "clear": 9.0, "dominant": 16.0}   # added to the round's loser
const WINNER_DAMAGE := 2.0

## One round's counts. margin = "close"|"clear"|"dominant" (RoundScript.margin of the round); loser = "a"|"b";
## sides = {"a": {"power","chin","heart"}, "b": {...}} (heart 0..100; a missing key = 55); damage = {"a": float, "b": float}
## going INTO the round; counts_so_far = {"a": int, "b": int} in the bout; rng is seeded by the caller.
## Only the round's LOSER can be counted (the sim already decided the round). At most 3 counts in one round.
## Each count: chance p = BASE_COUNT * MARGIN_FACTOR[margin] * exp((winner.power - loser.chin) / POWER_CHIN_SCALE)
##   * (1 + damage[loser] / DAMAGE_SCALE), capped at 0.85; after a count, the next one in the same round uses p * 0.6.
## The count she beats: up_at = clamp(8 - int(heart / 25) + (1 if damage > 70 else 0), 2, 9) ("up at 6").
## She stays down (a KO) when damage[loser] after the round >= 80 and rng.randf() < (1 - heart / 100) * 0.5.
## Returns {"loser": loser, "counts": int, "up_at": [int per count], "stopped": bool,
##          "how": "" | "RSC" (count rule) | "KO" (stayed down), "damage": {"a": float, "b": float} AFTER the round}.
static func round_counts(margin: String, loser: String, sides: Dictionary, damage: Dictionary, counts_so_far: Dictionary,
    rng: RandomNumberGenerator) -> Dictionary

## A whole bout for the tests and the balancing: rounds rounds; each round's winner and margin come from
## (power_a - power_b) + rng.randf_range(-6, 6) (> 0 = a wins; |diff| < 1.5 close, >= 4 dominant, else clear);
## stops at the first stoppage. Returns {"counts": {"a": int, "b": int}, "stopped": bool, "how": "", "by": "a"|"b"|"",
##   "round": int (the round it ended, or rounds)}.
static func simulate_bout(sides: Dictionary, rounds: int, seed_value: int) -> Dictionary
```

## Tests (all must pass; print `KNOCKDOWNS failures=0`; 1,000 bouts each unless said)
1. Two EVEN fighters (all 60, heart 55), 3 rounds: share of bouts with at least one count in [0.05, 0.35]; share stopped
   in [0.01, 0.15]. Print both shares.
2. Big puncher (power 72) vs weak chin (chin 48): more bouts with a count on the weak chin than in test 1, and more
   than the reverse match (power 48 vs chin 72).
3. Only the loser is counted: in round_counts the winner's count is always 0 (200 rolls).
4. Heart: over 500 counted rounds, the mean up_at for heart 90 is LOWER (up earlier) than for heart 20.
5. The count rule: counts_so_far {"a": 3} + one more count in the bout -> stopped, how "RSC". Three counts in one round ->
   stopped, how "RSC".
6. A KO only at damage >= 80: damage 30 going in, a close round -> how is never "KO" (500 rolls).
7. Determinism: simulate_bout with the same seed twice gives the same dict; different seeds give at least two different
   outcomes over 50 seeds.
8. Damage grows: after a dominant round the loser's damage rose by DAMAGE_PER_ROUND["dominant"], the winner's by WINNER_DAMAGE.
Write one test first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/knockdowns_test.gd
```
NEVER the `_console.exe`. The exit code alone is not a pass: the output must show `KNOCKDOWNS failures=0` and no
`SCRIPT ERROR`. Nothing else to run.

## Contract
OWNS: scripts/rules/Knockdowns.gd, tests/knockdowns_test.gd   (Lean repo)
RED_TEST: tests/knockdowns_test.gd -> KNOCKDOWNS failures=0
REGRESSION: none (a new module, nothing calls it yet)
VISUAL: no

## The one trap
GDScript `:=` on a Variant (a value read from a Dictionary) is a parse error: `var x: float = float(d["k"])`. `exp()` is a
global. A parse error HANGS a headless run: no output in 60 s = kill it and look for a parse error.

## Prior research
Old repo topics/knockdowns_stoppage.md: men's UFC 35% of bouts have a knockdown (not our target), boxing pro ~47% KO/TKO,
doctor stoppage ~1%; the old engine once ran 3.3x too many knockdowns - hence bounded rates. John (TASK_J_KDRATES1) is
researching women's amateur rates; the constants get tuned when he lands.

## What would a human do?
An amateur referee: a standing count when a boxer is hurt and not defending, three in a round or four in a bout and it
is over; a brave fighter beats the count early, a hurt one with no heart stays down.

## Prefab check
Nothing to buy: a pure rules module.

## When done
Commit both files on qwen/knockdown1, message ending `RESULT: tests/knockdowns_test.gd -> KNOCKDOWNS failures=0`, and
paste the last 20 lines of the test run (with the printed shares) in your final answer.
