# TASK LUDO-CORNER2P - the between-rounds resolution as ONE pure function (Ludo corner + doctor odds) - Arena

Model: Arena Agent Mode. Repo ICOON-Studio/FightCamp, branch from master; work ONLY on your own arena/ branch, open a PR into master,
NEVER merge it. Write ONLY the two NEW files below; edit nothing else. Do not delete or weaken any existing test.

## Owned files
- `Godot/scripts/CornerBreak.gd` (NEW, pure: extends RefCounted, static funcs only, no autoload; it may preload ONLY
  `res://scripts/LudoCorner.gd` and `res://scripts/CutsDoctor.gd`)
- `Godot/tests/corner_break_test.gd` (NEW, extends SceneTree)

## Prior research
- `Godot/scripts/LudoCorner.gd` + `Godot/assets/data/ludo_corner.json` (merged, approved D40): `state_word(head, composure, bpm,
  score_diff)`, `tone_effect(state, tone)`, `lane_plan(lane, picks)`, `resolve(lane, picks, roll)` and the three lanes' actions
  (cutman / second / chief) with their effects and blunders. Read the whole data file.
- `Godot/scripts/CutsDoctor.gd` + `cuts_doctor.json` (merged, D42): `stoppage_chance(pips, cutman)`.
- Design: `research/LUDO_CORNER_TABLES_S190.md` (Ludo, verbatim) - one drawer, 3 lanes x 2 AP, a rushed 3rd AP risks a 35% blunder.
- House style: `Godot/scripts/PromoterTrap.gd` + `Godot/tests/promoter_trap_test.gd`.

## What would a human do?
One function that takes the fighter's state at the bell and the player's picks per lane, runs the existing table functions, and returns
the fighter's state for the next round plus the lines the stool shows - no new numbers.

## Spec
`CornerBreak.resolve_break(fighter: Dictionary, picks: Dictionary, tone: String, rolls: Dictionary) -> Dictionary`
- fighter: {head (0-100), composure (0-100), bpm, stamina (0-1), score_diff (int), swelling_pips, bleed_pips (0-5), plan (0-1)}.
- picks: {"cutman": [...ids], "second": [...ids], "chief": [...ids]}; tone in {"calm","fire","truth"} (used only if chief picks
  "deliver_tone"); rolls: {"cutman": 0..1, "second": 0..1, "chief": 0..1} (the caller rolls - NEVER randf()).
- Steps: state = LudoCorner.state_word(...) BEFORE any action; each lane: LudoCorner.lane_plan (refuse the whole break with {ok:false,
  reason} if any lane is invalid) then LudoCorner.resolve with that lane's roll; apply every effect/blunder key that maps onto the
  fighter (swelling_pips, bleed_pips clamp 0-5; bpm; stamina clamp 0-1; composure clamp 0-100; plan clamp 0-1); "tone_applied" ->
  apply LudoCorner.tone_effect(state, tone)'s composure/bpm/plan; carry every other key (counter_window, trap_defence, clinch_break,
  visual_tracking, cut_prob, doctor_risk, dmg_taken, ...) into "round_mods" (summed). doctor_risk sums into "doctor_risk_reduction".
- Returns {ok, state_word, fighter (updated copy), round_mods, doctor_odds: CutsDoctor.stoppage_chance(bleed_pips, ...) as a fraction with
  the reduction applied (floor 0), lines: [short stool lines for the UI, e.g. "PANICKED - Calm: composure +20, pulse -25"], blunders: [...]}.
- The input dicts are never mutated.

## Done = (tier: new files only - parse + this test)
Parse gate, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/corner_break_test.gd` (Linux: the Godot 4.7.2
headless binary from Tools/cloud_setup.sh) -> `CORNER_BREAK_TEST FAILS=0`, no SCRIPT ERROR, no engine ERROR line. Cases (numbers typed
from ludo_corner.json / cuts_doctor.json, not read back): a PANICKED fighter (bpm 188, composure 40) + chief deliver_tone calm -> composure
+20, bpm -25; ice_enswell + adrenaline_swab -> swelling -1, bleed -1, doctor odds at 4 pips 0.70 -> 0.50; a rushed 3rd AP with roll 0.2 ->
blunder applied, roll 0.5 -> not; an invalid lane pick -> ok false and the fighter unchanged; clamps hold (bleed never below 0 or above 5,
stamina 0-1); inputs not mutated. PR description: 3 mutants with FAIL counts - (a) state word computed AFTER the actions, (b) swab
reduction ignored, (c) blunder threshold 0.35 -> 0.5.

## The one trap
JSON numbers parse as floats in Godot - compare with an epsilon; unknown ids are push_warning, never push_error (our runner fails any
engine ERROR line).
