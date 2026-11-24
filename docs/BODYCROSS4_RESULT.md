# BODYCROSS4 result (S548, 2026-11-24) - the rear straight to the body is thrown in the 3D fight

Task: ops/research/TASK_BODYCROSS4.md. Owner, three sessions running (C502: "there is no elbow bent , the reaction should
force the opponent to bend hisposture a bit"); step 5, C505 on the close body hook's film: "this is wrong , there isno
punching on this clip".
METHOD followed: FIGHTPLAYER2, v2 only, NO new correction layer - the change is in which take is chosen, what hand a
settled punch is shown with, and one layer LESS on one take (the arm finish is not armed where the take's own keys land
it). The owner's eye is the ruler: every bar is read on pictures 1/60 s apart, as a fixed side camera sees them. The 3D
fight never decides: no bout number moved (the control, below).
STUDY the work follows: **K51_THE_HIT_RESPONSE** (a body punch: forward crumple, front-loaded, on the blow) and **K48**
(bend / brace, reset 0.5-1 s) for the hit boxer, unchanged from BODYREACT2; **K52** lines 10, 42, 46-47 (elbow at impact:
amateurs 137 +/- 12 deg) for the arm, as BODYCROSS3. Reference clip: MoCap Online Punch PRO body cross as re-cut in
BODYCROSS3 (pro_body_cross). `python ops/Tools/prior_research.py body cross straight rear body` was run; its top pages
(C223 digest, REFERENCE_PUNCH_TARGETS_S439, CLIP_CRITICS_S439) hold no verdict on the method that this work goes against.

## NOT GREEN - read this first
1. **Women, ON THE BODY: 118 of 120.** In 2 exchanges the glove front is 2.1 cm under her skin on the touch picture; my
   own margin for "not inside it" is 2.0 cm (the glove's padding). The other 118 read -2.0 to +2.6 cm.
2. **Men: the glove goes 6.8-8.4 cm under his skin on the pictures after the touch** (women 0.8-2.3 cm). The take was
   authored to drive 6-8 cm past where his surface was (BODYCROSS3, G75's follow-through); he only starts to bend on the
   third picture, so for 3 pictures (0.05 s) the glove is inside his outline. On the side film it is hidden between the
   bodies; I am saying it, not hiding it. The men's pair stands about 3 cm nearer than BODYCROSS3's own range (my reading of its table, not re-measured).
3. **Inside a burst a lead body hook can still be the close take he rejected.** From range the fight no longer picks it
   (step 5). Second in a combination there is no room to set the pair to the long hook's distance: over 240 planned
   rounds 57 of 208 thrown body hooks are still pro_body_shot (it was 223 of 367). The alternative there is worse: the
   long take, cut in part-way with its step lost, stops 16-17 cm short of him (measured, 30 of 30). A second captured
   body hook that reads at close range is the fix (his call: the mocap buy).
4. **The long body hook's arm is dead straight** (elbow 169-178 deg on the touch): it reads as a long straight left to
   the ribs more than a hook, and on the men's pair its glove is 3.7-6.3 cm off his skin on the touch picture (ON THE BODY for a body hook
   from rest: 109 of 120, before and after). Not touched: it is the take he said "nice" to (C504 / C506).
5. **One take only.** S513's variety rule wants two. Decided here, as the brief allows: one is enough to start; no
   boxer throws it twice running. A second take is a debt.
6. **Words and picture can disagree.** The fight log, the 2D pictures and a named combination's caption still say
   "body hook" for a punch the 3D ring now throws with the rear hand. They are outside this task's files; one call
   (`RoundScript.show(beats, south)`) gives them the same answer. For the coordinator.
7. tools/run_tests.sh is shared: I added `body_cross_play_test` after `body_react_test` (one word). For the coordinator.

## What now works
- **The punch is thrown.** Over 240 planned rounds a body cross lands in 42 (bar: 40, 1 round in 6); none before.
  160 body crosses are thrown in all, 44 land. No boxer throws two running (0).
- **A bent elbow, straightening through the touch**: 104-105 deg on the picture before the touch, 129 on the touch,
  130 after it, on 240 of 240 exchanges (both pairs).
- **On his body**: the glove front -0.02 to 0.002 (median -0.01) m from his trunk skin on the touch picture (men), -0.021 to 0.026 (median 0.016) m (women);
  it gets 0.499 to 0.569 (median 0.525) m nearer in the last 0.15 s (men), 0.384 to 0.465 (median 0.404) m (women).
- **He bends on the blow**: 10 deg or more on 3-4 pictures inside 0.15 s, 240 of 240; deepest 19.9 to 26 (median 22.4) deg (men),
  18.6 to 22.9 (median 21.3) deg (women). The fold rule is BODYREACT2's, untouched.
- **Step 5: from range the body hook is the take he liked.** Measured first, 120 exchanges a pair: the close take's
  glove gets 0.01-0.08 m (men) / 0.12-0.15 m (women) nearer his skin in the last 0.15 s and touches with the heads
  0.46-0.58 m apart - 0 of 136 read as a punch (bars: 0.25 m, 0.45 m). It failed on the glove's travel on every one;
  the heads were over 0.45 m. The long take: 0.85-1.08 m, heads 0.62-0.75 m, 104 of 104. WHICH IT WAS: the pool gives the
  take he liked - where the pair can be set to range (from rest or after a wait) the close take is not picked. From
  rest now: 240 of 240 body hooks read as a punch (before: 104 of 240).
- **After his own jab the body punch is the rear hand's** (hands alternate inside a combination): 80 of 80 exchanges
  hold every bar, both pairs.

## How it is decided (no draw anywhere)
The bout settles a body punch as "body_hook" and that name stays on the beat. A new move name out of RoundScript (the
brief's step 1, line 281) would have MOVED BOUT NUMBERS: BodyMap (rib damage), BodyLoad (arm load), the exchange's body
tally and the shipped player all read the move by name and skip one they do not know. So the round is not touched:
`RoundScript.shown(beat, southpaw)` only says which HAND the 3D ring shows it with.
- **The share comes from the game's own data**: the damage map already puts every body punch on one side of the ribs
  (the liver side 60 % of the time, BodyMap.LIVER_SHARE). An orthodox boxer's lead hook lands on the other man's right
  ribs; the left ribs are his rear hand's. So 40 % of body punches are the rear straight (a southpaw: 60 %), and the
  picture hurts the side the body panel marks. No random number is added or moved.
- **Inside a combination the hands alternate** (`RoundScript.show`): after his lead hand the body punch is the rear
  hand's, after his rear hand the lead hook's.
- **It lands when the settled punch lands**: same contact time as the hook it stands for; only the take starts later.
- **Its own keys**: where the plan has the pair at the take's distance the arm finish is not armed. Armed, the glove
  was held on the aim point 5 cm off his skin while the body came on: the arm was straight (168 deg) one picture
  BEFORE the touch and bent after it - the reverse of a punch. Measured, then removed for this take.

## The bars (tools/bodycross4_ruler.gd; men mh_boxer_02 v 01, women 11 v 14; 60 seeds a size, 120 a pair)
Committed RED on the shipped tree first (5277af362). "Before" = the same 120 settled punches on the shipped tree.

| Bar | Men before | Men after | Women before | Women after |
|---|---|---|---|---|
| THROWN: the plan shows a body cross | 0 of 120 | **120** | 0 of 120 | **120** |
| ON THE BODY: glove on his trunk skin on the touch picture (6 cm, not over 2 cm in) | 109 (a hook) | **120** | 120 (a hook) | **118** |
| THE ELBOW: under 150 deg before the touch, opening into it | 10 | **120** | 2 | **120** |
| HE BENDS: 10 deg or more on 3 pictures inside 0.15 s | 120 | 120 | 120 | 120 |
| APART: no head inside the other man | 120 | 120 | 120 | 120 |
| FLOOR: no ball or heel over 3 cm under the canvas | 120 | 120 | 120 | 120 |
| Verdict | RED | **GREEN** | RED | **RED (ON THE BODY, 2 of 120 by 1 mm)** |

THROWN over 240 planned rounds (as choreographer_test R14 builds them): 0 -> **42 rounds** land a body cross (bar 40);
two running: 0.

FLOOR, said plainly: BODYREACT2's reading (a joint under its own height in the guard) gives the men's puncher 3.2 cm on
the lead ankle, over its 3.0 bar. The guard stands on the balls with the heels up, so a foot PLANTED flat reads as sunk.
The ruler now reads the ball against where it stands in the guard and the ankle against a flat foot (the skeleton's
rest pose): 2.4 cm men, 2.2 cm women, on every exchange. Both readings are printed.

## The loop check and the control
| | Before | After |
|---|---|---|
| Landed body punches the bout settled, 240 rounds | 123 | 123 |
| ... shown as the lead body hook | 123 | 79 (64 %: over half, the brief's limit) |
| ... shown as the rear straight to the body | 0 | 44 |
| Thrown body hooks / body crosses | 367 / 0 | 208 / 160 |
| Takes of all body punches thrown | body_shot 223, kidney_shot 144 | body_cross 160, kidney_shot 151, body_shot 57 |
| Body punches the plan could not put at their take's distance | 5 | 8 |
| Punches shown / cut, 240 rounds | 4,890 / 150 | 4,892 / 148 |
| Wait things (fidgets, paws, feints) | 1,700 | 1,711 |

- **Head punches pick what they picked: 9,600 of 9,600, men; 9,600 of 9,600, women** (BR2_CONTROL SAME).
- **10 played rounds (seeds 100-109), both pairs: thrown, landed, cut and contacts reached are the same, round by
  round, 10 of 10** (21/7/0/21, 21/7/0/21, 21/7/0/20, 21/7/0/21, 21/7/0/20, 21/7/0/21, 20/7/1/20, 20/7/1/20, 20/7/1/20,
  19/7/2/19 men; women the same but 102: 21 reached and 104: 20).
- Over 240 PLANNED rounds two punches fewer are cut (150 -> 148): a body cross starts later than the hook it stands
  for, so two missed punches that were cut by a stun now get thrown. Landed: unchanged. Said, not hidden.
- One-rep trial before every 60-seed run (one seed, one pair), as the brief asks.

## Films and sheets (opened by me, every one named here)
http://127.0.0.1:8787/review, S548, "not scored: your eye". Files in ops/previews/s548_bodycross4/ (not in git).
- bodycross4_before_after_m.mp4, _w.mp4 - fixed side camera, left the lead hook the fight threw for this punch, right
  the rear straight; twice at real speed, once at quarter speed. bodycross4_twelve_pictures_m.png, _w.png.
- bodycross4_game_camera_m.png, _w.png - the game's own camera, the touch and 0.10 s later, top before, bottom after.
- bodycross4_jab_then_body_cross_m.mp4, _w.mp4 and their twelve pictures - second in a combination.
- bodycross4_close_hook_before_after_m.mp4, _w.mp4 and twelve pictures - step 5, the same punch at the same moment.
"Before" for the close hook was filmed with the one new pick rule switched off by hand for that run (the shipped pick,
the same seed); it is back on. Framing: every run 143 of 143 or 144 of 144 pictures hold both boxers head to feet.

What my eye says, per still: the gap - the rear glove is on his stomach on the touch picture, both pairs; noses - no
head near the other body (heads 0.60-0.76 m); wrists - the free hand stays at the chin, his gloves stay at his head
through the bend; feet - all four on the canvas, the puncher's lead foot planted flat.
Still wrong to my eye:
- **Men, game camera: the glove arrives under his elbows and his forearm hides it** - it reads as a punch into the
  guard more than into the stomach. On the women's pair the glove is clear below her elbows.
- **The first two pictures after the touch show no bend** (0.1, 0.6 deg): a beat between glove and fold at quarter speed.
- **The puncher drops low and stays square-on for about 0.1 s after the touch** before the arm comes home.
- The close hook's replacement is a long straight-armed punch (NOT GREEN 4): better than a shove, not yet a hook.

## Decided (no questions asked)
1. The round is not changed; the hand is a showing rule (above). The brief's same-draw split would have reached only
   rounds built without profiles (the real game draws punches in RoundStyle) and would have moved rib damage.
2. The share is the damage map's, not a number of mine.
3. One helper, `ChoreoRules.is_body(move)`, over one list (`ClipCensus.BODY_FAMILIES`): a third body punch is one name.
4. The body cross is not a "straight" in the plan's rules: it turns the hips 70 deg and changes level, so it starts
   and comes home like a hook.
5. `"played": true`: ClipCensus.V2_PLAYS names the takes only the v2 player plays, so clip_db_test still holds the list.
6. The close take is refused only where the pair can be set to range (NOT GREEN 3).
7. "Never twice running" = no boxer's two punches in a row are both body crosses.
8. FLOOR is read against the canvas (above).

## Tests
RESULT: tests/body_cross_play_test.gd -> BODY_CROSS_PLAY failures=0
RESULT: tests/player2_test.gd -> PLAYER2 failures=0
RESULT: tests/choreographer_test.gd -> CHOREO failures=0
RESULT: tests/body_react_test.gd -> BODY_REACT failures=0
RESULT: tests/round_script_test.gd -> ROUND_SCRIPT failures=0
RESULT: tests/clip_db_test.gd -> CLIP_DB failures=0
RESULT: tests/fight_pictures_test.gd -> FIGHT_PICTURES failures=0
player2_test's two standing debts print inside their guards, as before this task:
  DEBT JUMPS no head moves over 12 cm in 1/30 s outside a contact (3; guard 12)
  DEBT SLIDE a standing foot travels under 1 m an exchange (9.11 / 9.38 over 2; guard 6 m: 5 until S537 KNEEROOT1 gave a punch its own feet back, docs/KNEEROOT1_RESULT.md)
The full suite was not run (05:00).

## How to run it again
```
G=<godot> ; Q="python ops/Tools/godot_slot.py run --who <you> --"
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross4_ruler.gd -- <out> fightplayer2 set=m|w [move=cross|hook] [after=jab] [seeds=60] [show]
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodycross4_ruler.gd -- <out> thrown=240
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_ruler.gd -- <out> fightplayer2 set=m counts=10 play control=<dir of an earlier run>
$Q python tools/hidden_desktop.py run --timeout=300 --log=<f> $G --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/bodycross4_film.gd -- <out> fightplayer2 set=m|w ask=cross|hook side=before|after [slot=1] [after=jab] [cam=game]
```
A ruler run takes about 3 minutes a pair; a film run 15 s.

## Commits (main, not pushed)
- 5277af362 step 0: the ruler, RED on the shipped tree
- this commit: steps 1-5, the film tool, the test, this page
