# TASK FIGHTLOG1A (S218) - fight technique tally (pure module + test)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests. Do not delete or shorten any existing test. Touch no other file.

## Why
After a real-time boxing bout the game records NO technique usage, so a boxer never gets better at the punches he lands under
pressure (queue FIGHTLOG1, Ludo r46 slice 2, approved by the operator). This task builds ONLY the bookkeeping, as one pure module.
Codex later calls it from the fight engine (one call per resolved strike) and hands the rows to the career code.

## Prior research
`research/TASK_FIGHTLOG1.md` (the full feature; this is its pure core), `LUDO_ROUND46_VERDICT_S213.md` (pressure lands),
`Godot/scripts/FightSimulation.gd` `get_technique_analytics` line ~943 (the row shape to copy).

## What would a human do?
A coach tallies what his fighter threw and landed, what landed when he was tired or hurt, and which punch the other man kept landing
on him, then sets next week's work from it.

## Prefab check
None. This is about 120 lines of counting inside our own engine.

## Do - new file `Godot/scripts/FightUsageTally.gd`
`extends RefCounted`; all functions `static`; NO preloads, autoloads, nodes, RNG or file reads. Sides are the strings "a" and "b".
```gdscript
const PRESSURE_STAMINA := 0.50       # DESIGN (Ludo r46): lander's stamina fraction below this = a pressure land
const PRESSURE_RECENT_TICKS := 60    # DESIGN: or he took a CLEAN hit within the previous 60 ticks
const EXPOSED_MIN_LANDS := 3         # DESIGN: exposed_hole needs at least 3 clean lands
static func new_tally() -> Dictionary
## One resolved strike thrown by `side` at the other side. contact: "missed" | "glancing" | "clean".
## stamina_frac = the THROWER's stamina 0..1 at the strike. A "land" = glancing or clean.
static func record_strike(tally: Dictionary, side: String, technique_id: String, technique_name: String, role: String,
		contact: String, stamina_frac: float, tick: int, damage: float, stamina_spent: float) -> void
static func usage_rows(tally: Dictionary, side: String) -> Array
static func exposed_hole(tally: Dictionary, side: String) -> Dictionary
```
Rules:
1. `record_strike` adds 1 attempt to (side, technique). A land (glancing or clean) adds 1 land, `damage` and the land counters;
   `stamina_spent` is added on every attempt.
2. PRESSURE LAND = a land where `stamina_frac < PRESSURE_STAMINA`, OR the thrower took a CLEAN hit at a tick t with
   `tick - t <= PRESSURE_RECENT_TICKS` and `t <= tick` (only hits recorded BEFORE this call count).
3. A CLEAN strike by `side` also records, for the OTHER side, `counters_taken[technique_id] += 1` (clean lands the opponent scored
   with that technique on him) and stores `tick` as that other side's last clean hit taken.
4. `usage_rows(tally, side)`: one Dictionary per technique `side` threw, keys EXACTLY: technique_id, technique_name, role, attempts,
   lands, effectiveness (100*lands/attempts, 0.0 when attempts is 0), damage, stamina_spent, pressure_lands, counters_taken (clean
   lands the opponent scored on `side` with THIS technique id, 0 if none). Sorted by attempts descending, ties by technique_id
   ascending (deterministic). A technique the opponent landed on `side` but `side` never threw does not get a row.
5. `exposed_hole(tally, side)`: the technique the OPPONENT landed CLEAN on `side` most often: {technique_id, technique_name, lands};
   ties by technique_id ascending; `{}` when the best has fewer than EXPOSED_MIN_LANDS. The name comes from the opponent's own rows.
6. Bad input never crashes: an unknown side or contact string is ignored (no change); NaN stamina_frac counts as 1.0 (not pressure).

## Test - new `Godot/tests/fight_usage_tally_test.gd`
`extends SceneTree`; prints `FIGHT_USAGE_TALLY_TEST PASS (<n> checks)` or `FAIL ...` lines; `quit(0)`/`quit(1)`. Load the module with
`load("res://scripts/FightUsageTally.gd")`. Blind, from THIS contract only. The fixture is a hand-written bout script of 30+ strikes
(both sides, jab/cross/hook/body_hook, mixed contacts, stamina falling from 1.0 to 0.3, clean hits at known ticks). Checks:
1. attempts/lands/damage per technique equal counts you compute from the fixture script INDEPENDENTLY (loop over the script).
2. pressure_lands: a land at stamina 0.49 counts, at 0.50 does not; a land 60 ticks after a clean hit counts, 61 does not; a clean
   hit recorded AFTER the strike does not count; pressure_lands <= lands everywhere.
3. counters_taken and exposed_hole: the fixture lands 3 clean hooks on "b" -> exposed_hole("b") is the hook with lands 3; with
   only 2 it is {}; ties pick the lower technique_id.
4. Row keys exactly as listed; sort order; effectiveness 0.0 at 0 attempts is impossible (no row) but 100*lands/attempts is right.
5. Unknown side / contact ignored; NaN stamina not pressure.
6. Three mutant checks inside the test, each proving an assertion would go red: (a) `<=` instead of `<` on PRESSURE_STAMINA;
   (b) counting glancing hits as clean for counters_taken; (c) a pressure window that also looks at FUTURE clean hits.

## Gate (CI runs it)
Parse gate on the 2 new files, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/fight_usage_tally_test.gd`
prints the PASS line.

## The one trap
Do not edit FightRealtime.gd, FightNightScreen.gd, GameState.gd or TechniqueStage.gd. This is the pure module only. GDScript: use
`absf`, explicit casts on Dictionary reads (`int(d["attempts"])`), and no `:=` on Variant reads.

## VISUAL GATE
Not a visual task: pure bookkeeping module, no body, animation, camera or look change (S219 note for the start check).
