# S362 - next session (written S361, 2026-11-02, after update 63)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean (branch `main`).
S361 (Lean 5015885, e7f3440, 64ad09b): Q-S294-86 built whole - the week review lands its rows one by one and the week's
surprise last (ReviewReveal); her own asks replace the twist card some weeks (PushBack, WeekTwist.ASKS, heard/overruled);
morale is now trust in the fight (FighterProfile.trust x Exchanges.uptake in LiveRound - before S361 NOTHING read morale);
a halftone fight poster per bout on Home (FightPoster). Digest: Game/Godot/research/S361_DIGEST.md. Stills on /review S361.
OPERATOR RULES: no his/her in game text; agents do animations, Claude mechanics + UI; probes at `--fixed-fps 30`; tests may
run beside ONE windowed render on GREEN; check Miro (https://miro.com/app/board/uXjVETf7la4=/) at start.
NEVER rewrite a .gd through PowerShell Get-Content/WriteAllText: Edit tool or Python utf-8.

In order:
1. Collect Ziva TASK_ZIVAFOOT1 (Game/Godot/research/TASK_ZIVAFOOT1.md; branch ziva/footwork1 in E:\FightCamp\wt\ZIVA_LEAN;
   chat at 127.0.0.1:7012). S361: its scratch _join_dbg.gd hung (await p.ready after add_child) and was killed by PID;
   if it is stuck again, tell it why. Re-run tools/join_probe.gd yourself on its commit and on main; merge only within
   the brief's bounds; send him the film.
2. Split WeekBoard.gd (490 lines, cap 500): THIS CAMP (_camp, _line_under, _pulse, _preview) into WeekCamp.gd.
3. Belt road v3 in the Record tab (Q-S294-80 "Yes, build both"; evenings panel gone, no holo).
4. Tips index cards on the top bar / gym and the T3 keyword sticky notes (J90 6c, 6g).
5. Move the Miro production map cards (S361 skipped it at hand-over).
Q-S294-89 (SMOOTH3 A/B) waits on his look at smooth3_ab.mp4.
