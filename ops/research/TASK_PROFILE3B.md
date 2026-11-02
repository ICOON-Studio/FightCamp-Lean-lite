# TASK PROFILE3B - the profile's 3D stage: the fighter, dressed, in guard, playing the clicked certified move

Model: gpt-6.1-sol (Codex, animation/3D). Keep fixing and re-running until the acceptance is green - there is NO two-run limit.
Approved: operator board Q-S204-3 "yes build PROFILE3" (Ludo r39 s1 + r41 s1.2: the centre of the TECHNIQUES tab is a 3D stage).
Operator S206 (verbatim): "i want to see a proper player profile card with its subtabs fully completed".

## The defect this replaces (seen on the game still docs/previews/s206_profile_tabs/2_tab1_techniques.jpg)
`Godot/scripts/ui/ProfileTabHost.gd` `_build_stage_viewport` (~line 110) mounts `FighterPortrait.build_studio`, a HEAD-PORTRAIT
studio: the still shows a giant bald, bare head and shoulders filling the 920 px stage. The stage must show the WHOLE fighter as he
fights: his own boxing body, trunks, gloves, boots, standing in guard on a mat plinth, framed head to feet.

## Spec
1. NEW `Godot/scripts/ui/ProfileStage.gd` (Node3D builder, static `build(athlete: Dictionary, size: Vector2i) -> SubViewport`):
   - The body + kit exactly as the live fight builds them: `Godot/scripts/FightWorldLiveScreen.gd` (~9k lines - NEVER read whole;
     window `sed -n 1270,1370p`: the fighter node + mesh, `FighterKit.dress(node, mesh)` at ~1318, `FightStagePlayer.new()` at
     ~1345). Reuse those calls; do not invent a second body pipeline.
   - Plays the idle GUARD loop by default through a FightStagePlayer (the same clip library the fight uses).
   - A dark stage: Ludo's plinth (a low cylinder, ~1.6 m diameter, #1E293B top, rim light), a warm key light from front-left and a
     cool rim from behind - the fighter must read clearly against #0B0F17.
   - Camera: full body, head-top to boots inside the frame with ~6% margin top and bottom, slightly above hip height looking a little
     down; framing per move class from `TechniqueTree.stage_camera(node)` ("front34" default, "side" for hooks/uppercuts, "low"
     for body shots) - each a fixed preset, still full body.
   - `play(technique_id: String)`: for a CERTIFIED move (`res://assets/data/certified_moves.json`) play that clip looped through the
     FightStagePlayer (the same role/clip names the fight uses - find the mapping where the fight picks a clip for a technique id);
     for anything else stay in guard and return false. `set_slow(on: bool)` = 0.25x playback. `set_loop(on: bool)`.
2. `Godot/scripts/ui/ProfileTabHost.gd`: `_build_stage_viewport` uses ProfileStage instead of FighterPortrait; a click on a node row
   calls `play(id)`; LOOP / SLOW-MO buttons call set_loop / set_slow; the telemetry card keeps its text. Headless tests keep
   `load_models` false (no stage built) exactly as today.
3. Stills tool `Godot/tools/profile2_stills.gd`: after the TECHNIQUES still, click the Jab row and shoot `2_tab1b_techniques_jab`.

## Acceptance (tier: new script + edited scripts)
- NEW `Godot/tests/profile_stage_test.gd` (SceneTree `_initialize()`, prints `PROFILE_STAGE total=N fails=M`, quit(1) on fail):
  builds ProfileStage for TWO DIFFERENT fighters (different height/reach/body from the roster fixtures the fight tests use - never
  identical); after a few frames: the head-top bone and both foot bones project INSIDE the camera's viewport with >= 4% margin
  (Camera3D.unproject_position on the skeleton's global bone positions - update the skeleton first); the fighter wears the kit
  (FighterKit's boot attachments exist); play("boxing_jab") returns true and the AnimationPlayer's current clip changes;
  play of an uncertified id returns false and the clip stays the guard. This test needs the LFS bodies - it is a PC test.
- Parse every touched .gd; run the test with `"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot
  --script tests/profile_stage_test.gd` (never the _console exe); then `python Godot/tools/run_tests.py --jobs 1 --only profile`
  (jobs 1: the PC ran hot today).
- Claude shoots the stills on the game camera (godot_hidden.ps1) and judges them; you do not open any window or image.

## Owned files
new Godot/scripts/ui/ProfileStage.gd, new Godot/tests/profile_stage_test.gd, Godot/scripts/ui/ProfileTabHost.gd (stage + row click
+ buttons only), Godot/tools/profile2_stills.gd (one extra still). Read-only: FightWorldLiveScreen.gd, FightStagePlayer.gd,
FighterKit.gd, FighterPortrait.gd, TechniqueTree.gd.

## Prior research
LUDO_ROUND41_S206_reply1.txt s1.2 (stage + telemetry card), LUDO_ROUND39_VERDICT_S205.md (reuse the fight's body + clips; only
certified moves play), FighterKit.gd header (boots on boxing bodies).

## What would a human do?
Fight games' move-list screens (Tekken/UFC "move preview"): the real character model on a small lit stage, looping the move you
picked, full body so you read the footwork too.

## Prefab check
None to fetch - every piece (bodies, kit, clips, FightStagePlayer) is in the repo.

## The one trap
`get_bone_global_pose()` is stale until the skeleton updates - force the update (or wait two frames) before projecting bones, or the
framing check passes on the rest pose.
