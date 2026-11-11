# Training map v3 (TRAINING_MAP_S432) - blind critic review: player development lead (Football Manager-style)

Read: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (whole), CLUBWEEK_MAP_V41_S432.md (whole), the drawing
`docs/mockups/s432/training_v2.png`, and the code: WeekPlan.gd, TrainingLoad.gd, PadWeek.gd (head and functions), MoveMastery.gd,
HabitFix.gd, plus Attrs.gd (abilities, VALUE, SESSION_ATTRS), Sim.gd line 120, Recruit.ceiling, PushBack.gd, CoachAreas.gd.
No other critic's file was opened.

## Score: depth 7 / 10
One line: a training design with real weekly trade-offs (load against Legs, fade against new gains, a niggle against pushing on)
and honest hooks into the fight's own numbers. It stops short of 8 because the panels never price each other, the screen
never adds up what the week buys for the bout, and most of the new sizes are guesses until the probes run.

## What the design gets right (checked in the code)
- THE LOAD BUTTONS SAY WHAT THEY COST. Easy / Normal / Hard each print Legs on the bout day, Fitness, injury risk and the day a
  point lands. That is the clearest weekly training choice I have seen in a management game. The hours (6 / 10 / 15), the
  42-day usual load (TrainingLoad.next_chronic, 0.1535 a week) and the 1.3 / 1.5 lines are all in the code. Fitness as the top of
  the Legs bar uses the code's own two time scales (tiredness keeps 87% a night, the usual load is a 42-day average). No new
  meter is added.
- ROOM TO GROW FIXES A REAL DEFECT. Sim.gd line 120 passes `"pot": int(f["pot"])`, and WeekPlan.day / full_day read only that.
  Recruit.ceiling (+6 on the class's strength, -6 on its gap) is used only by the signing card. So today "which morning" makes no
  difference to growth by ability. FAST / SLOW / NEAR CAP is the Football Manager lesson exactly: show how much room is left, and
  the player can feel it.
- THE NEXT LINES ALREADY EXIST IN THE FIGHT. A corner call is graded OK at 50 and Good at 62, Fight IQ 65 finds the answer alone,
  Cardio 64 means no fade from round 3, and the perks have their own thresholds. Showing the next line and its date turns a decimal
  into a target the player wants to reach. Leaving out invented lines (REJECTED section) was the right call.
- FADE GIVES A CAMP AN ORDER. Without it, the measured values (Attrs.VALUE: Defence 0.090, Footwork 0.085) make one morning
  always best. With holding times, Cardio and Strength go early and Speed goes late. The cap of 3 points under the season's best
  stops fade feeling like a punishment.
- HABITS AS TRAINING WORK (THERE, HALF FIXED, GONE in pad places) build on HabitFix's real cost of 6 an exchange and PUNISHED_BY.
  It gives the pad tray a job besides new moves.
- NIGGLES FROM YOUR OWN LOAD in place of random body cards: cause and effect the player can steer, using the real injury types and
  the x3 spike.
- ONE PLACE PER DECISION (section 4). Shared slots are locked on this tab with "change on Club week", so the two boards do not fight.

## What keeps it from 10 (most important first)
1. THE PANELS NEVER PRICE EACH OTHER. In the drawing, "Rest it" on the sore hand says only "usual risk". Resting the hand turns
   Wednesday's habit pads into shadow boxing, in the very week Kayleigh punishes that habit (+2 to +4 in 100 if it is gone). That is
   the best trade-off on the screen, and the screen hides it. The same goes for Hard (Legs -8 at the bell against Fitness +3) and
   for a keep-it pad place (a new move a week later). Every answer should print what it costs in the other panels' own terms.
2. NOTHING ADDS UP WHAT THE WEEK BUYS FOR THE BOUT. CLUBWEEK's one number (your week against Coach's, as a range) lives on the
   bout page's bill, not on the tab where the week is made. A Football Manager player reads training and match preparation side by
   side. The tab needs one panel: the win-chance range against Coach's week, Legs at the bell, the habit's state, and which dates
   land AFTER the bout.
3. DATES AFTER THE BOUT ARE NOT FLAGGED. The drawing shows "Check hook Usable Mon 2 Mar" with the bout on Sat 28 Feb, and a Timing
   line on 17 Mar. A date past the next bout must say "after the bout", with the price of bringing it forward ("+1 pad place:
   Usable Fri 27", and who goes short on Club week).
4. THE ABILITIES PANEL SHOWS THE WRONG SIX. It lists Cardio, Defence, Footwork, Speed, Power and Fight IQ. Timing is missing, yet it
   is the ability Kayleigh tests most (x1.4, T18). Rows should be sorted by what a point is worth against the booked opponent
   (Attrs.VALUE times OppTests), with "show all 14" one click away. "Power" is the old summary of Strength (holds 30 days) and
   Explosiveness (holds 7). One "keeps" figure cannot be true for both, so rows must be the 14 abilities, never the old seven.
5. THE GOAL IS MISSING FROM THE DRAWING. FighterGoal is the one training target in the code with real stakes (mood +10 when met,
   -20 when missed). The map says the goal line moves into the load card, but the drawing has none. It belongs on the header and
   on the ability row it names ("54: your goal, Fri 6 Mar").
6. THE FIGHTER HAS NO VOICE IN TRAINING. PushBack.gd already makes a fighter with discipline under 50 push back on a Hard week,
   but the load buttons do not show it. In Football Manager, a player who is unhappy with training is half of what makes
   development feel personal. Put the fighter's ask on the Hard button, and make overruling it cost mood, as in the code.
7. A COACHED MORNING'S QUALITY IS INVISIBLE. CoachAreas has five rated areas (pads, bag, conditioning, strength, sparring), and
   CLUBWEEK says Coach is weak on Cardio work. The cells say "Coach" and nothing more. Show the grade on each cell ("Coach · bag A",
   "You · bag B") so the coached-morning choice reads as a quality choice.
8. AMATEUR WORDS LEAK FROM THE CAMP. "Keep my changes into Peak" sits on an amateur's tab, but CLUBWEEK v4.1 gives amateurs a fight
   week and no camp. Amateur blocks are BUILD, FIGHT WEEK, REST and DELOAD; the button should name those. Also, the Speed row says
   "fades Sat 21" while the plan has a Saturday speed bag. The "keeps" column must read the plan ("kept by the Sat speed bag").
9. SIZES ARE STILL PROMISES. Fitness as 55 + 4 x the usual hours, the fade rates, the niggle triggers, OppTests, the habit steps,
   bouts teaching, Lean and Cut x0.9 are all ESTIMATES. Fading 0.25 a week, capped at 3 points, may fall under the map's own cut
   rule (1.5 in 100). Run DETRAIN1 before drawing: if it comes back flat, fade Speed and Explosiveness at 1.0 a week rather than
   cut fade. Print no number the probes have not measured, as CLUBWEEK already rules.
10. ONLY ONE OF THE FOUR IS DRAWN. Samira (amateur) is drawn. The professional's camp (BUILD / PEAK / TAPER, "Cardio 64: no fade in
    rounds 3 and 4", worth twice on the debut) and Ana's mat week (class kinds with the stripe date for each, Cardio's hold, the
    hard-rolls strain) need the same frame drawn, or the Cursor brief will improvise them.
11. SPARRING PARTNERS ARE ALL EQUAL. The pair is chosen on Club week, but who you spar with never changes what is learned. A small
    rule would make the pair a felt training choice: a partner 5 or more above teaches Timing, Fight IQ and Composure x1.2, one 5
    or more below x0.8. Probe it with SPARSET1; cut it if it is under the cut rule.

## To reach 10/10 (concrete, buildable, most important first)
1. CROSS-PRICED ANSWERS: every option (load, niggle, keep-it card, diet, deload) prints its cost in the other panels' terms, read
   from the same run of WeekPlan.week and PadWeek.run_week ("Rest it: Wed habit pads become shadow, so the habit is HALF FIXED on
   Sat 28").
2. "SAT 28: WHAT THIS WEEK BUYS" PANEL on the Training tab: the win-chance range against Coach's week (CLUBWEEK's one number,
   LeverSize), Legs at the bell, the habit's state, the targets that land after the bout, and the biggest lever still open.
3. AFTER-THE-BOUT FLAG on every date past the next bout, with the price of bringing it forward and who goes short on Club week.
4. ABILITIES SORTED BY WORTH AGAINST THE BOOKED OPPONENT (Attrs.VALUE x OppTests, shown as four dots, not a decimal); Timing and
   Inside visible when tested; "show all 14"; never an old-seven summary row.
5. THE GOAL (FighterGoal) on the header and on its ability row, with on track or at risk and its date.
6. THE FIGHTER'S VOICE on the load buttons from PushBack (the ask and its mood price), one handwritten line.
7. THE COACH'S GRADE on every coached cell, from CoachAreas.
8. AMATEUR PHASE WORDS (BUILD / FIGHT WEEK / REST / DELOAD), and a "keeps" column that reads the plan.
9. PROBES BEFORE PIXELS: FITLEGS1 and DETRAIN1 first. If fade is flat, raise the Speed and Explosiveness rates rather than cut it.
   Only measured sizes appear on screen.
10. DRAW THE PROFESSIONAL'S CAMP AND ANA'S MAT in the same frame before the Cursor brief.
11. PARTNER LEVEL in sparring gains (x1.2 above, x0.8 below), kept only if the probe passes.

My 10/10: `docs/mockups/s432/critics/tr3_fm_10.png` (HTML beside it). Samira on Monday 16 Feb, with the hand rested. It shows the
cross-priced niggle, the "what this week buys" panel against Coach's week, the after-the-bout flags, abilities sorted by what
Kayleigh tests (Timing first), the goal on the header, the fighter's voice on the load, the coach's grade on each cell, "ask for +1
on Check hook" with its Club week cost, and "Keep my changes into the fight week".

## Complete for this version?
YES, with the list applied. For four fighters from amateur to a first professional fight, the design covers everything that
matters: weekly load, form for the bout day, growth to each ability's ceiling, fade, targets from the fight's own lines, the
opponent's tests, the body, habits, weight to the scale's day, the season strip and its ledger, bouts teaching a little, the
professional's camp, and Ana's mat. The risk is too much, not too little: the gate (TRAINSEASON1) and the two foundation probes
must be allowed to cut. Nothing above adds a new meter; items 1 to 8 are display and wiring of rules the map or the code already has.
