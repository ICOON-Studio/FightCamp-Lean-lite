# TASK KITS1 (S224) - boxer kits: the data + the clash rule + its test (Arena, pure)

Model: cloud Qwen (label `qwen`), default model. Branch qwen/issue-<n>; never master. Read `.github/CLOUD_AGENT.md` first.
Approved: operator Q-S221-6 "Approve, build it" on `research/LUDO_ROUND62_VERDICT_S223.md` part A (read it). Sources:
`research/M43_MARIA_REPLY.md` (12 kits with hexes; s1.3 the contrast rules R1-R3, E1-E3; s2.1 her computed tables) and
`research/LUDO_ROUND62_REPLY_S223.txt` (~lines 17-90: the 10 kits kept, Magenta + Silver CUT, boot rule).

## Build
1. `Godot/assets/data/boxer_kits.json`: the 10 kits Ludo kept, ids K01..K10 as in Ludo's table minus the cut ones (keep Maria's ids;
   do not renumber), each `{"id","name","trunk","trim","waistband","gloves","tape":"#f4f4f2","boot_base":"#121212"|"#f4f4f2",
   "boot_accent"}` - hexes from Maria's table, corrected where Ludo's table changes them; boots neutral black or white with the kit
   colour as accent (laces, ankle strap, heel); only K03 White and K04 Black may run solid boots. Plus `"canvas":"#cfcac2"`,
   `"crowd":"#1c1916"`, `"warm_light":"#ffb674"` and `"rules"` holding Maria's numbers (R1 dE00 >= 20 worst of six conditions;
   R2 WCAG >= 1.5; R3 waistband light/dark or dE00 >= 30; E1 canvas; E3 ropes).
2. `Godot/scripts/rules/KitClash.gd` (extends RefCounted, static funcs, no preloads, no RNG):
   - colour maths: `hex_to_lab`, `delta_e2000(a, b)` (CIEDE2000, the standard formula), `wcag_ratio(a, b)`, simulations `protan`,
     `deutan`, `tritan` (Machado 2009 matrices, severity 1.0) and `warm(c)` (linear-light multiply by warm_light) - the six conditions
     of R1 = normal, protan, deutan, warm, warm+protan, warm+deutan;
   - `clash(kit_a, kit_b, data) -> Dictionary` `{"clash": bool, "worst_de": float, "condition": String, "failed": [rule ids]}`;
   - `resolve(home_kit_id, away_kit_id, away_alt_kit_id, data) -> Dictionary` `{"home": id, "away": id, "reason": String}`: if home vs
     away clashes the away boxer switches to his alternate; if that clashes too he wears K03 White, or K04 Black when home is White.
3. No switch, no scene, no visuals - the Codex kit task wires it later.

## Test (blind, from this contract): `Godot/tests/kit_clash_test.gd`
extends SceneTree; prints `KIT_CLASH PASS checks=N` / FAIL; non-zero exit on failure.
(a) data: exactly 10 kits; no id named Magenta or Silver; every hex valid; every boot base is #121212 or #f4f4f2.
(b) CIEDE2000 against the published Sharma 2005 test pairs - at least 6 rows of that table, each within 0.0001.
(c) wcag_ratio(#000000, #ffffff) == 21.0; (#777777, #ffffff) in 4.47..4.49.
(d) a kit vs itself always clashes; Crimson vs Royal Blue does not.
(e) EVERY ordered pair of the 10 (90 pairs) with every possible alternate: resolve() never returns two kits that clash.
(f) White home vs White away -> away gets Black.
(g) MUTANT: run (e) with the R1 threshold set to 0 inside the test (a data copy) - show it lets at least one clashing pair through,
    proving (e) can read worse.
Parse: `python Godot/tools/check_scripts.py Godot/scripts/rules/KitClash.gd Godot/tests/kit_clash_test.gd`; run:
`godot --headless --path Godot --script tests/kit_clash_test.gd`.

## Owned files
New only: the json, the module, the test. Touch nothing else.

## The one trap
Read Maria's hexes from her tables, never invent one; GDScript `:=` on Dictionary values fails to parse - type every var
(`research/GDSCRIPT_TRAPS.md`).

## Prior research
M43_MARIA_REPLY.md (computed contrast incl. colour-blind), LUDO_ROUND62_REPLY_S223.txt part A, Nevada / A.P.B.C. kit rules cited by Maria.

## What would a human do?
A broadcast colour checker: the inspector picks contrasting trunks before the bout, and the away corner changes.

## Prefab check
CIEDE2000 and Machado CVD matrices are public formulas - implemented in-module, no library (GDScript has none).
