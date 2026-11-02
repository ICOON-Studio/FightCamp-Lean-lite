# C213 — generated fighters in the fight room

Branch: `codex/c213-generated-in-room`. Baseline: `9d2ccf72f02bfa63015d321bb2ed99039216593a`.

## Implementation

- Model selection and rig profiles: `scripts/FightWorldStage.gd`, consumed by `FightWorldLiveScreen.gd` and `TrainingFloor3D.gd`.
- `skin=generator` selects the MPFB pilot for male athletes. `FighterLook.apply` and `apply_skin` use each athlete's own ID. Female selection and the default/CC switches remain on their existing paths.
- The pilot profile is in metres, scale 1, lift 0. `FighterPhysique` still supplies stature scaling. The floor retains the Tripo profile's 0.925 m lift; the fight room retains its existing AABB placement for old models.
- `FightStagePlayer.gd` already retargets bought FBX takes. Generated rigs additionally retarget legacy GLB takes instead of grafting f01 local rotations by name.
- The generated floor route retargets source FBX files, never f01 station resources. Station clips retain cyclic horizontal travel and remove net endpoint drift.
- Generated rigs create an empty AnimationPlayer library before binding and connect procedural glove synchronization. These branches are generator-only.

## Verification

Parse: `CHECK total=6 fails=0 autoload_refs=0 autoload_warnings=0`.

`tools/c213_rig_probe.gd` compares every bound take and all floor sources using S93's world limb-direction method at 30 Hz. Result: **170 takes, 0 failed, worst segment 18.7075 degrees**, below the 20-degree limit. The worst is Chest-to-Head on the boxing warm-up station clip; `retarget.json` includes every take and segment maximum. No engine/script errors in the final probe; existing FBX reader and teardown warnings remain.

`tools/c213_record.gd` records the production boxing room with distinct athlete IDs `a` and `b`, male, 66.0/66.5 kg, 1.80/1.72 m. FighterLook weights and skins come from these IDs. Its sole metric evaluates seeded blend shapes, inverse binds and current bone poses, then reports the lowest actual sole vertex of each fighter relative to the canvas on every rendered frame. This is a grounded-body measurement, not a claim that the raised foot of a stepping fighter stays on the canvas.

| Fighter | Minimum sole Y | Maximum sole Y | Samples |
|---|---:|---:|---:|
| a | -0.031178 m | +0.041914 m | 300 |
| b | -0.011069 m | +0.042667 m | 300 |

Both pass the +/-0.05 m gate. Four procedural boxing gloves are present; the worst measured glove-node-to-wrist error is 0.000000 m. `soles.json` includes frame samples and counts of actually played clips. The final recording has no engine/script errors.

Video: **`docs/previews/c213/bout.mp4`**, H.264, 1280x720, 30 fps, exactly **300 frames / 10.0 seconds**. Godot's movie writer emits a terminal extra frame; the encoded deliverable contains the first 300 measured frames. Reviewed the three saved full-size frames and the ten-frame contact sheet extracted from the delivered MP4.

Switch OFF, requested 20-test subset:

```text
Master 9d2ccf72: SUITE total=20 fails=4
C213:           SUITE total=20 fails=4
```

The same four tests fail: `fight_stage_presenter_contract_test`, `fight_stage_realism_test`, `fight_stage_technique_fidelity_test`, and `fight_world_live_test`. The three short tests have identical failing assertions. The clean-master suite's realism process initially exited before printing its totals, so a focused master rerun resolved that uncertainty: **both master and C213 report `TOTAL=13 fails=8`, and the complete RULE R1-through-TOTAL measurement section is identical**. See `realism_comparison.txt` and `suite_comparison.json`. This is no regression against master, not a green existing suite.

The clean baseline used one worker while an exploratory run finished; the final candidate subset used `--jobs 2`. The focused master follow-up used one worker. No run exceeded two workers. The final source files were verified against their staged bytes after restoring them from the focused master comparison.

### Reproduce

```powershell
python Godot/tools/check_scripts.py scripts/FightWorldStage.gd scripts/FightWorldLiveScreen.gd scripts/TrainingFloor3D.gd scripts/FightStagePlayer.gd tools/c213_record.gd tools/c213_rig_probe.gd
# Headless: tools/c213_rig_probe.gd through the installed Godot console executable.
powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --script tools/c213_record.gd --rendering-method gl_compatibility --write-movie docs/previews/c213/bout.avi --fixed-fps 30 --resolution 1280x720
python Godot/tools/run_tests.py --jobs 2 --only fight_stage,fight_world,retarget,floor
```

## Visual limits

The MPFB pilot is an **unclothed base mesh**, not a finished clothing/kit asset. Its finger chains retain the pilot's open-hand pose because the existing clips animate the shared body skeleton, not the extra fingers. The preview proves the requested rig, identity, clip and floor integration; it does not claim final fighter art or solve the existing fight-realism failures.

## Scope and workflow

The user's self-contained task and release of HELD superseded the generic brief/inbox intake, meter lookup and HANDOFF instructions. No HANDOFF, CURRENT_STATUS or archive was read or edited. Work remained inside the C213 worktree. No full suite was run; the requested fight-stage/world/retarget/floor subset is the ceiling. Windowed recording uses `Tools/godot_hidden.ps1`.

Tracked import sidecars changed by editor import were restored. Automatic approval review rejected deleting the broader set of untracked `.uid`/`.import` sidecars because it could remove other work; those remain unstaged and are excluded from the delivery.
