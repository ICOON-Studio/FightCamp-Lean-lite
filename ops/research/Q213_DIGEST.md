clip gate (S120 on master, Claude re-run after a lookup fix): clips 1/11 pass - boxing_jab_body PASS (2.53 cm) at its real certified spacing 1.6725 m (run8_bound; the send-back picked the REJECTED run10_jab_trial row, 1.185 m, which manufactured its 21.24 cm); rear_hook_body (S120) FAIL 16.28 cm. Every other row as below.

clip gate: live FAIL 21 events (head 2, arm 16, leg 3), clips 0/10 pass — certificate spacing, sequences included

## SEND-BACK 2 fixes
1. **Spacing from certificate, never a constant.** `_build_cert_lookup()` globs all `run*_*.json` in `docs/previews/c223/`, parses run number and file priority (bound>final>four>other), keeps newest run per (move, rig) with `mechanical_failures==[]`. Sequences read from `run*_chain.json` with `certified==true`. Each Q213_CLIPS line prints spacing and cert file. Missing cert = `push_error`, never a default.
2. **Sequences included.** Removed `not entry.has("sequence")` filter. `boxing_one_two` and `boxing_double_jab` now played via `play_role(sequence_name)` which uses `FightStagePlayer.sequence_plan` / `_advance_sequence` — the production bound path. Total 10 certified moves measured.
3. **Per-move table has spacing column.** Each Q213_CLIP_MOVE line shows the certificate spacing for the first rig.

## Live 180s seed 94301
| class | frames_over | events | failing | worst_cm | worst_pair | at |
|-------|------------|--------|---------|----------|------------|-----|
| HEAD | 9 | 6 | 2 | 7.49 | LeftUpperArm-LeftLowerArm>Head | boxing_slip_counter/boxing_jab_body |
| TORSO | 5 | 4 | 0 | 35.49 | UpperChest-Neck>UpperChest-Neck | boxing_slip_counter/slip |
| ARM | 195 | 86 | 16 | 20.26 | LeftShoulder-LeftUpperArm>Spine-Chest | boxing_slip_counter/slip |
| LEG | 33 | 18 | 3 | 19.45 | LeftUpperLeg-LeftLowerLeg>RightUpperLeg-RightLowerLeg | boxing_slip_counter/slip |
| FOOT | 8 | 5 | 0 | 6.89 | LeftFoot-LeftToes>LeftFoot-LeftToes | react_body#2/boxing_jab_body |

Q213_GATE FAIL population=live_boxing seed=94301 frames=5400

## Clips 10 boxing exact x 4 rig pairings
| class | frames_over | events | failing | worst_cm | worst_pair | at |
|-------|------------|--------|---------|----------|------------|-----|
| HEAD | 1071 | 57 | 51 | 14.70 | Head>LeftShoulder-LeftUpperArm | boxing_jab_body/idle |
| TORSO | 46 | 2 | 2 | 18.34 | UpperChest-Neck>UpperChest-Neck | boxing_jab_body/idle |
| ARM | 1690 | 83 | 52 | 21.24 | LeftHand>UpperChest-Neck | boxing_jab_body/idle |
| LEG | 767 | 34 | 34 | 17.54 | LeftUpperLeg-LeftLowerLeg>LeftUpperLeg-LeftLowerLeg | boxing_lead_uppercut/idle |
| FOOT | 0 | 0 | 0 | 0.00 | | |

| move | failing | worst_cm | spacing | cert | verdict |
|------|---------|----------|---------|------|---------|
| boxing_body_hook | 4 | 10.14 | 1.5225 | run9_bound | FAIL |
| boxing_cross | 4 | 9.64 | 1.2950 | run8_bound | FAIL |
| boxing_double_jab | 11 | 9.48 | 1.0600 | run10_chain | FAIL |
| boxing_jab | 6 | 8.80 | 1.0600 | run10_jab_bound | FAIL |
| boxing_jab_body | 11 | 21.24 | 1.1850 | run10_jab_trial | FAIL |
| boxing_lead_hook | 11 | 12.17 | 1.2250 | run9_bound | FAIL |
| boxing_lead_uppercut | 27 | 20.84 | 0.7072 | run9_bound | FAIL |
| boxing_one_two | 16 | 20.16 | 1.0600 | run10_chain | FAIL |
| boxing_rear_hook | 32 | 17.46 | 0.7285 | run9_rear_final | FAIL |
| boxing_rear_uppercut | 8 | 10.69 | 1.3150 | run9_bound | FAIL |

Q213_GATE FAIL population=clips_boxing_exact moves=10 pass=0 fail=10

## Certificate spacing per (move, rig)
| move | welter_a | welter_b | heavy_c | heavy_d |
|------|----------|----------|---------|---------|
| boxing_jab | 1.060 (run10_jab_bound) | 1.015 (run10_jab_bound) | 1.125 (run10_jab_bound) | 1.110 (run10_jab_bound) |
| boxing_cross | 1.295 (run8_bound) | 1.245 (run8_bound) | 1.375 (run8_bound) | 1.350 (run8_bound) |
| boxing_lead_hook | 1.225 (run9_bound) | 1.185 (run9_bound) | 1.290 (run9_bound) | 1.270 (run9_bound) |
| boxing_rear_hook | 0.728 (run9_four) | 0.722 (run9_four) | 0.778 (run9_four) | 0.782 (run9_four) |
| boxing_lead_uppercut | 0.707 (run9_bound) | 0.704 (run9_bound) | 0.763 (run9_bound) | 0.764 (run9_bound) |
| boxing_rear_uppercut | 1.315 (run9_bound) | 1.265 (run9_bound) | 1.390 (run9_bound) | 1.365 (run9_bound) |
| boxing_jab_body | 1.185 (run10_jab_trial) | 1.095 (run10_jab_trial) | 1.753 (run8_bound) | 1.723 (run8_bound) |
| boxing_body_hook | 1.523 (run9_bound) | 1.453 (run9_bound) | 1.583 (run9_bound) | 1.548 (run9_bound) |
| boxing_one_two | 1.060 (run10_chain) | 1.015 (run10_chain) | 1.125 (run10_chain) | 1.110 (run10_chain) |
| boxing_double_jab | 1.060 (run10_chain) | 1.015 (run10_chain) | 1.125 (run10_chain) | 1.110 (run10_chain) |

## Contract test
32/32 checks pass. No changes to the contract test this send-back.

## Owned files
- `Godot/tools/q213_clip_gate.gd`
- `Godot/tests/q213_clip_gate_contract_test.gd`
- `research/Q213_DIGEST.md`

No engine constants, separation, contact_stop or clip changed.
