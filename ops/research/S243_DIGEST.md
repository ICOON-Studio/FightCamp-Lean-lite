# S243 DIGEST (2026-10-17) - ISOWALL1 shipped (iso view turns, cutaway walls); Two Point Museum studied; PLACEMENT1 verdict on the board

## Operator rulings this session (verbatim)
- "i also want the placement to be similar to 2point games and similar games" -> PLACEMENT1 verdict, board Q-S242-1 (attached doc).
- "there is 2point museum installed if you want to reverse engineer things and use in our game" / "there are tools to help you
  decompile , we are not copying anything do it" -> studied from his install with UnityPy (numbers and rules only; raw dumps outside
  the repo in E:\FightCamp\tmp\tpm_study; nothing of theirs committed).
- Board at start: no open questions, no answers, no review comments.

## What now works (evidence on master)
- ISOWALL1 (c089c73d, 7839c799): on the iso floor camera Q/E turn the view in 90-degree steps (45/135/225/315, 0.28 s cubic, Ludo
  r109 A4); middle-drag makes one step per ~0.9 rad. The walls whose outward face points at the camera drop to the 0.45 m stub -
  the club's own walls (IsoWallCut.split over all 54 pieces, centre of the club) AND the hall shell (Shell/BackWall, GymLook2
  west/east slabs, cap beams) - while the far walls stand with their decor. Decor hung on a cut wall hides (club name, flyers, fight
  posters, wall clock, round timer, bag-beam brackets/plates); bag beams + bags and speed bags stay (stations). New: scripts/club_rooms/
  IsoWallCut.gd (pure), IsoWallShell.gd (scene side), hooks in ClubRoomBase.gd (iso_turn, _iso_facing_walls, _sync_iso_shell - only on a
  yaw/zoom change). Correction to the brief: Q/E DID turn the iso view before, by 30 deg clamped +-90 via the perspective _orbit_yaw.
  - tests/iso_wall_rotation_test.gd: red on master 20 failures (Q 45->75, shell never cut, decor never hidden) -> ISO_WALL_ROTATION
    failures=0 (32 OK). `run_tests.py --only iso_camera,gym_club,club_room,office,playable_loop,iso_wall --jobs 3` SUITE total=20 fails=0.
  - Stills (tools/isowall_stills.gd, hidden desktop): docs/previews/s243_isowall/ 4 yaws x floor_far/floor_view, opened by Claude. First
    pass showed the bag-beam wall brackets over the cut back wall with shadows outside the hall -> fixed 7839c799, re-shot clean.
    Sheet on the review board + Q-S242-2 for his OK (visual closes on his OK only).
- Two Point Museum study: research/TWOPOINT_MUSEUM_STUDY_S243.md - camera FOV 17 perspective, pitch 35-90, free yaw; far walls
  back-face only, near walls transparent; 1,600 items: 0.5 m grid 87%, 45-deg 74% / 90-deg 23%, free placement on all; room minimums
  in cells, required items, prestige cap 30-48 per cell, 100% refund, room move/renovate/templates.
- Ludo r109 (26,315 chars) + r110 (26,059, continuation + Part C reconcile with the measured values), still uploaded; raw in
  research/ludo_rx/. Verdict research/PLACEMENT_VERDICT_S243.md (demo: build mode - move/turn/buy stations on a 0.5 m grid,
  green/red ghost with the reason, clearance + aisle check, 100% refund while building, rooms fixed; room drawing EA). NOT taken:
  Ludo's FOV 24 perspective camera (the ortho iso camera is his settled ruling Q-S239-1).

## Decided (Claude, developer calls)
- Cutaway by outward normal from the club centre (one rule for shell, inner and corridor walls) plus the existing ray rule for walls
  hiding a room floor or the fighter. Decor index re-read per turn (the zones refresh rebuilds the bag beams).
- Stub kept at the existing ISO_STUB_H 0.45 m (Ludo 0.40 + a 6 cm cap rail - the cap rail is a later art pass, not built).

## Agents
- Cline: ASSETAUDIT1 part A (issue #245, brief TASK_ASSETAUDIT1.md - audit script + inventory table, no game files). Part B (swaps +
  iso stills) is Claude's when it lands.
- Still in flight from S242: Grok Dev NIGHTLY8, FLOATERS1 Qwen #243 / Arena chat 01a149c7 / Cursor #244 - none landed by 16:40.

## HANDOFF
- Working commit: S243 commits 4426688c..this digest. Pushed.
- Next action: roadmap now.next_action - PADPAIR1 Cascadeur first (deadline 2026-10-27), collect FLOATERS1 A/B/C + NIGHTLY8 + Cline #245.
- Awaiting operator: Q-S242-1 PLACEMENT1 verdict; Q-S242-2 ISOWALL1 stills OK.
