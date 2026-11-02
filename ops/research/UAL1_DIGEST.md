# UAL1 digest

## Source animation inventory
- A_TPose
- Crouch_Fwd_Loop
- Crouch_Idle_Loop
- Dance_Loop
- Death01
- Driving_Loop
- Fixing_Kneeling
- Hit_Chest
- Hit_Head
- Idle_Loop
- Idle_Talking_Loop
- Idle_Torch_Loop
- Interact
- Jog_Fwd_Loop
- Jump_Land
- Jump_Loop
- Jump_Start
- PickUp_Table
- Pistol_Aim_Down
- Pistol_Aim_Neutral
- Pistol_Aim_Up
- Pistol_Idle_Loop
- Pistol_Reload
- Pistol_Shoot
- Punch_Cross
- Punch_Jab
- Push_Loop
- Roll
- Sitting_Enter
- Sitting_Exit
- Sitting_Idle_Loop
- Sitting_Talking_Loop
- Spell_Simple_Enter
- Spell_Simple_Exit
- Spell_Simple_Idle_Loop
- Spell_Simple_Shoot
- Sprint_Loop
- Swim_Fwd_Loop
- Swim_Idle_Loop
- Sword_Attack
- Sword_Idle
- Walk_Formal_Loop
- Walk_Loop

## Source bones
root, pelvis, spine_01, spine_02, spine_03, neck_01, Head, clavicle_l, upperarm_l, lowerarm_l, hand_l, index_01_l, index_02_l, index_03_l, index_04_leaf_l, middle_01_l, middle_02_l, middle_03_l, middle_04_leaf_l, pinky_01_l, pinky_02_l, pinky_03_l, pinky_04_leaf_l, ring_01_l, ring_02_l, ring_03_l, ring_04_leaf_l, thumb_01_l, thumb_02_l, thumb_03_l, thumb_04_leaf_l, clavicle_r, upperarm_r, lowerarm_r, hand_r, index_01_r, index_02_r, index_03_r, index_04_leaf_r, middle_01_r, middle_02_r, middle_03_r, middle_04_leaf_r, pinky_01_r, pinky_02_r, pinky_03_r, pinky_04_leaf_r, ring_01_r, ring_02_r, ring_03_r, ring_04_leaf_r, thumb_01_r, thumb_02_r, thumb_03_r, thumb_04_leaf_r, thigh_l, calf_l, foot_l, ball_l, ball_leaf_l, thigh_r, calf_r, foot_r, ball_r, ball_leaf_r

## Retarget and selection
Six real source takes, baked at 30 Hz via FightClipRetarget.retarget_clip. UALMotion supplies the named source take to the existing sample cache (the stock sampler selects only the first animation), with a map built from the actual UAL bone inventory above. Source glTF bind rest, not an animated frame, supplies corrections; silhouette_rest aligns segment axes from UAL T-pose to MetaHuman A-pose. MetaHuman intermediate spine/neck rests are folded once. Pelvis XZ stays constant; per-frame lowest foot/toe datum is planted at zero.

| Bake | Source | Length (seconds) | Use |
| --- | --- | ---: | --- |
| idle.res | Idle_Loop | 2.500 | Standing staff/member variant |
| talk.res | Idle_Talking_Loop | 2.933 | Standing gesture variant |
| sit_idle.res | Sitting_Idle_Loop | 1.667 | Seated staff variant |
| sit_talk.res | Sitting_Talking_Loop | 2.933 | Seated staff conversation variant |
| walk.res | Walk_Loop | 1.333 | MetaHuman GymHall walkers |
| walk_formal.res | Walk_Formal_Loop | 1.333 | Baked alternative, not currently selected in rooms |

The Standard inventory lacks neutral carrying, phone/typing, arms-crossed, clap/cheer, stretch and bottle drinking. Weapon/torch/spell loops are not substitutes. There is one neutral stand and one standing conversation take: two standing variants, not three fabricated motions. Clip choice and phase are stable by person ID (named room role where no identity exists). Lobby desk uses desk_name/owner_on_desk; StaffRoom uses coach ID. Lobby, LockerRoom, PhysioRoom and StaffRoom inherit the common staff selection. Legacy bodies retain the original boot clips and original c207 walker path. No certified combat clip or retarget module is edited.

MetaHuman ambient hall bodies must load through MetaHuman.load_fighter to get the same renamed skeleton/skin bind names as the baked clips. The previous raw GLTFDocument path retained UE5 joint names; the minimal loader choice is necessary for UAL playback and stays confined to ambient clips in the owned TrainingFloor file. Station/combat mounting is unchanged.

## Deliberately broken map witness
A temporary idle bake maps thigh_l/thigh_r to the upper arms. The actual test returned exit 1:
```
SAMPLE broken.res 0.000 feet 0.0000/0.9005 hips 0.9568 head 1.5671
FAIL broken.res both feet within 0.04m
```
The broken resource is deleted after this witnessed failure; it will not ship.

## Frame strips
1920x1080 JPEGs, coach top row and desk bottom row; columns at 0, 25, 50 and 75 percent of the source duration. Hidden desktop only, absolute executable supplied via FIGHTCAMP_GODOT_EXE:
`previews/ual1/{idle,talk,sit_idle,sit_talk,walk,walk_formal}.jpg`.
The file-tool inspection of all six strips showed relaxed arms, bent seated legs and alternating walk steps. No image viewer or visible Godot window was opened. These are authored contact sheets, not proof of an operator's live playthrough.

## Gates and specification exception
- Parse: `CHECK total=7 fails=0 autoload_refs=0 autoload_warnings=0` (all touched GDScripts, including UALMotion).
- Focused runner: `SUITE total=1 fails=0` (`--only ual_clips`), including output-error detection.
- Required direct geometry/playback test: `UAL RESULT: 0 failures`, exit 0, no script/runtime errors. Includes real staff `_add_body` mounts, stable ID selection, zero mount lift, renamed MH member mount and GymHall UAL walk selection.
- Affected systems: `SUITE total=18 fails=0`, serial (`--jobs 1`) because watchdog was AMBER, never RED. No full suite.
- Literal walk rule exception: both feet cannot remain within 4 cm during a real gait. The supplied walks have 6-18 cm swing-foot clearance. Test output preserves `INFO walk.res literal both-feet 0.04m: false` (same for walk_formal); walk gates require support contact <=4 cm, no foot below -4 cm, swing clearance <=22 cm, zero pelvis XZ travel and alternating steps. Standing clips still require BOTH feet <=4 cm, standing heads >1.45 m; seated hips are 0.563 m, inside the stated chair band. This is an explicit interpretation of the task's conflicting walking-contact wording, not an assertion that the literal rule passed.
- The temporary wrong-map resource failed the original strict check and was removed. Its right foot was 0.9005 m above floor; even the walking swing bound would reject that corruption.
- All six contact sheets inspected through the file tool. Existing shirt/skin intersections at bent shoulders are visible on the staff assets; clothing assets are outside this task's owned files.
- Task-owned files take precedence over the general HANDOFF habit; no shared HANDOFF block was edited. This branch supplies the digest for Claude's integration record.

## Reproduction
Set `GODOT_EXE` and `FIGHTCAMP_GODOT_EXE` to `C:/Users/user/AppData/Local/Programs/Godot/Godot_v4.7.2-stable_win64.exe`; never use redirected LOCALAPPDATA or the console executable.
Bake: absolute Godot executable, `--headless --path Godot --script tools/ual_strip.gd -- --bake`.
Red witness: append `--broken` to bake; run `tests/ual_clips_test.gd`, observe failure, delete only `assets/anim/ual/broken.res`.
Strips: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools/godot_hidden.ps1 --path Godot --resolution 1920x1080 --script tools/ual_strip.gd`.
Source archive extracted into the explicitly requested new `E:/FightCamp/tmp/ual1/` directory. Only the in-place GLB is admitted; root-motion variant remains outside the project.
