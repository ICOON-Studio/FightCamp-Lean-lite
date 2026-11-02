# TASK U186 - CURSOR - THE FEET CARRY THE BODY: PIN THE PLANTED FOOT, LET THE STEP MOVE THE MAN (S90, after U185)
Owner: cursor. Assigned 2026-09-26. Model: composer-2.5 (Cursor pool), normal effort.
Branch: `cursor/u186-feet-carry`, cut from YOUR `cursor/u185-planted-slide` (c0b8ba95) in Temp/FightCamp-U171.
Do NOT merge master into it; Claude merges. Operator: use Cursor until its quota runs out - if you hit the limit
mid-task, COMMIT AND PUSH what you have with a digest that says where you stopped.

## Why
Your U185 instrument is good (the drag-root mutant reads worse - it moves) and it showed the truth: planted-foot slide
p95 BEFORE 0.573 -> AFTER 0.645 m/s, worse. Your own diagnosis: "idle-bound footwork still drives root travel while
clip toes are static - planted locks fight animated drift until steps fire". So the body GLIDES and the feet chase it.
And the kneel: foot-lock IK bends corner b's LeftKnee to the canvas on `boxing_step_in_out` (idle take, ~2.35-2.43 s);
your knee floor guard in `_bend_leg` did not clear the gym probe ("many violations").

## What would a human do?
A locomotion animator never lets the pelvis glide over pinned feet: the ROOT MOVES BECAUSE A FOOT STEPS. In a boxer's
step-drag the lead foot steps (swing), weight transfers, the body arrives over it, then the rear foot drags up. While a
foot is planted its world position is FIXED - zero slide by construction, not by a spring catching up. Game studios do
this with root motion / stride warping: travel is spent through steps, never applied to a body standing still.

## Do
1. On boxing footwork beats (the U183 idle binding), make the engine's travel feed the STEP, not the pelvis: accumulate
   the wanted root displacement; the displayed pelvis moves only while a foot is in swing (and during the drag), so the
   planted foot is pinned exactly (lock target frozen in world, no spring). The engine's POSITION is the truth - the
   visual may lag it by at most one step length and must catch up within the step (print the max visual-vs-engine lag).
2. Re-measure with `tools/u185_planted_slide.gd`: BEFORE / AFTER / drag-root mutant, same seed 94301, both men.
3. The kneel. First CHECK THE UNITS: our fighter rigs are NOT in metres (Tripo exports at a different scale; the
   training floor lifts bodies 0.925 m) - a 0.25 m knee floor measured in rig units is not 0.25 m. State the frame and
   scale your probe reads, then make the gym-spar probe pass: no knee lower than 0.25 m above the canvas (world metres)
   on idle/footwork beats, or report with evidence why the IK must be refused instead.

## Owned files
`Godot/scripts/FightStepPlanner.gd`, `Godot/tests/fight_step_planner_test.gd`, `Godot/scripts/FightStagePlayer.gd`
(the lock/step/`_bend_leg` sections only - about 4,500 lines, NEVER open it whole; sed -n windows around
`busy_technique`, `set_foot_lock`, `foot_lock_stats`, `_bend_leg` and your U184/U185 hooks), `Godot/tools/u18[4-6]_*.gd`,
`research/U186_DIGEST.md`, `previews/u186/`.

## Gate (a CEILING - over-deliver and say so)
- Planted-foot slide p95 on footwork beats: AFTER <= 50% of BEFORE (<= 0.287 m/s), printed beside BEFORE and the
  drag-root mutant (which must still read worse than BEFORE).
- Max visual-vs-engine lag printed, <= one step length (JUDGEMENT: 0.35 m).
- Gym-spar kneel probe: 0 knees below 0.25 m (world metres) on idle/footwork beats, frame + scale stated.
- U183 gate still true (foot <= 0.10 m, knee rise <= 0.12 m on the nine boxing footwork rows).
- `fight_step_planner_test` (+ its mutants red), `fight_foot_lock_test`, `fight_leg_ik_test`,
  `boxing_footwork_clearance_test`, `spar_watch_test`, `fight_stage_walk_test`: 0 failures, run one by one.
- Re-render the gym spar (hidden) and LOOK at it: `docs/previews/u186/`.

## Tier
Script edited: parse gate (`python Godot/tools/check_scripts.py <touched .gd>`), then the focused tests one by one.
No full suite. Every windowed Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.

## Research
All research is open: root `RESEARCH_INDEX.md` (U92, U93, C116, U183, U184, U185). Do NOT read HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md, and do not explore to "get oriented".

## Done
Commit (explicit paths), push the branch, write `research/U186_DIGEST.md` (the table, the lag, the kneel with
units, the render), then
`python Tools/agent_comms.py send --from cursor --to claude --topic U186 --body "<slide p95 before->after, lag, kneel>"`.

## The trap
Tuning the spring or the unplant radius again. The slide is structural: a planted foot under a gliding pelvis will
always slide or stretch. Stop the glide, and the slide goes with it.
