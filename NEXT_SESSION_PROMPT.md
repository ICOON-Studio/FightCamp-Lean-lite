# S361 - next session (written S360, 2026-11-02, after update 62)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean (branch `main`).
S360 (Lean 7749bec, c37006f): PLAYBOOK > Moves is a move book (tiers, pad-time bars, "11 of 27 ready"); Game plan writes the
plan as lines, each answer rated against the opponent's game as the bout scores it (Beats it / Works / Walks into it, +n),
picks save at once, hover plays, plan-edge bar, coach-locked lines, Test it vs the last test. Whiteboard: VS <OPPONENT>
goal line (WeekOpp; the coach's week misses it, 1-2 edits fix it, +3 prep edge in her-game exchanges), evenings as words,
Pads/Combo behind More in camp week 1. Digest: Game/Godot/research/S360_DIGEST.md. Stills on /review S360.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; probes at `--fixed-fps 30`; tests may
run beside ONE windowed render on GREEN; check Miro (https://miro.com/app/board/uXjVETf7la4=/) at start.
NEVER rewrite a .gd through PowerShell Get-Content/WriteAllText (it mangled "·" in S360): Edit tool or Python utf-8.

In order:
1. Collect Ziva TASK_ZIVAFOOT1 (Game/Godot/research/TASK_ZIVAFOOT1.md; branch ziva/footwork1 in E:\FightCamp\wt\ZIVA_LEAN;
   chat "Task Setup for Ziva Footwork 1" at 127.0.0.1:7012). Re-run tools/join_probe.gd yourself on its commit and on main;
   merge only within the brief's bounds; send him the film.
2. Q-S294-86 "Yes, build them": the week-review reveal, then she pushes back (her morale is the trust score, no new meter),
   then a fight poster per bout. Design each from real evidence, write the why, his OK on the verdict before building.
3. Belt road v3 in the Record tab (Q-S294-80 "Yes, build both"; evenings panel gone, no holo).
4. Split WeekBoard.gd (484 lines): THIS CAMP (_camp, _line_under, _pulse, _preview) into WeekCamp.gd.
5. Tips index cards on the top bar / gym and the T3 keyword sticky notes (J90 6c, 6g).
Q-S294-89 (SMOOTH3 A/B) waits on his look at smooth3_ab.mp4 (sent as a file S360).
