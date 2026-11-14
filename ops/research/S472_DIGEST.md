# S472 digest (2026-11-14)

## His words
- C398 "if this is corner minute why it has the gyms background" -> fixed. C399 "kind of heavy on the eye, lighten it up a
  bit" -> "Lighter still" -> "Light enough". C400 "ok" (clinch reach). "Take's 18" on the rear knee pair.

## What changed (commits on main)
- ffef7717, c82bebea: fight night on a solid venue dark (MainFlow.gd: the "fight" modal's scrim opaque); the 3D corner
  card panel #62513f at 0.86 with a #8f7760 edge (CornerOverlay.gd). Stills on the review board.
- 9940d6cb + 1122a809: SPLIT471 (Qwen) collected as a diff; PunchReach forwarders `_along` (ReachLimit calls it by name:
  every punch in the game errored after the split), `weight`, `static var STRAIGHT`. Evidence: golden_path 0, short_punch 0,
  crack_wire 0, clinch_rest PASS, punch_form output identical with and without the split, head_aim 0, fight_feel 0;
  hit_frame 3 and punch_speed 41 equal the pre-split files.
- 9caa8b0d + 61cd4c31: rear knee. tools/stance_raw.py (Blender on Box1_M3_Idle): the take's rear knee 17.8 deg inside its
  toes (lead 1.2); rear toes 45 deg; balls 0.46 along x 0.39 across; pelvis line 68.6 deg off the lead toes. The take's
  stance on the rig moved guard_knee -0.079 -> -0.085 -> -0.092 (the foot is not the cause). REAR_BAND_DEG 0 -> 18 (his
  pick, tools/knee_band_still.gd); boxer_footwork_test bar split lead 8 / rear 20: footwork 0 (rear 18.5 / 18.6);
  guard_knee -0.031 / -0.017 v +0.029 (gap halved, still red: the hips -> TASK_PELVIS1, Qwen, launched 18:22).
- 107a47ad: double hook closed. PunchReach's target is live (RangeTable.aim -> target_point -> GloveClear.shown_head).
  Probe arm `-- reachwhy`: pro_left_hook_ft short of the full solve 0.097 m, all of it ReachLimit's 0.30 m cap off the
  clip's glove; glove 0.168 m off -> shown as a graze (GRAZE_M 0.15) by design.
- punch_range_test: a WINDOWED test (header); headless it had no stage and a script error -> now a clear FAIL line.
- Played fight (hit_gap_probe, hidden desktop, 30 fps): 0 script errors, 33 landed, 1 far = S471.

## Lessons (memory: project_s472_split_fix_knee_take)
- After a split, grep every removed name (func, const, static var) including call("_name") strings; run the tests that
  drive the moved code.
- Measure the source take with the bar's own measure before tuning a pose to a bar.
- The guard still tool shoots 6 frames after setup, before the step-out: not a game defect.

## Not done
- guard_knee red (hips), punch_speed 41 (pre-existing), plan_bots red (step bars). His flowchart picture verdicts.
- Miro P0: two surplus empty slots not deleted (deletion needs his OK).
- punch_range_test WINDOWED (hidden desktop, 60 fps, seed 4242): runs to the end, failures=73 (heads, elbow bands, misses, cap) - the first windowed baseline; nothing to compare yet.
