# Training map v6: depth review (critic tr6_1, a strength and conditioning coach who plans fight camps for professional boxers)

Blind, fresh. Read: CRITIC_PACK.md, CRITIC_ACCESS.md, TRAINING_MAP_S432.md (whole), the drawing training_v2.png, and the code
(WeekPlan.gd, Attrs.gd, BoutRules.gd, Exchanges.gd, Combos.gd, TrainingLoad.gd, InjuryRoll.gd, MoveMastery.gd, Sim.gd).
Owner rulings folded in: Q-186 (full time once pro), Q-187 (featherweight and middleweight tables), Q-188 (Ana's mat plan this version).

## Score: depth 7 / 10

One line: the best-grounded training model I have seen planned for a management game (session load as effort x minutes, the
acute-to-usual ratio, a real taper, fade by dose, a stand-down after head knocks), but the weeks are still a pile of loads, not a
camp: the ORDER of blocks buys nothing, roadwork and intervals are the same job, and the week cannot react to how the fighter wakes up.

## The code claims, checked
Every defect the map names is real and named correctly, so each counts as handled (it is a foundation task):
- F1 rest drains Stamina: TRUE. Attrs.train, "The same points come off stamina" (`out["stamina"] = -float(out["recovery"])`).
- F3 Stamina is not one number: TRUE. BoutRules.play_round takes OWN_FADE 1.0 when the old conditioning is under the line (a cliff);
  Combos.spend_factor and refill both read conditioning (1.2 - 0.4 x c/100; 0.8 + 0.4 x c/100).
- F5 the dead zone: TRUE. BoutRules.stale_energy is 0 under tiredness 50 and 0 with no camp.
- F8 Hard barely buys: TRUE. WeekPlan.INTENSITY hard gain 1.3, load 1.5.
- F9 the free camp edge: TRUE. PROTOCOLS Light / Standard / Hard all cost 0, edges 0.25 / 0.6 / 1.0, focus 1.1 / 1.2 / 1.35.
- F10 the call grade step: TRUE. Exchanges.grade reads Good / OK / Poor from the mean, no climb.
- F4 hours without effort: TRUE. WeekPlan.hours is minutes x the load only; TrainingLoad.START_HOURS 10.
- The numbers I re-worked: Normal week 1,959 / 2,607 = work 75; Hard 2,659.5 = 102; the usual 92 to 97.7 after one 129 week (0.1535 of
  the gap); the Tank at tiredness 35 = 4.5 off. All add up.
- Small slips: MoveMastery's word for under 30 is "Learning" in code, "Raw" in the pack and map; T3 moves the heavy bag to Explosiveness +
  Inside while section 0's share table and the F2b test still use Strength + Explosiveness (fine as a before and after, but say which the
  test reads).

## What is deep (and true to a real camp)
- One load in WORK (effort x minutes, Foster), against a 42-day usual, with a 1.3 safe line and a 1.5 spike: this is how real camps
  are monitored, and the game prices it in injury the player can see.
- The taper as Sharpen: volume cut, intensity kept, nothing fades, the fighter arrives sharp. Correct (Bosquet, Mujika).
- Fade by dose with residual windows (Issurin): Speed needs a touch every week, Stamina and Strength every two. That creates the real
  weekly puzzle of "what do I keep alive while I build something else".
- The stand-down from sparring by what the head took, with "spar anyway" as a priced gamble. Real and responsible.
- Two horizons: this week vs the block to the target, with the spike after a taper called out. That spike after the taper is the most common
  real injury pattern I see, and the map makes the player meet it.
- Every option priced in the other panels by one run (T24). That is what makes a deep model playable.
- Hard is not free: from a tired start it pushes past 80 and triples injury; from a fresh start it is right. A real coaching judgement.

## What is shallow, from a camp planner's chair
1. THE ORDER OF THE WEEKS DOES NOT MATTER. A real camp builds a base (aerobic, strength) and then converts it (intervals, power, sparring),
   then sharpens. Here a Strength week before an Explosiveness week gives exactly what the reverse gives; each ability grows only by its
   own room. The strip labels blocks by load, not by what they build, so the season has no shape to plan.
2. ROADWORK AND INTERVALS ARE THE SAME JOB (both Stamina 2.0; the Recovery share waits on MORNINGS1). After F3, Stamina sets the energy a
   round costs and Recovery sets the refill between rounds: the game already has two engines in the ring and gives the player no way to
   build them separately.
3. NO REACTION TO THE MORNING. The week is set on Monday and runs; the one mid-week stop is a niggle after sparring. Real coaches change the
   session when the fighter wakes up wrecked. The map rejected the morning check as a hidden number; a VISIBLE rule set on Monday ("tired 72+
   in the morning: Hard becomes Normal") gives the same decision with no new number and no new stop.
4. THE HEADLINE EXAMPLE SHOWS THE WEAKNESS. Samira's Hard block is built on Stamina, an ability near its ceiling: Easy 63.0, Normal 63.2,
   Hard 63.5 at the regional. A player who sees a 0.5-point spread for a tripled injury chance learns "the load does not matter". The same
   tab on a FAST row (Footwork 57 of 72) would show the dose working.
5. EVERYONE RESPONDS THE SAME. Fighters differ in ceilings, not in how they take training. A trainability word per group (scouted, like
   ceilings) would make four fighters four different training problems.
6. HEAD CONTACT IS ONLY COUNTED PER BOUT. Hard sparring rounds over a season are the real long-term cost; the stand-down covers the night
   after a bout only.
7. EVERYTHING IS AN ESTIMATE AND THE GATE CAN CUT IT. Fine as a design, but SEASON1 (a careful player beats "Coach runs it" by 4 in 100 or
   reaches the target 4 weeks sooner) decides whether any of this survives. Until it runs, depth is a promise.
8. THE TAB IS VERY DENSE. The drawing carries about 150 numbers; cells clip ("Kayleigh" in a Tue cell). The reveal order helps, but the
   week-1 state is never drawn.

## To reach 10/10 (most important first, each buildable)
1. BLOCKS THAT BUILD ON EACH OTHER. Give each strip block an emphasis: BASE (roadwork, strength circuit, neck), SPECIFIC (intervals, heavy bag,
   pads, sparring), SHARPEN. A SPECIFIC block that follows at least one BASE week in the last 4 gets x1.2 on its points (ESTIMATE; probe
   BLOCKORDER1: "Base, Specific, Sharpen" beats "Specific, Specific, Sharpen" by 1.5 in 100 or a target 2 weeks sooner). Add one transfer:
   Explosiveness's ceiling is held under Strength + 10 (the slugger needs strength first). Show both on the strip ("x1.2 from the base") and
   on the Explosiveness row ("ceiling held by Strength 54"). Owned: WeekPlan.gd (dose count), Recruit.gd (ceiling_of), SeasonStrip (NEW).
2. TWO ENGINES. Roadwork trains Recovery 1.5 + Stamina 0.5 (base: the refill between rounds and the night's clearance); intervals train
   Stamina 2.0 (the energy each round costs). F3 already reads them apart; print the ring meaning on each morning card ("refill +1 a point",
   "round 3 energy +0.2 a point") and draw round 1-2-3 energy now against after the block. Test: roadwork_vs_intervals_test.gd.
3. MORNING RULES, SET ON MONDAY, NO STOPS. Three to four standing rules per fighter, each a toggle: tired 72+ in the morning: Hard to Normal;
   sore after sparring: next morning to mobility; hand day 3 running: bag to shadow; mood Low: the week turns Easy. The 13-day chart marks
   where a rule fires; "Coach runs it" uses Coach's rules. Replaces the rejected morning check with no hidden number. Module MorningRules.gd
   (pure), read inside WeekPlan.week before each day.
4. DEFAULT HARD'S AIM TO WORTH x ROOM, and redraw the headline on a FAST row. Coach lays Hard on the row with the most (Attrs.VALUE x the
   opponent's test x room), so a first Hard week shows a whole-point gain. Print the aim's gain to the target as "+2.6", and its ring line
   ("Jab and move: OK to Good"). Balance bar for the probe: Hard is the best load in 25 to 40 of 100 build weeks across the four fighters;
   under 15 it is a trap, over 60 it is the only answer.
5. RUN THE GATE BEFORE THE PIXELS. F1 to F10, then PACE1, DOSE1, FITLEGS1, HORIZON1 and SEASON1 with the bars as written; publish the table
   and cut what fails, as section 10 promises.
6. TRAINABILITY PER GROUP. Each fighter gets one word per profile group (HEAD, HANDS, GUARD, CARDIO, LEGS): responds fast x1.15, normal,
   slow x0.85 (ESTIMATE), a range until Known opens the group, like the ceilings; on the header ("fast to skills, slow to strength").
7. HEAD CONTACT OVER A SEASON. Count hard sparring rounds over 8 weeks (technical rounds count half); past a line (48, ESTIMATE) the
   Durability ceiling drops 1 (CeilingShift's existing stoppage-loss event, a second trigger). On Training and Condition.
8. THE WEIGH-IN DECISION FOR PROFESSIONALS. A day-before weigh-in allows a last-24-hour water cut (up to 2% of body weight, ESTIMATE) refilled
   by the bell at a Tank price; a same-day club scale forbids it. One more line on the WEIGHT panel, priced by the same run.
9. DRAW THE QUIET STATES. Draw week 1 (load, strip, room to grow only) and Lucy's camp and Ana's mat (8b) before the Cursor brief; fix the
   clipped cells; keep 20 px text.
10. ANA'S MAT ON THE SAME RULES. Her class kinds read the same load, dose and fade rules (one run), and the drill feeds her mat plan (Q-188),
   with the BJJCLASS1 probe.

## Complete?
Yes as a design, not yet as a build. Every mechanic has a code hook, a menu table, a unit test red on main, a probe and a build order, and
every code defect it names is real. Not complete for the build: Lucy's and Ana's stills (8b) are not drawn, every drawn number is worked
by hand until PACE1 and SEASON1 run, and the order of blocks (point 1) is the missing piece a camp planner would notice first.

## My 10/10 drawing
`docs/mockups/s433/critics/tr6_1_0_10.html` -> `tr6_1_0_10.png`: the strip as BASE / SPECIFIC / SHARPEN blocks with "x1.2 from the base",
the load table on a FAST row (Hard on Footwork +2.6, Jab and move Good), MY RULES (four morning toggles, where they fire), TWO ENGINES
(roadwork builds Recovery, intervals build Stamina, round energy now against after the block), trainability on the header, and head
contact over 8 weeks.
