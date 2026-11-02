# TASK PREVIEWLOOK1 - ROUND 3 (S263). THIS IS THE TASK. Model: Cursor (cloud). Discipline: BOXING (demo).

BOOTS ARE DONE ON MASTER (Claude, 06ae095a, operator S263 "use boots on the fighters"): `FighterKit.wears_boots(model, discipline)`
(discipline decides first) and `FighterKit._dress_metahuman` (fit in the fighter's rest space, then the foot bone's frame).
Round 3 = rebase `cursor/issue-260` on master, DROP every change you made to `Godot/scripts/FighterKit.gd` and the
`FighterKit.dress` call in `FightWorldLiveScreen.gd` (take master's), keep the Profile-stage look from rounds 1-2
(`Godot/scripts/ui/ProfileStage.gd`), and make `tests/preview_look_test.gd` measure MASTER's boots with the four WORLD-space
checks in Defect 1 below, on the Profile stage AND a live boxing room (they must PASS on master now - print the four numbers
per boot per sample; also prove they go RED by temporarily setting TOE_SPILL_M = 0.6 locally - paste that red line in the PR
body, do not commit the mutant). Kickboxing control arm: no boots. Push the SAME branch, open the PR with RESULT lines.
OWNS: Godot/scripts/ui/ProfileStage.gd, Godot/tests/preview_look_test.gd. Parse gate + `python Godot/tools/run_tests.py --jobs 2
--only preview_look_test,fighter_kit_test,profile_stage_test,profile_techniques_uicards1_test,repertoire_rows_test`.

(Round 2 text below for the checks and history.)

# TASK PREVIEWLOOK1 - ROUND 2 (S256). THIS IS THE TASK. Model: Cursor (cloud). Discipline: BOXING (demo).

Round 1 (`cursor/issue-260`, 6cbc3b47) was reviewed by Claude: the PR never opened, and it is NOT merged. Build round 2 ON TOP of
your round-1 branch `cursor/issue-260` (rebase it on master first), push the SAME branch, and open the PR.

## What round 1 got right (keep it)
Trunks #0F172A matte, octagon plinth + gold trim, Key/Fill/RimGold/RimCyan lights, perspective fov 32 camera, toe bone
`LeftToes|LeftToeBase`, kickboxing control arm, `tests/preview_look_test.gd`. profile_techniques_uicards1_test, repertoire_rows_test,
fighter_kit_test pass with it.

## Defect 1 - BOOTS ARE MISPLACED IN THE LIVE FIGHT (seen on the game camera; you cannot see images, so the numbers below)
Claude's live-fight still (`previews/s256_boots/03_boots_feet_crop.png`, FightWorldLive as_game, mh_boxer bodies): each
boot floats BESIDE / BEHIND its foot, the toe points sideways-back, and the bare foot is still fully visible. Your test's
"toe aim 0.0 deg" passed - it measures in the boot's own frame and cannot see this. Fix `FighterKit.dress` for MetaHuman bodies
(the MetaHuman foot bone's rest frame is not the old bodies' +Z-forward frame: derive the boot's yaw/pitch from the WORLD foot->toe
vector, not BOOT_YAW) and REPLACE the boot checks with these, measured in WORLD space, on BOTH the Profile stage AND a live boxing
room (FightWorldLive, `discipline: "boxing"`, mh_boxer bodies, after 30 frames, then 5 samples over 2 s of the bout):
- boot world-AABB centre, projected on the floor, within 0.05 m of the floor-projected midpoint of the foot bone and toe bone world origins;
- the boot's long axis (its toe end minus heel end, world, floor-projected) within 25 deg of the foot->toe world vector (floor-projected);
- the foot bone AND toe bone world origins both lie INSIDE the boot's world AABB grown by 0.01 m (the boot covers the foot);
- boot lowest vertex within 0.03 m of the floor/plinth top.
PRINT the four numbers per boot per sample. RED FIRST on your round-1 code (put the failing lines in the PR body).

## Defect 2 - discipline must decide first (Claude's review)
Round 1's `wears_boots` returns true for any `mh_boxer_*` path BEFORE it looks at the discipline - an mh_boxer body in a
kickboxing/MMA room would get boots. Use exactly this (Claude's fix):
```
static func wears_boots(model_name: String, discipline: String = "") -> bool:
	var file := model_name.get_file().to_lower()
	var boxing_body: bool = file.contains("_box_") or (model_name.contains("/metahuman/") and file.begins_with(META_BOXER_PREFIX))
	if not discipline.is_empty():
		return discipline == "boxing" and boxing_body
	return boxing_body
```
and `static func dress(body: Node3D, model_name: String, discipline: String = "") -> int` passing it to `wears_boots`;
`FightWorldLiveScreen.gd` (line ~1327) calls `FighterKit.dress(_node_a, _fighter_a_mesh, _discipline)` (and `_node_b`). Keep your
kickboxing control arm (mh bodies in a kickboxing room: 0 boots).

## Defect 3 - framing missed
Round 1 printed `projected body height 70.3% of viewport` (need 78-86%) and `body corner inside viewport (363.69, 680.32)` FAIL
(0.3 px below a 680 px viewport). Fix `_set_camera_front34` so both pass; simplify the 5 stacked adjust loops into one bounded solve
(distance from the projected height, then a v_offset clamp) - each loop is a frame-time cost while `_process` re-calls `_set_camera`.

## Guard - REPORT, do not fail
The preview plays `play_role("idle")`. Round 1 measured rear glove 0.30 m from the head, lead glove 0.42 m forward. Find what the LIVE
FIGHT plays for a boxer at rest on a MetaHuman (`FightStagePlayer.play_role`, `FightClipBinding.BINDINGS`); if the preview plays the
same clip, the guard numbers are the fight's own (a separate task) - turn the 3 guard checks into `REPORT:` lines (printed, not
counted). If the preview plays a DIFFERENT clip than the fight, switch it to the fight's and keep the checks as failures.

## Files you own
`Godot/scripts/FighterKit.gd`, `Godot/scripts/ui/ProfileStage.gd` (only `_ready`, `_guard`, `_build_set`, `_set_camera` front34,
your new helpers), `Godot/scripts/FightWorldLiveScreen.gd` (the two `FighterKit.dress` lines ONLY - 9,000+ lines, never read whole:
`grep -n "FighterKit.dress" Godot/scripts/FightWorldLiveScreen.gd`), `Godot/tests/preview_look_test.gd`.

## Run
Parse gate: `python Godot/tools/check_scripts.py <every .gd you touched>`. Tests: `tests/preview_look_test.gd`,
`tests/fighter_kit_test.gd`, `tests/profile_techniques_uicards1_test.gd`, `tests/repertoire_rows_test.gd`. Plain `--script` tests are
the OFF control arm (as_game turns switches on).

## PR body
`RESULT: tests/preview_look_test.gd -> PREVIEW_LOOK failures=0`, `RESULT: tests/fighter_kit_test.gd -> fighter_kit_test: 0 failure(s)`,
the other two tests' pass lines, the red-first lines of round 1's code, the printed boot numbers and the REPORT guard lines.

## Prior research
`python Tools/prior_research.py preview profile stage boots trunks`: PROFILE3B, FighterKit S115, Ludo r119 C.
## What would a human do?
Put the boot ON the foot: heel at the heel, toe at the toe, sole on the floor - then check it from the camera the player sees.
## Prefab check
`assets/models/kit/boxing_boot.glb` (Higgsfield tripo_3d, commercial use) - reuse it, no new asset.

---
# ROUND 1 BRIEF (for reference)

THIS IS THE TASK. Model: Cursor (cloud). Discipline: BOXING (demo).

## Why
Operator mark C108/C109 (`Feedback/2026-10-18-01/README.md`, box over the centre 3D boxer of the Profile > Techniques tab):
"this doesn't look good". What it shows: barefoot, shiny purple shorts, rear glove hanging away from the chin, stiff stance, flat
light on a dark disc. Lead designer Ludo r119 section C (`research/ludo_rx/LUDO_R119_raw.txt` lines 138-225) gives the look.
Found while reading the code: boots never mount on the MetaHuman boxers - `FighterKit.wears_boots()` only matches the old `_box_`
bodies and looks for a `LeftToes` bone - so the fighters are barefoot IN THE RING too (S254 still
`previews/s254_shoutdock/01_dock_guard.png`). Boxers wear boots.

## The route the game runs (traced)
- Preview: `scripts/ui/ProfileTabContent.gd:147 _build_stage_viewport` -> `scripts/ui/ProfileStage.gd` (1,340 lines - never read whole):
  `_ready` (:74-127) mounts the body through `FightWorldStage.mount`, calls `Kit.dress(fighter, mesh)` (:102), gloves, `_guard()` ->
  `player.play_role("idle")` (:232), `_set_camera("front34")` (:647). `_build_set()` (find `func _build_set`) builds the environment,
  the 0.8 m CylinderMesh plinth (#1E293B), a #94A3B8 torus rim, two lights via `_add_light`, and an ORTHOGONAL camera.
- Trunks: `scripts/MetaHumanRig.gd:207 colour_trunks(fighter, colour)` recolours the `MH_Trunks*` material (the fight uses it for corners).
- Boots: `scripts/FighterKit.gd:38 dress()` - `wears_boots` (:32) and `FEET` (:28, bone pairs).

## Files you own
1. EDIT `Godot/scripts/FighterKit.gd`: `wears_boots` also true for a boxing MetaHuman body (the mesh path under
   `assets/models/metahuman/` when the discipline is boxing - add a `discipline` argument defaulting to the old behaviour, or read the
   path; keep kickboxing/muay thai/MMA barefoot); FEET accepts the toe bone as `LeftToes` OR `LeftToeBase` (and Right). Same fit maths.
   Find every `Kit.dress(` caller (`grep -rn "Kit.dress(" Godot/scripts`) and make sure the live fight's boxing MetaHumans get boots.
2. EDIT `Godot/scripts/ui/ProfileStage.gd` ONLY in `_build_set`, `_set_camera` "front34" branch, `_ready` (after `Kit.dress`), `_guard`:
   - Trunks: `MetaHumanRig.colour_trunks(fighter, Color("#0F172A"))`, and set that material roughness 0.45, metallic 0.08 (matte satin).
   - Plinth: octagon (CylinderMesh radial_segments 8), radius 1.2 m, height 0.12 m, albedo #151921 roughness 0.85; trim ring #C59A41
     metallic 0.85 roughness 0.30 (replace the #94A3B8 emissive torus). Turn on SSAO in the stage Environment.
   - Lights (replace the two): Key #FFF8EE energy 3.2 at (-1.4, 2.2, 2.2); Fill #384556 energy 1.1 at (2.0, 1.4, 1.8); RimGold #E8B04B
     energy 4.5 at (-1.8, 2.8, -1.5); RimCyan #7DD3FC energy 2.8 at (1.8, 2.4, -1.2) - positions relative to the boxer's floor point,
     each aimed at the chest (y = 1.3 x height ratio is fine: aim at the AABB centre). Key casts shadows.
   - Camera "front34": PERSPECTIVE, fov 32, at (0, 1.35, 2.65) from the boxer's floor point rotated by the existing front-3/4 yaw,
     pitch -4 deg; then pull back/forward so the boxer's projected height is 78-86% of the viewport height (head room ~10%).
   - Guard: the preview must play the SAME guard the live fight plays for a boxer at rest (find what `FightStagePlayer` plays in the bout
     for guard - `certified_moves.json` `boxing.guard_idle` / `guards`); do NOT author a new animation (operator S246: MetaHuman motion
     = ActionForge clips one-to-one). If the fight's guard still has the rear glove off the chin by the measure below, report it in the PR
     with the numbers - do not hand-pose bones.
3. NEW `Godot/tests/preview_look_test.gd` (extends SceneTree; OK/FAIL lines; ends `print("PREVIEW_LOOK failures=%d" % failures)`).

## Acceptance (numbers - you cannot see images)
`preview_look_test.gd` builds `ProfileStage.build(<a boxing demo athlete>, Vector2i(760, 680))` under a SubViewport, steps 30 frames, then:
- two `FighterKit_*` BoneAttachment3D nodes exist on the MetaHuman skeleton; each boot's lowest vertex (world) is within 0.03 m of the
  plinth top; the boot's toe points within 30 deg of the foot's forward.
- the trunks material albedo is #0F172A (+-0.01 per channel), metallic <= 0.1.
- the plinth mesh has 8 radial segments, radius 1.2; four lights named Key/Fill/RimGold/RimCyan with the colours above (+-0.01).
- camera fov 32, projection PERSPECTIVE; the boxer's AABB projected through the camera spans 78-86% of the viewport height, all of it
  inside the viewport.
- guard (sampled at 5 times over 2 s of idle): rear glove centre to the head bone <= 0.14 m; lead glove centre 0.10-0.30 m in front
  of the head along the facing, and between chin and brow height. PRINT these distances on every run.
- RED FIRST: the test fails on master (`f8528660` or later) - put the failing lines in the PR body.
- The fight: `tests/fight_kit_test.gd` if it exists (else add a check in your test) - a live boxing room's two MetaHumans each carry
  two `FighterKit_*` boots; a kickboxing room's do not (control arm).
- Run: `tests/preview_look_test.gd`, `tests/profile_techniques_uicards1_test.gd`, `tests/repertoire_rows_test.gd`. Parse gate:
  `python Godot/tools/check_scripts.py <every .gd you touched>`.
- PR body lines: `RESULT: tests/preview_look_test.gd -> PREVIEW_LOOK failures=0` + the other two tests' pass lines + the printed
  guard distances.

## Prior research
`python Tools/prior_research.py preview profile stage boots trunks`: PROFILE3B (the stage), FighterKit S115 (boots stand-in, Higgsfield
licence), Ludo r119 C (the look). Plain `--script` tests are the OFF control arm (as_game turns switches on).

## What would a human do?
A boxing game shows its fighter like a fight poster: trunks, boots, wraps, gloves up, chin down, lit from above with a coloured rim on a
ring-canvas pedestal - the player should want to see this man fight.

## Prefab check
Boots: `assets/models/kit/boxing_boot.glb` already in the project (Higgsfield tripo_3d, commercial use) - reuse it, no new asset.
Lights/plinth: Godot built-ins. Trunks: the MetaHuman's own `MH_Trunks` material recoloured.

## The one trap
`Kit.dress` is called by the fight too: a boot that fits the preview but floats or clips on the ring canvas is a regression in every bout.
Measure the boot sole against the floor in both. Discipline: BOXING only - never boots on a kickboxing/muay thai/MMA body.

## Contract
OWNS: Godot/scripts/FighterKit.gd, Godot/scripts/ui/ProfileStage.gd, Godot/tests/preview_look_test.gd
RED_TEST: Godot/tests/preview_look_test.gd -> PREVIEW_LOOK failures=0
REGRESSION: preview_look_test, profile_techniques_uicards1_test, repertoire_rows_test
VISUAL: yes

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First run the gate on master's shipped clip: it must read RED on the boots beside the feet in the live fight; paste that number in your report.
2. Stills only via record_room.gd -- as_game + still_framing.gd save_if_framed: guard, contact frame, one between.
3. For every still report: gap between bodies / where each nose points / wrists in line / feet / the defect / which bodies.
4. Do not call it accepted or fixed. Claude opens every still; the operator closes it.
