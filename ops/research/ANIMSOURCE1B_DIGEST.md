# ANIMSOURCE1B - native MetaHuman boxing guard and shape gates

Completed source production on codex/animsource1, continuing 90bcdaa4. All four
raw clips and the final imported PackedScene playback pass
`MOVE_SHAPE_SUMMARY moves=4 fails=0`. The 1A negative witness is
`MOVE_SHAPE_SUMMARY moves=4 fails=4`. Production fight bindings were not in this
task's owned files. This certifies these source clips and their original-model
playback; live fight integration and Claude's artistic acceptance are separate.

## Shared orthodox guard

The saved native hub is `Tools/cascadeur/animsource1/guard_pose.casc` (local,
ignored), with its animation-only `mh_guard_pose.glb` committed for receiver
playback and the shared-pose gate. Final guard measurements below are from the
normal imported path, at frame 0 and frame 20 of every move.

- Heel-to-heel stance: 53.775 cm long, 24.237 cm wide.
- Knee bends: 24.110/19.803 degrees (lead/rear).
- Torso blade: 37.986 degrees. Authored forward lean 7 degrees, additional head tuck 10 degrees.
- Pelvis lowering: 3.955 cm (4 cm controller target; solved joint is 0.45 mm above that target).
- Rear heel lift: 2.259 cm; rear ball height 1.213 cm, the original toe-ground height.
- Toe directions from ankle/ball joints: -19.995/-50.559 degrees; the native foot boxes are keyed at -25/-45 degrees plus the rear tilt.
- Lead wrist above shoulder: 18.449 cm; forward of head: 20.880 cm.
- Rear wrist-to-jaw landmark: 7.475 cm. Middle-finger flexion: 104.408/104.591 degrees; closed finger boxes retained from 1A.

Heel positions are reconstructed from the native quick-rig Self0 heel points
in each foot's rest basis; stance measurements are not ankle-distance proxies.
The jaw landmark is head origin plus (0, -0.06, 0.08) metres in the paired stage.
The shared-pose gate additionally compares all sampled joint/heel positions at
both endpoints to the actual guard clip, with a 2 mm ceiling. Every final move
has an endpoint discrepancy below 0.000001 m. The hip controllers are keyed as
well as pelvis points, so the gate measures an actual hip-joint turn.

## Final imported shape numbers

Arm chains measure 57.137 cm lead and 57.477 cm rear from shoulder-elbow-wrist.
Contact is frame 8 (0.266667 s); final guard frame 20; duration 0.666667 s;
30 fps. Jab/cross hold through frame 4, extend in 4 frames and return in 3.
The jab raises its lead shoulder and turns palm-down during the final third.
Cross shifts toward the lead leg and pivots about the rear ball. Hook traces an
outward arc and pivots about the lead ball. Uppercut chambers from the jaw guard
to chest height, dips, rises under the chin, and returns to the common guard.

| Move | Extension | Out/back s | Hip turn deg | Rear pivot deg | Contact elbow deg / height cm | Non-punch wrist-to-face cm | Max planted drift mm |
| --- | ---: | --- | ---: | ---: | --- | ---: | ---: |
| jab | 94.011% | 0.133333/0.100000 | 15.219 | 0.345 | 140.106 / 2.219 | 7.475 | 1.172 |
| cross | 94.509% | 0.133333/0.100000 | 51.360 | 30.109 | 141.831 / 4.039 | 14.736 | 8.399 |
| lead_hook | 69.857% | 0.133333/0.100000 | 52.002 | 0.073 | 88.529 / 3.869 | 7.475 | 0.341 |
| inside_uppercut | 46.653% | 0.266667/0.233333 | 27.836 | 2.374 | 55.521 / 12.986 | 14.736 | 6.135 |

Uppercut-specific gates: chamber-to-contact rise 24.000 cm,
horizontal displacement 6.405 cm, pelvis dip
7.996 cm, forearm angles
14.532, 10.769, 11.116, 11.691 degrees (frames 5-8),
elbow below the wrist throughout the rise, maximum hand step
7.352 cm. All are inside the original 1A uppercut limits.

The uppercut rise uses its actual chest-level chamber (frame 3), rather than
frame 0: a common jaw-level guard cannot simultaneously be its chest-level
starting wrist. This makes the new shared guard and the retained rise rule
compatible without weakening the rise/angle/dip/continuity limits. The 8 cm
per-frame continuity ceiling applies to the uppercut, as required by its 1A
rules; the deliberate fast straights have larger physically plausible steps.
Pivoting ankles are excluded from planted-ankle drift only for cross/rear and
hook/lead; their balls remain gated at 1 cm. Uppercut has no pivot exception.
Full precision evidence: `shape_1b.json`, `shape_imported_1b.json`, and
`guard_shape.json` in `Tools/cascadeur/animsource1/`.

## 1A negative witness

The new gates were first run on 1A before any punch was replaced. Original
1A bytes were retained locally in `_1a_clips/`, and the completed probe was
rerun on those identical bytes. `shape_1a_failures.json` records all four failures.
All four fail stance length/width, both knee bends, rear glove, torso blade,
shared guard and the non-punching glove. 1A's heel stance is about 24.02 x
36.26 cm, blade 12.01 degrees, knees about 12.71/2.28 degrees; rear glove is
18.77 cm from the jaw (29.09 cm on its uppercut guard).

| 1A move | Additional failed move-specific gates |
| --- | --- |
| jab | Extension 88.851% (<90%); out/back 0.266667/0.400000 s |
| cross | Out/back 0.266667/0.400000 s; hip turn 2.441 degrees; rear pivot 0.020 degrees |
| lead_hook | Elbow angle 68.524 degrees; height difference 13.841 cm; hip turn 27.464 degrees |
| inside_uppercut | Guard/other-glove gates above; its original rise, angle, dip and foot rules still pass |

## Animation-only packages

Each file has 341 native joints with the exact original names/parents, one
animation, no mesh nodes, meshes, materials, images or textures. Exact bytes:

| Clip | Bytes |
| --- | ---: |
| mh_guard_pose.glb | 544,348 |
| mh_jab.glb | 544,340 |
| mh_cross.glb | 544,344 |
| mh_lead_hook.glb | 544,348 |
| mh_inside_uppercut.glb | 544,352 |

All are below 600,000 bytes. Removed the 28 duplicate 1A texture files and their
28 .import companions, including the duplicate eye textures. Normalization
keeps the 1A packaging/unit repair; `animation_only.py` then removes render
payloads and deduplicates identical accessors without changing their bytes.
`validate_exports.py` checks hierarchy, absence of render data, size, alignment
and final hashes. `receipt_<move>.json`, `animation_only_<move>.json` and
`clip_manifest_1b.json` bind the source/raw/final files and payload checks.

The probe maps only AnimationPlayer NodePaths onto the original model's native
bones. No retarget, IK, Godot correction layer or post-export motion edits.
The static normalized armature transform is transferred unchanged; root tracks
are discarded only after checking they are constant. Attacker is the original
mh_boxer_01; receiver is the distinct mh_boxer_02, wearing blue trunks and
holding the common guard. Pair distances are computed from contact reach plus
both guard face positions: jab 0.969116 m, cross 0.917448 m, hook 0.834558 m;
inside uppercut 0.500000 m. Guard-only review uses 1.2 m for a clear silhouette.

## Private sheets for Claude

Opened all final imported sheets with the image tool, including guard side,
front and top, before recording their hashes in `frame_review_1b.json`.
Move sheets are 1920 x 1080, 12 frames: 0,2,4,5,6,7,8,10,12,15,18,20.
Guard stills are 480 x 360. All are PNG, plain background, both different men
head to feet. Front is oblique to show both figures; the inside pair naturally
occludes parts of each other at short range. Paths are local only:

- `E:/FightCamp/tmp/animsource1b/guard_side.png`
- `E:/FightCamp/tmp/animsource1b/guard_front.png`
- `E:/FightCamp/tmp/animsource1b/guard_top.png`
- `E:/FightCamp/tmp/animsource1b/jab_side.png`
- `E:/FightCamp/tmp/animsource1b/jab_front.png`
- `E:/FightCamp/tmp/animsource1b/cross_side.png`
- `E:/FightCamp/tmp/animsource1b/cross_front.png`
- `E:/FightCamp/tmp/animsource1b/lead_hook_side.png`
- `E:/FightCamp/tmp/animsource1b/lead_hook_front.png`
- `E:/FightCamp/tmp/animsource1b/inside_uppercut_side.png`
- `E:/FightCamp/tmp/animsource1b/inside_uppercut_front.png`

Sheets are for Claude's review; no image uploads or visible operator-desktop
viewers were used. Codex inspection is recorded; Claude opening/acceptance is
not claimed. The canonical main-checkout mailbox handoff fe58a9808baa supplies the private
paths for his review. The prescribed send command staged that new message in
the main checkout; it is separate from this branch's owned source commit.

## Validation and delivery boundaries

- Parse before Godot runs: `CHECK total=1 fails=0`; Python author/producer,
  finalizer, stripper and static validator compile; owned diff whitespace clean.
- Raw and imported final gates: moves=4 fails=0, no ERROR/SCRIPT ERROR in either.
- Actual per-move AutoPhysics CONVERGENCE and core-finished lines are retained
  in `physics_1b.json`. The verified hidden Cascadeur PID was stopped after
  exports; `hidden_desktop_1b.json` records it. Watchdog waits on RED between
  heavy stages; no visible Cascadeur/Godot windows or audio were launched.
- Godot uses only C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe,
  including captures via `godot_hidden.ps1` on the hidden desktop.
- Two editor imports: the first exposed default optimizer regressions (three
  imported shape failures). It also logged 56 stale-UID errors, two for each
  of the 28 deliberately removed legacy textures; none were new-clip import
  errors. Targeted AnimationPlayer optimizer/compression were disabled, with
  immutable tracks retained. The justified settings reimport returned rc=0
  with zero errors, and final imported shape/sheets passed.
- Task-specific source/probe gates supersede the generic full-suite habit;
  no full suite or gameplay edits. The task's branch/ownership instructions
  supersede master rebase, unrelated mailbox assignments and HANDOFF edits.
  Fetch succeeded; dirty unrelated import/UID files were preserved unstaged.
- The asset-production skill informed validation; game-dev CLI was unavailable.
  The task explicitly authorizes this existing local Cascadeur/normalization/
  capture workflow. No alternate provider, paid job or canonical-package flow.

Commit includes the supplied untracked TASK_ANIMSOURCE1B.md and only owned
scripts, animation packages/import settings, receipts and this digest. Push
codex/animsource1 only; no merge to master.
