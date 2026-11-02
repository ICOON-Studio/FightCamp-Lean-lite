# TASK CUTSCAR1A - the cut decision and the scar it leaves: pure module + data + test (S197)
Model: cloud seat (issue label `cline`) - pure module, no LFS, no Godot window, no game wiring.
Approved design: operator S188 "yes all picks" -> CUTSCAR1: "Fight 2 cut: towel (lose purse) vs push on (win chance, permanent
'cut prone' trait)". Ludo's spec: `research/LUDO_ROUND17_S193.md` lines 552-624 (`CutScar1.gd`, verbatim) and Claude's
verdict at line 1052 (real class name `CutScar`, tables in JSON, composure bands use OUR names Focused/Rattled/Shaken/Broken).

## What to do
1. `Godot/scripts/rules/CutScar.gd` - `extends RefCounted`, `class_name CutScar`, pure static, data from
   `res://assets/data/cut_scar.json` (cache it exactly like `Godot/scripts/rules/CareerWear.gd` does - copy that loader shape).
   No GameState, no autoload, no RNG, no preload. Functions (typed, `var n: int = ...` style - never `:=` on a Variant):
   - `resolve_corner_decision(decision_id: String) -> Dictionary` {valid, outcome, purse_penalty, scar_awarded, prestige_delta}
     for THROW_TOWEL, WAVE_HIM_ON, and (from Ludo's spec) any other decision it lists.
   - `future_cut_risk(scar_level: int, base_cut_chance: float, current_bleed_pips: int) -> Dictionary`
     {modified_cut_chance (clamped 0..1), effective_bleed_pips, doctor_risk_modifier, tier_name}; scar_level clamped 0..3;
     a missing tier falls back to the nearest LOWER tier (Ludo's table skips tier 2 - fill tier 2 in the json between 1 and 3).
   - `scar_after(current_level: int, decision_id: String) -> int` (never above 3, never below current).
2. `Godot/assets/data/cut_scar.json` - decisions + scar_tiers 0..3 from Ludo's spec, with a `note` naming the source.
3. `Godot/tests/cut_scar_test.gd` (extends SceneTree, prints `CUTSCAR total=N fails=M`, quit(1) on fails): towel costs purse and
   no scar; wave-on awards scar 1; tier 1 multiplies 1.35; tier 3 starts +1 bleed pip; clamps (level 9 -> 3, chance never > 1);
   unknown decision -> valid false; tier-2 monotonic between 1 and 3. Prove with 3 mutants (listed in the PR), each must go red.

## Owned files
Godot/scripts/rules/CutScar.gd (new), Godot/assets/data/cut_scar.json (new), Godot/tests/cut_scar_test.gd (new). Nothing else.

## Gate (CI)
`godot --headless --path Godot --script tests/cut_scar_test.gd` -> exit 0, fails=0, no SCRIPT ERROR.

## Prior research
LUDO_ROUND17_S193.md (spec + verdict); CareerWear.gd / ApronShouts.gd / RefereeStyle.gd (the sibling pure modules from the same round).
## What would a human do?
Port the designer's table into the house module pattern and lock it with tests.
## Prefab check
n/a.
## The one trap
`%` inside a GDScript format string must be `%%`; a typed `:=` on a Dictionary.get() is a parse error. Branch `goose/issue-<n>`, PR, never master.
