# TASK SHOUT1A - apron shouts work in the live fight (engine half, switch `ludo_shouts`, default OFF)

Model: cloud Codex (issue label `codex`, gpt-6-luna). Branch: the workflow names it. Never master, never HANDOFF.md, never AgentComms/.
Operator S188 ("yes all picks", SHOUT1): "Mid-round shouts from the apron: 3 per round on a cooldown ('off the ropes', 'go to the
body', 'tie him up'); success = ring IQ x his trust". This is the ENGINE half; the shout buttons on the fight HUD are SHOUT1B (later, UI).

## Owned files
- `Godot/scripts/FightRealtime.gd` (~9,000 lines - NEVER read whole; grep + `sed -n` windows). Anchors:
  - option pattern: grep `ludo_referee` (REFEREE1A, merged 83fe52b6) and copy it; do NOT add the switch to DEMO_SWITCHES (~1170).
  - plan knobs the effects must reuse: `corner_volume` (~4109 in the "volume" weight), `region_weights` (~1925/4034 - body vs head bias),
    the ropes accumulator `_composure_on_ropes_tick` (~8937, `_composure_ropes_s`), composure (`Composure.apply`, band via `Composure.band`).
  - the doctor's pattern for a player decision entering the engine: `resolve_doctor_choice` (~3722).
- `Godot/tests/shout_live_test.gd` (NEW).

## Prior research
- Pure rules merged S194 (1a0e8a73): `Godot/scripts/rules/ApronShouts.gd` (`attempt_shout(...)`, `calculate_adherence_chance(...)`) +
  `Godot/assets/data/apron_shouts.json` (3 per round, 22 s cooldown, 1.5 stamina, 2.5 s distraction on failure; per shout a trust
  threshold, iq/trust weights, success_effect, failure_cost). REUSE them; never copy numbers into the engine.
- Design: `research/LUDO_ROUND17_S193.md` (shouts section). Coach trust: if the fighter dict has no `coach_trust`, read 50.

## What would a human do?
Give the engine one entry point the HUD will call - `shout(state, side, shout_id)` - that rolls the shout on the fight's own RNG, logs
it, and turns success/failure into short-lived changes on knobs the engine already has.

## Spec
1. `static func shout(state, side, shout_id) -> Dictionary`: only when `state.has("ludo_shouts")`; counts per round + last-shout time per
   side in state; calls `ApronShouts.attempt_shout` with the fighter's fight_iq as ring IQ, coach_trust, the composure band (or
   "Focused" when composure is off) and a roll from a DEDICATED rng stream (`_stream(seed, <new offset>)` - never the impact/decision
   streams, so an unshouted fight is unchanged); logs `{type: "shout", side, id, success, reason}`; returns the result.
2. Effects for `success_effect` / `failure_cost`, each for a bounded number of seconds (name the durations as consts):
   OFF_THE_ROPES success -> clear the ropes accumulator + a lateral move bias; GO_TO_THE_BODY success -> body region weight x the json
   multiplier; the third shout's effect as its json says; composure_delta through `Composure.apply`; failure -> guard drop for its
   duration + composure_delta; stamina cost from the result. Anything the engine cannot express yet: log it as intent, never fake it.
3. OFF (switch off, or switch on and nobody shouts): the log hash equals master's (print both in the test).

## Done (tier: script edited - parse, focused test, related runs)
- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/shout_live_test.gd`.
- `shout_live_test.gd`: two DIFFERENT boxers (name them in the output), 6 seeds. A 4th shout in one round is refused (MAX_CAP_REACHED);
  a shout inside 22 s is refused (COOLDOWN_ACTIVE); a successful GO_TO_THE_BODY raises that fighter's body-shot share over the next
  20 s vs the same seed unshouted; a failed shout lowers composure; switch ON with no shout -> log hash = master. RED first on master
  (paste the count), then green.
- `python Godot/tools/run_tests.py --only fight_realtime --jobs 2`, `--only composure --jobs 2`, `--only referee --jobs 2` -> 0 fails
  (say if a test cannot run on CI for lack of LFS models).
Final message: red count, green results, the hash proof.

## The one trap
A shout arrives from the HUD between ticks. Apply it at the START of the next tick (queue it in state), never mid-tick, so the presented
fight and the log agree about when it happened.
