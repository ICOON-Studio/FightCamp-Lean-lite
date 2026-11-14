# PLANFLOW1 v2 - facts from the code and the designer's rulings on the v1 critics (Claude, S471)

Three critics scored v1: Dola 7 / 8 / 6, Maria 7 / 6 / 6, John 6 / 5 / 7 (depth / general design / play). John's 5 misses
the owner's bar (6+ depth and 6+ general design). v2 answers every point of all three lists and folds in the owner's four
pictures (PLANFLOW1_OWNER_PICTURE_S470.md). Where critics disagree with each other or with the code, this page decides.

## Facts the critics could not see (the pack was stale; it is corrected now)
1. Step and defence answers are NOT free any more. `StepMastery` (S463): 10 bars (step in, step out, step back, pivot out,
   cut off, herd, feint, tie up, roll out, push off), given at signing from Footwork. A step fires by its bar like a punch;
   under Usable (30) the coach never plans it. How a step is trained today (S463, greybox): the fighter page's WHAT TO LEARN
   NEXT card puts ONE step or defence in the study slot; the week's pad nights raise it about 6 a week (step back 0 to 32
   in about 5 weeks); at Usable 30 it leaves the slot. What is missing: nothing takes a step past 30 (to Sharp 60),
   sparring gives a step nothing, and only one can be learned at a time. Measured today: a "well-read" plan built on
   step back / pivot out / tie up with low step bars is worth only +0.13 over no plan while the coach's plan is worth
   +0.09 (plan_bots_test is red for that reason). So v2 MUST price step answers with the study slot (weeks to Usable,
   one at a time), say how a step reaches Sharp, and keep a STEPS-ONLY bot in the probes that finishes under GOOD.
2. The opponent adjusting inside a round is BUILT (`PlanRead`): a planned line pays in full for its first 2 uses in a
   round, then less each use; it resets at the bell.
3. The other corner reading your plan across bouts is BUILT for professionals only (`ProRead`: last two professional
   fights, waits for the most-thrown punch; two real weapons or a feint line blunt it). Amateurs are not read across bouts.
4. Film is an evening on the Week (Rest / Pads / Sparring / Film): a film evening is a pad evening not taken. That trade is
   real. Whether a Film evening may be taken with a bout booked but no camp: tag it CHECK (Claude verifies before build).
5. Baseline numbers: use the pack's (good plan 59 %, no plan 45 %, bad plan 41 %, one matchup).

## Rulings (v2 follows these)
- IFs are the six modes the fight really has (pressing, boxing at range, waiting to counter, loading up, tiring, hurt).
  The real habits on the file (drops the right after the jab, slow starter, fades late, chases the stoppage) are found IFs
  or timing rules on top. The four invented modes (shells up, circles away, switches stance, bites on feints) leave v2
  unless they are costed as fight-engine work in a later stage.
- ONE Plan B: a return arrow "lost: back here" from every box to the opening box. No separate Plan B bar or decision.
- One word per idea: PRESSURE = your edge in a round; "seen" = their corner has read a line; bait = PRESSURE with a target.
- Every answer is a move, a combination or a step the game has. A new one is listed as NEW content with its own mastery.
- Slots: boxes and IFs share the coach's 4 to 6 lines in stage 1; later stages add the boxer's bouts and Fight IQ, cap 7.
- "Test it" costs a sparring night (which also drills the plan's moves). No count of free tries. No free Simulate button.
- The plan locks at the first bell, not at the weigh-in.
- Live fight: a small strip (about 300 px): the box in play, FIRED as a word, its count. The full chart is for the corner
  minute and the result page.
- No state shown by colour alone: BEST / OK / WRONG, "+2" / "-1", FIRED are printed as words.
- "Opponent is hurt" IF against the corner call "Go for the finish": the shout wins and spends its instruction.
- The hurt rule is one line in the file column in stage 1, not a stub on every box.
- Amateur reuse: until amateurs are read across bouts, an amateur opponent who has met your boxer before starts with the
  most-used line already "seen" (NEW, small).
- BJJ: the same chart over the existing BjjTree comes in stage 2, not stage 3; boxing is stage 1.
- Buttons to add: load the saved plan for this opponent (rematch), clear one box, copy a team-mate's plan for the same
  opponent or style.
- From the owner's pictures (verdicts in PLANFLOW1_OWNER_PICTURE_S470.md): VALIDATE PLAN before the bout; the opponent's
  habits drawn as HER OWN TREE filled in by scouting; ONE swap between rounds on the tree with the corner's read as the
  reason; a works / countered pair on a bait; ONE emergency box. Left out by his own earlier rules: percent stat buffs,
  bought moves, exact percents the player cannot know, names in feed lines.

## What v2 must contain
The decisions in order, every menu it appears on and what each is wired to, each element tagged CODE / NEW / CHECK
honestly, the probe set with pass lines (including STEPS-ONLY and the amateur reuse bot), stages 1-3, and the four owner
questions from v1 section 10 restated only if still open.
