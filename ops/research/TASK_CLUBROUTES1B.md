# TASK CLUBROUTES1B - make the painted day-plan routes READABLE (send-back of CLUBROUTES1), switch `club_routes` stays OFF

Model: Cursor (cursor_task.cmd). Worktree E:/FightCamp/wt/CLUBROUTES1B, branch cursor/clubroutes1b from master. Push the branch; never master,
HANDOFF.md, AgentComms/. No windows/viewers/browser; windowed Godot ONLY via `Tools\godot_hidden.ps1`. Your image tool is blocked: prove
visibility with pixel checks and say so in your first line.

Defect (Claude opened `previews/clubroutes1/01_routes_idle.jpg` on master): the routes are a faint dashed trace, barely
readable on the dark floor at game-camera scale. Operator wants "painted, colour-coded drill routes" (Ludo mock
`previews/ludo_s188/gym_topdown_drill_routes.jpg` = solid ribbons ~0.25 m wide, clearly coloured).

## Owned files
`Godot/scripts/GymClub3D.gd` - ONLY the CLUBROUTES1 section (s ~2497-end; grep `club_routes`/`ribbon`); `Godot/tests/club_routes_floor_test.gd`;
`Godot/tools/club_routes_stills.gd`; `previews/clubroutes1/*.jpg`. Pure rules `scripts/rules/ClubRoutes.gd` unchanged.

## Spec
Idle opacity stays Ludo's 12% BASE for the pulse but the ribbon must read: ribbon width >= 0.25 m, emissive/unshaded so floor shadows do
not eat it, idle floor alpha raised so that in the 1920x1080 game-camera still the route pixels (saturation > 0.35, not wood/mats/people)
cover >= 1.5% of the floor area in idle and >= 3% on hover; hover stays brighter than idle by >= 40% of those pixels. Done segments dimmer.

## Done (tier: script edited)
Parse gate; extend club_routes_floor_test with the width/alpha numbers (RED first on master, paste count); `--only club_routes`,
`--only gym_club`, `--only gym_floor` -> 0 fails; re-shoot 01_routes_idle/02_routes_hover as JPG via the stills tool
(`-- as_game gym3d_main gym4_club gym_floor_view club_routes hud2`), report the pixel coverage numbers. Commit + push cursor/clubroutes1b.
