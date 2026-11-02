# S84 DIGEST - the training floor in 3D (training floor, step 2)
Claude, 2026-09-26. Roadmap `now` from S83: the 3D floor for gym tiers 1-2.

## Shipped (master, fc750d37 + the collection commit)
- **`TrainingFloorLayout.gd` (pure, zero preloads).** The save's floor -> metres (R66 cell 1.5 m, read back from
  GameState's own metre view). A catalogue footprint is the item's USE ZONE (R66: object plus clearance); the item is
  drawn at its **G113 device size inside it** (heavy bag 0.38 m in a 1.5 x 3.0 m zone). `cramped` flags every zone
  smaller than G113's real one (heavy bag wants 3 x 3) - the draw is honest; the catalogue footprints are NOT changed
  (balance call, see below). Tier presets: tier 1 "Back-room club" (doors street + office), tier 2 "<discipline> club"
  (+ locker room). Doors: street -> `fights_hub`, office -> `office_menu`, lockers -> `roster`.
- **Fighters** stand at their station's work point (in front of a bag, on a bike, on the canvas at ring height) with the
  planner's own gain (`preview_training_gain`, 1/7 of a week) as a **share of the next point: "POWER +5%"** - D28 said
  "+0.05 reads as nothing". A station with no stat gain names its drills ("DRILLING ACCURACY · DEFENSE").
- **The coach.** Pad work happens in the ring: a fighter on the ring today -> the head coach (best coaching rating) is in
  there with him "holding mitts for <name>"; nobody in the ring -> he waits in the mitt pocket at the locker. **Found:**
  `focus_mitts_locker` is an "analysis" item with NO training focus (`set_week_program_day` -> UNKNOWN TRAINING FOCUS),
  so nobody can be planned "on the mitts" - the design's mitt pocket needed this reading.
- **`TrainingFloor3D.gd`:** bright cutaway shell (walls cut to the knee toward the camera), zone floor colours (red
  striking, blue mats, grey iron, green cardio, wood recovery) with each station's name on the floor, a greybox per
  catalogue shape (ring with ropes, hanging bags on chains, speed-bag board, rack, bike, rower, mats, tub...), quality/
  wear tint, rigged fighters on the baked idle (lifted 0.925 m - the idle puts the hips at the origin, C208's figure),
  a **round clock** (3:00 work / 1:00 rest, `round_ended` bell signal, tags pulse at the bell), clickable doors
  (ray test), camera pans along wide floors.
- **`TrainingFloorPanel.gd`** on route **`training_floor`** ("THE FLOOR"), HOME fighters hub pin **"The floor"**.
- **Station motion:** the heavy-bag worker plays C212's `punching_bag_station` 0.835 m off a bag hung at C212's fitted
  1.40 m centre; the ring fighter plays `boxing_warm_up_station` (the two clips D27 read as real). Other stations idle.
- Renders: `previews/s84/tier1_floor.png`, `tier2_floor.png`, and an 8 s video `floor.mp4`, via
  `tools/s84_render_floor.gd` (hidden window; `-- movie` with `--write-movie`).

## Tests (subsets; the full suite is the nightly)
- `training_floor_3d_test` - 200+ checks, 0 failures: every owned item has a prop node at its cell with its device inside
  its use zone and a zone patch (tier 1 and tier 2), no use-zone overlaps, planned fighters in their station's zone with
  the planner's label, nobody off-plan drawn, coach holding mitts in the ring, doors route, clock rings. **Three mutants
  caught:** zones shifted a cell (many fails), a week's gain on the label (6), coach outside the ring (2).
- Subset (training_floor_3d, scene_router, menu_clarity, home_pin, smoke, career_loop, gym_hub, day_feed, ui_kit_shell,
  office_nav, training_legibility + hub): 22 tests, 0 failures after `scene_router_test`'s contract list gained the new
  route. Last nightly: 2026-09-26 at 9847dd13, SUITE total=416 fails=13 (AgentComms/nightly/latest.txt).

## Collected
- **D28 (Dola)** - training screens: HOME's day card is best, the Monday report worst; "+0.05 reads as negligible".
  Ruling: % of a point everywhere (floor done; HOME/planner/Monday report in S85).
- **G114 (Grok)** - U179's CC0 links mostly DO NOT EXIST as 3D props (Kenney sports = 2D tiles; ambientCG = materials).
  One pack: PixelPress MMA/Boxing Gym via Cubebrush, **$25, FBX/OBJ** (Fab/Unity licences allow Godot use). Raised to the
  operator; buy nothing without them. Greyboxes stand in meanwhile.
- **D29 (Dola)** - the floor itself: who/what readable; tie labels to equipment (done: station on every tag and zone);
  layout flow and "tier 2 should add capacity" -> step 4 presets.
- **U178B (Cursor)** merged (cd13ac91): the MMA leg boost applies only to kicks at long/mid range. Re-measured on master: C85 MMA
  leg share **13.6%** (band 12-18%), MMA footwork **16.1 m/min** (floor 12). `fight_realtime` reds = the six pre-existing judo
  rows only; `fight_scoring` red as before.

- **G115 (Grok)** - drill mastery: pips at 6/16/36/72/140 focused hours, +1.5/1.2/1.0/0.8/0.5% (S&C smaller); NO measured
  breakthrough rate exists - JUDGEMENT 6% at pip I-II, 2% from III, cutting the pip's remaining hours 25-40% (supersedes the
  design page's 8-12% doubling). S85 builds on it.

## Assigned
- **G116 (Grok)** real gym floor incidents and their frequencies, for step 3's floor events.
- **Q186 (Qwen)** launched in Temp/FightCamp-Q164.

## Decided, not built
- Catalogue footprints stay (economy unchanged); `cramped` is visible data for the step-4 preset/capacity pass.
- Speed bag and skipping clips (D27: miss / barely) -> **U180 (Cursor)**, launched S84.
