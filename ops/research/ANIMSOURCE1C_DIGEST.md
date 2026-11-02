# ANIMSOURCE1C - native boxing palette from the accepted 1B guard

Batches delivered on `codex/animsource1`: A.
These are animation sources and original-model playback checks. Production fight bindings are outside this task; Claude artistic acceptance and live fight integration are not claimed.

## Pipeline and phases

The saved `guard_pose.casc` is the hub. The existing native rig, AutoPhysics toolbar actions, normalization and animation-only packaging remain the production path. Authoring writes controllers, never joint positions. Saved native scenes and raw exports remain local/ignored; receipts bind their hashes to the shipping GLBs. Every move has actual solver CONVERGENCE/core-finished evidence in `physics_1c.json`.

All singles are 30 fps, 21 frames / 0.666667 s, starting and ending on the shared guard. Strikes contact at frame 8. Defence has no contact: slip/pull use evade peak 8; catch uses parry peak 8; hit_head/hit_body use impact 8. Recovery is the first subsequent full-joint shared guard, with the prescribed 0.5/0.6 s ceiling. Idle is 61 frames / 2.0 s, loop phase 30, closure on every native joint. Lead-positive X and rear-negative X follow the original left/right foot sides.

The lead uppercut chambers over four frames, rises 20.5 cm over four, and uses the lowest native two-link elbow pole; the shorter knee dip is 6.5 cm. This keeps its forearm under 25 degrees and per-frame hand motion under 8 cm. Catch opens the rear finger boxes and turns the wrist before closing into the same guard. Hit-body folds the upper torso about spine_02, not about the pelvis.

Only idle enables exact constant-key packing in `animation_only.py`. Repeated components must be byte-identical and the expanded hash is retained; varying channels are unchanged. Static keys clamp identically at all times. The shorter clips retain the existing packer path. No post-export pose correction, retarget, IK layer, tolerance optimizer or gameplay edits.

## Imported measurements

| Batch / clip | Extension | Hip yaw | Rear / lead pivot | Dip | Torso clearance | Guard error |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| A / rear_uppercut | 46.65% | 27.84 deg | 2.38 / 0.17 deg | 8.00 cm | 11.00 cm | 0.0080 mm |
| A / lead_uppercut | 47.95% | 28.03 deg | 0.06 / 0.01 deg | 6.50 cm | 19.90 cm | 0.0080 mm |
| A / jab_body | 94.40% | 15.11 deg | 0.06 / 0.07 deg | 19.77 cm | 49.08 cm | 0.0093 mm |
| A / cross_body | 94.50% | 53.07 deg | 44.98 / 0.13 deg | 19.99 cm | 40.25 cm | 0.0079 mm |

Extension is a strike measure; the defence/idle rows merely retain sampled arm geometry. The complete family-specific measurements and errors are in `shape_imported_1c_<batch>.json`.

## Pair spacing and private sheets

The gate uses conservative torso front envelopes: the most forward chest/pelvis centre over every frame plus 16 cm on each man. Separation includes at least 10 cm surface clearance, with 1 cm authoring margin. The same separation is used by the renderer, so close moves no longer reuse the rejected 0.50 m uppercut pairing. This is a conservative torso-envelope check, not a general triangle collision test.

Private output directory: `E:/FightCamp/tmp/animsource1c/`. Each clip has `<move>_side.png` and `<move>_front.png`, 1920 x 1080, 12 frames, mh_boxer_01 attacker and the distinct blue-trunked mh_boxer_02 guard receiver. Captures use only `godot_hidden.ps1`; no visible viewer/browser is launched. File-tool inspection is recorded separately from Claude acceptance. Idle sheets cover frames 0 through 60.

Batch A: `rear_uppercut_side.png` / `rear_uppercut_front.png`, `lead_uppercut_side.png` / `lead_uppercut_front.png`, `jab_body_side.png` / `jab_body_front.png`, `cross_body_side.png` / `cross_body_front.png`.

## Negative witnesses

`negative_witnesses.py` starts from the real 1B jab. It supplies that deliberately wrong clip to each new move family; the idle fixture additionally displaces its last pose and planted ankle, and reaction fixtures deliberately recover over two seconds. These clips remain ignored/nonshipping. `negative_manifest_1c.json` binds their bytes, and `negative_shape_1c.json` retains every measured FAIL.

`MOVE_SHAPE_SUMMARY moves=17 fails=17` for the new-family witnesses. The previously accepted 1B uppercut paired at 0.50 m fails with `FAIL paired torso clearance`: measured surface clearance 0.021531 m, below 0.10 m (`negative_pair_1c.json`). Existing 1B guard/strike gate witnesses remain in `shape_1a_failures.json` and the 1B digest.

Observed FAIL lines (deduplicated):

```text
FAIL arm extension
FAIL body level change
FAIL body reaction fold and elbow
FAIL body reaction recovery
FAIL catch open glove
FAIL catch parry
FAIL check hook lead pivot
FAIL cross hip turn
FAIL defence gloves face
FAIL duration
FAIL end rear glove
FAIL end stance length
FAIL evade head displacement
FAIL head reaction displacement
FAIL head reaction recovery
FAIL head reaction torso and gloves
FAIL hook elbow angle
FAIL hook elbow height
FAIL hook hip turn
FAIL idle bounce
FAIL idle every joint loop
FAIL idle glove drift
FAIL idle planted ball_l
FAIL idle planted ball_r
FAIL idle planted foot_l
FAIL idle planted foot_r
FAIL non-punch glove face
FAIL overhand loop and head contact
FAIL planted ball_l
FAIL planted ball_r
FAIL planted foot_l
FAIL planted foot_r
FAIL rear heel pivot
FAIL return to guard
FAIL shared guard pose
FAIL snap return timing
FAIL up jab chamber and rise
FAIL uppercut continuity
FAIL uppercut dip
FAIL uppercut shape
FAIL paired torso clearance
```

## Validation and delivery

Per delivered batch: parse; raw shape gate; editor import with optimizer/compression disabled and immutable tracks retained; normal ResourceLoader shape gate; hidden imported sheets; static package validation. Each GLB has 341 original names/parents, one animation, no mesh/material/image/texture, and is below 600000 bytes. Exact bytes/hashes are in per-move receipts and the clip manifest. Import logs and any editor diagnostics are retained separately from runtime playback gates.

Watchdog precedes every heavy stage, RED waits. One verified hidden Cascadeur instance is recycled per source and stopped before batch import/capture. Absolute non-console Godot 4.7.2 is used, including hidden desktop captures. No full suite: this task grants source/probe gates.

Task-specific branch/batches/ownership supersede the general master rebase, one-commit/end, unrelated inbox work and HANDOFF edits. Only owned paths are staged. The merge-blocking seven unrelated untracked reception files were preserved in `.local_merge_backup_animsource1c/`; unrelated import/UID working changes are left unstaged. Master was never checked out, edited or pushed.
