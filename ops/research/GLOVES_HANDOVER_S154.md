# GLOVES - handover to the next session (Opus 5.5), S154, 2026-10-03

## Operator, verbatim (S154, after the move clips with gloves were sent)
"the gloves are still wrong, you have wasted 2 hours for the gloves on other session and they still not right. prepare next
session for opus 5.5 to fix them and continue with the rest"
Earlier the same session: "why there are no gloves? is it normal?" (that was a defect in MY video tool, fixed - see below).

## What I do NOT know (say this first, do not guess)
The operator has NOT said what is wrong with the gloves. Candidates from the record, none confirmed for the current look:
shape (a blob, not a boxing glove), size against the hand, the cuff/forearm fit, the thumb, colour/paint, position at the
wrist (floating, offset, sunk), orientation in the guard, a glove frozen or lagging behind the hand, clipping into the head.
FIRST ACTION: send him ONE zoomed still or a 3-second close clip of a glove in the live room (see Reproduce) and ask him in one
line what is wrong ("shape, size, position, or movement?"). Everything else waits on that answer. Asking is allowed here:
this is TASTE (CLAUDE.md s2).

## What exists (primary sources - open them, summaries are pointers)
- The glove in the game: the CC-BY 4.0 Sketchfab glove (Incg5764), ONE closed 1,950-triangle mesh in metres (0.26 m cuff-to-front,
  front 0.16 m past the wrist, 0.14 x 0.125 m across, cuff band = vertex colour). Merged S147 as 946b12e0 (C241 run 4).
  `research/S147_DIGEST.md`, `C241_DIGEST.md`, `G80_GLOVE_DIMENSIONS.md` (real-glove dimensions), credits in
  `Godot/assets/models/gloves/CREDITS.md`. Manifest entry `fight_gloves` (approved, CC BY 4.0).
- How it gets on a fighter: `Godot/scripts/CCFighterSkin.gd` - `mount_procedural_gloves(node, discipline, mesh)` (l.178),
  `_pose_gloves` (l.337), `_pose_glove` (l.395, the real palm frame for rigs with finger bones: wrist, middle knuckle, index,
  little), `_build_glove` (l.425), `_paint_whole_glove` (l.518), `sync()` once per frame. The live room mounts it in
  `FightWorldLiveScreen._mount_ruleset_gloves_if_needed` (l.4698) and calls `.sync()` at ~l.4665.
  `FighterFist` folds the fingers (0.3) and thumb (0.05) under the glove.
- Rules: `TASK_Q154_GLOVES_ARE_RULESET_DATA.md` (gloves are ruleset data), `TASK_U176_FIGHTER_B_GLOVES.md` (fighter B).
- History of "gloves wrong": S146 operator asked "is the new gloves finished on the fighters"; U208 gloves frozen/ugly (S141,
  `U208_DIGEST.md`); S147 fixed the glove mesh/tear/UV cracks; the operator's S151 ruling on Q213D "hand goes through the body".
  A past mistake to not repeat (C241): splitting the glove into separately scaled Fist and Cuff tore it open; decimating before
  welding UV-seam vertices opened cracks. Fit by rendering, never by a vertex dump (memory `fit_the_render_not_a_vertex_dump`).

## Reproduce what the operator saw (works, committed)
`Godot/tools/q213_move_video.gd` replays one boxing move for one rig pair with the live room's gloves, half speed, side camera:
```
powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q213_move_video.gd --write-movie <ABS>\out.avi --fixed-fps 30 --resolution 960x540 -- move=boxing_lead_uppercut pair=1 pin=1
```
(moves: boxing_lead_uppercut pair=1, boxing_rear_hook pair=1, boxing_rear_hook_body pair=3). Convert with imageio_ffmpeg
(`-an -c:v libx264 -pix_fmt yuv420p`). The three clips sent to him: `scratch/q213_*.mp4`. NOTE: this tool mounts gloves exactly like the
room but WITHOUT the room's other passes; if the glove looks wrong ONLY here, the defect may be the tool (check by also looking
at the real room: `-- as_game` live room, Tools\godot_hidden.ps1, a hidden render of a bout, not my tool).
Things I saw in my own frame sheets and did not chase: gloves read as plain red blobs from the side camera (no visible cuff/lace
detail at 640 px); the red fighter's glove on the head of the blue fighter at the contact frames; I never zoomed on a single
glove at full resolution (my two zoom crops missed the fighters - wrong pixel offsets).

## Plan for the session
1. Ask the one question above while rendering a LARGE close still (1920x1080, camera 0.8 m from one fist, guard pose, then a
   mid-punch frame) of the live-room glove on BOTH body types (MPFB man = the game today; MetaHuman is OFF).
2. Fix what he names, at the source (`CCFighterSkin` pose/fit/paint or the mesh). Prove with the render, opened; A/B the OFF arm.
3. Gates: parse; `run_tests.py --only glove,fighter_gloves,c241,fight_world --jobs 2`. NIGHTLY1 note: `fighter_gloves_both_corners_test`
   HANGS in the nightly (533 s then rc=127; `FightClipRetarget._load_fbx` prints "Reading less data than requested" at every corner via
   `build_silhouette_corrections`) - it is the glove test and it is red; fix it in this session too (TASK_NIGHTLY1_CHRONIC_REDS.md).
4. Do not spend more than ~90 minutes without showing him a still. The last two hours were spent without his eye on the result.

## Not part of this
The clipping of a defender's glove into the attacker's head (Q213) is a separate defect (clip/contact), see the roadmap decision.

## ADDENDUM - the operator named the defect (S154, after the brief above was written)
Operator, verbatim, with a close crop of a glove: "their body shape looks weird, the hands of the man are awkward. Why can't you identify the
problem on the gloves? it is clear that the gloves do not cover all the hand and facing is weird because you use the left glove on the
right hand and the right glove on the left hand."
So the question in the plan above is ANSWERED. Two defects, his words: (1) the glove does not cover the whole hand; (2) the gloves are on the
wrong hands (left glove on right hand, right glove on left hand). Ignore "ask first"; start from these two. (He also says the staff bodies
look weird and the men's hands are awkward: the STAFF1b portrait is a separate matter, switch metahuman_staff stays OFF.)

### Read-only findings from `CCFighterSkin.gd` (no code was changed; HYPOTHESIS until a render proves it)
- Bone mapping is NOT swapped: `FINGER_HANDS` l -> LeftHand/LeftMiddleProximal/LeftIndexProximal/LeftLittleProximal, r -> Right*.
- `_pose_glove` (l.395) builds the same frame for both hands: X = index->pinky knuckles, Y = wrist->middle knuckle, Z = X x Y. In that
  frame the THUMB side is always -X (index side) for both hands; Z is the back of the hand on the right hand and the palm on the left.
- `_build_glove` (l.448) comment: "The mesh is authored for the RIGHT hand (thumb on glove +X/+Z); the left hand mirrors depth" and the left glove
  is only `scale = (1, 1, -1)`. If the Sketchfab mesh's thumb really sits on +X (the PINKY side of this frame) the thumb is on the wrong
  side for BOTH hands - which is exactly "left glove on the right hand and right glove on the left hand" - and flipping Z cannot fix it.
  Candidate fix: mirror X (and keep the handedness consistent) / re-author the mesh thumb at -X, then verify.
- "Does not cover the whole hand": the glove is 0.14 x 0.125 m across and starts at the wrist with the cuff 0.10 m down the forearm; the
  generated MPFB hand with finger bones is bigger/longer than G80's 10 oz glove, and `FighterFist` curls fingers only to 0.3/0.05, so
  fingers and thumb stick out of a glove fitted to a fist. Measure the posed hand's bounding box against the glove's.
- PROOF TO MAKE (his eye, not a gate): a 1920x1080 still 0.5 m from each fist, front and side, guard pose, BOTH hands side by side, thumb
  side annotated; a test that asserts the glove's thumb side against the hand's thumb bone (ThumbProximal) on both hands and goes RED
  when the mirror is flipped (the instrument must be able to read worse).
