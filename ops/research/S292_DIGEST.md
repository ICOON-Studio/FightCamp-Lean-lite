# S292 digest (2026-10-23) - D48 golden path: camp + next goal reachable, amateur stipend, S289RED1 collected

## Operator words (verbatim)
- None this session (session start only). No open board questions at start; no new review comments.

## What now works (evidence)
1. d3e6a40c S289RED1 COLLECTED by diff (Cursor #344, issue closed): BUILD room_check keeps the street-door rule ahead of the reception
   reserve; drawn_rect undoes a half-metre snap into a neighbour (Claude: toward the nearer side, overlap <= 0.5 m only - the branch
   always pushed east). Claude also: GymHall3D top bar checked `is Control` BEFORE is_instance_valid (5 SCRIPT ERRORs per as_game run
   on a freed shell panel); GymClub3D._club_routes_clear removed the routes root from the wrong parent; gym_club_3d's goals-HUD check
   follows the S275 one top bar. Game arm 10/10 (6 + 4 regressions), plain 10/10, golden_path 9/9.
2. a0d99a4f GAP 1 + GAP 5 (golden path):
   - SET CAMP in the floor tray (OneTopBar FloorTray, GymHallPanel) while GameState.get_camp_gate_asks() holds a row -> the fighter
     card's CAMP tab. The camp ask lived only behind GameState.continue_day, which the floor's day never passes.
   - NEW GOAL in the floor tray while a goal talk waits -> GymHall3D/ClubRoomBase.go_to_goal_talk walks the camera into the office
     (board Q-S237-2 "this should be done in the office"); no office drawn -> the talk opens on the floor.
   - golden_path_test G7C (SET CAMP -> START A CAMP -> focus + protocol -> START CAMP -> camp live): RED on the shipped panel
     ("TrayCamp is not a visible enabled button"), GREEN with the fix. G9 now presses NEW GOAL and sets the next goal (Southpaw Answer).
     golden_path as_game 10/10.
3. c0f09531 GAP 4 (part): every non-pro amateur signs on the $250 club stipend (the S146 rule only covered 0-bout novices; S188 resets
   the book to 0-0-0 at signing anyway; J5 "invented polarity"). Golden path: cash at fight night $6,276 -> $15,420; weekly net
   -$2,798 -> -$1,456. first_months_cash + game_money_split green both arms.
4. 242870b7 NIGHTLY: ShellFloorMembers walk-in deferred on the hall (the static apply deferred with a freed `self` raised "Cannot
   convert argument 1 from Object to Object" - profile_drawer, skip_day_drawer, gym_club_clearance red in the 10-23 nightly). Plain 4/4.
5. LUDO ROUND (research/LUDO_PROGRESSION_MONEY_S292.md, reply 15,707 chars): training pace 0.6 -> 1.0/week + rookie headroom
   1.25x, goals retargeted to ~70% clearable, week-review fill-to-next-point rows, first coach $450/week, dues $22, a built gym opens
   with 30 members, classes +$350/week, amateur bout $450 ticket cut. Claude's verdict in the same file -> board Q-S289-2 (attached).
6. PLAYABLE BUILD Builds/FightCamp_Godot (WHAT_TO_TRY.txt rewritten for the fighter's path). The glove icon (S290) had importer
   "texture" -> the export refused it; set to "keep" like every lucide icon.

## Nightly (10-23 @4ddc99bf, 1002/13) vs last check (10-22 @c4dc03a0, 13)
FIXED since: camp_pays, mastery_select_wire, q226_strands. NEW red: bag_mount, build_holds_clock (hang), gym_club_clearance,
iso_ceiling_fixtures, no_garage, profile_drawer, reception_keeps_gym, reception_street_door, room_camera_flow, room_draft_flow,
room_walls_mgt2, skip_day_drawer; still red: fight_identity. Fixed this session: reception_street_door, room_draft_flow,
room_walls_mgt2 (S289RED1), profile_drawer / skip_day_drawer / gym_club_clearance engine error (242870b7). Left: bag_mount,
build_holds_clock, iso_ceiling_fixtures, no_garage, reception_keeps_gym, room_camera_flow (gym building - parked by D48), fight_identity.

## Agents
- Cursor #345 GOLDREDS1 (TASK_GOLDREDS1.md): golden path gap 7 - timeline_bar, first_corner, floor_week_bookkeeping, week_review,
  camp_reaches_bout, camp_pays red in the game arm; + profile_drawer / skip_day_drawer game-arm setup (empty roster). RUNNING.

## Decisions taken (developer calls)
- Camp and next-goal asks are tray flags, never auto-opened panels (S275/S276 "nothing auto-opens", the APPLICANT pattern).
- The amateur stipend covers every amateur who never turned pro: research direction (J5) already existed - no new number.
- Training pace / goal targets / economy numbers are DESIGN: Ludo first (D39), operator approves on the board before build.

## Next (in order)
1. Q-S289-2 answer -> build the approved half(s): LIVED_GAIN_SCALE + program pace + headroom; FighterGoal retargets; week-review
   fill bars; quick-start economy (coach $450, dues $22, 30 members, classes +$350, $450 ticket cut). Each lands with a golden_path
   bound (GOLDEN MONEY net >= -$200 week 1; a trained stat ticks a whole point within 2 weeks) red first.
2. Collect Cursor #345 by diff the session it lands.
3. (Gap 6 closed in S292: the floor bar stays hidden under one_top_bar, golden_path G5 guards it.)
