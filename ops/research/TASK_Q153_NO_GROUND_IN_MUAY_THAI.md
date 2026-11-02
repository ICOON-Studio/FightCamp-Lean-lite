# TASK_Q153 - a Muay Thai (or boxing/kickboxing) bout never stays on the ground (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S60, 2026-09-23.

## Evidence (your own Q152)
40 of the 54 unnamed muay_thai grapple events are GROUND-position events. Real Muay Thai has no
ground fighting: a sweep or dump that puts a man down is scored and the referee stands them up
at once. `assets/data/combat_rulesets.json` carries NO ground policy for any ruleset, so the
engine cannot know. Adding muay_thai ground techniques to the catalogue (Q152's suggestion) is
WRONG - operator rule: "The fighter you put in the fight must be in accordance to fight rules."

## Owned files
`Godot/assets/data/combat_rulesets.json` (a new per-ruleset field), `Godot/scripts/FightRealtime.gd`
(ONLY where a grapple event moves the pair to a ground seat, and where the referee resets -
grep `stand_up`, `_move_seat`, `referee`; ~file is large, sed -n windows only),
`Godot/tests/fight_ground_policy_test.gd` (NEW), `research/Q153_DIGEST.md`.

## Spec
1. New ruleset field `"ground_policy"`: `"none"` (boxing, kickboxing, muay_thai: any ground seat is
   ended by an immediate referee stand-up - both men back to standing at a reset distance),
   `"brief"` (judo: newaza allowed for a short window then stand-up - use the existing judo
   behaviour if the engine already has one, and SAY what you found), `"full"` (mma, bjj, sambo,
   wrestling). Missing field = "full" so nothing unlisted changes.
2. With "none", a sweep/dump/throw that lands a man is still an EVENT (it can score), but no
   ground SEAT persists beyond 1.0 s of fight time, and no ground technique is ever named.
3. MMA, BJJ, sambo, freestyle, greco, judo behaviour must be byte-identical for the same seed
   (determinism check: same seed with and without your change for those rulesets).

## Gate (tier: engine edited - broad)
- Parse gate. New test: 8 seeded muay_thai bouts (two DIFFERENT men per bout - a clinch fighter vs a
  kicker, both able to do everything Muay Thai permits; name them in the output): total time in any
  ground seat <= 1.0 s per occurrence, zero ground techniques named; the same for boxing. And the
  byte-identical check for mma + bjj seeds.
- `tests/grapple_naming_contract_test.gd` (report muay_thai clause 1 before/after), `tools/q148_phase_violations.gd` = 0.
- `run_tests.py --only grapple`, `--only fight_`, `--only room`, `--only world`. Name every test whose
  numbers change. No full suite (Claude runs it at integration).
- Branch `qwen/q153-ground-policy`, digest, one agent_comms.py send. Do NOT edit HANDOFF.md.
