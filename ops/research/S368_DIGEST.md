# S368 digest - BJJ side merged, the fight camera, the referee seat, Argon on Miro and in Blender (2026-11-02)

Main: f6715e7 -> 8a1fc03 (merge of s365-bjj-side) -> 3785941 -> c97e105 (+ this digest). Branches: claude/camview1 5c9a6a8,
agy/refbreak1 9c05850, claude/jabfix1 (pilot, not for merge), ziva/wip-s368 (local only).

## Shipped on main
- s365-bjj-side tested and merged (BjjSide, S366 one repo, S367 Gemini tools): bjj_side/stripe_call/no_gi/drill_pick/
  golden_path + 25 money dependents; ONE red found and fixed - the top bar's money card left out the BJJ dues and coach
  (tip_notes_test -180 vs -147, TopCards.gd). Export: full suite 116/116 PASS, Builds/FightCamp.exe rebuilt, pushed.
- Repo-move leftovers: start's Ziva hint (wt/ZIVA_LEAN), seed_godot_cache.ps1 (Lean root project.godot); Ziva up again on
  ziva/lean-s368 (= main), her uncommitted pile kept on local ziva/wip-s368 (be33d35).
- GrappleMap: a move named "Escape https://www.youtube.com/..." - links are refs now (grapple_db_test checks it).
- Tools: tools/ref_break_probe.gd, tools/cam_view_probe.gd, tools/clip_gltf.gd (+ ops/Tools/blender_clip.py: lossless
  Godot<->Blender clip round trip, 0.056 deg), tools/clip_feet_probe.gd (bare clip), tools/orbit_feet_probe.gd (as the
  preview shows it), ops/Tools/gemini_miro.py (Argon's Miro seat), ops/Tools/gemini_blender.py (Argon writes bpy).

## Camera MERGED, referee waiting
- CAMVIEW1 MERGED into main 51bc60b on the operator's "Yes, merge camera" (claude/camview1): operator "many times it is behind the fighter and cant see". Every lens within 40 deg of
  side-on, closer/wider at the ropes, other side when no room, a crane over the top rope in deep corners; shoulder shots ->
  three-quarter. cam_view_probe 90 s: behind a boxer 36.9 % -> 2.8 %, chest hidden 6.1 % -> 0 %; head hidden 5.2 -> 5.1 %
  (clinch heads side by side), longest 1.53 -> 2.60 s (t 43.7, a clinch) - still FAIL on those two lines. Argon camera
  3/10 -> 7.5/10. ring_lens_test + fight_flow/golden_path/tape_room green. Films: ops/previews/S368/camfilm_{before,after}.mp4.
- REFBREAK1 (agy/refbreak1, Antigravity on gemini-3.8-flash-high, 3 rounds): ref_break_probe PASS (0 of 445 frames through
  a body, both hands within 0.044 m of both chests; was 0.168 m / 10 frames); clinch_check identical to main; 4 tests green.
  Argon still 2/10: the boxers step out at the same instant he pushes (Clinch.gd fires the break and both step_outs at once),
  his arms spread wide (T-pose look), he shuffles between breaks. Next round: timing (step_out ~0.3 s after part()), bent-arm
  push close to his body, the walk's foot slide. Films: refbreak_{before,after}.mp4.

## Argon (Gemini 4)
- Operator BJJ clip: 5/10 as a match view, 8/10 techniques read (research/GEMINI_JUDGE_PILOT_S368_BJJ.md); Claude 6/10.
- Miro seat: frame "BJJ belt match - you call the next move" (loop board), Argon 6/10, its checks shaped the design
  (calls only on settled positions, 3 calls a match, her drilled moves only, odds + cost of a miss, belt clock). BJJMATCH1
  approved by the operator ("ok go-ahead").
- Blender pilot (operator "Yes, pilot the jab"): r1 made the feet worse (frame_set reset the held hips - fed back), r2 cut
  the bare clip's planted-foot slide 0.220 -> 0.024 m with the punch intact; $0.14 for both rounds. BUT in the preview
  pipeline the fight's foot re-pin already holds the jab's feet (orbit_feet_probe travel 0.000 m before AND after) - Argon's
  "severe moonwalking" (feet 2/10 -> 3/10) is not feet moving. Argon misjudges feet from an orbiting camera; its S367 "the
  jab holds two punches" was the preview REPLAYING the clip (clip_orbit cycles length + 0.4 s).

## Next session (S369), in order
1. Operator's call on CAMVIEW1 (merge, or the clinch head-hidden step first). 2. REFBREAK round 4 (timing in Clinch.gd is
outside its OWNS - brief the step_out delay as part of it). 3. Footing: find what the operator sees on the board previews -
render feet from a FIXED side camera, list per clip orbit_feet_probe travel (the hard right hook moves 0.27 m); Argon+Blender
only where the preview's feet really move. 4. BJJMATCH1 build. 5. Auto-dispatch session's results (seat_dispatch.py, the
Lean-layout gate) - collect from its own branch/files.

## After ship: camera merged (operator "Yes, merge camera")
Main 51bc60b. Export: full suite 116/116 PASS, Builds/FightCamp.exe rebuilt. The first export attempt failed on
grey_reason_test (exit 9: a SCRIPT ERROR line in its output under JOBS=2 although the test printed PASS); alone 4/4 clean,
the rerun suite clean - a parallel-run flake to watch (two tests sharing a user:// file is the guess, unproven).

## Ziva down at session end
Ziva's editor (wt/ZIVA_LEAN, godot_hidden.ps1 -e) ran ~09:00-21:00, then exited; three relaunches each exit with code 1 (one opened port 7012 for ~5 s first). Its log shows only the stale tools/begin_probe.gd parse error (FightCast.BODIES no longer exists - present in the morning too, not the cause). No zivacode sidecar left running. S369: open the Ziva chat page while it is briefly up (preview_start http://127.0.0.1:7012/) for a login/plan message; fix or delete tools/begin_probe.gd.
