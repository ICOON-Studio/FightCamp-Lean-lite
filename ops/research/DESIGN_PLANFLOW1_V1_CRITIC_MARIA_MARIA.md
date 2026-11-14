# DESIGN_PLANFLOW1_V1_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ121)

Brief: research/DESIGN_PLANFLOW1_V1_CRITIC_MARIA.md
Sent: 2026-11-14 15:29 | collected: 2026-11-14 16:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give PLANFLOW1 v1 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it reaches the owner's bar. The core is right: it redraws the plan the game already has instead of building a second one, and its strongest rule is that only a habit found on film can earn a "best" answer. But its depth rests on pad time as the budget, and the step and defence answers cost no pad time at all. That one hole is what stops it reaching 8.

## Scores

**1. DEPTH: 7/10**
What works:
- **Film versus pads.** A night on film costs a pad night, and a habit found on film is the only way to get a "best" answer against it.
- **Habit share as a bet.** "3 of 4 films" against "1 of 4" lets the player weigh a strong answer to a rare habit against an ok answer to a common one.
- **Early answers are worth more,** because reads build through the round.
- **A wrong diamond costs more than an empty one.**
- **The opponent caps it:** an answer used again loses edge, and a pro corner reads the plan.
- **Real fit.** Real corners plan exactly this way: "if they come forward, step back and check hook". Tape tells you what the opponent does most, and the plan bets on that.

What holds it back:
- **Step and defence answers are free.** The pack (S448) says the StrikeMap arrows (step back, pivot out, cut off, herd, tie up, feint, roll out) have no mastery and always work in full. Many of the map's best answers are exactly these: step back, pivot out, cut off, feint. A diamond built on them needs no drill card, never gets a red stamp, and always fires. So the pad-time budget only applies to punch answers. A plan of found habits answered with steps beats everything for free. The probe set has no bot for this.
- **Amateurs don't punish reuse.** Opponents adjusting by round 2 is AGREED, NOT BUILT in the pack, not CODE as the map tags it. ProRead isn't in the pack at all (NOT VERIFIED). Until either exists, the ONE bot (one diamond, every bout) isn't punished in amateur bouts.
- **The preset leaves little room.** Free habits cover the opponent's main style mode plus tires and hurt, so the coach's preset already answers the habit that fires most. The extra found habits (shells up, circles away, bites on feints) have no confirmed tell names.

**2. GENERAL DESIGN: 6/10**
What works:
- Every element maps to a code thing (section 2): box, diamond, chain, Plan B as the opening card's arrow.
- The rejected "lost_last" arrow and the hurt rule kept apart from Plan B are good discipline.
- Shouts merged with the existing two-a-minute rule, not a second resource.
- No timer on the corner.
- No name outside headers, no pronouns.
- 14 menus wired, no new screen.
- "Last round, behind on your coach's count" is honest: amateur scoring isn't shown live in real boxing.

What fails:
- **Colour shows state alone in three places:**
  - the best/ok/wrong dot on a diamond,
  - the gold or red read pips,
  - the red "FIRED" fill.
  Each needs a word or shape beside it ("BEST", "+2", "FIRED" as text and not only the fill).
- **Numbers don't match the pack.** The map quotes S396 as 59 / 46 / 43. The pack says 59 / 45 / 41. Pick one source.
- **Film's cost contradicts the pack.** The pack says camp Film (tape study) is free. The map says a film night costs a pad night (240 units). If Film takes an evening slot that would have been pads, say that plainly and confirm it in code. Otherwise the main trade (film versus pads) isn't real.
- **CODE tags that need checking:** opponents adjusting, ProRead and its memory, FixLab, the four new habit names, films-shown counts, the cut state mid-round. Seven CHECKs, and three of them prop up the depth argument.
- **"Is hurt: best is the finishing combination"** overlaps the existing corner call "Go for the finish". Two ways to do one thing on the same exchange; say which wins.
- **Main line "one box per card", at most 4,** but there are six places in the ring. Say which two places a plan can't have a main move on, or why 4.

**3. PLAY: 6/10**
"FIRED" lighting up on the live panel is a real moment, and the corner minute with counts on the flowchart is the right place to make the one change. The failure path teaches well: diamonds that never fired, with habit share on the file before the fight. But in v1 the fight is watched, not steered: the player's part ends at the weigh-in apart from one change a round. The thing to look forward to between fights, a better plan for the next opponent, depends on probe pass line 1 (good plan +12 over none). Today's measured gain from one change is about 1 bout in 20, too small to feel.

## Options: missing, useless, and what each changes

**Missing**
- **A mastery cost for step and defence answers,** or a slot cost, so they spend the same budget as punches.
- **A cost for reusing a plan in amateur bouts** until adjusting is built: for example, an amateur opponent who has seen your boxer before starts with one read on the most-used diamond.
- **A "plan the opponent will show" line on the file:** the most likely opening mode, from films.
- **What happens to diamonds on a habit that hasn't shown by round 2:** keep them, or let the corner change swap one for free.

**Useless or near-dominant**
- **Diamonds answered by a step, defence move or tie-up:** free and always firing, so dominant.
- **The grey "HURT: hold" stub in v1:** shown on every box but not changeable. Under the owner's rule, show it once in the file column, not on every box, until v2 makes it a choice.
- **"Load preset" once a hand-made plan exists for that opponent:** only useful for a new opponent.

**What each option changes**
- **Film night:** one habit found, one diamond unlocked, one pad night lost.
- **Scout ($250, pro):** weapon and weakness at once.
- **A main-line box:** the move after a won exchange on that card, worth match × pad time minus the card average, and a drill card to fill.
- **A diamond:** taken first when its habit holds, best/ok/wrong against the opponent's game. A wrong one puts your boxer a read down and shrinks the energy ceiling.
- **Plan B:** the opening card's any-time move, used after every lost exchange.
- **Test it:** shows the plan's worth over no plan and which diamonds fired, using one of the limited tries.
- **Corner change:** one box or diamond per round. Changing a box that worked resets its reads.
- **v2 aimed shout:** forces one box next exchange, using one of two full instructions a minute.
- **v3 bait pips:** body work builds "expects the body", cashed by a feint-low diamond.
- **v3 Composure:** after a knockdown, a shown chance the plan holds, or edge 0 until the corner.

## To reach 10/10

1. **Close the free-answer hole.** Give StrikeMap arrows mastery like moves (Usable 30, Sharp 60, fire rates 1 in 2, 3 in 4, always), drilled on pads and in sparring. Or make each step diamond take a slot. Add a STEPS bot to the probes (found habits answered only by steps); its pass line is to finish under GOOD.
2. **Confirm the trade between film and pads in code.** Camp Film takes an evening that would have been pads, and the tray shows "Film night: −1 pad night". If code keeps camp Film free, the found-only rule needs another price, such as one camp day per habit.
3. **Tag adjusting honestly.** It's AGREED, NOT BUILT. Either build "opponents adjust by round 2" as part of v1, or give amateurs the reuse read in item 3 of Missing. Then re-run pass line 4 for amateurs as well as pros.
4. **Run probes 1 to 8 on three seed sets,** plus STEPS. GOOD must beat PRESET by 8+ points or the editor isn't worth drawing. Use one S396 source.
5. **No colour-only state.** Diamonds print BEST, OK or WRONG. Pips print "+2" or "−1". FIRED stays as text over the fill.
6. **Settle the seven CHECKs.** Drop any habit without a real tell name rather than ship it on a guess.
7. **Make the hurt rule a single file-column line in v1,** not a stub on every box.
8. **Say which corner call wins** when "is hurt" fires and the player shouts "Go for the finish" in the same exchange. The shout should win, using its full-instruction slot.
9. **Give the player something to steer in v1:** the corner minute shows which diamonds haven't fired and lets the one change swap a dead diamond for a box on the card the opponent actually fights on, with FixLab's suggestion outlined.
10. **Draw both pages as 1920×1080 PNGs,** stress-tested with long combination names and a switch-hitter.

**My 10/10: the plan editor, 1920×1080, Look B whiteboard**
- **Header (120 px):** your boxer's polaroid and the opponent's, each name once, class in kg, style word and stance.
- **Left (400 px), THE FILE:**
  - Habit chips with the word, "3 of 4 films", and FOUND or FREE as text.
  - Locked chips say "1 film night opens this".
  - The opening card, the hurt rule as one line, and Load preset.
- **Centre (960 px), THE FLOWCHART:**
  - The opening node at the top, then up to 4 main-line boxes joined by arrows labelled with the card each move leads to.
  - Each box shows the move, tier and number, fire rate and edge, with a red stamp and "UNDER 30" in text.
  - Diamonds to the right with habit word, answer, and BEST / OK / WRONG printed. Step answers also carry a tier.
  - The Plan B bar at the bottom with its return arrow to the top.
- **Right (400 px), WHAT IT COSTS:**
  - Drill cards needed against pad nights left, film nights used.
  - One warning line each ("Pivot out: Raw, fires 1 in 2").
  - Tests left.
  - The worth line "+8 over no plan, coach's test", gold only there.
- **Bottom (80 px):** Save plan, Test it, Clear. Every number explains itself on hover.
