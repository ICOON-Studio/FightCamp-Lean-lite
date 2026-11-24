# BODYREACT2 result (S547, 2026-11-24) - in the 3D fight a landed body punch now bends the hit boxer

Task: ops/research/TASK_BODYREACT2.md. Owner, C502: "there is no elbow bent , the reaction should force the opponent to
bend hisposture a bit"; before it S305 "body shots do not seem to have any impact", S310, S369.
METHOD followed: FIGHTPLAYER2, v2 only, no new correction layer (nothing runs over a playing take; nothing outside
`scripts/fight3d/v2/ChoreoReact.gd` changed in scripts/). The owner's eye is the ruler: every bar is read on pictures
1/60 s apart, as a fixed side camera sees them. Nothing bought or generated. Bout numbers untouched.
STUDY the work follows: **K51_THE_HIT_RESPONSE** - lines 12, 65-68 (a body punch to the solar plexus: "winded, forward
crumple"), lines 7, 81, 96 (a reaction is front-loaded: "retime so motion begins at contact"; "the fake look is often a
reaction that starts too late"), line 77 with K48 line 12 (posture reset 0.5-1 s); K48 lines 10, 13 ("bend / brace /
hold more than a long retreat"). No study gives a body punch's flexion in degrees: the 10 / 15-25 deg bars are the
brief's. Reference take: MoCap Online Punch PRO Hit_By_GutShot_V3, re-cut in S546 as pro_hit_by_gutshot_v3_fold
(docs/BODYCROSS3_RESULT.md).

## NOT GREEN - read this first
1. **tests/choreographer_test.gd is red (CHOREO failures=3) and I did not touch it: it is outside this task's files.**
   Two of its checks hold the rule this task replaces, one is a 1-in-12 sample that moved. The patch is in
   "The patch for choreographer_test" below. Until it is applied the 05:00 run shows that test red.
2. **Men: 17 of 120 exchanges bend 25.1-26.2 deg at the deepest (bar 15-25).** Every one is an exchange where he
   stood more upright than usual on the touch picture (lean 1.4-3.1 deg; the median is 5.3). The pick cannot change
   that; the women's pair is inside the bar on all 120.
3. **The heads-apart bar (0.60 m, the picture set's rule) is a debt, before and after alike.** It fails only where
   the punch is pro_body_shot, which stands the heads 0.46-0.58 m apart ON THE TOUCH PICTURE, before any answer, on
   the shipped tree too. The bend brings the heads another 0.11-0.14 m nearer (median; 0.20 at most); the nearest is
   0.31 m (men), 0.40 m (women). No head is inside the other man on any picture of any exchange.

## What now works
- A landed body hook in the 3D fight plays pro_hit_by_gutshot_v3_fold: 60 of 60 exchanges, both pairs, normal and big
  (shipped: v2_short / v2 for a normal punch, v3 for a big one; the fold take 0 of 240).
- He bends on the blow: 15.1-22.8 deg 0.15 s after the touch (shipped 0.6-10.3), on 3 to 5 pictures inside 0.15 s
  (shipped 0 or 1), 17.7-26.2 deg at the deepest 0.20-0.23 s after the touch, upright again after 0.47-0.63 s.
- His gloves stay by his head through the bend (the captured take's own arms; opened on every sheet).
- Head punches pick exactly what they picked: 9,600 of 9,600 (take and start), both pairs.
- A round shows the same punches: 10 played rounds, the same thrown / landed / cut / reached, round by round.

## The rule, in one sentence
For a landed body punch `ChoreoReact.react` plays the gut-shot take whose PICTURE shows 10 deg or more of bend
0.117 s after the key the player starts it on (a normal punch draws among such takes, a big one takes the deepest; if
no take does, today's head-travel pick stands and the plan's log says so).

How it reads that: `tools/bodyreact2_bake.gd` reads each gut-shot take's hips - neck line from its own keys on the
census body and stores it on the take's clip_db row (`fold_g`, 30 a second, over the guard the fight stands in);
`ChoreoReact.fold_shown` multiplies it by how far the fold join has carried him out of his guard by then.

| Take | Starts at | A picture shows 0.117 s later (the pick's number) | Keys 0.15 s later | Deepest (take time) |
|---|---|---|---|---|
| pro_hit_by_gutshot_v1 | 0.430 s | -4.0 deg | -3.5 | -0.7 at 0.70 s |
| pro_hit_by_gutshot_v1_short | 0.063 s | 1.0 | 2.8 | 4.3 at 0.30 s |
| pro_hit_by_gutshot_v2 | 0.380 s | 6.6 | 10.1 | 22.6 at 0.87 s |
| pro_hit_by_gutshot_v2_short | 0.130 s | 5.4 | 8.2 | 19.6 at 0.57 s |
| pro_hit_by_gutshot_v3 | 0.064 s | 1.3 | 5.4 | 27.2 at 0.50 s |
| **pro_hit_by_gutshot_v3_fold** | 0.000 s | **13.0** | 19.6 | 22.4 at 0.23 s |

Only one take folds on the blow, so every body punch plays it.

## The ruler, before and after (tools/bodyreact2_ruler.gd)
A body hook landed through the player's own route (Player2.queue -> Choreographer.plan -> ChoreoReact.react ->
the player's events, joins and layers), 60 seeds a size, each exchange its own seed by the player's own seed rule,
every exchange played whole at 60 pictures a second and read as drawn. The fixed side camera looks across the line of
the two pelvises on the touch picture. Fold = his hips - neck line against upright on that screen, the change since
the touch picture. Pairs: men mh_boxer_02 (red) v 01 (blue), blue throws; women 11 (red) v 14 (blue), red throws.
Committed RED on the shipped tree first (9f21983). Numbers are the least and the most over the 60 exchanges.

**Which take was drawn**

| | Men normal | Men big | Women normal | Women big |
|---|---|---|---|---|
| Before | v2_short 39, v2 21 | v3 60 | v2 39, v2_short 21 | v3 60 |
| After | v3_fold 60 | v3_fold 60 | v3_fold 60 | v3_fold 60 |

**What the pictures read**

| Measure | Men normal: before | after | Men big: before | after | Women normal: before | after | Women big: before | after |
|---|---|---|---|---|---|---|---|---|
| Bend 0.15 s after the touch, deg | 4.6-10.3 | 16.9-22.8 | 2.8-8.2 | 17.1-22.4 | 3.1-9.8 | 15.5-19.4 | 0.6-5.0 | 15.1-19.4 |
| Pictures at 10 deg or more inside 0.15 s | 0-1 | 3-5 | 0 | 3-4 | 0 | 3-4 | 0 | 3-4 |
| Deepest bend, deg | 17.6-24.5 | 20.1-26.1 | 24.8-30.9 | 20.3-26.2 | 14.9-23.5 | 18.0-22.7 | 22.0-27.8 | 17.7-23.1 |
| ... when, s after the touch | 0.50 | 0.20-0.23 | 0.43 | 0.20-0.23 | 0.47-0.48 | 0.20-0.23 | 0.43 | 0.20-0.23 |
| Upright again (within 5 deg), s | 0.70-1.07 | 0.50-0.63 | 0.75-0.90 | 0.50-0.63 | 0.68-0.98 | 0.47-0.53 | 0.72-0.78 | 0.47-0.55 |
| Nearest head to the other's trunk line and head, m | 0.49 | 0.31 | 0.48 | 0.33 | 0.56 | 0.40 | 0.54 | 0.42 |
| Deepest ball or ankle under its guard height, m | 0.029 | 0.029 | 0.029 | 0.029 | 0.029 | 0.030 | 0.027 | 0.030 |

**The bars: exchanges of 60 that hold each**

| Bar | Men normal: before | after | Men big: before | after | Women normal: before | after | Women big: before | after |
|---|---|---|---|---|---|---|---|---|
| ON TIME: 10 deg or more on 3 pictures inside 0.15 s | 0 | **60** | 0 | **60** | 0 | **60** | 0 | **60** |
| A BIT: deepest 15-25 deg | 60 | 52 | 1 | 51 | 59 | 60 | 20 | 60 |
| UPRIGHT: within 5 deg again inside 0.8 s | 38 | 60 | 48 | 60 | 21 | 60 | 60 | 60 |
| APART: no head under 0.60 m (debt, see below) | 23 | 23 | 29 | 29 | 31 | 21 | 29 | 29 |
| ... a head inside the other man, pictures | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| FLOOR: no ball or ankle over 3 cm under its guard height | 60 | 60 | 60 | 60 | 60 | 60 | 60 | 60 |
| Verdict | RED | **RED** (A BIT) | RED | **RED** (A BIT) | RED | GREEN WITH DEBT | RED | GREEN WITH DEBT |

The APART line, after: men normal - under 0.60 m in 37 exchanges, all 37 already under on the touch picture; men big
31, all 31; women normal 39, 37 of them on the touch picture (the other two are kidney shots that went from 0.60 to
0.594-0.599); women big 31, all 31. Every one of them is a pro_body_shot exchange (touch 0.46-0.58 m); with
pro_kidney_shot the heads stay 0.59-0.70 m apart through the bend.

## The control arm: head reactions unchanged
For each head punch (jab, cross, lead hook, rear hook, both uppercuts), normal and big, 400 seeds, both bodies' sizes
of each pair: the take ChoreoReact picks and where it starts. Shipped tree against this tree: **9,600 of 9,600 the same,
men; 9,600 of 9,600 the same, women** (`BR2_CONTROL SAME`). tests/body_react_test.gd holds the same thing against the
table with the folds taken out (4,800 of 4,800), and that the body pick leaves the exchange's dice where the old pick
left them (600 of 600): the head-travel pick is still drawn first, so every other draw of an exchange is what it was.

## The loop check: a round's punches, before and after
One-rep trial first (men, one seed a size): the drawn take changed from v2_short / v3 to v3_fold after the rule; the
60-seed run followed. 10 rounds as player2_test builds them (Slugger v Boxer, seeds 100-109), planned AND played on the
men's pair:

| Seed | Shown (thrown less cut) | Landed | Cut | Contacts reached when played | Landed body hooks: the take, before -> after |
|---|---|---|---|---|---|
| 100 | 21 = 21 | 7 = 7 | 0 = 0 | 21 = 21 | none |
| 101 | 21 = 21 | 7 = 7 | 0 = 0 | 21 = 21 | none |
| 102 | 21 = 21 | 7 = 7 | 0 = 0 | 20 = 20 | 1: v2_short -> v3_fold |
| 103 | 21 = 21 | 7 = 7 | 0 = 0 | 21 = 21 | 1: v2_short -> v3_fold |
| 104 | 21 = 21 | 7 = 7 | 0 = 0 | 20 = 20 | 1: v2_short -> v3_fold |
| 105 | 21 = 21 | 7 = 7 | 0 = 0 | 21 = 21 | none |
| 106 | 20 = 20 | 7 = 7 | 1 = 1 | 20 = 20 | none |
| 107 | 20 = 20 | 7 = 7 | 1 = 1 | 20 = 20 | none |
| 108 | 20 = 20 | 7 = 7 | 1 = 1 | 20 = 20 | none |
| 109 | 19 = 19 | 7 = 7 | 2 = 2 | 19 = 19 | none |

Only 3 of those 10 rounds land a body hook, so I also planned 240 rounds the way choreographer_test R14 does (Slugger
v Slugger): **4,890 punches shown before and after, 123 landed body hooks.** What does move is the quiet stretches
after a body punch (his answer hands back to the guard at a different time): fidgets 1,041 -> 1,039, paws 507 -> 521,
jab feints 108 -> 113, cross feints 19 -> 18, body feints 9 -> 9 (1,684 -> 1,700 wait things).

## Films and sheets (opened by me, every one)
On the review board, http://127.0.0.1:8787/review, "Body hook in the 3D fight: the hit boxer now bends on the blow
(before / after)", S547, "not scored: your eye". Files in ops/previews/s547_bodyreact/ (not in git):
- bodyreact2_before_after_m.mp4, _w.mp4 - fixed side camera, the shipped pick left, the new pick right; twice at
  real speed, then once at quarter speed. Punch: pro_kidney_shot (the longer body hook).
- bodyreact2_twelve_pictures_m.png, _w.png - 3 pictures before the touch to 8 after; top two rows before, bottom two
  after; each caption is what the ruler's reading gives on THAT picture.
- bodyreact2_game_camera_m.png, _w.png - the game's own broadcast camera, the ring as the fight shows it, 0.10 /
  0.15 / 0.23 s after the touch; top before, bottom after.
- bodyreact2_before_after_m_close.mp4, _w_close.mp4 and bodyreact2_twelve_pictures_m_close.png, _w_close.png - the
  same for pro_body_shot, the close body hook (the crowded case of "NOT GREEN" 3).
How they were made: tools/bodyreact2_film.gd plays ONE exchange through the same route as the ruler; "before" takes
the folds out of the table in memory, which is the shipped pick draw for draw. Same pair, same seed, same punch take,
same contact time on both sides: the films differ by the answer alone. The camera is set once and never moves.
Framing check: 144 of 144 (143 of 143) pictures of every run hold both boxers head to feet (`STILL_FRAMING ok`), game
camera too. I did not film the whole game to fight night (tools/fight3d_play.gd): it cannot hold the seed and the
punch still for a before / after pair.

What the twelve pictures read (the kidney shot; before = gutshot_v2_short men / gutshot_v2 women):

**Men**

| Picture | Before: bent deg (lean) | heads m | After: bent deg (lean) | heads m |
|---|---|---|---|---|
| 1 (-0.050 s) | -0.5 (6.3) | 0.72 | -0.5 (6.3) | 0.71 |
| 2 (-0.033 s) | -0.4 (6.5) | 0.71 | -0.3 (6.5) | 0.70 |
| 3 (-0.017 s) | -0.2 (6.7) | 0.71 | -0.2 (6.7) | 0.69 |
| 4 (the touch) | 0.0 (6.9) | 0.72 | 0.0 (6.8) | 0.69 |
| 5 (+0.017 s) | 0.1 (7.0) | 0.72 | 0.4 (7.2) | 0.68 |
| 6 (+0.033 s) | 0.1 (7.0) | 0.73 | 1.3 (8.1) | 0.67 |
| 7 (+0.050 s) | 0.3 (7.1) | 0.74 | 3.0 (9.8) | 0.65 |
| 8 (+0.067 s) | 0.8 (7.7) | 0.81 | 5.5 (12.3) | 0.68 |
| 9 (+0.083 s) | 1.6 (8.5) | 0.88 | 8.3 (15.2) | 0.70 |
| 10 (+0.100 s) | 2.7 (9.5) | 0.95 | 11.5 (18.3) | 0.73 |
| 11 (+0.117 s) | 3.8 (10.7) | 1.02 | 14.3 (21.2) | 0.76 |
| 12 (+0.133 s) | 5.0 (11.9) | 1.08 | 16.9 (23.8) | 0.78 |

**Women**

| Picture | Before: bent deg (lean) | heads m | After: bent deg (lean) | heads m |
|---|---|---|---|---|
| 1 (-0.050 s) | -0.4 (6.9) | 0.69 | -0.4 (6.9) | 0.68 |
| 2 (-0.033 s) | -0.3 (7.0) | 0.68 | -0.3 (7.1) | 0.67 |
| 3 (-0.017 s) | -0.1 (7.2) | 0.68 | -0.1 (7.2) | 0.66 |
| 4 (the touch) | 0.0 (7.3) | 0.69 | 0.0 (7.3) | 0.66 |
| 5 (+0.017 s) | 0.0 (7.3) | 0.70 | 0.2 (7.5) | 0.66 |
| 6 (+0.033 s) | 0.1 (7.4) | 0.70 | 0.9 (8.2) | 0.65 |
| 7 (+0.050 s) | 0.3 (7.6) | 0.71 | 2.3 (9.6) | 0.63 |
| 8 (+0.067 s) | 1.0 (8.2) | 0.78 | 4.5 (11.8) | 0.66 |
| 9 (+0.083 s) | 2.0 (9.3) | 0.85 | 7.3 (14.6) | 0.68 |
| 10 (+0.100 s) | 3.4 (10.7) | 0.92 | 10.5 (17.8) | 0.70 |
| 11 (+0.117 s) | 4.9 (12.2) | 0.99 | 13.5 (20.8) | 0.71 |
| 12 (+0.133 s) | 6.3 (13.6) | 1.05 | 16.3 (23.6) | 0.73 |

**Men, the close body hook (pro_body_shot)**

| Picture | Before: bent deg (lean) | heads m | After: bent deg (lean) | heads m |
|---|---|---|---|---|
| 1 (-0.050 s) | -0.3 (7.2) | 0.51 | -0.3 (7.2) | 0.50 |
| 2 (-0.033 s) | -0.1 (7.3) | 0.50 | -0.1 (7.3) | 0.49 |
| 3 (-0.017 s) | 0.0 (7.4) | 0.49 | 0.0 (7.4) | 0.47 |
| 4 (the touch) | 0.0 (7.4) | 0.49 | 0.0 (7.4) | 0.46 |
| 5 (+0.017 s) | -0.1 (7.4) | 0.50 | 0.2 (7.6) | 0.46 |
| 6 (+0.033 s) | -0.2 (7.2) | 0.51 | 0.8 (8.2) | 0.45 |
| 7 (+0.050 s) | -0.2 (7.2) | 0.52 | 2.0 (9.4) | 0.43 |
| 8 (+0.067 s) | 0.1 (7.5) | 0.54 | 4.0 (11.5) | 0.41 |
| 9 (+0.083 s) | 0.6 (8.1) | 0.55 | 6.6 (14.0) | 0.38 |
| 10 (+0.100 s) | 1.5 (8.9) | 0.55 | 9.5 (16.9) | 0.34 |
| 11 (+0.117 s) | 2.5 (9.9) | 0.57 | 12.3 (19.7) | 0.34 |
| 12 (+0.133 s) | 3.7 (11.1) | 0.61 | 14.9 (22.4) | 0.36 |

**Women, the close body hook**

| Picture | Before: bent deg (lean) | heads m | After: bent deg (lean) | heads m |
|---|---|---|---|---|
| 1 (-0.050 s) | -0.5 (5.1) | 0.62 | 0.1 (5.5) | 0.60 |
| 2 (-0.033 s) | -0.3 (5.2) | 0.61 | 0.1 (5.5) | 0.59 |
| 3 (-0.017 s) | -0.2 (5.4) | 0.60 | 0.1 (5.5) | 0.57 |
| 4 (the touch) | 0.0 (5.5) | 0.60 | 0.0 (5.4) | 0.56 |
| 5 (+0.017 s) | 0.1 (5.7) | 0.60 | 0.0 (5.4) | 0.56 |
| 6 (+0.033 s) | 0.4 (6.0) | 0.60 | 0.4 (5.8) | 0.55 |
| 7 (+0.050 s) | 1.0 (6.5) | 0.60 | 1.5 (7.0) | 0.53 |
| 8 (+0.067 s) | 1.9 (7.4) | 0.61 | 3.6 (9.0) | 0.51 |
| 9 (+0.083 s) | 3.1 (8.6) | 0.61 | 6.4 (11.9) | 0.48 |
| 10 (+0.100 s) | 4.5 (10.0) | 0.61 | 9.8 (15.2) | 0.45 |
| 11 (+0.117 s) | 6.1 (11.6) | 0.62 | 13.1 (18.5) | 0.43 |
| 12 (+0.133 s) | 7.5 (13.0) | 0.64 | 16.2 (21.6) | 0.43 |

Per still, by my eye: the gap between the boxers - the hook is on his body on the touch picture on all four sheets;
noses - no head in the other body, but on the close hook the bent man's head ends beside the puncher's lead shoulder
(0.34 m men, 0.43 m women); wrists - his gloves stay at his head through the bend, the puncher's free hand at his
chin; feet - all four on the canvas on every picture (before, the shipped take lifts his lead foot into a step back).

## What is still not right, to my own eye
- **The close hook is crowded.** With pro_body_shot the bent head ends at the puncher's shoulder. It reads as a man
  folding into the man who hit him, not as one body through another, but it is tighter than I would stage it. The
  cause is that punch's own range (0.46-0.58 m at the touch); the fix belongs to the punch's distance, not to the answer.
- **One take for every body punch.** Normal and big look the same, and two body hooks in one exchange play the same
  bend twice. Only one owned take folds on time. A second captured fold is the fix (the mocap buy is his call).
- **The first three pictures after the touch show almost nothing** (0.2-3.0 deg): the bend reads from the fourth
  picture (0.067 s). It is on time by the bar; at quarter speed there is a visible beat between glove and bend.
- **He is upright again after 0.47-0.63 s** - the low edge of K48's 0.5-1 s. A hurt man would stay bent longer.
- **Men, 17 of 120 over 25 deg** (25.1-26.2), as above.
- **He no longer gives ground the way the old takes did** (hips back 0.12-0.61 m, was 0.29-0.93): he bends where
  he stands, which is what K48 line 13 asks, but the pair stays closer after a body punch than it used to.
- The women's close film has a white flash over blue's head for a few pictures on both sides (the stage's crowd
  flash, not the reaction).
- clip_db still says `"played": false` on pro_hit_by_gutshot_v3_fold: that flag is the old player's pool list
  (BeatClips / ClipCensus, outside this task's files; tests/clip_db_test.gd holds it). The v2 player plays the take.

## SAID, NOT DONE: the body cross is still not thrown in the 3D fight
`pro_body_cross` has `"played": false`; its family body_cross has no pool; ChoreoRules.PUNCH_MOVES has no body_cross
and RoundScript emits no such move (only FightLog and the 2D pictures know it). What it would take:
1. A source: the round script (or BeatFire) must name a landed rear straight to the body - a presentation choice on a
   settled round, no bout number moves.
2. ChoreoRules: body_cross in PUNCH_MOVES with its impact time, hand and reaction size; `is_body` in ChoreoReact.react
   and the fold join in start_s / Player2 read `move == "body_hook"` today and must take body_cross too (the fold
   rule then applies as it is).
3. A pool: one take exists. S513's variety rule wants two; a second authored or captured take, or a ruling that one
   is enough to start.
4. Player2 aims a body punch at the ribs by `move == "body_hook"`: body_cross needs the same; player2_test LANDS
   must read it.
Not started.

## Decided (no questions asked)
1. **The pick reads the picture, not the keys.** The brief's rule was "the take's fold at 0.15 s after its start".
   Read from the keys over the bought guard pose (pro_idle, 1.9 deg BACK of upright) three old takes "fold" 12-17 deg
   by 0.15 s while the pictures show 3-10. Two corrections: the fold is read over the guard the fight stands in
   (Player2.WAITS: 3.7 and 6.6 deg forward; the touch pictures read 5.3 men, 6.9 women), and through the fold join's
   way (ChoreoReact.fold_shown). The time is 0.117 s, the first of the three pictures inside 0.15 s the bar needs.
   With both, the number is within 2 deg of the ruler's pictures for all four takes the fight has played.
2. **A body take shown twice plays twice.** The "not shown yet in this exchange" swap would hand the second body
   punch back to a late take.
3. **The old draw is kept.** The head-travel pick still consumes its draw; a draw among several fold takes (none
   today) uses its own generator seeded off the exchange's, without advancing it.
4. **The rule's two constants live in ChoreoReact.gd**, not ChoreoRules.gd (the one script file this task may edit).
5. **APART is printed as a debt** (player2_test's way: its numbers, and it fails only past its guard - a head inside
   the other man). The 0.60 half cannot tell before from after: the punch fails it on the touch picture.
6. **A new test file**, tests/body_react_test.gd, added to tools/run_tests.sh: player2_test.gd is 483 lines.
7. **The census drops the fold keys** (it writes each row afresh): run tools/bodyreact2_bake.gd after every census;
   body_react_test BAKED goes red until then. The bake writes clip_db.json back unchanged but for the six rows
   (324 added lines, none removed).

## The patch for choreographer_test (not applied: outside this task's files)
tests/choreographer_test.gd, three red lines on this tree, green on the shipped one:
- l.373 `R14: fidgets, paws and feints are all planned` asks for a cross feint in 12 rounds. There was exactly one;
  with the new body answer it is none ({fidget 50, paw 30, body_feint 1, jab_feint 3}; over 240 rounds 19 -> 18).
  Replace `int(kinds.get("cross_feint", 0)) > 0` with
  `int(kinds.get("jab_feint", 0)) + int(kinds.get("cross_feint", 0)) + int(kinds.get("body_feint", 0)) > 0`.
- l.403-405 `R15: the hit head travels by the punch` and `no punch gets a take under its floor` hold the old rule
  for the body (head travel 0.30 m; the fold take's is 0.15 from its first key). Drop the two body terms
  (`and float(mean["body_hook"]) > float(mean["cross"])`, `and float(mean["body_hook"]) >= 0.26`, and the body
  number from the message) and add:
  ```
  var be := _react_of("body_hook", 0)
  _check(React.fold_shown((rows.get(str(be.get("clip", "")), {}) as Dictionary).get("fold_g", []), float(be.get("from_s", 0.0)), React.BODY_FOLD_S, 30.0) >= React.BODY_FOLD_MIN_DEG,
      "R15: a body punch's take folds on the blow (%s)" % str(be.get("clip", "")))
  ```

## Tests
RESULT: tests/body_react_test.gd -> BODY_REACT failures=0
RESULT: tests/player2_test.gd -> PLAYER2 failures=0
RESULT: tests/clip_db_test.gd -> CLIP_DB failures=0
RESULT: tests/fight_pictures_test.gd -> FIGHT_PICTURES failures=0
Also run, green: root_path_test (ROOT_PATH failures=0), head_ease_test (HEAD_EASE_TEST failures=0), move_tip_test
(exit 0). player2_test on the shipped files against now: landed 14, median glove 0.004 m, head jumps 2, heads inside 0
on both; its two standing debts print as DEBT inside their guards on both (JUMPS 2 of guard 12; SLIDE 9.65 / 9.65 m
shipped, 9.65 / 9.45 m now, guard 12).
RED: tests/choreographer_test.gd -> CHOREO failures=3 (the patch above).
The full suite was not run (05:00).

## How to run it again
```
G=<godot> ; Q="python ops/Tools/godot_slot.py run --who <you> --"
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_bake.gd                          (after every census)
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_ruler.gd -- <out> fightplayer2 set=m|w [control=<dir of an earlier run>]
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_ruler.gd -- <out> fightplayer2 set=m counts=10 play
$Q $G --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/bodyreact2_ruler.gd -- <out> fightplayer2 set=m waits=240
$Q python tools/hidden_desktop.py run --timeout=300 --log=<f> $G --path . --windowed --resolution 1920x1080 --audio-driver Dummy --fixed-fps 60 --script res://tools/bodyreact2_film.gd -- <out> fightplayer2 set=m|w side=before|after [slot=1] [cam=game]
ffmpeg -framerate 60 -i <out>/before_%03d.png -framerate 60 -i <out>/after_%03d.png -filter_complex "[0][1]hstack=shortest=1,split=3[a][b][c];[c]setpts=4*PTS[s];[a][b][s]concat=n=3:v=1[v]" -map "[v]" -r 60 -pix_fmt yuv420p film.mp4
```
The ruler takes about 3 minutes a pair (43,200 pictures); a film run 15 s.

## Commits (main, not pushed)
- 9f21983 step 0: the ruler, RED on the shipped tree
- 85c4b17 steps 1-2: the rule, the bake, clip_db's six rows, tests/body_react_test.gd, run_tests.sh
- a13614d step 3: the film tool
- this document
