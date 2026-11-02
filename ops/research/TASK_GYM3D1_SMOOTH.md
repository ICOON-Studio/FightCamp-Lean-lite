# TASK GYM3D1_SMOOTH - every animation transition in the one big 3D gym is smooth (S176 operator rulings, next session)

Model: medium. Owner: claude. Branch: `claude/walk-clip-gym-hall-3d-meqiti` (unmerged; merge master in first: `git fetch origin master && git merge origin/master`).
Files: `Godot/scripts/GymHall3D.gd` (~850 lines; grep, read windows), `Godot/scripts/GymHallLayout.gd`, `Godot/assets/data/gym_hall.json`, tests under `Godot/tests/`. Do NOT edit TrainingFloor3D.gd unless a hook is unavoidable (say so).

## Operator, verbatim (2026-10-07, after the hall video with stairs)
"the animation from walking to taking the pose to punch is very abrupt, do not zoom the camera when he is about to climb the stairs,
put a rope that the coach will close the rope gap behind him when he enters after the fighter or if the fighter enters later he close
the ropes or make a proper animation to mount the ropes and enter the cage, every animation transition needs to be smooth"
Earlier in the same session: "he keeps walking a bit more than he should" (FIXED: walk clip stops when the walk phase ends) and
"he goes through the ring base" (FIXED: stairs + route + rope gap, `gym_hall_ring_steps_test`).

## What exists (anchors, commit 30f7c4e3 and later on the branch)
- `GymHall3D._set_body(training)` REBUILDS the fighter node (`_build_fighters`) at send_to (walk starts) and at arrival (train starts): the new body
  starts its clip at frame 0 = the pop. `_play_walk_clip` / `_stop_walk_clip` / `_build_walk_clip` / `_planted_foot_speed` (walk cycle, cached per id).
- `_place_on_route(fraction)` sets position (y from `HallLayout.height_at`) and heading each tick.
- Click: `_unhandled_input` -> `send_to(clicked)` then `focus(clicked)` IMMEDIATELY (camera zooms to the destination while he is still walking).
- `_build_ring_steps()`: 4 greybox steps + the south ropes split around the stairs (`RopeS0..2` + `RopeS0B..2B`).

## Build (in this order, one commit each, tests green before the next)
1. CROSSFADE (the main one). Before `_set_body` frees the old body, snapshot its skeleton pose (rotation of every bone + Hips position) into an
   `Animation` addressed like the clips (`Retarget.address_tracks`, path "<skel path>:<Bone>"), add it to the NEW body's "floor" library as "from",
   `player.play("floor/from"); player.advance(0.0)`, then `player.play(<walk or idle/station clip>, 0.35)` (custom_blend crossfade). Also carry the
   yaw: new node starts at the old yaw and `lerp_angle`s to its target over 0.4 s (and `_place_on_route` turns toward the heading at a limited rate,
   not instantly). Same for walk -> idle (`_stop_walk_clip`: `play("floor/idle", 0.25)`), idle -> walk (0.2), arrival -> station clip (0.4).
   Test (headless, models on): sample bone rotations of the SAME skeleton in consecutive frames across each transition; the largest per-frame
   angular change must stay under a bound AND a CONTROL (the current rebuild) must exceed it. Open stills/video frames on the game camera.
2. CAMERA on arrival, not on click. New `click_station(id)` = `send_to(id)` + remember the focus; `focus()` runs when the walk phase ends
   (where `_stop_walk_clip` is called). While he walks (stairs included) the camera stays where it is. `tools/gym_hall_video.gd` should use
   `click_station` and wait for the arrival (its `_until_phase("train", 10.0)` timed out and zoomed mid-walk: 25 s).
3. ROPE GATE. Replace the permanent gap by a gate: 3 rope boxes in the gap on a hinge `Node3D` at the gap's left post; CLOSED by default, swings
   open (rotate Y ~85 deg, 0.4 s, eased) as he comes within ~2 m of the stair foot, closes again (0.5 s) once he is > 1 m inside / > 2 m away.
   Operator's picture: "the coach closes the rope gap behind him". There is no coach animation yet: do the gate first, with the coach standing
   at the steps (he already stands beside them); a real "coach lifts/closes the rope" clip, or a "mount the ropes" clip, is optional and needs a
   generated motion (`generate` skill, fal.ai pay-as-you-go: ASK the operator first, it costs money).
4. Name tag: it still says "ON THE MOVE" during "prepare" (row label set at send_to); update it when the walk ends. Coach/body scale mismatch
   and no boxing boots are separate backlog items (not this task).

## Acceptance (all measured, printed in the digest)
The transition test above (per-frame rotation bound + control red), `gym_hall_ring_steps_test` (10), `gym_hall_walk_clip_test` (10), gym_hall_3d_test 29,
gym_hall_panel_test 6, daylap_splice_test 20, day_lap_test 81, gym_hall_layout_test; then the 30 s hall video (job=windowed `tools/gym_hall_video.gd`)
opened by you and sent to the operator for his OK. Run order and how: AgentComms/AGENT_TOOLS.md "PC runner" (dispatch with `ref=master` and input
`ref=claude/walk-clip-gym-hall-3d-meqiti`; two runners now: jobs run in parallel).

## Trap
A SceneTree test whose `_run` hits a script error never quits: keep the 90 s watchdog `create_timer(90.0)` in every new test. Search the `Clip`
player under `Fighters/` only (the coach has a `Clip` player too).
