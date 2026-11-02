# GYMLOOK3B — S226 training floor

Branch `codex/gymlook3b`, based on `origin/master` at `0b5d697ad73b892ec9bd0c519c747bb04011f5f7`. The old `codex/profile2f` branch and OFFBAKE1B worktree were not edited. **Implementation delivered for Claude/operator visual review; visual acceptance remains OPEN.**

## Delivered

The ten TAKEN items from Ludo round 54 are implemented through the existing shipped look flags in `GameSwitches.GAME_ON`; there is no new opt-in switch.

1. A Ludo timer case with real red digits cycles 3:00 round / 1:00 rest. Four existing fight-card textures, each 0.9 x 1.2 m, flank it. The player's gym-name sign stays. The separate green 08:00 display remains the existing game-day clock.
2. The packed ring's built-in stairs were removed from a derivative GLB. Two 0.85 m-wide treads reach the actual 0.90 m apron. Two reused red stools and a hollow galvanised bucket sit below the apron corners. The original ring atlas/emblem survives.
3. 0.08 m charcoal strips edge the zone floor patches, with soft floor/wall contact gradients.
4. Faded 2.5 m drill squares, Ludo ball/rope rack, 0.45 m ladder rungs at 0.40 m spacing, and two speed-bag stands with 75 mm posts / 0.60 m drums. The original textured speed-bag pouch is retained in a cropped derivative.
5. Roof trusses are thin steel-grey, translucent and shadowless. Opaque ceiling housings are cut away from the overview, zone and fighter cameras; their lights remain active. Existing wall-mounted bag support beams stay visible.
6. Warm continuous bag-line strips and distributed fills replace bag spots; four neutral ring corner lights replace ring spots. Ambient fill and a local east-wall bench fill keep equipment readable. The first after capture revealed housings across the timer and floor; those were corrected and all four views recaptured.
7. Loaded rubber/mat roughness is 0.89; loaded canvas roughness is 0.94. Rubber roughness textures no longer override the requested value. The custom canvas shader preserves its original behavior outside the club override.
8. SSAO radius 1.2 / intensity 2.0, plus soft contact patches beneath racks, benches and treadmills.
9. The timer ticks independently of simulation RNG; exactly two actual heavy-bag meshes sway 0.75 degrees about their suspension point. Tests check real mesh transforms, not an empty animation node.
10. The reused locker bench holds two bottles and a pair of gloves on the east wall; a Ludo chalk stand sits by the platform. Moving the real dumbbell rack from x=28.0 to x=26.3 in both layout records leaves a measured 0.93 m bench gap. The existing duplicate-suppression path lets that rack serve the weights station; its training work and approach points remain unchanged. Main aisles and platform clearance are checked.

Room entry hides `ClubZones/Signs`, and exit restores it. No room furniture, art or layout was changed.

## Assets and credits

Six Ludo image-to-3D props, **27 / 28 credits** (3 image-reference credits + 24 model credits; no generation retries). All six pass <=5,000 triangles, <=1.5 MB, 1024-pixel embedded textures, bottom-centre pivots, actual vertex bounds and SHA-256 validation. The ROOMS3 1.2x size is baked into these models; instances use scale one. Prompts, provider IDs, receipts and licence provenance are recorded in `assets/models/props/gymlook3b/provenance.json`; validation beside it. See `GYMLOOK3B_ASSETS.md` and `../docs/previews/gymlook3b/models_check.jpg` for the 24-view asset inspection. Local bowl/bottle support repairs are recorded there; no extra credits were spent.

Ring derivative: Oxygen3D CC BY 4.0 attribution retained in `assets/models/gym_pack/CREDITS.txt`. Original source GLBs were preserved. No import cache deletion or `.import` churn.

## Red evidence and verification

The baseline red tests and four before stills ran on the freshly branched master source before production changes. Complete red lines are pasted in `GYMLOOK3B_RED.txt`; representative witnesses:

```text
FAIL: ladder rung width 0.45 m (actual 1.050)
FAIL: ladder rung spacing 0.40 m (actual 0.320)
FAIL: roof beam Truss_0 cast_shadow OFF
FAIL: SSAO enabled radius 1.2 intensity 2.0 (actual 1.85 / 2.40)
FAIL: rubber Patch_strength roughness 0.88-0.90 (actual 0.80)
FAIL: canvas roughness 0.94
FAIL: continuous strip fixtures replace bag spots
FAIL: bag sway amplitude 0.75 degrees
FAIL: floor labels hidden in room view
GYMLOOK3B: 24 checks, 21 failures
FAIL: pack's original front/back stair geometry removed (depth 7.907)
FAIL: ring has exactly two compact stair treads (actual 0)
GYMLOOK3B_GEOMETRY: 32 checks, 26 failures
```

After the first visual review, an additional red camera witness reproduced `FAIL: ceiling fixture Lamp_0 clears ludo_overview camera`; all ceiling fixtures now pass the three-camera visibility assertions.

- Touched GDScript parse gate: `CHECK total=14 fails=0 autoload_refs=0 autoload_warnings=0`.
- `gymlook3b_test.gd`: **148 checks, 0 failures**; `gymlook3b_geometry_test.gd`: **60 checks, 0 failures**. Focused runner: `SUITE total=2 fails=0`.
- `gym_hall_ring_steps_test.gd`: PASS after updating its obsolete four-tread expectation to the specified two treads.
- Restart focused runner: `SUITE total=3 fails=0` (`gymlook3b`, `gymlook3b_geometry`, `club_double_kit`). The recovered double-kit test now asserts that exactly the weights station is superseded by its real rack; all six checks pass, including the OFF control and frozen S205 witness.
- Bounded suite: **`SUITE total=71 fails=0`, runner exit 0**, using `python Godot/tools/run_tests.py --jobs 1 --only gym,club,look,zone,room --godot E:/FightCamp/tmp/gymlook3b/godot_guarded.cmd --verbose`. The wrapper checks the watchdog before every hidden-engine launch. Full per-test summary: `GYMLOOK3B_GREEN.txt`. Restart logs use `E:/FightCamp/tmp/gymlook3b/restart_temp/fightcamp_test_logs`; the default shared temp logs can be overwritten by other worktrees and were not accepted as branch-specific proof. No full suite was run.
- Independent GLB validator: all six PASS. Source review found no critical/important code issue; its missing loaded-canvas assertion was added. Visual assessment remains separate.

Production captures and the final restart gates use `godot_hidden.ps1`, with a watchdog before each launch and one job under AMBER. The interrupted suite had thermal-blocked launches and no final summary. Its shared cached logs were insufficient to close the task, so the bounded suite was repeated with isolated logs; all 71 passed, including no-teleport, room positions, ring bounds and walkout. The restart hidden parse gate passed all 14 touched scripts (`fails=0`, `autoload_warnings=0`, 252 seconds). Known teardown RID/resource messages are classified by the repository runner, not treated as mid-run script failures.

Restart source review found no critical or important issue in the recovered test/capture changes: the weights overlap matches both layout records and existing duplicate suppression; training work/approach data is unchanged, and `focus("weights")` uses the shipped camera. All six committed GLBs were rechecked against their provenance SHA-256 hashes. The eight saved game-camera stills and asset sheet were reopened as files; no generation or completed implementation step was repeated.

Local capture sample: before **27.1 fps / 1,447 draw calls**; final after **21.2 fps / 1,675 draw calls**. The earlier after attempt measured 25.7 fps / 1,707 calls. These are short samples on a busy, thermally constrained shared PC, not a controlled benchmark; the final sample is lower and does not establish a performance improvement.

## Game-camera review

Nine 1920x1080 PNGs live in `../docs/previews/gymlook3b/{before,after}/`: the four before/after pairs and a restart strength-zone supplement. Capture: `tools/gymlook3a_stills.gd -- as_game floor_review`, using the game's overview, ring zone, fighter and reception cameras. The supplement adds `strength_only` and uses the existing `focus("weights")` action. No custom beauty camera. The harness keeps the shipped look enabled in the baseline; its older effect-off passes are skipped only for this floor-review mode.

Each table covers the before and after still's ten Ludo items. A static image cannot prove ticking, sway, numerical shader values or hidden objects; runtime/geometry tests supply that evidence.

### 01 — overview

In frame: nearly the whole training floor, back wall, ring, east bench and one training fighter. Before: roof/lamp shadows make square dark patches; the east corner is dark. After: ceiling obstructions are gone, the bench and gear are lit, the fighter silhouette remains readable. No visible floating prop in the exposed floor. The front wall crops the chalk stand and the lower strength area; the second stool is largely hidden by the ring.

| Item | Before | After |
| --- | --- | --- |
| 1 Timer/posters | Green game clock; two separated fight panels; no red round timer. | Red 2:45 timer and four flanking panels. Existing tiny poster text is not legible at overview scale. |
| 2 Stairs/stools/bucket | Wide textured multi-tread stairs, no corner dressing. | Narrow two-tread stair and near red stool; bucket small; far stool hidden. |
| 3 Trims/contact | Abrupt untrimmed patch edges. | Dark zone borders and wall-foot darkening. |
| 4 Bag floor/ladder/posts | Bare bag strips, oversized ladder, old speed-bag boards. | White drill squares, ball rack, narrow ladder and steel stands. |
| 5 Roof | Square fixture silhouettes and floor shadows. | Roof fixtures cut away; no square floor shadows. Bag support beams remain. |
| 6 Lighting | Uneven support shadows and dark east corner. | Warm wall strips, readable back/east walls and gear bench. |
| 7 Materials | Canvas/rubber visible; numeric roughness cannot be read. | Matte ring and rubber visible; wood retains its existing sheen. |
| 8 AO/contact | Strong existing contact/shadow areas. | Rack/bench/treadmill grounded; strength floor stays intentionally dark. |
| 9 Life | No round timer; motion cannot be established. | Timer displays 2:45; sway cannot be established from one frame. |
| 10 Gear/chalk | No east gear bench or chalk stand. | Gear bench visible; chalk bowl at cropped lower edge, base not judgeable. |

### 02 — ring zone

In frame: ring/apron/stair, near stool and bucket, bag-wall fragments, cardio, partial lower zones. The fighter is clipped at the left edge by this existing ring-centred camera; judge full-body readability in 03. After: no ceiling bars cross the ring; the near stool and bucket have floor contact. The far stool and chalk/gear corner are out of frame. Shadows under the ring are appropriate; the staircase remains a simple two-tread mesh.

| Item | Before | After |
| --- | --- | --- |
| 1 Timer/posters | Mostly above the crop/HUD. | Timer lower edge and poster fragments only; use 01/03 to judge. |
| 2 Stairs/stools/bucket | Broad multi-tread block dominates the apron. | Two compact treads meet the apron; detailed stool and hollow bucket at near corner. |
| 3 Trims/contact | Unframed floor rectangles. | Borders clearly separate wood, grey aisle and rubber. |
| 4 Bag floor/ladder/posts | Bare bag strips; partial wide ladder. | Drill squares and ball rack visible; ladder only at lower edge, posts out of frame. |
| 5 Roof | Hanging black housing and square floor shadows. | No housing across ring or square roof shadows. |
| 6 Lighting | Ring visible with strong opaque fixture shadows. | Ring and apron readable; rope shadows remain natural. |
| 7 Materials | Original emblem and textured canvas. | Emblem preserved, matte canvas; no plastic highlight introduced. |
| 8 AO/contact | Existing apron/cardio shadowing. | Stool/bucket/ring visibly grounded; treadmill foot contact visible at right. |
| 9 Life | No live round timer in crop. | Timer mostly cropped; static bags cannot establish movement. |
| 10 Gear/chalk | Out of frame. | Out of frame; no claim from this still. |

### 03 — training fighter

In frame: whole fighter, boxing floor, left bag line and rack, speed stands, timer/sign, near ring corner. After: head, hands and feet remain unobstructed and readable, timer digits clear, no dark wall zone. No visible floating stool, bucket or rack. East gear/chalk and staircase are out of frame. Existing slip-rope posts and wall support shadows remain.

| Item | Before | After |
| --- | --- | --- |
| 1 Timer/posters | One sparse red panel; no round timer. | Red 2:41 digits clear, two adjacent posters and a partial panel; gym name preserved. |
| 2 Stairs/stools/bucket | Ring edge only, no corner props. | Detailed stool and hollow bucket visible at lower right; steps/far stool out of frame. |
| 3 Trims/contact | Bare wood boundary. | Thin dark border around boxing floor and bag strip. |
| 4 Bag floor/ladder/posts | Unmarked bag strip; oversized wooden boards. | Drill squares, ball/rope rack and two steel-post/drum stands; ladder out of frame. |
| 5 Roof | Roof cutaway already clears this close camera. | Still clear; the new ring fixture no longer crosses timer digits. |
| 6 Lighting | Wall visible, heavy speed-board shadows. | Continuous warm strips, readable fighter and wall; reduced board-shadow mass. |
| 7 Materials | Wood sheen and ring edge. | Existing wood sheen retained; ring edge matte. Rubber mostly out of frame. |
| 8 AO/contact | Bag shadows and fighter floor contact. | Ball rack, stool and bucket contact visible; no new floating object seen. |
| 9 Life | No timer; still cannot prove motion. | Timer differs from overview at a later capture time; exact phase/sway checked at runtime. |
| 10 Gear/chalk | Out of frame. | Out of frame; inspect overview/models and clearance evidence. |

### 04 — reception room

In frame: reception counter, trophy cabinet, room bench, board, pendants and coat rack. No fighter is in frame. The after image is substantially brighter because the hall environment's ambient fill is shared; board/cabinet detail is now readable. Existing props remain grounded, with no new clipping seen. Hall signs are absent, but the hall is outside this camera's main view in both images: the room-entry/exit test is the decisive label regression evidence.

| Item | Before | After |
| --- | --- | --- |
| 1 Timer/posters | Hall back wall out of frame. | Hall back wall out of frame. |
| 2 Stairs/stools/bucket | Hall out of frame. | Hall out of frame. |
| 3 Trims/contact | Room floor and wall junction visible. | Room geometry unchanged; hall trims out of frame. |
| 4 Bag floor/ladder/posts | Out of frame. | Out of frame. |
| 5 Roof | Room's own pendants visible. | Room pendants retained; hall fixture cutaway does not remove them. |
| 6 Lighting | Dark board/cabinet side and floor zones. | Brighter board/cabinet and floor; no black room zone. Shared ambient effect requires operator review. |
| 7 Materials | Existing warm wood/metal. | Same room materials; brighter exposure of detail. Hall material values not judgeable here. |
| 8 AO/contact | Strong room prop/wall contact. | Contact/shadows retained with softer perceived contrast. |
| 9 Life | Hall out of frame. | Hall out of frame. |
| 10 Gear/chalk | Existing reception bench only. | Existing reception bench unchanged; new gym gear bench is elsewhere. |

### 05 - strength-zone supplement (restart)

In frame: strength floor, rack, platform, gear bench, cardio, right bag line and part of the ring/stairs. No fighter is in frame. The two bottles and pair of gloves read clearly on the lit east-wall bench. The rack and bench have visible contact; the dark rubber retains some shadow detail. The front wall hides the chalk stand and crops the platform's near edge. The white/red wall bars visually cross the bench from this angle, but transformed mesh bounds leave 0.138 m between their nearest Z faces (bench ends at 14.180; wall bars begin at 14.318). The gear set rests at the bench top, Y=0.594. No production geometry was changed in the restart.

| Item | Observation |
| --- | --- |
| 1 Timer/posters | Back wall is cropped; no claim from this still. |
| 2 Stairs/stools/bucket | Two narrow treads visible at left; corner dressing mostly cropped. |
| 3 Trims/contact | Charcoal borders separate cardio, bag line, aisle and strength floor. |
| 4 Bag floor/ladder/posts | Right drill squares visible; ladder and speed stands out of frame. |
| 5 Roof | No ceiling housing obscures the strength equipment. |
| 6 Lighting | Gear lit clearly; dark rubber by wall bars remains dark, with visible rack/contact shadows. |
| 7 Materials | Matte strength/cardio floor; numerical roughness established by tests. |
| 8 AO/contact | Rack feet and bench base appear grounded; platform partly cropped. |
| 9 Life | Static right bags; timer out of frame, so neither motion nor timing proved here. |
| 10 Gear/chalk | Two bottles and gloves visible on bench; chalk entirely hidden by front wall, judged only in the asset sheet/geometry evidence. |

## Delivery and remaining review

S226 review board: [local review page](http://127.0.0.1:8787/review), batch `E:/FightCamp/review/2026-10-16_0102_gymlook3b_floor_review_including_strengt`, **10 files posted and manifest verified** (nine game-camera PNGs plus asset sheet). It supersedes the earlier nine-file batch. Claude should open every still and show the ten-item comparison back to Ludo. The operator closes the visual gate. In particular, judge the shared reception brightness, simple stair finish, sparse existing poster art, and limited chalk visibility from the shipped floor camera. This is not a claim of operator acceptance or a controlled performance pass.

General rule adaptations: the explicit new branch replaced rebasing the old branch; task jobs=1 unless GREEN replaced the generic parallel preference; the bounded suite replaced a full-suite habit; assigned art direction and generation approval replaced redundant design/provider approval questions. The authorized Ludo CLI/ROOMS3 normalization workflow replaced the generic asset-provider route. Existing untracked PROFILE2E outputs were preserved and excluded; no other worktree was touched.

Restart delivery: retained and pushed the recovered duplicate-kit test (`be19b415`), strength-camera harness/still (`eb67bccc`), and plan/digest checkpoint (`be0092dd`). Final documents add the completed bounded gate and Claude handoff. The restart instruction superseded the original new-branch instruction: work continued on `codex/gymlook3b`; no rebase, master edit, completed generation, or production-code step was repeated. The requested branch push/handoff supersedes the branch-finishing skill's integration menu; no merge or worktree deletion is requested.
