# S336 - next session (written S335, 2026-11-01)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.
S335 shipped update 37: the ground-move prototype (operator Q-S294-58 "Build the prototype now"). GrappleMap (public
domain, assets/grapplemap/) on two of our MetaHuman women: scripts/grapple/ GrappleMapDB (decode), GrapplePose (joints
-> bones, aim + roll per bone, then two-bone IK on wrists/ankles), GrapplePlayer (keyframes, 0.5 s a segment),
GrappleGraph (moves in/out per position from graph.json, built by tools/grapplemap_graph.py; align() lays the next move
on the pose on screen), GrappleBrowser (`-- jump=grapple`, `walk=N` films it). Digest: Game\Godot\research\S335_DIGEST.md.
Operator on the film: "the video looks amazing, can still be improved".

0. SPLIT (operator S335 "Yes, split it", after Claude proposed Cursor + a second Claude session over paying for a new
   agent): in the first minutes launch Cursor on Game/Godot/research/TASK_GROUND2A.md (body push-out, numeric gate;
   Tools/agent_window.ps1 + cursor_task.cmd, a Lean worktree under E:\FightCamp\wt) and start a second Claude session
   (start_session, own worktree) on TASK_GROUND2B.md (a speed per move). Land 2B first (both touch GrapplePlayer.gd).
   This session keeps (c) gripping hands and (d) MMA kit, and films and judges both branches before merging.
1. GROUND2, polish: (a) bodies sink into each other in mount / side control / back: push them out along the contact
   normal (capsule per bone, top body moves, joints keep their targets via the IK); (b) a speed per move instead of a
   flat SEGMENT_S, from keyframe distances (fast through small changes, Sekai clip lengths for reference);
   (c) curl the hands into grips (finger bones, MHRig.UE5_FINGERS) when a wrist is near the other body; (d) MMA kit:
   no boxing vest (it tears white under a raised arm), a rash guard or sports top in the corner colour. Re-film
   (`--fixed-fps 30 --write-movie ... -- walk=10`, ffmpeg to mp4), open a contact sheet, send + review_add.
2. Board: Q-S294-61 (boxing move map + whiteboard plan game + corner shouts on right/wrong moves + own combos,
   Game\Godot\research\STRIKEMAP_S335.md), Q-S294-59 (Dojo Legacy ideas), Q-S294-60 (younger faces), Q-S294-53 marks.
3. Judo/kickboxing (he asked): judo throws/takedowns are in GrappleMap (throw 16, single leg 42, double leg 27,
   standing 125). Kickboxing has no such data; it needs our own clips.
4. ANIMCLOUD1 (fight-stills CI) belongs to session local_c7e7549f: do not duplicate.
