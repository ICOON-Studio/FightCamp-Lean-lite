# U177 — Option B (2.5D hub rooms) in Godot: pipeline cost and floor sync

A management UI lead would keep the brass-and-leather chrome and the one-glance facts (next fight, cash, NEEDS YOU, roster pressure) untouched, insist that anything the player buys or assigns must show on the floor they manage, and refuse a second art language unless it stays cheaper to sync than tiered stills. For FightCamp today, that means **honour the S80 still hubs and the kit FLOOR tab’s data contract first**; treat full isometric B as a **GYM FLOOR renderer swap**, not a replacement for HOME or the three area pictures, until separate rooms (recovery, kitchen, dorms, film, media) exist in the save.

## Current state (what works, what breaks)

From `S80_DIGEST.md` and the shipped assets in `Godot/assets/images/SOURCES.md`: HOME and three area hubs are warm 3840×2160 Higgsfield stills with object pins; the shell and inner plates match M34 direction A. That matches Punch Club 2’s lesson (`S81_PUNCH_CLUB_2_SURVEY.md`): **objects in the picture should be the actions** — our pins already aim at that on HOME. What fails is **state honesty**: the same picture at three fighters and thirty, and after upgrades (`S80_DIGEST.md` known list). The GYM hub’s **FLOOR** tab is already honest: it is a live grid of stations, occupancy chips, and expansion — but it is **UIKit vector tiles** (`UIKit.floor_grid` / `station_tile`), not a room the player “walks.” HOME’s weights pin and the FLOOR mat can disagree because they are different surfaces.

## Option B in Godot — what the repo proves

**No 2.5D pipeline exists.** A repo-wide search of `Godot/**/*.gd` for `TileMap`, `Sprite2D`, and `AnimatedSprite2D` returned **0** matches. The training floor is drawn in `GymHubPanel._build_floor` → `UIKit.floor_grid`, which places `station_tile` panels on a rectangular grid from `get_gym_hub()`.

**Floor truth is already centralized.** `GameState.get_floor()` returns `width`, `height`, `room_tier`, and `items[]` with `position`, `footprint`, `catalog_id`, and condition. `get_gym_hub()` (GameState.gd ~13618) projects that into `floor.grid` `{w, h}` and `equipment[]` with `x`, `y`, `w`, `h`, `users`, and repair flags — the only shape `GymHubPanel` consumes. Expansion adds **2 columns** per purchase (`ROOM_EXPANSION_COLUMNS`), width cap **12** (`MAX_FLOOR_WIDTH`), height **5** on the starter template (`generate_starter_boxing_floor`: width **8–9** from RNG, height **5**). Cell size in the real world is **1.5 m** (`FLOOR_CELL_METRES`); max floor is **12×5 cells** (comment: **18.0 × 7.5 m**).

**Catalog size drives art enumeration.** `equipment_catalog.json` (version 2) lists **25** items in **6** categories; **20** are `store_available`. Footprints fall into **8** shapes; largest is **16** cells (`club_ring` **4×4**). Any B renderer must composite multi-cell pieces the same way `floor_grid` already does.

## Sprite pipeline cost table (repo-sourced counts; art sources named, not shipped)

| Deliverable | Count (source) | Godot work | Licence / source options |
|---|---:|---|---|
| Equipment station sprites (one visual per `catalog_id`) | **25** (`equipment_catalog.json`) | Map `def_id` → texture(s); multi-cell blit from `w`,`h` | **No gym isometric pack in repo.** CC0 candidates cited elsewhere: **Kenney** (CC0, UI/ generic — not a full gym set; `TASK_ARENA_ART.md`, J45). Custom commission or operator **Higgsfield** stills (commercial per `SOURCES.md`) baked to tiles — consistency cost, not a count. |
| Footprint shape templates | **8** (same file) | Layout rules already in `floor_grid`; B must not re-invent placement | Code-only |
| Rotation / footprint swap | persisted in save | **1** renderer must read rotated `footprint` from instance | Code-only |
| Occupied fighter tokens on stations | up to `station_capacity` per item (catalog) | Bind `equipment[].users` from hub read | Reuse portrait chips or **Quaternius**-style CC0 silhouettes (J45: CC0, not our faces) vs bespoke pixel people — **identity trade-off** |
| Training motion loops per station family | not enumerated here (Q179 lens) | `AnimatedSprite2D` or `AnimationPlayer` per family | RamsterZ fight clips ≠ exercise loops (`C208_HUB_DISPLAY_EVAL.md`); B needs **separate** cycles or static “working” poses |
| Room backdrop (training floor) | **1** grid width grows to **12** | Scroll or widen isometric base; tier **`room_tier`** has no visual hook today | **1** backdrop × tier variants if we mirror operator upgrade complaint — **ESTIMATE: 3–6** tiers if we match width steps (not authored in data) |
| HOME + area hub pictures (already shipped) | **5** JPGs (`SOURCES.md`) | Unchanged if B is FLOOR-only | Higgsfield Plus (documented) |
| Operator-planned **separate rooms** (HANDOFF Active claims) | **5** room types named | **5** additional room scenes + HOME pins each | Punch Club scales as **1 hand-painted room per place**; here **5×** room art + object animations if B — **ESTIMATE multiplier**, not in save schema yet |
| Hub chrome (shell, roster, store drawer) | existing | Keep; B sits inside FLOOR pane only | N/A |

**Sync rule (non-negotiable):** one read — `get_gym_hub().floor` — drives both the management grid and any B view. Purchase, move, rotate, repair, expand, and week-program `users` must invalidate the same rebuild path `GymHubPanel` already uses; do not mirror floor state in a second JSON or scene.

**Implementation sketch (greenfield):** `SubViewport` or layered `Node2D` with an isometric projection function `(grid_x, grid_y) → screen` fed by the same `equipment` array; picking via `Area2D` or color ID map; optional `TileMapLayer` only for empty floor cells. Godot 4.7 supports this, but **every line is new** — there is no template in-tree.

## Options A / B / C — B-focused judgement

| | Player | Cost to us | Scales with gym | Risk |
|---|---|---|---|---|
| **A** Stills + tier variants | Keeps M34 warmth; pins stay readable | **5** hubs already paid; tier swaps = more Higgsfield jobs (`~54 credits` cited S80 for first pass — **operator tool**, not re-run here) | Tier JPGs lag per-piece truth | Picture lies about individual stations |
| **B** 2.5D rooms | Punch Club–style “room is menu”; crowding and expansion visible on training floor | **25** station visuals + backdrop + loops + **new renderer**; **5** future rooms multiply art; **0** existing TileMap code | Grid width **8–9 → 12** is code-synced; backdrop art may not | Second look vs photoreal HOME; chibi sprites vs named fighters |
| **C** 3D engine | Same save truth as FLOOR tab; identity-preserving | Measured idle probe: **3** fighters **5.826 ms** mean frame interval (`c208_hub_frame_probe.gd`, includes readback) | Reuses rigs; exercise gaps remain | CPU/thermals when stacked (`S81_PUNCH_CLUB_2`: demo **93 °C** uncapped) |

B’s CPU edge over C is **unmeasured in this task** (no Godot run). For the operator’s **~87% CPU** constraint, static or lightly animated 2D is *likely* cheaper than live 3D, but that remains **ESTIMATE** until a headless/scene probe exists.

## Recommendation

**Do not bet the whole product on B.** Keep **A** for HOME and FIGHTERS / FIGHTS / FINANCE until separate rooms are real features. For the **GYM → FLOOR** tab, choose between **C** (spatial honesty, one engine) and a **narrow B slice** only if Maria rejects greybox 3D for the training room.

**First slice (one session, research follow-on build):** a throwaway scene that renders `get_gym_hub().floor` with **placeholder CC0 tiles** (Kenney or similar — licence row in `LICENCES.md` before ship) and **static** station sprites for the **10** items on the starter floor (`generate_starter_boxing_floor` spec list), wired to the same click handlers as `_on_station` / `_on_cell`. **Prove:** move `heavy_bag`, expand width **+2**, and see the backdrop and footprint update without a manual art pass.

**Kill criteria:** if tier/backdrop art cannot match M34 brass-and-leather HOME within one art pass, or if **5** satellite rooms each need a full Punch Club room, **fall back to A** with **tier stills + hotspot sync** (cheaper than maintaining **25** animated stations × tiers).

Parse gate: none (research). No shipped scripts edited. No HANDOFF block.
