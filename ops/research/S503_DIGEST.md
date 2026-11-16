# S503 digest (2026-11-16) - fight motion week day 8: feet that step, waiting with a plan

## Operator this session
- Board Q-264 (guard damage): "Yes, design it". v2 waits on John's SQ204 + Dola's 6/7 notes, then two fresh critics.
- C424 (walk shoulders): "better". Kept.
- New idea, with a picture of an official promotion scorecard: "add similar score cards at the end of the fight , what do
  you think ?" Answer: yes - a Scorecard tab on the result page in our own look (header: date, venue, weight class,
  referee; three judge sheets red | blue with round score, deduction, totals, judge name and lean; the result line),
  hover a round for that judge's reason. Point deductions only once fouls exist; amateur sheet for amateur bouts.
  Order: the judges must decide the result first (JudgeNight.DECIDES false since S443 - rerun the S444 agreement probe,
  then switch), then a 1920x1080 mockup for his yes, then build. Data module done today (SCORESHEET1).
- "kill discord and restart it": done (6 processes stopped, relaunched through its Update.exe).

## Built (commits on main)
1. 73ce6e46c FILMBAR2 collected (Qwen PR 335 + Claude's fixes). Qwen's round 2 hit a real conflict (z-gates vs exact
   gates). Decided: the after-a-moment PASS needs the z bar AND the exact Fisher tail p <= 0.03; a claim about ONE round
   (round1, last_min) can only say "maybe" from one film - rounds come in won/lost clumps in the film builder, so one lost
   round 1 read as "out-landed in round 1"; two films pooled can pass; a hook/cross she throws within 0.7 s of her own
   punch is a COMBINATION, not a wild swing (the one-two, two-three, double hook were firing "jab -> wild swing").
   FILM_COUNT failures=0, noise avg 0.0105, worst 0.067 (was 0.265); admires_her_work one film 0.443.
2. 92e253e1b FEET. The r9 "planted slide" (10.64 / 11.74 m a round) was not FootPlant and not a pivot: 70 % of it was
   the footwork rig's own steps - the quickest pair 0.27 s made each foot a 4-frame flick at 4.5 m/s lifting 2 cm, and
   the sin arc is low at both ends while the foot already travelled. BoxerFootwork: the foot travels only inside 15-85 %
   of its swing, every step clears >= 1.95 cm, the body's turn over a pair follows the feet's own travel (on the pair's
   clock the hips turned before the feet moved: ring_feet_test read the feet crossing, 0.08 m). RingFeet: quickest pair
   0.36 s (each foot ~0.19 s in the air; real 0.17-0.25). Film seed 7, 75 s: slide 0.40 / 0.25 m, knee shake L
   3.30 -> 3.03 deg, R jerks > 8 deg 126 -> 90. Tried and dropped: sqrt(sin) or plateau lift (knee jerks x3), CLEAR 0.25
   (worse knees), no minimum lift (slide back to 7-8 m: 1 cm skims ARE what reads as sliding). knee_calm_test bar
   0.75 -> 0.77 (its own rig reads x0.75 with the clearance; reason + film numbers in the test). `-- oldswing`.
   file_limits: GamePlan.gd / MatTree.gd back to 500 lines.
3. 96196cc48 WAITING. GuardLife wait beats: a PAW (pro_left_jab_b to its contact frame, ~20 cm) and a FEINT (its first
   0.12 s at x1.2) on their own clocks (1.5-3 s / 2-4 s) while she stands in guard or a fidget - also while her place
   moves; STYLE_EVERY scales them per style (counter-puncher feints more, pressure / volume / out-boxer paw more;
   FightStage keeps the fighter's style on the boxer). ~40 beats a round each; longest wait 5.83 / 5.7 -> 2.93 / 2.27 s;
   waiting 72 / 69 -> 62 / 60 %; feet held. `-- nowaitbeats`. The hips-relative hand path from shown.csv is too noisy
   to judge the paw's shape - judge it on the sheets.
4. c150bf477 SCORESHEET1 collected (Qwen PR 336): ScoreSheet.build(judges, meta) -> header, three judge sheets, result
   line. Collect fixes: the verdict named the player's boxer red even from the blue corner (Qwen's test held the bug);
   the name test typed Strings as Array (a script error the runner reported as failures=0).
5. Briefs: TASK_SCORESHEET1, TASK_PUNCHEND1 (Qwen, running: a ruler for where each punch ends + frames to come home).

## Blind round r10 (E:/FightCamp/tmp/fightweek/r10blind)
Filmed after 1-3 (seed 7, 75 s, the game's camera, 1920x1080), sheets at the r9 times, rulers_raw / rulers_motion,
r9 briefs with the folder renamed, two NEW critics.
- Coach 5 (r9 4.5): punches 5.5, defence/reactions 4, feet 5.5 (r9 4: "feet that don't skate"), blending 5, waiting 4.5.
  Top: hit reactions on the contact frame + 2-3 frames, sized by punch (median peak 5 frames late, many 4-8 cm); hands
  home fast (arm out median 6, worst 15) and the free hand at the chin; no glove-pressing stand-offs inside 1.0 m; runs
  of 2-4 punches with a pivot / step off the line; a body shot folds 15-25 deg and turns away. Also a floating crowd
  flash at rope height (fixed the same session, 7123bd874: flashes only above both heads, true screen size).
- Animator 4.5 (r9 5): punches 5, defence/reactions 4, feet 4.5, blending 4, waiting 5. Top: the same reaction rule
  (layered over whatever the hit man does - his own punch cut 3), punches land on the face 1-2 frames / blocked ones
  push the guard 5-8 cm, hands home within 4 frames, head/hip jumps inside clips capped at 8 cm a frame (31 of 37),
  slips / rolls / pull-backs that move the head.
- Files: critic_*.md and *_10.png in r10blind; the two 10/10 pictures on the review board (S503).

## Debt
block_absorb, hit_carry, join_return, punch_speed, punch_weight red on main since S496-S501 (unchanged today).

## Next
Hit reactions first (both r10 critics), then punches on the face + hands home in 4 frames (PUNCHEND1 measures it),
head jumps inside clips, stand-offs inside 1.0 m, defence that moves the head.
Scorecard: judges decide -> mockup -> his yes -> build.
