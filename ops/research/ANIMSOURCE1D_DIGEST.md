# ANIMSOURCE1D - shared cheek guard, straights, remaining native palette

IN PROGRESS on `codex/animsource1`. This digest records source exports and original-model playback; production fight bindings are outside the owned paths.

## Scope and resume

Resumed after WIP `e3fb6792` and merge `fb902a59`; merged the current `origin/master` before authoring. Task D's explicit merge supersedes the generic entry rebase. Imports, gym_pack images and `.local_merge_backup_*` are not staged. The task's existing Cascadeur controller/AutoPhysics/export pipeline supersedes the asset-production skill's generic canonical-package workflow (`game-dev` is unavailable); no paid generation is involved. Hidden Cascadeur desktop/PID verification and watchdog checks precede heavy operations. Private images are read with the file image tool; no browser or viewer is opened.

## E: guard before any punch batch

Reference: [IBA Coaches Manual](https://www.iba.sport/documents/iba-coach-manual/), printed page 34 (PDF page index 33). Saved/inspected `E:/FightCamp/tmp/animsource1d/iba_guard_reference.png`: orthodox illustration has the rear fist at the cheek/chin, elbow along the ribs, lead fist ahead of the face, bent knees and tucked chin. The tighter brow/chin and cheek-distance limits come from task E and D64 s6.1. Also inspected the supplied C209 shadowboxing take 1 sheet: cheek-height hands and rib-level elbows are useful motion comparison; that sheet is explicitly labelled REJECTED SOURCE, so it is not an accepted authored clip.

The pre-change shipping guard/straights were checked BEFORE changing the hub. `shape_1d_rejected_guard_confirm.json`: `MOVE_SHAPE_SUMMARY moves=5 fails=5`. Exact repeated guard FAIL lines:

```text
FAIL guard_shape start l glove top chin-brow
FAIL guard_shape start l elbow down
FAIL guard_shape start r cheek jaw
FAIL guard_shape end l glove top chin-brow
FAIL guard_shape end l elbow down
FAIL guard_shape end r cheek jaw
```

Old lead fist top 1.701976 m vs brow 1.659934 m; lead elbow only 8.723 cm below shoulder; rear fist centre 9.282 cm from the jaw vs 8 cm limit. `freeze_guard_1d.py` preserves the rejected checkpoint bytes from `e3fb6792`; hashes are in `rejected_guard_manifest_1d.json`. These are independent of the older 1B witnesses.

First candidate was rejected after inspecting EVERY generated image: `frame_review_1d_guard_candidate1.json` binds the three observations to hashes. Front: elbows down, but both hands droop into claws near the chin. Side: stance and separation clear, wrists/fingers droop and expose the face. Three-quarter: salute elbows gone, but fists are not upright at the cheeks. Gate agrees: both fist tops below chin and rear fist too far from jaw (`shape_1d_guard_candidate1.json`). Cause: loading the curled hub and applying orientation/curl twice. The hub now loads from the neutral native scene; all other clips still load from the saved hub.

## Preserved D negative witnesses

`shape_1d_rejected_straights.json`: rejected jab fails guard clearance, joint penetration, contact elbow and no_wrap; cross fails guard clearance, contact elbow and no_wrap; cross_body fails guard clearance and contact elbow. `shape_1d_rejected_uppercut.json`: 0.50 m inside-uppercut pair fails torso clearance, guard clearance and joint penetration. The old cross already meets the literal 6 cm path and +5 cm elbow ceiling; `negative_straights_1d.py` provides separately displaced, nonshipping fixtures for those thresholds. Do not claim the old cross failed a threshold it met.

## Remaining verification

Four straights exported on the new hub; first raw check `moves=4 fails=1` (`shape_1d_straights_guard_first.json`). Jab/jab_body/cross_body pass. Cross contact elbow 170.590 deg and wrist curvature 1.625 mm pass; elbow height is 5.137 cm (limit 5 cm), rear-ball drift 10.294 mm (limit 10 mm), so cross remains rejected. Its source target is lowered 2 cm to the lower chin and the rear pivot reduced 52 -> 48 degrees; unchanged gate limits. Export receipts currently describe the first attempt, pending regeneration of cross. This intermediate batch is checkpointed to avoid losing exports while E: approaches 1 GB free.

Checkpoint `83fee0f9` is pushed. Automatic approval review rejected the next hidden Cascadeur/Godot batch because E: had about 1 GB free and required 6 GB of headroom, despite the watchdog's reported AMBER. No indirect execution or bypass was attempted. Regeneration/reshooting and task D remain outstanding until disk headroom recovers. Claude was sent `70ea31e6c5c4`; the operator was asked to free space or wait. Lightweight GLB validation still passes all four current WIP packages (341 joints, one animation, no render payload, <=600KB); this does not accept the red cross. Generated guard/cross/legacy controller source compiles as Python syntax.

Review reconsideration: measured cross scene 7,635,565 bytes, raw export 5,756,152 bytes, shipping GLB 544,344 bytes, existing imported scene 150,779 bytes; replacement write envelope below 40 MB. E free remained 1,016,725,504 bytes. Fresh host watchdog exited 0 AMBER (C 44.7 GB free, RAM 65%, commit 26.2 GB free, CPU 24%, 78 C). The script's 6 GB critical disk threshold applies to C, not E. On these read-only checks, automatic review ACCEPTED a direct single-cross regeneration, without editor import/render. Heavy verification steps are checked separately; no rejected command was executed indirectly.

E headroom subsequently recovered above 63 GB, clearing the disk blocker. Cross elbow correction passes at 4.0846 cm. Reducing the solver's rear pivot from 52 to 48 degrees left ball drift 10.004 mm and actual pivot only 31.059 degrees; reducing to 40 lost required hip turn (41.881 degrees). The source returns to the established 52-degree solver input. `plant_cross.py` corrects the actual pivot anchor after AutoPhysics using only native foot point/box controllers: rotate around the anatomical ball, not its offset rig handle. Live native readback after the correction: 39.94-degree pivot and 0.044 mm ball drift. Guard endpoint keys are retained, and the receipt binds this additional controller script. No joint keys or exported animation accessor are patched. Final combined hip/foot/shape review remains required; the deliberately reduced-pivot attempt is retained in `shape_1d_cross_foot_first.json`.

Corrected guard: raw and imported `MOVE_SHAPE_SUMMARY moves=1 fails=0`, import diagnostics=0, 544348-byte animation-only GLB with 341 native joints, one animation and no render payload. Lead/rear fist tops 1.601977/1.558369 m (chin 1.489934, brow 1.659934); lead fist 11.701 cm in front of face; rear fist 4.469 cm from jaw; elbows 18.905/22.693 cm below shoulders; forearms 3.853/14.236 degrees from vertical. Raw and imported front/side/three-quarter views were each inspected: cheek/jaw hands and rib-covering elbows replace the salute on both men. Front exposes red's cheek guard; side exposes blue's jaw hand; three-quarter shows both. Bent knees, raised rear heels, separated hands/bodies remain. These original source models render bare closed hands; production glove meshes are outside the harness. Observations/hashes: `frame_review_1d_guard_final_raw.json` and `frame_review_1d_guard_final_imported.json`.

## Straight batch accepted source review

Raw and imported: `MOVE_SHAPE_SUMMARY moves=4 fails=0`, import diagnostics=0. All four GLBs have 341 native joints, one animation, no mesh/material/texture payload, and are 544340-544348 bytes. All 16 freshly rendered files were inspected and bound to `frame_review_1d_straights_guard_imported.json`.

The final cross uses 4 cm knee dip, a 0.995 fixed-target chain ratio and the established 52-degree solver pivot input. It has 50.329-degree hip turn, 38.868-degree actual rear pivot, 8.254 mm maximum planted-ball drift, 7.078 mm planted lead-ankle drift and 3.897 cm maximum elbow elevation. All limits are unchanged. Isolated post-physics foot edits were rejected because they disturbed the coupled hip/lead-foot solve; `rejected_foot_controller_1d.py` is nonshipping and guarded against accidental invocation. The original whole-body controller/physics path is the shipping path.

Contact surface uses the leading closed-fist knuckle/skin landmark: putting the wrist centre 0-3 cm from the head would bury the closed fingers. The measured wrist-centre offset remains reported separately. This resolves the wording difference between task A's fist surface and C's wrist point in favour of the explicit no-interpenetration requirement; it is not a tolerance increase.

| Clip | Contact elbow deg | Wrist path mm | Solved pair m | Guard body clearance cm | Fist surface gap cm | Closest joint gap cm |
| --- | ---: | ---: | ---: | ---: | ---: | ---: |
| jab | 169.916 | 3.018 | 1.150871 | 27.676 | 1.500 | 2.567 |
| cross | 166.526 | 1.412 | 1.118353 | 24.523 | 1.500 | 2.337 |
| jab_body | 170.794 | 2.137 | 1.132062 | 25.850 | 1.500 | 2.286 |
| cross_body | 173.248 | 1.374 | 1.153687 | 27.950 | 1.500 | 2.261 |

Before/after: old rejected jab/cross/cross_body contact elbows were 140.107/141.831/141.815 degrees, with only 5.943 cm guard clearance. Old jab/cross failed `no_wrap`; old jab also had joint penetration. Current four pass every retained/new gate. Old wrist curvature was already below the literal 6/8 cm ceiling; isolated wrong-path/wrong-height fixtures are required to prove those thresholds honestly.

Next: finish 1C batches B-D, re-key/re-check legacy uppercuts/lead_hook on the new hub, validate all 22 clips under the full gate set, inspect every new sheet and push each completed batch. No full suite or production fight binding change is claimed.

## Hook/overhand first checkpoint (not accepted)

`author_hooks.py` uses measured chain lengths for a 90-degree contact elbow and a horizontal source elbow plane, with head/rib targets and source weight transfer. `no_wrap` now applies to EVERY strike, retaining its limits. First raw result: `moves=5 fails=4`; rear_hook_body passes. Lead_hook: planted rear ankle, guard clearance, finger penetration. Rear_hook: rear-ball drift/pivot, guard clearance, finger penetration. Body_hook: guard clearance 14.965 cm (limit 15). Overhand: planted lead ankle/rear ball, pivot, guard clearance and `no_wrap`; actual fist surface gap 16.377 cm. This is the negative witness proving the all-strike target check sees the old overhand miss. `shape_1d_hooks_overhand_first.json` preserves measurements; no new hook sheets were made because raw review was red.

## What I saw on every new straight sheet

- jab_side.png: Cheek guards at rest; lead elbow stays down through early extension, arm approaches a straight line at 0.267s, rear hand stays at the jaw, and the fist returns by 0.400s. Both men remain head-to-feet in every tile.
- jab_front.png: Lead fist arrives at the near chin rather than crossing behind the head. Both men return to the cheek guard with elbows below the shoulders; no forehead salute.
- jab_top.png: Lead wrist travels along a narrow forward corridor. It stops before the receiver head centre; the torso and feet remain separated.
- jab_contact.png: Upper arm and forearm nearly align, closed fist and tucked thumb sit on the near chin side, and the rear hand remains beside the attacker's jaw. Both heads are visible.
- cross_side.png: Rear shoulder advances with the small knee dip and rear heel pivot; rear fist extends to the near chin, lead hand protects the face, then both hands recover to the cheek guard.
- cross_front.png: Torso turns through the rear straight. Contact arm is almost straight rather than a horizontal bent hook, and the rear fist stays on the receiver's near side.
- cross_top.png: Hip/shoulder rotation and rear-foot pivot are clear; wrist follows a narrow forward line and does not sweep beside or behind the receiver's head.
- cross_contact.png: Rear arm has a small remaining bend, with the fist at the near lower chin and the lead hand beside the cheek. Closed striking fingers/thumb are clear; both heads remain framed.
- jab_body_side.png: Both knees lower the attacker, while the torso remains upright enough and the rear hand follows the jaw. Lead arm extends almost straight to the near rib plane and returns to guard.
- jab_body_front.png: Visible level change and an aligned lead arm distinguish this from a body hook. Receiver keeps his guard, including an elbow near the body target; bodies stay separate.
- jab_body_top.png: Lead wrist stays in a narrow corridor to the near torso, without wrapping around the receiver. The planted stance remains visible.
- jab_body_contact.png: Lead fist is at the near rib plane under the receiver's guarding elbow, arm nearly straight, rear hand at the attacker's jaw; both heads and the body contact region are framed.
- cross_body_side.png: Knee level change and rear-foot pivot accompany a straight rear-arm arrival at rib height. Lead hand stays at the face and both hands recover to the new guard.
- cross_body_front.png: Rear shoulder turns through a nearly straight body punch; the hand does not arrive as the rejected bent side hook. Receiver's guard remains over the ribs.
- cross_body_top.png: Narrow forward wrist path, visible torso rotation and rear pivot; fist remains on the near torso side, with no far-side wrap.
- cross_body_contact.png: Rear elbow is nearly straight and striking thumb tucked; fist rests at the near rib plane under the guarding elbow. Lead hand remains at the cheek and both heads are visible.
