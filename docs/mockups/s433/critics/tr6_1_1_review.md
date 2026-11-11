# Training map v6: blind critic review (tr6_1_1)

Critic: a lead systems designer of player-development and training mechanics in a long-running sports management game. Fresh and blind: I read
CRITIC_PACK, CRITIC_ACCESS, TRAINING_MAP_S432.md (whole), the drawing training_v2.png, the real Week tab (23e_training_tab_real.png) and the code
named below. I did not read any other critic's file.

## Score: depth 6.5 / 10

One line: a well-linked, honestly traced training system whose main choice moves numbers too small to feel, with every outcome printed in
advance, so the player never discovers anything about how a fighter develops.

## The code claims I checked (all hold)
- F1: `Attrs.train` (Attrs.gd ~329-334) does take the rest morning's Recovery points back off Stamina ("The same points come off stamina").
- F2a: `Recruit.ceiling` is one `pot` +/- 6 for the class bias, old stats only; `Sim.week_ctx` passes one `pot` (Sim.gd 120).
- F3: `LiveRound.gd` 65 and `BoutRules.play_round` take OWN_FADE 1.0 when the old conditioning is under 64, a cliff; `Combos.spend_factor` and
  `refill` both read the conditioning mean.
- F5: `BoutRules.stale_energy` is 0 under 50 tiredness and 0 with no camp.
- F8: `WeekPlan.INTENSITY` hard gain is 1.3.
- F9: `BoutRules.PROTOCOLS` Light / Standard / Hard all cost $0 with edges +0.25 / +0.6 / +1.0 into `night_edge`; `Roster.turn_pro` never clears
  `day_job` and `GymSpend.DAY_JOB_GAIN` 0.85 still applies.
- F10: `Exchanges.grade` is a step (Poor / OK / Good).
- Small stale fact: the map says LiveRound.gd is 494 lines; after commit 6ee496fc it is 456. That does not matter.
- Camp partner $160 = `PARTNER_FEE` 40 x 4 visits. Matches.
Every defect the map names is in section 0 as a foundation task, so I count those as handled.

## What is deep (credit)
- One load choice (Easy / Normal / Hard on an aim / Sharpen) is priced in five places at once: injury, tiredness, the energy at the first bell,
  the goal and the block to the target. That is a real linked decision, not a slider.
- Each ability has its own ceiling, and ceilings move only after named events (a step-up win, PEAK CAMP, a strong coach's season). That gives
  a career arc instead of filling a bar.
- Abilities fade without their dose, and nothing fades in a fight week or a deload. That turns "what to keep" into a weekly trade.
- Niggles come from your own load, and both answers are priced in the other panels. The stand-down after a bout stops "spar every week".
- The opponent sorts the board, so the same fighter trains differently for a counter-puncher than for a pressure fighter.
- The professional's camp becomes the load blocks. The free "Hard camp +1.0" goes, and Q-186 is folded in: full time once pro.
- Section 8 has a menu-by-menu wiring table, and section 11 step 6 walks the whole thing in one golden path. This meets the owner's "wired and
  shown" bar on paper.

## Why it is not 7 yet
1. THE MAIN CHOICE IS TOO SMALL TO FEEL. The map's own worked numbers: Hard kept against Normal kept ends at Stamina 63.5 against 63.2 by the
   regional. That is 0.3 of a point after seven weeks. At the fade slope (0.25 a point) that is under 0.1 power in round 3 only. Rows show
   whole points, so the player sees 63 and 63. In the fight week the four loads leave energy 94 to 97 at the bell, a gap of 1 to 3 in 100.
   The thing that makes Hard "win" in the drawing is the goal's mood cliff at 63.0 (met +10, missed -20). That is the one cliff the map does
   not smooth, and the drawing's whole story stands on it. Part of the cause is the example: Hard is aimed at Samira's SLOWEST row (Stamina,
   room 0.18) while Footwork (room 0.6, three times the gain) sits beside it. The tab never shows where Hard pays most.
2. NOTHING TO DISCOVER. T24 "one run, every price" prints the exact result of every option before the player picks. In the long-running
   development games that last (scouted potential, a youngster who suddenly "gets it"), the hook is uncertainty that narrows as you learn the
   player. Here every fighter responds the same way to the same week. Coachability only changes habit steps. The map rejects a hidden load
   tolerance and leaves discipline scaling for later. The Week review can only confirm the forecast; it can never surprise.
3. AGE DOES NOT CHANGE GROWTH. An 18-year-old and a 30-year-old gain the same from the same morning. Ceilings falling at 31+ are LEFT FOR
   LATER. The pack's own pro road already has ageing, peaks and retirement, so the training is the one place that ignores age.
4. THE PERSON BARELY TOUCHES THE GAIN. Discipline only skips alone mornings (under 45). Mood only scales sessions without a coach. Ambition does
   nothing (pack 4.11). Fighters develop differently mainly through ceilings, not character.
5. MOST OF IT IS ESTIMATE. Hard's 1.6, the block dose of 1.3, the freshness slope, the fade slope, the call climb and every fade window are all
   probe-set. The season gate (SEASON1: 4+ wins in 100 for a careful player) has not run, and if it fails, the tab is cut back to three panels.
   The depth is designed, not shown.
6. ANA IS A FRAME. Q-188 says "This version" for Ana's mat plan, but this map hands it to another map and critic. Ana's six stats get doses
   and ceilings only on one table row (8b). The grappler's training is not designed to the same depth as the boxers'.
7. READABILITY. The drawing uses insider words: "work 102 · usual 92 · safe to 120", "Tank 95", "Hands up 57-66, Flex 55", "Lucy x1.2". The
   owner's rule is game words. A dense tab where every number needs a hover is wide, not deep.

## To reach 10/10 (most important first)
1. MAKE THE LOAD FELT. Set PACE1's target as a pass line, not a hope: Hard kept on a FAST row must reach at least +2 whole points more than
   Normal kept by the next target, and at least +1 on a SLOW row. If it cannot, cut the load to three options. In the Hard popover, add a
   "Where Hard pays most" list: each top row's whole-point gain by the target and the line it reaches (Footwork +3: Jab and move Good;
   Stamina +1: the goal). The aim becomes a real pick between the goal and what the opponent tests.
2. HOW EACH FIGHTER RESPONDS (discovery). Give each fighter a hidden training response per group (Legs, Cardio, Guard, Hands, Head): slow
   x0.8, normal x1.0 or quick x1.3. The scout gives a guess. After 3 dosed weeks in a group, the Week review names it ("Legs: quick learner").
   Until then every forecast prints as a range ("Footwork 62-64") that narrows as the group becomes known. A coach rated 70+ in that area
   halves the weeks needed. Plug it into the existing Known (C12) so no second meter is added.
3. AN AGE CURVE ON THE GAIN THIS VERSION: x1.2 under 23, x1.0 from 23 to 28, x0.8 from 29 to 31, x0.5 from 32 (shown as one chip on the
   header). Ceilings losing 1 a year from 31 can stay for later, but the growth curve should land now, because the pro world already ages
   boxers.
4. CHARACTER IN THE GAIN: discipline scales every session x0.9 to x1.1 and sets skipped mornings. An ambitious fighter gains x1.1 in the week
   after a goal is set. Show both as a header chip.
5. SMOOTH THE GOAL, THE LAST CLIFF: met (+10 mood), close within 0.5 (+3), short within 1 (-5), missed (-20). The drawing's decision should
   then stand on points and lines, not on a 0.1 decimal.
6. SOME WEEKLY SURPRISE WITH A REASON: each ability's weekly gain rolls inside plus or minus 25% of the forecast, and the review names the cause
   ("it clicked", "bad sleep Tue", "sore after sparring"). The one-run price stays the expected value with its band. The Week review stops
   being a receipt.
7. RUN THE GATE BEFORE THE BRIEF: PACE1, DOSE1, FITLEGS1 and SEASON1 report before Cursor draws the tab. Then write their numbers into section
   1's table, and cut any panel whose choice falls under the 1.5-in-100 or season-effect rule.
8. ANA TO THE SAME DEPTH THIS VERSION: the mat plan map (Q-188) lands with Ana's six abilities, each with its dose, ceiling and response group.
   The class kinds should feed specific mat-plan lines, the way a pad place feeds a boxer's line. Draw it as the second still.
9. PLAIN WORDS ON THE TAB: "74% of a usual week" not "work 59 · usual 92"; "energy at the first bell 95" not "Tank 95"; "Hands up helps from
   56" not "Hands up 57-66, Flex 55"; keep at most three numbers on a load card at first reveal, and put the rest on hover.
10. A SEASON PLAN, ONE CLICK: pick two groups to build this season (for example Legs, then Guard). Coach lays the Hard blocks on them, so the
    aim is a season choice you revisit, not a weekly chore over 14 rows.

## Complete?
No. The training design is wired and traced well, and its defects are queued as foundations. But by its own drawn numbers the central choice
moves less than one shown point. No fighter responds differently enough to be discovered. Ana's half of "this version" is a frame. It reaches 7
once item 1 passes PACE1 and items 2 and 3 are in. Items 4 to 10 take it to 10.

## My 10/10 drawing
`docs/mockups/s433/critics/tr6_1_1_10.html` and `.png`: the Training tab with each load priced in whole points by the regional as ranges, a
"Where Hard pays most" pick, "How Samira responds" (quick, slow, not known yet), last week against the forecast with its cause, the age and
discipline chips, the graded goal, the career curve and a season plan.
