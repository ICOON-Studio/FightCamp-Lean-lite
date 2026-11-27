# LAYERS1 - one man per picture, phase 1 (S572, console worker)

Brief: ops/research/TASK_LAYERS1.md (owner on the board: "Yes, do all moves"). Phase 0: docs/LAYERS0_RESULT.md.
Renders: tools/pics2d_anim.gd layers=1, one family per render on the hidden desktop through godot_slot, watchdog +
"no ArcheAge, llama-server under 4 GB" before each (a preflight script waits 5 min on any of them). Work files in
E:\FightCamp\wt_tmp\LAYERS1\.

## Red first (today's ?layers=1 page, 6 random bouts, jumps over 4 screen px)
| | pictures | boundaries | jumps | touching the cross | both runs layered |
|---|---|---|---|---|---|
| before the cross (S572 start) | 425 | 62 | 63 | 5 | 0 |

## Trial: the cross family - PASSES
Render: pics2d_anim.gd layers=1 only=red_cross_,blue_cross_ at range=3 / 2 / 1 (18 runs, 186 frames, 0 refused, 0 gate
failures) + the short cross (range=3 short=1): both short runs FAIL the picture gate (glove 0.105 / 0.122 m from his face,
the gate wants 0.14), so the short cross stays on its old two-man picture (anim_web skipped it).

Two defects found on the ?layers=1 page and fixed (both would have hit every family):
1. **The man's anchor was wrong** (proto/twohands/tools/layers_cut.py feet_x). It was the mean x of his lowest leg pixels,
   i.e. the ONE foot nearer the camera. Blue's guard in the cross runs sets his feet differently from the hold, so he read
   0.43 m further in while his body stood on the same spot - and the page drew him 0.43 m off (red's cross landed in the
   air). Now the anchor is the middle of the span his feet cover (every column whose lowest leg pixel is in the bottom 40%
   of his legs). Checked: blue reads 0.846 in the hold and 0.83 in the cross; a static man varies under 0.03 m; every Mid
   and Inside run now starts within 0.08 m of the hold's gap (was 0.36-0.53 for the cross). All 138 layered runs re-cut.
   (The layer pictures did not change, only the anchors in img/layers/frames.json.)
2. **Layer pictures were not preloaded** (proto/twohands/layers_ui.js). The page warms a beat's two-man pictures before
   playing them; the layers were not, so the first time a run played the man stayed in his previous pose until his new
   picture loaded (red's cross drawn with red in his guard). warm() now also loads the layers of every run it warmed.

Measure note: the page shakes the whole stage on a landed hit (.stage.shake), which moves both men 5 px together; the
recorder counted it as a jump. The gate is now recorded with reduced motion (a copy of jump_rec.mjs in the work folder,
Emulation.setEmulatedMedia prefers-reduced-motion) - the shake is the ring moving, not a man.

| 6 random bouts, jumps over 4 px | pictures | boundaries | jumps | touching the cross | both runs layered |
|---|---|---|---|---|---|
| before (S572 start) | 425 | 62 | 63 | 5 | 0 |
| cross layered, old anchor, shake on | 491 | 68 | 74 | 10 | 2 (both the hit shake, -5 px each man) |
| cross layered, old anchor, shake off | 522 | 75 | 88 | 10 | **0** |
| cross layered, new anchor + preload, shake off | 425 | 50 | 71 | 14 | **0** (jab + holds family: 0 too) |
The jumps left touching the cross are where a layered run meets an old two-man run (steps, hooks, head moves): they go
family by family, as in phase 0.

Stills (beat_shot copy that pauses the page on the contact frame, ?layers=1, full size, opened): blue's cross landed at
Mid and Inside - glove on his face; blocked at Mid and Inside - glove on his raised glove; red's cross landed / blocked at
Mid and Inside - each man where the 3D take has him (the page's two layers are 88 and 77 px over, 0.04 m apart from the
render), red's cross meets blue's raised glove at his face as the take does. Both men head to feet, feet on the canvas
line, no arm through a body Inside. Long: the cross falls short - still the old two-man picture.
Regression: anim_check PASS (160 runs), page_play_test 4 passed.
