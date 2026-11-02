# TASK GYMCAP2 - show the FULL gym: every store station packed into the hall, with the capacity numbers on screen (design view, switch `club_capacity`, OFF)

Model: Codex luna (medium). Worktree E:/FightCamp/wt/GYMCAP2, branch codex/gymcap2. Never master, never HANDOFF.md, never AgentComms/.
Operator S196 (verbatim): "i think it's better to add all available stations for each equipment so we can understand how many of each equipment can
fit and how many customers maximum and fighters can be at the same time in the gym". GYMCAP1 (merged) computes it; EQUIP2 (merged) made the
catalogue 95 items; GYMLOOK1A (merged) zoned the floor. This step SHOWS it: the operator opens the club with `club_capacity` ON and sees the hall
filled with every station the catalogue offers, with a plate listing how many of each fit and how many fighters/members the gym holds at once.

## Owned files
- NEW `Godot/scripts/club_capacity/ClubCapacityView.gd` (`extends Node3D`, `build(hall_w, hall_d, tier_id)`): reads `ClubCapacity.full_mix(hall_w, hall_d,
  catalog, rules)` (returns `placements` = Array of rects {id, x, z, w, d} in hall metres - READ-ONLY use; GYMCAP1B is editing ClubCapacity.gd in
  parallel, never touch it) and `ClubCapacity.people(...)`; for each placement draws the item's greybox with the SAME builder the training floor uses
  (`Godot/scripts/TrainingFloor3D.gd` shape match ~1121 / `_build_prop` area; `TrainingFloorLayout.DEVICES[id]` has size/shape/zone; fallback box for ids
  without a shape) tinted by its zone colour (`TrainingFloorLayout.ZONE_COLOURS`), centred in its rect.
- NEW `Godot/scripts/club_capacity/ClubCapacityPlate.gd` (`extends Control`): a UI plate (bottom-left, over the HUD, readable at 1280x720): title
  "TIER T2 - CAPACITY", a two-column list "Heavy bag 24 ... " grouped by category (strength, cardio, bags, mats, recovery), then three big numbers:
  FIGHTERS AT ONCE, MEMBERS AT ONCE, TOTAL (from `people()`), a small italic note "row packing, a lower bound". Scrollable if long; UIKit style as the other
  HUD plates (`UIKit.tip` for hovers, never tooltip_text).
- `Godot/scripts/GymClub3D.gd` (~2,000 lines - NEVER read whole; grep): ONE mount point beside `_club_zones_refresh()` (~1538): `_club_capacity_refresh()`
  with the switch pattern of `club_zones` (`_club_zones_enabled` ~1530, career flag or cmdline arg `club_capacity`), OFF = no node, tree identical. When ON:
  hide the existing station props/pads/routes/zones for the view (find how `_floor_view` hides things; only visibility, never delete), mount the
  view, mount the plate. Switching it OFF restores them.
- `Godot/tools/gym_floor_view_stills.gd`: no edit - pass the switch on the command line (see its header). Add NEW `Godot/tools/club_capacity_stills.gd`
  only if the stills tool cannot show the plate (then copy its structure).
- NEW `Godot/tests/club_capacity_view_test.gd`.

## Prior research
- `python Tools/prior_research.py gym capacity floor stations packed` first; GYMCAP1_REPORT.md (the numbers), TASK_GYMCAP1B.md (landing in parallel: fields may be
  added to `full_mix`/`people`, e.g. supervised slots, categories - read with `.get(key, default)`, never assume they exist).
- Operator rules: bright gym art; stills ONLY on the game camera via the existing stills tool; both men N/A here; NOTHING opens on his screen.
- Hall size from `assets/data/gym_tiers.json` tier T2 (30 x 18 m); the hall in the scene is 30 x 18 (HALLSIZE1).

## What would a human do?
Hold up the catalogue against the floor plan: line every machine up in rows with aisles, label the zones, and write the head-count on the wall.

## Spec
1. `ClubCapacityView.build` places one greybox per placement; the count of child nodes equals `sum(counts)` (derived), none outside the hall rect, none
   overlapping the reserved ring (the module already guarantees rects; the test re-checks from the nodes' own positions).
2. The plate shows, for every category, the count per item id from `counts` (display_name from the catalogue), and the three people numbers from `people()`.
   Numbers on the plate must equal the module output exactly (test reads both).
3. Switch OFF: nothing mounted, existing props visible; ON then OFF restores visibility (assert node visibility flags).
4. Do NOT add `club_capacity` to DEMO_SWITCHES; do not change career data, saves, stations, or the ring.

## Done (tier: script edited - parse, focused test, related runs, stills)
- Parse gate: `python Godot/tools/check_scripts.py <every touched/new .gd>`.
- `club_capacity_view_test.gd`: RED first on master (no view -> fails; paste the count), then green; two different tiers (T1 and T3 halls) build and
  differ; control arm: with the ring-sized hall of 4 x 4 m the view places 0 nodes and the plate says so.
- `python Godot/tools/run_tests.py --only club_ --jobs 2`, `--only gym_floor --jobs 2`, `--only club_capacity --jobs 2` -> 0 fails.
- STILLS (visual): on the game camera via `Godot/tools/gym_floor_view_stills.gd` (header has the godot_hidden.ps1 command; add `club_capacity` to the switch
  list) -> `previews/gymcap2/01_full_1920.jpg` and `02_full_1280.jpg`. You cannot see images: report geometric checks only (placements in
  hall, plate text) and the file paths; Claude opens them.
Final message: red count, green results, still paths, the plate's numbers for T2.

## The one trap
The scene's hall origin and the packer's origin differ (the packer works in hall metres from the north-west corner inside the wall margin; the club's
world origin is its own). Convert once in `ClubCapacityView.build` using the same offset the club uses for station zones (`Club.zone_rect`, `Club.height_at`)
and assert it with one station that exists in both (the ring: its rect from gym_club.json must land where the packer reserves 8 x 8 m).
