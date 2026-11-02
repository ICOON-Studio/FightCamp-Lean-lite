# C137 - one synchronised two-fighter BJJ sequence, playing in FightCamp

COLLECTED 2026-09-20 by Claude (S29) from the `FightCamp-C134` worktree.
Codex's run produced the artefacts and then died before it could commit them:
its last mail (`d9fe77b07efd`, 19:35Z) says "blocked at Step 0", and the files
on disk are timestamped 19:46-19:49Z - **the mail is stale, the work is not.**
This is the fourth time an agent's own summary sentence has been wrong about
its own delivery; the artefacts are the record.

## What it is

The operator's own ask: ONE synchronised two-fighter BJJ sequence playing in
FightCamp, with a recording of actual in-game playback - not a Blender preview
and not a contact sheet of a source clip.

- `C137_RECORDING.mp4` - **166 frames, 30 fps, 5.53 s**, three phases.
  NOT COMMITTED: this repo tracks no video and has no LFS rule for one. It was
  sent to the operator on 2026-09-20 and the original is at
  `<C134 worktree>/research/C137_RECORDING.mp4`
  (sha256 `8e71fa95...4012ed9c`, recorded in the measurements file).
- `C137_FOUR_ANGLES.jpg` - the same beat (`grapple_sweep`, t=2.77 s) from four
  cameras, which is what makes a pair judgeable: a sequence that reads as
  contact from one angle and as two men in separate rooms from another is not
  synchronised, it is framed.
- `C137_MEASUREMENTS.json` - the numbers below.

## The numbers, and what they do NOT say

| quantity | value |
| --- | --- |
| max pair clock drift | **0.000 s** |
| phase 0 (0.00-1.67 s, 51 f) | largest landmark step 0.00087 m; hips net 0.000 / 0.000 m |
| phase 1 (1.70-3.50 s, 55 f) | largest landmark step 0.501 m (actor 0 LeftHand); hips net 0.592 / 0.586 m |
| phase 2 (3.53-5.50 s, 60 f) | largest landmark step 0.036 m; hips net 0.132 / 0.128 m, settled 0.000 / 0.000 m |

**The two men travel together**: 0.592 m against 0.586 m of hip displacement
through the throw phase is a 6 mm difference over half a metre, and the clock
drift is exactly zero. That is the synchronisation claim, and it is met.

**It is NOT the contact claim, and Codex says so in its own status field:**
`"UNFINISHED - numerical measurements do not certify contact"`. A 0.501 m
single-frame hand step in phase 1 is the sweep's own snap, but nothing here
measures glove-to-gi distance, forearm clearance or interpenetration - the
three things every previous paired-asset gate has passed while looking wrong.
**Read the four angles before believing the table.** This is the S4a lesson
applied to a delivery instead of to a gate: open the output.

## Gates Codex ran

- `--only c134` 5/0
- `--only clip` 9/0
- `--only pair` 7/1 - `fight_pair_live_test` is **PARKED ON PURPOSE** by the
  operator's 2026-09-15 ruling (the authored jab pair is unvalidated, not
  disproved). It is a baseline red, not a C137 regression.

## What is owed

The operator's eye. The sequence plays and the pair holds one clock; whether
it looks like two men grappling is not a number this project can produce, and
it is the same verdict `S4e-room-verdict` has been waiting on.

## THE OPERATOR'S VERDICT, 2026-09-20 - AND IT IS THE FIRST POSITIVE ONE

Verbatim, on the recording above: **"this is pretty good ! need more movements"**.

This is a ruling and it settles two things.

**ACCEPTED.** The paired sequence itself is good enough. Do NOT spend another
session polishing this one chain's contact - C134's four pose iterations, the
forearm clearance, the wrist contact and the torso pressure are all below the
bar the operator actually set. The S4e-room-verdict wait and the 2026-09-14
foot-lock verdict ("no visible difference") were both negative; this is the
first paired-asset verdict that is not, and it was given on ONE chain played in
the game rather than on a clip in isolation - which is exactly the fair
comparison the 2026-09-15 withdrawal asked for.

**WHAT IS NOW OWED: MORE MOVEMENTS.** The gap is breadth, not fidelity. The
BJJ route currently plays one chain (`Paired_FullMount_Takedown_BodyLock_Loop`
-> `Reversal` -> `BodyLock_End`). The named holes are already on record in
`C134_BJJ_PRESENTATION.md` and S6c's ruling: **side control, guard, half guard,
back control and the clinch have no paired film at all**, and `mma_dirty_boxing`
was refused on POSITION because every paired film we own is two men on the
canvas while `cage_clinch` is two men upright. R144 lines 1 and 2 are the
shopping for exactly those, they are PC-only, and this machine is the PC.

So the next BJJ slice is a BINDING-AND-BREADTH slice, not a contact slice.

## AND THE SECOND HALF OF THE RULING: FOUR CAMERAS, 2026-09-20

Verbatim: **"we can use 4 cameras like in the video for the fight coverage if
that helps with camouflaging animations"**.

The video they are answering is `C137_FOUR_ANGLES.jpg` - the same beat from four
cameras, which C134 rendered as EVIDENCE and the operator has just read as a
PRODUCT idea. It is a real broadcast technique and it extends S7's standing
ruling (OPTION C, constrain the camera) rather than contradicting it.

**THREE THINGS IT DOES NOT FIX, SAID NOW RATHER THAN DISCOVERED LATER.**

1. **The 180-degree line still binds, and the C137 sheet breaks it.** S7's
   ruling is "stay one side of the fight line, a hard cam by default". Four
   cameras is four cameras ON ONE SIDE; the quad sheet's top-right view is from
   the far side, which is the shot that makes a viewer think the men swapped
   corners. Four cameras is a cut list, not a licence to cross.
2. **A cut cannot hide a join it lands in the middle of.** The room's median
   beat is **0.30 s** (`probe_counter_budget.gd`, 7,546 scheduled entries), and a
   cut needs a beat to breathe on either side of it. Cutting at 0.30 s is a
   strobe, not coverage. So the camera can hide a weak MOMENT and cannot hide a
   weak RATE of moments - which is the same thing S14 found when a 1.503 s
   slip-cross chain would not fit the beat.
3. **It hides, it does not fix.** Worth having anyway: hiding the worst frames
   of an asset we own is cheaper than buying a better one, and it is the
   standard answer in every sports game. But it must not be spent as a reason to
   stop improving the assets - C134's armbar root cause (retargeting discards
   1.020 m X and 0.844 m Z of attacker hip travel) is not a framing problem.

**WHERE IT GOES.** S7 (constrain the camera) already owns the shot grammar and
`FightCameraRig.SHOTS` is Q55 verbatim, sized against a 1.6 m GROUND pair - so
the standing shots are still missing and that is still M20's brief, still an
attachment in a chat. This ruling adds a CUT LIST to that slice: four fixed
cameras, all one side of the line, cutting on exchange boundaries rather than
on a clock.
