# U164 digest — are bought strike clips faster than humans?

Population: MMA seed **92012**, `strikes_play_whole` + `reactions_play_whole` ON for live checks; vendor peaks on **`clip_phases.json` effector** (striking limb, never support foot).

## Part 1 — literature (`assets/data/strike_speed_anchors.json`)

Rows cite method, measure point (wrist/fist, foot/toe, etc.), elite/amateur where retrieved, and **NOT FOUND** where no primary peak was opened. Roundhouse/body kick band **10–17 m/s** on the **kicking foot** (Gavagan & Sayers ~14.7 m/s; Falco et al. 2009; Robalino et al. 2025 band). Cross/uppercut use Xu et al. (2024) mean±SD envelopes, not observed maxima (C187). Jab/hook/elbow peaks **NOT FOUND** in retrieved text.

## Part 2 — census (124 bound strikes)

Tool: `Godot/tools/u164_source_speed_census.gd` (`write=1` refreshes `clips` in JSON).

| Metric | Value |
| --- | ---: |
| Clips measured | **124** |
| Above literature max (flagged) | **46** |
| Worst vendor peak | **boxing_overhand** RightHand **36.86 m/s** vs punch_other max **12.05 m/s** (wrist) |
| Worst foot | **muay_thai_spinning_back_kick** RightFoot **34.54 m/s** vs spinning cap **18 m/s** |
| Example body-kick family | **tkd_cut_kick** RightFoot **28.47 m/s** → tempo **0.597** → **17.0 m/s** projected |

`kickboxing_body_kick` (LeftFoot per Q167) vendor world peak **≤ 17 m/s** on this census — **not flagged**; U163’s **24.3 m/s** was a different attribution window/foot lesson, not contradicted here on the catalog effector.

## Part 3 — fix (`human_speed_tempo`, default OFF)

- `FightWorldLiveScreen.gd`: option `human_speed_tempo`.
- `FightStagePlayer.gd`: per-flagged-clip `playback_tempo = literature_max / vendor_peak` (floor **0.25**), applied in `_kick_playback` and whole-strike `play_role`.
- Before/after: vendor peak × tempo → literature max (or floor-limited best effort).

A/B: `research/_captures/watch_loop/u164_human_speed_ab.mp4` (**3.6 MB**, 10 s, 1280×540 OFF | ON, seed 92012, tight shot, take-four ON).

## Gate

- `check_scripts.py` on touched `.gd`
- `fight_human_speed_test.gd` → **TOTAL=104 fails=0**
- `run_tests.py --only fight_stage` → **total=10 fails=1** (documented `fight_stage_realism_test` ceiling)
- `run_tests.py --only fight_strike` → **total=3 fails=1** (`fight_strike_speed_test` logs `!is_inside_tree` chatter under runner; direct run **26/0**)
- `run_tests.py --only fight_world` → **total=4 fails=0**
