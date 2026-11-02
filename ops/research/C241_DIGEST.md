# C241 — original glove assets

## Status

S146 run 4 (Claude): **DONE for the boxing glove on the demo rigs; one cosmetic caveat.** The approved CC-BY Sketchfab glove (Incg5764, `E:/FightCamp/incoming/sketchfab_boxing_glove_incg5764.glb`) replaces the authored boxing mesh. Credits in `Godot/assets/models/gloves/CREDITS.md` (+ `CREDITS.txt`, which the export filter packs). The in-game build still has NO credits screen: the CC-BY text must be shown somewhere before ship (open item).

- ONE closed mesh in metres (`build_sketchfab_boxing_glove.py`): 0.26 m cuff-to-front, front 0.16 m past the wrist (the old fist reach, so no hit distance moves), cuff 0.10 m down the forearm, 0.14 m x 0.125 m across (G80 lists 0.13 packed), 1,950 triangles, 44 KB, no textures. Cuff band = vertex colour; `CCFighterSkin._paint_whole_glove` paints fist/cuff per fighter with a small shader. Left hand mirrors depth. MMA and mitt keep the old Fist/Cuff meshes.
- What failed first (not repeated): splitting the glove into separately scaled Fist and Cuff tore it open at the seam (the white wedge in earlier stills was the hand showing through that tear), and decimating before welding the UV-seam vertices opened see-through cracks. The fit numbers came from stills of the posed hand, NOT from skinned-vertex dumps: `get_bone_global_pose()` read outside the skeleton update misses the FighterFist fold, and the dump's x side disagreed with the render.
- `FighterFist`: thumb now folds too (Metacarpal, Proximal, Distal at 0.05; fingers stay 0.3).
- Evidence (all opened): `docs/previews/c241/review/boxing_after_sheet.png` (close + broadcast, frames 0/30/59), `docs/previews/c241/zoom/cmp10.png` (both gloves, front/side/top, MPFB man), `docs/previews/c241/zoom_mh/cmp_mh.png` (same on the MetaHuman boxer: fronts clean).
- Caveat: from a grazing side/top angle a small thumb crease shows skin through the glove (MPFB left hand, MetaHuman both). Not visible from the broadcast and corner cameras; plug it if a close-up shows it.
- Tests: `cc_skin_contract_test` 76/0 (its `Fist` lookups now use the nominal fist centre point; the old `has_node("Fist")` was already stale), `fighter_gloves_both_corners_test` boxing/kickboxing/muay_thai/mma corners all ok, `ruleset_gloves_test` ok. `asset_manifest_test` still fails on 35 pre-existing room/crowd references (none about gloves); the glove folder is now claimed (`fight_gloves`).
- How Undisputed does it (metadata scan, nothing extracted, per R121): separate L and R skinned glove meshes of ~2,200 vertices, a 168-vertex hand-wrap mesh, strap-driver bones, and a per-fighter "Default Gloves P1/P2" object plus DLC gloves, so gloves are per-fighter assets there. Ours is one shared mesh recoloured per fighter.

## Result

Replaced the sphere-and-cylinder glove meshes in `CCFighterSkin._build_glove` with three small, original Blender-authored GLBs: boxing, MMA, and WKF mitt. The attachment function still returns a `Node3D` named `Glove_<side>`, takes the existing style spec, applies its same fist/cuff size and position values, and remains mounted through the existing hand-bone path. No caller, hand index, pose, sync, or style-spec values changed.

The asset source is `Godot/assets/models/gloves/build_gloves.py`; Blender 5.2.1 generated the GLBs. The exporter converts Blender Z-up to Godot Y-up. Boxing is a rounded padded shell with a thumb lobe and raised seam paths; MMA has a dorsal plate, four separated knuckle pads, thumb, and short strap; the mitt has a compact pad with separate finger channels. The mesh parts are material-overridden from the existing per-fighter spec at runtime.

## Dimensions and cost

The three meshes are normalized to the existing per-style spec scales and cuff reach, retaining the G80 envelope values: boxing 0.26 × 0.11 × 0.10 m with 0.15 m cuff; MMA 0.19 × 0.10 × 0.06 m with 0.08 m cuff; WKF mitt 0.16 × 0.10 × 0.055 m with 0.04 m strap. No scale constants were changed.

| Asset | Triangles per glove |
| --- | ---: |
| Boxing | 552 |
| MMA | 612 |
| WKF mitt | 546 |

## Provenance and review

The checkpoint checked the local asset tree but could not reach external catalogues. S144 completed a read-only public Sketchfab API search (`boxing glove`, downloadable models). Candidates included [Boxing Glove](https://sketchfab.com/3d-models/5b464201104949e09f77f2d1cf8b60c3), CC Attribution, 4,064 faces; [Boxing Glove](https://sketchfab.com/3d-models/58b8fd62214043149ec65c2e7436c2d0), CC Attribution, 2,226 faces; and [Vintage / Old boxing gloves](https://sketchfab.com/3d-models/b41079124d1e420d8549d088917b1dff), CC Attribution, 115,264 faces. These exceed the few-hundred-triangle accessory budget before any adaptation. No third-party model was downloaded or used. Retained the checkpoint's authored, original geometry.

Before/after stills use the same U208 tale-of-the-tape fighter pair, faceoff camera, guard-idle animation sample, and layout. The primitive baseline and replacement were opened for both styles:

- Boxing before: `previews/c241/boxing/before/variant_2_faceoff.png`
- Boxing after: `previews/c241/boxing/after/variant_2_faceoff.png`
- MMA before: `previews/c241/mma/before/variant_2_faceoff.png`
- MMA after: `previews/c241/mma/after/variant_2_faceoff.png`

The close renders show distinct boxing padding and wrist wrap, and the open-finger MMA/mitt pads. Animated boxing captures at frames 0001 and 0059 show the glove moving with the hand during the two-second live animation path; the mount object is retained for the full render to preserve `CCFighterSkin`'s skeleton listener. A valid broadcast-distance comparison was not obtained: the U208 full-height/broadcast preview camera produced severely oversized/cropped fighter meshes in both render panels. The close stills are valid; broadcast-distance readability remains unverified.

## Checks and limits

- Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/CCFighterSkin.gd` — `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- Focused suite: `rtk python Godot/tools/run_tests.py --only ccfighter,glove,fight_stage,portrait --jobs 2` — `SUITE total=14 fails=3`. `fight_stage_technique_fidelity_test.gd` failed its fixture reachability assertion (`NEAREST` got 0); `fighter_gloves_both_corners_test.gd` and `fight_stage_realism_test.gd` timed out. Captured logs also report failure to read the root certificate store. No glove mesh assertion failure was reported, but the timed-out glove test is inconclusive.
- Superseded checkpoint health observation: sandbox-denied WMI is not a usable health clearance. S144 ran the watchdog outside the sandbox (GREEN, C: 56.8 GB free) and read CPU temperature through the installed LibreHardwareMonitorLib.dll because watchdog TEMP is unavailable. Added a session-local strict 80 C / 80 percent preflight; watchdog remains chained with && before every heavy command. A reading of 80.25 C blocked a render before launch. No watchdog bypass.
- The required initial `git fetch origin && git rebase origin/master` could not run because Git's shared worktree metadata under the main checkout is outside the writable roots. This worktree was supplied as fresh from master. No HANDOFF file was edited.

## S144 resume findings (in progress)

- Resumed checkpoint `bf8552af`; no regeneration of completed assets. Found and fixed a real integration defect: exported `FistTrim` and `CuffTrim` siblings lacked their parent part's scale/position. Copying each part transform keeps seam and wrap geometry on the glove.
- Reproducible review harness lives beside the assets: `review.gd` and `review_primitive.gd` (frozen parent-master primitive builder). It retains the overlay reference and reuses U208's generated fighter, FightStagePlayer idle, and FighterFist. It writes matched before/after samples at frames 0, 30 and 59, both close and broadcast distance, under `previews/c241/review/`. New images supersede the checkpoint's cropped U208 evidence.
- Opened boxing and MMA before/after at both distances. The new MMA knuckle pads are distinct; boxing has a shaped wrap instead of a cylinder. Boxing thumb fit is NOT yet accepted: a body thumb protrudes through both baseline and replacement. Character skin also renders white in this compatibility-renderer harness; this is not a skin-material quality gate.
- Both styles logged identical before/after glove transforms at each sample, with changing transforms across the three idle samples: attachment math is unchanged and animation following occurs.
- Parse after transform fix and harness: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0`. Ruleset glove focused test: `SUITE total=1 fails=0`. The both-corners retry was deliberately terminated when temperature telemetry became unavailable, not counted as a product failure or pass. Cached affected subset remains `SUITE total=14 fails=3`; prior two failures are still unresolved.
- Latest strict thermal gate blocked at 80.25 C; polling at two-minute intervals. Other agents' engine processes were observed and left untouched.

### Resume checkpoint evidence

- Original mesh triangle counts verified directly from GLB index accessors: boxing 552, MMA 612, mitt 546. First S144 boxing refinement exported in Blender 5.2.1 and imported successfully (thermal peaks 68.0 C and 69.9 C respectively).
- Boxing-only hidden render completed (`C241_REVIEW complete`), peak 77.3 C. New boxing after close frames 0 and 59 were opened along with MMA frame 59. Thumb protrusion remains, so the visual gate is explicitly NOT passed.
- Thumb bone positions in the unchanged glove-local frame were measured: proximal `(0.048054, 0.053290, +/-0.026696)`, distal `(0.069082, 0.080885, +/-0.046287)`. A further source refinement reserves normalized X bounds -0.8 to +1.2 for shell plus thumb (same total 0.11 m width); **this source revision is not exported yet**. Do not treat the current GLB as that revision.
- A persistent read-only feed was found at the already-running LibreHardwareMonitor `http://localhost:8085/data.json`; session-local preflight and runtime guard use CPU Tctl/Tdie plus CPU Total. Runtime guard checks every two seconds and terminates only the owned process tree at >=80 C or >=80 percent CPU or missing telemetry. Owned heavy jobs are restricted to one logical CPU, below-normal priority. Session helpers are in `.tmp/c241/` and are not game assets.
- Heavy jobs were blocked or terminated at 80.25, 80.4, 80.9, 82 and 88 C. No C241 heavy job remains running. Polls continue at two-minute intervals. A conservative 75 C start threshold leaves headroom; the operator's 80 C hard cutoff remains binding even when the shared watchdog labels higher readings AMBER.
- `git fetch origin` succeeded on resume. No rebase: the supplied worktree has thousands of unrelated import changes and a concurrently updated watchdog; they are preserved and excluded from C241 staging. No HANDOFF edits.

The historical pending-export next step above was completed in run 3 below.

## S144 run 3: final authored review and prefab referral

- Resumed `260cc7ab`; exported only boxing from the already-written thumb-fit source using Blender 5.2.1. Export reports **552 triangles**, then Godot import completed. No attachment code, spec constants, or other styles were changed in this run.
- Applied the operator's newer thermal instruction to session-local helpers: start below 82 C, stop at >=84 C only after three consecutive two-second readings. Kept the 80 percent CPU limit, missing-telemetry stop, below-normal priority and one-logical-CPU affinity. Watchdog AMBER is allowed; watchdog and preflight are chained with `&&` for every heavy step. Only the owned process tree can be terminated. Export peak 83.4 C; import peak 79.0 C; render peak 84.3 C was a transient spike, not three hot readings.
- Hidden `review.gd -- boxing_only after_only` completed with `C241_REVIEW complete`. Opened the new boxing close frames 0 and 59, boxing before close, both boxing broadcast frame 59 images, and MMA before/after at close and broadcast distances. The new boxing shell **still exposes white hand/thumb geometry** and the fist/cuff silhouette still reads too simply. The visual gate FAILS. This is the second refinement across S144; no third refinement was attempted.
- Frames 0, 30 and 59 logged different glove transforms, confirming animation following continues. This does not establish correct glove fit. Existing FBX read warnings and exit-time object leaks remain visible in the render log; skin renders white in this harness.
- **Best candidate among the checked listings: [Boxing Glove by Incg5764](https://sketchfab.com/3d-models/boxing-glove-5b464201104949e09f77f2d1cf8b60c3), [CC-BY 4.0](https://creativecommons.org/licenses/by/4.0/), 4,064 faces** (Sketchfab API `faceCount`, verified 2026-10-02). Opened its public preview: closed knuckle padding, integrated thumb and a distinct wrist wrap read much more clearly. It needs reduction and in-game fit validation to meet the few-hundred-triangle budget. This is a candidate, not an accepted game asset.
- Attribution chain: Incg5764 credits [Boxing Gloves - Left Handed by Gohar.Munir](https://sketchfab.com/3d-models/boxing-gloves-left-handed-076293541203455da59a38eea5b6a44b), also verified CC-BY 4.0, 85,592 faces. Preserve both credits if Claude/operator approve adaptation. The 2,226-face Just_som listing describes a glove-in-a-box prop, so it is a less suitable worn-accessory candidate. **No model/archive/texture set was downloaded.** Only public metadata and a listing preview image were inspected.
- Parse: `CHECK total=3 fails=0 autoload_refs=0 autoload_warnings=0` for the integration and both review scripts.
- Focused retries (each `--jobs 2`, one selected test): both-corners `SUITE total=1 fails=1`, 600-second timeout, peak 83.4 C; emitted passing checks for both corners in MMA, boxing, kickboxing and Muay Thai before timing out. Technique fidelity `SUITE total=1 fails=1`, `TOTAL=34 fails=1`: fixture NEAREST occurrence remains 0; 94 action beats, 64 named plays, 30 degrades, 0 substitutions, 8 distinct clips; peak 80.4 C. Realism `SUITE total=1 fails=1`, abnormal engine exit `4294967295`, peak 82.0 C; log ends in FBX `Reading less data than requested` warnings during setup, without a final assertion summary. Cause of that abnormal exit is unknown; it was not killed by this thermal guard. No assertions were weakened and no unrelated presenter/retarget code was changed.
- Read-only reclassification of the complete affected cached subset after those retries: **`SUITE total=14 fails=3`**. This combines 11 previously completed passes with the three current retries; it is not a new full-subset execution. No full suite was run. All owned heavy jobs finished and no C241 Godot process remained at the final process check. Run-3 logs remain in the ignored `.tmp/c241/` scratch folder.
- Workflow exceptions: no rebase across the dirty shared import/watchdog changes; no HANDOFF edits; retained the user-requested direct Blender export because optional `game-dev` CLI is absent. For focused retries, each runner uses `--jobs 2` with exactly one matched test so the newer one-heavy-job instruction takes precedence over the original concurrent-subset instruction. Previously completed passing tests are not repeated.

Next owner action: Claude asks the operator about the candidate before any model download or adaptation. Do not merge this authored glove as visually accepted.
