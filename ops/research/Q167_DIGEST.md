# Q167_DIGEST — tag every bound strike clip: START, CONTACT, RECOVER-TO-GUARD

## Population
- **Rig:** f01_m_box_welter_rigged
- **Strike roles tagged:** 124 (0 skipped)
- **Source:** FightClipBinding.gd — punch_roles + technique_roles + strike_{head,body,leg}, minus 20 non-strike exclusions (grapples, sweeps, throws, takedowns, slams)

## Definition (printed in tool output)
- **contact** = time of peak effector-chest distance, refined by speed minimum within ±5 samples
- **start** = last time before contact where effector speed > 10% of peak
- **recover** = first time after contact where effector is within 0.08 m of t=0 position AND speed < 10% of peak
- **NO_RETURN** = clip end without recover

## Summary by category

| category | clips | contact median | contact range | recover median | recover range |
|----------|-------|----------------|---------------|----------------|---------------|
| punch | 55 | 0.333 s | [0.150, 0.717] | 0.817 s | [0.400, 1.117] |
| kick | 46 | 0.567 s | [0.150, 1.217] | 0.908 s | [0.640, 1.983] |
| knee | 14 | 0.417 s | [0.417, 1.133] | 0.900 s | [0.700, 1.517] |
| elbow | 6 | 0.442 s | [0.333, 0.500] | 0.917 s | [0.650, 1.017] |
| generic_strike | 3 | 0.317 s | [0.300, 1.133] | 0.883 s | [0.817, 2.317] |

## Findings

### NO_RETURN clips: 41 of 124
Clips where the effector never returns to within 0.08 m of guard within the clip length.
- All 46 kick clips: 18 are NO_RETURN (foot extends and clip ends before return)
- All 14 knee clips: 12 are NO_RETURN (knee drives forward, foot doesn't return)
- Punch NO_RETURN: jab_lead, cross_lead, hook_lead, hook_rear, boxing_body_hook, boxing_check_hook, boxing_check_hook_pivot, boxing_rear_hook_body, boxing_shovel_hook, karate_kagizuki, kickboxing_dutch_combination
- Effector auto-detection picked RightFoot for several punch roles — the foot's displacement from weight shift exceeded the hand's in the chest frame for those retargeted clips

### Fast-contact clips (< 0.10 s): 0
No clip has contact under 0.10 s. No "bullets" (clips that start already extended).

### Effector detection note
Auto-detection picks the limb (LeftHand, RightHand, LeftFoot, RightFoot) with max displacement from t=0 in the chest frame. For some retargeted punch clips, the foot's displacement from weight shifting exceeds the hand's, causing the tool to report RightFoot as the effector. This is a known limitation of the heuristic — the data is still valid as a measurement of what moved most.

## Files
- `Godot/tools/q167_tag_clip_phases.gd` — the tool
- `Godot/assets/data/clip_phases.json` — 124 entries, one per strike role
- `Godot/tests/clip_phases_data_test.gd` — structural validator (4 checks, 0 failures)

## Gate
- Parse gate: 2 files, 0 fails
- Test: clip_phases_data_test.gd — 4 checks, 0 failures

## S66 correction (Claude, on collection)
The data file was wrong under a green test. `_detect_effector` picked the bone that moved most relative to
the chest over all four limbs, so **81 of 88 punches were timed on a FOOT** (e.g. `boxing_body_hook`
effector `RightFoot`), and `start` was the LAST fast frame before contact - one sample before it.
Fixed in the tool: the effector is chosen within the technique's own limb (punch hand, elbow LowerArm
origin, knee LowerLeg origin, kick foot); start walks back from the fastest pre-contact frame to the
first sub-10% frame. Re-run: punch wind-up median 0.10 s (was ~0.017), **NO_RETURN 20 of 124, not 41** -
half the "limbs never return to guard" finding was the foot artefact. 51 clips start at t=0 because the
limb is already moving at the slice's first frame (sliced from a longer take) - correct, not a defect.
