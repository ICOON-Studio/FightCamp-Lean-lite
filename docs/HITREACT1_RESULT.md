# HITREACT1 - Do hit reactions move as much as their source capture?

S409, 2026-11-09. Two measures over every reaction clip reachable from BeatClips.REACT and BeatClips.BIG_REACT:

- **HEAD**: max distance the Head bone moves from where it starts, relative to UpperChest (spine top), metres.
- **TRUNK**: max change in the angle of the line from Hips to Neck, degrees.

SOURCE is the Punch PRO FBX read in Blender (tools/hit_react_raw.py). CLIP is the game's MetaHuman body with every SkeletonModifier3D off (tools/hit_react_probe.gd, mode=clip). GAME column empty: the reactions play in a fight driven by BeatClips, not in isolation; a stage setup that plays one clip with the full rig reads the same bones as CLIP plus HitSnap (a separate head rotation, measured in tools/head_react_probe.gd) and GuardWeave (a guard blend). Neither changes the trunk or the chest-relative head travel of the clip itself, so the GAME column would repeat the CLIP column. Bodies: mh_boxer_01 (red orthodox) and mh_boxer_02 (blue southpaw). CLIP head and trunk are the mean of both bodies. Sorted weakest first by CLIP HEAD.

## The table

| CLIP | SOURCE head_m | SOURCE trunk° | CLIP head_m | CLIP trunk° | CLIP/SRC head | CLIP/SRC trunk | Pools |
|---|---|---|---|---|---|---|---|
| pro_hit_by_cross_v2_short | 0.063 | 4.5 | 0.032 | 3.7 | 51% | 82% | cross |
| pro_hit_by_hook_v2_short | 0.093 | 8.7 | 0.048 | 3.8 | 51% | 44% | lead_hook, lead_uppercut |
| pro_hit_by_jab_v5_short | 0.076 | 6.2 | 0.036 | 7.3 | 48% | 118% | jab |
| pro_hit_by_jab_v3 | 0.091 | 7.7 | 0.059 | 6.5 | 65% | 84% | jab |
| pro_hit_by_cross_v1_short | 0.075 | 4.2 | 0.062 | 4.7 | 82% | 112% | cross |
| pro_hit_by_hook_v6_short | 0.169 | 8.7 | 0.150 | 3.5 | 89% | 40% | BIG_REACT |
| pro_hit_by_jab_v1_short | 0.121 | 10.8 | 0.072 | 7.4 | 60% | 68% | jab |
| pro_hit_by_cross_v1 | 0.059 | 8.6 | 0.066 | 7.0 | 112% | 81% | hurt |
| pro_hit_by_hook_v1 | 0.161 | 8.4 | 0.140 | 6.7 | 87% | 80% | hurt |
| pro_hit_by_jab_v2_short | 0.162 | 16.0 | 0.087 | 9.7 | 54% | 61% | jab |
| pro_hit_by_hook_v3 | 0.126 | 9.1 | 0.109 | 9.3 | 86% | 102% | BIG_REACT |
| pro_hit_by_cross_v3 | 0.226 | 25.0 | 0.111 | 15.3 | 49% | 61% | cross |
| pro_hit_by_hook_v1_short | 0.175 | 8.5 | 0.119 | 4.9 | 68% | 58% | lead_hook, rear_uppercut, rear_hook |
| pro_hit_by_gutshot_v2_short | 0.213 | 25.9 | 0.126 | 20.5 | 59% | 79% | body_hook |
| pro_hit_by_hook_v5 | 0.229 | 17.7 | 0.103 | 14.2 | 45% | 80% | lead_hook, rear_hook |
| pro_hit_by_hook_v3_short | 0.140 | 12.2 | 0.071 | 8.7 | 51% | 71% | lead_hook, rear_hook |
| pro_hit_by_jab_v4_short | 0.117 | 10.0 | 0.065 | 7.3 | 55% | 73% | jab |
| pro_hit_by_uppercut_v1 | 0.272 | 32.2 | 0.153 | 23.0 | 56% | 71% | rear_uppercut, lead_uppercut |
| pro_hit_by_combo_v1_short | 0.171 | 15.6 | 0.089 | 8.2 | 52% | 52% | hurt |
| pro_hit_by_hook_v8_short | 0.357 | 34.6 | 0.263 | 30.6 | 74% | 88% | BIG_REACT |
| pro_hit_by_hook_v7_short | 0.367 | 39.1 | 0.274 | 35.4 | 75% | 90% | BIG_REACT, hurt |
| pro_hit_by_combo_v2_short | 0.127 | 15.6 | 0.114 | 9.5 | 90% | 61% | hurt |
| pro_hit_by_gutshot_v2 | 0.245 | 28.3 | 0.171 | 26.7 | 70% | 94% | body_hook |
| pro_hit_by_gutshot_v3 | 0.282 | 34.0 | 0.169 | 28.3 | 60% | 83% | body_hook |

## Clips that match their source and are simply small

cross_v1_short (0.062 m head, 4.7° trunk): the source is 0.075 m / 4.2°. The clip matches the source; both are small. The S390 score of 3 ("almost no reaction") is the source's own fault.

cross_v1 (0.066 m, 7.0°): the source is 0.059 m / 8.6°. The clip actually moves MORE than the source on head. Both are small reactions for a straight punch.

hook_v3 in BIG_REACT (0.109 m, 9.3°): the source is 0.126 m / 9.1°. The clip matches. It's the weakest of the big four (the others are v6/v7/v8 at 0.15-0.27 m).

## Clips that lost movement in our conversion (CLIP under 70% of SOURCE on either measure)

| CLIP | CLIP/SRC head | CLIP/SRC trunk | Pools | Note |
|---|---|---|---|---|
| pro_hit_by_hook_v5 | 45% | 80% | lead_hook, rear_hook (3 picks) | Source is big (0.23 m / 17.7°); clip loses half the head travel |
| pro_hit_by_cross_v3 | 49% | 61% | cross (3 picks) | Source is big (0.23 m / 25°); clip loses half |
| pro_hit_by_hook_v2_short | 51% | 44% | lead_hook, lead_uppercut (2 picks) | Both measures halved; S390 score 3 confirmed |
| pro_hit_by_hook_v3_short | 51% | 71% | lead_hook, rear_hook (3 picks) | Head halved |
| pro_hit_by_cross_v2_short | 51% | 82% | cross (3 picks) | Head halved; S390 score 3 confirmed |
| pro_hit_by_combo_v1_short | 52% | 52% | hurt (1 pick) | Both measures halved |
| pro_hit_by_jab_v2_short | 54% | 61% | jab (1 pick) | Source has real movement (0.16 m / 16°); clip loses it |
| pro_hit_by_jab_v4_short | 55% | 73% | jab (1 pick) | Head halved |
| pro_hit_by_uppercut_v1 | 56% | 71% | rear/lead_uppercut (2 picks) | Source is the biggest uppercut (0.27 m / 32°); clip reads 0.15 m / 23° |
| pro_hit_by_jab_v1_short | 60% | 68% | jab (1 pick) | Both measures under 70% |
| pro_hit_by_gutshot_v3 | 60% | 83% | body_hook (1 pick) | Source is the biggest gut reaction (0.28 m / 34°); clip loses head travel |
| pro_hit_by_gutshot_v2_short | 59% | 79% | body_hook (1 pick) | Head loses 40% |
| pro_hit_by_jab_v3 | 65% | 84% | jab (1 pick) | Head under 70% |
| pro_hit_by_hook_v1_short | 68% | 58% | lead_hook, rear_uppercut, rear_hook (3 picks) | Trunk loses 42% |
| pro_hit_by_gutshot_v2 | 70% | 94% | body_hook (1 pick) | Borderline on head |
| pro_hit_by_hook_v6_short | 89% | 40% | BIG_REACT (1 pick) | Head matches; trunk loses 60% (source 8.7°, clip 3.5°) |
| pro_hit_by_hook_v7_short | 75% | 90% | BIG_REACT, hurt (2 picks) | Both close to source; among the biggest reactions in both columns |
| pro_hit_by_hook_v8_short | 74% | 88% | BIG_REACT (1 pick) | Both close to source; the second biggest in both columns |
| pro_hit_by_combo_v2_short | 90% | 61% | hurt (1 pick) | Head matches; trunk loses 39% |

mc_hit_jab, mc_hit_hook, mc_hit_combo, react_head, react_body, react_hurt: no Punch PRO source; skipped in the SOURCE column.

## How often the game picks each weak clip

The weak clips (CLIP under 70% of SOURCE on either measure) sit in these pools:

- **jab** pool (7 picks from 5 pro_ clips + 2 fallbacks): jab_v1_short, jab_v2_short, jab_v3, jab_v4_short, jab_v5_short. Every one of the five pro_ jab reactions lost head travel (45-65% of source). The pool has no strong jab reaction.
- **cross** pool (5 picks from 3 pro_ clips + 2 fallbacks): cross_v1_short, cross_v2_short, cross_v3. All three lost head travel (49-82%). cross_v1_short and cross_v2_short are the two weakest clips in the table.
- **lead_hook / rear_hook** pools (4-5 picks each): hook_v1_short (68%/58%), hook_v2_short (51%/44%), hook_v3_short (51%/71%), hook_v5 (45%/80%). The four hook reactions in play all lost movement.
- **rear_uppercut / lead_uppercut** pools (3 picks each): uppercut_v1 (56%/71%) and hook_v1_short/hook_v2_short. Both uppercut pools rely on reactions that lost movement.
- **hurt** pool (7 picks from 5 pro_ clips + 2 fallbacks): hook_v1 (87%/80%, matches), cross_v1 (112%/81%, matches), combo_v1_short (52%/52%), combo_v2_short (90%/61%), hook_v7_short (75%/90%). Two of five pro_ hurt reactions lost movement.
- **body_hook** pool (4 picks from 3 pro_ clips + 1 fallback): gutshot_v3 (60%/83%), gutshot_v2_short (59%/79%), gutshot_v2 (70%/94%). All three lost head travel.
- **BIG_REACT** (4 picks): hook_v8_short (74%/88%), hook_v7_short (75%/90%), hook_v6_short (89%/40%), hook_v3 (86%/102%). The big four mostly match their source; hook_v6_short lost trunk movement.
