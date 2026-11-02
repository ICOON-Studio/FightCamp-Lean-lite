# TASK U103 — CURSOR — THE PAIR VIEWER: PLAY BOTH FIGHTERS' TAKES OF ONE EXCHANGE ON ONE CLOCK, AND RECORD IT

Model: `composer-2.5`, medium, `-p --force --trust`. Owner: cursor. Worktree
`C:/Users/user/AppData/Local/Temp/FightCamp-U80`, branch `cursor/u103-pair-viewer` (Claude creates it from `master`
before launch - do not switch branches). Push the BRANCH. Stage: S4a (THE MOVE SCRIPT).

**Test tier: NEW TOOLS ONLY - NO EXISTING SCRIPT EDITED.** Parse gate on the owned files, the runs below, then
`U103_check.py`. No suite.

## Owned files (these only)

- `Godot/tools/make_test_pair.gd` - NEW, `extends SceneTree`: builds a TEST pair JSON from two bridge exports.
- `Godot/tools/watch_pair.gd` - NEW, `extends SceneTree`: mounts two fighters and plays a pair JSON on one clock.

## Why this exists

The operator watched our 3D boxing and said "There is no cohesion between animations and reactions" and "Their
distance is off". The fix is a PAIR: one exchange (a jab landing on the head) authored in Blender with BOTH fighters
on ONE timeline, then played back in our room as a unit - both takes sampled at the same pair time every frame, the
two bodies standing at the distance the pair was authored at. Claude is authoring the first pair in Blender now
(through your U102 bridge). This task builds the Godot side that plays one and records it, with the room's meshes,
arena, lights and camera, so the operator judges it on the same picture as the live room.

## The pair format (a contract - Claude's Blender exporter writes exactly this)

```
{"format": "fightcamp.pose_pair", "version": 1, "fps": 60, "id": "BOX_JAB_HEAD_LAND",
 "pair": {"id", "length_s", "contact_s", "entry_s", "start_gap_m", "min_gap_m", "max_gap_m",
          "end_travel_m": {"thrower", "receiver"}},        // FightMoveScript's pair dictionary
 "roles": {"thrower":  {"fighter": "res://.../f01_m_box_welter_rigged.glb", "bones": [...], "take": {...}},
           "receiver": {"fighter": "res://.../f09_m_bare_welter_rigged.glb", "bones": [...], "take": {...}}},
 "notes": "free text"}
```
- `bones` and `take` are exactly U102's bridge blocks (`FightPoseBridge.skeleton_block` / `take_block`): skeleton-space
  GLOBAL transforms at 60 fps. Both roles' takes share ONE `times` array and `take.length_s == pair.length_s`.
- `start_gap_m` is the NODE-to-NODE distance on the floor (the same quantity as the live room's `_gap`): the thrower's
  node stands at `-start_gap_m / 2` along the fight line, the receiver's at `+start_gap_m / 2`, each facing the other
  (`FightWorldStage.face_each_other`). Any travel during the exchange is INSIDE the poses (the Hips move); the nodes
  never move while the pair plays.
- `contact_s` is the pair time the glove meets the target.

## `tools/make_test_pair.gd` (a fixture to prove the viewer - NOT a real exchange)

`-- thrower=<bridge.json> receiver=<bridge.json> out=<pair.json> gap=1.23`
Reads two U102 exports. Thrower take = the thrower file's `jab`; receiver = the receiver file's `idle` until the jab's
`contact_s`, then its `react_head`, then `idle` again to the end. `length_s` = `contact_s + react_head.length_s + 0.5`.
Every frame of both takes is resampled onto ONE `times` array (the bridge rule: `k/60`, then `length_s`) by taking the
source row at the nearest source time (no blending - it is a fixture, and a visible cut is fine). The thrower holds his
jab's last row after it ends. `pair`: `entry_s 0`, `start_gap_m` = `gap`, `min_gap_m = gap - 0.1`,
`max_gap_m = gap + 0.1`, `end_travel_m {0, 0}`, `contact_s` = the jab's `contact_s`. `notes`: "TEST FIXTURE: bridge
takes stitched with no blending". Validate `pair` with `FightMoveScript.validate_pair` (preload
`res://scripts/FightMoveScript.gd`) and print `PAIR_FIXTURE ok` or the errors.

## `tools/watch_pair.gd`

`-- pair=<pair.json> lead=0.8 tail=0.8 [debug]`, windowed; recorded with
`--write-movie <file.avi> --fixed-fps 30 --quit-after <frames>` before `--script`.
1. Build the scene the way `Godot/tools/watch_live_room.gd` (269 lines - read it whole) builds its view: the same
   arena, lights and side-on camera FRAMED FROM THE SKELETONS every frame (copy its framing constants and function),
   the real-time stopwatch label. But do NOT start the fight room or the engine: instance the shell
   (`res://scenes/FightWorldPreview.tscn`) and mount the two meshes named in the pair with `FightWorldStage.mount`
   (read `Godot/scripts/FightWorldStage.gd` for `mount` and `face_each_other` only), at `-start_gap_m/2` and
   `+start_gap_m/2` along the line between the shell's `SpawnA` and `SpawnB` marks, facing each other.
2. For each role, `FightPoseBridge.animation_from(<role data with "takes": {"pair": take}>, "pair", skel, skel_path)`
   (preload `res://scripts/FightPoseBridge.gd`), add it to that fighter's AnimationPlayer library as `pair`.
3. ONE CLOCK: a single `pair_t` advanced by frame delta. For `lead` seconds both bodies hold frame 0 of their take;
   then both play; after `length_s` both hold the last frame for `tail` seconds; then quit. Every frame, BOTH
   AnimationPlayers are set to the SAME time: `ap.seek(pair_t, true)` on each (clamped to `[0, length_s]`) - never
   `play()` on separate timers.
4. A label under the stopwatch: `pair <id>  t=<pair_t 2 decimals>`, and the word `CONTACT` shown for the frames within
   2/60 s of `contact_s`.
5. With `debug`: at pair times 0, `contact_s` and `length_s` print
   `PAIR_DEBUG t=%.3f role=<role> hand_L=<x,y,z> head=<x,y,z> hips_world=<x,y,z>`, where `hand_L` and `head` are the
   SKELETON-SPACE positions from `FightPoseBridge.globals_at(skel, anim, t)` and `hips_world` is the Hips bone in world
   space (`skel.global_transform * globals_at(...)[hips].origin`), and once `PAIR_DEBUG gap_nodes=%.4f` (the two nodes'
   flat distance). Then `PAIR_DONE`.

## Gate, in order

1. `python Godot/tools/check_scripts.py Godot/tools/make_test_pair.gd Godot/tools/watch_pair.gd`
2. Two bridge exports with U102's tool (it is on master):
   `python C:/Users/user/AppData/Local/Temp/FightCamp-tools/godot_run.py C:/Users/user/AppData/Local/Temp/FightCamp-U80 tools/export_take_poses.gd --timeout 1200 -- side=a takes=jab,idle out=C:/Users/user/AppData/Local/Temp/u103_a.json fps=60`
   and the same with `side=b takes=react_head,idle out=C:/Users/user/AppData/Local/Temp/u103_b.json`.
3. `godot_run.py ... tools/make_test_pair.gd --timeout 600 -- thrower=C:/Users/user/AppData/Local/Temp/u103_a.json receiver=C:/Users/user/AppData/Local/Temp/u103_b.json out=C:/Users/user/AppData/Local/Temp/u103_pair.json gap=1.23`
4. `godot_run.py ... tools/watch_pair.gd --windowed --timeout 600 -- pair=C:/Users/user/AppData/Local/Temp/u103_pair.json lead=0.5 tail=0.5 debug`
   and save its log as `C:/Users/user/AppData/Local/Temp/u103_watch.log`. (Run `godot_run.py --help` once for the
   `--windowed` form; Godot cannot render headless.)
5. `python research/U103_check.py C:/Users/user/AppData/Local/Temp/u103_pair.json C:/Users/user/AppData/Local/Temp/u103_watch.log`
   must print `U103_CHECK PASS`. **If it cannot, do not commit: send `U103 BLOCKED` with its FAIL lines.** Never edit
   the check.
6. Record 3 s to prove the movie path: the same run with `--write-movie C:/Users/user/AppData/Local/Temp/u103.avi
   --fixed-fps 30 --quit-after 90` before `--script` (through the wrapper if it supports extra Godot arguments; else the
   windowed exe directly with its output redirected to a file - never piped into PowerShell). Report the file size.

## Deliver

`git restore --staged -- AgentComms/messages` first. Commit ONLY the two owned files with their paths on the commit
line, `git show --stat HEAD`, `git push -u origin cursor/u103-pair-viewer`, then
`python Tools/agent_comms.py send --from cursor --to claude --topic "U103 ready" --body "<the U103_CHECK line, the avi size>"`.
Do not commit JSON, logs or video. Do not edit HANDOFF.md or AgentComms/roadmap.json.

## The trap

Two AnimationPlayers each `play()`ed start on the frame each call happens and drift apart by a frame whenever a frame
is slow - that drift is the "each part has its own speed" the operator saw. Seek both to one `pair_t` every frame. And
`FightWorldStage.mount` applies the fighter's weight scale to the node: place the nodes by the NODE distance, and read
positions back from the skeleton's global transform, never from assumed metres.

## SEND-BACK 1 (Claude, 2026-09-14) - THE CHECK PASSED AND THE PICTURE WAS WRONG: BOTH MEN STAND UNDER THE RING

Your `5be4e50` passed `U103_check.py`, and Claude opened `u103.avi`: both fighters are sunk into the ring canvas to the
waist and the camera cuts their heads off (it frames from toes that are underground). The ring's canvas is about a metre
above the floor, and the fighters were mounted on the floor. The live room gets this right in
`FightWorldLiveScreen.setup` (`Godot/scripts/FightWorldLiveScreen.gd:284-300` - read only those lines): it resolves the
arena spec (`_spec_for`), takes `deck = Arena.surface_y(spec)`, adds `Arena.build(spec)` to the shell, and passes that
`deck` to `FightWorldStage.mount`. Do the same in `watch_pair.gd` (reuse the room's spec path for DISCIPLINE `boxing`).

Then add, with `debug`, at pair times 0 and `contact_s`, one line per role:
`PAIR_DEBUG ground t=%.3f role=<role> deck_y=%.4f toe_min_y=%.4f` - `deck_y` the canvas height you mounted on, `toe_min_y`
the lower of `LeftToes` / `RightToes` in WORLD space (`skel.global_transform * FightPoseBridge.globals_at(...)[toe].origin`).
`U103_check.py` on master now fails when a standing man's lowest toe is more than 3 cm under the canvas or 10 cm above it.
`git merge origin/master` brings the new check into your branch. Rerun steps 4-6, open three frames of the new `u103.avi`
yourself (any image viewer or a 10-line Python cv2 script) before you send, and say in the mail what you saw.
