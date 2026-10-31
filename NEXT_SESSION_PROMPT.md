# S321 - next session (written S320, 2026-10-31)

Start: `git pull && python Tools/agent_comms.py start` in E:\FightCamp\Game, then work in E:\FightCamp\Lean.

Where it stands: update 23 exported (Lean 9a55d90, 37/37 tests): glide steps (no walking-stride clips; clip changes
167 -> 97/min), punches from outside their range step in (PunchRange.gd), body maps on each boxer's own baked portrait
at her own screen edge with live punch stats, round + result pages as pictures (RoundGraphics.gd), the habit fix says
what it did, smooth ropes. Digest: Game Godot/research/S320_DIGEST.md.

1. Board: Q-S294-35 (update 23), Q-S294-34 (in-round plan: aim the shout on the body map, Push/Steady/Save), Q-S294-32/33.
   He sends films and stills now: judge them with `tools/judge_film.gd` (movie writer, then ffmpeg to mp4) and
   `tools/fight3d_play.gd` (p08 = the round page).
2. Inside punches still land 0.15-0.22 m short of the face with PunchReach weight 1.0 (tools/hit_gap_probe.gd prints each
   far hit with its miss direction). Not GloveClear (exempted, no change). Log the striking glove before/after each
   modifier at the contact frame (ElbowClear, HitSnap) and the ShortPunch skip; fix that one cause.
3. Referee drifts between the boxers in quiet spells (S320 film ~1:10): Referee.gd keep-clear.

Traps: a png a tool rewrites needs `godot --headless --path . --import` again (the exe showed the old picture with the
new anchors); every new json the game reads goes in export_presets include_filter; probe the exe itself with
`Builds/FightCamp.exe --headless --script E:/FightCamp/Lean/tools/<probe>.gd`. Two Godot jobs at once are fine (operator
S320; heat stayed under 75 C).
