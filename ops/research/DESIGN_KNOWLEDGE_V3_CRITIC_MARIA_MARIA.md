# DESIGN_KNOWLEDGE_V3_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ112)

Brief: research/DESIGN_KNOWLEDGE_V3_CRITIC_MARIA.md
Sent: 2026-11-14 09:42 | collected: 2026-11-14 10:00 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give KNOWLEDGE v3 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it just reaches the owner's bar, on one condition: the perk leak and the Strength and conditioning shortcut below get fixed before build. It closes most of v2's problems: it keeps "scouting" for opponents only, gives the trial a real price, sets a threshold for when you find out, and closes the gain-line leak. What's left are three new leaks and one hire that makes most of the reads pointless.

## Scores

**1. DEPTH: 7/10**
The reads cost different things:
- money (Look closer, Test day, Re-check),
- a morning session,
- risk (hard spars),
- a roster place (the trial),
- a real bout.

The key trade is real: Under fire (Durability and Composure) can only be read by taking injury risk or fighting. That's how real gyms work. Coaches say you don't know a chin until someone hits it. Hard sparring before a debut is the standard test, and so is the chance of losing a prospect to it.

Hype makes signing a decision, not a lottery: a flop is a read you skipped. Stale knowledge (a step up, a layoff, age 30+) keeps reads worth buying in year three, and Re-check gives a cheaper way back.

What holds it back:
- **Strength and conditioning dominates.** At $100 a week it makes every Body row Exact. Once you hire it, Test day is useless and the Body group stops being a choice. The physio does the same for Recovery and Flexibility.
- **Mornings already narrow Body for free** (1 point per 3 focused mornings). Test day only matters for a new boxer, and the map already doubles it under 5 bouts, so it's a first-month button.
- **The proof is one seed set** (+6 top-10s per 60 worlds). If the reads don't pay off on all three sets, the depth on paper doesn't hold.

**2. GENERAL DESIGN: 6/10**
What works:
- One word for each act (Read, Scouting, Look closer).
- One list of width words.
- Heart sits in Mind only.
- No pronouns, and no person's name outside headers.
- 17 menus wired.
- Old saves start at Exact.
- The fight still reads the true stats, so balance doesn't move.

What fails:
- **The perk road gives exact values away.** Perks open at fixed attributes: Iron chin at Chin 70, Finisher at Power 70, Second wind at Conditioning 70. The day Iron chin opens, the player knows Durability is past the line, and that reveals the very thing Under fire is meant to hide. The map doesn't mention perks.
- **Other leaks:**
  - The Why prints "worth about +X%" from true stats.
  - The coach's one change and "Do it" on the Week tab are picked from true values.
  - The attribute hover "what each does in a fight" may quote exact numbers (NOT VERIFIED).
  Probe K4 reads only the week review, so it would miss all of these.
- **The finding-out moment stops the clock.** The pack stops the clock only for things that need the player (an offer, a weigh-in, fight night, an injury). A narrowed band needs nothing. A flag that waits for Monday fits the rules better.
- **"Tiredness in three colours"** shows state by colour alone, which breaks the colour rule. It needs a word: Fresh, Tired, Overreached.
- **The CODE claim on win chance is too wide.** The pack says the band widens when the *opponent* is unscouted. Widening it for your own boxer's Unknown rows is new work, not CODE.
- **Dola 4 is "done" on paper only.** The coach's gut line isn't in any menu row (M1 to M17).
- **Fight IQ is listed under Skills.** The code (`Attrs.gd`, S448) has it as an ability, beside Composure. Pick one and match the code.
- **The trial and the 3-place roster.** With 3 roster places at the start, a trial that holds a place blocks a signing for 4 weeks. That's either the point or a trap, and the map doesn't say which.

**3. PLAY: 6/10**
There's a moment to look forward to: the first hard spar or first bout opening Under fire, with the old band ghosted beside the new one and a button to act on it. Hype gives a "was I right?" beat at the trial.

But most weeks it's a quieter Monday with bands instead of numbers. The week review loses its best moment, the bar filling to a whole point, and the map puts nothing in its place. The reward from reading isn't shown either: the player never sees "this read saved you a $500 trial" or "this spar caught a weak chin before the debut".

## Options: missing, useless, and what each changes

**Missing**
- **A perk rule:** perks unlock without showing the threshold, or perk names hide until a bout reveals them.
- **"What this read bought you"** on the moment card and the Why.
- **A way to read an amateur opponent's Under fire:** tape of a past stoppage. Today it's weapon, habits and weakness only.
- **Confirmation before a trial** that names the blocked roster place.
- **The coach's gut line** as a real row (one band word, on the Monday report).

**Useless or dominant**
- **Test day once Strength and conditioning is hired.** Also late in a career, when mornings have already narrowed Body.
- **Re-check on Body for a boxer over 30** when Strength and conditioning is hired.
- **The Cutman's "opponent's cut risk"** helps on pro nights only, with no choice attached unless it feeds a plan line or a corner call.

**What each option changes**
- **Look closer ($120):** one group to half its day-one width, or clears Hyped.
- **Trial ($500 over 4 weeks plus a roster place):** every group narrows as if signed; you can walk away for free.
- **Test day ($60 plus a morning):** Body narrows 4 a side, 8 under 5 bouts, but costs that morning's gain.
- **Re-check ($40 plus a Light morning, every 3 weeks):** wins back half a stale band.
- **Hard spar with a club mate:** injury ×2 that night, tiredness +15, Under fire up to half way.
- **Hard spar with an outside partner:** the same plus $160, Under fire up to 3/4 of the way.
- **A bout:** Under fire narrows 4 a side, the only full read.
- **Strength and conditioning, physio, second coach:** respectively Body Exact, Recovery and Flexibility Exact, and Skills narrowing 25% faster.

## To reach 10/10

1. **Close the perk leak.** The perk road shows "opens when a body number is strong enough", with no number. An Under fire perk (Iron chin) shows only after Under fire reaches Good read. Add the perk road and the Why's "+X%" to probe K4.
2. **Cap the hires.** Strength and conditioning makes Body narrow twice as fast, not Exact. The physio makes a Recovery and Flexibility Test day free. Re-run K3 with Strength and conditioning hired, pass line unchanged.
3. **Make the moment a flag, not a stop.** It goes in Monday's report, except Under fire's first opening after a hard spar, which flags on the top bar without stopping the clock.
4. **Run K1 on three seed sets and K2 with a human reader,** and print the margins. Replace each ESTIMATE with its probed value.
5. **Show the payoff.** The moment card and the Why add one line, such as "Spar read: Durability 41–49. The step up was 3 weeks away." The History tab lists the last 8 band moves with what each read cost.
6. **Give the week review a new reward.** A band tightening animates, with the centre marker sliding. "Good read" to "Exact" gets its own line, landing last in the week's surprises.
7. **Fix the words.** Tiredness shows as Fresh, Tired or Overreached plus colour. Fight IQ goes in one group, matching `Attrs.gd`. Drop "CODE" from the win-chance-for-your-own-boxer claim.
8. **Make Dola 4 real:** "Coach's gut: chin looks solid (Rough)" as one Monday line, wired to Knowledge.gd.
9. **A trial confirmation** that names the roster place it holds and the 4 weeks' cost.
10. **John's SQ30 answer** sets the Under fire step from bouts and spars. Until then, that step stays ESTIMATE.

**My 10/10: Fighter page > Overview, 1920×1080, Look B**
- **Header (120 px):** polaroid, the name once, class in kg, age, record, Hyped tag as a sticky note with a word.
- **Left (600 px), WHAT YOU KNOW:** Body, Skills, Under fire as marker bands on paper, each with its width word and an open arrow for its rows. Mind as words. Room to grow as a word. The perk road below, with no numbers, showing "opens when…" in plain words.
- **Centre (760 px), FIND OUT:** cards for Test day, Re-check, Hard spar (club or outside) and Look closer. Each has its price, the risk in words, the narrowing it buys as a ghost band, and one button. A card is greyed with its reason when a hire already covers it.
- **Right (560 px), WHAT IT BOUGHT YOU:** the last 8 band moves with what caused each and its cost. STALE bands with their cause and Re-check. The hires that would speed each group up.
- **Bottom (120 px):** the last moment card, the old band ghosted beside the new, one sentence, and one button ("Rebuild the defence", "Book the step up" or "Write it"), with gold only on that button.
