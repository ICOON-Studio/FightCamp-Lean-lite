# C92 — Striking clip content windows

## Method

The audit was parsed and run from the repository root with:

```powershell
$env:GODOT_EXE='C:\ProgramData\chocolatey\bin\godot.exe'
python Godot/tools/check_scripts.py Godot/tools/audit_striking_content.gd
& 'C:\ProgramData\chocolatey\bin\godot.exe' --headless --path Godot --script tools/audit_striking_content.gd
```

The tool opens each FBX directly with `FBXDocument`, takes the first animation,
and scans every track key. `first_s` is the minimum key time over all tracks,
`last_s` is the maximum, `content_s = last_s - first_s`, and
`dead_air_s = file_s - content_s`. Travelling is `yes` when the keyed pelvis
position span exceeds 0.1 m. Bones moved is the number of the 22 named UE4
humanoid rows which carry at least one key.

`readable_s` is an honest proxy, not measured contact. At 120 Hz, plus every
exact track-key time, the tool interpolates the animation's position, rotation,
and scale track values and composes the known UE4 parent chains. It never calls
`get_bone_global_pose()`. For each sample it measures both hands and both feet
relative to the pelvis against their positions at `first_s`; `readable_s` is the
time of the greatest displacement, expressed from `first_s`. This approximates
contact for strikes and maximum displacement for defences/reactions. If no
complete pelvis-to-extremity chain had both position and rotation tracks, the
row says `NOT MEASURED` rather than inventing a peak.

The folder contains 124 FBX files. The concrete C92 name filters selected 71.
The other 53 were skipped: 17 `_RootMotion` engine-owned duplicates, 24
non-striking `Walk*`/`Run*`/`Sprint*`/`Turn*`/`Jump*` locomotion clips, 2
`Equip`/`Unequip` clips, and 10 files outside the specified strike, defence, and
reaction name patterns (meshes/reference poses, idles, charge clips, and other
unlisted names).

## Per-clip measurements

All times are seconds; root travelling uses the 0.1 m threshold.

| clip | file_s | first_s | last_s | content_s | dead_air_s | travelling | bones moved | readable_s |
|---|---:|---:|---:|---:|---:|:---:|---:|---:|
| H2H_AxeKick_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.333 |
| H2H_BackflipKick_InPlace.FBX | 1.333 | 0.000 | 1.333 | 1.333 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_BarrelRollKick_Forward.FBX | 1.267 | 0.000 | 1.267 | 1.267 | 0.000 | yes | 21 | 0.700 |
| H2H_BlockEnd.FBX | 2.333 | 2.000 | 2.333 | 0.333 | 2.000 | yes | 20 | NOT MEASURED |
| H2H_BlockIdle.FBX | 0.767 | 0.000 | 0.767 | 0.767 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_BlockLoop.FBX | 2.000 | 0.333 | 2.000 | 1.667 | 0.333 | no | 21 | NOT MEASURED |
| H2H_BlockStart.FBX | 0.333 | 0.000 | 0.333 | 0.333 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_Dodge_Back.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_Dodge_Forward.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_Dodge_Left.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_Dodge_Right.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_FadeBack.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_FlipAxeKick_Forward.FBX | 0.900 | 0.000 | 0.900 | 0.900 | 0.000 | yes | 21 | 0.367 |
| H2H_FrontflipKick_Forward.FBX | 1.067 | 0.000 | 1.067 | 1.067 | 0.000 | yes | 21 | 0.333 |
| H2H_GetUp01.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.400 |
| H2H_GroinPunch_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_Haymaker_Forward.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 19 | NOT MEASURED |
| H2H_Haymaker_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 19 | NOT MEASURED |
| H2H_HighSideKick_InPlace.FBX | 1.167 | 0.000 | 1.167 | 1.167 | 0.000 | yes | 21 | 0.467 |
| H2H_HitReaction01.FBX | 3.033 | 2.467 | 3.033 | 0.567 | 2.467 | no | 20 | NOT MEASURED |
| H2H_HitReaction02.FBX | 4.000 | 3.067 | 4.000 | 0.933 | 3.067 | no | 21 | NOT MEASURED |
| H2H_HitReaction03.FBX | 4.867 | 4.033 | 4.867 | 0.833 | 4.033 | no | 21 | 0.400 |
| H2H_HitReaction04.FBX | 5.800 | 4.900 | 5.800 | 0.900 | 4.900 | no | 21 | NOT MEASURED |
| H2H_HookPunch_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_JumpSpinHookKick_Forward.FBX | 1.133 | 0.000 | 1.133 | 1.133 | 0.000 | yes | 21 | 0.700 |
| H2H_JumpingBackKick_Forward.FBX | 0.900 | 0.000 | 0.900 | 0.900 | 0.000 | yes | 21 | 0.167 |
| H2H_JumpingBackKick_InPlace.FBX | 0.900 | 0.000 | 0.900 | 0.900 | 0.000 | yes | 21 | 0.167 |
| H2H_JumpingUppercut_Forward.FBX | 1.533 | 0.000 | 1.533 | 1.533 | 0.000 | yes | 19 | 0.433 |
| H2H_JumpingUppercut_InPlace.FBX | 1.533 | 0.000 | 1.533 | 1.533 | 0.000 | yes | 19 | 0.433 |
| H2H_KneeStrike_Forward.FBX | 0.900 | 0.000 | 0.900 | 0.900 | 0.000 | yes | 21 | 0.367 |
| H2H_KnockDown01.FBX | 1.933 | 0.000 | 1.933 | 1.933 | 0.000 | yes | 21 | 0.867 |
| H2H_KnockDown02.FBX | 2.000 | 0.000 | 2.000 | 2.000 | 0.000 | yes | 21 | 0.333 |
| H2H_LeadingUppercut_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.533 |
| H2H_LeftCutKick_Forward.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.400 |
| H2H_LeftCutKick_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.167 |
| H2H_LegBlockEnd.FBX | 2.333 | 2.000 | 2.333 | 0.333 | 2.000 | no | 21 | NOT MEASURED |
| H2H_LegBlockIdle.FBX | 0.767 | 0.000 | 0.767 | 0.767 | 0.000 | no | 21 | NOT MEASURED |
| H2H_LegBlockLoop.FBX | 2.000 | 0.333 | 2.000 | 1.667 | 0.333 | no | 21 | NOT MEASURED |
| H2H_LegBlockStart.FBX | 0.333 | 0.000 | 0.333 | 0.333 | 0.000 | no | 21 | NOT MEASURED |
| H2H_LegSweep_InPlace.FBX | 0.767 | 0.000 | 0.767 | 0.767 | 0.000 | yes | 21 | 0.200 |
| H2H_LowSideKick_InPlace.FBX | 1.167 | 0.000 | 1.167 | 1.167 | 0.000 | yes | 21 | 0.467 |
| H2H_PowerHayMaker_Forward.FBX | 1.133 | 0.000 | 1.133 | 1.133 | 0.000 | yes | 21 | 0.567 |
| H2H_PowerPunch01_Forward.FBX | 2.133 | 0.000 | 2.133 | 2.133 | 0.000 | yes | 21 | 1.433 |
| H2H_RightCutKick_Forward.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.567 |
| H2H_RightCutKick_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | 0.567 |
| H2H_RoundhouseKick_InPlace.FBX | 0.700 | 0.000 | 0.700 | 0.700 | 0.000 | yes | 21 | 0.233 |
| H2H_SlipLeft.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 17 | NOT MEASURED |
| H2H_SlipRight.FBX | 0.667 | 0.000 | 0.667 | 0.667 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_SnappingBackfist_InPlace.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_SpinningElbow_Forward.FBX | 1.133 | 0.000 | 1.133 | 1.133 | 0.000 | yes | 21 | 0.500 |
| H2H_SpinningHookKick_InPlace.FBX | 0.800 | 0.000 | 0.800 | 0.800 | 0.000 | yes | 21 | 0.233 |
| H2H_StaggerFromBehind01.FBX | 1.233 | 0.000 | 1.233 | 1.233 | 0.000 | no | 21 | NOT MEASURED |
| H2H_StaggerFromBehind02.FBX | 3.000 | 1.533 | 3.000 | 1.467 | 1.533 | yes | 21 | NOT MEASURED |
| H2H_StaggerLarge01.FBX | 2.633 | 0.000 | 2.633 | 2.633 | 0.000 | yes | 21 | 2.100 |
| H2H_StaggerLarge02.FBX | 5.767 | 2.667 | 5.767 | 3.100 | 2.667 | yes | 21 | 1.033 |
| H2H_StaggerLarge03.FBX | 8.800 | 5.800 | 8.800 | 3.000 | 5.800 | yes | 21 | 0.500 |
| H2H_StaggerLarge04_LowHit.FBX | 11.533 | 8.833 | 11.533 | 2.700 | 8.833 | yes | 21 | 0.900 |
| H2H_StaggerLarge_FromBehind01.FBX | 2.333 | 0.000 | 2.333 | 2.333 | 0.000 | yes | 21 | 1.400 |
| H2H_StaggerLarge_FromBehind02.FBX | 2.633 | 0.000 | 2.633 | 2.633 | 0.000 | yes | 21 | 0.633 |
| H2H_StaggerLarge_FromBehind03.FBX | 3.000 | 0.000 | 3.000 | 3.000 | 0.000 | yes | 21 | 0.633 |
| H2H_StaggerMedium01.FBX | 1.767 | 0.000 | 1.767 | 1.767 | 0.000 | yes | 21 | 0.800 |
| H2H_StaggerMedium02.FBX | 3.633 | 1.900 | 3.633 | 1.733 | 1.900 | no | 21 | 0.933 |
| H2H_StaggerMedium03.FBX | 5.267 | 3.667 | 5.267 | 1.600 | 3.667 | no | 21 | 0.567 |
| H2H_StaggerMedium04.FBX | 6.800 | 5.300 | 6.800 | 1.500 | 5.300 | no | 21 | 0.700 |
| H2H_StaggerSmall01.FBX | 1.000 | 0.000 | 1.000 | 1.000 | 0.000 | no | 21 | NOT MEASURED |
| H2H_StaggerSmall02.FBX | 2.433 | 1.033 | 2.433 | 1.400 | 1.033 | yes | 21 | 0.533 |
| H2H_StaggerSmall03.FBX | 7.033 | 5.833 | 7.033 | 1.200 | 5.833 | yes | 21 | 0.333 |
| H2H_StraightPunchForward.FBX | 0.833 | 0.000 | 0.833 | 0.833 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_StraightPunchInPlace.FBX | 0.833 | 0.000 | 0.833 | 0.833 | 0.000 | yes | 21 | NOT MEASURED |
| H2H_TornadoKick_Forward.FBX | 0.900 | 0.000 | 0.900 | 0.900 | 0.000 | yes | 21 | 0.533 |
| H2H_TrippleSpinningHookKick_Forward.FBX | 1.600 | 0.000 | 1.600 | 1.600 | 0.000 | yes | 21 | 0.233 |

## Ready-to-paste zero-dead-air block

These are fifteen of the clips tied for least dead air (0.000 s), restricted to
rows whose `readable_s` proxy was measured. Keys are the clips' own short names,
not engine technique ids. `length_s` is content length, never FBX file length.

```gdscript
"AxeKick_InPlace": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_AxeKick_InPlace.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.000, "start_s": 0.000, "end_s": 1.000, "readable_s": 0.333,
},
"BarrelRollKick_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_BarrelRollKick_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.267, "start_s": 0.000, "end_s": 1.267, "readable_s": 0.700,
},
"FlipAxeKick_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_FlipAxeKick_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 0.900, "start_s": 0.000, "end_s": 0.900, "readable_s": 0.367,
},
"FrontflipKick_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_FrontflipKick_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.067, "start_s": 0.000, "end_s": 1.067, "readable_s": 0.333,
},
"GetUp01": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_GetUp01.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.000, "start_s": 0.000, "end_s": 1.000, "readable_s": 0.400,
},
"HighSideKick_InPlace": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_HighSideKick_InPlace.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.167, "start_s": 0.000, "end_s": 1.167, "readable_s": 0.467,
},
"JumpSpinHookKick_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_JumpSpinHookKick_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.133, "start_s": 0.000, "end_s": 1.133, "readable_s": 0.700,
},
"JumpingBackKick_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_JumpingBackKick_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 0.900, "start_s": 0.000, "end_s": 0.900, "readable_s": 0.167,
},
"JumpingBackKick_InPlace": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_JumpingBackKick_InPlace.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 0.900, "start_s": 0.000, "end_s": 0.900, "readable_s": 0.167,
},
"JumpingUppercut_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_JumpingUppercut_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.533, "start_s": 0.000, "end_s": 1.533, "readable_s": 0.433,
},
"JumpingUppercut_InPlace": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_JumpingUppercut_InPlace.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.533, "start_s": 0.000, "end_s": 1.533, "readable_s": 0.433,
},
"KneeStrike_Forward": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_KneeStrike_Forward.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 0.900, "start_s": 0.000, "end_s": 0.900, "readable_s": 0.367,
},
"KnockDown01": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_KnockDown01.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.933, "start_s": 0.000, "end_s": 1.933, "readable_s": 0.867,
},
"KnockDown02": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_KnockDown02.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 2.000, "start_s": 0.000, "end_s": 2.000, "readable_s": 0.333,
},
"LeadingUppercut_InPlace": {
	"path": "res://assets/anim/audition/ramsterz_h2h/H2H_LeadingUppercut_InPlace.FBX",
	"retarget": true,
	"reference": "res://assets/anim/audition/ramsterz_h2h/T_pose.fbx",
	"length_s": 1.000, "start_s": 0.000, "end_s": 1.000, "readable_s": 0.533,
},
```

## Totals

- Files measured: **71**
- Total content: **86.967 s**
- Total dead air: **55.700 s**
- Worst single offender: **H2H_StaggerLarge04_LowHit.FBX** — **8.833 s** dead air
- Reliable `readable_s` proxies: **42 of 71**
