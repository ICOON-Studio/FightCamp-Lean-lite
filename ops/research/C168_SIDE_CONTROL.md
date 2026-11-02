# C168 - One authored side-control hold

The clip is checkpointed before binding. Source: two fresh, identical Cascy rigs,
289 objects and one mesh each. Four seconds at 30 fps, 121 keys, 78 written
controllers per frame. No joint or mesh transform was written.

## Derivation and limitations

`build_side_control.py` requires two matching rest-controller tables. Proper
rigid rotations put the bottom fighter supine and the top fighter prone,
perpendicular across his chest. Chest controller-to-additional-point distance
(9.8481 cm) supplies a **body-depth proxy**, not a measured skin thickness.
Arm, leg, shoulder, hip and hand dimensions all come from the rest rig.
Cross-face and hip-control hands, and the bottom fighter's neck/hip frames,
are checked against that rig's arm reach before solving. Solved elbow and knee
controllers are excluded from writes. Feet use the rig's rest foot orientation.

One sinusoidal breathing cycle peaks at 0.4924 cm. This is an artistic amplitude,
not a footage-derived physiological claim. The controller hip-distance readback
is 42.15-42.16 cm over 25 samples; frame 0 and frame 120 both read 42.164 cm.
The tiny hip excursion comes from the solve; the torso controllers carry the
breathing. This is one hold, not an entry, escape, submission or transition.

Source visual review: Cascadeur screenshot at frame zero shows the perpendicular
pair with both meshes, bottom supine and top across the chest. This does not
establish game visual quality. The attempted kneeling-base construction does
**not** place the solved knees on the mat: they solve to about 31 cm high.
The clip therefore has a wide, foot-supported base, not verified knee support.
No retarget measurement was used to adjust the source pose.

## Authored contract: actual solved joint centres

`measure_contacts.py` measured the live scene, and its rounded-to-0.01-cm joint
positions below supply the new distances. Values are metres, not intended
controller targets. Four functional hand contacts plus chest and hip spacing
are declared before the game measurement. None will be dropped for failing.

| Probe contact | Authored metres |
|---|---:|
| att_lhand_to_vic_neck | 0.0672181523 |
| att_rhand_to_vic_hip | 0.1079189047 |
| vic_lhand_to_att_neck | 0.0671500558 |
| vic_rhand_to_att_hip | 0.0695793073 |
| chest_to_chest | 0.1969000000 |
| hip_to_hip | 0.4215999170 |

Lowest source joints: attacker toe_l 0.0289 m, victim foot_l 0.0887 m.
Joint height is not skin clearance. Chest centres are 0.1969 m apart.

| Actor | Joint | x cm | y cm | z cm |
|---|---|---:|---:|---:|
| att | pelvis | 27.52 | 27.80 | 27.52 |
| att | chest | 0.00 | 29.54 | 27.52 |
| att | neck | -26.87 | 27.01 | 27.53 |
| att | hand_l | -4.58 | 17.31 | 54.39 |
| att | hand_r | 9.60 | 16.52 | -0.00 |
| att | calf_l | 72.67 | 31.04 | 40.86 |
| att | calf_r | 72.66 | 31.09 | 14.16 |
| att | foot_l | 67.59 | 11.72 | 76.28 |
| att | foot_r | 67.59 | 11.72 | -21.23 |
| vic | pelvis | 0.00 | 11.59 | 0.00 |
| vic | chest | -0.00 | 9.85 | 27.52 |
| vic | neck | -0.00 | 12.39 | 54.39 |
| vic | hand_l | -26.87 | 31.93 | 32.10 |
| vic | hand_r | 22.60 | 32.72 | 27.52 |
| vic | calf_l | -15.86 | 18.13 | -44.50 |
| vic | calf_r | 15.86 | 18.14 | -44.50 |
| vic | foot_l | -19.61 | 8.87 | -83.91 |
| vic | foot_r | 19.61 | 8.88 | -83.91 |

## Reproduce source

1. Run `python Tools/cascadeur/ensure_server.py`; confirm with `csend.py -c
   "print(app.current_scene().name())"`.
2. Load `C:/Program Files/Cascadeur/samples/Cascy.casc`. Use File > Import >
   Import Scene To Current to import the same sample. Verify two Mesh Objects.
3. Run `csend.py Tools/cascadeur/dump_rig.py WORKDIR`, then
   `python Tools/cascadeur/build_side_control.py WORKDIR`.
4. Run `csend.py Tools/cascadeur/apply_clip.py WORKDIR`, then
   `csend.py Tools/cascadeur/measure_contacts.py WORKDIR`.
5. Inside the Cascadeur server process set `os.environ['CASCY_PAIR_KEY'] =
   'Cascy_SideControl'` and `WORKDIR`, then execute `export_pair.py`. Environment
   variables on the caller do not automatically propagate into the live app.
6. Run `strip_namespace_glb.py WORKDIR/Cascy_SideControl_Vic.glb`; copy the two
   GLBs into `Godot/assets/anim/audition/cascadeur/`.

The exported attacker/victim files were 3,222,412 / 3,223,156 bytes before victim
namespace stripping. Each export selected its own 289 objects and included
animation. The victim namespace stripper removed `character1:` from 68 names.

## Scope

The task-specific no-fetch/no-rebase, self-contained read window and no-HANDOFF
rules supersede the general startup, mailbox and handoff rules. No full suite.
No retarget, pose-solver, capsule or approach-band edits. The task requests
`gpt-6-astra`, MEDIUM; this report does not infer the actual app model from the
repository or change the user's model settings.

## Binding and game result

Operator correction: `bjj_side_control` is a technique ID, so the six-field
entry is in **PAIRED_STRIKE_BINDINGS**, beside `mma_dirty_boxing`, not in the
`grapple_*`-keyed PAIRED_BINDINGS table named in the original task. The operator
supplied its catalogue identity: Side Control, brazilian_jiu_jitsu, tier 1,
positions, control role, ground_top, prerequisite bjj_guard. No broader catalogue
or runtime source read was needed. It describes this hold without inventing a
new technique or binding an unrelated grapple event.

Direct GLB inspection: each file has 67 nodes, one pelvis hierarchy, one mesh
node, one animation and 198 channels. Cascadeur emits two skin records, but the
single mesh uses skin 1; these are not two exported actors. All channels carry
121 samples ending at 3.9999976158 s (float32 representation of four seconds).
102 output tracks change on each actor. Maximum raw first/last component delta
is 0.00001526 attacker / 0.00000763 victim; the loop is not claimed bit-exact.

The unchanged sampling calculation grafts both clips through PairedStagePlayer
on f01_m_box_welter and f02_m_box_heavy, nine samples over four seconds:

```text
S31CONTACT key=bjj_side_control content_s=4.000 samples=9
S31CONTACT measure                   authored      min      max     mean    drift
S31CONTACT att_lhand_to_vic_neck        0.067    0.094    0.094    0.094      40%
S31CONTACT att_rhand_to_vic_hip         0.108    0.123    0.126    0.125      15%
S31CONTACT vic_lhand_to_att_neck        0.067    0.156    0.156    0.156     133%
S31CONTACT vic_rhand_to_att_hip         0.070    0.114    0.118    0.116      66%
S31CONTACT chest_to_chest               0.197    0.226    0.226    0.226      15%
S31CONTACT hip_to_hip                   0.422    0.449    0.449    0.449       7%
S31CONTACT worst=vic_lhand_to_att_neck 133%
```

**Gate failed: worst 133%; three of six contacts exceed 30%.** Source pose and
contacts were frozen before that result and were not tuned to compensate.

## Where the chain loses contact

The export has motion and both single-actor files graft successfully. At t=0,
the existing probe's 18 torso/shoulder/arm direction comparisons agree with
source to at most 0.000401 degrees. The top and bottom torso orientations survive;
this is not evidence of the former synthetic UpperChest direction defect.
Lengths differ: source upper arm/forearm about 0.26369/0.23082 m; target attacker
0.26066/0.24325 m; target victim left arm 0.23875/0.29114 m. The victim forearm
is about 6.0 cm longer and upper arm about 2.5 cm shorter. Source Spine->Chest
is 0.16787 m versus target 0.12475/0.12774 m. Direction-preserving transfer onto
these different segment lengths does not preserve cross-character endpoints.
The victim neck frame is 0.156 m instead of 0.067 m, while hip spacing shifts
from 0.422 to 0.449 m. The loss is narrowed to target-body geometry/placement
through retarget and pair mounting, not a proven rotation loss. These data do
not allocate every centimetre between root placement and individual segments,
nor establish all-frame direction fidelity. No retarget or solver repair was
attempted under C168's ownership limits.

The inherited probe emits 108 out-of-tree global-transform errors for six
contacts (the clinch emits 90 for five), returning the established identity
fallback. There are zero SCRIPT ERROR or Parse Error lines. Measurement logic
was left unchanged; these are the requested instrument's results, not a claim
of an error-free probe. Nine sampled mean distances are not a maximum-per-frame
bound or a signed surface-contact test. Source GUI review is not target visual
review: no recorded live bout or game render was reviewed in this task.

## Follow-up: stage isolation before engine edits

The operator authorized FightClipRetarget.gd, PairedStagePlayer.gd and focused
tests, explicitly excluding FightPoseSolver.gd. `c168_contact_stage_test.gd`
compares source, direct retarget, animation registration with mounting suppressed,
and actual shared mounting, after scene-tree entry. 121 frames, mean distances:

| Contact | Source m | Retarget m | Graft m | Mount m |
|---|---:|---:|---:|---:|
| att left hand / vic neck | .067227239 | .094187234 | .094187234 | .094187234 |
| att right hand / vic hip | .108992762 | .124698441 | .124698441 | .124698441 |
| vic left hand / att neck | .067230228 | .156139068 | .156139068 | .156139068 |
| vic right hand / att hip | .071231152 | .115765129 | .115765129 | .115765129 |
| chest / chest | .196963256 | .226041488 | .226041488 | .226041488 |
| hip / hip | .421583131 | .449363882 | .449363882 | .449363882 |

Maximum contact change from graft: 0.000000000000 m; from identity mount:
0.000000000000 m. **Retarget changes the distance. Registration and mounting do
nothing to it in this reproduced configuration.** Source means differ slightly
from the frame-zero authored contract because the hold breathes; no contract
value was changed. Diagnostic parse total=1 fails=0; no engine errors.

A separate, unexported Cascadeur controller diagnostic showed that moving the
knee MainPoint (rather than the re-solved LimbDir point) brings knee centres to
about 3.7/6.1 cm, but also moves the feet. The original 121-frame source was
restored before the stage trace. No production GLB or contact fixture changed.

## Follow-up: contact preservation, first passing correction

The correction runs as an opt-in paired-retarget pass for bjj_side_control,
using animated source signed hand/anchor offsets and each target's own arm
lengths. It rotates upper arm, forearm and wrist; it does not translate/stretch
bones, alter source assets, change authored distances, or move the mount.
FightPoseSolver.gd remains unread and untouched. Other pairs do not opt in.

Original probe drifts are now **0%, 1%, 0%, 2%, 15%, 7%**, in the six-row order
above. Worst is chest spacing at 15%, below the 30% ceiling. RamsterZ remains
0.302639 / 0.304671; clinch left hand remains 15%.

The focused endpoint contract uses 241 samples (every key and halfway sample)
on both the identity pair and unequal body scales 0.93/1.08 under a rotated,
translated mount. 7,720 checks, zero failures; maximum per-sample declared drift
14.8173%, signed endpoint error 0.000000465 m, target limb-length error
0.000000149 m. It also asserts breathing occurs and the one-mount invariant.
The source/contact fixtures have not changed. This validates positions, not
skin intersection or the art quality of the elbow bend choice.

## Follow-up: knee controller repair and final source export

The leg-authoring bug was writing `calf_LimbDir` while excluding the knee's
`calf_MainPoint`. The limb solve overwrote the direction target. The generator
now writes the knee MainPoint and excludes the solver-owned calf LimbDir and
AdditionalPoint, while keeping foot targets. Both attacker knee joint centres
solve to **4.84 cm** above the mat instead of 31.04/31.09 cm. Feet remain at
11.72 cm. This is a source support improvement, not a retarget compensation.
Every previously named source contact in measure_contacts.py remains unchanged
at its reported precision; the declared six-contact contract remains untouched.
Both source files were re-exported and checkpointed in de782119.

Final endpoint contract after this export: 241 samples x two variants, 7,720
checks, zero failures. Worst per-sample drift 14.8173%; signed endpoint error
0.000000485 m; limb length error 0.000000179 m. Original nine-sample probe still
reports **0%, 1%, 0%, 2%, 15%, 7%**. These are positional results, not surface
collision or target knee-support certification. The attempted new source screen
capture did not capture Cascadeur, so it is not counted as visual validation.

The stage witness now prints the added paired-retarget pass separately. Final
source/independent-retarget/paired-retarget/graft/mount means for the worst
original hand contact are .067230328 / .156138549 / .067230327 / .067230321 /
.067230321 m. The max independent-repeat registration difference is
0.000000230968 m (floating-point noise), and mount difference remains exactly
zero. The initial pre-edit zero/zero localisation remains recorded above.
