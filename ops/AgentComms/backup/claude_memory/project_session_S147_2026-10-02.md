---
name: session-s147-2026-10-02
description: S147 - the CC-BY Sketchfab boxing glove is one closed mesh on both fighters (live-room stills), merged 946b12e0; credits screen + exe rebuild owed; Undisputed gloves are per-fighter skinned L/R meshes
metadata:
  type: project
---

S147 (Claude, Sonnet): GLOVES C241 run 4 DONE for boxing - master 946b12e0. One 1,950-tri mesh in metres, cuff band = vertex colour painted by a shader per fighter, left hand mirrors depth, FighterFist folds the thumb. Live-room stills docs/previews/c241/live/, MetaHuman checked (fronts clean; small thumb crease shows skin at grazing angles). Digest S147_DIGEST.md.

**Owed:** a credits SCREEN (CC BY: Incg5764, CREDITS.md/.txt are packed but not shown), exe rebuild, then M40 -> ECON1.
**Undisputed (installed, metadata only, R121 method):** separate L/R skinned glove meshes ~2,200 verts, 168-vert hand-wrap mesh, strap-driver bones, per-fighter default + DLC gloves; 2,699 named clips with motion matching.
**PC:** operator playing Breachway keeps CPU ~77-80 C (AMBER) and slows renders; MH2 Codex (pid 30692) still running at handover. See [[feedback-fit-the-render-not-a-vertex-dump]], [[project-session-s146-2026-10-02]].

**Late S147 (after ship):** HOME pins now open the 3D rooms (DayFeedPanel: Office->office_room, Staff room->staff_room, Gym floor->training_floor). Live fighters are TRIPO bodies (no finger bones): glove oriented from the hand bone + `hide_hand_meshes` cuts the hand under a closed boxing glove + roomier boxing_glove_tripo.glb; operator: "gloves look fine now" (roll 0 stays). Open defect: live `react_head#1` clip folds fighter A and flings his back leg up (fix next). Exe rebuilt 22:41 (Builds/FightCamp_Godot/FightCamp.exe, headless smoke ok). Rooms decision: [[rooms-25d-decision-2026-10-02]]. Codex MH2 still running ~3.5 h over ETA (operator may stop it).
