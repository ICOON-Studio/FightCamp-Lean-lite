# LOCOKNEE1 - the walking clips against their source, with the ruler that works

## The measure

Every fighter's walk in the fight is one of rk_loc_in, rk_loc_back, rk_loc_left, rk_loc_right. The guard measure (S408) skipped those frames. This task measures them: the knee's distance out of the plane through hip, ankle and foot direction, as a share of leg length. + = towards her own midline. A straight leg reads 0.

Same maths as the guard (tools/knee_plane_probe.gd, tools/knee_plane_raw.py). Three columns per clip per leg: SOURCE (Blender, the FBX in its window), CLIP (baked on the skeleton, all 16 layers off), GAME (all layers on, the fight as played). Each row states which clip was playing and for how many frames.

## The table

### rk_loc_in (Boxing 0.20-1.80 s, mirrored: clip lead = source right, clip rear = source left)

| | SOURCE | CLIP | GAME |
|---|---|---|---|
| lead (source right) | norm=0.0145(-0.0187..0.0694) flex=46.6 | norm=0.0145(-0.0143..0.0604) flex=46.5 | norm=0.0145(-0.0143..0.0604) flex=46.5 |
| rear (source left) | norm=-0.0078(-0.0490..0.0593) flex=49.1 | norm=-0.0082(-0.0449..0.0474) flex=48.9 | norm=-0.0082(-0.0449..0.0474) flex=48.9 |

240 frames per leg. Foot slide (whole file): 4.259 m.

KNEEPLANE_CLIPS GAME red orthodox rig_w=0.00 { "rk_loc_in": 240 }

### rk_loc_back (Walking_Backwards 0.0-0.85 s)

| | SOURCE | CLIP | GAME |
|---|---|---|---|
| lead | norm=-0.0142(-0.0793..0.0004) flex=41.3 | norm=-0.0137(-0.0764..0.0002) flex=41.3 | norm=-0.0137(-0.0764..0.0002) flex=41.3 |
| rear | norm=0.0156(-0.0475..0.1036) flex=34.4 | norm=0.0170(-0.0464..0.1012) flex=34.4 | norm=0.0170(-0.0464..0.1012) flex=34.4 |

240 frames per leg. Foot slide (whole file): 0.642 m.

KNEEPLANE_CLIPS GAME red orthodox rig_w=0.00 { "rk_loc_back": 240 }

### rk_loc_left (Boxing_Left_Side_Step_Walk 0.0-1.033 s)

| | SOURCE | CLIP | GAME |
|---|---|---|---|
| lead | norm=-0.0131(-0.0656..0.0090) flex=32.7 | norm=-0.0131(-0.0638..0.0088) flex=32.7 | norm=-0.0131(-0.0638..0.0088) flex=32.7 |
| rear | norm=-0.0041(-0.0453..0.0069) flex=37.7 | norm=-0.0034(-0.0423..0.0068) flex=37.8 | norm=-0.0034(-0.0423..0.0068) flex=37.8 |

240 frames per leg. Foot slide (whole file): 0.312 m.

KNEEPLANE_CLIPS GAME red orthodox rig_w=0.00 { "rk_loc_left": 240 }

### rk_loc_right (Boxing_Side_Step_Walk 0.0-1.033 s)

| | SOURCE | CLIP | GAME |
|---|---|---|---|
| lead | norm=-0.0210(-0.0772..0.0629) flex=36.8 | norm=-0.0204(-0.0749..0.0617) flex=36.9 | norm=-0.0204(-0.0749..0.0617) flex=36.9 |
| rear | norm=-0.0119(-0.1117..0.0610) flex=35.3 | norm=-0.0115(-0.1047..0.0607) flex=35.4 | norm=-0.0115(-0.1047..0.0607) flex=35.4 |

240 frames per leg. Foot slide (whole file): 0.115 m.

KNEEPLANE_CLIPS GAME red orthodox rig_w=0.00 { "rk_loc_right": 240 }

## Does GAME differ from SOURCE by more than 0.02 of leg length?

Nowhere. The largest mean difference between GAME and SOURCE is 0.0014 (rk_loc_back rear: SOURCE 0.0156, GAME 0.0170). Every clip and every leg stays well within the 0.02 bar.

| clip | leg | SOURCE mean | GAME mean | |diff| |
|---|---|---|---|---|
| rk_loc_in | lead | 0.0145 | 0.0145 | 0.0000 |
| rk_loc_in | rear | -0.0078 | -0.0082 | 0.0004 |
| rk_loc_back | lead | -0.0142 | -0.0137 | 0.0005 |
| rk_loc_back | rear | 0.0156 | 0.0170 | 0.0014 |
| rk_loc_left | lead | -0.0131 | -0.0131 | 0.0000 |
| rk_loc_left | rear | -0.0041 | -0.0034 | 0.0007 |
| rk_loc_right | lead | -0.0210 | -0.0204 | 0.0006 |
| rk_loc_right | rear | -0.0119 | -0.0115 | 0.0004 |

## Which layer causes the difference?

No layer causes a meaningful difference. CLIP (all 16 layers off) and GAME (all layers on) produce identical numbers on every walking clip. The modifiers that change the guard knee (JoinSmoother + RkJoinFeet) are inactive during locomotion: their influence reads 0 on walking frames, so switching them off changes nothing.

KNEEPLANE_LAYERS GAME red: JoinSmoother:on:1.00, RkJoinFeet:on:1.00, MetaHumanTwist:on:1.00 (all others off:0.00)

## The furthest-in knee

The clip and frame with the most inward knee (highest positive norm) across all walking clips:

**rk_loc_back, rear leg, frame 55** (red orthodox) / frame 106 (blue southpaw), norm = 0.1012 (about 10% of leg length, roughly 8-9 cm inward).

This is the source take's own knee coming through: SOURCE rear max = 0.1036. The game does not add to it.

## The one trap

Rounds 1 and 2 of the guard job scored walking frames as guard frames. This task's ruler reads `current_animation` and only counts frames that match the clip name (or guard prefix). Every row above states its clip and frame count from `KNEEPLANE_CLIPS`: 240 frames of the named clip on every boxer, no guard frames mixed in.
