# S94 DIGEST - gym props on Tripo Pro, named music playlists (Claude, 2026-09-27)
Commits: 06c95ab0, 2d5fd2c5, 010c6e4e, 5f1be8c2 (+ ship). Suite: nightly 2026-09-26 at 9847dd13 total=416 fails=13
(AgentComms/nightly/latest.txt); this session ran subsets only: training_floor 1/1, gym_ 14/14, boot_panels 1/1,
boot_root 1/1, gym_prop_models PASS, music_playlists PASS. asset_manifest_test red BEFORE this session (Mixamo
candidate pack refs, nightly-listed) - not touched.

## Built
- **Tripo Pro props replace greyboxes by catalogue id** (`TrainingFloor3D._place_model`, raw GLB via GLTFDocument,
  `assets/models/props/gym/<catalog_id>.glb`, `.gdignore` so Godot never unpacks textures). 11 models, 30 MB, ~45 credits
  each (3200 -> ~2660): heavy_bag, speed_bag (regenerated flat - v1 tilted upright), double_end_bag, focus_mitts_locker
  (+striking_safety_locker alias), grappling_dummy, compact_weights, plyometric_step_rig, exercise_bike (+air_bike,
  cardio_floor aliases), rowing_ergometer, physio_table. Pilot PASSED -> Unity 80286 pack NOT bought.
- Fit rules by shape: uniform fit inside the device; hanging bag by width, bottom at 0.8 m, chain to 3.6 m; wall board
  by width, top 1.93 m on a post; ball by width at 1.5 m on cords; locker/dummy by height; rower by length; cabinet at 1 m.
  A slanted model is squared to its main axis (vertex covariance, only when > 2:1) and quarter-turned to its slot.
  Bounds are measured from VERTICES (a turned mesh box only grows - it hid the rower fix).
- Licence: tripo3d.ai/terms 5.2.2 paid users hold all rights incl. revenue (asset_manifest tripo_pro_gym_props).
- **Coach-in-the-locker bug** (pre-existing, hidden by the greybox): the idle coach stood at the mitt locker's zone
  centre = the locker. `TrainingFloorLayout.beside_device` puts him in the widest free strip; old code fails the check.
- **Named playlists** (operator): Settings > AUDIO > PLAYLIST - ALL, LAID-BACK, ROCK, METAL, PHONK, FUNK, EPIC; menu
  theme first, then the list shuffled with no repeat before a full pass; choice saved. 29 human-made Pixabay tracks
  (Content Licence), Ogg q0 ~64 kbps, 28 MB (operator: "dont make it too heavy on MBs"); SolarFLEX removed by the operator.

## Collected
G129 (dressing: CC0 system hair caps + bodyparts05 beards, rigid boxing glove, trunks via MakeClothes carrying the 31
keys; never hair02/hair03/pants03), J56 (keep 5/128, MOVE the neck grip points - written into TASK_C211), D40 (5/8
cards read mannequin: one skull template; widen face shapes + skin detail + eye catchlights). U187 NOT merged (p95 0.638
vs baseline 0.573, target 0.287; kneel 924) -> U188 held for Cursor. Ludo pilot REJECTED by the operator (drums only).

## Failed / named
- ACE-Step: `import torch` segfaults on the RX 6800 XT (rocm-rel-7.2 wheels are RDNA3/4; AMD publishes gfx103X ROCm
  runtime but no gfx103X torch). Not retried. Options: torch-directml (30 min try) or CPU overnight.
- Higgsfield has no standalone music model (speech only).

## Traps earned
- `ffmpeg` inside `while read` eats the heredoc: 12 files lost their first letters. Use `-nostdin`.
- A generator picks its own axis and angle: measure the model, never assume its facing.
- A fit test that only asks "inside and touching one side" passes a 0.6 m rower in a 2.4 m slot: require the long side.
