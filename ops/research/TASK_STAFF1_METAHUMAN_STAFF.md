# TASK STAFF1 - the gym's staff are clothed MetaHumans, not fighters in trunks

Model: Codex gpt-6-astra at MEDIUM (3D pipeline). Owner: Codex. Worktree `E:/FightCamp/wt/STAFF1`, branch
`codex/staff1-metahuman-staff` from master at launch. LAUNCH AFTER MH3 LANDS (same UE project, same seat; one UE
process at a time on this PC). Claude reviews and merges.

## Why (operator, verbatim)
S153: "do we need models for physios,coahes and trainers ?" -> asked which bodies -> "MetaHuman, clothed (Recommended)".
S152 on the MH2 video: "the metahuman look better". Decision D34.

## The problem (primary source - open with your FILE tool first)
`previews/q232/staff_s153.png`, `physio_s153.png`, `office_s153.png`, `locker_s153.png`, `mat_s153.png`,
`floor_s153.png`, `lobby_s153.png`. Every staff member is a FIGHTER body in fight kit:
- `COACH_MODEL := "f10_m_bare_heavy_rigged"` (`Godot/scripts/TrainingFloor3D.gd` line 47) - a shirtless heavyweight -
  is the head coach on the floor (TrainingFloor3D ~line 1402), the office owner (`Office3D.gd` line 16 OWNER_MODEL),
  the lobby desk (`Lobby3D.gd` ~line 439), the locker-room coach + cornerman (`LockerRoom3D.gd` ~352, ~394), the mat
  coach (`MatRoom3D.gd` ~264), the film-room coach (`FilmRoom3D.gd` ~856), the staff room's first seat (`StaffRoom3D.gd` ~385).
- `STAFF_MODELS := ["f09_m_bare_welter_rigged", "f11_f_bare_feather_rigged"]` (`StaffRoom3D.gd` line 29) - bare fighters.
- The physio is `FEMALE_MODELS[4]` = a female fighter in a sports bra (`PhysioRoom3D.gd` ~line 365).

## Build
1. FOUR clothed MetaHumans through the MH2 pipeline (`Tools/metahuman/mh2_build.py`, configs like
   `Tools/metahuman/mh2_boxer_0N.json`, Blender `mh2_glb.py`; read `research/MH2_DIGEST.md` and
   `research/MH1_DIGEST.md` "What failed / traps" FIRST):
   - `mh_staff_coach` - male, 50s, heavier build, grey hair: tracksuit (jacket + track pants) and trainers.
   - `mh_staff_trainer` - male, 30s, athletic: gym T-shirt + training shorts/joggers + trainers.
   - `mh_staff_physio` - female, 30s: polo or scrubs top + trousers + clean shoes.
   - `mh_staff_desk` - female, 20s: hoodie or club T-shirt + jeans (front desk / membership).
   Clothing = the MetaHuman Creator's own Outfits / garment assets (same Epic licence as the bodies, MH1 Licence
   section). Prefer a Creator outfit preset over hand-made meshes. If a garment is missing in the Creator, say which and
   use the nearest one - do not model clothes by hand.
2. Wire them in: a staff constant set in `TrainingFloor3D.gd` (COACH_MODEL's callers keep working) behind a NEW switch
   `metahuman_staff` that follows the demo-switch convention of `metahuman_bodies` (read `FightWorldStage.metahuman_bodies()`
   and copy its pattern): **leave its game default OFF** - the operator turns it on after he sees the stills.
   `TrainingFloor3D._add_body` must mount a MetaHuman path through the MH loader (`MetaHuman.load_fighter`, as
   `FightWorldStage.mount` does), on the room's calm idle and seated idle clips (MH3 folds the room clips - reuse it).
3. Each staff body stands on the floor at a human height (coach ~1.78, trainer ~1.80, physio ~1.68, desk ~1.65 m) and
   sits on its seat with no body part inside the furniture (operator S153: "stop putting humans inside the objects").

## Acceptance
- Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <files>`.
- `Godot/tests/room_body_scale_test.gd` (S153, append - do not rewrite): add the four staff GLBs to the population with
  the switch ON; the same bands (hips->head 0.42-0.68 m; standing head 1.40-1.75 m and feet 0-0.075 m; seated feet at
  the seat datum) -> 0 failures, AND a mutant (staff mounted without the MH loader) that reads FAIL. Then the existing
  room tests one by one: room_click_marks, office_room, staff_room, physio_room, locker_room, mat_room, film_room.
- Switch OFF: the rooms render byte-identical to master (same check the MH2 digest's off_comparison used).
- Stills with the switch ON: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 --path Godot --script tools/q232_render.gd -- tag=staff1`
  (add `metahuman_staff=1` the way `metahuman_bodies=1` is passed - read the tool header). OPEN every still with your FILE
  tool: clothes on, no T-pose, no floating hair, no body through a chair/bench/desk, faces lit. Plus one 1280x720 portrait
  sheet of the four (`docs/previews/staff1/`).
- Each GLB below 8 MB; garment textures at most 2K.
- `research/STAFF1_DIGEST.md`: per staff member the preset, outfit, height, bytes, the stills, what still looks wrong.

## Owned files
`Tools/metahuman/staff1_*.{py,json}` (new), `Godot/assets/models/metahuman/mh_staff_*` (new),
`Godot/scripts/TrainingFloor3D.gd` (the staff constants + `_add_body`'s MetaHuman branch only),
`Godot/scripts/FightWorldStage.gd` (the `metahuman_staff()` switch reader only), the seven room scripts' staff-model
lines only (`Office3D, Lobby3D, LockerRoom3D, MatRoom3D, FilmRoom3D, StaffRoom3D, PhysioRoom3D`),
`Godot/tests/room_body_scale_test.gd` (append), `Godot/tools/q232_render.gd` (the switch arg only),
`previews/staff1/`, `previews/q232/*_staff1.png`, `research/STAFF1_DIGEST.md`.

## The one trap
THE PC FROZE in MH1: a preset carrying Outfits = WI_DefaultGarment made `spawn_meta_human_actor` compile 4K/8K clothing
textures (~4.3 GB). This task WANTS outfits, so: before every spawn set the garment texture resolution to 2K or lower
(or bake the outfit at its lowest LOD), build ONE staff member at a time, and run
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once` before each UE run - exit 1 (RED) = stop
and wait. Write what resolution the garment actually built at into the digest.

## Rules
Commit on `codex/staff1-metahuman-staff`, push `git push origin codex/staff1-metahuman-staff`. Never commit `*.import`.
One Godot and one UE process at a time. Never open a viewer or window on the operator's screens (file tool only; renders
through Tools\godot_hidden.ps1). Never edit HANDOFF.md. Do not stop at a plan.

## Prior research
`python Tools/prior_research.py coach physio clothed staff model` -> S92_ASSET_STORE_SEARCH_GYM_PROPS_AND_STAFF.md ("No
store sells a fight-gym STAFF set ... in one style that matches our fighters"; Fab single coaches EUR 31-35 each, mixed
styles); MH1_DIGEST (pipeline, licence, the garment freeze); MH2_DIGEST (four boxers, outfit slot cleared, per-model JSON
receipts); topics/staff_coaches.md; S153 room_body_scale_test (the dwarf bug - f06/f08 at half scale).

## What would a human do?
A character artist dresses the cast from the same character system as the leads - Creator outfit presets, one look per
role (tracksuit coach, polo physio) - so the gym reads as one world, then checks every one in its room.

## Prefab check
MetaHuman Creator outfits (Epic, free with the bodies); MakeHuman/MPFB CC0 clothes as a fallback; Fab staff characters
(S92: mixed styles, EUR 31-35 each) rejected by the operator's choice.
