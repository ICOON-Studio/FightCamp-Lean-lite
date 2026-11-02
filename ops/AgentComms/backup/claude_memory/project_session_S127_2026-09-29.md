---
name: project_session_S127_2026-09-29
description: S127 - demo palette = certified moves (D27), .exe built + walked IN the exe 83/0, result round/clock fixed on the real path, rules to one page
metadata:
  type: project
---

S127 (2026-09-29, same session as S126 - two stages). Digest research/S127_DIGEST.md.
- D27 palette: assets/data/certified_moves.json + FightMoves.restrict_to_certified + switch `certified_palette` in DEMO_SWITCHES.
  Feints (invisible in the room) and movement-only steps (locomotion) are KEPT - filtering them froze the feet. KO+TKO 37.5%
  under the palette vs 44.2% off (no head hooks yet).
- The EXPORTED exe can be walked: `FIGHTCAMP_GODOT_EXE=<Builds/FightCamp_Godot/FightCamp_console.exe>` + godot_hidden.ps1
  `--main-pack <pck> --script <abs path>/Godot/tools/s64_career_walk.gd -- plan=<abs> out=<abs> as_game`. 83/0.
- Trap repeated: a unit test on a synthetic dict passed while the exe still showed the bug - `payload_from_sim` dropped the fields.
  The fix is proven only when a REAL engine result goes through the real payload function ([[feedback_assert_the_quantity_the_user_sees]]).
- Rules: CLAUDE.md one page; `start` compact (`--full` for all); MEMORY.md 135 via group memories [[feedback_rules_now_in_claude_md]],
  [[reference_agent_notes]]. The operator asked "do you have all these?" about 11 skill folders (3d-production-routing,
  blender-game-animation, ffmpeg, img2threejs...) - none installed; they would go in ~/.claude/skills/<name>/SKILL.md.
- A stray file C:\Program Files\Git\tmp_s127_panel_old.gd (my redirect to "/") - removal blocked by the safety check; operator to delete.
- Later: U198 merged (overlap 1.8 mm), lead_uppercut certified (palette 15), Tools/c223_parallel.py (156 s -> 44 s, identical
  rows). Compute answer: the PC was waiting (CPU 4-12%), not maxed - parallelise first, mini PC (Beelink SER8 ~00-800) or GPU
  rental only if needed. QuickMagic subscribed ([[reference_quickmagic]]).
- S128 (same session): QuickMagic text-to-motion check hook (in band after warp, floats 12 cm). REACH: implemented per fighter
  (TaleOfTape height by class, reach = height -6..+10) and used by the engine, but a 22 cm edge moves wins ~4 points vs the sourced
  ~+10-24 (J33) - RC1 calibrate, RC2 arms follow reach in 3D. Operator: "i want the reach to play an active role on the fight".
