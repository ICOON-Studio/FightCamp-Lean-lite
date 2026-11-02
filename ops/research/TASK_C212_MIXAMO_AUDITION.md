# TASK C212 - CODEX - AUDITION FOUR MIXAMO TRAINING CLIPS ON OUR FIGHTER
Owner: codex. Assigned S82, 2026-09-26 (operator: "try mixamo for animations as an alternative").
Model: `gpt-6-astra` at MEDIUM (`CODEX_MODEL=gpt-6-astra`), `CODEX_WEB=live`. Branch `codex/c212-mixamo-audition`.

## Why
C210 (`research/C210_DRILL_MOTION_SOURCES.md`) found NO owned training motion and named Mixamo as the $0 first
audition per gym drill. The operator approved the download; four clips are now in
`Godot/assets/anim/mixamo_audition/` (FBX Binary, without skin, 30 fps, Mixamo `mixamorig:` skeleton):
`punching_bag.fbx` (heavy bag), `jumping_rope.fbx` (skipping), `boxing_warm_up.fbx` (shadowboxing),
`speedbag.fbx` (speed bag). Manifest status `candidate` (`mixamo_training_audition`).
C209's text-to-motion takes all failed review (bag walked through the bag, shadowboxing wandered, skipping slipped).

## What would a human do?
An animator auditioning library clips for a gym scene retargets each onto the production rig, loops it in place, puts
the PROP where the clip expects it (bag at the hands, speed bag at head height, rope clearance), and watches the loop
from the game camera. They reject a clip whose hands miss the prop, whose feet slide, or whose loop pops - and they say
what editing would rescue it before calling it dead.

## The work
1. Retarget each clip onto the f01 reference rig per `research/C200_RIG_SPEC.md` (22 named bones, metres, +Y up,
   +Z forward). Map `mixamorig:` bones explicitly; do NOT rename-and-call-it-admitted. Handle the Mixamo hip/root:
   an in-place station loop needs root translation removed or measured.
2. Measure per clip, on the retargeted f01: duration, loop seam (pose + root-velocity difference first vs last frame),
   foot slip (contact-foot speed p95, m/s), root drift over one loop (m), and for the bag/speed bag clips the hand path
   relative to where a prop would sit (distance from fist to a bag cylinder you place at the clip's own strike point).
3. Render each as a short MP4 + one contact sheet from a fixed gym-camera angle with a simple prop stand-in (cylinder
   bag, small speed bag, no rope needed), through `Tools\godot_hidden.ps1` (never a visible window). Open the renders
   yourself before reporting.
4. Verdict per clip: USABLE AS-IS / USABLE WITH EDIT (name the edit: trim, loop blend, root lock, IK hand to prop) /
   REJECT (why). Compare against C209's numbers.

## Owned files
`Godot/tools/c212_mixamo_audition.gd` (or a Blender script if the retarget needs it - Blender 5.2.1 is on the PC),
retargeted outputs under `Godot/assets/anim/mixamo_audition/retargeted/`, renders under
`previews/c212/`, `research/C212_DIGEST.md`. Do not bind anything into the game and do not change the
manifest status.

## Tier
Parse gate on the tool; no test suite (nothing in the game changes). Renders only through `Tools\godot_hidden.ps1`.
Commit after each clip - an honest partial beats an uncommitted whole.

## Research
Open to all: root `RESEARCH_INDEX.md` (C200, C209, C210, R94 retarget notes, `project_fighter_rigs_are_not_in_metres`
- Tripo rigs are not in metres). Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch,
`python Tools/agent_comms.py send --from codex --to claude --topic C212 --body "<per clip: verdict, slip p95, seam, drift>"`.

## The trap
Mixamo clips are authored on X Bot's proportions; a punch that lands on X Bot's bag can miss by 10 cm on f01. Place the
prop from the RETARGETED hand path, not from the Mixamo preview.
