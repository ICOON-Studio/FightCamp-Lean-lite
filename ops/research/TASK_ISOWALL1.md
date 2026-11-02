# TASK ISOWALL1 - the iso view turns in 90-degree steps; far walls stand, near walls cut, by the camera's rotation (S242)

Operator S242 (on the no-walls still, bag rails and the gym sign floating with no wall behind them): "can you render the end wall
depending on the view and rotation ?" Inside the approved iso camera ruling (Q-S239-1). Discipline: BOXING (demo).
Seat: Cursor (iso camera owner, ISOCAM1) after #244 lands, else Claude. Model: Cursor default.

## What the game does today (read, S242)
- `scripts/club_rooms/ClubRoomBase.gd:17` `ISO_YAW_DEG := 45.0` - `_iso_pose_from_target` (line ~203) always uses it, so Q/E
  (`GymClub3D.gd:1743` -> `orbit_step`) do not turn the iso view.
- `_iso_walls_hiding()` (line ~455) ray-casts from the fighter + every room centre along the camera forward and cuts the CLUB's
  inner walls (`_walls`, node "Walls") it hits. The hall shell's outer slabs (`GymLook2/Shell/HallShell/Slab{West,East}{In,Out}`
  and the back/front brick) are never cut and never considered.

## Operator approval (S242, verbatim, on "Sims-style cutaway on Two Point-style rotation. I'll run it past Ludo with the no-walls still before it's built.")
"do it next session" - approved; Ludo check of the rule first, then build.

## Build
1. Iso yaw is a state: `_iso_yaw_deg` starts at 45; in iso mode Q/E step it by +/-90 (45, 135, 225, 315) and re-pose the camera
   with the same pitch/distance; zoom keeps the yaw.
2. Every wall - club inner walls AND the hall shell slabs/brick - gets an outward normal. A wall whose normal points AWAY from
   the camera (dot(normal, camera_forward) > 0 = we see its inside face) stays FULL height; a wall facing the camera is cut to
   the existing stub height (the same stub/fade `_update_wall_fade` already uses). Inner walls keep the existing ray rule as well.
3. Wall-hung things (bag rails, signs, the gym name, clocks, posters) follow their wall: full on a full wall, hidden with a cut one.
4. Recompute on every yaw step and zoom change - never per frame.
5. Switch: `iso_camera` (already GAME_ON). OFF arm unchanged.

## Gates
- Test `tests/iso_wall_rotation_test.gd`: for each of the 4 yaws, the walls on the far side are full height and the near side
  cut (name them per yaw); red on master first (yaw never changes; shell slabs never cut). Pass line `ISO_WALL_ROTATION failures=0`.
- Parse gate; `python Godot/tools/run_tests.py --only iso_camera,gym_club,club_room,office,playable_loop --jobs 2` unchanged or better.
- Stills: Claude runs `tools/iso_club_still.gd`-style shots at all 4 yaws (floor_far) for the operator's OK.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on <Q/E do not turn the iso view; outer walls never cut>; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
(Floor stills here = the iso club still tools; Cursor cannot see images - report which walls are full/cut per yaw from the test.)

## How shipped games do it (S242 web check, operator: "check how 2point hospital and similar games do this")
- Two Point Hospital / Campus: free camera rotation (Z/X keys or drag), tilt capped near 45 degrees; NO wall-hide toggle.
  Walls only draw their finish from one side, so a wall between you and a room is seen "through" (players note seeing into a
  bathroom through it from one side, a tiled wall from the other) = one-sided walls / back-face culling by view direction.
- The Sims: three modes - walls up, CUTAWAY, walls down. Cutaway keeps the outer/far walls standing and drops the camera-facing
  walls to a thin strip on the floor so the layout still reads; most wall-hung items vanish with a cut wall. Players toggle walls
  up to place wall items, then back down.
- The common rule (patents, three.js forum): a wall faces the camera when dot(wall_normal, camera_pos - wall_pos) > 0; hide/fade
  the ones that face the camera AND sit between the camera and the subject.
- Decision for us: The Sims cutaway (far walls full with their rails/signs, near walls to a stub strip - our layout must stay
  readable at the iso zoom), on Two Point's rotation (Q/E 90-degree steps first; free drag later if Ludo asks). Send this rule to
  Ludo with the S242 no-walls still before building (Ludo gate for visuals).
- Sources: steamcommunity.com/app/535930/discussions/0/1737715419904316904 (TPH walls one side),
  community.twopointcounty.com/.../threads/1470-walls-go-down (Campus: no wall toggle, rotate instead),
  two-point-hospital.fandom.com/wiki/Preferences, forums.ea.com/discussions/the-sims-4-gameplay-en/inner-walls-wont-cut-away-anymore/8694620
  (cutaway strip), twinfinite.net/?p=314684 (Sims console wall modes), discourse.threejs.org/t/get-orbitcontrols-azimuth-angle/25945/2.

## Prior research
TASK_ISOCAM1.md, S241_DIGEST.md (yaw 225 put the camera behind the back wall), Q-S239-1 ruling, tools/iso_nowalls_still.gd.

## What would a human do?
The Sims / Two Point Hospital cutaway: rotate in 90-degree steps, the two walls nearest the camera drop, the far two stand with
everything hung on them.

## Prefab check
Engine-side logic on our own walls - no asset.
