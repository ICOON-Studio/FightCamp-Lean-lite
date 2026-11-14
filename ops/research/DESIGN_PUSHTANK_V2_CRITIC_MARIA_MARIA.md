# DESIGN_PUSHTANK_V2_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ102)

Brief: research/DESIGN_PUSHTANK_V2_CRITIC_MARIA.md
Sent: 2026-11-14 06:11 | collected: 2026-11-14 06:41 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PUSHTANK v2 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it meets the owner's bar of 6 and 6. It's the best-grounded fight map so far: almost every number points to the code, and the v1 exploit is found and fixed. It isn't higher because LEGS is a brand-new resource that's sized on guesses, a few lines break owner rules, and the probe hasn't run.

## Scores

**1. DEPTH: 7/10**
Two dials, three resources. HANDS spends wind (wind comes back between rounds). FEET spends legs (only a little comes back). Both protect the head, which never comes back. That gives a real trade every round, and the case table proves the right setting changes with the score, the opponent's style, the weight cut and the round count.

It matches real boxing. A fighter who walks a mover down burns their legs for nothing; boxers call this "chasing". Cornermen do tell a fighter who is up on the cards to box and move in the last round rather than trade. And the damage a fighter takes to the head doesn't heal in the minute.

It ties into the rest of the game:
- The weight cut takes wind and legs at the first bell.
- Stamina, Recovery and Footwork training feed the tanks.
- The ROUND row in the game plan sets each round's dials in advance.
- Heart gives a second wind.
- Head damage feeds the injury roll and the days with no sparring.
- Rest days come from wind and legs.

What holds it back:
- **Coast is nearly a trap.** It has no refill now, it lowers your margin, and a lost round costs more head. It's right only in about two of the 17 cases. Real fighters do take a round off to recover, and the map gives coasting almost no upside.
- **The opponent only reacts by script.** Their hands follow a fixed rule by style and score. They never answer your setting, so the corner minute is a puzzle against a clock, not a duel.
- **The 6-round case is one line** ("legs decide"). Pro fights of 6 to 10 rounds are where this should matter most, and it has the least design.

**2. GENERAL DESIGN: 6/10**
What works:
- It checks every claim the v1 critics made against the code.
- It cuts AIM Head (strictly worse) and AIM Body (a duplicate of the call).
- It defines Hold as today's play, so the bot test has a clean control.
- It removes four elements from the fight screen.
- It runs the probe before any screen gets built.

What fails:
- **LEGS is six new rules, all sized by estimate.** The 2.0 base spend, the fitness factor, the 20% minute refill, the cliff at 50 to 20, the 30 line and the half-cut drain are all NEW. The "Press + Push reaches 30 late in round 3" target is an ESTIMATE. The headless bout has no legs today, so this is a new system, not wiring.
- **Rule breaks:**
  - **A name outside a header:** "Ortega's corner has Ortega pushing" in the clue line. It should read "The opponent's corner has the opponent pushing."
  - **Teal for LEGS on the floor ring:** teal is kept for UI only, and gold against teal on a floor ring is state shown by colour alone unless the ring carries a word.
  - **"His words"** fixes the speaker as a he; this is a quote of the owner, so it's allowed.
- **Pace stops being free during the round.** Today the pace dial is free and unlimited. Making each change cost one of the two full shouts is honest, but it takes those shouts away from calls. The map doesn't say how the panel shows "1 of 2 shouts left" when the player has already used a call.
- **Head per exchange changes how the game feels in the round, untested.** Splitting the round's damage into sixths keeps the same total, but the 60 line can now be crossed mid-round. That changes when knockouts can happen, and the probe doesn't log knockout timing.
- **It relies on things not yet wired.** The amateur judges' clean / ring / initiative leans (R29) are referenced in case 1 but marked "when wired". PlanPhase's if-ahead and if-behind rules are built but unused.
- **Not measured yet:** PUSHPROBE2 is a plan, not a result.

**3. PLAY: 6/10**
The tanks in the corner minute are the pit stop the owner asked for: wind refills and you see it, legs barely move, the head stays where it is. Clock-time readouts ("gassed at 1:00 of round 3 at Push") give the player a forecast to beat. The best moment is case 13: one shout to Push for the last 30 seconds and steal a 3-3 round. What drags:
- The dials are set once a minute and mostly left alone, because changing them costs a shout.
- With only scripted opponent hands, the best setting can be learned once and repeated.
- The rings under the feet add a second read on top of the corner panels, which is two places for the same number.

## Options: missing, useless, and what each changes

**Missing**
- An opponent corner that answers your setting. For example: you Press, the opponent switches to Move next round.
- A real upside to Coast, such as the wind refill back at a smaller size, or a better chance to come back from a hurt state.
- Logging knockout timing in the probe, now that the head moves every exchange.
- Pro-length rules beyond one line: how legs refill over 6 to 10 rounds, and when the tanks change between rounds.
- A word on the floor rings so state isn't colour alone.

**Useless as written**
- **The floor rings** when the corner panels carry the same numbers with lines and words. They're one more read, not a choice.
- **Coast** in most rounds, until it has an upside.
- **The "Heat" branch** listed as later: it's a note for the future, not an option.

**What each option changes**
- **HANDS Push:** +6 an exchange, punches landed ×1.25, wind drain ×1.35. It fades under 55 wind and is worth nothing at 40.
- **HANDS Steady:** today's play.
- **HANDS Coast:** −4 an exchange, landed ×0.75, drain ×0.6, no refill. A lost round costs more head.
- **FEET Press:** steps one place closer, legs ×1.5, the opponent's legs ×1.3, and pins the opponent on the ropes after 2 exchanges. It acts as Hold under 30 legs.
- **FEET Hold:** the fighter's own place, legs ×0.7.
- **FEET Move:** wants long range, legs ×1.0; makes an opponent who presses pay.
- **Changing a dial mid-round:** uses one of the two full shouts and goes through trust.
- **The corner minute:** sets both dials for free, gives back 52% of the wind debt, plus water, and 20% of the legs spend. The head gets nothing back.
- **Calls that name a place:** override FEET for that exchange.

## To reach 10/10

1. **Run PUSHPROBE2 and show the owner the table.** Arms A to D at 3 and 6 rounds, 400 paired bouts per cell. Add one more log: in which round and minute the knockouts happen, compared with today.
2. **Make the opponent answer.**
   - The opponent's corner reads your last round's setting and has one answer per style. For example: against Press, a mover goes to Move; against Push, a counter-puncher Holds.
   - Each answer shows as one clue line in the round, using "the opponent", never a name.
   - Probe: the best fixed setting must change after the opponent's answer in at least 5 of 10 cells.
3. **Give Coast a reason.** It gives back +1.5 wind an exchange (EXAMPLE, half of today's flat +6 spread over the round), and the chance to recover from hurt goes ×1.5. It still costs head on a lost round. Probe: Coast is the best setting in at least 2 cells and never more than 4.
4. **Size LEGS from the probe, not guesses.** Measure the six NEW numbers before any screen: the 2.0 base, the fitness factor, the 20% minute refill, the 50-to-20 cliff, the 30 line, and the half-cut drain. Pass: Hold ends near 70, Move near 60, Press + Push hits 30 in round 3, at 3 rounds and at 6.
5. **Fix the words and colours.**
   - "The opponent's corner has the opponent pushing."
   - Show LEGS in a non-teal colour with the word "Legs" on the ring.
   - Every line the player reads uses "your boxer" and "the opponent".
6. **Show the shout cost honestly.**
   - The panel shows "Shouts this minute: 1 of 2 left" for calls and dial changes together.
   - Hovering a dial change shows "uses your last full shout".
7. **Cut the floor rings, or make them the only meter.** Keep one place for wind and legs. My pick: keep the corner panel and drop the rings, which also keeps the fighters' feet clear.
8. **Write the pro-length rules.**
   - At 6 to 10 rounds the minute gives back 30% of legs (EXAMPLE).
   - Press costs ×1.3 from round 5.
   - Add cases for rounds 4 to 6 and 8 to 10.
9. **Wire PlanPhase and the amateur judges' leans** in the first build, so cases 1 and 13 are real, or remove those lines until they're wired.
10. **Feed the result.** The Why gets one line about the tanks, for example "Your boxer ran dry of legs in round 3: the ropes cost 2 exchanges", with a "Train footwork next week" button.

**My 10/10: the corner panel in a 3D fight, 1920×1080**
- **The fight (centre, 1920×800):** both fighters head to feet, nothing drawn over them.
- **Top-left and top-right corner panels (420×260 px each, top edge in the corner's colour):**
  - HANDS: Coast, Steady or Push, as words.
  - FEET: Press, Hold or Move, as words.
  - Each says "set for this round" or "uses a shout".
  - WIND bar with its 40 line ("Push worth nothing") and 35 line ("gassed").
  - LEGS bar with its 30 line ("legs gone").
  - HEAD bar with its 60 line ("a count can finish it").
  - Under each bar, one line in clock time ("Wind: gassed at 1:00 of round 3 at Push").
  - The opponent's bars are shown as ranges until film.
- **One clue line under the opponent's panel:** the opponent's game plus their corner's answer ("The opponent has gone to Move").
- **Bottom bar (1920×120):** the calls, Say nothing, "Shouts this minute: 1 of 2 left", the clock, landed punches, speed and skip.
- **Corner minute (same layout, darker):** the bars refill live (wind a lot, legs a little, head not at all), with the two dials to set for free and the three recovery points.
