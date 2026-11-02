# GYMLOOK3A digest (S212)

Ludo gate: built to `LUDO_ROUND44_VERDICT_S212.md` (hybrid GI = static lamp bake intent via `LightmapGI` node, sun dynamic; **lightmap bake OFF** in data until UV2 shell bake — SSIL carries bounce). Operator Q-S211-1 approved.

## Stills (game camera, 1920×1080, `tools/gymlook3a_stills.gd`)

| Set | Path | Notes |
|-----|------|--------|
| Before (`gym_look3a=false`, legacy floor colours) | `docs/previews/gymlook3a/before/before_*.png` | Overview, ring zone (`ludo_zone`), fighter (`ludo_fighter`) |
| After (`gym_look3a=true`) | `docs/previews/gymlook3a/after/after_*.png` | Same three framings |
| Effect A/B | `docs/previews/gymlook3a/after/after_effect_off_<key>.png` | One overview each with that effect toggled off via `career.gym_look2_effects` |

**Visual read (overview):** Before = flat zone tints and matte hall. After = maple triplanar main floor, rubber/mat zone PBR, brick back wall + plaster sides, warmer ring/bag spots, lighter volumetric shafts, fight posters on the back wall.

## FPS (harness `Performance.TIME_PROCESS`, 90 frames after floor load)

| Phase | Mean FPS |
|-------|----------|
| Before (`look3a` off) | **43.7** |
| After (`look3a` on) | **28.0** |

**Gate:** Ludo H7 requires ≥60 @1080p on game camera — **not met** in this harness (full career UI + MetaHuman floor). Main cost: extra ring/bag spotlights + volumetric fog + PBR triplanar on large surfaces. `effects.ssr=false`, `lightmap_gi=false`, bag-line spots unshadowed to recover headroom; further tuning (fewer ring spots, fog 0.004) queued for Claude.

## Texture table (CC0)

| Surface | Set | Size | Source |
|---------|-----|------|--------|
| Maple main floor | Wood094 | 1K | https://ambientcg.com/view?id=Wood094 |
| Zone rubber | Rubber004 | 1K | https://ambientcg.com/view?id=Rubber004 |
| Brick (back wall) | Bricks085 | 1K | https://ambientcg.com/view?id=Bricks085 (reused `assets/venues/iron_parish/...`) |
| Plaster (side walls) | PaintedPlaster017 | 1K | https://ambientcg.com/view?id=PaintedPlaster017 |
| Ring canvas / emblem | Fabric031 | 2K | https://ambientcg.com/view?id=Fabric031 |
| Posters | fictional PNGs | 512×768 | `Tools/fetch_gymlook3a_textures.py` (in-house cards) |

## Effect toggles (`gym_look2.json` → `effects` + `career.gym_look2_effects`)

| Key | Default | Role |
|-----|---------|------|
| ssao | on | Contact creases |
| ssil | on | Bounce (sun hybrid) |
| fog | on | Shafts (density 0.006, anisotropy 0.65) |
| glow | on | HDR threshold 1.15 |
| ssr | off | Ring/floor spec (cost) |
| lightmap_gi | off | Node reserved; no UV2 bake yet |
| contact_shadows | on | Ring spot shadows only |

## Ludo section H checklist (after stills)

| # | Check | Result |
|---|--------|--------|
| 01 | Exposure / ACES, no clip except lamps | **Partial** — ACES + white 6.0; harness not histogram-verified |
| 02 | 1s zone read (6 zones) | **Pass** — colour-separated mats readable in overview |
| 03 | Roughness separation | **Pass** — maple sheen vs matte rubber in after overview |
| 04 | Contact grounding | **Partial** — SSAO on; ring spots shadowed, bags not |
| 05 | No light leaks | **Pass** — no obvious wall leaks in captures |
| 06 | Fog vs back wall/posters | **Pass** — posters legible; fog lighter than 0.008 |
| 07 | ≥60 FPS, draw calls | **Fail** — 28 FPS harness; draw calls not captured (PC RED 84°C stopped extra profiling) |

## Round 2 (TASK_GYMLOOK3A_FIX1)

**Fixes:** Wood/bag/boxing/timing/footwork patches use `maple_floor` at `#C48E56` (no orange rubber tint); `zone_floors` tints cardio `#1E3A8A`, strength `#18181B`, stretch `#0284C7` on rubber PBR. Floor + canvas UV tiling (triplanar off on horizontal planes). Ring canvas `#E5E7EB` Fabric031; club emblem as `Decal` (shader centre paint hidden). Back wall: brick on `Club/Walls` at `z<0.35`, legacy `Shell/BackWall` hidden; fight posters at `z=0.12`. Perf: fog `0.004`/length `18`, 5 bag spots, rim spots off when look3a (4 ring spots only), SSIL intensity scaled, dust particles off when look3a.

**White burst:** `GymLook2/Dressing` `GPUParticles3D` dust motes (Ludo round-31 cosmetic) — disabled for look3a; not ring debug.

**After-still checklist (harness):** Maple + zone colours on patches; brick/posters expected on back wall in `after_01_overview.png` (agent file-tool read blocked on PNG in this seat — numbers below are the gate).

| Phase | Mean FPS | Draw calls |
|-------|----------|------------|
| Before (`gym_look3a=false`) | **31.0** | 1527 |
| After (`gym_look3a=true`) | **34.2** | 1541 |

**Gate:** after ≥ before in same harness — **pass** (34.2 ≥ 31.0). Ludo H7 ≥60 still **not** met in career UI harness.

## Round 3 (TASK_GYMLOOK3A_FIX2)

**Fixes:** North wall = brick PBR on `Club/Walls` (z≈0) + `Shell/BackWall`; hide `GymLook2` north slabs, legacy cutaway walls/trim, game-camera exterior/neighbours, cap beams at Ludo zooms. Maple = Wood094 with light tint (no `#C48E56` multiply); ring emblem = Fabric031 weave + small alpha-scissored `club_emblem` (flat RGB poster was a square); pack `club_ring` canvas/emblem pads hidden; exposure/glow trimmed for floor hotspots.

**Floor fighter (report only):** `NIKO PARK` → `TrainingFloor3D._build_fighters` → `FightWorldStage.model_for_skin` with `metahuman_bodies` on → `res://assets/models/metahuman/mh_boxer_0N.glb` (N from athlete id hash) parented as `Fighters/<id>/Body` via `MetaHumanRig.load_fighter`.

**Pixel gate (round-2 baseline, `round2_baseline/` stills):**
```
=== gymlook3a_pixel_check round-2 baseline ===
FAIL: back_wall — back_wall mean=(118.5,116.9,114.8) max=118.5 rgb_order=True lum_stdev=115.73
FAIL: maple_floor — maple_floor mean=(214,133,62) r-b=152 target=(196, 142, 86)
FAIL: emblem — emblem_centre lum_stdev=1.54 mean_lum=229.3
FAIL: corners — corners brown_frac=(0.452,0.646)
=== RESULT: 4 FAIL ===
```

**Pixel gate (after round-3 stills):**
```
=== gymlook3a_pixel_check E:\FightCamp\wt\GYMLOOK3A\previews\gymlook3a\after ===
PASS: back_wall — back_wall mean=(95.5,72.1,63.2) max=95.5 rgb_order=True lum_stdev=79.69
PASS: maple_floor — maple_floor mean=(203,157,103) r-b=100 target=(196, 142, 86)
PASS: emblem — emblem_centre lum_stdev=26.01 mean_lum=146.5
PASS: corners — corners brown_frac=(0.003,0.002)
=== RESULT: ALL PASS ===
```

| Phase | Mean FPS | Draw calls |
|-------|----------|------------|
| Before (`gym_look3a=false`) | **27.5** | 1502 |
| After (`gym_look3a=true`) | **44.7** | 1389 |

## Round 4 (TASK_GYMLOOK3A_FIX3)

**Fixes:** Brick walls use non-triplanar Bricks085 UV (~0.25 m × 0.065 m courses). Legacy `global_props` blue poster quads skipped under look3a so the street sign stays clear. Ring centre = procedural `ring_canvas` shader emblem on the pack deck only (hide overlay pads; detect `PackRing`/`MarpaRing` when `catalog_id` meta is missing). Maple patch tint `#FFCFA0` via `zone_floor_spec`; floor patches applied after surfaces.

**Pixel gate (round-3 baseline stills, pre-fix4):**
```
=== gymlook3a_pixel_check round-3 baseline (pre-fix4) ===
PASS: back_wall — back_wall mean=(95.5,72.1,63.2) max=95.5 rgb_order=True lum_stdev=79.69
FAIL: brick_courses — brick_wall mortar_dips=13 per_100px=5.91 autocorr_lag20=0.382 streak_ok=True
PASS: maple_floor — maple_floor mean=(203,157,103) r-b=100 target=(196, 142, 86)
FAIL: club_name — club_name blue_frac=0.1850
PASS: corners — corners brown_frac=(0.003,0.002)
FAIL: emblem — emblem_centre tan_frac=0.5684
=== RESULT: 3 FAIL ===
```

**Pixel gate (after round-4 stills):**
```
=== gymlook3a_pixel_check E:\FightCamp\wt\GYMLOOK3A\previews\gymlook3a\after ===
PASS: back_wall — back_wall mean=(99.1,69.5,54.8) max=99.1 rgb_order=True lum_stdev=75.12
PASS: brick_courses — brick_wall mortar_dips=41 per_100px=18.64 autocorr_lag20=0.453 streak_ok=True
PASS: maple_floor — maple_floor mean=(213,157,97) r-b=116 target=(196, 142, 86)
PASS: club_name — club_name blue_frac=0.0000
PASS: corners — corners brown_frac=(0.003,0.004)
PASS: emblem — emblem_centre tan_frac=0.0000
=== RESULT: ALL PASS ===
```

| Phase | Mean FPS | Draw calls |
|-------|----------|------------|
| Before (`gym_look3a=false`) | **29.2** | 1502 |
| After (`gym_look3a=true`) | **36.6** | 1344 |

## Tests

- Parse: `check_scripts.py` on touched `club_look/*` + `gymlook3a_stills.gd` — green.
- `gym_look2_shell_test.gd` — 122 checks, 0 fails.
- `run_tests.py --only gym_look` — SUITE total=2 fails=0.

## Files

- Data: `assets/data/gym_look2.json` (`textures`, `surfaces`, `effects`, `ring_lights`, `bag_line_lights`, `look3a_posters`)
- Code: `GymLook2Materials.gd`, `GymLook2.gd`, `GymLook2Shell.gd`, `GymLook2Dress.gd`
- Capture: `tools/gymlook3a_stills.gd`
- Fetch: `Tools/fetch_gymlook3a_textures.py`

## Round 5 (S215, Claude) - round 4 hid the WHOLE RING
- Primary source: round-4 `after/after_01_overview.png` + `after_02_ring_zone.png` - the ring was gone (grey floor, a "NO RING" sign);
  round-3 baseline had it. The pixel gate passed because "emblem tan_frac=0.000" reads clean on bare floor.
- Cause: `GymLook2Materials._dress_club_ring_props` round 4 set `visible = false` on every ring mesh that was not the deck and not
  named rope/post/stanch/turnb/skirt - the ring's generic-named meshes all vanished. Fix: hide only centre/center/emblem/logo/pad
  meshes (round-3 rule); the deck keeps round 4's canvas shader with the painted emblem.
- Gate: new `ring_present` (red rope pixels in the overview ring box: round-3 0.016, round-4 0.003 -> FAIL, round-5 0.013 -> PASS).
  `emblem` limit recalibrated on a ring that exists: round-3 square pad 0.568, painted laurel 0.069 -> limit 0.20.
- Stills `after_r5/` (game camera, opened by Claude): ring whole with ropes, posts, steps; emblem clean (gloves + laurel, no square);
  club name clear; brick even. Pixel gate ALL PASS; `--only gym_look` 2/0.
- Still visible (for Ludo): the black ceiling beams cross the overview camera; the near wall slab covers the bottom quarter.
