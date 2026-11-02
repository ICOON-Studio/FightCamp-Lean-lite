# TASK HALLSIZE1 - the gym gets REAL-WORLD size: 30 x 18 m hall (540 m2) for the starting club, tier table as data

Model: Codex luna (CODEX_MODEL=gpt-6-luna), medium. START ONLY AFTER STATIONS4 (codex/stations4) IS MERGED (both edit gym_club.json). Worktree E:/FightCamp/wt/HALLSIZE1, branch codex/hallsize1 from master.
Push the branch; never master, HANDOFF.md, AgentComms/. No windows/viewers/browser; windowed Godot ONLY via `Tools\godot_hidden.ps1`; `timeout` 300 s per headless Godot run; parse gate first.

Operator S195 (verbatim): "there is established club with so small gym, gyms must be around 465 - 1,860 m2 and even bigger for fitness gym or multipurpose facility, how can ai be so off on that?" and, on the proposal
below: "yes go with those tier sizes". Claude's S195 lesson: benchmark real-world numbers first; never hand an AI our own current value as its baseline (Ludo anchored on our 20 x 18 m).

Operator S196 board answer Q-S194-6 (verbatim): "i want the starting Gym to be minimum 450 sq. m adjust everything according to that". T2 540 m2 satisfies it and is THE start hall; T1 garage (150 m2) must NOT be the start tier - when LUDO-HOUR1 is built it starts at T2, not T1 (supersedes the D40 garage-start line below).

## The decision (tier table, DATA: new `Godot/assets/data/gym_tiers.json`)
T1 Converted garage ~150 m2 (15 x 10 m) - not used in the demo start | T2 Established club 540 m2 (30 x 18 m) - THE DEMO STARTING HALL | T3 Commercial gym ~1,000 m2 (40 x 25 m) | T4 Elite centre 1,860 m2 (60 x 31 m) |
later: multipurpose facility > 2,800 m2. Per tier: hall w/d, wall height, station capacity (7 / 20 / 36 / 64), civilian-member capacity (15 / 60 / 150 / 360 - Ludo's ratios scaled), and the unlock cost placeholders (0 / paid-later).
`start_tier` key (default "T2") picks the hall the game starts in: D40 (S190, approved) says hour 1 is a GARAGE gym with expansion locked - when LUDO-HOUR1 is built it sets start_tier to T1; until then the operator reviews the floor at T2 (540 m2).
Ludo R25 numbers for dues and wear are in LUDO_ROUND25_S195.md; do NOT implement money/members here - only sizes, capacities as data and the hall geometry for T2.

## Owned files
- `Godot/assets/data/gym_club.json` (after STATIONS4): `room.w` 20 -> 30 (the hall gets 10 m WIDER on the east; depth stays 18). The front block (locker room, physio, reception, office, z 18-22.5) keeps its x 0-20 footprint; the new
  strip x 20-30, z 18-22.5 becomes ONE new room `equipment_store` (door onto the front aisle, shelves + boxes dressing, no TV/chair), so no dead walled-in space and it is the natural place for spare equipment once wear exists.
  Everything that lives at x >= 18 stays where it is; the ring, bags, rack, stations keep their coordinates. Re-space ONLY the freed floor: the free strip is now ~30 m wide (x 0-30, z 10.6-16.4): keep the new stations' coordinates,
  the empty expansion_bay stays, add NOTHING else. Street, sidewalk, road, neighbour buildings: widen with `room.w` (check `Neighbour`, `Sidewalk`, `Road`, skylights, plants in GymClub3D.gd for hard-coded w + 12).
- `Godot/assets/data/gym_club.json` cameras: `home_camera`, `zoom_cameras` far/mid/floor_far/floor_view targets and distances re-fitted for a 30 x 18 hall (the floor must still fill >= 70% of the HUD-clear area at 1280x720 and
  all four hall corners stay in view - `gym_floor_view_test` checks both). Re-tune by running the test, not by guessing.
- NEW `Godot/assets/data/gym_tiers.json` + a pure reader `Godot/scripts/rules/GymTiers.gd` (`tier(id)`, `current_tier()` = T2, capacities); NEW `Godot/tests/gym_tiers_test.gd`.
- Existing tests that assume 20 m width (find with grep for `"w"` / `20.0` in `Godot/tests/gym_*`, `club_*`, `floor_*`): update the assumption ONLY where the test hard-codes the old size, never loosen a rule;
  the aisle/walk-limit/clearance rules stay as they are (walk_limit_m may need to grow with the hall: justify the number from the longest route and write it in the commit).

## Prior research
`python Tools/prior_research.py hall size tier gym`; LUDO_ROUND23_S195.md (28 x 20 m hall), LUDO_ROUND25_S195.md (tier path), the S195 commit 2220fd29 (the 12 -> 18 m deepening, and what tests needed changing).

## Done (tier: data + script edit)
- Parse gate on every touched .gd. RED first: `gym_tiers_test` fails on master (file missing). Green after: T2 == the hall in gym_club.json (w 30, hall_d 18 = 540 m2), tiers strictly increasing in area, capacities increasing, T4 = 1,860 m2.
- `python Godot/tools/run_tests.py --only gym_ --jobs 2`, `--only club_ --jobs 2`, `--only floor_ --jobs 2`, `--only walk_in --jobs 2`, `--only hud2 --jobs 2` -> 0 fails (counts vs master).
- Stills (`Godot/tools/gym_floor_view_stills.gd`, `-- as_game gym3d_main gym4_club gym_floor_view hud2`, JPG): the wide floor, the equipment store opened. Report pixel facts; do not describe pictures you cannot see.
Commit + push codex/hallsize1. Final message: red count, green runs, the new walk limit and why, the camera numbers.
