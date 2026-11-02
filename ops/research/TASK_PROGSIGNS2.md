# TASK PROGSIGNS2 - the floor ring under him (D2) and his between-sets posture (D3) from ProgressionSigns (S241)

Seat: Grok Dev (coding seat, pushes a branch) - AFTER NIGHTLY7. Branch `grok/progsigns2`, PR to master; Claude merges by diff.
Model: Grok Dev default. Discipline: BOXING (the demo).

## Why (operator, board Q-S237-1, verbatim)
"the loop , animations,workout,feeling of progrsession and improvement from training these are what matters for now". Lead designer
Ludo r105 part D (research/ludo_rx/LUDO_R105_raw.txt): D2 a ring on the floor under him at a station - wide, wobbly amber for a
novice at that station's stat, tight steady teal for a master; D3 between sets he stands spent (hands on hips, head down, torso pitched)
or sharp (upright, light bounce) by conditioning and fatigue. D4 (milestone floaters) is already live.

## What is on master (read, do not rebuild)
- `Godot/scripts/rules/ProgressionSigns.gd` (pure, PROGSIGNS1): `station_ring(stat) -> {radius_m, colour, alpha, jitter_m, band}`,
  `idle_posture(conditioning, fatigue) -> {torso_pitch_deg, hands_on_hips, head_down, bounce, band}`. Tests: tests/progression_signs*_test.gd.
- `GymHall3D.gd` (4,506 lines - grep + `sed -n` windows, NEVER read whole): preloads it as `ProgressionSignsRules` (used at ~3126,
  `_milestone_floaters`); switch `progression_signs` is ON in GameSwitches.GAME_ON (read with `GameSwitches.on("progression_signs")`).
  His place/station: `day_state()` (~3170) -> `"place"`, `"station"`, `"phase"` ("train" / "stand" / a pending why); stamina:
  `day_state()["stamina"]`; fatigue the game uses = `clampf(100 - stamina, 0, 100)` (~2639). His stats: `_wire_athlete()` (or
  `_fighter_row` when empty) `["stats"]`. The station's trained stats: `DayLapSim.stations(true)["stations"][<station>]["trains"]`
  (dict stat -> rate; the station's stat = the highest rate - exactly as `hover_text` does at ~3928). His node: `_fighter_node()` (~3534).

## Do
1. D2: while he is AT a station (`phase == "train"`), a flat ring (MeshInstance3D, TorusMesh inner = radius-0.04, outer = radius, height
   0.01; unshaded StandardMaterial3D, the colour + alpha from station_ring, transparency on, no depth write) lies 0.02 m over the floor
   under his feet, named "ProgressRing"; jitter_m wobbles its centre (sin/cos, ~2 Hz) - 0 for a master = still. Gone when he walks/stands.
   Recompute when the station or the stat changes (never every frame).
2. D3: while `phase == "stand"` (between sets, no station), apply idle_posture to his visual: torso pitch on the spine bone if the rig
   has one (find how GymHall3D/TrainingFloor3D already pose the fighter - grep "spine" / "set_bone_pose"), else pitch the body node by
   torso_pitch_deg / 3; bounce = a 2 cm 1.5 Hz bob. Restore exactly on leaving "stand". Read the band; never invent other numbers.
3. Both only when `GameSwitches.on("progression_signs")`; plain `--script` tests stay the OFF arm (no ring, no posture change).

## Tests (red on master first - paste the red line in the PR body)
New `Godot/tests/progsigns_floor_test.gd` (SceneTree; build the hall like tests/fighter_goal_floor_test.gd `_day()`; set
`career["progression_signs"] = true` for ON). Two DIFFERENT boxers (print both rows): A with the station's stat 40 (novice), B with 85
(master), each sent to the same station (`send_to`) and advanced until phase == "train": A's ProgressRing radius 1.4 +-0.01 and colour
#FBBF24, B's 0.375 and #2DD4BF; walk away -> no ring. Stand phase: A conditioning 40 -> band "spent" applied (pitch read back != 0), B
conditioning 85 -> "sharp". OFF arm -> no ProgressRing node, posture untouched. Prints `PROGSIGNS_FLOOR failures=N`.
Then `python Godot/tools/run_tests.py --only gym_hall,progression,fighter_goal --jobs 2`: no NEW reds vs master.
PR body: `RESULT: tests/progsigns_floor_test.gd -> PROGSIGNS_FLOOR failures=0`.
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/progsigns_floor_test.gd`. Parse gate first:
`python Godot/tools/check_scripts.py <touched .gd>`.

## VISUAL GATE
Claude closes it, not the test: game-camera stills (iso floor_view + floor_close, `record_room`/still tools on the hidden desktop) of the
ring under him at a station (novice and master) and of him standing spent/sharp - gap, noses, wrists, feet checked per still - then the
operator's OK on the board. The test only proves the numbers reach the scene.

## Rules
GDSCRIPT_TRAPS.md. Do not touch GymHallPanel.gd, GymClub3D.gd, ClubRoomBase.gd or ui/OfficePcScreen.gd / FindFightPanel.gd (Cursor
OFFICEPC2 is in them). Never delete or weaken a test. Boxing only.
THE ONE TRAP: a ring rebuilt every frame (or a material per frame) - build once, update on change.

## Prior research
LUDO_R105_raw.txt part D; PROGSIGNS1 (rules/ProgressionSigns.gd header); S240_DIGEST.md (milestone floaters wiring).

## What would a human do?
Game Dev Tycoon / Two Point: a small readable sign on the floor that changes as he improves - no numbers needed.

## Prefab check
Godot TorusMesh + StandardMaterial3D - nothing to download.
