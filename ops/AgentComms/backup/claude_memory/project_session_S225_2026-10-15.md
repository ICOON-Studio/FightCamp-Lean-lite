---
name: project-session-s225-2026-10-15
description: "S225 - collect day: ANIMFIX1 merged, KITS1/CORNERLIVE2/FLOORHUD1/STREET1/NIGHTLY6/GLOBE1/LUDOCTX1 merged, ANIMFIX2 round 2 after two gate rulings"
metadata:
  node_type: memory
  type: project
  originSessionId: 30a4cc5e-b22d-4889-b9ce-4f20748dfe7f
  modified: 2026-10-15T14:28:54.629Z
---

S225 (2026-10-14/15), digest research/S225_DIGEST.md.
- Merged by diff: ANIMFIX1 (rest-aware mirror; the uppercut's pointed sole is in the Mixamo source), KITS1, CORNERLIVE2 (corner on the
  real clock, ON), FLOORHUD1 (ON but its pieces do not mount on the training_floor route = TrainingFloorPanel/_build_ludo_gym_hud, not
  GymHallPanel._build_hud2_pieces -> r3), STREET1 (CI red was a test built in SceneTree._init before autoloads), NIGHTLY6 re-pins,
  GLOBE1 (3 fixes of mine: lon 180 deg vs SphereMesh UV, fly-to pivot order EULER_ORDER_XYZ, shader id match), LUDOCTX1 (Arena).
- ANIMFIX2: Codex stopped on my wrong gates twice (direction-vs-axis cone; a 3-number conversion cannot keep the weighted Euler path;
  absolute cm targets across proportions). Ruled: authored deg stays, "anatomical space" = generator rig's rest frame conjugation;
  bounded face box; forearm 6 deg / upper arm 4. Wrist bend at retarget output -> ANIMFIX2B. See [[feedback_cursor_reads_issue_body]],
  [[feedback_arena_diff_collapsed_sections]].
- Operator in chat: the folded-boxer still he opened was the BEFORE witness; boots = WARDROBE1 (no re-rigging, skinned hightops).
- In flight at handover: ANIMFIX2 r2 (Codex, E:/FightCamp/wt/ANIMFIX2), FLOORHUD1 r3 (cloud Cursor #188).
