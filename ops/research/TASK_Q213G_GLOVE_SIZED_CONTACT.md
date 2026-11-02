# Q213G - clear the three failing palette moves: the guard GLOVE stays out of the attacker's head

Model: Claude (Opus 5.5) next session, or Cline (stealth model, ends 2026-10-05) once NIGHTLY1 lands. Worktree
E:/FightCamp/wt/<seat>, branch `<agent>/q213g` from origin/master. Nothing opens on the operator's screen (file tool only;
Godot windowed only via `Tools\godot_hidden.ps1`). IDLE priority, one Godot process at a time, never the full suite.

## Why (operator, S155, verbatim choice)
Asked whether the demo should withdraw boxing_lead_uppercut / boxing_rear_hook / boxing_rear_hook_body (honest skin gate
FAIL 3.85 / 1.56 / 3.63 cm) or fix them: **"Fix their clips first"**. They stay in the certified palette meanwhile.

## What is known (primary sources)
- Q213C_DIGEST.md l.332-381: every failing row is the DEFENDER's raised guard hand inside the ATTACKER's head
  (`skin:B:LeftHand>Head`, `LeftLittleDistal>Head`) - the attacker bows/leans into the guard during the move.
  Rigs pair a-d, frames named there (lead_uppercut d f71-80 3.85 cm; rear_hook b f27 1.56; rear_hook_body d f17-20 3.63).
- Q213F (origin/codex/q213c baf08337, NOT merged): elbow IK, marginal (none of the 3 cleared). Do not resume it.
- S155 (GLOVES, ff134b75): the game now draws a closed Sketchfab glove (0.26 m cuff-to-front, front 0.16 m past the wrist,
  0.14 x 0.125 m across) and CUTS the hand out of the body mesh under it. So the thing that must stay out of a head is the
  GLOVE, not the bare fist.
- HYPOTHESIS (S155, unmeasured): both the room's head-protection push and the gate use the capsule body's hand part:
  `FightBodyCapsules.gd` l.28-29 + l.77 - a sphere on the hand BONE (the wrist) with radius = p80 of bare-hand skin
  distances (~4-5 cm). A glove's mass sits ~6-8 cm past the wrist with ~6.5 cm radius, so the push
  (`FightContactSolve.hand_pushes` l.69, `HEAD_CLEAR_M` l.67; room `FightWorldLiveScreen._stop_posed_contact`; gate
  `tools/q213_clip_gate.gd` `pin_gloves` l.763) leaves most of the glove free to sit in a head. And the Q213E skin gate
  (`tools/q213e_skin.gd` `model()` l.7) measures the BARE body mesh - no glove is mounted in the gate - so it reads a folded
  fist the game no longer draws; the glove probably reads WORSE.

## Prior research
Q213C_DIGEST.md (the honest table + review stills), Q213_DIGEST.md, TASK_Q213_CLIPPING_GATE.md, C191_DIGEST.md (contact_stop),
S126_DIGEST.md (push box, PUSH_SKIN_M, the jab lunge fixed at its root with a solved Spine lean), C223_DIGEST.md
(FightClipPoseLayer keyed offsets), G80_GLOVE_DIMENSIONS.md (real 10 oz glove), research/topics/contact_collision.md.
G147 limits: head > 1 cm for > 1 frame fails.

## What would a human do?
A fight-game animator gives the glove its own collision volume the size of the glove, keeps it out of the opponent's head
with contact IK (the hand slides to the head surface), and only edits a clip's head path when the IK cannot hold without
an ugly arm. Measure the glove as drawn before touching any clip.

## Prefab check
Everything needed exists: the glove mesh and its frame (`CCFighterSkin._pose_glove`), the posed-triangle probe
(`tools/q213e_skin_fast.gd`), the push (`FightContactSolve.hand_pushes`), the pose layer (`FightClipPoseLayer.gd`, 107 l.).
No new library.

## Spec, in order
1. INSTRUMENT FIRST: add a glove arm to the gate - mount `CCFighterSkin.mount_procedural_gloves` on both clip-mode bodies
   and measure the glove mesh's posed triangles (world space, as drawn) against the opponent's head skin, beside the
   current hand-skin row. Print both per move/rig. Prove it reads worse: on master, a glove row >= the hand row on
   lead_uppercut d.
2. Fix at the root, smallest first: give the hand part the glove's volume when gloves are on (centre = the glove's
   centroid in the glove frame, radius from the mesh - derived, not typed) so the existing push/pin keeps the GLOVE
   out. Measure the 3 moves; then the 23 passing moves must not regress (C223 production gate on the certified pairs).
3. Only if 2 cannot clear a move without a broken arm: a `FightClipPoseLayer` lean-back key on the ATTACKER's Spine
   over the named frames (S126 method: solve the angle by target, print achieved beside wanted).
4. Video: the 3 moves via `tools/q213_move_video.gd` (now draws the S155 gloves), frame sheet opened by you, then sent to
   the operator (silent).

## Owned files
`Godot/tools/q213_clip_gate.gd` (810), `Godot/tools/q213e_skin.gd`, `Godot/tools/q213e_skin_fast.gd` (94),
`Godot/scripts/FightBodyCapsules.gd` (hand part only, l.20-125), `Godot/scripts/FightContactSolve.gd` (106),
`Godot/scripts/FightClipPoseLayer.gd` (107) + its data, `research/Q213G_DIGEST.md`. FightWorldLiveScreen.gd only
the call into the push (never read whole; `sed -n` around `_stop_posed_contact`).

## Gate (the one test)
`python Tools/c223_parallel.py production -- <gate args> report=q213g.json` per CLAUDE.md s6, plus the gate's clips mode
for the 3 moves with the glove arm: all 3 PASS on the glove row; 23 others unchanged or better; OFF-arm captures
byte-identical. Parse gate first. Then `python Godot/tools/run_tests.py --only glove,fight_body_overlap,q213,contact --jobs 2`.

## The one trap
A bigger hand sphere also pushes a LANDING punch off the head (a glove must touch, not hover): arm-vs-head keeps zero
skin (`PUSH_SKIN_M` applies arm-vs-arm only). Check a landed jab still reads contact on the head in the gate's fist band.
