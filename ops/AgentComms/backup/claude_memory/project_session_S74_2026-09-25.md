---
name: project-session-s74-2026-09-25
description: S74 - playable .exe shipped and walked in the exe; career fights in the 3D arena; 2D fight picture banned; fictional names + swap file; SIM THE FIGHT; readiness audit
metadata:
  node_type: memory
  type: project
  originSessionId: 6ea6c998-ea6a-4ee7-8278-a27838bf80cb
  modified: 2026-09-25T04:20:14.346Z
---

S74 (2026-09-25), the operator-as-playtester stage ([[feedback-operator-is-the-playtester]]).

- Build: `python Tools/build_playable.py` -> Builds/FightCamp_Godot (Godot runtime exe + same-named .pck, no export templates; raw .glb/.fbx beside the exe because the runtime reads them through GLTFDocument - `scripts/RawAsset.gd`). Walk the EXE, not the dev tree: `FIGHTCAMP_GODOT_EXE=<exe> Tools/godot_hidden.ps1 --script <abs path>/s64_career_walk.gd -- plan=<abs> out=<abs>`.
- Operator rulings (verbatim in roadmap): the 2D fight picture is banned for ever (banned_2d_fight_picture_test); every fight in the 3D arena; mic corner calls with crowd noise as a settings option (research first, Dola D18); defender = block/dodge/between + anticipate + counter (J50 -> U172).
- The operator had never seen the 3D arena in the career: it was a dev-only route all along and S64 had noted it without fixing. Watch for "known, listed, not fixed" on anything the player sees.
- Names: shipped data fictional; real names/histories/12 photos in research/names_real (never exported); GameState overlays names_real.json from user:// or beside the exe.
- Traps found: no world athlete carries `turned_pro` (every star was amateur-eligible); a boxer's competition weight came from the MMA table and is the engine's body mass; offer ids with `|` inside the org id.
- Agent deliveries that did NOT merge: U171 p2 A/B recordings byte-identical (md5 every A/B); C199 p3b loaded the BUDDI prior against the licence bar; Q172 a rate fit (share right, time wrong).
- Suite 406 raw fails=15 -> real 9 (the S73 nine).

**Why:** the operator plays; the suite had passed a first-booking dead end and a picture he never wanted.
**How to apply:** S75 opens with his playtest report, then phase 0 and the booking model (G96). Re-walk in the exe every stage.
