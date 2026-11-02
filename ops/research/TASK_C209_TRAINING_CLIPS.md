# TASK C209 - CODEX - THE FIRST THREE TRAINING CLIPS (heavy bag, skipping, shadowboxing)
Owner: codex. Assigned S81, 2026-09-26. Model: gpt-6-astra, MEDIUM (3D animation), CODEX_WEB off. Branch:
`codex/c209-training-clips`. Why: `S81_HUB_DISPLAY_SYNTHESIS.md` decided the GYM FLOOR becomes our 3D engine with the
player's fighters on their stations - and your own C208 plus Qwen's Q179 measured **0 training clips on disk against 18
stations**. This task makes the first three. No floor scene yet.

## What would a human do?
A game animator making a gym loop does not animate a fight move and hope. He (1) shoots or buys reference of the real
drill - a boxer on a heavy bag works in 3-5 punch bursts with a reset step, circles the bag, and keeps a slight lean;
skipping is a light bounce on the balls of the feet, rope turned from the wrists, elbows tucked; shadowboxing is guard
up, combinations, slips and steps, never a static stance; (2) authors or captures ONE clean cycle; (3) makes the loop
seamless - first and last frame match in pose AND velocity; (4) checks it IN PLACE against the prop at game camera
distance: glove meets bag surface, feet do not slide, the rope clears the feet. Do that, in that order.

## The route (already proven by you in C207)
`Godot/assets/anim/c207/generate_walk.py` + `receipt.json`: Higgsfield text-to-motion (kimodo, `ardy-core`), ~0.1 credit a
job, ONE body per clip - which is what a solo training drill is. Then the existing `FightClipRetarget` silhouette + hip
path, exactly as C207 did (GLB, not FBX - you found the FBX axis/unit trap). Budget: **at most 3 credits in total**,
booked through `Tools/higgsfield/budget.py` like C207 (well inside the 150 you may spend without asking).
Prompts must describe the drill a coach would recognise (see above) and say "in place".

## Deliverables (owned files)
- `Godot/assets/anim/c209/` - per clip: the GLB, the prompt + receipt, a README line (what, seed, seconds, loop frames).
- `Godot/tools/c209_training_audition.gd` - renders each clip on one real fighter rig at a station: a heavy bag (a
  simple capsule prop is fine), open floor for skipping (a thin torus/line for the rope is optional), open floor for
  shadowboxing. Fixed elevated camera like C208's probe.
- `previews/c209/` - one short MP4 per clip + a contact sheet. Look at every one before you commit.
- `research/C209_DIGEST.md` - the numbers below, the stills, the honest limits.

## Measure, do not describe
For each clip, printed by your tool: loop seam error (pose + root velocity, first vs last frame); planted-foot slip p95
(the C207 method); for the bag clip, glove-to-bag-surface distance at each strike's peak. A number no tool printed is
marked ESTIMATE.

## Tier
No shipped script in `Godot/scripts/` is edited. Parse gate on your new tool: `python Godot/tools/check_scripts.py
Godot/tools/c209_training_audition.gd`. No test suite. Every windowed Godot run goes through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.
**The full test suite starts at 04:00 on this PC: start no Godot process after 03:40 local time.** If you are not done by
then, commit what you have with a note of what is left, push, and stop.

## Done
Commit on `codex/c209-training-clips`, push, then
`python Tools/agent_comms.py send --from codex --to claude --topic C209 --body "<one line: clips made, seam + slip numbers, credits spent>"`.
Do not edit HANDOFF.md.

## The trap
A fight idle or a jab clip looped in front of a bag is NOT a bag drill - the synthesis forbids a fight motion pretending to
train. If the generator will not produce a recognisable drill in two tries per clip, stop that clip and report it; do not
dress up a fight clip.
