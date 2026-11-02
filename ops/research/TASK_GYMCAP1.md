# TASK GYMCAP1 - how many of each station fit, and how many people the gym holds at once (capacity packer + report)

Model: Codex luna (medium). Worktree E:/FightCamp/wt/GYMCAP1, branch codex/gymcap1. Never master, never HANDOFF.md, never AgentComms/.
Operator S196 (verbatim): "i think it's better to add all available stations for each equipment so we can understand how many of each
equipment can fit and how many customers maximum and fighters can be at the same time in the gym". Step 1 = the numbers (pure module + report +
a stills tool). Showing the packed gym in 3D (a `club_capacity` switch) is GYMCAP2 - do NOT edit GymClub3D.gd (GYMLOOK1A is editing it).

## Owned files
- NEW `Godot/scripts/club_capacity/ClubCapacity.gd` (pure static, no nodes, no preload of game scripts except reading data files).
- NEW `Godot/assets/data/club_capacity_rules.json` (every constant named, with a `source` string each).
- NEW `Godot/tests/club_capacity_test.gd`.
- NEW `Godot/tools/club_capacity_report.gd` (prints the table, writes `research/GYMCAP1_REPORT.md`).
- READ ONLY: `Godot/assets/data/equipment_catalog.json` (id, category, `footprint` cells, `station_capacity` = athletes at once, `store_available`),
  `Godot/assets/data/gym_tiers.json` (T1 15x10, T2 30x18, T3 40x25, T4 60x31 m; `station_capacity`, `member_capacity`), and the metre sizes in
  `Godot/scripts/TrainingFloorLayout.gd` (~54-70: per-device `size` and `real_zone` [w, d] = the area one athlete needs, clearance included; grep
  `real_zone`; devices without an entry get footprint cells x 1.0 m + the same clearance rule - say which in the report).

## Prior research
- `python Tools/prior_research.py gym capacity occupancy members stations tiers` first; research/topics/gym_market.md (crowding, members),
  training_floor.md; Ludo R25/R28/R29 files in research (tiers, member loop, "450 m2 minimum start hall" = D45).
- The existing ring is 8 x 8 m with ropes (gym_club.json `ring`); the door side keeps `DOOR_WALL_MARGIN_M` 1.5 m; stations keep a 1.2 m walking gap.

## What would a human do?
Take the floor plan and the catalogue, cut cardboard rectangles of every machine at scale, and push them around the plan: first how many of ONE kind
fit (a hall of nothing but heavy bags), then a believable full mix. Then count heads: athletes training at once (sum of `station_capacity`), and the
most members the building may legally and comfortably hold (floor area per person).

## Spec
1. `ClubCapacity.max_copies(hall_w, hall_d, item_id, rules) -> int`: rectangle packing of the item's `real_zone` rects inside the hall minus wall
   margin and door margin, 1.2 m walking aisle between rows, the ring (8 x 8 m) reserved when the item is not the ring. Deterministic row packing
   is enough (no optimiser) - the report states "row packing, a lower bound".
2. `ClubCapacity.full_mix(hall_w, hall_d, catalog, rules) -> Dictionary`: every store-available item at least once, then fill the remaining area by
   a `mix_weights` table in the rules json (data), stopping at the hall limit. Returns counts per item, area used %, and
   `athlete_slots` = sum(count x station_capacity).
3. `ClubCapacity.people(hall_w, hall_d, mix, tier_row, rules) -> {fighters_max, members_max, total_max}`: fighters_max = athlete_slots capped by
   coaches available (rules json: 1 coach per N athletes, default from Ludo's member docs - cite the file); members_max = min(tier member_capacity,
   floor(hall area / area_per_person_m2)) with `area_per_person_m2` from the rules json (use the real-world figure for fitness/exercise rooms in the
   building codes you can find in prior research; if you cannot verify it, set 4.65 m2 (50 sq ft) and write `"verified": false`).
4. Report for T1..T4: table 1 = max copies of each single item per tier; table 2 = the full mix per tier (counts, % area, athlete slots);
   table 3 = fighters / members / total at once; plus the 3 largest surprises in plain words. Also a CSV beside the .md.
5. Pure data in, pure data out: same inputs -> same outputs (determinism asserted).

## Done (tier: a new test file + a new tool only - parse + that test)
- `python Godot/tools/check_scripts.py <every new .gd>`.
- `club_capacity_test.gd`: RED first on master (module missing - paste the count) then green: (a) hall of nothing but heavy bags: copies x area <=
  usable area and copies grow monotonically T1<T2<T3<T4; (b) no two packed rects overlap and all stay inside the hall (derived from the module's own
  placements, not copied numbers); (c) full_mix covers EVERY store_available item id in the catalogue (derived list); (d) athlete_slots equals
  sum(count x station_capacity); (e) the control arm: a hall too small for the ring item returns 0 for `club_ring` (cannot share the bug);
  (f) determinism: two runs equal; (g) people() never exceeds tier member_capacity.
- Run the report tool headless: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tools/club_capacity_report.gd` and commit the .md/.csv.
Final message: red count, green results, the 3 surprises, branch pushed.

## The one trap
`footprint` is in grid CELLS and `real_zone` in METRES; mixing them makes every hall look 2-4x too roomy. Use metres everywhere and assert the unit in
the test (a heavy bag zone is 3 x 3 m, not 1 x 2).
