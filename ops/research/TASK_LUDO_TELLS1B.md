# TASK LUDO-TELLS1B - Ludo's authored tells for Perez and Miller - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Do not delete or weaken any existing test.

## Owned files
- `Godot/assets/data/tells.json` (EDIT: add a top-level "authored" object; the "styles" pools stay byte-identical)
- `Godot/scripts/Tells.gd` (EDIT, 56 lines: `revealed()` prefers authored entries for an opponent id that has them)
- `Godot/tests/tells_test.gd` (EDIT: add cases; every existing case keeps passing unchanged)

## Prior research
- `research/LUDO_CAST_S190.md` section 2 - Tommy "The Hook" Perez (fight 1) and Ray "Meat-Axe" Miller (fight 2), 3 tells each, with
  kind (TELL from sparring / EXIT from film), name and effect text. Copy the names EXACTLY; keep each name <= 40 chars as written.
- `research/TASK_LUDO_TELLS1.md` - the module this extends (merged on master); its effect numbers stay the rule for every entry:
  TELL effect {counter_window 0.15} blunder {counter_window -0.10, rounds 1}; EXIT effect {trap_defense 0.20, clinch_break 0.25} blunder
  {damage_taken 0.15, rounds 1}. Ludo's per-tell flavour numbers ("+20% uppercut counter window", "punch volume drops by -35%") go into a
  separate "note" text field - they do NOT change the effect dict (one rule for every tell; the operator approved V4 that way).

## What would a human do?
Add the six hand-written entries under the two opponents' ids and make the reveal function use them first, then test exactly those six.

## Prefab check
N/A.

## Spec
`tells.json` gets `"authored": {"tommy_perez": [3 entries], "ray_miller": [3 entries]}` - same entry shape as the style pools
({id, kind, name, effect, blunder}) plus "note" (Ludo's effect text verbatim). `Tells.revealed(opponent, film_depth, partner_matched)`:
when `opponent.id` has an authored list, draw from it (same order/caps rules as today); otherwise unchanged. Add `Tells.authored(id) ->
Array` (deep copies; [] for unknown).

## Done = (tier: script edited - parse + this test)
Parse gate, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/tells_test.gd` (Linux: the Godot 4.7.2 headless
binary from Tools/cloud_setup.sh) -> `TELLS_TEST FAILS=0`, no SCRIPT ERROR. New cases: both authored lists have 3 entries with the exact
names from LUDO_CAST_S190.md typed in the test; Perez at film depth 2 + matched partner reveals only Perez's authored entries; an
unknown id still uses the style pool (the old result, unchanged); `authored()` returns copies. PR description: 2 mutants with FAIL counts -
(a) one Perez name misspelled, (b) authored lookup disabled.

## The one trap
JSON numbers parse as floats in Godot - compare arrays of numbers element-wise as int/float, never `array == [1, 2, 3]`.
