# TASK LUDO-TELLS1 - V4 named, permanent tells (pure module + data) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the three NEW files below; edit nothing else.

## Owned files
- `Godot/assets/data/tells.json` (NEW)
- `Godot/scripts/Tells.gd` (NEW, pure)
- `Godot/tests/tells_test.gd` (NEW)

## Prior research
Design approved by the studio head (Ludo, lead designer): a camp reveals up to 3 NAMED opponent tells; a TELL comes from sparring the
partner cast to look like the opponent, an EXIT comes from film study (depth 0-3). In the fight corner the chief second spends 1 action
point to switch one revealed read ON for the rest of the bout:
- TELL activation: "Opponent Counter Window +15%" (permanent for the bout). Blunder (rushed AP failed): "Opponent Counter Window -10% next round".
- EXIT activation: "Trap Defense +20%, Clinch Break +25%" (permanent). Blunder: "Fighter circles into opponent power side (+15% damage taken) next round".
Examples of tell names from the design: "Drops left hand after right cross", "Freezes against southpaw jabs", "Gasses in Round 7 after body
shots", "Drops his left hand when lunging", "Overhands lead with a duck", "Over-hooks when cornered".
The existing (to be replaced later, do not edit) two-slot model: `Godot/scripts/CornerPitStop.gd` lines ~64-77 (READ_CARDS tell/exit).

## What would a human do?
Write a small table of tells per fighting style, one pure function that reveals them from what the camp did, and test it like a table.

## Prefab check
N/A - our own rules module.

## Spec
`tells.json`: {"styles": {"out_boxer": [...], "swarmer": [...], "counter_puncher": [...], "slugger": [...], "boxer_puncher": [...],
"default": [...]}} - each list has at least 2 entries of kind "tell" and 3 of kind "exit": {"id", "kind": "tell"|"exit", "name" (<= 40 chars,
player-facing, in the style of the examples), "effect": {...}, "blunder": {...}}. Effects use the numbers above exactly, as fractions:
tell {"counter_window": 0.15}, blunder {"counter_window": -0.10, "rounds": 1}; exit {"trap_defense": 0.20, "clinch_break": 0.25}, blunder
{"damage_taken": 0.15, "rounds": 1}.

`Tells.gd` (extends RefCounted, static only, reads tells.json once like a cached table; no other preloads, no RNG, no GameState):
- `pool(style: String) -> Array` - that style's list, or "default" for an unknown style.
- `revealed(opponent: Dictionary, film_depth: int, partner_matched: bool) -> Array` - opponent = {"id": String, "style": String}.
  EXIT tells revealed = clamp(film_depth, 0, 3); TELL tells revealed = 1 if partner_matched else 0; total capped at 3 (EXITs first when the
  cap bites, then the TELL - keep the TELL if film_depth == 3 by dropping the last EXIT). The ORDER inside each kind is a stable,
  deterministic shuffle by `hash(opponent.id + tell.id)` so two opponents of the same style do not show the same tells, and the same
  opponent always shows the same ones.
- `activate(tell: Dictionary, blunder: bool) -> Dictionary` - the effect dict (or the blunder dict when blunder).
- `MAX_REVEALED := 3`.

## Test command (tier: new files only)
Parse: `python Godot/tools/check_scripts.py Godot/scripts/Tells.gd Godot/tests/tells_test.gd`
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/tells_test.gd` -> rc 0, `TELLS_TEST FAILS=0`, no SCRIPT ERROR.
The test (house style of `Godot/tests/shown_record_test.gd`: extends SceneTree, `_check(ok, message)`, prints FAILS, quit(1 if failures)):
every style has >= 2 tell + >= 3 exit; depth 0/1/2/3 x partner yes/no -> exact counts (0,1,2,3 EXIT; +1 TELL; cap 3 with the TELL kept at
depth 3); same opponent twice -> same list; two opponents of one style -> different order at least once over 10 ids; unknown style ->
default pool; activate() numbers exact (1e-6); names <= 40 chars. Print one POPULATION line (styles + ids used).
List 3 mutants in the PR (cap 4 instead of 3; TELL dropped instead of last EXIT; blunder ignored) with the FAIL count each produced.
The test loads no 3D model (CI has no LFS).

## The one trap
Godot's `hash()` on a String is stable within one engine version - use it, never `randi()`; sort by the hash value to get the order.
