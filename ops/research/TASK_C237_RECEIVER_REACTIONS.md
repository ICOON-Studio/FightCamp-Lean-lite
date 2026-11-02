# TASK C237 - the man who gets hit reacts like a boxer (animation, Codex - permanent animation seat)
Model: gpt-6-astra, medium. Owner: Codex. Worktree E:/FightCamp/wt/C237, branch codex/c237-receiver-reactions (from master).
Operator 2026-10-01, verbatim: "why in the videos the second fighter is still ?" and D29 "assign codex to constantly work
on animations (blender or cascadeur)". Queue: AgentComms/codex_animation_queue.md row 2.

## What is wrong
In the live room the receiver's reactions are thin: react_head#1 / react_body / react_leg are NOT certified (S138 live
record: `LIVE_CLIP react_head#1 ... not certified`), and between hits the second man reads frozen. Undisputed / Fight Night
Champion: head snaps back or to the side by the punch's direction and force, a body shot folds him, a hurt man stumbles
a step, then guard returns - and he keeps moving (weight shift, small steps) while the other man works.

## Do
1. Census: which reaction clips the live room plays (FightClipBinding react_* entries, FightStagePlayer receiver path),
   their sources, and why each is not certified (run the C223 production gate on them WITH `plant phase live_contact bound`).
2. Author or fix (Cascadeur: `python Tools/cascadeur/ensure_server.py`, Tools/cascadeur/*; or Blender 5.2.1 headless) a
   reaction set: head snap left/right/back (by punch side), body fold, a hurt stumble, guard recovery - each <= 0.8 s,
   blending back to guard idle.
3. Make the receiver never stand still while the attacker works (an idle with weight shift + small steps).
4. Video: a 20-30 s LIVE-ROOM recording (as_game, both men active, game camera, >= 1280x720, silent) via
   `Tools\godot_hidden.ps1 --path Godot --script tools/s119_live_record.gd -- as_game out=<E: dir> seconds=30 seed=92012`,
   encoded with imageio-ffmpeg -an -> previews/c237/live.mp4. The operator approves it before any clip
   enters certified_moves.json - do NOT edit certified_moves.json yourself.

## Owned files
`Godot/scripts/FightClipBinding.gd` (react_* entries), `Godot/scripts/FightStagePlayer.gd` (receiver path only - sed -n
windows), new clips under `Godot/assets/anim/c223/` (light: < 2 MB each), `Tools/cascadeur/c237_*`, `previews/
c237/*`, `previews/c223/c237_*.json`, `research/C237_DIGEST.md`.

## Prior research
R109 reactions, U159 reaction probe, C223 gate docs, `python Tools/prior_research.py reaction head snap receiver`.

## What would a human do?
An animator: reference footage of real head snaps and body folds, key the reaction, check it in the game camera.

## Prefab check
Our Mixamo/RamsterZ/CMU sources first (Godot/assets/anim/audition, mixamo_pipeline_a); Cascadeur for the rest.

## Tests
Parse gate; `python Godot/tools/run_tests.py --jobs 2 --only fight_clip,fight_stage_presenter,certified,clip_binding`;
the gate rows for the new clips. OPEN the frames of the video before calling it done.

## The one trap
Without `bound` the C223 gate measures its own legacy candidate, not the game's clip.

## Finish
git add by explicit path, commit, git push -u origin codex/c237-receiver-reactions. Never edit HANDOFF.md. Do not stop at written.
