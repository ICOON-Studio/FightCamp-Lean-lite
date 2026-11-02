# TASK CROUCH - a fighter drops to his hands for ~2 s and pops back up (operator S160: "fix the crouch too")

Owner: Claude next session (windowed recording on the PC). Model: Sonnet.

## Evidence
`tools/record_room.gd -- discipline=boxing seed=92012 as_game`, round 1 clock 2:17 -> 2:14 (movie t 43-46 s, frames
~1290-1380): fighter A (red trunks) folds to hands and knees, no knockdown in the log (scorebug shows none, which is
right), then stands. Stills: `previews/readround/sheet2.png`.

## Do
1. Re-record with `pose_log=1` (prints clip, trunk tilt, foot height per drawn frame when extreme) and read which clip
   plays on A at frames 1290-1380 and why (beat type, contact, reaction role).
2. Bucket by clip first (S131 lesson): if it is a reaction clip (e.g. `react_leg` / StaggerLarge, 2.7 s nearly to the
   floor) chosen for a non-knockdown punch, the fix is the reaction choice, not the clip.
3. Fix, re-record the same seed, open the frames, and add a guard test: no non-knockdown beat plays a reaction whose
   pelvis drops below X of standing height (bound, derived from the clip set).
