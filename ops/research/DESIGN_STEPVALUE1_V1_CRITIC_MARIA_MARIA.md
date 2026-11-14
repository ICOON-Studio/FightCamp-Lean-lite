# DESIGN_STEPVALUE1_V1_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ142)

Brief: research/DESIGN_STEPVALUE1_V1_CRITIC_MARIA.md
Sent: 2026-11-14 23:10 | collected: 2026-11-14 23:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give STEPVALUE1 v1 **DEPTH 7, GENERAL DESIGN 6, PLAY 5**, so it clears the owner's bar, just. It fixes a real measured fault: a step at 0 currently fires like a Signature and is worth almost nothing even when it fires. It builds its effects from things the exchange already counts. It also gives the player a reason to learn different steps for different boxers. It loses points for the word Tank, an unchecked style-to-mode table that every number rests on, and a weekly loop where the reward is mostly invisible.

## Scores

**1. DEPTH: 7/10**

What works:
- **Grade from two abilities makes the learn pick personal.** A slow slugger grades Poor on step back but OK on tie up and roll out. Two boxers in the same gym should learn different steps. That's the strongest idea in the map.
- **Each step is right against some styles and wrong against others,** with a real downside: step in walks into a counter-puncher, roll out leaves the ribs open to a body puncher. Real coaching works this way. Whitaker made Chávez miss with lateral movement in their 1993 draw, and Durán beat Leonard in Montreal in 1980 by driving him to the ropes.
- **The ropes count creates a real pair.** Step back alone puts your boxer on the ropes, so it wants pivot out or step out beside it. Pairs (step back with pivot out, feint with a sharp counter) are the kind of book-building the owner calls the fun part.
- **The costs are real:** a plan slot, pad units, energy, no points on the cards, and the cap that an all-step plan loses.

What holds it back:
- **The value depends on the opponent's style, but amateurs can't scout before accepting** (S410) and the style word is the only thing known for free. The "learn for the region" read needs the Rankings style column to be trusted, and the map doesn't show the player how many pressure fighters are in the region.
- **Six steps answer the pressure fighter, and only one answers the counter-puncher.** Against pressure the choice is crowded, and against a counter-puncher feint is forced. The cap of +5 helps, but the counter-puncher has no real choice.
- **Push off is "the smallest worth of the ten",** and pivot out is worth little alone. Two of ten are filler unless they get a job of their own.
- **Opponents don't use steps by mastery** (held back as OPPSTEP1), so the system is one-sided. Your boxer's steps matter, but the opponent's footwork is just a mode word.

**2. GENERAL DESIGN: 6/10**

What works:
- The problem is stated with measured numbers (NODEREAD1, TREEVALUE1, PICKSPREAD1).
- The fix starts with one code change (FireLevel reads StepMastery).
- Every effect uses an existing exchange value except the ropes count, which is marked NEW.
- PlanRead's decay is reused as the anti-spam rule instead of a new one.
- Every size is marked ESTIMATE with a probe and a gate.
- The menu table wires each line to a system.
- No names in the body, and no fixed pronouns on screen.

What fails:
- **It uses "Tank" again.** The code says Energy (BoutNight._energy), and WEIGHT1 already asked the maps to use it. One word per concept.
- **Most best and wrong answers are proposed, not code.** Only "press" comes from PlanFight.ANSWERS. The six-style table and the style-to-mode mapping are both CHECKs, and every size in section 5 is a target against a style. If the code maps styles to modes differently, half the table moves. This should be settled before the sizes are written.
- **The Q-211 quote goes beyond the code.** Q-211 says steps fill in shadow mornings and sparring, but the pack says sparring gives a step nothing and nothing takes a step past 30 (NOT BUILT). The map marks this NEW in section 6, which is right, but the owner rules list quotes it as if settled.
- **"Can't be picked under 30" changes built behaviour.** Today a step under 30 is never planned by the coach and mostly fails. The map makes it unpickable. That's a reasonable rule, but it's owner question 2 and it removes the "try it early and pay for it" option.
- **The grade pairs need opponent abilities.** Opponents have heights and reaches, and the S448 Attrs exist for fighters, but whether every generated opponent carries Fight IQ, Composure, Timing and Accuracy values is not shown. Add a CHECK.
- **Tie up at amateur level is soft.** Amateur referees break holds fast, and the map can't say whether a holding warning exists. Ali against Foreman in 1974 was a pro fight with a lenient referee, a weak example for the amateur ring.
- **The Home note "Nothing in the study slot"** risks becoming a nag. The owner's rule is to show it only if the player should act, and an empty slot can be a choice.

**3. PLAY: 5/10**

There's a beat when the bar crosses 30 ("can go in the plan"). There's a payoff in the Why ("Step back answered the pressing 5 times") and a clear rematch story: lose to a presser, learn step back, come back. But a step's worth is denial: damage not taken, a counter that got +0.10. The player sees a bigger Why line and maybe a better band. Nothing on fight night shows the step working except a corner-card sentence, and the ropes count is hidden during the round. The reward is real but quiet.

## Options: missing, useless, and what each changes

**Missing**
- **A corner shout that leans on a learned step.** The map holds new shouts back, but "Hands up move your head" and "Jab and move" already exist. Let a shout get its best match when your boxer has the matching step at Usable, so learning shows on fight night.
- **A visible ropes warning in the corner minute** when the count reached 2 or 3 last round ("Put on the ropes twice: pivot out or step out"). Right now it's only in the Why.
- **The region's style count on the learn card:** "4 of the 10 ranked boxers press." This is the information that makes "learn for the region" a decision instead of a guess.
- **A counter-puncher answer beside feint,** for example a second job for step back against counter (draw and reset), so feint isn't forced.
- **Sparring on steps.** Sparring gives a step nothing (NOT BUILT). The map plans a sparring share past 30 but not under 30, so the only way to Usable is the single study slot.

**Useless or near-useless**
- **Push off:** +1.5 against one inside presser, the smallest effect, and it takes a slot from pivot out or tie up. Give it a job (clearing the clinch place to save energy) or fold it into tie up.
- **Pivot out alone:** +2.5 only when your boxer is pressed back, and the map calls it "a partner, not a step on its own". That's fine as a pair, but it shouldn't be offered as a learn pick before step back.
- **The Home amber note:** see above.

**What each option changes**
- **Step back:** takes away 35% of power damage, moves the fight to long range, +0.10 to the next counter, and +1 to the ropes count.
- **Step out:** takes away 25%, switches the opponent from Pressing to Boxing at range for one exchange, and clears the ropes count.
- **Pivot out:** moves the fight to mid range, clears the ropes count, and +0.08 to the next punch line.
- **Step in:** moves the fight to mid or inside, +0.12 to the next inside punch, and drains the opponent's energy. Against a counter-puncher it costs 20% more damage taken.
- **Cut off:** the opponent's steps fire 30% less, drains the opponent's energy, and +1 to the opponent's ropes count.
- **Herd:** +1 to the opponent's ropes count, and +0.12 to power punches at the ropes.
- **Feint:** the opponent's counter fires at −0.10, and +0.12 to your next punch. It decays fastest.
- **Tie up:** ends the exchange early (both sides land half), gives back 0.8 energy, and breaks Loading up.
- **Roll out:** takes away 40% of head damage from hooks, and +0.10 to a counter. The ribs stay open.
- **Push off:** moves the fight from inside to mid, and drains the opponent's energy.
- **The study slot:** one step to Usable in about 5 weeks, in place of the study pick going to a punch.
- **A step drill card past 30:** shares a pad night with punches.
- **A shadow morning on a step:** step mastery instead of the morning's stat.
- **A greyed plan line:** shows how long until it can be picked.
- **The Why's NEXT button:** opens the learn card.

## To reach 10/10

1. **Settle the style-to-mode mapping and the full PlanFight.ANSWERS lists first,** then rewrite sections 3 and 5 from the code. Every target rests on them.
2. **Use Energy, not Tank,** everywhere.
3. **Give the counter-puncher a second answer,** and give push off a real job or merge it into tie up, so no style has a forced pick and no step is filler.
4. **Show steps on fight night:**
   - A corner-minute ropes line when the count hit 2 or more.
   - The best match for "Jab and move" and "Hands up move your head" when the matching step is Usable or better.
   - Both use existing shouts, with no new ones.
5. **Put the region's style count on the learn card,** read from the regional table ("4 of 10 press"), so learning for the region is a read, not a guess.
6. **Add a CHECK that every generated opponent carries the grade abilities** (Speed, Timing, Fight IQ, Composure, Accuracy, Strength). If one is missing, grade against the old summary stat.
7. **Let sparring give steps under 30 a small share** (about a third of the pad rate, an ESTIMATE). Then the single study slot isn't the only road, and two steps can move at once at a cost.
8. **Ask the owner question 2 with the trade spelled out:** "unpickable under 30" or "pickable at a 1 in 4 fire rate and the wrong cost". The second keeps a gamble.
9. **Make the Home note conditional:** only when a booked opponent's style has an answer your boxer can reach by fight night.
10. **Run NODEREAD2, TREEVALUE2, STACK1 and PICKSPREAD2,** paste the tables, and have John verify each named fight. Replace Ali against Foreman with an amateur-legal clinch example.

**My 10/10: Fighter page > Overview > WHAT TO LEARN NEXT, 1920×1080, Look B whiteboard**
- **Dark top bar** with CONTINUE.
- **Portrait header** with the name once.
- **Left column (40–620): THE STUDY SLOT.**
  - One magnet holds the current step with its bar (0 to 30), the weeks left in marker, and "Usable by fight night" or "2 weeks short" beside the circled fight date.
  - Under it, three step cards ranked by the coach. Each card has the step, the grade word with the ability pair on hover, "Pays against pressure fighters", "Wrong against counter-punchers", the size at Sharp, and the weeks to Usable.
- **Centre (660–1260): WHAT YOU'LL MEET.**
  - The next opponent's style word and found tells.
  - The region's styles counted as tally marks ("Press 4, Range 3, Counter 2, Slug 1").
  - A star beside each style your boxer has no Usable answer for.
- **Right column (1300–1880): YOUR STEPS.**
  - The ten as small magnets with tier words (Raw, Usable, Sharp) and the pairs drawn as marker links (step back to pivot out).
  - A sticky reading "Last fight: on the ropes 4 times" when it happened, with a button to open the Game plan.
- **Bottom (980–1060):** Put in the study slot (gold), Drill on the pads (from Usable), Open the Game plan.
