# S161 DIGEST - 2026-10-04 - the crouch and the ball gloves were the camera; Godot runs on a hidden desktop

## Shipped
| What | Commit | Evidence |
|---|---|---|
| Windowed Godot runs on a hidden Win32 desktop (`Tools/godot_desktop.ps1`); `godot_hidden.ps1` routes through it by default (`FIGHTCAMP_VISIBLE_DESKTOP=1` = old off-screen path); CLAUDE.md s4 says so | a74378c6, 20818ac9 | operator: "can you run the test in a vritual windows envornment so i do not see the popups". CreateDesktop + CreateProcess lpDesktop, IDLE priority, Dummy audio, output printed at exit, exit code passed (rc 1 on a missing script). Movie captures render normally (720p frames opened). |
| CROUCH fixed: the "hands and knees" at seed 92012 2:18-2:17 was the CAMERA - keep-pair fit clamped it inside the ring at a corner and lofted it to ~75 deg down, a standing guard foreshortened into a fold. Pitch capped at `CAMERA_MAX_PITCH_DOWN_DEG` 45; past it the camera backs off horizontally (out 3 m/s, in 0.6 m/s); option `camera_max_pitch_deg` (89.9 = old) | c7db44d0 | side camera (`shot=low_mat`) of the same frames: A upright in guard; pose_log hips ~0.76 m over the deck; active_ragdoll OFF still "folded" (not the ragdoll). `fight_camera_pitch_cap_test` ON max 45.0 / OFF control 75.1 (p95 61.6), both heads in frame 100% both arms; camera (3), fight_world_live, stance_offset green. Clip sent: E:/FightCamp/gloves2/crouch_fixed_28-46s.mp4 (silent, frames opened). |
| GLOVES2 measured: glove geometry is right on MPFB man/woman AND MetaHuman mh_boxer_01 - hand covered (0 finger-skinned tris drawn), thumb lobe on the thumb side, glove along the forearm (26.0 / 25.3 / 21 deg, bound 35). The "ball" + "bare hand" read came from the same top-down camera | 26a7ea47 | `glove_handedness_test` 30/0 (MH case + axis check added); mutant (glove tipped 70 deg) 12 red on all six hands. Stills sent: docs/previews/gloves2/compare_mh_vs_tripo.png (MH vs default, BEFORE - its right half is the MPFB default men, NOT Tripo: as_game swaps the Tripo pair for the generator), gloves_after_camera_fix.png (AFTER). |
| NIGHTLY1B merged (Arena PR #45, diff applied, PR closed): the 4 "hangs" are slow tests - measured ceilings x1.5 in run_tests; strike_speed one mount instead of four | 1ee09c55 | strike_speed green here (388 s, --jobs 2). check_workflow flagged the test edit outside owned files - accepted (brief step 5, same 25 checks). |
| SCHED1-GATE (OpenCode issue #32) closed as superseded by Arena PR #42 (same badge, merged); its run died on a retired Gemini model | a74378c6 | |
| record_room pose_log flags a low pelvis | c7db44d0 | |

## Operator (verbatim)
- "can you run the test in a vritual windows envornment so i do not see the popups"

## Waiting on the operator
- His verdict on the gloves: compare_mh_vs_tripo.png (asked "do the MetaHuman gloves look right?") and
  gloves_after_camera_fix.png ("do these look normal now?"). GLOVES2 closes on his OK; if he still sees a defect,
  ask WHAT (S154 lesson) - the measured geometry is in range.

## In flight
- GLOVEFIT on Arena (chat 01a1071a, branch arena/01a1071a-fightcamp): fix + glove_capsule_fit_test written, running.
- NIGHTLY1C on Arena (chat 01a1044c): session errored after 13.5 h unpushed; sent "commit + push + PR now" at 17:58.

## Next
Collect GLOVEFIT and NIGHTLY1C, then PR #43 KM3 A/B (bash E:/FightCamp/wt/km3_c223_ab.sh, detached, GREEN only),
then rebuild the .exe (READROUND + corner + camera cap) and walk a fight as_game.

## Operator after ship (verbatim) - GLOVES2 REOPENED
- On his phone screenshot of the fixed-camera frame (seed 92012, 2:17; saved docs/previews/gloves2/operator_right_glove_2-17.png):
  "Doe the right glove looks right ?" - NO. The rear (right) glove in guard stands upright with its cuff hanging
  below/beside the wrist; the forearm runs into the glove's side. The S161 axis check (21-26 deg) measured the
  rest pose, not the guard - it could not see this. Next session starts here (roadmap now).
