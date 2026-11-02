---
name: project-godot-bake-fps
description: generate_scene bakes at 30 Hz by default - glTF resamples up AND down, FBX ignores it entirely
metadata:
  type: project
---

`GLTFDocument.generate_scene()` resamples animation onto a `bake_fps` grid whose
engine default is **30**. Measured S39:

- **glTF resamples both ways.** `combo_jab_cross_hook.glb` holds 75 keys at
  30 Hz in the file and returns **593 keys** when loaded at 240. So **counting
  keys off a loaded clip can never recover its native rate** - it returns the
  grid you asked for. Read the file's own sampler input times instead:
  `Tools/glb_native_rate.py` / `Tools/glb_read.py`, no engine needed.
- **FBX ignores `bake_fps` outright.** Swept at 8/15/30/60/120/240 on
  `H2H_HitReaction01.FBX`, the key count never moved off 18 on a 3.0333 s clip.
  Godot hands back the file's own authored poses.

`FightClipRetarget._load_fbx(path, bake_fps := 30.0)` takes the rate;
`_source_frames` passes whatever the caller is sampling at. Both shipped callers
pass `RETARGET_FPS = 30.0`, so the game is unchanged.

**Blast radius, measured and closed:** of 64 GLBs only 4 are above 30 Hz (the
CMU paired captures); of 241 parsed FBX, 42 are 60 Hz but none are baked.
**The defect touched exactly four files.** `fight_clip_bake_rate_test.gd` pins
both halves - do not "simplify" the two branches together.

A resample destroys single-frame extrema and leaves distributions alone: it cost
4.8 mm on 18/19_05's one-frame dip and nothing on 22/23_17's 620-frame hold.
Related: [[feedback-validate-on-a-fixture-that-can-fail]].
