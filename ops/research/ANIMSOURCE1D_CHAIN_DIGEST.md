# ANIMSOURCE1D chain digest — recovered guard candidate; hook remains RED

Branch `codex/animsource1`; resumed WIP `b5bb8c06`, merged current master as `ae06a77e` without conflicts. Status OPEN. No new native motion was authored in this chain pass and no production clip was replaced. The isolated v18 guard from the interrupted S218 run is now preserved with its recipe, readback, package and receipts.

## Red first, on the shipped bytes

All 22 current palette GLBs match `fix2_rejected_manifest.json`'s f7b7080c hashes. Both MetaHuman body Git blobs match f7b7080c, current master and this branch. All 22 retained native/drawn pose exports match the frozen export hashes. These checks are reproducible with `Tools/cascadeur/animsource1/chain_receipt.py`.

The unchanged Blender mesh/facing/wrist gate was rerun on those retained exports, using current S218 anatomical conventions. Full evidence: `E:/FightCamp/tmp/animchain_s222/baseline_audit.json`, `.log`, `.err`; committed compact numbers/hashes: `Tools/cascadeur/animsource1/chain_s222_baseline_summary.json`.

These are fresh calculations from retained pose exports, not a fresh Godot export from today's merged runtime. Clip/body byte identity is verified; effects of intervening runtime-code changes on the final drawn pose are not verified here.

Gate prefixes and summary (full per-hand JSON is in the log):

```text
FAIL FIX2_mesh body_hook
FAIL FIX2_facing body_hook
FAIL FIX2_wrist body_hook
FIX2_SUMMARY clips=22 red=22
AssertionError: FIX2 defect gates remain RED (full R50 acceptance requires the supplement)
```

The PowerShell waiting wrapper returned zero despite the Blender assertion; the assertion, per-gate output and report were inspected, so this is recorded RED, never inferred green from the wrapper exit.

Every clip is red for facing and wrist/roll. Mesh/spacing is additionally red on `body_hook`, `guard_pose`, `inside_uppercut`, `lead_uppercut`, `rear_hook`, `rear_uppercut`. The other sixteen pass only that primary mesh gate.

Body-hook witnesses:

| Measure | Shipped | Required |
|---|---:|---:|
| Chest gap, frames 0 / 4 / 8 / 10 / 20 | 83.43 / 83.43 / 75.16 / 81.08 / 83.43 cm | 78±4 / 66±3 / 52±2.5 / 53±2.5 / 78±4 cm |
| Maximum head yaw error, A / B | 32.08 / 32.66° | 8 / 6° |
| Maximum native lead wrist bend | 64.47° | 2.5° in the strike window |
| Rear roll drift | 43.13° | 15° |
| Body penetration upper bound | 0 cm | ≤1 cm |

The mesh red is clearance/spacing; **this run did not measure body penetration**. Do not relabel the operator's visual complaint as a newly measured intersection.

## Cause and remaining source work

The native hook still contains the rejected orientation/staging. The old authoring recipe hardcodes its wrist target, while the review staging carries a -0.74 m lateral offset; together these are not the R50 approach/contact trajectory. A recorder clamp cannot repair that choreography.

The retained body-hook export has **one distinct receiver native pose across all 21 frames**. `animsource1_fix2_export.gd` applies `guard_pose` to B and samples B at zero; the game-camera fixture does the same. Thus this evidence path cannot demonstrate the required level-before-contact, contact-reaction, tucked-reset receiver motion. Native receiver motion and explicit two-take sampling are still required; merely changing the attacker or a threshold cannot satisfy that requirement.

The earlier native diagnosis remains supported: point-only direction/additional controls straighten the wrist without the rejected Box/FK elbow flip. Do not revive solved-field writes. This pass did not attempt another unvalidated native rewrite. The prior v1–v18 trials remain preserved, and the chain's bounded WIP exception is used rather than calling the recovered guard a completed hook.

## Recovered guard: primary red → green only

`fix2_candidates/s218_guard_v18/mh_guard_pose.glb`: 544,356 bytes, 341 native joints, one animation, no mesh/material/texture payload; SHA256 `94cabaf9588c4a3dff712d1b4ffdbd1492ede89f8ca893372a51790e99787b9c`. Native source remains `Tools/cascadeur/animsource1/fix2_s218_guard_v18.casc` under the existing ignored-source convention; its hash is in `chain_s222_receipt.json`.

The same primary gate was freshly rerun on the retained raw and imported v18 exports:

```text
PASS FIX2_mesh guard_pose
PASS FIX2_facing guard_pose
PASS FIX2_wrist guard_pose
FIX2_SUMMARY clips=1 red=0
```

Both runs exit 0 with those markers and no Python errors. Full reports/logs: `E:/FightCamp/tmp/animchain_s222/v18_raw.*`, `v18_imported.*`; committed summary: `chain_s222_guard_summary.json`. Facial-clearance receipts were hash-verified against the exports, not recomputed this session: raw 4.00–5.90 cm and imported 4.00–5.90 cm across the four gloves. These primary greens do not cover the full hook, palette endpoints, foot motion or operator acceptance.

## Existing stills opened this run — not new captures

Paths:

- `E:/FightCamp/tmp/animsource1d/fix2_s218_guard_v18_game_raw/guard_pose_guard.png`
- `E:/FightCamp/tmp/animsource1d/fix2_s218_guard_v18_game_imported/guard_pose_guard.png`

The original logs show `STILL_FRAMING OK ... shot=broadcast err=0` through the record_room-derived fixture. Both images were opened with the file image tool. They show body 01 in red on the right and body 02 in blue on the left, both head to feet. **Their old capture logs omit the pair transform, so exact PNG-to-export transform matching is unverified.** The following numbers describe the corresponding retained export pose, not a claimed fresh numerical capture of each PNG.

| Image | Gap / noses | Wrists | Feet |
|---|---|---|---|
| Raw guard | Bodies visibly separate; export chest gap 78.91 cm. Noses toward opponent; head-to-head yaw errors 0.193/0.193°, both pitch -14°. | Gloves near cheeks, forearms aligned. A bend L/R <0.001/<0.001°; B 0.840/1.468°. Rolls about 45/80°. | Four feet visible, raised rear heels; static image cannot prove planting/sliding. Ankle stance width A/B 34.30/34.18 cm, length 29.28/28.86 cm. Raw ankle-to-ball pitches A 28.34/35.85°, B 27.29/34.68°. |
| Imported guard | Bodies visibly separate; export gap 78.91 cm. Head-to-head yaw errors about 0.0003/0.0003°, both pitch -14°. | Cheek guard and straight wrist columns; all bends <0.001°. A rolls 45/80°, B 44.48/77.18°. | Four feet visible, foot pose still requires review. Ankle stance width/length both about 34.40/29.16 cm; raw ankle-to-ball pitches both 28.34/35.85°. |

Ankle pitch is not calibrated sole pitch; ankle-centre stance length is not heel-to-toe length. Full numerical definitions and per-hand/per-foot values are in `chain_s222_receipt.json`. The stills show only a static guard: no between/contact hook frame and no new 20-second clip were produced. No visual defect is called fixed.

## Preservation, gates and handoff

- Pre-existing generated import churn and four master-added reference copies are saved in scoped stash `9f5a0efc0d8487e28970c3f950ab1be10e159c1d` (`ANIMSOURCE1D chain: preserve pre-existing import churn and master-added reference copies`). Other candidates, UIDs and scratch directories were left in place. No import churn is staged.
- No GDScript, production animation binding, FighterCapsules or runtime wrist correction changed in this pass. Python receipt execution and the three Blender audits are the current checks; fresh Godot affected-system/visual gates remain open.
- Watchdog ran before heavy jobs. The audit used one hidden Blender process at a time, limited threads/priority; observed temperature peak was 82°C. No second Godot process was started. The pre-existing Cascadeur instance was not changed.
- User's chain/merge/WIP rules override the generic one-task-session/rebase habit. Claude reviews the candidate and owns board delivery; operator closure is still required.

Next source work: native two-body hook staging and receiver take, canonical guard endpoints on the palette, then unchanged full R50 gates and fresh game-camera guard/between/contact/20-second evidence. The defect list remains open.
