# S241 DIGEST (2026-10-17) - iso gym camera collected + fixed on the game camera, office PC + goal banner, nightly reds cleared

## Operator rulings this session (verbatim)
- Board Q-S239-1 (answered before S241, quoted at start): "3D World + Orthographic Isometric Projection): STRONGLY RECOMMEND [...] swap the
  camera projection to PROJECTION_ORTHOGONAL at standard isometric angles [...] Add all the rooms we have rdy so their opjects )desk PC in
  Office) can be accessed with unzooming gym floor a bit and and clicking it. we switch on other objects on rooms [...] 1 at a time when
  mechanics enforce it".
- Session start: "make your orientation faster" -> he started the separate session "Make agent_comms.py start fast" (not this stage).

## What now works (evidence on master)
- COLLECTED by diff (23f07011, 96eb1d04): Grok Dev NIGHTLY7 #234 promotions_board, #235 default_build_shows_no_real_name, #238
  station_move_picker (SUITE 3/0); Cursor ISOCAM1 #232 (iso_camera switch ON, live_objects office:desk, desk -> office_pc), Cursor PCHUB1
  #233 (OfficePcScreen + FindFightPanel embedded), Qwen FINLEDGER1 #236 (FinanceLedger), Arena #237 test only (goal_next_test blind vs
  master - its FighterGoal diff re-declared WALK_OUT_TRUST). 11 tests 11/0.
- Collect fixes: FindFightPanel confirm line fell back to a hardcoded "DANNY REYES" and lost the fight day; OfficePcScreen header was a fixed
  "ANVIL STREET GYM" -> set_gym_name/set_fighter_name (b0311b1e).
- ISOCAM1 FIXED ON THE GAME CAMERA (f2dd61d2, stills previews/s241_iso45/, tool Godot/tools/iso_club_still.gd):
  yaw 225 put the camera BEHIND the back wall (z -25.6: back wall at the bottom, floor letters upside down) -> 45 (street side, like every
  perspective zoom); iso floor_far drew the ROOF over every room and hid the office -> whole club open (no roof, front rooms drawn); iso wall
  cut along the camera direction at the fighter + every room. iso_camera_test +2 checks red on the shipped tree (17 roof nodes, office
  hidden), green now; iso/club/office/playable 17/0. Stills on the review board + sent to him.
- OFFICE GOAL BANNER (413f3357, Ludo r108 step 2): "[!] GOAL REVIEW PENDING: <NAME> WAITS IN OFFICE / CLICK THE OFFICE DESK TO SET HIS NEXT
  GOAL" over the office while a settled goal waits. REGRESSION FIXED: ISOCAM1's live-pick remap sent every desk click to office_pc, so the
  S240 goal talk was unreachable with iso ON - the desk opens the talk while one waits, the PC otherwise. GoalCard empty-row tween ERROR
  fixed. office_goal_banner_test (2 boxers + OFF) 0 fails; goal/club 11/0.

## Decisions (developer calls, said once)
- FightBoard (Arena FIGHTBOARD1, chat "orchestrating" 2 h, no branch) folded into Cursor OFFICEPC2 #239: one bout-rows module, not two.
- staff_pose_test (nightly red since ANIMFIX1 386fae952): the fold stays; only "seated palm toward lap" fails (standing passes) -> the seated
  forearm reach must be keyed from the body's rest, not the folded source. Queued to Grok Dev as STAFFPOSE2 (after PROGSIGNS2).
- PADPAIR1 (Cascadeur, deadline 10-27) NOT started here: it is a fresh Opus-high session's first PC job (brief says so; ~300k used here).

## In flight at handover
- Cursor OFFICEPC2 issue #239 (brief research/TASK_OFFICEPC2.md rev 1): FightBoard + desk click -> PC -> book_fight -> countdown pill,
  floor FIND A FIGHT dropped with iso ON. Collect: diff + parse + fight_board_test + office_pc_wiring_test + subset.
- Grok Dev: NIGHTLY7 camp_pays_test (it will flag a test-design change for Claude's call), then PROGSIGNS2 (TASK_PROGSIGNS2.md), then
  STAFFPOSE2 (gbot message). Read with `python Tools/gbot.py thread --to dev`.
- Free: Arena, Qwen.

## Traps
- A live-pick test that ray-casts a prop box passes even when the room is hidden or roofed - open the still.
- `git stash push -- <path>` was used once to prove red; prefer a scratch worktree (CLAUDE.md s7 bans bare stash only, still avoid).
- live_runs*.json are written with indent=1 - json.dump(indent=2) rewrites the whole archive.

## HANDOFF
- Working commit: see git log (S241 commits 23f07011..this digest). Pushed.
- Next action: roadmap now.next_action.
- Awaiting operator: his OK on the iso stills (review board S241 "Iso gym camera").
