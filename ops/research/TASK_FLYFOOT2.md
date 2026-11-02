# TASK FLYFOOT2 (S221) - the feet point like a ballet dancer's: ankle pitch, roll and toes in the live fight

Model: Codex sol, reasoning high. Worktree E:/FightCamp/wt/FLYFOOT1 (branch codex/flyfoot1, HEAD 93a2c7d6) - continue there, merge
origin/master first. Never master. Next on the Codex seat (operator-seen defect: it goes before the rest of the Codex queue).

## The operator's verdict on FLYFOOT1 round 1 (S221, verbatim, after watching flyfoot1_20s.mp4)
"wtf i checked the video is to bad the feet do not look normal yellow boxer has no hair and doesnt throw a single punch"
and, with two crops of the feet: "these do not look normal".
- Crop 1 (yellow/Perez rear foot): a rounded stump with no toes visible - the foot is pointed straight down (fully plantar-flexed),
  so the camera sees the top of the foot only.
- Crop 2 (purple/Adebayo): the foot points down AND rolls inward (sickled: plantar-flexed + inverted), toes toward the floor.
- His full frame: `previews/flyfoot1/operator/operator_frame.png`.
Round 1 measured root speed, ankle width, crossing and airborne - all GREEN - while the feet look wrong. The gate could not see
the defect: it never measured how each FOOT is oriented.

## What a real boxer's feet do (bound values, not one number)
- Lead foot: flat or nearly flat on the canvas in guard and while punching: foot pitch (heel->ball line vs the floor) 0-12 deg,
  roll (sole tilt sideways) within +-10 deg, toes not curled under.
- Rear foot: up on the ball, heel raised: pitch 15-40 deg; never "en pointe" (> 55 deg) except a frame or two at the very end of a
  rear-hand pivot; roll within +-12 deg.
- Toe bones: bent UP (dorsiflexed, the ball of the foot carries weight) or neutral - never curled down under the foot.
Sources to cite in your report: boxing stance coaching references (rear heel up, lead foot flat) and K46 (ball-only support rule,
already in the repo) - reconcile with K46: "ball support" = heel up 15-40 deg, not a pointed foot.

## Do
1. A GATE THAT SEES IT, red first: in the as_game recording (record_room.gd as_game, the same seeds 930093 and 94301, different
   fighters, the four MetaHuman bodies), per frame per foot compute from WORLD bone positions (MetaHuman foot/ankle, ball and toe
   bones - print their names): pitch = angle of (ankle->ball) vs the floor plane, roll = sole normal tilt about the foot's long
   axis, toe = angle of (ball->toe tip) vs (ankle->ball). Report max/p95 per foot per fighter and the % of frames outside the bands
   above. Run it on master AND on 93a2c7d6 first: it must read RED on the shipped tree (paste the lines) - if it reads green, the
   instrument is still blind; fix it before touching the feet.
2. Find the writer: which system sets these angles each frame (the clip, the foot lock/IK, the ball-support rule, the pelvis
   grounding, the toe bone untouched by retargeting?) - log the first writer that pushes pitch past 55 deg or roll past 12 deg.
3. Fix the cause in the pipeline that owns it (foot IK target orientation / ankle limits / toe retarget), not by clamping in the
   recorder. Keep round 1's gains (no flying, no sliding, no crossing).
4. Re-run the gate: both fighters, both seeds, >= 95% of frames inside the bands, no frame en pointe for more than 2 consecutive
   frames outside a pivot.

## Gate
- Parse: `python Godot/tools/check_scripts.py <touched .gd>`.
- The feet gate (red on master + 93a2c7d6, green after), `Tools/flyfoot_gate.py` for round 1's checks, then
  `python Godot/tools/run_tests.py --jobs 2 --only flyfoot,foot_lock,realism,fight_moves,fight_stage` (`--jobs 1` unless GREEN).
- Commit + push codex/flyfoot1 at every checkpoint.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
Red first (above). Stills via record_room.gd as_game + still_framing.gd save_if_framed: guard, mid-punch (rear-hand), between -
PLUS a feet close-up crop of each still (the operator judges feet). A 20 s clip for the operator. Report per still: gap, noses,
wrists, FEET (pitch/roll numbers at that frame), bodies. Do not call it fixed; Claude opens every still, the operator closes it.

## Not in this task (Claude routes them)
- No hair on Perez: bodies mh_boxer_02 and mh_boxer_07 have no hair-card textures (export gap) -> MH5.
- Perez throws 8 punches in 60 s (Adebayo 19; CompuBox 45-56 per 3-min round = 15-19/min), the SAME on master -> PAIRLIVE1 item 6.

## Prior research
FLYFOOT1_DIGEST.md (round 1), K46 (ball-only support), Q103 (root motion), TASK_FLYFOOT1.md, memory: Cursor/agents cannot judge
images - measure geometry.

## The one trap
A foot "on the floor" can still be pointed like a ballet dancer's. Measure ORIENTATION, not just height and position.
