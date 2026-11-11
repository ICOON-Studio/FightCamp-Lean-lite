# Training depth: a strength and conditioning coach's review (S432, blind)

Reviewer: a strength and conditioning coach who prepares amateur and professional boxers for bouts. Fresh and blind: no earlier score read.
Scored: the training map `ops/research/TRAINING_MAP_S432.md` and its drawing `docs/mockups/s432/training_v2.png`, laid over the training as built
(WeekPlan, TrainingPreview, TrainingLoad, InjuryRoll, PadWeek, MoveMastery, HabitFix, Attrs, BoutRules.NIGHT_LINES, PeakCamp, SkillAwards, NoGi,
the real tab `trainingb2_23e_real.png`), with CLUBWEEK v4.1 and the RPG layer v3 as the shared layer it sits in.

## Score: 6 / 10
In one line: the right parts and honest sport science, but the body side of training is still a pile of decimals that only ever goes up. A
Hard week has a cost and no fitness payoff, nothing fades when you stop training it, and what a point changes in the ring stays hidden. So the
week is an allocation, not a plan.

(As built today, with no map: 5. The map as written: 6. With the list below: 9 to 10.)

## What is good
- The sport science is real and the numbers come from real sources: kcal from METs, session load as effort x minutes (Foster), tiredness kept
  at 87% a night (the Banister fatigue curve), this week's load against the usual load over 42 days with the 1.3 and 1.5 lines (Gabbett), a
  training injury about 1.3 in 100 a normal week. Most games invent all of that. This one does not.
- The coach writes the week from the phase (Base, Build, Peak, Taper) and the player changes exceptions. That is how a real gym runs.
- T1 (one load a week, priced on the button) is the right cut. Twenty-eight Light/Normal/Hard picks were busywork. "Hard: tired 74, injury 3
  in 100" is the sentence a coach actually thinks.
- T5 (habits as training work) is the best new piece. A fault drilled out over weeks, half fixed, then slipping back when the boxer is tired:
  that is exactly what happens on the pads. It ties the week to the fight (HabitFix), to the opponent (PUNISHED_BY) and to the Why.
- T4 (the sparring setting decides WHAT is trained and what is found) turns sparring from a volume knob into a choice.
- T6 (film with no bout = your own tape) removes a dead option and gives it a real job.
- T9 (the season strip with deloads you place and the Legs printed on each bout day) is the start of real periodisation.
- T10 (switching on the firing rule) finally gives pad time past Usable a reason. The R55 measurement (a plan answer in hand at the bell is
  worth up to 14 in 100) is the biggest training lever in the game, and the pad places are where it lives.
- The cut rule (under 1.5 in 100 and no season effect = cut) and a named test for every rule is rare discipline. The map says plainly where it
  is guessing.
- Ana gets real choices (drill, positional, hard rolls), close to how an academy runs its week.

## Where it falls short (an S&C view)
1. FITNESS IS ONLY A COST. In the real fitness-fatigue model, hard training builds fitness and fatigue together; a taper clears the fatigue and
   shows the fitness. The game has both numbers (the usual load over 42 days, and the tiredness), but the Legs bar reads tiredness only. A Hard
   week therefore costs Legs and injury risk, and pays x1.3 on a decimal. LOADDIAL1 will almost certainly come back flat, and the map already
   says what happens then: the load goes back to the coach. The deload (T9) has the same problem: it can only give back what you spent. The map
   rejects a deload bonus as invented. It would not be invented: it is the fitness side of the same Banister model the code already cites.
2. NOTHING FADES. Abilities only go up. No detraining, and no "this quality keeps 30 days, that one 7". Without it there is no ORDER to a camp:
   build the engine and strength early, sharpen speed and explosiveness last. That sequencing is the heart of real periodisation, and here it
   does not matter when you train what. Every week is the same allocation problem (train what is worth most per point: Defence 0.090, Footwork
   0.085), so the week has a solved answer.
3. A POINT IS NOT FELT, A LINE IS. The fight already has lines: Cardio 64 = no round-3 fade, Power over 60 = the body call goes strong, Technique
   over 61 = "Jab and move" works (BoutRules.NIGHT_LINES), plus the eight perk lines. T2 prints whole points with their day ("Defence 52 Wed"),
   which helps, but "52" still means nothing in the ring. Defence, Speed and Footwork have no line at all, so their points are never felt.
4. THE OPPONENT DOES NOT SHAPE THE WEEK (except through habits). Real camps are built against the opponent: a counter-puncher asks for footwork
   and feints, a pressure fighter asks for the engine and the inside. The fight engine already weighs abilities by the opponent's game; the
   Training tab never says so.
5. INJURY IS A HIDDEN DICE ROLL. The player sees "3 in 100" and then, one Monday, a hand injury. Real coaches see a niggle first: a sore hand
   after three bag days, a tight hamstring after a spike. The twist deck has "sore wrist" and "tight knee", but drawn at random, not from the
   player's own load. The load decision never produces a warning the player can answer.
6. THE PERSON IS ANOTHER DECIMAL. Coachability x0.91 to x1.09 and alone x0.8 / 0.6 / 0.4 are true, but nobody will feel x0.96. Discipline
   skipping a session (CLUBWEEK) is the one that bites: a missing morning on the board.
7. WEIGHT STOPS A DAY TOO EARLY on the Training tab. Hold / Lean / Cut is good. But how much is left to the last 24 hours (a small water cut,
   and what it costs the Legs) is the real call before a weigh-in. CLUBWEEK has eat less / train it off for the day; the Training tab should
   show where the diet leaves that day.
8. TOO MANY PROBES HOLD THE MAP UP. Twelve probes, each able to cut a rule. If LOADDIAL1, DELOAD1, COACHABLE1 and LEANCUT1 all come back under
   1.5 in 100 (likely, for the reason in point 1), the map shrinks back to habits, sparring settings and the strip. Points 1 and 2 are what keep
   those rules alive.

## Missing options
- A fitness side to the load: Hard builds fitness that a deload or taper turns into Legs on the night.
- Ability fade with different holding times (engine and strength hold about 30 days; speed and explosiveness about a week).
- Each ability's next fight line on the Training tab, and new lines for Defence, Speed and Footwork.
- "What this opponent tests": each ability's worth against the booked opponent's game, printed beside the sessions.
- A niggle warning that comes from the player's own load, with a choice (rest that session for a week, or push on at a stated risk).
- The day before the weigh-in on the weight panel: what Lean or Cut leaves to the last 24 hours, and its Legs price.
- A camp shape for a professional's longer bout (4 to 10 rounds): the fade line moves with the rounds, so the engine counts for more.

## Useless or weak options
- Per-morning Light / Normal / Hard as anything more than a rare exception (the map already demotes it).
- Mobility as its own morning (the map folds it into Rest: right).
- The 70/30 and 30/70 pad splits (the map cuts them: right).
- Film with no bout as it is today (the map fixes it with T6).
- Coachability as a multiplier only: keep it as a threshold that decides whether the corner's fix and a pad correction "take", not as x0.96.
- The deload as priced today (tiredness drains, nothing built): a decoy until fitness counts.

## To reach 10/10 (most important first, each buildable)
1. MAKE THE LEGS BAR FITNESS MINUS TIREDNESS. Legs at the bell = a fitness term from the usual load (TrainingLoad's 42-day average, already in
   the code) minus today's tiredness (WeekPlan, already in the code). Hard weeks raise fitness slowly and tiredness fast; a deload or taper clears
   tiredness in about a week and keeps fitness (the code's own 87% a night and 42-day numbers). Print both on the season strip with the Legs on
   each bout day. Then the load dial and the deload have a real payoff, and LOADDIAL1 / DELOAD1 have something to find. Probe: a "Hard, Hard,
   deload, bout" plan must beat "Normal throughout" by 1.5+ in 100 on that bout, and "Hard to the bell" must lose.
2. ABILITIES FADE WHEN NOT TRAINED, AT DIFFERENT SPEEDS. Gains above a fighter's kept level slip back after a holding time with no session on
   that ability: Cardio and Strength about 30 days, Durability and Defence about 21, Speed, Explosiveness and Timing about 7. Real basis:
   residual training effects (Issurin's block periodisation). Show it on the Training tab as "keeps 30 days" / "fades in 6 days". This gives a
   camp an order (engine and strength first, speed last) and ends the solved week.
3. THE NEXT LINE, PER ABILITY, ON THE TRAINING TAB. Show each ability's next line from BoutRules.NIGHT_LINES and PerkRoad (Cardio 64: no
   round-3 fade; Technique 61: jab and move; Speed 70: Fast hands), with the day it is crossed. Add one fight line each for Defence, Speed and
   Footwork in the fight model (for example Defence 55: the corner's "Hands up" goes strong; Footwork 60: escapes the ropes once a round), each
   measured at 1.5+ in 100 on the bouts where it applies.
4. WHAT THIS OPPONENT TESTS. With a bout booked, print each ability's worth against the booked opponent's game (from the fight engine's own
   weighting by mode), and let Coach's week lean toward it. "Kayleigh Bell, a counter-puncher: Footwork and Defence worth x1.4, Cardio x0.8".
5. NIGGLES FROM THE LOAD. When a body part's sessions spike (three bag days running, a load ratio past 1.3), a niggle card appears before any
   injury roll: rest that session for a week (risk back to normal) or push on (risk x3 to x4 for that part). Same InjuryRoll numbers, now
   visible and answerable. The twist deck's sore wrist and tight knee come from here, not from the random draw.
6. COACHABILITY AS A LINE, NOT A MULTIPLIER. Under 40, a habit needs one more pad place to go Half fixed and a corner fix holds half; over 70,
   one fewer. One sentence on the card instead of x0.96.
7. THE DAY BEFORE THE WEIGH-IN ON THE WEIGHT PANEL. Show where the diet leaves the last 24 hours: "Lean lands 65.3: 0.3 kg water the day
   before, Legs -2"; over about 2% of body weight left to the last day = Legs -8 and a red line. Uses CLUBWEEK's eat less / train it off prices.
8. A CAMP SHAPE FOR THE PROFESSIONAL. The fade line moves with the rounds (3 amateur, 4 debut, 6 ranked): the engine's line rises with the
   rounds, so the professional's camp leans to Cardio. Print it on the camp card.
9. ONE SEASON TEST, NOT TWELVE. Keep TRAINSEASON1 as the gate (a careful player against "Coach runs it" for all four: 4+ in 100 on the season's
   bouts), and run points 1 and 2 before the smaller probes, because the smaller ones depend on them.
10. THE TAB AS DRAWN BY THE MAP (T13), plus: the niggle and "the next line" on the screen, the season strip showing fitness and tiredness as two
   lines, and every cell with its word and who coaches. Drawing: `docs/mockups/s432/critics/tr2_sandc_10.png`.

## Complete?
Yes, with the list applied, for this version (four fighters, amateur to a first professional fight). A season would then have a shape a coach
recognises: build the engine and strength, sharpen late, deload into the bout, drill the fault the next opponent punishes, read a niggle before it
becomes an injury, and make weight without killing the legs. Nothing more is needed for this version: altitude, sleep, nutrition plans and moving
up a class can wait. Without points 1 and 2, the map is likely to lose its load and deload rules to its own probes and fall back to about 5.

## My 10/10 drawing
`docs/mockups/s432/critics/tr2_sandc_10.html` -> `tr2_sandc_10.png` (1920x1080): the season strip with fitness and tiredness and the Legs on each
bout day; the load priced in fitness, Legs and injury; a niggle with two answers; the week with words and who coaches; "the next line" per
ability with how long it keeps; what the opponent tests; weight with the day before; the habit; what this week buys.
