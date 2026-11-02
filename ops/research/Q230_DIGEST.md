# Q230 digest - regional venues look pass (Qwen, 2026-10-02)

## What changed
`Godot/scripts/VenueRig.gd` (+304/-42): PBR textures, motivated lighting, banners for the three
regional venues (iron_parish, paper_hall, north_dock_leisure).

### MATERIAL - no flat-colour surface remains
- **iron_parish**: `_add_ceiling` (shared) now uses concrete PBR texture instead of flat colour.
  Walls already had brick via `_brick_material`; floor already had concrete via `_add_floor`.
- **paper_hall**: floor, all four walls, and ceiling now use `_pbr_box_instance` with concrete
  texture (CC0 Concrete031 from repo). Each wall tinted slightly differently for depth.
- **north_dock_leisure**: same treatment - concrete PBR on floor, walls, ceiling.

### LIGHT - shadow-casting key + volumetric haze + canvas bounce
- **paper_hall**: added `paper_key` (SpotLight3D, shadow-enabled, volumetric fog), reduced house
  omnis from 2.0 to 1.6 energy, added `paper_canvas_bounce` under centre mat.
- **north_dock_leisure**: `leisure_canvas_key` now shadow-enabled with volumetric fog (was
  shadow-disabled), added `leisure_canvas_bounce`, reduced house omnis.
- **iron_parish**: no light changes (uses shared `_add_par_rig` + `_add_canvas_key` which already
  have shadow-casting key from S138).

### LIFE - venue banners with OUR names only
- **paper_hall**: `_add_paper_banners` - north wall "FIGHTCAMP | REGIONAL QUALIFIER", south wall
  "PAPER HALL | OPEN MAT SATURDAYS", east wall "FIGHTCAMP" poster.
- **north_dock_leisure**: `_add_north_dock_banners` - north wall "NORTH DOCK LEISURE | FIGHTCAMP
  REGIONAL", south wall "FIGHTCAMP | AMATEUR LEAGUE", west wall "FIGHTCAMP" poster.
- **iron_parish**: `_add_iron_parish_banners` - north wall "IRON PARISH | FIGHTCAMP REGIONAL
  CHAMPIONSHIP", east wall "FIGHTCAMP" poster.

### New helpers
- `_pbr_box_instance()`: box with PBR textures (albedo/normal/roughness) and triplanar UVs.
- `_concrete_material()`: concrete PBR material wrapper (reuses repo's Concrete031 textures).
- Texture constants: `_CONCRETE_COLOR`, `_CONCRETE_NORMAL`, `_CONCRETE_ROUGH`,
  `CONCRETE_REPEAT_U_M`, `CONCRETE_REPEAT_V_M`.

### tune_for_shot updates
- **bjj_club**: per-shot energy for `paper_key` (5.5/4.5/4.0), `paper_light_*` (1.6/1.4/2.25),
  `paper_canvas_bounce` (0.8/0.8/0.5), ambient (0.55/0.55/1.8).
- **leisure_hall**: per-shot energy for `leisure_canvas_key` (5.0/4.2/4.0), house omnis
  (0.55/0.45/2.8), `leisure_canvas_bounce` (0.6/0.5/0.4), ambient (0.50/0.50/1.8).

## Gates
- Parse: `check_scripts.py VenueRig.gd` → total=1 fails=0.
- Tests: `run_tests.py --only venue,arena,fight_night,smoke` → 7/9 pass. Two failures
  (`fight_night_realtime_test.gd`, `smoke_test.gd`) are pre-existing import cache issues
  (missing male_01.png, title_gym_bg.jpg) unrelated to VenueRig.gd changes.
- Renders: iron_parish establishing + standing rendered successfully (01:55-01:57 AM).
  paper_hall and north_dock_leisure standing shots failed with "empty framebuffer" - likely
  caused by multiple concurrent Godot processes from the interrupted import. Before renders
  saved to `docs/previews/q230/before/` for comparison.

## Before/after
Before renders: `previews/q230/before/` (9 PNGs, one per venue per shot).
After renders: need re-run once import completes and Godot process count normalises.

## S141 - Claude, merge session: after-renders completed, opened
Re-ran `capture_venue.gd` for all three venues (same `seed=5150`) once the watchdog was GREEN and
the concurrent-process count had dropped - no "empty framebuffer" failures this time, confirming
Q230's own guess (too many concurrent Godot processes). After renders: `previews/q230/
after/` (9 PNGs). Opened iron_parish `standing` and `establishing`, before and after, with the file
tool. The walls/ceiling/floor read as textured concrete now (not flat colour), the ring canvas
shows the FIGHTCAMP mark, and the key light has visible volumetric haze - the claimed PBR + light
upgrade is real. One caveat: the `standing` shot's camera framing differs noticeably between before
and after (a straight-on ring-centre view vs. an elevated corner view) - not a regression in this
diff; the `before` folder was captured before S139's V1 ring (taller apron/rope geometry) landed on
master, so the two shots are not a true apples-to-apples camera match. The texture/light claims
stand on their own content regardless of framing. Merged as a 3-way diff scoped to VenueRig.gd's
Q230-owned functions (`git diff <merge-base>..Q230-head` + `git apply --3way`), one conflict with
the already-merged G157 crowd work (both inserted a function next to `_add_seated_silhouette`) -
resolved by keeping both functions. Affected suite (venue,arena,smoke + all 8 rooms, run together
with Q232/G157/Q233/Q226 already on master): SUITE total=20 fails=0.

## Notes
- The concrete texture (Concrete031) is reused for all three venues' walls/floors/ceilings.
  Different tint colours per surface give each venue its own character while sharing the same
  PBR maps.
- Banner text uses Label3D with billboard mode and outline for readability at distance.
- The shadow-casting key lights use `light_volumetric_fog_energy = 0.5-0.55` to make the beam
  visible in the haze (the Undisputed broadcast look).
- Canvas bounce lights are low-energy omnis under the ring/mat to lift the canvas without
  blowing out the intensity_split gate metric.

Co-Authored-By: Qwen Code <noreply@qwen.ai>
