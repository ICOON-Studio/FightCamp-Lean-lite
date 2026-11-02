# TASK SEETHRU1 (S222) - anything between the camera and what you look at, or too close to the camera, goes see-through

Model: cloud Cursor (label `cursor`). Repo ICOON-Studio/FightCamp, branch `cursor/issue-<n>` from master. Open a PR, never merge.
No Git LFS on the cloud box: tests build the club with `load_models = false`. Do not delete or shorten any existing test.
Operator, verbatim: S222 "why dont you make the south wall too ? actually when zooming in everything that is in the way or too close can be
transparent"; S221 C61 "south wall can be semi-transparent"; C62 "make wlass transparent when zoomed in". New features ship ON (S221).

## Prior research
- `Godot/scripts/club_rooms/ClubRoomBase.gd` (1,187 lines): `FADE_ALPHA` 0.2 / `FADE_S` 0.3 (line 5-6), `walls_to_cut()` (299),
  `_update_wall_fade(delta, snap)` (337) - fades ONLY the meshes in `_walls`, by name; the floor overview fades the south wall (z = hall_d)
  and the corridor stubs. `_apply_cut(wall, alpha)` (376). This is the system to extend - do not add a second fade system.
- Not in `_walls` today, so they never fade: the wall-top cap beams (`club_look/GymLook2Shell.gd` 154-161: CapNorth/CapSouth/CapWest/CapEast),
  the roof beams, pillars, and tall props. The white slab across the bottom of the floor overview is the south side (wall + CapSouth).

## What would a human do?
The Sims / Two Point / Planet Coaster: walls and objects between the camera and the subject fade to a ghost; walls down in overview.

## Do
1. One occluder registry in ClubRoomBase: walls (as today) + the four cap beams + roof beams + pillars + any prop taller than 1.6 m. Each
   gets the same fade (alpha 0.2, 0.3 s tween; `_apply_cut`-style material duplicate so shared materials are not changed globally).
2. Rule, every frame (cheap: AABB tests only, no physics): an occluder fades when (a) its AABB intersects the segment from the camera to the
   focus point (the zoomed room's centre, the selected station, or the screen-centre ground point in overview), or (b) any point of its AABB
   is within 2.5 m of the camera, or (c) it is the SOUTH wall/cap (z = hall_d) in the floor overview (C61 - keep today's behaviour, add the cap).
   It returns to opaque when none holds.
3. Never fade the floor, the ring canvas, fighters, or the station the player selected.

## Acceptance - NEW `Godot/tests/see_through_occluders_test.gd`
(a) floor overview: CapSouth and the south wall read alpha 0.2 after the tween, CapNorth reads 1.0; (b) a camera placed 1.5 m from the west
wall: that wall + CapWest fade; move it away: both back to 1.0; (c) a pillar placed on the camera->focus segment fades, the same pillar
off the segment stays opaque; (d) fighters and floor never fade; (e) existing wall-cut tests pass (grep `walls_to_cut`/`club_alpha` in tests/).
(a)-(c) must go RED on master first - say so in the PR. Parse gate `python Godot/tools/check_scripts.py <touched .gd>`.
Claude takes the game-camera stills (overview + a zoomed room) on the PC after it lands.

## The one trap
Materials are shared between walls and props: setting transparency on a shared material ghosts every copy in the club. Duplicate per mesh
(the way `_apply_cut` does) before changing alpha.
