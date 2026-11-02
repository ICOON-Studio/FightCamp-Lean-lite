# TASK LASTSPAR1A - the last spar's three irreversible choices as data + a pure resolver + test (S198)
Model: Arena (cloud). Repository ICOON-Studio/FightCamp (Godot 4.7.2, GDScript in Godot/). Work on your own arena/ branch, open a PR
into master, never merge it yourself.

## Owned files
- `Godot/assets/data/last_spar.json` (NEW)
- `Godot/scripts/rules/LastSpar.gd` (NEW)
- `Godot/tests/last_spar_test.gd` (NEW)

## Spec (operator approved, board Q-S196-3: "the last spar = one screen, three irreversible choices with predicted effects";
## his S188 rule "lock one, sacrifice one")
After Thursday's 2-round test spar the player commits ONE of three options for fight night. Numbers (Ludo's definitive table):

| metric | DEFENSIVE_LOCK | DOUBLE_DOWN | TAPER |
|---|---|---|---|
| opponent_signature_ko_mult | 0.35 | 1.0 | 1.0 |
| counter_risk_mult | 1.0 | 1.40 | 1.0 |
| power_output_mult | 0.85 | 1.25 | 1.0 |
| hand_foot_speed_mult | 0.92 | 1.0 | 1.10 |
| stagger_rate_mult | 0.88 | 1.30 | 1.0 |
| start_stamina_delta | 0 | -8 | +15 |
| snap_mult | 0.96 | 1.06 | (locked to 1.0 peak: `snap_lock: true`) |
| cut_risk_mult | 0.50 | 1.35 | 0.85 |
| cards | deactivate the card in `options.lead_card` | force active the card in `options.power_card` | freeze all equipped cards (`cards_frozen: true`) |

1. `last_spar.json`: the three options with id, title ("THE DEFENSIVE LOCK", "DOUBLE-DOWN", "TISSUE TAPER"), one-line intent, the
   effects above, and `note` naming the source (Ludo round 33 5.2, approved round 32 5.2).
2. `LastSpar.gd`: `extends RefCounted`, `class_name LastSpar`, pure static, loads + caches the json (copy the pattern of
   `Godot/scripts/rules/CutScar.gd`). API:
   - `options() -> Array` (deep copies, in table order);
   - `commit(state: Dictionary, option_id: String, ctx: Dictionary = {}) -> Dictionary` - `state` is a plain fight-night modifier dict;
     returns `{ok, state}` where the effects are applied ONCE: multipliers multiply what is already there (missing key = 1.0),
     start_stamina_delta adds, `committed: option_id` is set; a second commit on a state that already has `committed` returns
     `{ok:false, reason:"ALREADY COMMITTED"}` (irreversible); unknown id -> ok:false. `ctx.lead_card` / `ctx.power_card` name the cards
     for the card effects (`deactivated_cards` / `forced_cards` arrays, `cards_frozen` bool).
   - `predict(option_id: String) -> Array` of plain strings for the screen, e.g. "Opponent KO threat -65%", "Counters taken +40%",
     "Starting stamina +15", "Snap locked at 100%".
3. `last_spar_test.gd` (extends SceneTree; prints `LASTSPAR total=N fails=M`; quit(1) on fail): 3 options with unique ids; every table
   number read back exactly; commit applies each multiplier to an existing 1.2 value (1.2 x 0.85 etc.); a second commit refuses;
   unknown id refuses; the input state is not mutated; predict lines contain the signed percentages; card effects with ctx names.
   List 3 mutants in the PR body that each make the test fail.

## Gate
`godot --headless --path Godot --script tests/last_spar_test.gd` exits 0, fails=0, no SCRIPT ERROR. Typed GDScript, tabs, never `:=`
on a Variant. The test loads no models (no LFS), so CI can run it.

## Prior research
research/LUDO_ROUND32_S197.txt "5.2 The Last-Spar Decision Screen"; LUDO_ROUND33_S198.txt "The Irreversible Last-Spar
Choices & Outcomes"; `Godot/scripts/SparRead.gd` (the spar panel's numbers - read-only context, do not edit).
## What would a human do?
A head coach after the last spar picks one game plan and writes down what it costs; he does not change it on fight night.
## Prefab check
None - our own rules.

## The one trap
"Irreversible" is the mechanic: a second commit must refuse, and `commit` must return a NEW dict without touching the caller's.
Do not delete or weaken any existing test to make CI green.
