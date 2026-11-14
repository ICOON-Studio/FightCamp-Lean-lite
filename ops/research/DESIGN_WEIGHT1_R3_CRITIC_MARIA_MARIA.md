# DESIGN_WEIGHT1_R3_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ128)

Brief: research/DESIGN_WEIGHT1_R3_CRITIC_MARIA.md
Sent: 2026-11-14 19:40 | collected: 2026-11-14 20:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give WEIGHT1 round 4 **DEPTH 6, GENERAL DESIGN 5, PLAY 6**, so it doesn't pass the owner's bar yet. It fixes the round-3 faults:
- Names now sit only in headers.
- Weights are in kg only.
- One energy word is used everywhere.
- The club show and the championship now weigh in differently, which is how amateur boxing really works.
- The plan table folds away until it's needed.

It falls short because the map changes what a missed weight does today, adds a new tab with no agreed mockup, depends on two other designs that aren't built, and admits that its best and worst sensible plans differ by only 1 or 2 bouts in 100.

## Scores

**1. DEPTH: 6/10**

What works:
- **The weight you agree on a club-show offer is a real bet.** Keeping size helps a boxer who fights inside, but it risks being outside the 2 kg gap if the opponent comes in light. Watching tape 2 narrows that risk, so tape study now has a second use.
- **Each lever is paid in a different currency.** Burn mornings cost a stat or the goal. The fighter's ask costs mood or cash. The Monday answer costs Energy or the bout. Different payments make choices that differ from boxer to boxer, as the worked examples show.
- **Tiredness at the bell changes the answer.** A Cut is free for a fresh boxer and costs 14 to 18 Energy for a worn one, so the same plan isn't right twice.
- **The window ties weight to pace and the plan.** Energy at the bell sets how often the "when the opponent tires" line fires. That links three core systems, which is what deeper-not-wider asks for.
- **The real-world fit is good.** In England Boxing, amateurs weigh in on the day. Club shows are matched within a gap, and championships use the class limit. A light refuel against a full one is a real trade at multi-day championships.

What holds it back:
- **The map admits the choices barely change the result.** The WIN middles in 8.1 sit within 1 to 2 points of each other, inside the band. The choice then rests on the side costs (Flat on the night, the goal, cash). That's a real choice, but it's thin. P1 may show the screen should lead with those costs rather than with WIN.
- **The size edge is close to nothing at amateur level.** At a club show it's 0 to +1, and only inside and in the clinch. At a championship it's usually 0. "Keep size" only pays off when P2 says it does.
- **The window only exists if the opponent starts below 100 Energy (B6).** The map says that without it, the window is mostly 0 to 2 exchanges. So half the depth depends on one new rule.
- **Some answers win too easily (see Useless).** Half a plate looks like the safe answer for a boxer with low discipline. Come in light is rarely right.

**2. GENERAL DESIGN: 5/10**

What works:
- Every point from both critics gets an answer.
- The CODE tags match the pack: the $300 empty slot, stale Energy, CUT_DEFICIT, PushBack, morale ±5, the trust bands and the promoter refusing after two ducks.
- One rule for pulling out, shared with the injury pull-out.
- Prices print what lands in the cash tin.
- No pop-ups. Needs sit on Home.
- Release 1 and release 2 are cut cleanly.
- The words table is the best in any map so far.

What fails:
- **It changes a built rule without asking the owner.** Today a missed weight calls the bout off, the club pays $300, and it counts as no loss (pack 4.4). The map turns an amateur outside the gap into a walkover loss, with −12 mood, a member lost, reputation lost and a mark on the record. The map's own CHECK says real club shows may simply call the bout off. That should be owner question 3, not a CHECK left to the researcher.
- **It moves the amateur scale from the day before to the same day.** That's right for the real sport, but it touches every amateur bout, the Home "Weigh in" need and the weigh-in modal. It's shared with AMATEURWEEK1, which isn't built, so release 1 can't ship alone.
- **It leans on other designs that aren't built.** The favour pool belongs to AMATEURWEEK1. CLUBWEEK1 v7 has to adopt this map's Energy word. B0 (the Save fix) changes every fight number. That's three outside dependencies for a release called "the core".
- **It adds a screen nobody agreed.** M2, the Body and class tab, is a new tab on the fighter page, and the CLASS card is a new panel. Pack section 7 says screens come only from agreed mockups. M1 is drawn only as a to-do in the map's own 10/10 list.
- **Odd numbers go unexplained.** A missed goal costs "−19.9 mood after the bout", but the pack gives no goal value of that size: NOT VERIFIED. Cut 5 days is "−0.16 kg (CODE)", but 500 kcal a day for 5 days is about 0.3 kg by the usual 7,700 kcal per kg: NOT VERIFIED. The miss chance by room under the cap is ESTIMATE. No probe has run.
- **The title doesn't match the content.** The map is called R3 but says round 4. The header names "KALLI_KALLI". Small, but it confuses which version is being scored.
- **Weight on the Roster is shown by colour.** Amber and red need a word beside them ("Monday answer ran", "PAST THE CAP").

**3. PLAY: 6/10**

There's a real arc:
- The offer arrives with a weight bet.
- The Monday check lands as a number to sweat over.
- The scale is a moment, with the re-weigh as a tense second step.
- The Why names "Energy 92 at the bell, the window 4, your line fired 3 times".

That's anticipation and a payoff. But the scale only gets tense when the forecast is tight. Most weeks it's a line on Home, and the coach's row is gold for a reason. The fighter's ask is the only part with a person in it, and it never comes for a boxer with discipline of 50 or more.

## Options: missing, useless, and what each changes

**Missing**
- **The owner's choice on a miss:** bout off (today's rule) or walkover loss (EB 10.7.2).
- **Ask the opponent's corner to meet you halfway** at a club show. The two coaches agree a new weight at the scale, which really happens at club shows. It's free when your boxer is inside 2.5 kg, and the opponent's corner may refuse.
- **A plain line for when it doesn't matter:** "Weight is safe: nothing to decide". It sits on Fight prep so the player knows they can skip it.
- **A rough history of how close past scales were**, so the walk and the trim feel earned over a career.

**Useless or near-dominant**
- **Meal prep at $25 a day:** in 8.1 it buys 0.8 Energy for $300. Nobody pays that until money is plentiful. Make it cheaper or give it more effect.
- **Come in light:** gives away size and costs Energy. It only wins if the opponent is a big puncher you want to outlast, and the map itself says it's "rarely right".
- **Half a plate** for discipline under 50: it keeps mood and costs little weight. It's likely best almost every time unless the trim is near its cap. P14 should test it alone.
- **The nutritionist** at $100 a week: it halves asks only for boxers with discipline under 50 who are on a diet. With 3 roster places, that's often zero boxers.

**What each option changes**
- **Box near the walk:** keeps the size edge (0 to +1 inside), with a 5 to 12 in 100 band of being outside the gap.
- **Meet the declared weight:** no edge, Energy 100, outside the gap about 1 in 100.
- **Come in light:** costs the trim's Energy price and gives the size away.
- **Burn morning:** −weight, +1 to 3.4 Energy at the bell, minus that morning's stat. If the morning fed the goal, the goal may be missed.
- **The fighter's ask, Let eat:** +0.5 kg, mood +5.
- **The fighter's ask, Half a plate:** +0.2 kg, no mood change.
- **The fighter's ask, No:** mood −5, and with discipline under 50 the fighter may eat anyway.
- **Meal prep:** −$300 for 12 days, and a No always holds.
- **Monday check, Trust the trim:** costs the trim's Energy.
- **Monday check, Cut 5 days:** −0.16 kg, paid in tiredness.
- **Monday check, Pull out:** −$300, the $450 ticket cut is lost, no loss on the record. At a championship it ends the run.
- **Refuel Light:** gives back a quarter of the trim's Energy price.
- **Refuel Full:** gives back half of it plus 1.5 to 2.1% weight, but costs −2 live Energy in round 1.
- **Re-weigh:** sweat up to 0.3 kg at −2 Energy per 0.1 kg.
- **Another name:** costs 1 favour and works about 1 time in 2.
- **Pace per round:** sets the window and how many exchanges your boxer spends tired.
- **Write it:** adds the "when the opponent tires" line, replacing the weakest line.
- **The CLASS card (Move now, Move after the next bout, Test the weight):** changes the cut every camp, the size edge, the ladder place and how many offers come.
- **Share shows or One moves:** decides who gets the next offer when two of the club's boxers share a class.

## To reach 10/10

1. **Ask the owner about a miss before anything else:** "An amateur outside the gap: bout off with $300 (today) or a walkover loss?" Build only the answer he gives.
2. **Run P1, P2 and P3 now,** with B0 and B6 in a test branch. If the plan spread is under 3 in 100 in most bouts, the panel leads with the side costs ("Flat on the night 2 in 5", "Goal missed", "−$300") and drops the WIN column.
3. **Make release 1 stand alone.** Move the same-day scale, the gap and the re-weigh into WEIGHT1's own B5. Put a club-level stand-in for AMATEURWEEK1's favour pool in its place ("ask the matchmaker: once per 8 weeks"). Nothing in release 1 should wait on another map.
4. **Get M1 and M2 agreed as owner mockups before B9 and B10,** in Look B, at 1920×1080. Fold M2 into the existing Overview's BODY block instead of a new tab if the owner prefers.
5. **Fix the free and dominant answers.** Meal prep drops to $10 a day or also gives +1 Energy. Half a plate costs −2 mood under discipline 40. Come in light is cut, or it gives +2 Energy for one round against a Slugger.
6. **Make the size edge felt or cut it.** If P2 shows under 1 in 100 for every style, drop "keep size" from the club show and make the weight bet purely about the gap risk.
7. **Show the numbers' sources.** Read the goal-miss mood value from the code, or mark −19.9 ESTIMATE. Work out Cut 5 days from the kcal maths.
8. **Words beside every colour** on the Roster and on Home: "PAST THE CAP" and "MONDAY ANSWER RAN" as text.
9. **Add "Weight is safe: nothing to decide"** as the one line Fight prep shows when the forecast miss is under 1 in 100, so most weeks stay one click.
10. **Give the scale a moment.** The weigh-in modal shows the reading ticking up to its number, then MADE or OUTSIDE in words. A re-weigh is the second step, and it's the only weight event that stops the clock.

**My 10/10: Fight prep > THE WEIGHT, 1920×1080, Look B whiteboard**
- **Dark top bar:** the date, cash, and the big CONTINUE reading "to Sat 28, the scale at 9 am".
- **Header:** portrait, name once, 65 kg, the record, and the bout circled in marker ("London regional, 12 days").
- **Left (520 px), THE SCALE:**
  - A drawn bathroom scale.
  - "Now 65.9, on the day 65.2 (limit 65.0)".
  - The walk line, and the room under the cap as a marker bar with the words "0.4 kg room".
  - The miss risk in words ("1 in 100").
- **Centre (860 px), THE PLAN:**
  - The coach's row in the one gold frame, as three magnets: Burn mornings (Tue, Thu, Sat as pickable magnets, each showing its stat cost), If the fighter asks (Let eat, Half, No) and Monday check (Trust, Cut, Pull out).
  - Under each magnet, its price in words.
  - One alternative row in pencil.
  - "All plans" only when the risk is 5 in 100 or more.
  - At a club show this whole area is replaced by the three weight-bet magnets and the gap band.
- **Right (440 px), FIGHT NIGHT:**
  - Energy at the bell as a stacked bar for both corners: tiredness, trim, refuel.
  - The window drawn as shaded exchanges across three rounds.
  - Pace per round as Push, Steady and Save magnets.
  - The "when the opponent tires" line with Write it, and what it replaces.
- **Bottom strip:**
  - The deciding costs in words: "Flat on the night 2 in 5", "Goal: on track", "Cash: no cost".
  - "Too close to call on WIN" when it is.
