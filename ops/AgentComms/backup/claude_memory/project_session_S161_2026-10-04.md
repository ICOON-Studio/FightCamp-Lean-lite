---
name: project-session-s161-2026-10-04
description: "S161 - Godot on a hidden Win32 desktop (no popups); crouch + ball gloves = top-down camera, capped 45 deg; NIGHTLY1B merged; glove stills await operator"
metadata:
  node_type: memory
  type: project
  originSessionId: 3eee0c1d-28da-4baa-ac69-6e8cc1425396
  modified: 2026-10-04T14:51:49.804Z
---

S161 (2026-10-04, Opus): operator mid-session: "can you run the test in a vritual windows envornment so i do not see the popups" -> `Tools/godot_desktop.ps1` (CreateDesktop "FightCampHidden" + CreateProcess lpDesktop); `godot_hidden.ps1` routes through it by default (FIGHTCAMP_VISIBLE_DESKTOP=1 = old path). GPU renders fine there (movie capture verified). Windows Sandbox was rejected: needs a Windows feature switched on + weak GPU.

CROUCH and GLOVES2 were the keep-pair camera (c7db44d0, cap 45 deg) - see [[feedback_camera_can_fake_a_pose_defect]]. GLOVES2 waits the operator's OK on docs/previews/gloves2 stills. as_game swaps the Tripo demo pair for MPFB generator men (I mislabelled them "Tripo" in the first still, corrected in chat).

Arena: NIGHTLY1B hit the 3 h limit unpushed - a "commit + push + PR now" message in the same chat worked (PR #45 merged by diff). NIGHTLY1C errored after 13.5 h, same nudge sent. GLOVEFIT running. Digest: research/S161_DIGEST.md.

AFTER SHIP: operator on his phone screenshot (2:17, fixed camera): "Doe the right glove looks right ?" - NO. In guard the rear glove's cuff hangs beside the wrist, forearm enters the glove's side. My axis check (21-26 deg) measured the REST pose, not the guard - a gate on a pose the game never shows (same family as [[feedback_measure_the_posed_thing_not_the_rest_box]]). GLOVES2 reopened as the first item of next session.
