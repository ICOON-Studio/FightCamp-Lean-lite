# BODYCROSS2 result (S545, 2026-11-24) - the body cross reaches him and hurts him

Task: ops/research/TASK_BODYCROSS2.md. Owner, review comment C500 on the S542 film: "the punch in the stomach does not
reach opponent and the motion reads more like he is trying to touch hime rather than punch him and hurt him".
METHOD followed: FIGHTPLAYER2, v2 only, no new correction layer in scripts/fight3d. Nothing in scripts/fight3d was
edited. The fix is in the take's own keys and in which captured reaction the hit man plays, by the v2 player's own route.
Nothing was bought or generated.

## What now works
- `pro_body_cross` is re-authored (same file, assets/anim/baked/mc_Box1_M3_Body_Cross.res). The glove meets his body with
  the elbow still bent (143 deg), at 8.2 m/s (women) / 9.4 m/s (men) - its fastest picture - and the rest of the arm goes
  8-9 cm INTO him. On the old take the glove stopped 2-7.5 cm short of his skin at 0.05-0.24 m/s.
- The hit man is hurt: he gives 19-25 cm of ground and folds 7-8 deg inside 0.15 s, staggers back about half a metre
  and is not back in his stance for 0.7-1.1 s. On the old film he moved 3 cm.
- The ruler (tools/bodycross2_ruler.gd) was committed RED on the shipped take (8916b1032) and reads GREEN on both sets.
- Before/after films on the fixed side camera and the stills are on the review board. The twelve body-cross pictures
  are re-made. The owner's eye closes it; the green ruler closes nothing alone.

## Why the old one read as a touch (three causes, all measured)
1. **The contact was the arm's furthest key.** By construction the glove has stopped there (CROSS_POWER_S439's main
   finding on the head cross; BODYCROSS1 kept it). Its top speed came 5 pictures (0.083 s) before.
2. **The film and the pictures played the punch through the game's finish (PunchAim).** That layer eases the glove ONTO
   the body target and holds it 0.04 s: its blend ends flat, so the glove arrives at zero speed whatever the take does.
   And the body target (the "rib point") is a point in the air 5-7.5 cm in front of his skin: the glove was "on target"
   (BODYCROSS1's 0.2 cm) and visibly short. Control run, the NEW take with that finish switched on: 5.2 cm short,
   0.31 m/s at the contact, 4 of 8 bars fail. So the film and the pictures now play this take on its own keys.
3. **The hit man's take was started from its first key, on the spot.** The v2 player starts a body reaction part-way in
   (so the fold is on the blow) and lets the take's own step back move the body; the old film tool did neither.

## Step 1 - which study each target follows
| Bar | Number | Study (line) | Reference clip |
|---|---|---|---|
| Glove meets his body SURFACE, then 0.04-0.10 m past where it was | follow-through 110 mm | G75_STRIKE_SPEEDS.md 26-27, 127 (Atha 1985); CROSS_POWER_S439 "carry-through 0-2 cm, real 11" | Frank Bruno's cross (Atha) |
| Speed at the contact 6 m/s or more | contact 5.9-8.2 m/s; cross 8.22 +/- 1.08, 8.9, 9.14 +/- 2.06 | G75 20, 24-27 (Whiting, Piorkowski, Atha, Walilko) | - |
| ... and 70 % or more of the top; top 8 or more | peaks 6.6-12.5, fastest 8-21 ms before contact; cross band 6-11.5 | G75 20, 23, 179; K54 34 | - |
| First move to contact 0.23-0.36 s | cross 223 +/- 99 ms to 495; readable floor 230-270 ms | G75 112, 179; K54 22 | BODYCROSS1's own 0.358 s |
| Elbow bent at the contact | amateurs 137 +/- 12 deg, professionals 102 +/- 17 | K52 46-47 | the bought cross's own key (elbow 143 at 0.24 s) |
| Hips and shoulders turn | the bought take's own keys, nothing added | owner S537; K49 28-30 for the real size | MoCap Online Punch PRO Right_Cross (with ActionForge's legs) |
| Weight forward | body straight 0.055-0.061 m; plain cross 0.04 | REFERENCE_PUNCH_TARGETS_S439 lines 97 (Undisputed Straight_Body_R0), 52 (Blood & Canvas) | Undisputed Straight_Body_R0 |
| Fist height | 0.30-0.40 m under the head form | REFERENCE_PUNCH_TARGETS_S439 body row / BODYCROSS1 step 1 | Blood & Canvas AS_JabBody |
| Rear heel up | no published figure (K46 line 19) | our captured rear uppercut 6.1 cm, cross 1.3-1.9 (CROSS_POWER_S439) | pro_right_uppercut |
| The hit man folds / gives ground, is not back at once | a body shot folds a man 30-50 cm over 5-6 pictures; reactions "too small" | ChoreoRules REACT_FOLD_S / REACT_HEAD_M (S530 critics); FIGHTPLAYER2 critic rounds | the bought gut-shot takes |

## Step 2 - the ruler, before and after
Tool: tools/bodycross2_ruler.gd (headless). The film's own pairs (men: mh_boxer_02 red v 01 blue, blue throws; women:
11 red v 14 blue, red throws), the pictures' side camera, 60 pictures a second. The glove is read against the hit man's
trunk skin as drawn (his skinned mesh, 1,345-1,487 vertices), never the rib point. Speeds are what the side camera sees.

| Measure | Bar | Men before | Men after | Women before | Women after |
|---|---|---|---|---|---|
| Glove to his body at its nearest | touches (1 cm) | NaN m short | touches | NaN m short | touches |
| Past where the surface was | 0.04-0.10 m | NaN | **NaN** | NaN | **NaN** |
| Speed at the contact | 6 m/s or more | NaN | **NaN** | NaN | **NaN** |
| ... as a share of the top | 70 % or more | 1 % | 100 % | 3 % | 100 % |
| Top speed (when) | 8 m/s or more | NaN (NaN s before) | NaN (the contact picture) | NaN (NaN s before) | NaN (the contact picture) |
| First move to contact | 0.23-0.36 s | NaN | NaN | NaN | NaN |
| Hit man within 0.15 s: hips back | 0.05 m (or fold) | NaN | **NaN** | NaN | **NaN** |
| ... trunk fold (neck over hips) | 0.05 m (or hips) | NaN (NaN deg) | NaN (NaN deg) | NaN (NaN deg) | NaN (NaN deg) |
| Posture back after | 0.4 s or more | NaN s | NaN s | NaN s | NaN s |
| Elbow at the contact | (K52: 137 +/- 12) | NaN deg | NaN deg | NaN deg | NaN deg |
| Puncher's hips forward at the contact | (0.04-0.06) | NaN | NaN | NaN | NaN |
| Hips apart in the guard | - | NaN m | NaN m | NaN m | NaN m |
| **Verdict** | | **RED** (5 of 8) | **GREEN** | **RED** (7 of 8) | **GREEN** |

Control (men, the new take with the game's finish armed): NaN m short, NaN m/s at the contact, RED 4 of 8.

Men, after, picture by picture (0 = the contact):

| Picture | Glove to his body (m, under 0 = in it) | Speed m/s | Past where the surface was | His hips back | His fold |
|---|---|---|---|---|---|
| -6 | 0.456 | 2.32 | -0.572 | 0.000 | 0.018 |
| -5 | 0.437 | 2.07 | -0.540 | 0.000 | 0.015 |
| -4 | 0.397 | 3.23 | -0.487 | 0.000 | 0.012 |
| -3 | 0.347 | 3.93 | -0.421 | 0.000 | 0.009 |
| -2 | 0.245 | 6.72 | -0.308 | 0.000 | 0.006 |
| -1 | 0.117 | 9.14 | -0.156 | 0.000 | 0.003 |
| 0 | 0.000 | 9.41 | 0.001 | 0.000 | 0.000 |
| 1 | -0.063 | 4.75 | 0.078 | 0.001 | 0.005 |
| 2 | -0.043 | 1.28 | 0.093 | 0.018 | 0.006 |
| 3 | -0.012 | 0.35 | 0.089 | 0.039 | 0.002 |
| 4 | 0.029 | 0.98 | 0.074 | 0.065 | 0.006 |
| 5 | 0.073 | 1.06 | 0.058 | 0.091 | 0.017 |
| 6 | 0.116 | 1.18 | 0.041 | 0.119 | 0.030 |
| 7 | 0.149 | 1.27 | 0.021 | 0.146 | 0.044 |
| 8 | 0.180 | 1.52 | -0.004 | 0.171 | 0.058 |
| 9 | 0.217 | 1.88 | -0.035 | 0.193 | 0.068 |
| 10 | 0.260 | 2.26 | -0.071 | 0.214 | 0.076 |

The first-move bar is read from the first picture his glove or hips move (the studies' INIT / ACTION to CONTACT).
The fist alone, by CROSS_POWER's rule (from 15 % of its top speed): NaN s men, NaN s women (real fist
start to impact: Atha 100 ms; Undisputed's plain cross 0.13 s).

## Step 3 - what was changed in the take's keys
Tool: tools/pics2d_bodycross_bake.gd (headless, run once; it writes 60 keys a second into the file). Base: the plain
cross the game shows (the bought Punch PRO cross with ActionForge's legs). Kept from S542: hips sink 0.18 m, trunk
hinges 10 deg, both feet on their spots, knees over the toes (96.8 / 102.1 deg at the contact).
New, measured on the census body (mh_boxer_10):

| Change | Before (S542 take) | Now | Source |
|---|---|---|---|
| Contact key on the arm's travel | the furthest reach, elbow 168 deg | the bought take's 0.24 s, elbow **142.7 deg** | K52: 137 +/- 12 |
| What is left of the arm after the contact | 0 | **0.065 m** further, elbow to 167.3 deg, in 0.04 s | G75: follow-through 110 mm |
| Glove speed on the contact key | 0.9-1.1 m/s | **7.61 m/s** (the take's top) | G75: contact 5.9-8.2, cross 8.2-9.1 |
| The drive | the bought take's own pace (top 5.4) | speeds up to 2.0 x the bought pace on the contact, back to 1 x after it | CROSS_POWER fix 2 (done in the keys, not at run time) |
| The load | 1.45 x slower | 1.64 x slower (to 0.218 s) | what the sink needs, below |
| The sink | eased in and out | a fall: 7.05 m/s2 at most (1 g = 9.81), the legs brake at 9.24 | the brief: "not slowed more than a body falling needs" |
| Contact after the start | 0.358 s | **0.300 s**; whole take 0.927 -> 0.900 s | G75 line 112, 179 |
| Hips forward at the contact | 0.027 m | **0.059 m** | Undisputed body straight 0.055-0.061 |
| Rear heel up at the contact | 0.029 m (the bought take's own) | **0.055 m**, on the ball of the foot, toes flat | our captured uppercut 6.1 cm; no published figure |
| Hip line / shoulder line turn | the bought take's | the bought take's: 94 % / 90 % of its full turn is in by the new contact (49 of 52 deg, 67 of 75) | owner S537: nothing twisted |
| Glove height at the contact | the census rib point (0.889 m) | **0.949 m**: 0.06 over it, 0.32 m under the head form | REFERENCE_PUNCH_TARGETS: 0.30-0.40 under |
| Arm pitched from the shoulder | 1.4 deg | 0.0 deg (the higher contact needs none) | - |

Why 0.06 m higher: on the four film bodies the game's body target sits at the belt line (1-11 cm over the hit man's
hip joints). The first re-bake landed on the waistband, on the women 1-3 cm over the hip joints: it read low. Now 7.5
(women) to 18 cm (men) over them.

The clip table row (assets/data/clip_db.json, this take's row only): contact_s 0.358 -> 0.3, contact_gap_m 1.045 ->
1.019, hips_at_contact_m 0.027 -> 0.059, length 0.927 -> 0.9, the head and hips curves re-measured by tools/clip_census.gd
(dry run; no other row touched).

## Step 4 - the hit man: every captured body reaction on disk, measured
Measured with the ruler on the men's pair, each take forced in turn (react=<take>), started the v2 player's way.
"Census" columns are the clip table's (the take alone on the census body).

| Take | Length s | Census head travel m | Census hips travel m | Starts at s | Hips back in 0.15 s | Fold in 0.15 s | Posture back s | Note |
|---|---|---|---|---|---|---|---|---|
| pro_hit_by_gutshot_v1 | 1.333 | 0.137 | 0.137 | 0.430 | 0.070 | 0.137 (14.5 deg) | 0.43 | folds most of the gut-shot takes, gives little ground |
| pro_hit_by_gutshot_v1_short | 0.967 | 0.137 | 0.132 | 0.063 | 0.092 | 0.103 (10.9 deg) | 0.37 | back in his stance too soon (0.37 s; bar 0.4) |
| pro_hit_by_gutshot_v2 | 1.967 | 0.291 | 0.499 | 0.346 | 0.226 | 0.080 (8.4 deg) | 1.03 | **the v2 player's pick on the women** (film, pictures) |
| pro_hit_by_gutshot_v2_short | 1.667 | 0.267 | 0.461 | 0.080 | 0.193 | 0.068 (7.1 deg) | 0.72 | **the v2 player's pick on the men** (film, pictures) |
| pro_hit_by_gutshot_v3 | 1.767 | 0.348 | 0.339 | 0.047 | 0.115 | 0.061 (6.4 deg) | 0.87 | the stand-in when v2 and v2_short were both just shown in the exchange |
| pro_hit_by_kidneyshot_v1 | 1.433 | 0.137 | 0.272 | 0.397 | 0.149 | 0.053 (5.6 deg) | 0.43 | a kidney shot from the side; the player never picks it for a body punch (name rule: gutshot only) |
| react_body | 1.1 | 0.199 | 0.027 | 0.000 | 0.022 | 0.150 (15.9 deg) | 0.47 | our own old clip: folds on the spot, gives no ground; never picked (name rule) |

**What the v2 player plays when a body punch lands:** ChoreoReact.react (move body_hook) takes only the takes named
"gutshot", picks the one whose head travel is nearest 0.30 m for his size (v2 and v2_short share it; v3 is the stand-in when both were just shown), and
ChoreoReact.start_s starts it part-way in so the fold arrives 0.17 s after the glove; Player2 starts it one picture
after the contact on the fold join, and the body follows the take's own step back. That route already exists and is
right. The S542 film did not use it. The film and picture tools now call it; nothing was wired or authored.
No mc_ (Punch Starter) body reaction exists; assets/anim/baked holds no other body-hit take.

Feedback-loop check, before the picture run: family body_cross holds only pro_body_cross ("played": false; no BeatClips
pool, no choreographer punch list names it); the reaction route is called only for the landed body cross of these tools.

## Steps 5 and 6 - film, pictures, tests
- Films (tools/pics2d_bodycross_film.gd, hidden desktop): the pictures' fixed side camera, widened to 3.0 m so the step
  back stays in frame, never moved during a film. Left: the S542 take exactly as it was filmed (its file and row read
  from commit 49121faa6 at film time). Right: the new take. Twice at real speed, then once at quarter speed. Every
  one of the 542 pictures passed the framing check (both boxers head to toes).
- Same pair as the film he commented on. Distance: the puncher stands where the take's own glove meets the body, so
  the men start 4 cm closer (hips 1.241 -> 1.199 m) and the women 1 cm (1.068 -> 1.061).
- Pictures (tools/pics2d_bodycross_pics.gd): all twelve re-made in both sets. The four landed ones are the film's own
  frame two pictures after the touch (glove at its deepest, 1.3-3.8 cm into his body as drawn), on the take's own
  keys; blocked and missed go through the set tool's own route with the new take. All twelve passed the set's gate.
- tests/fight_pictures_test.gd got one check: a landed body cross is on or in his body as drawn, never through it.

RESULT: tests/fight_pictures_test.gd -> FIGHT_PICTURES failures=0
RESULT: tests/fight_pictures_gate_test.gd -> FIGHT_PICTURES_GATE failures=0
RESULT: tests/player2_test.gd -> PLAYER2 failures=0
RESULT: tests/clip_db_test.gd -> CLIP_DB failures=0

Not mine, seen on the way: since about 02:54 every headless run prints SCRIPT ERROR lines from scripts/state/Data.gd.
Another session's uncommitted edit there (line with "Staff") put a comment before the row's closing comma, so the file
does not parse. The four tests above print their own pass lines and zero failures; the runner's rule (a SCRIPT ERROR
fails a test) will read fight_pictures_test red until that comma is back. I did not touch the file.

## Decided without asking
1. The film and the pictures play this take WITHOUT the game's finish. The finish is the cause of both complaints
   (cause 2 above) and the METHOD line forbids patching it. If the fight ever throws a body cross, it must be planned
   at this take's own range (clip table: 1.019 m) with no finish, or the finish must first be changed to arrive moving
   and to aim at the skin (CROSS_POWER_S439 fix 1): that is a scoped change to scripts/fight3d, not this task.
2. The contact key is the bought take's 0.24 s (elbow 143), not its 0.233 s key (elbow 137). At 137 the men's longer
   arm went 0.110 m past the surface (bar 0.10) at 11.0 m/s. Both are inside K52's 137 +/- 12.
3. The drive's pace (2.0 x) is set so the smallest pair still tops 8 m/s: census body 7.6, women 8.2, men 9.4.
4. The first-move bar counts from the first movement of the body, as the studies it cites do; the fist-alone figure is
   printed beside it. The shipped take passes that bar either way.
5. The row's contact_s and contact_gap_m are set to the authored contact key. The census's rule marks the deepest key
   (0.333 s, 1.084 m): right for a punch finished by the arm solve, wrong for one whose last 6 cm are meant to be in him.
6. tools/pics2d_bodycross_stage.gd is new (the staging the ruler, the film and the pictures share) and
   tools/pics2d_bodycross_pics.gd is new (pics2d_set.gd is at 499 lines; the landed body cross is an override, the set
   tool is unchanged). The S542 film tool no longer ran (a constant it used was removed in S543): rewritten on the stage.
7. No hand authoring of a reaction, no change to which reactions other punches play.
8. ops/previews/s545_bodycross is not committed (as S542's was not); the files are on the review board.

## Still not right to my own eye
- The crouch is deep, most on the women: the rear knee comes low with the heel up. It reads as a level change, but a
  touch theatrical. The 0.18 m sink is S542's and was not re-judged here.
- For two to three pictures (0.03-0.05 s) the glove is 4-6 cm inside his belly as drawn, before his body gives: the v2
  player starts a reaction one picture after the contact. At quarter speed you can see it.
- The drive is four pictures long and the glove moves 15 cm a picture at the end. Real, but at 60 pictures a second
  the "fastest 8-21 ms before the contact" of the studies cannot be shown: the top is the contact picture itself.
- The men's 9.4 m/s at the contact is the upper side of the measured band (Walilko's Olympic boxers 9.14 +/- 2.06).
- The head still stays on the centre line (BODYCROSS1's open item).
- After the stagger the hit man resets about half a metre further away and the puncher does not follow: right for a
  film of one punch, the fight's distance plan would close it.
- The blocked pictures show the glove on a raised forearm at chest height, as before.
- The take is authored, not captured. A captured body straight would replace it (the mocap buy is his call).
- Found, not touched: the game's body target is a point 5-7.5 cm in front of the skin at belt height, and the finish
  stops every armed punch dead on its target. Body hooks in the fight go through the same two things.

## On the review board (http://127.0.0.1:8787/review, "Body cross: reaches and hurts", S545)
Files in ops/previews/s545_bodycross/ (copied to E:/FightCamp/review/2026-11-24_0258_body_cross_reaches_and_hurts):
- bodycross2_before_after_m.mp4, bodycross2_before_after_w.mp4 - before left, after right; twice real speed, then quarter speed
- bodycross2_contact_before_after_m.png, _w.png - before at its contact | after at the touch | after two pictures later
- bodycross2_after_every_picture_m.png - after, every picture from 3 before the touch to 8 after
- bodycross2_hit_man_every_tenth_s_m.png, _w.png - the hit man every tenth of a second
- bodycross2_pictures_m.png, _w.png - the six re-made 2D pictures a set

Every still was opened by me. Before: a clear gap between glove and belly (men), the glove resting at the waist
(women). After: the glove on the stomach above the waistband at the touch, sunk in two pictures later; he folds, goes
back, and stands bent over a second later.

## How to run it again
```
python ops/Tools/godot_slot.py run --who <you> -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross2_ruler.gd -- <out_dir> set=m|w as=own
git show 49121faa6:assets/anim/baked/mc_Box1_M3_Body_Cross.res > <old.res>      (the before side; its row from the same commit's clip_db.json)
python ops/Tools/godot_slot.py run --who <you> -- python tools/hidden_desktop.py run --timeout=900 --log=<f> <godot> --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/pics2d_bodycross_film.gd -- <out_dir> art=toon set=m|w old=<old.res> row=<row.json>
```
