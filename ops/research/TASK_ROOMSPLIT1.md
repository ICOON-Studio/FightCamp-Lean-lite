# TASK ROOMSPLIT1 - the room code leaves GymClub3D.gd (pure refactor, behaviour identical)

Model: Codex luna (CODEX_MODEL=gpt-6-luna), medium (codex_task.cmd). Worktree E:/FightCamp/wt/ROOMSPLIT1, branch codex/roomsplit1 from master (HEAD has CLUBROUTES1
merged). CODEX_REPO must point at that worktree. Push the branch; never master, HANDOFF.md or AgentComms/. No windows/viewers/browser;
windowed Godot ONLY via `Tools\godot_hidden.ps1`. `timeout` 300 s on every headless Godot run. Parse gate before any test.

Decision (Claude, S194/S195, operator: "should it be better to split each room own module"): GymClub3D.gd is 2,867 lines and every room
task edits it. Move the four front rooms (office, physio, reception, locker) into one module each so agents work on rooms in parallel.

## Owned files
- `Godot/scripts/GymClub3D.gd` (2,867 lines, NEVER read whole; windows: s=1721-2496 "GYMVIEW1: clear training floor" holds the room
  open/close, door hotspots, room camera glide and wall fade; s=616-848 zoom + wall fade; s=231-565 build; s=2497-end CLUBROUTES1 - leave).
- NEW `Godot/scripts/club_rooms/ClubRoomBase.gd` (shared: room camera pose, glide 0.45 s, fade, door hotspot) and
  `ClubRoomOffice.gd`, `ClubRoomPhysio.gd`, `ClubRoomReception.gd`, `ClubRoomLocker.gd` (each: its own build + its own open/close hooks).
- Layouts stay DATA in `Godot/assets/data/gym_club.json`; no row moves, no key renamed.
- Tests: existing only (do not edit a test to pass). One NEW `Godot/tests/club_rooms_split_test.gd`: each room module loads, mounts under a
  GymClub3D, opens and closes via the same public calls as before (`open_room`/door hotspot - grep the current names), room node names equal
  the pre-split names (byte-identical tree paths), OFF arm (`gym_floor_view` off) builds the identical node count.

## Prior research
`python Tools/prior_research.py roomsplit gymview` - GYMVIEW1 is in S194_DIGEST.md; the 0.45 s glide and one-sided street sign are gated.

## Spec
1. Extract per room; GymClub3D keeps ONLY orchestration (mount the four modules, route clicks/doors to them). Public method names and
   signals of GymClub3D stay exactly as they are (other scripts and tests call them).
2. The shared door-hotspot / camera-pose / fade logic exists ONCE in ClubRoomBase.
3. GymClub3D.gd ends under ~1,900 lines. No behaviour change, no new switch, no data change.

## Done (tier: script edited - parse, focused tests, related runs; NEVER the full suite)
- Parse: `python Godot/tools/check_scripts.py <every touched .gd>`.
- RED first: `club_rooms_split_test.gd` fails on master (modules missing), green after.
- `python Godot/tools/run_tests.py --only gym_floor --jobs 2`, `--only gym_club --jobs 2`, `--only club_ --jobs 2` -> 0 fails, counts
  unchanged vs master (gym_floor_view_test must stay green as is).
- Stills with `-- as_game gym3d_main gym4_club gym_floor_view hud2` via `Godot/tools/gym_floor_view_stills.gd` (JPG) match master's 01-08
  (compare pixel-diff per still; report max diff). Do NOT describe pictures you cannot see; give the numbers.
Commit + push codex/roomsplit1. Final message: red count, green runs, line counts before/after, pixel diffs.
