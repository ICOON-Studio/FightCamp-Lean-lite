# TASK_Q149 - significant hits get a push-in and a touch of slow motion (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S60, 2026-09-23.

## What the operator asked, verbatim
> "can you add auto zoom to the targeted area when a significant hit happens and a bit of slow slow mo ?"

## Owned files
- `Godot/scripts/FightHitCam.gd` (NEW, pure module - no preloads, no autoloads, caller passes everything).
- `Godot/scripts/FightWorldLiveScreen.gd` - ONLY: construct it, feed it significant beats, apply its output.
- `Godot/tests/fight_hit_cam_test.gd` (NEW).
- `research/Q149_DIGEST.md` (NEW).

## Spec
1. A beat is a trigger when `beat.significant == true` AND it landed (contact not missed/blocked),
   or `beat.knockdown == true`. The beat dictionary is what the HUD already reads at
   `FightWorldLiveScreen.gd:2570-2583` (`target_region`, `contact`, `significant`, `knockdown`).
2. ZOOM: the camera's look-at eases toward the TARGET man's hit region (head_neck -> Head bone,
   torso/body -> Chest/Spine, legs -> the leg's LowerLeg bone, read off his Skeleton3D) and the
   camera dollies in to 0.6x its distance. Ease in 0.15 s, hold 0.5 s, ease out 0.4 s
   (smoothstep). It rides ON TOP of the free camera (`_view_yaw_deg/_view_pitch_deg/_view_dolly`,
   `_apply_view()`): it must return exactly to the player's view afterwards.
3. SLOW MO: presentation speed `_speed` is multiplied by 0.35 across the hold, eased back.
   The engine is untouched (it is pumped by ticks; `_speed` is a presentation knob - see the
   note above `_read_pace()`). Knockdown: 0.25x and 1.0 s hold.
4. Cooldown 2.0 s so a flurry does not stack zooms. Option `hit_cam` in `configure()`,
   default true in the game and **false under `--script`** unless passed (tests and recording
   tools must be unchanged).
5. `FightHitCam.gd` API (contract - the test calls these exact names):
   `static func trigger(beat: Dictionary) -> String` returns "" (no trigger), "hit" or "knockdown";
   `func start(kind: String, region: String, now_s: float) -> bool` (false while cooling down);
   `func sample(now_s: float) -> Dictionary` returns `{"zoom": float in [0.6, 1.0], "speed": float in [0.25, 1.0], "region": String, "active": bool}`.

## Anchors (FightWorldLiveScreen.gd ~2,900 lines - never open it whole)
`_process` :938, `_apply_view` (grep), HUD beat read :2570, `_read_pace` (grep). `sed -n` windows only.

## Gate (tier: a script edited + a new module)
- Parse gate on the three .gd files.
- Test: trigger() on landed-significant / missed-significant / non-significant / knockdown beats;
  the sample() curve (1.0 before, 0.6 at hold, back to exactly 1.0 after, monotone ease);
  cooldown refuses a second start inside 2.0 s; speed never below 0.25. Break the module 4 ways
  (mutants) and show the test catches each.
- `python Godot/tools/run_tests.py --only room`, `--only world`, `--only camera`. No full suite.
- Stills: capture one significant hit before/at-hold/after into `previews/hit_cam/` and OPEN them.
- Branch `qwen/q149-hit-cam`, commit explicit paths ("Co-Authored-By: Qwen <noreply@qwen.ai>"),
  push, digest, `python Tools/agent_comms.py send --from qwen --to claude --task Q149 --body "..."`.

## Trap
Never change `_speed` permanently or touch the engine tick: a slow-mo that leaks changes the
bout's presentation clock for the rest of the fight. Restore to the player's own `speed=`.
