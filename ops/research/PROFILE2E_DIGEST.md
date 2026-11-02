# PROFILE2E digest (S209)

## Shipped
- **Five full-screen tabs** in `ProfileOverview.gd`: OVERVIEW, TECHNIQUES (live `learned/total`), PERFORMANCE & CAMP, MEDICAL & BIO (live `WEAR %`), CAREER & CONTRACT. Tab bar uses Ludo widths; ~180 ms crossfade on tab body; elevated tab/panel styling via `ProfileTabsLayout.gd`.
- **`ProfileMedical.gd`** — four-box medical screen: left `BodyMapFigure` + injury list + career wear badge; centre-top diagnosis + approved stress bands (CALM 0–49 / STRAINED 50–79 / ON EDGE 80–99 / BREAKING 100) + weight/clearance; centre-bottom face viewport (3D when `load_models`); right treatment deck with confirm buttons emitting `treatment_action(gs_method, arg)`.
- **Merged tabs**: `ProfileTabHost._build_performance_camp` (camp summary + weekly schedule + learning column); `_build_career_contract` (record + contract side-by-side with clip hosts).
- **Stills**: `tools/profile2_stills.gd` → `previews/profile2e/` (all five tabs + injured/unhurt medical).

## Ludo elements omitted (no honest data / no GameState action)
- Invented staff names, treatment costs, recovery %, deload week scheduler, medical-hold issuer, head-coach office talk, cut-man scar repair as dedicated actions — not wired because `GameState` has no matching public methods (only `assign_recovery_station`, `assign_training`, `set_weight_cut_plan`, `act_on_weight_cut` for treatments shown).
- Diagnosis prose without a stored “doctor verdict” string — built from injury count, fatigue, clearance only.
- Rear anatomical view — wear list only (no separate back mesh art).
- Financial / ranking columns on career screen beyond what `ProfileTabsB` already renders in record + contract.

## Tests
- `profile_medical_bio_test.gd`: **PROFILE_MEDICAL_BIO total=947 fails=0** (5 tab names, injured/unhurt fixtures, stress band, blacklist, GameState `has_method` for treatment actions).
- `python Godot/tools/run_tests.py --jobs 2 --only profile`: **SUITE total=15 fails=0**.

## Round 2 (TASK_PROFILE2E_FIX)
- **Injured stills**: `profile2_stills.gd` applies `BodyReadiness.store_injury` + `Injury.build`, `area_wear`, stress, and weight-over-limit via GameState athlete record before capture; injured/unhurt JPEGs differ (196306 vs 178368 bytes this run).
- **Face box**: MetaHuman-only via `ProfileStage.build_face` + `FightWorldStage.model_for_skin(..., true)`; non-MH (e.g. women until MHNATIVE1) shows **NO SCAN**; portrait camera on head bone (~39° FOV).
- **Body map**: `AreaWear` band colours on all six regions, injury pins, separate rear silhouette (`BodyMapFigure.design_shapes_rear`).
- **Weight-cut copy**: diagnosis, clearance, and RECONFIGURE card agree — past safe line drops “CLEARED TO SPAR”; `NOT INDICATED` only when no cut is active.
- **PERF & CAMP**: empty-camp week-1→fight-night track + “NO BOUT BOOKED”; right column lists `TechniqueTree.next_to_learn` when nothing assigned.
- **Treatments**: taller cards with EFFECT rows; full-height scroll column.
- **Tests**: `profile` suite 15/15; `profile_stage_test` updated for MetaHuman rigs (no legacy boot attachments).

## Round 3 (TASK_PROFILE2E_FIX2)
- **One athlete, one rig**: overview portrait uses `ProfileStage.build_face` + `resolved_mesh_path`; `profile_stage_test` asserts path parity for three fixtures.
- **Portrait framing**: head-bone aim +4 cm, tighter FOV, hair/low-body meshes hidden in face portrait mode.
- **Wear honesty**: tab suffix `REGIONAL %`; medical shows `CAREER WEAR` and `REGIONAL LOAD` separately (`WeightCut.division_display` for banner division names).
- **Overview right column**: next bout or “NO BOUT BOOKED” + OPEN MATCHMAKER; last-3-weeks form lines (load, fatigue, composure, fight badges).
- **PERF & CAMP**: camp timeline squares fit inside panel; stills seed week program via `set_week_program_day`.

## Round 4 (TASK_PROFILE2E_FIX3)
- **Portrait meshes**: `_trim_portrait_meshes` keeps any mesh whose global AABB overlaps the head bone ±15 cm; hides only meshes entirely below the collar line (no blanket hair hide). Logs `PORTRAIT_MESH` per mesh in windowed stills.
- **Portrait metrics**: `ProfileStage.portrait_coverage_metrics` + stills/test `PORTRAIT_COVERAGE` lines (windowed run example: `ath_thailand_phuket_01_03 76.7%`, `real_rafael_aghayev 85.9%` vs ~0% on broken round-3).
- **Weekly schedule**: stills hire a coach (career country + cash floor) before `set_week_program_day`; `WEEK_READ ath_thailand_phuket_01_03 RING BAGS CARDIO RING STRENGTH REST REST`.
- **Training load line**: overview “LAST 3 WEEKS” uses `GameTraining.program_week_effort` from `ctx.week_program`, not legacy `training_focus` alone.
- **Composure bands**: labels via `FighterReadout.composure_band()` (post-COMPOSEBANDS1 names); profile suite 15/15.

## Round 6 (TASK_PROFILE2E_FIX5)
- **Eye-level portrait**: `_eye_world_position` (FACIAL eyes or head + 7 cm); lower `lift` vs b9cc86be crown shot; `_portrait_place` fixes GDScript lambda capture so distance nudges apply; grid + nudge + chin tuck.
- **PORTRAIT_FACE v2**: `pitch_deg` (|pitch| ≤ 5°), hair crown offset 0.452 m, chin ≤ 72%, top 6–14%, MSAA 4× + TAA on face `SubViewport`.
- **b9cc86be FAIL (new gate)**: `PORTRAIT_FACE bruno_moreau top=39.0% chin=77.1% pitch=-38.2 … ok=false` (crown-down framing).
- **PASS (this run)**: `PORTRAIT_FACE bruno_moreau top=13.8% chin=71.5% pitch=-5.0 … ok=true`; `PORTRAIT_FACE niko_park top=13.9% chin=71.6% pitch=-5.0 … ok=true`.
- **Stills log** (overview/medical viewport ~460×440): `PORTRAIT_FACE ath_thailand_phuket_01_03 top=15.7% chin=77.9% pitch=-4.9 ok=false`; `real_rafael_aghayev top=16.6% chin=78.9% pitch=-5.0 ok=false` — Bruno/Niko gate green in `profile_stage_test` at 420×440.
- **Tests**: `python Godot/tools/run_tests.py --jobs 1 --only profile` → **SUITE total=15 fails=0**.

## Round 5 (TASK_PROFILE2E_FIX4)
- **Portrait aim**: `_set_camera("portrait")` looks at the face (head + ~5 cm), not chest (`look_at` −34 cm on 979f0668); FOV 28°, stature/wide-viewport yaw, iterative nudge to satisfy `portrait_face_metrics`.
- **PORTRAIT_FACE** (replaces coverage-only gate): projects head top / head / chin; PASS needs in-frame landmarks, headroom, span 35–75%, head centred (30–70% x), chin cap scales with aspect (`74 + aspect*6`). Chest framing proof: `bruno_moreau_chest_proof … ok=false` (979f0668-style aim) while live portrait `ok=true`.
- **Stills (this run)**: `PORTRAIT_FACE ath_thailand_phuket_01_03 top=39.0% head=53.0%,58.6% chin=77.1% span=38.1% ok=true`; `PORTRAIT_FACE real_rafael_aghayev top=40.0% head=54.6%,60.2% chin=78.5% span=38.5% ok=true`. `WEEK_READ ath_thailand_phuket_01_03 RING BAGS CARDIO RING STRENGTH REST REST`.
- **Weekly schedule labels**: `ProfileTabsLayout._label_wrapped` + tooltip so long station names wrap in day columns (no mid-word clip).
- **Tests**: `python Godot/tools/run_tests.py --jobs 1 --only profile` → **SUITE total=15 fails=0**.

## Round 9 (TASK_PROFILE2E_FIX8)
- **Pixel gate**: `portrait_pixel_crown_pct` / `portrait_geometry_crown_pct` (posed skin vertices) replace bone `top_y_pct` for PASS when the viewport renders or headless supplies geometry; `profile_stage_test` passes `get_image()` windowed or geometry crown headless (dummy renderer trap avoided).
- **Face direction**: `portrait_face_direction_metrics` — eye-line vs nose (3D forward offset from eye midpoint); `face_ok` on log line; idle phase pick + neck/head level before framing.
- **Stills (windowed `profile2_stills.gd`, face box ~460×440, pixels from texture)**: **Bruno** `pixel_top=6.1%` eyes `41.7%` chin `56.2%` `face_ok=true` `ok=true` (headless test @460×440). **Niko** `pixel_top=6.5%` eyes `41.8%` chin `54.3%` `ok=true`. **Phuket** `pixel_top=7.7%` eyes `41.7%` chin `57.8%` `ok=true` (overview stills log). **Rafael** `pixel_top=10.7%` eyes `41.8%` chin `55.5%` `ok=true` (medical stills log).
- **Tests**: `profile_stage_test` **216/0**; `run_tests.py --jobs 1 --only profile,readout` → **SUITE total=17 fails=0**.

## Round 8 (TASK_PROFILE2E_FIX7)
- **Portrait gate at panel size**: `profile_stage_test` builds one rig per fighter, resizes the face `SubViewport` to `ProfileLayout` portrait rect plus 420×440 and 480×440; chest `look_at` proof stays `ok=false` (`bruno_moreau_chest_proof` etc.).
- **PORTRAIT_FACE v3**: eyes 35–42%, shoulders 80–97.5%, `head_pitch` (horizontal, −head.basis.z) ≤ 5°; log line includes eyes/shoulder/`head_pitch`.
- **Idle tuck fix**: `portrait_frozen` stops `FightStagePlayer` advancing on face viewports; `_apply_portrait_head_pose()` levels Neck/Head once before framing (portrait-only).
- **Stills** (`profile2_stills.gd`, ~460×440 face box): overview / techniques / medical re-shot. **Bruno (overview metrics)**: hair crown ~13% from top, eyes ~39%, chin ~63%, shoulder line ~86–90% (in frame). **Rafael (medical unhurt log)**: crown ~13%, eyes ~39%, chin ~63%, shoulders ~88%, `head_pitch=4.1`, `ok=true`.
- **Tests**: `profile_stage_test` **216/0**; `run_tests.py --jobs 2 --only profile,readout` → **SUITE total=17 fails=0**.

## HANDOFF
Cursor PROFILE2E_FIX7 complete on `cursor/profile2e`: portrait gate green at panel size (4 fighters × 3 sizes), frozen portrait pose + head level, stills + digest round 8.
