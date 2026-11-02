# U165 digest — strikes that READ (G75 onset→impact floors)

Population: **124** bound strike clips; onset = striking **clip_phases effector** leaving guard at **≥0.45 m/s** for **2** consecutive samples @30 Hz (hips-frame speed on grafted takes). Contact for census = **clip_phases.json `contact_s`**, played @30 fps with vendor tempo 1.0; human_speed OFF/ON.

## Part 1 — census (`Godot/tools/u165_onset_census.gd`)

G75 floors live in `assets/data/strike_speed_anchors.json` → `onset_floors` (citations verbatim from G75 §4).

| Metric | human_speed OFF | human_speed ON |
| --- | ---: | ---: |
| Clips under class floor | **17** | **10** |
| Worst shortfall | **kickboxing_jab_lowkick** **9** frames (1.0f vs 10 floor) | **kickboxing_spinning_hook** 8 frames (human ON still short) |
| Elbow example (seed 92012 bout) | **muay_thai_spinning_elbow** — inspect live at ~round 1; census flags **spinning_back_kick** / **punch_other** elbows-in-combo clips similarly |

Engine `_contact_s` can differ from catalog contact; warp applies only when census flags **and** engine timeline can stretch load→contact without shifting scored contact.

## Part 2 — fix (`readable_onset`, default OFF)

- `FightWorldLiveScreen.gd` / `record_room.gd`: option `readable_onset`.
- `FightStagePlayer.gd`: piecewise wall-clock map compresses guard / stretches load→contact so delivery ≥ G75 floor; **`_contact_s` unchanged**; composes with `human_speed_tempo`.
- Example warp log: **strike_body** before **6.3f** → after **10.0f** @ floor 10, contact_s **0.433** unchanged.

A/B command (windowed, hidden): `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --write-movie research/_captures/watch_loop/u165_readable_onset_ab.avi --fixed-fps 30 --resolution 1280x540 --quit-after 300 -- --script tools/record_room.gd -- seed=92012 discipline=mma strikes_play_whole=1 reactions_play_whole=1 shot=tight` (run OFF then `readable_onset=1` for ON; ffmpeg to `u165_readable_onset_ab.mp4`). Cloud render did not produce a sheet; operator eye gate applies.

## Gate

- `check_scripts.py` on touched `.gd` → **5/0**
- `fight_readable_onset_test.gd` → **TOTAL=84 fails=0** (contact wall + onset floor + 4 mutants)
- `run_tests.py --only fight_stage` → **total=10 fails=1** (documented realism ceiling)
- `run_tests.py --only fight_strike` → **total=3 fails=0**
- `run_tests.py --only fight_world` → **total=4 fails=0**
- `run_tests.py --only fight_human_speed` → **total=1 fails=0**
