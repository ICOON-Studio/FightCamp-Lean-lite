# TASK STATS1A - the fighter readout model: 9 headline numbers 0-100, monthly change, body wear bands, scouting mask (S197)
Model: cloud Codex (issue label `codex`) - one pure module + one headless test; no UI, no LFS, no edits to existing files.
Operator approved (board Q-S196-2, verbatim: "amazing, approve all and use 0-100 for band as ludo says") Ludo round 32 PART 2 -
research/LUDO_ROUND32_S197.txt section "PART 2 - THE FIGHTER READOUT" (2.2 grid, 2.3 wear bands, 2.4 composure, 2.5 scouting) and
research/LUDO_ROUND32_VERDICT_S197.md section A.

## Decision (Claude, lead developer) - the 9 headlines and where each comes from
Ludo's 9: POWER, TECHNIQUE, SPEED, STAMINA, CHIN, DEFENCE, FOOTWORK, RING IQ, COMPOSURE. Our athlete dict keeps 9 stats in
`STAT_KEYS` (Godot/scripts/AthleteDevelopment.gd:34: power, technique, speed, defense, conditioning, fight_iq, grapple_offense,
grapple_defence, top_control) plus other fields. Map: POWER<-power, TECHNIQUE<-technique, SPEED<-speed, DEFENCE<-defense,
STAMINA<-conditioning, RING IQ<-fight_iq. CHIN, FOOTWORK, COMPOSURE: grep the repo for the athlete's existing chin/durability,
footwork/movement and composure fields (Composure.gd, FighterHand.gd, BodyReadiness.gd, GameState athlete creation) and use them;
if one truly does not exist, derive it from named existing fields and write the formula in a comment + the PR body - never a constant.
Grappling stats are not shown for a boxer (they stay in the TECHNIQUES tab later).
Scale: our stats are stored on their own scale (find it - 0-100 or 1-20); the readout shows 0-100 (convert linearly, round to int).

## Build (NEW files only)
1. `Godot/scripts/rules/FighterReadout.gd` - extends RefCounted, class_name FighterReadout, pure static, no GameState/autoload/RNG.
   - `headlines(athlete: Dictionary) -> Array` of 9 {key, label, value 0-100}
   - `with_delta(now: Dictionary, month_ago: Dictionary) -> Array` adds `delta` (float, one decimal) per headline
   - `regions(athlete: Dictionary) -> Array` of our 6 regions (head_neck, torso_core, left_arm, right_arm, left_leg, right_leg) with
     wear 0-100 (read the athlete's existing region wear/health field - find it, e.g. BodyReadiness / FighterHand), band
     {Pristine 0-14 #10B981, Fatigued 15-39 #FBBF24, Degraded 40-69 #F97316, Compromised 70-89 #EF4444, Critical 90-100 #7F1D1D}
   - `composure_band(value_0_100: float) -> Dictionary` FOCUSED 80-100 / RATTLED 55-79 / SHAKEN 25-54 / BROKEN 0-24 with Ludo's colours
   - `masked(readout: Dictionary, scout_level: int) -> Dictionary` - level 0: values replaced by letter-grade ranges ("C- to A"), regions
     hidden, techniques "???"; 1: numeric ranges +-5 (clamped 0-100); 2: exact numbers; 3: exact + region wear revealed.
2. `Godot/tests/fighter_readout_test.gd` - extends SceneTree, prints `READOUT total=N fails=M`, quit(1) on fail: builds 2 DIFFERENT
   athletes from code (different stats, frame and style - never identical), checks 9 headlines in 0-100, conversion correct at both ends
   of our scale, deltas sign/size, every band boundary (14/15 ... 89/90), composure boundaries, and each scout level hides exactly what
   it should. 3 mutants in the PR body that each fail.

## Rules
Typed GDScript, tabs, never `:=` on a Variant, `%` in format strings written `%%`. Repository ICOON-Studio/FightCamp; branch codex/issue-<n>,
open a PR into master, never merge. Acceptance: `godot --headless --path Godot --script tests/fighter_readout_test.gd` exits 0,
fails=0, no SCRIPT ERROR.
