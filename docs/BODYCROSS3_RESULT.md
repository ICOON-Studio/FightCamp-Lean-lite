# BODYCROSS3 result (S546, 2026-11-24) - the body cross: a bent elbow you can see, and the hit man bends

Task: ops/research/TASK_BODYCROSS3.md. Owner, review comment C502 on BODYCROSS2's own sheet of twelve pictures, picture 9
boxed: "there is no elbow bent , the reaction should force the opponent to bend hisposture a bit".
METHOD followed: FIGHTPLAYER2, v2 only, no new correction layer in scripts/fight3d. Nothing in scripts/fight3d was
edited. Both fixes are in takes' own keys, authored offline by bake tools. Nothing was bought or generated.
The owner's eye is the ruler: every bar below is read on the sheet's own twelve pictures, as the side camera sees them.

## What now works
- **A bent elbow on every picture he looks at.** As the side camera sees it the elbow is 129 deg on the touch and
  128-129 on all eight pictures after it (BODYCROSS2: 159 on the touch, 168-169 after). The upper arm comes down from
  the shoulder, the forearm goes level into his stomach.
- **He bends.** From the picture after the touch the hit boxer folds: 12 deg by picture 10, 18-19 deg inside 0.15 s,
  21-22 deg at the deepest (0.23 s after the touch), upright again after 0.52-0.53 s (BODYCROSS2: 6.5-8.4 deg inside
  0.15 s; the fold came half a second late, after the sheet had ended).
- **Still a punch.** 9.6 m/s (men) / 8.5 m/s (women) on the touch, its fastest picture; 5.7-7.9 cm into him.
- **He steps in.** The lead foot steps 5.6 cm, lifted 3.3 cm, and is down 0.067 s before the touch.
- tools/bodycross3_ruler.gd was committed RED on the shipped take (59013db: 5 of 13 bars fail on both pairs) and reads
  GREEN on both now (13 of 13). The sheets, the touch stills, the films and the game's twelve pictures were opened by
  me and are on the review board. His eye closes it; the green ruler closes nothing alone.

## Step 2 - the NaN table
Cause: tools/bodycross2_ruler.gd never wrote that summary table. Its console lines and its JSON hold real numbers in
every field (re-run on the shipped take: all finite). The table in docs/BODYCROSS2_RESULT.md was filled outside the repo
from that JSON, by field names the JSON does not have; the picture-by-picture table under it, read by the real names,
was right, and the verdict line and the percentages came from the bars' own text. No such script is in the repo, so
this is the reading the evidence allows, not a line I can point to.
Fix: the ruler now writes the table itself (`ruler_<set>_<tag>.md`), and takes `old=<res> row=<json>` so an earlier
version of the take can be read beside the shipped one. The real numbers, same pairs, same camera:

| Measure | Bar | Men S542 (as filmed) | Men S545 | Men S546 (now) | Women S542 (as filmed) | Women S545 | Women S546 (now) |
|---|---|---|---|---|---|---|---|
| Glove to his body at its nearest | touches (0.01 m) | 0.075 m short | touches | touches | 0.019 m short | touches | touches |
| Past where the surface was | 0.04-0.10 m | -0.072 m | 0.093 m | 0.079 m | -0.020 m | 0.079 m | 0.057 m |
| Speed at the contact | 6 m/s or more | 0.05 m/s | 9.41 m/s | 9.58 m/s | 0.24 m/s | 8.22 m/s | 8.54 m/s |
| ... as a share of the top | 70 % or more | 1 % | 100 % | 100 % | 3 % | 100 % | 100 % |
| Top speed (when) | 8 m/s or more | 8.54 m/s (0.083 s before the contact) | 9.41 m/s (0.000 s before the contact) | 9.58 m/s (0.000 s before the contact) | 7.43 m/s (0.100 s before the contact) | 8.22 m/s (0.000 s before the contact) | 8.54 m/s (0.000 s before the contact) |
| First move to contact (the fist alone) | 0.23-0.36 s | 0.367 s (0.233 s) | 0.300 s (0.233 s) | 0.300 s (0.233 s) | 0.383 s (0.383 s) | 0.300 s (0.283 s) | 0.300 s (0.283 s) |
| Hit man within 0.15 s: hips back | 0.05 m (or fold) | 0.009 m | 0.193 m | 0.116 m | 0.007 m | 0.246 m | 0.116 m |
| ... trunk fold (neck over hips) | 0.05 m (or hips) | 0.034 m (3.5 deg) | 0.068 m (7.1 deg) | 0.195 m (20.6 deg) | 0.034 m (3.9 deg) | 0.073 m (8.4 deg) | 0.168 m (19.3 deg) |
| Posture back after | 0.4 s or more | 1.100 s | 0.717 s | 0.617 s | 1.017 s | 1.067 s | 0.550 s |
| Elbow at the contact (in 3D) | (K52: 137 +/- 12) | 168.5 deg | 142.7 deg | 129.5 deg | 168.5 deg | 142.7 deg | 129.5 deg |
| Puncher's hips forward at the contact | (0.04-0.06) | 0.000 m | 0.057 m | 0.105 m | 0.000 m | 0.057 m | 0.105 m |
| Hips apart in the guard | - | 1.241 m | 1.199 m | 1.155 m | 1.068 m | 1.061 m | 1.031 m |
| Verdict |  | RED (5 of 8 bars failed) | GREEN (0 of 8 bars failed) | GREEN (0 of 8 bars failed) | RED (7 of 8 bars failed) | GREEN (0 of 8 bars failed) | GREEN (0 of 8 bars failed) |

(S542 "as filmed" = the game's finish armed, the hit man's take from its first key on the spot. S545 = BODYCROSS2's
take on its own keys, the hit man v2_short (men) / v2 (women) by the v2 player's start rule. The verdicts match
BODYCROSS2's: RED 5 of 8 and 7 of 8 before, GREEN after. This is the OLD ruler: its elbow is 3D on one key and its
fold is 3D neck-over-hips - the two things C502 showed it could not see.)

## Step 1 - which study each bar follows
| Bar | Number | Study (line) | Reference clip |
|---|---|---|---|
| Elbow as seen 150 or less on the first on-body picture | amateurs 137 +/- 12 deg at impact, professionals 102 +/- 17; 180 = straight | K52 lines 10, 42, 46-47 | the bought Punch PRO cross's own key at 0.225 s (129.5 deg) |
| Never over 160 on a later picture; 3 on-body pictures at 155 or less | "keep elbow short of lock on straights (~135-140)" | K52 line 101; the task's bar for the eye | - |
| Speed 6 m/s or more on the touch, 70 % of the top, top 8 or more | contact 5.9-8.2 m/s; cross 8.2-9.1; band 6-11.5 | G75 20, 23-27, 179; K54 34 (as BODYCROSS2) | - |
| First move to contact 0.23-0.36 s | cross 223 +/- 99 ms; readable floor 230-270 ms | G75 112, 179; K54 22 | - |
| 0.04-0.10 m past where his surface was | follow-through 110 mm | G75 26-27, 127 (Atha 1985) | Frank Bruno's cross (Atha) |
| He folds 12-25 deg inside 0.15 s | flexion degrees and ms of a body punch: NO STUDY; "solar plexus: winded, forward crumple" | K51 lines 12, 65-68; ChoreoRules REACT_FOLD_S 0.17 s ("a body shot folds a man 30-50 cm over 5-6 pictures", S530 critics) | MoCap Online Punch PRO Hit_By_GutShot_V3 (26 deg as captured) |
| Front-loaded: the fold starts on the blow | "reaction animation should be front-loaded ... retime so motion begins at contact"; "the fake look is often a reaction that starts too late" | K51 lines 7, 81, 96 | - |
| Not upright again before 0.4 s | first voluntary postural correction 100-250+ ms; reset 0.5-1 s | K51 line 77; K48 line 12 | - |
| He gives ground, 0.05 m or more | "bend / brace / hold more than a long retreat"; first compensatory step 25-33 cm; body-shot travel: NO STUDY | K48 lines 10, 13, 34-37 | - |
| The step: 5-8 cm, lead foot planted before the touch | coaching step-in ~5-8 cm (SECONDARY); lead foot the lock at impact (61 % of the load) | K46 lines 8, 10, 31 | the captured stepping cross pro_right_cross_ft (see "Decided" 3) |
| Knees | cross at impact 142.8 +/- 16 deg (elite); level change in cm: NO STUDY | K46 lines 54, 56 | ours 108 / 120 deg on the census body (a level change; was 97 / 111) |

## Step 3 - the ruler on the sheet's own twelve pictures, before and after
Tool: tools/bodycross3_ruler.gd (headless). The sheet = every picture of the film from 3 before the touch to 8 after
(60 a second: the sheet spans 0.2 s, not 0.9 - picture 9 is 0.083 s after the touch). Same pairs as the film (men:
mh_boxer_02 red v 01 blue, blue throws; women: 11 red v 14 blue, red throws), the film's fixed side camera. Elbow =
shoulder - elbow - wrist projected on the screen (3D in brackets). Glove = to his trunk skin as drawn. Fold = his hips -
neck line against upright on the screen, change since the touch picture (his lean in brackets). Last column: the
picture set's crowding measure (a head to the other's trunk line and head, bar 0.60), as drawn.

**Men, BEFORE (BODYCROSS2's take; the hit man v2_short from 0.080 s) - RED**

| Picture | Elbow as seen (3D) | Glove to his body m | His fold deg (lean) | His hips back m | Head to the other's trunk m |
|---|---|---|---|---|---|
| 1 (-3) | 103.3 (87.9) | 0.347 | 0.8 (6.4) | 0.000 | 0.871 |
| 2 (-2) | 115.2 (97.0) | 0.245 | 0.5 (6.1) | 0.000 | 0.843 |
| 3 (-1) | 136.2 (114.4) | 0.117 | 0.3 (5.8) | 0.000 | 0.810 |
| 4 (+0) | 158.6 (142.7) | 0.000 on | 0.0 (5.5) | 0.000 | 0.780 |
| 5 (+1) | 168.3 (164.7) | -0.063 on | -0.6 (5.0) | 0.001 | 0.768 |
| 6 (+2) | 169.4 (167.3) | -0.043 on | -0.6 (5.0) | 0.018 | 0.777 |
| 7 (+3) | 168.5 (166.6) | -0.012 on | -0.2 (5.3) | 0.039 | 0.792 |
| 8 (+4) | 166.1 (164.2) | 0.029 | 0.6 (6.1) | 0.065 | 0.809 |
| 9 (+5) | 164.8 (162.6) | 0.073 | 1.6 (7.2) | 0.091 | 0.825 |
| 10 (+6) | 164.4 (161.7) | 0.116 | 2.9 (8.5) | 0.119 | 0.842 |
| 11 (+7) | 162.0 (158.6) | 0.149 | 4.2 (9.8) | 0.146 | 0.857 |
| 12 (+8) | 158.2 (154.0) | 0.180 | 5.5 (11.1) | 0.171 | 0.873 |

**Men, AFTER (the hit man pro_hit_by_gutshot_v3_fold from its first key) - GREEN**

| Picture | Elbow as seen (3D) | Glove to his body m | His fold deg (lean) | His hips back m | Head to the other's trunk m |
|---|---|---|---|---|---|
| 1 (-3) | 86.8 (87.1) | 0.291 | 0.8 (6.4) | 0.000 | 0.839 |
| 2 (-2) | 93.0 (93.5) | 0.208 | 0.5 (6.1) | 0.000 | 0.808 |
| 3 (-1) | 104.3 (104.9) | 0.100 | 0.3 (5.8) | 0.000 | 0.772 |
| 4 (+0) | 129.0 (129.5) | 0.004 on | 0.0 (5.5) | 0.000 | 0.735 |
| 5 (+1) | 129.4 (130.0) | -0.032 on | 0.3 (5.9) | 0.001 | 0.701 |
| 6 (+2) | 129.4 (130.0) | -0.039 on | 1.6 (7.1) | 0.020 | 0.686 |
| 7 (+3) | 129.3 (130.0) | -0.017 on | 3.6 (9.1) | 0.041 | 0.672 |
| 8 (+4) | 129.2 (130.0) | 0.004 on | 6.3 (11.8) | 0.060 | 0.657 |
| 9 (+5) | 129.0 (130.0) | 0.021 | 9.3 (14.8) | 0.081 | 0.646 |
| 10 (+6) | 128.9 (130.0) | 0.035 | 12.4 (18.0) | 0.095 | 0.632 |
| 11 (+7) | 128.7 (130.0) | 0.051 | 15.2 (20.7) | 0.108 | 0.625 |
| 12 (+8) | 128.7 (130.0) | 0.061 | 17.6 (23.1) | 0.113 | 0.615 |

**Women, BEFORE (the hit woman v2 from 0.363 s) - RED**

| Picture | Elbow as seen (3D) | Glove to his body m | His fold deg (lean) | His hips back m | Head to the other's trunk m |
|---|---|---|---|---|---|
| 1 (-3) | 103.3 (87.9) | 0.249 | -0.1 (6.2) | 0.000 | 0.789 |
| 2 (-2) | 115.2 (97.0) | 0.185 | 0.0 (6.3) | 0.000 | 0.766 |
| 3 (-1) | 136.2 (114.4) | 0.120 | 0.0 (6.3) | 0.000 | 0.740 |
| 4 (+0) | 158.6 (142.7) | 0.001 on | 0.0 (6.3) | 0.000 | 0.717 |
| 5 (+1) | 168.3 (164.7) | -0.064 on | 0.1 (6.4) | 0.000 | 0.703 |
| 6 (+2) | 169.4 (167.3) | -0.048 on | 0.4 (6.7) | 0.018 | 0.710 |
| 7 (+3) | 168.5 (166.6) | -0.009 on | 1.0 (7.3) | 0.047 | 0.726 |
| 8 (+4) | 166.1 (164.2) | 0.043 | 2.0 (8.3) | 0.083 | 0.747 |
| 9 (+5) | 164.8 (162.6) | 0.096 | 3.3 (9.6) | 0.122 | 0.771 |
| 10 (+6) | 164.4 (161.7) | 0.150 | 4.7 (11.0) | 0.161 | 0.793 |
| 11 (+7) | 162.0 (158.6) | 0.200 | 6.2 (12.5) | 0.197 | 0.814 |
| 12 (+8) | 158.2 (154.0) | 0.228 | 7.4 (13.7) | 0.226 | 0.831 |

**Women, AFTER - GREEN**

| Picture | Elbow as seen (3D) | Glove to his body m | His fold deg (lean) | His hips back m | Head to the other's trunk m |
|---|---|---|---|---|---|
| 1 (-3) | 86.8 (87.1) | 0.202 | -0.1 (6.2) | 0.000 | 0.748 |
| 2 (-2) | 93.0 (93.5) | 0.148 | 0.0 (6.3) | 0.000 | 0.720 |
| 3 (-1) | 104.3 (104.9) | 0.102 | 0.0 (6.3) | 0.000 | 0.689 |
| 4 (+0) | 129.0 (129.5) | 0.006 on | 0.0 (6.3) | 0.000 | 0.659 |
| 5 (+1) | 129.4 (130.0) | -0.022 on | 0.3 (6.6) | 0.001 | 0.633 |
| 6 (+2) | 129.4 (130.0) | -0.017 on | 1.2 (7.5) | 0.020 | 0.627 |
| 7 (+3) | 129.3 (130.0) | 0.004 on | 2.9 (9.2) | 0.041 | 0.621 |
| 8 (+4) | 129.2 (130.0) | 0.026 | 5.3 (11.6) | 0.061 | 0.613 |
| 9 (+5) | 129.0 (130.0) | 0.053 | 8.3 (14.6) | 0.081 | 0.604 |
| 10 (+6) | 128.9 (130.0) | 0.077 | 11.5 (17.8) | 0.095 | 0.589 |
| 11 (+7) | 128.7 (130.0) | 0.089 | 14.3 (20.6) | 0.108 | 0.580 |
| 12 (+8) | 128.7 (130.0) | 0.098 | 16.8 (23.1) | 0.113 | 0.568 |

The bars, men before / men after:

| Bar | Read | |
|---|---|---|
| BENT: elbow as seen <= 150 deg on the first on-body picture | 158.6 deg | FAIL |
| BENT: never over 160 deg on a later picture of the sheet | most 169.4 deg | FAIL |
| BENT: 3 pictures on his body with the elbow <= 155 deg | 0 pictures | FAIL |
| HE BENDS: fold 12-25 deg within 0.15 s | 6.5 deg | FAIL |
| HE BENDS: 3 sheet pictures after the touch show 10 deg or more | 0 pictures | FAIL |
| HE BENDS: not upright again before 0.4 s | after 0.700 s | pass |
| HE BENDS: his hips go back 0.05 m or more | 0.465 m | pass |
| STILL A PUNCH: reach: the glove meets his body | nearest -0.063 m from the surface (contact at take 0.300 s, the row's key 0.300 s) | pass |
| STILL A PUNCH: reach: goes 0.04-0.10 m past where the surface was | 0.093 m | pass |
| STILL A PUNCH: speed at the contact >= 6 m/s | 9.41 m/s | pass |
| STILL A PUNCH: speed at the contact >= 70 % of the top | 100 % (top 0.000 s before) | pass |
| STILL A PUNCH: top speed >= 8 m/s | 9.41 m/s | pass |
| STILL A PUNCH: first move to contact 0.23-0.36 s | 0.300 s (the fist alone, from 15 % of its top speed: 0.233 s) | pass |


| Bar | Read | |
|---|---|---|
| BENT: elbow as seen <= 150 deg on the first on-body picture | 129.0 deg | pass |
| BENT: never over 160 deg on a later picture of the sheet | most 129.4 deg | pass |
| BENT: 3 pictures on his body with the elbow <= 155 deg | 5 pictures | pass |
| HE BENDS: fold 12-25 deg within 0.15 s | 19.3 deg | pass |
| HE BENDS: 3 sheet pictures after the touch show 10 deg or more | 3 pictures | pass |
| HE BENDS: not upright again before 0.4 s | after 0.533 s | pass |
| HE BENDS: his hips go back 0.05 m or more | 0.189 m | pass |
| STILL A PUNCH: reach: the glove meets his body | nearest -0.039 m from the surface (contact at take 0.300 s, the row's key 0.300 s) | pass |
| STILL A PUNCH: reach: goes 0.04-0.10 m past where the surface was | 0.079 m | pass |
| STILL A PUNCH: speed at the contact >= 6 m/s | 9.58 m/s | pass |
| STILL A PUNCH: speed at the contact >= 70 % of the top | 100 % (top 0.000 s before) | pass |
| STILL A PUNCH: top speed >= 8 m/s | 9.58 m/s | pass |
| STILL A PUNCH: first move to contact 0.23-0.36 s | 0.300 s (the fist alone, from 15 % of its top speed: 0.233 s) | pass |


Women before / after:

| Bar | Read | |
|---|---|---|
| BENT: elbow as seen <= 150 deg on the first on-body picture | 158.6 deg | FAIL |
| BENT: never over 160 deg on a later picture of the sheet | most 169.4 deg | FAIL |
| BENT: 3 pictures on his body with the elbow <= 155 deg | 0 pictures | FAIL |
| HE BENDS: fold 12-25 deg within 0.15 s | 8.4 deg | FAIL |
| HE BENDS: 3 sheet pictures after the touch show 10 deg or more | 0 pictures | FAIL |
| HE BENDS: not upright again before 0.4 s | after 0.883 s | pass |
| HE BENDS: his hips go back 0.05 m or more | 0.501 m | pass |
| STILL A PUNCH: reach: the glove meets his body | nearest -0.064 m from the surface (contact at take 0.300 s, the row's key 0.300 s) | pass |
| STILL A PUNCH: reach: goes 0.04-0.10 m past where the surface was | 0.079 m | pass |
| STILL A PUNCH: speed at the contact >= 6 m/s | 8.22 m/s | pass |
| STILL A PUNCH: speed at the contact >= 70 % of the top | 100 % (top 0.000 s before) | pass |
| STILL A PUNCH: top speed >= 8 m/s | 8.22 m/s | pass |
| STILL A PUNCH: first move to contact 0.23-0.36 s | 0.300 s (the fist alone, from 15 % of its top speed: 0.283 s) | pass |


| Bar | Read | |
|---|---|---|
| BENT: elbow as seen <= 150 deg on the first on-body picture | 129.0 deg | pass |
| BENT: never over 160 deg on a later picture of the sheet | most 129.4 deg | pass |
| BENT: 3 pictures on his body with the elbow <= 155 deg | 4 pictures | pass |
| HE BENDS: fold 12-25 deg within 0.15 s | 18.5 deg | pass |
| HE BENDS: 3 sheet pictures after the touch show 10 deg or more | 3 pictures | pass |
| HE BENDS: not upright again before 0.4 s | after 0.517 s | pass |
| HE BENDS: his hips go back 0.05 m or more | 0.189 m | pass |
| STILL A PUNCH: reach: the glove meets his body | nearest -0.022 m from the surface (contact at take 0.300 s, the row's key 0.300 s) | pass |
| STILL A PUNCH: reach: goes 0.04-0.10 m past where the surface was | 0.057 m | pass |
| STILL A PUNCH: speed at the contact >= 6 m/s | 8.54 m/s | pass |
| STILL A PUNCH: speed at the contact >= 70 % of the top | 100 % (top 0.000 s before) | pass |
| STILL A PUNCH: top speed >= 8 m/s | 8.54 m/s | pass |
| STILL A PUNCH: first move to contact 0.23-0.36 s | 0.300 s (the fist alone, from 15 % of its top speed: 0.283 s) | pass |


Why BODYCROSS2's 142.7 deg read as a straight arm: the bought cross flares its elbow out, toward the camera. On its
contact key the elbow is 142.7 deg in 3D and 158.6 deg on the screen, and 168 one picture later.

## Step 4 - what changed in the punch take's keys
Tool: tools/pics2d_bodycross_bake.gd (headless, run once, 60 keys a second). Base and everything not listed: as
BODYCROSS2 (the bought Punch PRO cross with ActionForge's legs; hip and shoulder turn the bought take's own, nothing
twisted; rear heel up on the ball of the foot). Measured on the census body (mh_boxer_10).

| Change | BODYCROSS2 | Now | Source |
|---|---|---|---|
| Contact key on the arm's travel | the bought take's 0.24 s, elbow 142.7 (158.6 as seen) | the bought take's **0.225 s, elbow 129.5** | K52: amateurs 137 +/- 12 (125-149) |
| After the contact | the arm runs out to 167 deg in 0.04 s | the arm's shoulder-to-wrist span is capped: **130 deg at the most**, for the whole rest of the take; the last 5.4 cm into him are the bought take's own hip and shoulder turn and the weight | the task: "the follow-through stays bent"; K52 line 101 |
| Where the elbow points | out, toward the camera (the bought cross) | **down, under the shoulder-wrist line**, from mid-drive until he comes up; the upper arm rolled so the elbow's hinge is square to the bend; the fist kept as the bought take turns it | so the bend is in the plane the side camera sees |
| The step | none: both feet on their spots | lead foot **5.6 cm forward** (0.142 -> 0.198 m ahead of the hips' start), lifted **3.3 cm**, down at 0.233 s = **0.067 s before the touch**; stays planted through the drive and the hold; steps back out as he comes up (the take ends on its start spot: hips end 0.001 m) | K46 lines 8, 31 |
| Hips forward at the contact | 0.059 m | **0.111 m** (0.123 at the most): the step's 0.06 with them | the task: "close the range inside the take" |
| The sink | 0.18 m (knees 96.8 / 102.1) | **0.13 m** (knees 108 / 120): a fall of 5.1 m/s2 at most | see "Decided" 4 |
| Trunk hinge at the waist | 10 deg | **5 deg** | coach: bend the knees, not the waist; see "Decided" 5 |
| Arm pitched from the shoulder | 0 deg | 16.1 deg down (the shoulder is higher over the same target) | - |
| The drive's pace on the contact | 2.0 x the bought pace | **1.7 x** (men 9.6 m/s, women 8.5; at 2.0 the men read 10.9) | G75 cross band 6-11.5 |
| Glove on the contact key (census body) | 7.61 m/s, the take's top | **8.03 m/s**, the take's top | G75 |
| Contact after the start / length | 0.300 s / 0.900 s | 0.300 s / 0.917 s | - |
| Glove height at the contact | 0.949 m | 0.949 m (unchanged: 0.06 over the census rib point) | BODYCROSS2 |

Where the lead foot lands against his lead foot: on the four landed pictures the nearest foot bones are 0.33-0.47 m
apart along the line (women 0.334 / 0.343, men 0.381 / 0.467; the boots reach about 8 cm past each bone; the set's bar
for crossed feet is 0.16). He steps toward him, never onto or past his foot.
Distance in the guard, hips to hips: men 1.155 m (BODYCROSS2 1.199), women 1.031 m (1.061). The puncher still stands
where the take's own glove meets the body: 3-4 cm closer than BODYCROSS2's film, because the arm is 6 cm shorter at
the touch and the step gives back 5.6.

The clip table row (assets/data/clip_db.json, pro_body_cross only; tools/clip_census.gd dry run): re-measured, then
six fields set to the authored contact key as BODYCROSS2 decided (the census marks the deepest key, 0.35 s):
contact_s 0.3, contact_gap_m 0.991, glove_y_m 0.949, hips_at_contact_m 0.111, own_head_y_m 1.281, up_m 0.06.
ClipCensus.gd needed no edit (family body_cross is already there; the reaction is a reaction by its name).

## Step 5 - the hit man: every captured body reaction, by the fold AS SEEN
Measured with the new ruler on the men's pair against the shipped punch, each started where the v2 player's rule
starts it (ChoreoReact.start_s), fold on the screen at +0.05 / +0.10 / +0.15 s after the touch:

| Take | Starts at s | Fold deg at +0.05 / +0.10 / +0.15 | Deepest (when) | Hips back in 0.15 s / most | Upright again | Note |
|---|---|---|---|---|---|---|
| pro_hit_by_gutshot_v1 | 0.430 | -4.0 / -4.7 / -3.2 | 1.9 | 0.070 / 0.087 | never folds 10 | its 14.5 deg in 3D is a twist: nothing on the side camera |
| pro_hit_by_gutshot_v1_short | 0.063 | -0.9 / 0.8 / 2.9 | 3.9 (+0.22 s) | 0.092 / 0.108 | never folds 10 | the same |
| pro_hit_by_gutshot_v2 | 0.346 | 0.5 / 4.6 / 8.4 | 22.0 (+0.50 s) | 0.226 / 0.501 | 0.97 s | folds deep, half a second late |
| pro_hit_by_gutshot_v2_short | 0.080 | -0.2 / 2.9 / 6.5 | 19.3 (+0.50 s) | 0.193 / 0.465 | 0.70 s | the same; BODYCROSS2's film (men) |
| pro_hit_by_gutshot_v3 | 0.047 | -2.5 / -1.0 / 4.5 | 26.3 (+0.43 s) | 0.115 / 0.340 | 0.77 s | **the deepest fold, the least ground given**; its fold runs from 0.15 s to 0.45 s of the take |
| pro_hit_by_kidneyshot_v1 | 0.397 | 1.5 / 3.6 / 4.2 | 4.2 | 0.149 / 0.149 | never folds 10 | a side shot |
| react_body (our old clip) | 0.000 | 3.9 / 10.2 / 14.4 | 15.9 (+0.22 s) | 0.022 / 0.023 | 0.47 s | on time, but on the spot: gives no ground (bar 0.05) |
| **pro_hit_by_gutshot_v3_fold (new)** | 0.000 | **3.6 / 12.4 / 19.3** (women 2.9 / 11.5 / 18.5) | **21.8 (+0.23 s)** (women 21.1) | 0.116 / 0.189 | 0.53 s (women 0.52) | the pick |

So three captured takes reach 12 deg and more; none needed a deeper fold. What was wrong is WHEN: each opens with
0.15-0.35 s in which the man stands and even leans back 2-4 deg, and the player starts a body reaction near that
opening. The new take is the captured v3 FROM THE KEY ITS FOLD STARTS ON, baked offline by tools/pics2d_gutfold_bake.gd:

| What | Captured v3 | pro_hit_by_gutshot_v3_fold |
|---|---|---|
| First key | v3's 0.000 s | v3's **0.250 s**; every later key is the captured one, 0.25 s earlier; length 1.767 -> 1.517 s |
| Feet, legs, arms, head, the step back | - | as captured |
| Hips' place on the floor | gives 0.339 m | starts where v3 starts; the 0.154 m v3 gave before 0.25 s is not replayed; gives 0.185 m from there |
| Trunk bend (Spine, Chest, UpperChest only, against their first captured key) | x 1.00: 26 deg at the deepest | **x 0.75**: 21-22 deg. As captured it reads doubled over (head down at the puncher's chest); he asked for "a bit". At x 1.00 the ruler read 23.2 deg inside 0.15 s and 26.3 at the deepest. |

**Is it the take the v2 player plays when a body punch lands in the fight? No - and I could not make it so from the
files this task owns.** tools check (a throwaway probe calling ChoreoReact.react with 400 seeds a body size, the rows
as committed): the player takes every take named "gutshot", picks the one whose head travel is nearest 0.30 m for his
size (0.42 for a big shot) and draws among those within 4.5 cm. The new take's head travel from its first key is
0.153 m (it starts part-way into the fold), so it is never drawn: v2, v2_short and v3 share a normal body punch, v3
takes every big one - exactly as before this task. Its row is in clip_db.json; nothing in the fight changed.
The film, the sheet and the game's pictures play it by name (the picture tools' `react=`), started by the player's
own start rule (which starts it on its first key). In the 3D fight a landed body punch still folds the man 4.5-8.4 deg
inside 0.15 s. Making the fight use it is one rule in scripts/fight3d/v2/ChoreoReact.gd (a body punch picks by when
the fold arrives, not by head travel) - a scoped change to fight3d, not a take, so by the METHOD line I stopped here
and wrote it down. The body cross itself is still not thrown in the 3D fight ("played": false, family body_cross has
no pool): only body hooks land there.

Feedback-loop check, before the picture run: family body_cross holds only pro_body_cross; the new reaction is played
only by these tools; nothing reads either take back into a bout's numbers.

## Step 6 - the sheet, the film, the game's pictures
- tools/pics2d_bodycross_film.gd now makes the sheet itself: every one of the twelve pictures is captioned with what
  the ruler read ON THAT PICTURE (its number, the elbow as seen, glove on him or how far off, how far he has bent).
  No caption says "elbow bent" over a straight arm.
- Films: before (BODYCROSS2's take, the hit boxer v2_short / v2 as its film had them) left, after right; the fixed
  side camera, never moved; twice at real speed, then once at quarter speed; 17 s each. All 536 pictures passed the
  framing check (both boxers head to toes).
- The game's twelve body-cross pictures (assets/ui/fight_pictures/m and w) are re-made. The four landed ones are the
  film's own frame, 3 pictures after the touch (4 on the men's blue one): the latest on which the glove is still on or
  in his body and no head is in the other body. On them he has bent 3-6 deg: it starts there, it does not read yet.
  Blocked and missed: the set tool's own route with the new take. All twelve pass the set's gate.
- By my own eye, on the sheets and the stills: a bent elbow, yes - clear on every picture from the touch on, both
  pairs. A bent man, yes - from picture 9 or 10 on the sheet, plain on 11 and 12, and over the next 0.2 s on the film.

RESULT: tests/fight_pictures_test.gd -> FIGHT_PICTURES failures=0
RESULT: tests/fight_pictures_gate_test.gd -> FIGHT_PICTURES_GATE failures=0
RESULT: tests/player2_test.gd -> PLAYER2 failures=0
RESULT: tests/clip_db_test.gd -> CLIP_DB failures=0

tests/fight_pictures_test.gd got three checks: the landed body-cross pictures are made with the fold take and no
head in the other body as drawn; the punch take's own keys cap the elbow under 150 deg and step in; the hit man's take
starts on the fold.
Not mine, seen on the way: tests/player2_test.gd failed twice earlier in this session on "FLOOR ... deepest 3.5 cm,
boxer 0 LeftFoot in pro_right_cross" - once with my files, once with the three files this task changes swapped back to
the committed versions (same failure, same take: the plain cross, which I did not touch) - and passed on the last run.
It is not steady; it is not from this work.

## Decided without asking
1. The sheet keeps BODYCROSS2's rule (every film picture, 3 before the touch to 8 after), so before and after can be
   laid side by side. The brief took the sheet for one picture every 0.075 s; it is one every 0.017 s. A second strip
   (one picture every 0.1 s, 1.1 s long) is on the board beside it, so the whole fold and the way back can be seen.
2. "Fold" = the change of his hips-neck line on the screen since the touch picture; his lean against upright (5.5-6.3
   deg in his guard) is printed beside it. "Upright again" = back within 5 deg of his touch posture.
3. The step is authored (a lift and a set-down on a smooth curve), not the captured stepping cross's legs. That take
   (pro_right_cross_ft) lands 0.53 s after its start and its hips do not travel (0.015 m at the contact): its legs do
   not fit a punch that lands at 0.30 s. The size and the timing follow K46.
4. The sink went from 0.18 to 0.13 m. With the step added the 0.18 crouch became a kneeling lunge on the women's
   pair (rear knee a hand off the canvas on my first sheet).
5. The waist hinge went from 10 to 5 deg and the step is 0.06, not 0.08: a bent arm stands the two boxers 6-8 cm
   nearer than a straight one, and the picture set refuses a head within 0.60 m of the other body.
6. The elbow is 129 deg at the touch, not the "three quarters of the arm" of the coach's line (about 100 deg, K52's
   professionals): at 129 it is inside K52's amateur band, plainly bent on the screen, and the heads still clear.
7. The contact speed came down a little (pace 1.7 x): the earlier contact key is a faster part of the bought arm.
8. The trunk bend of the hit man's take is scaled DOWN to 0.75 (the brief allowed scaling it up). Captured it is a
   doubled-over man; he asked for "a bit".
9. The picture tool reads "a head in the other body" as drawn, like the glove. The set's gate reads bones between
   frames, which is the take's own key before the join smoother: for a take that starts part-way into a fold that is
   5-6 cm more of his head toward the puncher than the picture shows. The bar (0.60) is unchanged; tools/pics2d_gate.gd
   is unchanged. The picture is saved with the tree paused on the film's own frame.
10. ops/previews/s546_bodycross is not committed (ignored, as before); the files are on the review board.
11. docs/BODYCROSS2_RESULT.md is left as it is (not mine); the table above replaces its NaN table.

## Still not right to my own eye
- **The fight does not play the new reaction** (step 5). The owner sees it on the sheet, the film and the game's
  pictures; a body hook in the 3D fight still gets the late fold.
- On the game's four landed pictures the hit boxer has bent only 3-6 deg. A later frame would show the bend, with the
  glove 3-8 cm off his body again - and "does not reach" was his last complaint, so the glove won.
- The glove leaves his body 4 pictures after the touch (men 6 cm off by picture 12, women 10 cm): he gives ground
  faster than a planted punch follows. Real, but at quarter speed the gap opens early.
- He is upright again after 0.52-0.53 s: the low edge of K48's 0.5-1 s. A hurt man would stay bent longer.
- On the women the glove lands on the waistband (7 cm over her hip joints): low. BODYCROSS2 raised the target 6 cm;
  the women's pair wants more, the men's does not.
- The crouch is still a deep one (knees 108 / 120 deg; a plain cross is about 143).
- The puncher's head stays on the centre line (BODYCROSS1's open item).
- The step is small (5.6 cm): at real speed it reads as a shift of the lead foot, not a stride.
- Both takes are authored from captured ones, not captured. A captured body straight and a captured gut-shot fold on
  the blow would replace them (the mocap buy is his call).

## On the review board (http://127.0.0.1:8787/review, "Body cross 3: bent elbow, he bends", S546)
Files in ops/previews/s546_bodycross/:
- bodycross3_after_twelve_pictures_m.png, _w.png - the sheet he marked, re-made: 3 before the touch to 8 after
- bodycross3_before_twelve_pictures_m.png, _w.png - the same twelve of BODYCROSS2's take, with the same captions
- bodycross3_touch_before_after_m.png, _w.png - before: the touch, 0.1 s later | after: the touch, 0.1 s later
- bodycross3_after_every_tenth_s_m.png, _w.png - after, one picture every 0.1 s (the step in, the fold, the way back)
- bodycross3_before_after_m.mp4, _w.mp4 - before left, after right; twice real speed, then quarter speed
- bodycross3_game_pictures_m.png, _w.png - the six re-made 2D pictures a set

## How to run it again
```
G=<godot> ; Q="python ops/Tools/godot_slot.py run --who <you> --"
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pics2d_bodycross_bake.gd          (the punch take)
$Q $G --headless --audio-driver Dummy --path . --script res://tools/pics2d_gutfold_bake.gd                           (the hit man's take)
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/clip_census.gd -- dry            (the two rows; merge by hand, contact_s back to 0.3)
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross3_ruler.gd -- <out> set=m|w react=pro_hit_by_gutshot_v3_fold tag=after
git show 98088087c:assets/anim/baked/mc_Box1_M3_Body_Cross.res > <old.res>     (the before side; its row from the same commit's clip_db.json)
$Q $G ... --script res://tools/bodycross3_ruler.gd -- <out> set=m|w old=<old.res> row=<row.json> react=pro_hit_by_gutshot_v2_short|pro_hit_by_gutshot_v2 tag=before
$Q python tools/hidden_desktop.py run --timeout=900 --log=<f> $G --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_film.gd -- <out> art=toon set=m|w old=<old.res> row=<row.json> old_as=own old_react=<take> react=pro_hit_by_gutshot_v3_fold caps_before=<out>/ruler3_<set>_before.json caps_after=<out>/ruler3_<set>_after.json
$Q python tools/hidden_desktop.py run --timeout=900 --log=<f> $G --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_pics.gd -- <scratch>/<set> art=toon set=m|w only=*body_cross     (then copy the six pictures and their contacts.json entries into assets/ui/fight_pictures/<set>)
```
