# S284 digest (2026-10-22) - bag mounts, AUTO FILL, the MGT2 build flow, scenery fixes, four designed layouts queued

Operator drove most of this session in chat with screenshots; nearly every item came from a still he sent. Claude briefed/collected
Cursor runs and fixed small defects directly (a gap against "delegate max": Arena and Qwen were never launched - see Next).

## Shipped (master, newest last)
- 98aae199 BAGMOUNT3 (Cursor #331 by diff): floor-surface list in BUILD (wood default), wall-arm yaw fix. Operator then asked to
  REMOVE the 4-bag frame (Q-S277-5 "remove the item for now make the bags mountable only near a wall") -> fead1207 removed
  free_standing_bag from the shop; BAGMOUNT4 (#333, a 4-bag wall rig) was NOT collected (misread: the answer was in Q-S277-5).
- 5067f3fb ... 671a1f04 AUTOFILL1 (Cursor #334, 4 rounds): AUTO FILL on the new-career gym step = ONE preset, the original gym from
  the layout data (every room at its original rect+door, original furniture, training floor, every canonical station), built FREE
  at OPEN GYM, cash stays 25,000, `career["autofilled"]`. c4dc03a0: the preset's training floor is the whole open hall (it was a
  top-left rectangle: "why is the floor different colours?").
- f3284944 free camera: zoom is a pure dolly (no +21 deg tilt); free_camera_zoom_pitch_test red on master first.
- 4bc3ee17 wall-arm bags snap flush to the nearest hall wall at the right yaw (BuildMode._wall_snapped, WALL_BAG_CENTRE_M 0.82,
  snap from 1.5 m); `_nearest_wall` ignored walls the point is on the wrong side of; a reception may cover the street door
  (reception_street_door_test, red first).
- 994aa789 / ff58ade9 scenery: Neighbour W/E/N, skyline boxes and the GymLook2 Tenement_0-6 blocks hide when between the camera and
  the gym (neighbour_blocker_test), and cast no shadow ("what is the black spot" = a tenement's shadow on the floor).
- 81ab1e5d / aa32be99 BUILDFLOW1 r1+r2 (Cursor #335): MGT2 room draft - select, draw limits, eligible items list, door, FINISH
  charges once (RoomDraftRules, room_draft_flow_test). r3 (status text over the FINISH button) in flight.

## Evidence
- Stills opened and sent: s284_gym_build (frame 4 bags), s284c_wall_snap, s284_autofill/full_gym_01_floor_far.jpg (one wood floor),
  s284_buildflow/* (flow steps), sheet4 (four camera yaws, no box, no black patch). All on 8787/review.
- Ludo (FightCamp chat "Gym Management Screen"): LUDO_AUTOFILL_S284_raw.txt (3 preset counts, superseded), LUDO_LAYOUTS_S284.json
  (4 layouts as data). Ludo's numbers fail the game's geometry: `python Tools/validate_layouts.py` = 19 problems.

## Known red (not from today)
- build_single_piece_test -- as_game 18 FAIL and gym_club_3d_test -- as_game (far camera pose / roof / zoom_level) fail identically
  on the session-start versions of today's files. gym_preset_autofill_test is green again after the rework.
- HITFEEL2 (Cursor #323) r5 collected f5cd4989: hit_feel_wire_test 141 s as_game (target 120 s), punch_retime_test green both arms
  (5.5 min each - it is slow on master too). The operator A/B video was NOT made.

## Traps earned
- Cursor reads the ISSUE BODY, not comments: a round brief in a comment is ignored; append "## ROUND N" to the body, then remove and
  re-add the label.
- A branch is cut from master at launch: collect with `git diff <last collected commit> <tip> -- Godot/scripts Godot/tests`, never
  against current master (it shows later commits reversed). Two helpers named alike clash (`_wall_snapped`).
- Chrome profile: POST from the Ludo page to the 127.0.0.1:8799 receiver hangs in a new tab group; fallback = ask Ludo for COMPACT
  JSON and read it in <=1000-char slices (plain slices truncate at ~1000 chars, some blocked).
- A test that pins "what the code produced" (sums) is not a spec test: assert counts against the data.

## Next
See roadmap now.next_action (S285): collect #335 r3 and #336 AUTOFILL2; Arena/Qwen sweep; A/B video; day_feed rows 3/7/8; DEALS tab Ludo check.
