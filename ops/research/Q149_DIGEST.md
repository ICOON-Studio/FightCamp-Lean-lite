# Q149 Digest - Hit Cam + Slow-Mo

## What was built
A pure `FightHitCam.gd` module that triggers on significant landed hits and knockdowns,
easing the camera's look-at toward the target's hit region bone while dollying in to 0.6x
and slowing presentation to 0.35x (0.25x for knockdowns). The effect rides on top of the
player's free camera and returns exactly to their view when it ends.

## Files
- `Godot/scripts/FightHitCam.gd` (NEW) - pure module, no preloads/autoloads
- `Godot/tests/fight_hit_cam_test.gd` (NEW) - 22 checks, 0 failures
- `Godot/scripts/FightWorldLiveScreen.gd` - integrated: preload, configure option, setup
  construct, _count_action feed, _process apply/restore

## API contract (test calls these exact names)
- `static func trigger(beat: Dictionary) -> String` - returns "" / "hit" / "knockdown"
- `func start(kind: String, region: String, now_s: float) -> bool` - false while cooling
- `func sample(now_s: float) -> Dictionary` - {zoom, speed, region, active}
- `static func bone_for_region(region: String) -> String` - region -> bone name

## Timing
- Hit: ease in 0.15s, hold 0.5s, ease out 0.4s. Zoom 0.6x, speed 0.35x
- Knockdown: ease in 0.15s, hold 1.0s, ease out 0.4s. Zoom 0.6x, speed 0.25x
- Cooldown: 2.0s between triggers

## Integration
- `configure({"hit_cam": bool})` - default true in game, false under --script
- `_feed_hit_cam(beat)` called from `_count_action` on each impact
- `_apply_hit_cam()` called at start of `_process`, saves/restores player's view state
- Look-at blends toward target bone position (Head/Chest/LowerArm/LowerLeg by region)
- Speed multiplier applied to _speed for body advance and show clock

## Gate
- Parse gate: FightHitCam.gd, fight_hit_cam_test.gd, render_hit_cam.gd pass (0 fails)
- FightWorldLiveScreen.gd parses clean after is_inside_tree() fix
- Focused test: 22 checks, 0 failures
- --only world: 6/6, --only room: 2/2, --only camera: 2/2 (all green)

## Round 2 - regression fix
- fight_world_live_test.gd failed with `Condition "!is_inside_tree()" is true` because
  `_apply_hit_cam()` read `_live_camera.global_position` and `_feed_hit_cam()` called
  `bone_world()` while the room was not yet in the scene tree.
- Fixed: `is_inside_tree()` guard in both `_feed_hit_cam()` and `_apply_hit_cam()`,
  plus `_live_camera.is_inside_tree()` guard on the `global_position` read.
- Render script `tools/render_hit_cam.gd` captures before/at-hold/after stills.

## Stills
Captured to `previews/hit_cam/`:
- `01_before.png` - wide shot, normal camera distance
- `02_at_hold.png` - zoomed in on significant hit (FIGHTER B takes it to head_neck)
- `03_after.png` - camera returned to normal distance

## Trap avoided
_speed is restored every frame. The engine tick is untouched. The player's _view_dolly is
saved before hit cam apply and restored after, so the free camera state is never corrupted.
