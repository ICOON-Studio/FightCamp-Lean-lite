---
name: project-session-s152-2026-10-03
description: "S152 - TRAIN1 merged as floor drawer MOVES tab, MH2 merged OFF on operator's look verdict, ROOMSUI1 part 4 (RoomClickMarks/RoomDrawer, film cut, HOME pins), MH3 + ROOMS2 launched"
metadata:
  node_type: memory
  type: project
  originSessionId: fc2fd7cb-cb9f-4aa2-9fca-3b9f7d60aa32
  modified: 2026-10-03T05:54:56.665Z
---

S152 (2026-10-03, Claude Opus): one stage, handed over at ~330k context.

- Operator on the MH2 video, verbatim: "the metahuman look better, the walking animation on them needs polishing".
  MH2 merged e8d454af with `metahuman_bodies` OFF (the branch defaulted ON in the game; only `-- metahuman_bodies=1`
  now). MH3 (Codex astra, wt E:/FightCamp/wt/MH3) polishes the walk + certifies: on MH bodies 306/356 C223 rows had
  join_discontinuity where MPFB has 0, so the fault is the MH retarget/fold/scale, not the clips.
- TRAIN1 (Cline) merged; picker made the floor drawer's MOVES tab. Two defects found by opening stills/reading code:
  skills with certified clips (catch, slip) previewed as NO MOTION (resolver short-circuit), and station pins did not
  follow camera pan.
- ROOMSUI1 part 4: shared helpers `RoomClickMarks.gd` (markers/hover, 8 rooms) and `RoomDrawer.gd` (front desk, mat);
  `room_screen_layout_test` is the ROOMSUI1 acceptance test. ROOMS2 (Cline, branch cline/rooms2) grows staff/physio/locker.
- Agent seats this day: Qwen, Cursor, Grok OUT of credits; Codex + Cline usable. Launch with CODEX_REPO/CODEX_MODEL/
  CODEX_ADD_DIR env through agent_window.ps1 worked first try (pid check via Win32_Process command lines).

**Why:** next session must collect MH3 + ROOMS2 (in flight) and not relaunch them.
**How to apply:** read research/S152_DIGEST.md "Next (decision)"; the walk video goes to the operator before the
switch goes ON. See [[project_session_S151_2026-10-03]], [[feedback_open_the_output_before_the_gate]].
