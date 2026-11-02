# S238 digest (2026-10-17) - LOOP1 approved; slices 1-3 live on the floor; five T-posing workout clips fixed

## Operator rulings this session (verbatim)
- Q-S237-1 (board): "build it, the equipment wear is not what matters on this , the loop , animations,workout,feeling of progrsession
  and improvement from training these are what matters for now" -> LOOP1_VERDICT_S238.md approved; equipment wear OFF.
- "everythimgyou makein ludo i want it stored there" + "you cannot use the vault for more than 7 files, why i can see the generation
  fromother projects but not for fightcamp ?" -> CLI/API jobs never show in Ludo's web galleries; generate in the WEB app inside the
  FightCamp project (memory feedback_store_ludo_assets_in_project).
- "ignore the story run only the necessary tests" (memory feedback_only_necessary_tests_no_story). "its too early to handover ?" -> kept on.

## What now works (evidence on master 75a92ff6)
- LOOP1 slice 1 - GAINS / ATTRITION meters + CHANGE THE PLAN (switch training_meters): TrainingMeters (Arena, mutant-proven),
  TrainingMetersHud (Cursor), wiring + Ludo r103 review applied (TODAY: FRESH, one stack, pts vs RATE, amber SWAP TO RECOVERY,
  overdone work clip 0.75x, one-line intro). A red week halves what training pays (design values; J63: no published number).
- Slice 2 start - the coach WALKS to the fighter (Grok COACHWALK1) and is VISIBLE (he was hidden all day by the S223 office rule)
  in his own idle (he froze mid-stride). PACE1 (Grok, Ludo r104): a station switch costs 5 game minutes (a 4-switch day lost 398 of
  600 minutes to walking, now 20), the coach walk is free.
- Slice 3 - the goal with a deadline (switch fighter_goal): FighterGoal (Arena GOAL1), GoalCard (Cursor) top centre, compact, bars
  drawn right (bind-order bug fixed), a 0-0-0 walk-in gets "debut inside a month".
- LOOPOFF1 (Grok): story, the tutorial card, decision cards, floor events, cuts, corner rehearsal, open spar night, equipment wear,
  street view OFF in the game; nothing deleted.
- T-POSE DEFECT FIXED: 5 of 9 station work clips (pads, treadmill, rack, platform, weights) froze a MetaHuman fighter in a T-pose
  since S234 - Mixamo "with skin" FBX list an empty "Take 001" first; FightClipRetarget._anim_of now takes the first take with
  tracks; re-baked. tests/work_clips_no_tpose_test.gd 0 T-poses on all 9 (5 on master). A day that STARTS at a station works it.
- Collected: SPARWIRE1, PACING1 (hash-pick fix, unwired), ROOMS3CD3 (last rooms round), CURSOR201_R4, New career gym-step fixes.
- Defects fixed beside the loop: load ledger slot clamp (career_day % 7), FLOOR USED one true number, meters/goal hidden in rooms.
- Stills on 8787/review: s238_meters_r103, s238_coach, s238_loop, s238_gymstep, s238_rooms.

## Ludo / research this session
- r102 LOOP1 spec, r103 meters review, r104 pacing (research/ludo_rx/). John J63 plan-change signs (J63_PLAN_CHANGE_REPLY.md).
- Ludo web (FightCamp project): mh_staff_coach rigged + 12 coach takes stored; NONE usable (T-pose arm swings) - not wired.

## Open / next (in order)
1. Coach pad work = a PAIRED clip (coach holds, fighter hits, in sync) - the coach idles beside him now; source it (Cascadeur before
   10-27 / Ludo web Rig & Animate in FightCamp / mocap) and judge on the game camera with the operator.
2. Slice 4: opponent + booking + film study + the fight close the loop (the goal's booked_fight target; jab pair PAIRLIVE1 gate).
3. Goal outcome at the deadline (FighterGoal.outcome -> trust/morale, next goal) is not wired yet.
4. Boxers and the coach are barefoot in shorts (WARDROBE1 parked under LOOP1 - his call to unpark).
5. staff_pose_test red (48 seated-palm lines) - pre-existing, identical with master's retarget.
