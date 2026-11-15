# DESIGN_FIGHTFILM1_V3_CRITIC_JOHN_JOHN - John answer (seat queue SQ197)

Brief: research/DESIGN_FIGHTFILM1_V3_CRITIC_JOHN.md
Sent: 2026-11-15 23:11 | collected: 2026-11-15 23:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score FIGHTFILM1 v3 as a fresh critic, starting with the new evidence test, the power-to-wins conversion and the rerun of the probe on all 72 claims. The owner's computer is still offline, so I can't open `CRITIC_ACCESS.md`, the mockup or the probe script.

**Logic check.** I recomputed the map's evidence test and its power figures by hand. I couldn't run the probe because the owner's computer is offline, so I checked it against its printed rules.

**These hold:**
- **The coach's check in the mockup passes.** 7 of 31 against 3 of 43 gives an expected count of 2.16 and a spread of 1.93, so the evidence score is 2.51, over the 2.33 bar.
- **What the screen shows lands exactly on the bar.** 5 of 21 against 2 of 30 gives an expected count of 1.40, a spread of 1.54 and a score of 2.33. So the screen pointed at the claim, and the check confirmed it.
- **The spread formula is the right approximation** for comparing counts like these.
- **A second film now always helps:** punch habits go from 63–68% found to 86–91%.
- **Noise averages 2.0–2.5%.** That's about twice the 1% the bar suggests, which is expected with counts this small, and the test's 3% and 8% limits leave room for it.
- **+5.5 win points per power point follows from the map's model.** Two uniform swings from 0 to 27 give a round-win slope of 1/27 per point, and the majority of three rounds multiplies that by 1.5, which is 3.7 × 1.5 = 5.6.
- **"One-two 27 → 31" fits the code's units.** A 240-unit pad night at 2.1 an hour, split across two cards and multiplied by Luke Reid's coach factor of 0.91, gives about +3.8.
- **The mockup's numbers all still add up.**

**What doesn't hold:**
1. **The evidence test breaks when the rest count is 0.** If the fact never follows their other punches, the expected count and the spread are both 0, so the score divides by zero. Count the rest as at least 1, as v1 did.
2. **The coach sees what the camera didn't.** The coach watches the same film, so in the story the coach can't count punches the camera missed. That's what makes the fog feel made up (section 8, point 1).
3. **The stop compares the wrong things.**
   - A new weapon is permanent: +0.3 in every bout from now on. A tell pays against this opponent only, or in a rematch.
   - A tell's main value isn't the 0.28 film power. It's the plan line it lets you write, which can rate Beats it once confirmed. The pack measures a good plan against none at +14 wins in 100. The stop shows neither of these.
4. **Converting power to wins is a derivation, not a measurement (CHECK).**
   - The pack says each round is six exchanges settled by dice. If the swing applies per exchange rather than per round, the conversion changes.
   - It's also unclear whether "27 a side" means a range of 0 to 27 or ±27. The second halves the figure.
   - So measure it: 1,000 bouts each at +0.28, +0.4 and +1.2.
5. **"WEAPON_EDGE 0.3 a weapon over 4" is unclear.** If it pays only from a fifth weapon on, a young boxer's new weapon is worth 0, and the stop's "+0.3" is wrong (CHECK in the code).
6. **Watching yourself still wins in a TAPER week.** Most amateur bouts get no camp, so the film night falls in a fight week, where the stop says "a rest night (tiredness)" and gives no price. Watching yourself then costs nothing you can see.
7. **Old numbers are left over.**
   - Fight prep in section 6 still lists "30 / 70 / 90%" when the figures are now 70, 85, 30, 20 and 30.
   - `FilmTruth.LOOKED_TRUE` is 0.90 in the code and needs to become 0.85.
   - The section 1 header still says "the v2 answer".
8. **The percentages read as probabilities but aren't.** A reader's pass is right 88% of the time and a reader's two-film Maybe 55%, yet they show 70% and 20%. The player will read them as chances.
9. **The per-opponent cap still doesn't bite with a full-time coach.** With Marcus Hale, three nights of 3 checks is 9, capped at 8 for 4 films, which is enough to check nearly every true claim plus both report rows. Scarcity holds with Luke Reid (4) and against opponents with only 1–2 films.
10. **The probe tests the map's model, not the game** (FilmBout isn't built). The map says so; it stays a condition before approval.

**FIGHTFILM1 v3 scores 7 for DEPTH, 7 for GENERAL DESIGN and 7 for PLAY, so it meets the bar from me.** It still needs a second fresh critic, and four fixes should land first: the coach's view, the stop's prices, a measured power-to-wins test, and the divide-by-zero.

**DEPTH 7.** The decisions are now real:
- which of the screen's leads to spend scarce checks on;
- whether to pull a second film for fades and hurt habits;
- the coach you hire, which sets checks a night;
- what goes on file and what on the watch list;
- the corner minute as a live test of a Maybe.

It isn't 8 because the evening trade is mispriced. A permanent weapon is set against a one-opponent tell, the plan line's value is missing, and in TAPER weeks watching yourself costs nothing you can see.

**GENERAL DESIGN 7.** The evidence test is sound, a second film always helps now, and noise is under 3%. Holding it at 7:
- the divide-by-zero;
- the coach seeing what the camera missed;
- a power-to-wins figure that's derived rather than measured;
- the unclear weapon rule;
- old 90% values left over.

**PLAY 7.** One stop, one critical button, a readable "seen: 5 of 21" line, and "Not enough moments" instead of guessing. The figures shown as percentages will be misread as chances.

**Options**

| Option | Verdict | What it changes |
|---|---|---|
| "Frame by frame" (the coach's check) against "at full speed" (the screen) | Missing | Gives the fog a real cause, so section 8 point 1 is answered |
| Prices in wins on the stop, with "lasts" and "this opponent" tags | Missing | Makes the evening trade a real choice |
| A price for the TAPER rest night (fight-night energy) | Missing | Ends watching yourself as a free pick in fight weeks |
| "Only 1 film: fades can't be confirmed" on a one-film opponent | Missing | Points the player to the corner minute instead |
| Percentages in the figure | Useless as a probability | Show trust words (Sure, Likely, Maybe) with the % on hover |
| Report checks counting against the per-opponent cap | Keep | Already stops checking everything |
| The live log off by default | Keep | No change |

**Section 8 points:**
1. **The camera fog is fair if the story changes.** The screen is what you saw at full speed; the check is the coach going frame by frame for 20 minutes. Real coaches do slow tape this way (CHECK, from memory), so the 2 in 3 becomes "missed at speed", not a made-up limit.
2. **The evening trade isn't shown clearly yet.** It needs to say "+0.3, every bout from now on" against "+0.28 against this opponent, +0.4 once confirmed, and the plan line it unlocks", all in wins in 100.
3. **Two-film tells for fades and hurt habits are the depth, not unfair**, provided the first film says "Maybe: needs a second film or the corner minute". Real scouting watches several fights to see a pattern (CHECK). Even with two films only 50–55% of fades are found, so the first film's Maybe should say so plainly.

**To reach 10/10**
1. **Change how the check reads:** "full speed" against "frame by frame". Same numbers, but the coach no longer sees what the camera missed.
2. **Price the stop in wins, with how long each lasts.** Measure a confirmed tell's plan line rated Beats it against no plan line (1,000 bouts), and print it beside the weapon.
3. **Measure power into wins in the sim:** 1,000 even bouts at +0.28, +0.4, +0.9 and +1.2. First confirm in `BoutRules` whether the swing is per round or per exchange, and 0–27 or ±27.
4. **Price the TAPER rest night:** fight-night energy with and without it, in wins. If it's under 1 win in 100, make the TAPER film night cost the coach's sparring slot instead.
5. **Count the rest as at least 1** in the evidence test, and add a probe case where the rest rate is 0.
6. **Settle the weapon rule in the code** and make the stop show the edge this boxer actually gains, which may be 0.
7. **Update the constants:** `LOOKED_TRUE` to 0.85, add `MAYBE_ONE` 0.30 and `MAYBE_POOLED` 0.20, set the Fight prep labels to 30/70/85, and clear out the old v2 headers.
8. **Show trust words** (Sure, Likely, Maybe) in the figure, with the paid % on hover.
9. **Cap checks at films × 2 and at 6 an opponent**, so a full-time coach still has to choose.
10. **Add the one-film message**, then build FilmBout, re-run the probe on its real output (all 72 claims, 1,000 films, tiring boxers), and send to a second fresh critic.

**The 10/10 page (1920×1080, Look B: cream whiteboard, Permanent Marker headings, Kalam body text, colour only for risk)**
- **Header (y 0–90):** "<name> won on points · Film night 2 of 3" on the left. On the right, a chip reading "2 checks left · 6 for this opponent".
- **Left, at full speed (x 40–900):**
  - film thumbnails 1–4, with the chosen ones circled in marker;
  - the AFTER rows, such as "jab → right hand: seen 5 of 21, 10 not seen at full speed";
  - each row has one small "Frame by frame (20 min)" link.
- **Middle, the file (x 920–1440):**
  - claims marked Sure, Likely or Maybe (amber for Maybe), each with the % on hover;
  - "Not enough moments" in grey;
  - for fades on a one-film opponent: "Needs a 2nd film or the corner minute".
- **Right, tonight's stop (x 1460–1880):**
  - two cards side by side;
  - PADS: "one-two 27 → 31 · +1.7 wins in 100 · lasts";
  - FILM: "+1.5 wins in 100 against this opponent · plan line Beats it +X (measured)";
  - in a TAPER week, the pads card reads "Rest: +Y wins on fight night".
- **Bottom (y 960–1040):** one pulsing button, "Close the film", with nothing red unless a claim is about a hurt habit.

**Sources:** the scores and maths are DERIVED from the map's constants and recomputed by hand. The real-boxing scouting and slow-tape practice are CHECK, from memory. A measured win-rate for power and plan lines is NOT FOUND; it's the test in fix 3. I couldn't open `CRITIC_ACCESS.md`, the mockup images or the probe script while the owner's computer is offline.
