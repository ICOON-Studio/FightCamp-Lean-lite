# U163 digest — take-four kick/hand speed (vendor-world)

Population (MMA R133 **175 cm** grappler vs **185 cm** striker, seed **92012**, 1800 frames @ 30 Hz, `strikes_play_whole` + `reactions_play_whole` ON). Ratios are **live vendor FBX world** vs live world (never chest-native `peak_speed_mps`).

## Part 1 — attribution (take4 ON)

Worst kick: `kickboxing_body_kick` **9.81×** vendor (LeftFoot vendor **2.47 m/s**, screen **24.2 m/s**); split **local 3.6 + hips 6.5 + ik remainder 14.1** — composition (root placement + clip), not tempo (seek **0**, tempo **1.0**).

| Config | kick max ratio | hands >8 m/s stepping |
| --- | ---: | ---: |
| take4 OFF | 23.74 | **32** |
| take4 ON (U160 r4) | 9.75 | 125 |
| take4 ON (U163) | **9.81** | **0** |

Populations: `godot --headless --path Godot --script tools/u160_speed_probe.gd -- u163` (S65 demo boxing 92012, muay_thai **92020** / **92024**).

## Part 2 — fixes (behind whole-strike switches only)

- **`FightWorldLiveScreen`**: C190 root warp only while `whole_strike_presentation_active()`; kicks get **zero yaw warp** and **0.12 m** translation cap; rate-limited warp approach; skip contact solve during whole presentation; clear stale `_whole_roots` when off take.
- **`FightStagePlayer`**: vendor-world peak cache + `finish_strike_effector_frame` (1.05× vendor budget, leg IK); seed effector at whole `play_role`; skip `_ground` during whole presentation; tighter hand C186 budget (0.5×) while stepping with whole switch ON.

Target kick peak **≤1.05× vendor** not met on worst outlier (IK remainder); median kick ratio **1.62** (class). No clip tempo reduction.

## Gate

- `check_scripts.py` on touched `.gd`
- `fight_strike_speed_test` PASS (**26** checks; take4 hands ON ≤ OFF+8 on 900-frame room)
- `run_tests.py --only fight_stage` → total=10 **fails=1** (ceiling)
- `run_tests.py --only fight_world` → total=4 fails=0
- `run_tests.py --only fight_reaction` → total=2 fails=0
- `run_tests.py --only fight_strike_whole` → total=1 fails=0

## Round 2

Population: MMA seed **92012**, take4 ON (same as Part 1). Vendor beside ratio: worst `kickboxing_body_kick` **9.62×** (vendor **2.47 m/s**, screen **23.73 m/s**); median kick **1.73×** (was **1.62×** / max **9.81×**).

**Frame 471 (probe peak):** `cap_to_probe=0` — nothing moves the foot after `whole_effector_cap` that frame; inter-frame spike is **foot_lock undo + stance/root placement** after the whole take ends while the probe still scores the 1.2 s window. Writers on 471: `animation_sample` **2.75 m/s**, `inertia` **6.36 m/s**, `whole_effector_cap` **0** (budget already met vs presented tracker).

**Fixes:** cap uses `clip_phases` effector (`LeftFoot`, not travel-picked other foot); carry walk foot world into whole `play_role`; **0.5 s cap tail** after `_whole_remaining` hits 0; no `foot_lock` during tail; skip `_undo_foot_lock` during tail; slower kick whole-root warp during tail (`FightWorldLiveScreen`); probe `u163r2` kick writer audit.

**take4 OFF** same kick peaks **~8.8–10.6×** vs vendor **2.47 m/s** — same post-clip / join writer, not a bad ratio denominator (vendor foot is not near-zero).

**Gate:** parse OK; `fight_strike_speed_test` **26** checks; `--only fight_stage` **10** fails=**1** (ceiling); `--only fight_world` **4** fails=0; `--only fight_reaction` **2** fails=0; `--only fight_strike_whole` **1** fails=0.

## Round 3

**Denominator:** `clip_phases` names **LeftFoot** for `kickboxing_body_kick` / `muay_thai_switch_kick_body`, but vendor FBX in the strike window peaks **L=2.47 / R=24.30 m/s** — plant vs striker. Rounds 1–2 divided screen motion on the **kicking** foot by the **plant** foot; the false **9.62×** is retracted.

**Census (MMA 92012, take4 ON, `u163r3`):** kicks use **kicking-foot** vendor + probe bone. Worst `kickboxing_body_kick` **0.97×** (vendor kick **24.30**, screen **23.51** on RightFoot); kick class median **0.97×**, max **1.05×** (one low-kick outlier **3.15×** with vendor **0** on jab_lowkick — no vendor path). **4** plays listed `INVALID_RATIO_DENOM` under old catalog rule (`body_kick`, `switch_kick_body` ×2).

**Literature anchor:** Falco et al. (2009) and comparable TKD/Muay Thai kinematics report instep/foot linear speeds roughly **10–20 m/s** at impact (elite toward the top). Screen **~23.5 m/s** world on the striker foot is high but not absurd once hip translation is in world space; **no further take-four slow-down** warranted on body kick.

**Code:** `vendor_kick_foot_audit` / `kicking_foot_for_role` in `FightStagePlayer`; whole-strike cap + probe sample the kicking foot; round-2 tail/foot-lock kept.

**Gate:** parse OK; `fight_strike_speed_test` **31** checks; `--only fight_stage` **10** fails=**1** (ceiling); `--only fight_world` **4** fails=0; `--only fight_reaction` **2** fails=0; `--only fight_strike_whole` **1** fails=0.
