# MOVE SCRIPT - BOXING (v0, Claude, 2026-09-14)

The operator, 2026-09-14: "it looks like each part of body have each own sped", "There is no cohesion between animations
and reactions", "Have you written a proper script o. How to execute the moves?", "Their distance is off", "Why you don't
use tools like blender ?". This file is that script. One EXCHANGE (a technique and its outcome) is ONE document for BOTH
fighters on ONE clock; it is authored as ONE Blender scene (`Tools/blender_moves/author_pair.py` + a spec in
`Tools/blender_moves/specs/`) and played in the room as ONE pair (`FightMoveScript.gd` schedules it; `tools/watch_pair.gd`
shows it).

## DECISIONS

- **The clock**: 60 fps, frame 0 = CONTACT (glove front meets face front). Thrower and receiver keyed to the same frames.
- **Distance is part of the move**: head-height jabs in two-man footage (batch 2, n = 31) start at a hip gap of **2.23 T**
  (p10-p90 1.77-2.68), land at **2.06 T** (1.80-2.63) and reopen - T = torso length, 0.51 m on f01 (1.14 m node gap).
- **The jab is thrown mostly in place**: hips p50 +0.04 T (p90 0.14), lead ankle p50 +0.02 T (p90 0.23), extension
  p50 0.10 s. The bought RamsterZ jab steps 3-10x that (hips 0.49 T, lead ankle 0.71 T): authored at x0.2 with the rear
  foot held by leg IK.
- **The glove's path is authored, not patched**: the bought jab passes 0.31 m wide and 0.26 m low of a real head. An IK
  target TRAVELS on the pair clock - the hand where it is at -12 f, the face front at 0 to +2 f, the stance guard at
  +18 f, the guard until the strike blends out (+36 f) - so nothing snaps when it lets go.
- **The receiver reacts on contact, at jab strength**: react_head starts on frame 0 at 0.55 of full strength (full
  strength threw the head 0.66 T back in 0.2 s; sparring footage 0.2-0.38 T).
- **BOX_JAB_HEAD_LAND v0 is authored (variant D)**; every other exchange below is TO AUTHOR, in the order the engine shows them.

## Sources, in the order they win

1. FOOTAGE, two men (`S4A_PAIRS/footage_batch2_two_men.json`: ExpertBoxing partner drills at 50 fps + PXB sparring at 30 fps,
   MediaPipe, identity by hip continuity, side-on segments only). Operator ruling: technique detail comes from watching.
2. FOOTAGE, one man (`V1_BOXING_FROM_VIDEO.md`, batch 1: coaches' demonstrations, no opponent - a man's own body only).
3. OUR MOCAP (`Q107_MOCAP_CHAIN.md`: the bought clips on f01 through production - what they do, not what boxers do).
4. UNREAL 5.8 SOURCE for how shipped engines play and fit a pair (C127 Contextual Animation, C121 warping, C129 stride warping).
Where none has a number the field says TO MEASURE - never an invented one.

## BOX_JAB_HEAD_LAND (v0 authored: `specs/BOX_JAB_HEAD_LAND_IN_PLACE.json`)

| field | thrower (f01, orthodox, lead = LEFT) | receiver (f09) | source |
|---|---|---|---|
| enter | stance, phase 0 | stance, half a cycle later | M18 (two men in sync read as aerobics) |
| gap before / contact / after | 2.17 / 2.06 / 2.17 T (authored) | - | footage 2.23 / 2.06 / 1.99 T |
| take | `jab` (H2H_JabInPlace), forward travel x0.2 | `react_head` (H2H_HitReaction01) at 0.55 | Q107; footage |
| strike starts | -14 f (the take's own contact frame) | - | the take |
| chain by speed peak | rear foot -7, hips -5, shoulders -5, upper arm -5, forearm -1, fist -1 f | - | Q107 (the mocap) |
| chain in real boxers | TO MEASURE (60 fps two-man footage; K59 bouts) | TO MEASURE | - |
| extension | 0.23 s in the take | - | footage p50 0.10 s (p10-p90 0.06-0.20) |
| hips / lead ankle / rear ankle travel to contact | +0.11 / +0.20 / +0.08 T (front foot's step x0.6 about where it stood, C129) | 0 | footage p50 +0.04 / +0.02 / 0.00 T, p90 0.14 / 0.23 / 0.15 |
| contact | glove front on face front, 1 cm short, path keyed -12..+18 f | head starts moving on frame 0 | authored; Q107 react_head hips peak +1 f, head +5 f |
| guard hand | rear glove stays at chin (the take) | open-hand guard (f09's stance) | the takes |
| response at +0.2 s | - | head 0.37 T back | sparring footage 0.2-0.38 T |
| exit | back to guard by +18 f, stance by +36 f | reaction blends to stance by +48 f | authored |
| selection range | node gap 1.02-1.26 m | | authored (+-0.12 m) |

`python Tools/measure_pair.py S4A_PAIRS/BOX_JAB_HEAD_LAND_IN_PLACE.pair.json --footage S4A_PAIRS/footage_batch2_two_men.json`: all six
footage-comparable numbers inside the footage's p10-p90 (it reads only the exported JSON and agrees with the Blender scene to
0.0001 T). Known gaps in v0: the rear foot lock drifts up to 5.5 cm; the receiver's head reaction has no measured onset lag
(K60 is finding whole-body landed-punch footage); react_head's direction is the clip's, not the glove's.

**v1 (2026-09-14 night, branch `claude/s4a-combos`, not merged).** The v0 pairs FOLDED (chest +13 deg, lead knee 54 deg, two hip dips -
Q109: footage p50/p90 4/12.8 deg and 12/33 deg) and hid two defects: the bought jab straightens the arm between two 30 fps keys (wrist 26 cm
in one 60 fps frame) and the glove IK flipped the wrist 25 cm on the contact frame. v1 authors from the source: `vertical_scale` 0.2 (the
step's hip dip scaled with its travel, feet held by leg IK), `pitch_scale` 0.3, `extension_s` 0.10 (the take's clock retimed, poses
untouched), `aim.mode swing` (the take's own arm turned about its shoulder onto the face - no IK), distance `swing_reach` (the men stand
where that arm reaches: 2.28 T / 2.40 T at contact, footage p50 2.29), front step x0.3, selection -0.20/+0.15 m. Both pairs inside two-man
p10-p90 on pitch, knees, dips and gap. A Higgsfield/Meshy library jab through `glb_clip_to_bridge.py` measures the same (U106 29/34 v 28/34).
**Operator: "About the same"; next "Author the next punches"** - the exchanges below, with the v1 method.

## The other exchanges - TO AUTHOR

| exchange | thrower take | receiver take | first numbers to measure |
|---|---|---|---|
| BOX_JAB_HEAD_BLOCKED | jab | block | gap at contact; glove meets glove |
| BOX_JAB_HEAD_SLIPPED | jab | slip | slip onset vs the jab's extension |
| BOX_CROSS_HEAD_LAND | cross | react_head | gap at contact (V1: cross in place, hips +0.02 T) |
| BOX_LEAD_HOOK_HEAD_LAND | hook_lead | react_head#3 | hook distance (V1: body barely travels, rear heel pivots) |
| BOX_REAR_HOOK_HEAD_LAND | hook_rear | react_head#3 | the mirrored hook's stance swap (U90) |
| BOX_BODY_SHOT_LAND | strike_body | react_body | receiver trunk response |
| BOX_UPPERCUT_HEAD_LAND | (H2H_LeadingUppercut_InPlace, unbound) | react_head#1 | uppercut range |
| BOX_OVERHAND_HEAD_LAND | boxing_overhand | react_head#2 | - |

## How an exchange is played in the room (C127, `FightMoveScript.gd`)

Selected by gap (first authored range that holds the current node gap, else the nearest); both takes start at ONE origin
`impact - contact_s` (a combination punch seeks both by the same amount); both bodies ease to the pair's gap with
HermiteCubic by `entry_s`; both players are sampled at ONE pair time every frame; per-part layers (foot lock, aim, push,
warp) stay off for the pair's frames.

**BUILT 2026-09-14** (`FightLiveSchedule.add_pair`, `FightWorldLiveScreen._present_pair`, `FightStagePlayer.play_pair`;
tests `fight_pair_schedule_test.gd`, `fight_pair_live_test.gd`; A/B `pairs=off`). Assets: `Godot/assets/anim/pairs/`
`BOX_JAB_HEAD_LAND_F01_F09` and its mirror `F09_F01` (author with `specs/<id>.json`; the spec's `exchange` and each role's
`move` name the takes `jab#pair_<id>` / `react_head#pair_<id>`). Also: after a combination's seek skips `entry_s` the gap
eases to contact instead; a flinch from THIS thrower's earlier blow landing before contact merges into the pair's
reaction; anything else due on either man before contact, a busy receiver, a knockdown or a gap outside the range falls
back to the two clips, counted (`pair_stats`). Measured on 3 bouts: 18 of 44 landed head jabs played the pair (18 out of
range), its jabs reached the head 9 of 9 (the clips 45 of 166), R7 leg overlap +0.6 pp at its 1.138 m start gap.
**OPERATOR, shown it at 0:14 and 1:31 of seed 810039: "About the same"; next "Smooth the jab in combos"; "the body of
right is folding unnaturally at some point".** The fold is authored: the bought jab drops the hips ~10 cm twice for its
step and the pair kept both dips under a x0.2 step - the thrower sinks 0.17 T twice and tips forward +10 -> +24 deg;
real head-height jabs sink 0.00/0.03/0.08 T in batch 2's partner drills (n=31) but 0.00/0.08/0.29 T pooled with batch 3's bouts (n=104; batch 3 alone 0.03/0.12/0.29, and 64 of the 104 are one ringside pro bout, wzUWvsviqTM) - so 0.17 T is INSIDE the pooled range: the fold is likely the two dips within 0.7 s and the torso tipping forward (+10 -> +24 deg after contact), not the depth alone (`thrower_hips_drop_T`, Q108). v1 of this exchange compares dip count, pitch and timing, then
scales the vertical with the step.

## Rebuild an authored pair (every step is a command)

1. Bridge exports (the room's own retarget): `godot_run.py . tools/export_take_poses.gd -- side=a takes=jab,cross,idle,react_head out=<f01_takes.json> fps=60`
   and `-- side=b takes=react_head,react_head#1,react_head#3,idle,block,slip,jab out=<f09_takes.json>`.
2. Author: `D:/Tools/Blender/blender-5.2.1-windows-x64/blender.exe --background --factory-startup --python Tools/blender_moves/author_pair.py -- Tools/blender_moves/specs/BOX_JAB_HEAD_LAND_IN_PLACE.json`
   (writes the pair JSON, the .blend, preview frames and `report.json` with every footage-comparable number).
3. Watch it in the room's picture: `Godot_v4.7.2-stable_win64.exe --path Godot --write-movie <avi> --fixed-fps 30 --quit-after 110 --script tools/watch_pair.gd -- pair=<pair.json> lead=0.8 tail=0.8`.
Authored v0 files: `S4A_PAIRS/BOX_JAB_HEAD_LAND_IN_PLACE.pair.json` and the four variants' reports (A clip-native distance 1.54 m;
B footage gap with the full step; C step x0.5; D step x0.2 - D is the one that matches the footage).
