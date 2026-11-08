# RETARGET2B - the Punch PRO clips re-baked (2026-11-08, rokoko-repair session)

`tests/retarget_fidelity_test.gd`: 46 failures on RETARGET2 as delivered -> 0, bars untouched. It now prints one
`RETARGET_FAIL <clip> <bar> ours= raw= limit=` line per failing clip and bar.

## What was wrong, measured
Delivered RETARGET2: 28 slide, 20 width, 4 jitter failures across 46 clips, mostly small. Three causes:
1. Each ankle aimed from its OWN first-frame position, so the stance started wherever the converted pose happened to start.
2. RETARGET2's width pull could not run on these clips: the Blender export has no hip-line points, so the check for them was false.
   Fixed in `tools/raw_fbx_feet.py` (the raw table's values are unchanged by the fix).
3. "Planted" meant only "near the floor", so a boxer shuffling her feet (Win clips: 2.8 m of raw foot travel) was held still
   against the actor's own stance. Planted is now low AND nearly still (under 0.35 m/s for at least 4 frames).

Two more found by switching stages off one at a time:
- A low-passed plant offset hands the actor's fast foot noise back to the planted foot. Inside a plant the foot now sits
  exactly on its spot, and only the plant's edges are smoothed.
- Smoothing makes these clips worse. They are clean at the source (the S399 finding), and the smoothing written for noisy
  captures adds knee jitter. With smoothing off, one setting alone fails 7 of 145 (mean knee jitter 1.04 x raw).

## The real stance bug, found only by looking at the films
With all of the above done, `retarget_fidelity_test` read 0 failures and the jab was within 2.4 % of raw, and two blind critics
still scored the jab 5 against main's 7 (boots in one line). Measured in floor space, per frame:
raw (scaled) feet 0.32 across / 0.35 along; main 0.35 / 0.31; ours 0.47 / 0.03. The bake's `Y0` step, which turns a take so its
hips face the camera, rotated the whole boxer about 28 degrees, so a bladed stance became side-on. Width across the hips cannot
see that, because the hips turn with the feet. This is the stance collapse the S399 critic saw on RETARGET1.
Fixed: the json route no longer applies `Y0` (`facing=1` restores it), and the fidelity test has a new bar, the world direction
of the line through the ankles against the raw take, every frame, limit 20 degrees. It read the fault: 75 clips failed before the
fix, main's median is 7 degrees, and the final set is median 3, worst 16.

## How the clips were made
`tools/owned_mocap_fit.gd` is new (foot targets, plant holds, stance width). Each of the 145 clips keeps whichever bake
measured best against its raw clip, across 24 settings (the last grid, with `Y0` off). No clip was tuned by hand, and every setting has to clear the same
bars. The pick for each clip is in `RETARGET2B_choice.json`. Setting names:
- `y_r<r>_h<h>_s<s>_st<a>_l<d>`: room=r hard=h smooth=s still=a lock=d, with follow=0 exact=1 dbl=1 hardhz=0 fitbare=1.
Sources: run `tools/raw_fbx_feet.py` with `sources=<dir>`, then `tools/owned_mocap_bake.gd json_batch`, then
`tools/retarget_compare.gd candidates=<dirs> out=<dir>`.

LIMIT OF THIS RESULT: picking per clip from 24 settings makes passing the bars easier than one setting passing them all. It
is a good measure of fidelity, not proof of how a clip looks, so the film is the check that counts.

## Kept from RETARGET2
Width within 15 % of raw every frame and frames >= raw - 1 are bars in the test, for every clip. Jab peak 0.467 s unchanged.
Cross peak moved one frame (0.300 -> 0.267 s) on hip-relative reach, but the top is flat: reach 0.779 then 0.777 m, against
0.933 and 0.936 m on the raw take.

## Regression (merged with main)
retarget_fidelity 0 failures, foot_plant, fight_polish, corner_warm, golden_path pass. boxer_footwork_test has 2 failures,
both "torso leans ... (bar 8-12)", and fails the same way with main's clips in place, so it is not from this work.

## Blind results (sonnet critics, neutral names, every frame, leg crops)
| check | main | this branch | note |
|---|---|---|---|
| turntable, 6 clips, tight fit with `Y0` on (rejected) | jab 7, mean 6.42 | jab 5, mean 6.17 | two critics, jab worse both times |
| turntable, 6 clips, final | jab 7, mean 6.83 | jab 7, mean 7.00 | no clip worse; one fidget better |
| fight film, seed 7, final | 6.5 | 6.5 | critic could not separate them; low-confidence lean to main on stance |
Neither arm reaches the board's 8/10.

## Film
`tools/fight3d_film.gd` now takes `seed=<n>`: without it each film plays a different career (one run missed weight, got
hurt and never boxed, so the film sat on the home screen).
