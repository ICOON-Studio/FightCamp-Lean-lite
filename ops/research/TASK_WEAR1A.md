# TASK WEAR1A - career wear ACCUMULATES on the athlete (state + getter only, behind switch `career_wear`, default OFF)

Model: cloud Qwen (issue label `qwen`). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", WEAR1): "Career wear as a VISIBLE meter (wars, hard sparring, concussive damage); spent = a permanently
worse chin". This task is the STATE half; the meter on screen is WEAR1B (later, Cursor).

## Owned files
- `Godot/scripts/GameState.gd` (~17,900 lines - NEVER read whole; `sed -n` windows / grep only). Only these edits:
  a) `is_career_wear_on()` beside the other switches (pattern: `is_schedule_my_gym_on` ~17333 - career key OR user arg "career_wear").
  b) after a PLAYER bout is recorded: in `record_watched_world_bout` (~3175) where `history_row["knockdowns_suffered"]` is written (~3286),
     when the switch is on and the athlete is one of the player's, add wear for `knockdown_suffered` x count, and
     `deep_cut_survived_to_decision` once when the sim_result says a cut of 4+ pips went to the cards (if sim_result carries no cut data,
     add nothing - never invent it; write a `# WEAR1A: no cut data in sim_result yet` note).
  c) after a spar settles: `_settle_spar` (~6371) - when the switch is on, each side gets `hard_sparring_round` x rounds_done ONLY when
     intensity is the hard one (find the constant in GymSparring.gd; never a string literal).
  d) `get_athlete_wear(athlete_id) -> Dictionary` returning `{wear: float, tier: String, effective_chin, stamina_recovery_mult,
     cut_resistance_mult, retire_prompt}` from `CareerWear.calculate_fighter_degradations` (base chin / recovery from the athlete's own stats).
- `Godot/tests/career_wear_state_test.gd` (NEW).

## Prior research
- Pure rules, merged S194 (1a0e8a73): `Godot/scripts/rules/CareerWear.gd` + `Godot/assets/data/career_wear.json` - REUSE them; never copy
  the numbers into GameState. Ludo's design: `research/LUDO_ROUND17_S193.md` (career wear section).
- Wear is stored on the athlete dict as `career_wear` (float 0-100); a missing key reads 0.0 (old saves load unchanged).

## What would a human do?
Keep one number per fighter, add to it at the two places damage really happens (fights and hard spars), and read the chin cap from it.

## Prefab check
None needed - the pure module exists.

## Spec / Done (tier: script edited - parse, focused test, related runs)
1. Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/career_wear_state_test.gd`.
2. `career_wear_state_test.gd` (headless, uses GameState like `Godot/tests/game_training_split_test.gd` does): two DIFFERENT athletes (name
   them in the output). Switch ON: a recorded bout with 2 knockdowns suffered adds exactly 2 x 2.50 = 5.0; a hard spar of 4 rounds adds
   4 x 0.25 = 1.0; a light spar adds 0; wear 85 -> tier SPENT and effective_chin capped at 60. Switch OFF: no `career_wear` key is written by
   either path (the save dict is byte-identical to before - compare JSON.stringify of the athlete before/after).
   Write it RED first on master (paste the count), then green.
3. `python Godot/tools/run_tests.py --only spar --jobs 2` and `--only world_bout --jobs 2` -> 0 fails (say if a test cannot run on CI for
   lack of LFS models).
Final message: red count, green count, the two run_tests lines.

## The one trap
`record_watched_world_bout` records EVERY watched bout, including AI-vs-AI world bouts on the same card - only the player's athletes get
wear (find how `_is_player_bout_index` / the roster decides it); otherwise the whole world ages.
