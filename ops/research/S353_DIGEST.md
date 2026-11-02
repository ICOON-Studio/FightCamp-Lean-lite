# S353 DIGEST (2026-11-02) - update 54: the muscle holo, BJJ beside boxing, the gym Training week (mockup)

Lean commits: 59ada8e (holo), 47e2316, 66237c8 (Ziva TRAINCLIPS1 r5), training still, a788ecf (BeltRoad), wrap-up.
Game: HOLO_MODEL_BUY_S353.md, this digest, roadmap, previews/s353.

## Operator input this session (verbatim)
- Board answers: Q-S294-74 "this is ok for a training overview screen , but how do you set the training up for the week ,
  where do you teach the moves ? use the planner as the main player mechanism to train ?"; Q-S294-75 "Yes, build it".
- On the S352 corner-card figure (red/white/blue kit, circles): "wtf is this , it loooks so bad, stop doing tubes and shit",
  "use a real muscular holo"; "buy it", "paidit"; "holo looks fine".
- "we will ship bjj with boxing since we have all clips and moves , use this to add more options to the menus for training
  etc, see how the game will look in the biggerplan . a simple road to black belt in bjj for start"
- "we only use no gi on the game , do you agree?" (Claude: yes - bodies cannot wear a gi, the clips are no-gi).
- "should the holo do the animation that the fighter does in the fight showcasing which muscles are getting tired etc ?"
  (Claude: yes as step 2 - she stands in guard and replays the move that tired a muscle once; needs the ecorche rigged.)
- "so probably it is a good idea to have a gym training overview screen so i can see all fighters training from mon-sun
  training program i set on mornings for,power,condition,footwork etc , then a sumarry of the moves they train on the
  evening and the progress like half-filled bar in the move box"

## What now works (evidence)
1. THE MUSCLE HOLO (Lean 59ada8e). Bought CGTrader #6489289 "Ecorche Musclenames Male Female Anatomy" (royalty-free,
   order #18085604, $8.32 with VAT; raw files OUTSIDE the repos in E:/FightCamp/licensed/ecorche_aaaxis). The female
   figure rendered front-on in Blender 5.2 headless (tools/holo_render_blender.py: facing ramp + AO, see-through inside,
   back faces culled), baked by tools/bake_holo_figure.py (places, track strokes, part mask). BodyHolo.portrait gives every
   boxer the holo + her headshot for the HEAD close-up; BodyFigure: dark scanner plate, no circles; body_skin.gdshader holo
   mode: Burn colours and hurt spots glow on the muscles. Real stills (opened): docs/playtest/S353/fight/p06d_hover_callout
   (both fight panels, her face in HEAD, tooltip live), p05_corner_card, training/t1_training_week, callouts.png (tired
   shoulder orange, legs green, hurt liver red). Suite 89/89 PASS.
   Dropped first: a holo made from her MetaHuman (no skin under the vest, the shorts a smooth shell, no muscle detail).
2. TRAINCLIPS1 r5 COLLECTED (Ziva, 66237c8): 112 ink exercise cards (14 boxers x 8 sessions), drawn in 3D; opened Lucy's
   eight (guard, chin tuck, jab + arrow, cross into the bag, speed bag, hook on the mitt, slip under the rope, stride) -
   readable. The training board shows them (its existing PICS hook) beside the holo. session_pics_test failures=0.
3. BeltRoad (a788ecf): the IBJJF floor read from the IBJJF PDFs (graduation June 2026: ages blue 16, purple 16, brown 18,
   black 19 / 18 for a brown-belt adult world champion; 2 / 1.5 / 1 years at blue / purple / brown, none for a world
   champion at that belt. Rule Book v6.0: 5/6/7/8/10 min; mount/back 4, pass 3, takedown/sweep/knee-on-belly 2) + the
   professor's call above it (mat time, the belt's no-gi syllabus from his checklist, stripes per quarter, early promotion
   owes a quarter of the next belt's mat time). belt_road_test 26 PASS, 3 mutants caught.
4. Mockups for his OK (Q-S294-77, board review page): Gym > Training week (rows = fighters incl. BJJ, Mon-Sun, AM body
   session chip, PM move with a progress bar + the weapon tick at mastery 30, day-type strip, red on two hard days, a
   THIS WEEK column, an evenings board of move cards) and a BJJ fighter's Belt road tab (belts + stripes with the IBJJF
   minimums, to-blue syllabus with bars, coach's call: stripe / promote, next no-gi opens, the rules, the holo).

## SMOOTH3 r3 (Goose, goose/issue-18 28fe5c7)
Round 3 only rate-limits GloveClear's push (2.5 m/s); the per-layer ablation the brief asked for was not posted. Measured on
the GPU in wt/SMOOTH3_LEAN (--fixed-fps 30, 150 s): smooth_probe OURS 309/min (115 at a clip change) vs main 305/min
(122) - no gain (by clip: pro_idle 74, pro_left_hook 73, pro_body_shot 57); hit_gap_probe 25 landed, > 0.15 m: 0 (main 1),
max 0.133 m. REJECTED as a smoothness fix (harmless to the hits). Three red rounds -> Claude's code audit before any round 4
(CLAUDE.md "audit before more fix rounds").

## Decided (Claude, the developer)
- One holo picture for every boxer (the roster is women's lightweights); her identity rides in the HEAD close-up. The holo
  stands still (no turn strip) until it is rigged.
- No-gi only: the syllabus swaps gi guards / collar chokes for no-gi ones (k-guard, leg locks at purple/brown).
- BJJ mat time to ready = typical pace at a competitor's ~4 classes a week (200 a year): 200 / 450 / 350 / 300.

## Next
1. On Q-S294-77: WeekPlan (TRAINPLAN2 step 1, pure module: 7 days x AM body session + PM move/live/rest, day types, red on
   two hard days, the days -> TrainingPlan blocks, PM nights -> MoveMastery) then the Gym > Training week screen.
2. BJJ fighter data (belt, stripes, belt_day, mat_classes) + the Belt road tab; BJJ sessions for the AM/PM slots.
3. CLINCH2 -> Ziva (TRAINCLIPS1 landed). 4. The holo replays a tiring move (rig the ecorche to the MetaHuman skeleton).
5. PLAYBOOKTREE1 / MENUS_SCALE mockups; Miro map + loop board re-upload (not done S352/S353).
