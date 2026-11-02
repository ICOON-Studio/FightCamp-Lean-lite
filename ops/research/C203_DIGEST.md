# C203 - standing source re-authoring (default OFF)

Recovered the two uncommitted C203 tools and rebased `codex/c203-standing-sources`
onto S77 base `2662c016cb173935fc77e62e655cd6c1715f7860` before implementation.
Production changes are confined to the allow-list and default-OFF static switch
`FightStagePlayer.standing_sources_v1`, set before player preparation. No changes to
FightClipRetarget, FightWorldLiveScreen, original clips or fighter rigs.
The task's no-HANDOFF rule supersedes the general handoff-block rule. No HANDOFF edits.

## Census and acceptance definition

50 distinct standing source files; four nonstanding files explicitly excluded.
Excluded sources: `wrestling_double_leg_takedown.glb`, `wrestling_body_slam.glb`, `judo_hip_throw.glb`, `wrestling_single_leg_takedown.glb`.
All bound director, typed-punch, technique and locomotion roles and variant takes
are covered; deduplicated by source path. Sample full source duration at 60 Hz,
including endpoints, rather than only the binding's cropped window (whole-strike
playback is enabled in the evidence bout). Print role aliases and exclusions.

Guard: H2H_Idle minimum pelvis **0.890309095 m**. Authored tolerance **0.040 m**;
floor **0.850309095 m**. The author targets 0.853309095 m, a 3 mm numerical margin,
with a 1 cm C1 smooth transition to untouched heights above the floor.
This is an authored guard-relative criterion, not a universal biomechanical limit.
Flexion = 180 degrees minus hip-knee-ankle included angle.
RamsterZ and Motifect use source Y=0 as mat. The native combo GLB is hip-origin:
its mat is inferred from the lowest rest-pose toe (-0.94921875 m), explicitly
reported as `mat_y`; its values are not raw hip-origin Y coordinates.

33 originals fall below the floor; 32 revised files all clear it. The remaining
H2H_StaggerLarge04_LowHit cannot reach the floor while retaining both foot targets
and leg lengths (four unreachable 60 Hz samples; attempted lateral shift up to
0.303 m). No revision is exported or bound for it. The new switch therefore does
not claim to remove every crouch in every standing animation.

## Source authoring and independent verification

Blender **5.2.1 LTS**, existing licensed RamsterZ source inputs, no provider jobs.
The game-dev CLI was unavailable; the task-authorized local Blender/Godot route
was used. Source FBX files import as animated transform hierarchies, not armatures.
A two-segment analytic IK solve uses original ankle targets and original knee
planes; the foot orientation is restored, preserving toe contact. Pelvis XY is
projected into both leg reach discs when a purely vertical lift is unreachable.
Leg segment lengths are preserved; there is no runtime pelvis clamp or floating
lower-body substitution. The hook requires at most 31 mm of horizontal pelvis
adjustment. Rejected low-hit authoring is not silently forced through.

Only pelvis and leg/foot keys are authored. Upper-body curves are not edited in
Blender. The export keeps the original 30 Hz upper-body sampling and substitutes
60 Hz lower curves from a dense export; no upper-body half-frame Euler resampling.
Original timestamps/held lead-ins and full clip durations are preserved. Exports
use new `_v1.FBX` names beside originals. Local rotations and translations for
spine, neck, head, shoulders, arms and hands are independently compared to original
source transforms in Godot, including half-frame samples. Global upper-body position
moves with the raised pelvis, as intended; punch articulation is unchanged.

`c203_verify_sources.gd`: **32/32 pass**. Gates: maximum ankle/toe displacement
<1 mm at 60 Hz, segment-length error <0.1 mm, upper local transform component error
<0.001, duration error <0.001 s, pelvis >= floor minus 1 mm numerical allowance.
Actual maximum errors across all revisions: 0.000781978 m contact, 0.000007689 m segment length, 0.000007621 upper local component. Every revised
census minimum is above the actual floor without using the numerical allowance.

The recovered census needed GLTFDocument loading for GLB and an explicit Motifect
leg-name map; unknown rigs now fail loudly. The recovered replay's exact career
fighter dictionaries and seed are retained. A one-frame FBX export offset and
between-key Euler interpolation were found and corrected before acceptance.

## Default-OFF and runtime evidence

Default-OFF compared to the unchanged S77 replay: **3600/3600 SHA256 pose hashes
identical** (1800 frames x two fighters, complete local bone poses plus skeleton
world transform). Static allow-list lookup is bypassed entirely while OFF.
The ON switch is only a source path substitution before sway sampling/retargeting;
mirroring, clip windows, event clocks, camera and S77 hand code are unchanged.

Seed **2288268096**, Nasir Larkin f01 versus Santiago Pereira f02, boxing;
full original C202 career dictionaries retained. Same configuration/camera in both
arms. The render's OFF poses also match all 3600 unchanged baseline hashes;
ON changes 3575/3600 poses, proving the new sources actually reach the replay.
Clip names and clocks remain equal in all 3600 final rows.

Both MP4s: **854x480, H.264, 30 fps, 420 frames, 14.000 seconds**, fully decoded
without error. Hidden launcher uses `--resolution 854x480`; the project's internal
1920x1080 viewport is scaled to 854x480 at encoding. Windows are bout frames
360-569 and 1110-1319, corresponding to simulation times 12.033-19.000 s and
37.033-44.000 s after each advance (C202's two demonstration windows). They are
concatenated in each video; the 60-second simulation runs continuously.

- [before](_captures/watch_loop/c203_before.mp4): MD5 `e230f8ac90820dfd34f13daaf1e75233`, 2590556 bytes.
- [after](_captures/watch_loop/c203_after.mp4): MD5 `ac5c89aaea7f0b0dbf8d8cec090838f0`, 2548218 bytes.

Visual review: opened decoded frames at every whole video second plus denser
hook-entry/recovery comparisons and a full-resolution hook-detail pair. This is
sampled review, not uninterrupted video playback. Both fighters stay visible in
the S77 overhead ring view. At hook recovery the red-gloved fighter in black shorts
is visibly taller with a straighter supporting leg; the toes stay at the same mat
locations rather than rising with the hips. Blue-gloved fighter in burgundy shorts
and the punch/guard sequence remain recognisable. The walking dip is reduced in
the second window. No floating-body workaround is visible in these reviewed samples.
The overhead view limits subtle knee/sole inspection, so the mat-relative table and
source contact checks accompany it. This does not certify every one of the 32 clips
artistically or remove the pre-existing realism failures.

### Mat-relative replay comparison at identical frames

Knees are included angles (180 = straight); toes are left/right height above the
actual arena mat, not the skeleton origin. Earlier changed clips can affect an
ON idle through the existing layer/inertia history; no idle source is replaced.

| Side/frame/clip | Pelvis before/after m | Knees before L/R deg | Knees after L/R deg | Toes before L/R m | Toes after L/R m |
|---|---|---|---|---|---|
| a/478/hook_lead | 0.821249/0.915291 | 123.458920/122.076804 | 154.179062/150.761359 | 0.017964/0.019280 | 0.018517/0.018954 |
| b/421/loc_strafe_right | 0.791159/0.877267 | 126.598540/93.701091 | 156.722488/110.914349 | 0.030340/0.020955 | 0.028899/0.022726 |
| a/1243/loc_strafe_right | 0.826360/0.915291 | 126.795126/93.136828 | 156.818698/110.274770 | 0.034997/0.029045 | 0.036074/0.027063 |
| b/1241/loc_retreat_right | 0.821539/0.877267 | 116.402734/97.717925 | 129.850051/109.547362 | 0.080624/0.021064 | 0.079324/0.022119 |
| a/60/idle | 0.926299/0.931291 | 100.398795/119.812228 | 101.545344/121.287207 | 0.064142/0.018164 | 0.063488/0.018164 |


## Full standing census

Names below share `res://assets/anim/audition/ramsterz_h2h/` unless otherwise noted.
An asterisk in the below-floor column identifies every original below the floor.
Toe ranges include airborne phases; these are not claims that both feet should
be planted throughout every kick or walk.

| Source | Min pelvis m | Max flexion deg | Below floor | Revised min m | Revised max flexion deg |
|---|---:|---:|:---:|---:|---:|
| H2H_LegSweep_InPlace.FBX | 0.377399 | 149.484 | * | 0.853309 | 79.093 |
| H2H_StaggerLarge04_LowHit.FBX | 0.496226 | 131.597 | * | - | - |
| H2H_SpinningElbow_Forward.FBX | 0.604596 | 121.662 | * | 0.853309 | 97.847 |
| H2H_SlipLeft.FBX | 0.699856 | 106.583 | * | 0.853309 | 78.673 |
| H2H_JabForward.FBX | 0.714589 | 96.604 | * | 0.853309 | 71.865 |
| H2H_Haymaker_InPlace.FBX | 0.715268 | 93.869 | * | 0.853309 | 65.363 |
| H2H_FadeBack.FBX | 0.731600 | 84.470 | * | 0.853309 | 58.055 |
| H2H_Haymaker_Forward.FBX | 0.735816 | 105.657 | * | 0.853309 | 92.791 |
| H2H_JumpingBackKick_InPlace.FBX | 0.739191 | 127.025 | * | 0.853309 | 127.025 |
| H2H_SlipRight.FBX | 0.763069 | 78.611 | * | 0.853309 | 64.721 |
| H2H_HookPunch_InPlace.FBX | 0.763861 | 74.147 | * | 0.853309 | 69.496 |
| H2H_WalkLeft.FBX | 0.764379 | 94.748 | * | 0.853309 | 92.946 |
| H2H_WalkRight.FBX | 0.764379 | 94.748 | * | 0.853309 | 92.946 |
| H2H_StraightPunchInPlace.FBX | 0.770212 | 76.048 | * | 0.853309 | 62.884 |
| H2H_BlockStart.FBX | 0.777327 | 86.828 | * | 0.853309 | 71.388 |
| H2H_StaggerSmall03.FBX | 0.809148 | 77.050 | * | 0.853309 | 70.090 |
| H2H_KneeStrike_Forward.FBX | 0.809337 | 147.069 | * | 0.853309 | 147.069 |
| H2H_RightCutKick_InPlace.FBX | 0.810414 | 114.677 | * | 0.853309 | 114.677 |
| H2H_SnappingBackfist_InPlace.FBX | 0.811892 | 81.370 | * | 0.853309 | 73.986 |
| H2H_JabInPlace.FBX | 0.814587 | 74.740 | * | 0.853309 | 66.499 |
| H2H_HighSideKick_InPlace.FBX | 0.815531 | 137.025 | * | 0.853309 | 137.025 |
| H2H_LowSideKick_InPlace.FBX | 0.815531 | 146.626 | * | 0.853309 | 146.626 |
| H2H_HitReaction03.FBX | 0.817574 | 80.423 | * | 0.853309 | 76.231 |
| H2H_StaggerMedium01.FBX | 0.822744 | 98.116 | * | 0.853309 | 98.116 |
| H2H_StaggerSmall02.FBX | 0.834005 | 99.217 | * | 0.853309 | 95.702 |
| H2H_StaggerMedium02.FBX | 0.834067 | 84.802 | * | 0.853309 | 84.802 |
| H2H_StaggerMedium04.FBX | 0.836832 | 81.564 | * | 0.853309 | 81.564 |
| H2H_WalkForward.FBX | 0.839086 | 86.980 | * | 0.853309 | 86.980 |
| H2H_WalkBack.FBX | 0.839086 | 83.600 | * | 0.853309 | 83.600 |
| H2H_WalkBackLeft.FBX | 0.839087 | 83.580 | * | 0.853309 | 83.580 |
| H2H_WalkForwardRight.FBX | 0.839087 | 87.011 | * | 0.853309 | 87.011 |
| H2H_WalkBackRight.FBX | 0.839087 | 83.530 | * | 0.853309 | 83.530 |
| H2H_WalkForwardLeft.FBX | 0.839087 | 86.983 | * | 0.853309 | 86.983 |
| H2H_StaggerMedium03.FBX | 0.850709 | 96.042 |  | - | - |
| H2H_HitReaction04.FBX | 0.860923 | 64.879 |  | - | - |
| H2H_StaggerSmall01.FBX | 0.864504 | 78.157 |  | - | - |
| tkd_back_kick.glb | 0.869082 | 108.212 |  | - | - |
| H2H_SpinningHookKick_InPlace.FBX | 0.870774 | 110.312 |  | - | - |
| H2H_HitReaction02.FBX | 0.885004 | 53.487 |  | - | - |
| H2H_HitReaction01.FBX | 0.889889 | 58.647 |  | - | - |
| H2H_Idle.FBX | 0.890309 | 46.695 |  | - | - |
| combo_jab_cross_hook.glb | 0.890386 | 66.891 |  | - | - |
| H2H_AxeKick_InPlace.FBX | 0.895745 | 67.826 |  | - | - |
| H2H_TornadoKick_Forward.FBX | 0.897805 | 107.786 |  | - | - |
| tkd_roundhouse_high.glb | 0.901138 | 131.855 |  | - | - |
| muay_thai_knee_clinch.glb | 0.902312 | 48.428 |  | - | - |
| tkd_front_kick_high.glb | 0.904518 | 137.434 |  | - | - |
| H2H_LeftCutKick_InPlace.FBX | 0.906301 | 102.359 |  | - | - |
| H2H_RoundhouseKick_InPlace.FBX | 0.912998 | 137.160 |  | - | - |
| tkd_side_kick.glb | 0.917997 | 112.182 |  | - | - |

Only the fixed-seed bout below receives visual review in this delivery; the other revised
clips have source-space numerical validation, not individual in-game artistic approval.
The production default remains OFF pending lead review.

## Revised asset SHA256 and source-contact errors

| Revision | SHA256 | Max ankle/toe error m | Max horizontal pelvis adjustment m |
|---|---|---:|---:|
| H2H_StraightPunchInPlace_v1.FBX | `9a41e08e56c71555bc8f880653fd07c8464ae0579eb09ffaf322ce1113deed60` | 0.000026205 | 0.000000 |
| H2H_HitReaction03_v1.FBX | `83f2ed4a0bfa985e7c6b661c40e643d1c81fff0d4ce2c573f4667d46061a00c5` | 0.000031868 | 0.000000 |
| H2H_StaggerSmall02_v1.FBX | `c8222413bac71faf316af1eed63f8b6756c7a7fdf092b0ad45e4457c2a6710cf` | 0.000044444 | 0.000000 |
| H2H_StaggerSmall03_v1.FBX | `3e95fe5d86b4ab3b3df00dac0f37996d639e0ff6309e8b5007b3ff083624bce3` | 0.000025977 | 0.000000 |
| H2H_StaggerMedium01_v1.FBX | `2709ee0cff594193f9c4896c19ec83dacf1a01bf6ee4437dba5a76301cba2d0e` | 0.000065274 | 0.000000 |
| H2H_StaggerMedium02_v1.FBX | `ba67bb5890694c969dae6cd0046e3bd1dd92d2fdf2204ce5c805cbc50ca6f70c` | 0.000027156 | 0.000000 |
| H2H_StaggerMedium04_v1.FBX | `724bfe2dfb97ca68db7b52b97fe909ae3361b2e8d55ff01c3ae3a938af48a72a` | 0.000043072 | 0.000000 |
| H2H_BlockStart_v1.FBX | `584181a418e24bf125c26e4a51e9ed513813aa74d99a46df25bc10e533d8f657` | 0.000021266 | 0.000000 |
| H2H_SlipLeft_v1.FBX | `8da30a71dfab63e656a0817eb1d59a3f3b2ef6e7ca7a6a5aff340c272cc2d4fa` | 0.000043562 | 0.000000 |
| H2H_SlipRight_v1.FBX | `3abf824d83ce08e5e4ec4e7c98e5c66af7027cac43b3620d0015fc53821afb76` | 0.000015728 | 0.000000 |
| H2H_FadeBack_v1.FBX | `a3cf95dc3a588fd577e1b8425b0cccc4473d63ae85e817c8d83da45d462feaff` | 0.000041052 | 0.000000 |
| H2H_JabInPlace_v1.FBX | `c74fa78b408cc2059b64127af9f9222ca50945fcc9d85809e84e0d0fdd2b237f` | 0.000052163 | 0.000000 |
| H2H_HookPunch_InPlace_v1.FBX | `128f9a46b515b2af085b8825023246da34841e4beaeeabdccf6a36b0215212d8` | 0.000037709 | 0.031232 |
| H2H_Haymaker_InPlace_v1.FBX | `19a1f3e58dc7fabdb6e0290e07b24df5106ac9f01a5a13a34794bf32897feb5a` | 0.000030581 | 0.034251 |
| H2H_KneeStrike_Forward_v1.FBX | `78eb272647bbf02e000beec7050fa5023a683de87146cfb8112b2309c897759a` | 0.000019283 | 0.000000 |
| H2H_RightCutKick_InPlace_v1.FBX | `6b0fb3a88a59ad8793b672b93823a6e3699f73628d7dd7e7c1078a229ba216ac` | 0.000012991 | 0.010297 |
| H2H_HighSideKick_InPlace_v1.FBX | `6b6877a934d41f572e0ee3186d0613931a740800fee90a2dce95dfa7266e189c` | 0.000040603 | 0.000000 |
| H2H_LowSideKick_InPlace_v1.FBX | `39b6c85371968e74f3f5427b854320c350d26067f5f84cfb75a02f347b54f6d3` | 0.000041245 | 0.002582 |
| H2H_LegSweep_InPlace_v1.FBX | `cdaaa2237c716bf65dc52079c85516dcd64d146285635024a456e1d804ac754c` | 0.000015134 | 0.228401 |
| H2H_JabForward_v1.FBX | `30ec88c19e73a39231355f2084ccdbca65460ba1cf948f9ed5e879e3ed6bcda3` | 0.000036870 | 0.015794 |
| H2H_SpinningElbow_Forward_v1.FBX | `fbf2a95663d48b365e17d314627bc12b6a4933c05fd6883c052de4869c277dfd` | 0.000034541 | 0.002499 |
| H2H_SnappingBackfist_InPlace_v1.FBX | `04a4b1752949102d44bdf896e7b89193d6cf57f4a3bef5a1c91a73e0a4fcff5d` | 0.000055352 | 0.000000 |
| H2H_JumpingBackKick_InPlace_v1.FBX | `eb0c51e89c72f6d6146e9fdffe12b0c8b464edf9832a87659fae4ab2e7da64eb` | 0.000015192 | 0.001694 |
| H2H_Haymaker_Forward_v1.FBX | `c9e56aed35e4fe6625925d3e4555a3361d08eaab98ca9fa6be9f55322586544a` | 0.000015223 | 0.029795 |
| H2H_WalkForward_v1.FBX | `122d4e2fa33a595fe2169cc3aa648f9d78f48e3f08667d6940bcb85c62c5e143` | 0.000074248 | 0.000000 |
| H2H_WalkForwardLeft_v1.FBX | `b42b57e8fa237e8e65cd4ccb250937a41a14ec34e502d556f9f5b5c185cb3844` | 0.000045064 | 0.000000 |
| H2H_WalkForwardRight_v1.FBX | `bacd9590ac9fdc5af01ae3d6a6bfc1ef77720c56e034c56b21aaef7faafe44e3` | 0.000781978 | 0.000000 |
| H2H_WalkLeft_v1.FBX | `52d59760b5cbd25d1cd44a50e814e98289fd262625acb036f40b010557a4ece1` | 0.000038887 | 0.004204 |
| H2H_WalkRight_v1.FBX | `419119d3dce8ffcf987d29b594a4d773a7077a59923e5790953048065d93e023` | 0.000031621 | 0.004204 |
| H2H_WalkBackLeft_v1.FBX | `326ea762c42b65c2733681863f3ddd888e4993c5dd21799f54d4a5870c1a146c` | 0.000042864 | 0.000000 |
| H2H_WalkBackRight_v1.FBX | `d94eafb756b009ab6e8d6f6d21ecc236d174062e1ea116a9ff0cbe3cfe224f18` | 0.000043498 | 0.000000 |
| H2H_WalkBack_v1.FBX | `07603a4e882eeac0d3565185993a36ef246e6e7b04c6a71136c85e58265e7d28` | 0.000045670 | 0.000000 |

## Reproduce

1. Parse the five C203/production scripts with `check_scripts.py` before execution.
2. Run `tools/c203_standing_census.gd` headless. It prints every source, revision,
   alias and exclusion and writes `.godot/c203/census.json`.
3. To re-author: run `tools/c203_author.gd` to materialize the embedded Python;
   after Godot exits, run Blender 5.2.1 `--background --factory-startup --python
   Godot/.godot/c203_author.py`. It writes candidates and `.godot/c203/author.json`.
   Never run Blender and Godot jobs concurrently. This overwrites generated `_v1`
   candidates only, never originals. Run source verification before using candidates.
4. Run `tools/c203_verify_sources.gd`; JSON goes to `.godot/c203/verified.json`.
5. Replay `tools/c203_replay.gd -- arm=off` or `arm=after`. Use the hidden launcher
   for recordings with `--rendering-method gl_compatibility --rendering-driver opengl3
   --fixed-fps 30 --resolution 854x480 -- arm=before record=true` (or `arm=after`).
   Encode the 420 numbered PNG frames at 30 fps, H.264 CRF20 yuv420p, 854x480.
6. Exact focused gate: `python Godot/tools/run_tests.py --only
   fight_stage,fight_world,fight_clip,fight_body_layers --jobs 1`. No full suite.

## Gates

- Author tool emission SHA256 matches the exact executed Blender Python.
- Final parse gate: `CHECK total=5 fails=0`.
- Required focused subsets: **SUITE total=25 fails=1**. Only
  `fight_stage_realism_test.gd` fails: `TOTAL=13 fails=8`, equal to C202's known red.
  No tests or assertions were edited to accommodate the source changes.
- Frozen rig fixture: **SUITE total=1 fails=0** (`rig_convention_contract`).
  RamsterZ posed-bone SHA256 remains
  `83f6a766b4dc398d3abda6526f58692f3c4925f680fc4fbe0300654c7289f9ea`.
- Independent authored-source verification: **32/32 pass** at 60 Hz.
- Census: **50 originals + 32 revisions, 4 exclusions, 0 errors**.
- No full suite, no change to retargeting, original clips or canonical rigs.
- Existing FBX buffer/shutdown warnings remain; they are not suppressed or counted
  as successful proof. Final census, source verification, before and after logs contain no SCRIPT ERROR or ERROR lines.
