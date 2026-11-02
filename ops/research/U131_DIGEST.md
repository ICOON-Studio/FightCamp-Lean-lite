# U131 digest (cursor)

- `UIKit.technique_preview` + resolve/playback helpers: 380×420 hover panel; four states (PLAYING, NEAR labelled on face, NO CLIP YET, NO MOTION); schematic strip with `TechniqueGlyphs`; SubViewport mounts `FightWorldPreview` + `FightStagePlayer` with looped graft/retarget via existing bind path (BoneTrackGraft handles bare bone tracks).
- `SkillsMovesPanel`: 200 ms hover dwell (`PREVIEW_HOVER_DWELL_MS`), popover beside tree cell, `_process` advances preview player; click selection unchanged.
- Kit book: 3 variants + helpers entry; renders `technique-preview-*.png` (320 variants / 320 renders).
- Tests: `ui_technique_preview_test` (resolve + NEAR copy + `strike_head` bone motion via `advance`); `run_tests.py --only ui` total=16 fails=0; `--only skills` total=1 fails=0.
