# ROUND 3 (S343, Claude rendered round 2 (646db61) on a real GPU - read this first; it overrides the text below)

Round 2's probe printed `PAD CONTACT 3/3`, but the VISUAL GATE FAILED on its own stills, committed as the red on main:
docs/playtest/padwork_red/S343_r2_first_contact.png and S343_r2_last_contact.png.
1. THE PROBE MEASURED THE WRONG FRAME: the hook's line printed the jab's exact glove position (-0.044, 1.470, 0.451) and
   the last-contact still shows her hook back at her face, 0.4 m off the mitt. Sample EACH punch at ITS OWN contact frame
   (the clip's contact_s from assets/data/clip_contact.json, counted from the moment THAT clip starts) and print the frame
   time with it: `PAD <i> <move> t=<s> glove=<pos> mitt=<pos> gap=<m>`. A test that a fake can pass is no test: the mitt
   must be placed by the coach's arm BEFORE the contact frame (from the combo's target list), never moved to wherever her
   glove ends up - print `PAD <i> mitt_set_at=<s>` < contact time.
2. BARE FEET: she trains in boxing boots (operator S263: bare feet in a boxing still = FAIL), the coach in trainers.
   Dress her the way the fight does (`scripts/fight3d/BoxerBuild.gd` / `FighterKit.dress`), boots included.
3. GREY BOXES FOR MITTS: build a real focus-mitt shape - a rounded, slightly cupped pad (about 0.24 x 0.20 x 0.07 m, black
   leather with a red or white centre circle) on the coach's hand, palm side to her, from code (ArrayMesh / CSG), no box.
4. NEAR-BLACK ROOM: a soft key light + fill like the gym's (`MovePlayer.gd` _build_room is a fine pattern), so faces read.
5. Frame head to feet with a margin (both bodies' Head and LeftFoot/RightFoot bones inside the frame with 4 % to spare).
PASS: `PAD CONTACT 3/3` measured as in 1, `PADSTILL bodies 2 head to feet`, and Claude's own render on Windows shows each
glove on its mitt at its contact, boots on, the mitt a mitt.
# TASK_PADWORK1 - pad work: the coach holds the mitts, the boxer throws the combo she drills (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo). Operator Q-S294-61 "Yes, in
that order" (step 3: "the clips on the Training page (coach with pads + boxer)"); S338 "keep all agents working on animations".

## Why
A combination is learned with pad time (Combos.LEARN_AT 30). Today the Training page shows it as a dropdown only. Real pad
work is the picture of that: the coach stands square in front, calls the combo and SHOWS each target with a mitt; the boxer
throws into it and the mitt meets the glove ("pop"). StrikeMap's move ids -> clips are in `scripts/fight3d/MoveClips.gd`;
Combos.row(id)["beats"] lists a combo's punches.

## The red probe (write it first; it must read red on main)
NEW `tools/padwork_probe.gd` (SceneTree, `-- combo=<id> show3d`): builds PadWork, plays the combo once, and for every punch
prints `PAD <i> <move> gap <m> at contact` = the distance from the punching glove's centre to the mitt's centre at the
clip's contact time (assets/data/clip_contact.json, as BeatClips reads it), then `PAD CONTACT <n>/<total>` counting gaps
<= 0.10 m. On main it cannot load PadWork -> red. PASS: `PAD CONTACT 3/3` for `combo=1-2-3` and `PAD CONTACT 2/2` for `1-2`.

## Owned files (edit only these)
- NEW `scripts/fight3d/PadWork.gd` (Node3D, < 300 lines): `build(boxer_glb, coach_glb)`, `play(combo_id, loops)`,
  signal `done`. Boxer and coach face each other at the long-range gap (StrikeMap card "long" range_m middle); the coach's
  body is CornerCrew's coach body (reuse its body loader - read `CornerCrew._body`, do not copy CornerCrew); his hands
  carry the mitts and are placed with `CornerIK.reach` (scripts/fight3d/CornerIK.gd) at the point each punch aims for,
  raised EASE before the punch, a short "pop" back (0.04-0.06 m along the punch line, ~0.1 s) at contact, then the next.
  The boxer's clips: MoveClips / FightClips as the fight plays them (lead hand = left, orthodox). Between punches the
  boxer returns to guard through the JoinSmoother the fight uses.
- NEW `scripts/fight3d/Mitts.gd` (< 120 lines): a procedural focus mitt (rounded pad face ~0.22 x 0.18 m, 0.06 m thick,
  black/red, StandardMaterial3D) attached to a hand bone like Gloves.gd attaches gloves.
- NEW `tools/padwork_probe.gd` (above), NEW `tools/padwork_still.gd` (guard / first contact / last contact stills on a
  plain gym-floor backdrop, 1920x1080, saved under `docs/playtest/padwork/`).
- NEW `scenes/PadWork.tscn` only if you need one.
DO NOT EDIT: anything under scripts/ui (Claude wires the Training page button after merge), JoinSmoother.gd, GloveClear.gd,
PunchReach.gd, BeatClips.gd, FightStage.gd, RingPlace.gd, ExchangeBeats.gd (other seats hold them).

## Guard rails (must stay green)
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` - 0 failures.
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/glove_height_check.gd` -> `GLOVE HIGH 0:`.

## Evidence
Your PR runs `.github/workflows/fight-stills.yml` (stills + probe numbers as a PR comment). Add your padwork_probe and
padwork_still runs to the report; the how-to for a windowed run on the runner is `.github/CLOUD_AGENT.md` "Fight animation
tasks" (xvfb, `fastdraw`, `-- show3d`). GitHub Actions cannot open PRs on this repo right now: push the branch
`goose/padwork1` and say so; Claude opens the PR.

## Prior research
STRIKEMAP_S335.md s3 (the training tab plays the move on two bodies, coach on pads + boxer); S256 mitt pop (old project:
the mitt moves back into the punch at contact); CornerIK (S307, two-bone arm IK for the coach's hands).

## What would a human do?
A pad man holds the mitts at the boxer's shoulder height, shows the target a beat before each punch (jab: lead mitt at
her nose line; cross: the other mitt turned in; hook: the mitt turned sideways at her temple height), and "pops" each
mitt a few centimetres into the punch so it lands crisp. He stays square and moves with her.

## Prefab check
No free licensed focus-mitt model in the project; a procedural pad is a few meshes (like Gloves.gd). The boxer clips are
MoCap Online Punch PRO (private repo - never copy them anywhere else); the coach body is our MetaHuman coach.

## The one trap
Never move the boxer's punch to the mitt (that bends her clip): the mitt goes to where her glove arrives. And the coach is
NOT a second boxer - no boxer clips on him; his arms are IK on his idle.

## Report
`RESULT: tools/padwork_probe.gd -> PAD CONTACT 3/3` (combo=1-2-3) and `PAD CONTACT 2/2` (1-2), each `PAD <i>` line, the
still paths, the run_tests.sh summary and `GLOVE HIGH 0:`.

## ROUND 2 (S340, Claude's check of goose/issue-13 39cd654 - read this first)
1. The still is EMPTY: Claude rendered tools/padwork_still.gd on a real GPU (Windows, hidden desktop) - padwork_1_2_3_first_contact
   shows a dark backdrop and a floor corner, no boxer, no coach. Frame both bodies head to feet, side-on, ~3.5 m back, chest
   height, looking at the pair's middle; print `PADSTILL bodies 2 in frame` (both pelvis and head bones project inside the
   viewport) before saving, `PADSTILL FAIL` otherwise.
2. Every gap reads exactly 0.040 m (5/5 punches): the probe measures the mitt where PadWork put it, not the boxer's real glove.
   Measure the REAL glove: the glove mesh node's global position after the skeleton updates that frame (Gloves.gd attaches it;
   FightStage.glove_front reads it) against the mitt face node's global position, in a windowed run (`-- show3d`, xvfb +
   `fastdraw`, CLOUD_AGENT.md). Print per punch `PAD <i> <move> glove-mitt <m> (glove at <x,y,z>, mitt at <x,y,z>)`. The
   numbers must differ punch to punch; identical gaps = still measuring yourself.
3. Commit the new stills (docs/playtest/padwork/) only when PADSTILL says both bodies are in frame.
New RESULT lines: `PADSTILL bodies 2 in frame` (x3) and `PAD CONTACT 3/3` / `2/2` from the real-glove measure.
