# S358 - next session (written S357, 2026-11-02, after update 60)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean (branch `main`).
S357 shipped update 60 (Lean 58d270b..1151fa4): the short-notice swap twist card (rare; take a tougher opponent the same
night - the tape restarts, a win counts twice - or withdraw and end the camp), the whiteboard hover names the card a twist
replaced, and the ops board's "Test: a camp on the whiteboard" (jump=camp). Suite 102/102, build exported.
Digest: Game/Godot/research/S357_DIGEST.md.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; probes at `--fixed-fps 30`; tests may
run beside ONE windowed render on GREEN; tool updates without asking. He designs through MIRO
(https://miro.com/app/board/uXjVETf7la4=/, now a paid plan): check new frames/stickies at session start.

1. Collect Ziva's SMOOTH3 round 4 (wt/ZIVA_LEAN ziva/smooth3-r4 after 36f80cc; chat "Fixing PunchReach Continuity Issues"
   at http://127.0.0.1:7012/). S357 sent it back: measure plain/noreachin/noreachout/nolean/nofade/noreach on ONE commit,
   inside_guard on main too, a fresh hit_gap line. Read its numbers against the bounds yourself (it called 8 glove-in-head
   frames a PASS; bound <= 4 or no worse than main). Bounds: OURS <= 250/min, <= 110 at a clip change, hit_gap > 0.15 m no
   worse. Merge PunchReach.gd by diff only if met; never its project.godot.
2. Q-S294-86 (Miro top 5): if yes, build the week-review reveal first (rows one at a time, the biggest surprise last), then
   she pushes back (her morale is the trust score), then a fight poster per bout (art seat).
3. Q-S294-78/80 (belt road): if answered, build v3 (Record tab, no holo) + the pull from the S356 prompt (a belt goal,
   a BJJ evening class at brown/black, IBJJF belt divisions).
4. Kalli's whiteboard review (SQ25 -> Game/Godot/research/KALLI_WHITEBOARD_S357.md): act on it.
5. Q-S294-87 outside testers; Q-S294-84/85 if answered.
Lesson: play a new mechanic through on the hidden desktop (tools/s357_stills.gd) - it caught two bugs the tests missed.
