# U160 digest — strike speed caps and hands while stepping

Population: MMA R133 wrestle-grappler (A, **175 cm**) vs striker (B, **185 cm**), seed **92012**, ruleset mma, default live room (engine positions + body layers on), 30 Hz fixed step, 60 s probe.

## Part 1 — measurement (before fix, `caps=false`)

Probe: `Godot/tools/u160_speed_probe.gd` (1800 frames). Native peak from `assets/data/clip_phases.json` `peak_speed_mps`; screen peak = 30 Hz world-space effector speed during the play window. Ratios above 1.0 on punches often reflect room warp/IK vs isolated clip samples, not tempo alone; **seeked combos** drove the worst kick rows.

| Class | n | median ratio | p90 | max |
| --- | ---: | ---: | ---: | ---: |
| punch | 7 | 1.85 | 1.85 | 1.85 |
| knee | 7 | 1.48 | 1.91 | 2.13 |
| kick | 9 | 1.69 | 3.81 | **5.47** |
| all | 23 | 1.69 | 3.33 | 5.47 |

Worst play: `kickboxing_jab_lowkick` (seek 0.540 s, screen/native **5.47**). Hand strikes had **no** tempo/seek cap (U158 kicks only). Elbows: none in this 60 s slice; playback path still extended for `elbow` / `HAND_STRIKE_ROLES` when caps are on.

Hands (no hand strike playing): **92** single-frame wrist jumps **> 8 m/s** while `stepping()`; worst **52.8 m/s** (B, `loc_strafe_right`). Writer stack: walk splice + clip sample, then C186 `finish_hand_frame` fighting the walk pose. Glove–glove penetration events (depth > 0.12 m): **4**, max **0.053 m** (frame 23).

## Part 2 — playback fixes (default OFF)

`FightWorldLiveScreen.gd`: `strike_speed_caps`, `skip_hand_continuity_while_stepping` (both default **false**).

`FightStagePlayer.gd`:

- `_kick_playback`: when `strike_speed_caps` ON, same **1.05×** tempo cap and **≥0.20 s** wind-up before contact as U158 kicks, for `HAND_STRIKE_ROLES` and elbow-named takes. Kicks unchanged (always capped).
- `finish_hand_frame`: when `skip_hand_continuity_while_stepping` ON and stepping with no `strike_contact()`, skip C186 bend (track wrists only) so walk animation owns the hands.

Contract: `tests/fight_strike_speed_test.gd` (OFF hash stable; ON hand-strike tempo ≤ 1.05; seek clamp mutant on `muay_thai_spinning_elbow`).

## Part 3 — after (`caps=true`, same seed)

| Class | n | median ratio | p90 | max |
| --- | ---: | ---: | ---: | ---: |
| punch | 7 | 1.85 | 1.85 | 1.85 |
| knee | 7 | 1.48 | 1.91 | 2.13 |
| kick | 9 | 1.69 | 3.81 | 5.47 |
| hands >8 m/s while stepping | — | — | — | **95** jumps |

Playback rows with scheduled seek (e.g. `hook_lead` seek 0.167 → applied **0.133** with caps ON). Screen/native table unchanged on this slice because most plays had seek 0; caps prevent **future** elbow/hand seek+tempo defects without slowing clips below their source (tempo floor is min(fighter, 1.05), not an arbitrary m/s clamp).

A/B: `research/_captures/watch_loop/u160_speed_hands_ab.mp4` (**18.7 MB**, 10 s, OFF | ON, 1920×544, tight shot). Contact frame: `research/_captures/watch_loop/u160_ab_contact.png`.

## Gate

- `check_scripts.py` on touched `.gd`
- `fight_strike_speed_test` PASS (18 checks)
- `run_tests.py --only fight_stage` → total=10 **fails=1** (`fight_stage_realism_test` — documented ceiling)
- `run_tests.py --only fight_world` → total=4 fails=0
- `run_tests.py --only fight_reaction` → total=2 fails=0

## Round 2

Merged `origin/master` (C190 `strikes_play_whole`, U159 `reactions_play_whole`). Population unchanged: MMA R133 **175 cm** grappler vs **185 cm** striker, seed **92012**, 60 s / 1800 frames @ 30 Hz.

### Take-four measurement (operator config)

| Config | punch med | kick med | kick max | all max | hand jumps >8 m/s |
| --- | ---: | ---: | ---: | ---: | ---: |
| whole OFF (`take4=false`) | 1.85 | 1.69 | **6.30** (`kickboxing_jab_lowkick`) | 6.30 | **92** |
| whole ON (`take4=true`) | 0.74 | 0.71 | **2.54** (`kickboxing_jab_lowkick`) | 3.20 | 167 |

Seek/tempo caps do not move the OFF table: most rows keep seek **0**; `jab_lowkick` is the exception (seek **0.54→0.44** after leg effector fix) but screen/native stays **6.30** because excess is **clip pose at mid-seek + room composition**, not missing wind-up cap.

### Attribution (worst plays, take4 OFF)

- `#1 kickboxing_jab_lowkick` ratio **6.30**: screen **32.2** m/s vs native **5.11** — **local clip pose 13.9**, hips **4.2**, IK remainder **14.1**; owner **local_clip** (mid-combo seek, not tempo).
- `#2–3 muay_thai_switch_kick_body` ratio **3.8 / 3.3**: **IK remainder ~40 m/s** of **51–59** screen (seek 0).
- Punches flat **1.85×** everywhere: **hips_warp / IK**, not playback tempo.

### Fix shipped

`FightStagePlayer._effector_is_leg(take)` in `_kick_playback` (from `clip_phases.json`); removed role-level effector lookup that mis-read generic `strike_head` as **RightFoot**. `kickboxing_jab_lowkick` no longer escapes U158 cap via `"jab"` in the role id.

### Hands while stepping (no strike)

Worst five jumps unchanged at **92** events; skipping C186 bend still rejected. Per-writer deltas on worst frame **1068** (`loc_strafe_right`, **52.8 m/s** inter-frame): `animation_sample` **3.9**, `inertia` **3.4**, `arm_ik_L` **2.9** m/s **within the frame** — the teleports are **room root step + walk clip boundary**, not `hand_continuity`.

### Elbows (muay_thai demo pair, take4 ON)

Seed **92020** (not 92012): **2×** `karate_empiuchi`, median ratio **3.78**, max **4.64** (screen **17.1** vs native **3.69**, owner **local_clip**); seek **0**, whole ON.

### Gate (round 2)

- `check_scripts.py` on touched `.gd`
- `fight_strike_speed_test` PASS (**20** checks)
- `run_tests.py --only fight_stage` → total=10 **fails=1** (`fight_stage_realism_test` ceiling)
- `run_tests.py --only fight_world` → total=4 fails=0
- `run_tests.py --only fight_reaction` → total=2 fails=0

## Round 3

Merged `origin/master` (C190/U159). Take-four ON throughout.

### Elbows (muay_thai seed **92020**, A 181 cm vs B 178 cm)

| | plays | median ratio | max ratio | tempo (empiuchi) | screen / native |
| --- | ---: | ---: | ---: | ---: | --- |
| before (r2) | 2× `karate_empiuchi` | 3.78 | **4.64** | 1.0 | 17.1 / 3.69 |
| after | 2× `karate_empiuchi` | **1.07** | **1.07** | **0.332** | 3.9–4.0 / 3.69 |

Owner was **local_clip**: retargeted take peaks faster than `clip_phases.json` native. Fix: bake per-take effector peak at bind (`_derive_take_effector_peaks`), then `_whole_strike_tempo_cap` scales whole-strike playback to `native/baked` (not below source).

### Hands while stepping (MMA seed **92012**, take-four ON, probe counts only consecutive stepping frames)

| | jumps > 8 m/s |
| --- | ---: |
| before (r2, old counter) | 167 |
| after | **119** |

Walk `loc_*`→`loc_*`: carry gait phase (`seek` without update) + `LOWER_BLEND_S` crossfade; seed/clear C186 state on walk change and first stepping frame. Worst remaining jumps ~13–20 m/s (arm IK on seed frame), not 52.8 m/s room/idle false edges.

### `strike_head` in `clip_phases.json`

Generic role entry lists **RightFoot** (combo graft metadata). Timing for fidelity should use the **striking hand** (`LeftHand` / `RightHand` from `_aim_contact_s` / farthest reach at contact), not a foot — Claude to fix JSON.

### Gate (round 3)

- `check_scripts.py` on touched `.gd`
- `fight_strike_speed_test` PASS (**21** checks)
- `run_tests.py --only fight_stage` → total=10 **fails=1** (`fight_stage_realism_test` ceiling)
- `run_tests.py --only fight_world` → total=4 fails=0
- `run_tests.py --only fight_reaction` → total=2 fails=0

## Round 4

Merged `origin/master` (C190/U159). **Reverted** `_whole_strike_tempo_cap` and `_derive_take_effector_peaks` (r3 played `karate_empiuchi` at tempo **0.332** — a third of real speed). Kept effector-based leg kick cap, walk join smoothing (`LOWER_BLEND_S` / gait carry).

### Measurement fix (like-for-like)

Rounds 1–3 divided **live world** effector speed by `clip_phases.json` **chest-relative** `peak_speed_mps` (U162: retarget median **0.883×** vendor world; no clip **>1.5×**). Probe now compares live world to **vendor FBX world** (60 Hz, `FightClipBinding.path`, UE4 effector chain). Pass Godot user args after `--` (e.g. `take4=true`).

| Config | elbow world med/max | all world med/p90/max | chest_trap max (invalid) | hands >8 m/s stepping |
| --- | --- | --- | ---: | ---: |
| muay_thai **92020** take4 ON | **0.89 / 1.18** (`empiuchi` 0.60–1.18×) | 1.12 / 4.59 / 6.18 | **5.75** | **39** |
| muay_thai **92020** take4 OFF | 1.15 / 1.15 | 1.03 / 5.62 / 6.10 | 5.60 | **6** |
| mma **92012** take4 ON | (none in slice) | 0.94 / 3.31 / 9.75 | 6.30 | **125** |
| mma **92012** take4 OFF | — | 2.16 / 10.58 / 23.74 | 6.30 | **32** |

**Elbows:** not faster than vendor source at tempo 1.0 (max **1.18×** world); the operator’s “too fast” read is **readability** (~0.2 s contact), not playback overspeed — propose anticipation/contact-hold/camera, not tempo caps.

**Kicks still hot in room** (IK/placement; e.g. `switch_kick_body` world max **9.75×** take4 ON vs vendor foot sample) — separate from the chest-trap elbow false alarm.

**Hands** (one rule: inter-frame wrist **>8 m/s** while `stepping()`, no strike): r3 with whole-strike cap **119** (mma take4 ON) → r4 after revert **125**; walk smoothing still caps worst jumps ~**12 m/s** (not 52.8 m/s).

### Gate (round 4)

- `check_scripts.py` on touched `.gd`
- `fight_strike_speed_test` PASS (**20** checks)
- `run_tests.py --only fight_stage` → total=10 **fails=1** (`fight_stage_realism_test` ceiling)
- `run_tests.py --only fight_world` → total=4 fails=0
- `run_tests.py --only fight_reaction` → total=2 fails=0
