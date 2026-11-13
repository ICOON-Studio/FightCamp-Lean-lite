# ASKFIGHT_CRITIC_S447_JOHN - John answer (seat queue SQ48)

Brief: research/ASKFIGHT_CRITIC_S447_BRIEF.md
Sent: 2026-11-13 08:47 | collected: 2026-11-13 09:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

# ASK FOR A FIGHT v4 (S447): critic

Depth: **6/10**. Play: **6/10**. I wouldn't defend a 7 yet. The rules are much tighter than a lookup panel. But for two of the three things a player cares about, asking and waiting still come out the same, and the two cases that are supposed to prove the decision is real don't measure what the map says.

## 1. Logic check

**Case C's arithmetic is wrong.** A 4-1 boxer has already fought 5 bouts, so they can't be "3 bouts short of the nationals' 5". The probe still reports that nobody reaches 5 bouts by day 70. So either the probe counts bouts some other way, or C was played as a different boxer. Until that's fixed, C's chip ("The nationals' 3 bouts by Mon 16 Mar cannot be made") can't be trusted. C is also the only case where asking clearly buys something.

**Case E's labels contradict section 2.** For a ranked boxer, the step up is the nearest name above, which is Counter Cara, one place up. The probe calls her the sheet name and calls Press Pat, two places up, the step up. Under the map, Pat is a NAME YOU PICK, so the club gives up the $450. That means the measured 36% against 20% was played with the presser handed over for free. The gate was never tested in the one case built to justify it. Case E is also a dash in the cases table, so no season was ever played for it.

**The cases are at x1 and the map is at x1.25.** Every case row (A to G) comes from step teaching x1. The map ships x1.25, so the case answers below aren't the version being judged.

**The camp words have a gap.** The asked show is always 14 to 27 days away (shows run every 14 days). `camp_words` covers 21+ days and 8 to 14 days, but 15 to 20 days has no wording. "8 to 14 days: a PEAK camp" also contradicts pack 4.3, where Set camp needs 3+ weeks. The 7-day and under-7 lines can't appear until AMATEURWEEK1 lands.

**The Wait line doesn't match the pack.** It says "likely in 2 to 4 weeks… may leave time for a camp". Pack 4.5 says club offers usually come 8 to 12 weeks ahead, and only 2 to 4 weeks in the first hour. The probe used 2 to 4 weeks, so the measured Wait is a first-hour Wait. At 2 to 4 weeks, a camp is only possible at 3 to 4 weeks, so "may leave time for a camp" is often false. This mismatch is also a direct cause of the flat results (section 2).

**"Ask for the show after" has no rule for a second miss.** If that show's forecast also misses the scale, the map doesn't say what happens. It needs to say "no makeable show in the next 4 weeks: Wait", with no button.

**Section 6 is wider than section 5.** Section 6 shows "Ask for a bout" on each fighter with nothing booked. Section 5 closes it before the first bout, for pros, for BJJ, during the nationals, for injured or suspended boxers, while a sheet offer is unanswered, and for 10 days after a bout. Pack section 6 also still says "Ask for a fight (always, once a boxer is signed)". That line has to change to "once a boxer has fought".

**Case D's mood is in the wrong band.** "Near the bottom of Steady" doesn't match morale 35, which is Flat. Morale was also held fixed through the season, so D's mood trade was never measured.

**The Fighters wiring says "row".** S410 made the roster cards first, so the button belongs on the card as well as the table.

The rest is legal at that moment. The host says yes only to legal asks. Missing answers are absent, not greyed. A NAME is above or level only and only from 4 wins. The gate line appears only on a paid name. RankLine sets every "a win passes" claim.

## 2. Depth: 6/10

| Case | My pick | One-word lookup? | Always or never best |
|---|---|---|---|
| A, 1-0 | For record, the card with the better chance band (PLAN is clear). For growth and safety, the sheet name. | Yes. The chance band decides record, and the teach word decides growth, at x1. | The map's "step up" guess doesn't win anything here at x1. Not re-measured at x1.25. |
| B, 6-1, 3rd | Step up for record and growth, sheet for safety. All within noise. | Not needed: every answer is close. | No paid card is legal, so it's a free choice that barely matters. |
| C | Ask the sheet name (growth and safety, both clear). For record, waiting is better (−0.71 against −0.94). | No: the bouts chip and the record cost pull opposite ways. | The only real trade on the table, but the case is broken (section 1). |
| D, morale 35 | Sheet name for safety (clear). PLAN for record. | The stoppage word, the chance band. | Mood wasn't moved, so the "no reason to pay" claim is untested. |
| E | The presser, if the plan rates "Beats it". | Two steps: the style word, then the plan's rating against that style. That's the skill the game wants. | Not measured as a season, and the gate was never paid (section 1). |
| F | Wait, or the show after. | Forced by the strip. | Not a decision. |
| G | The nearest better record for record (+1.0 over the sheet). The sheet name for growth. | The chance band. | The unranked "better record" card can be the softer fight, and the label is now honest about that. |

Across the 60 fighters, no answer is always best. ASK_PLAN is never best for safety (0 of 60) and almost never for growth (4 of 60). The paid card earns its place only for record. For any single goal, the decision is a lookup: chance band for record, teach word for growth, stoppage word for safety. The only real decision is which goal counts this week, and nothing on the panel or in the game says that.

**Is flat record and safety a flaw? Yes.** The panel's main fork, ask or wait, does nothing for 39 and 49 of 60 fighters. Changing the wording won't fix that. The cause is how the probe set things up: the ask's 14-day lead lands where a 2 to 4 week sheet lands, every opponent sits within a few rating points, nobody had a camp, and mood, members and ladder places weren't scored. These mechanic changes would fix it:

1. **Make Wait a camp trade, not a coin flip.** Give the sheet the pack's 8 to 12 week lead with a full camp: the camp edge (+0.25, +0.6 or +1.0 by intensity) and the chance of PEAK CAMP. An asked night 14 to 27 days out gets a short camp or none. Then asking means a fight sooner on worse form, and waiting means a fight later and better prepared. Record and safety would split on that. The probe has to fight with camps to measure it.
2. **Let time without a fight cost something.** The game already has "a month without a fight −6" morale and "bout booked +5", and morale is how much the boxer listens to the corner (Low takes in 0.7). Score that over the season, plus members (+8 for a win). Then waiting has a real cost, and asking has a real gain for a fighter who is losing interest.
3. **Score the ladder, not just wins minus losses.** A place moves only when a boxer beats someone above them. Score RECORD with RankLine places and the road to the pro offer (top 3 with 7 wins). Then a step up pays in places and a soft name pays nothing, and the record player has a reason to choose.
4. **Check that x1.25 isn't tuned to one setup.** It was set to sit exactly on both bars, on one seed and one division, where the standard error is about 0.3. Re-run it on 3 seeds and the men's division before calling it settled.

## 3. Play: 6/10

The ask opens 10 days after a bout and books about 2 nights in 70 days per fighter. With a gym of 3 to 5 boxers, that's an ask every week or two, which does fill the empty Fights page. But while asking and waiting come out the same, the press is a formality for most fighters: it buys a known date, not a better season.

**Missing:** the plan's rating on each card, which E depends on. The game already rates answers as Beats it, Works or Walks into it in the Playbook. Also missing: the camp trade on the Wait line, morale over time, and the ladder place a win would earn.

**Useless:** the 7-day and under-7 camp words until AMATEURWEEK1 lands, a nationals chip built on C's broken count, and Ask buttons on fighters that section 5 closes.

The cuts in section 8 are right. Don't bring back favours, a date picker or host refusals.

## 4. Options and the menu table

| Option | Verdict | What it changes |
|---|---|---|
| Sheet name | Keep | A free, known date |
| Step up (ranked) | Keep | +25% teaching and a chance at a ladder place |
| Nearest better record (unranked) | Keep, honestly titled | It can be the easier night (G) |
| A NAME YOU PICK, above or level | Keep, but unproven | Costs $450 to choose the style. Never tested with the gate paid. |
| Wait | Keep, rewrite with the real lead time and the camp trade | Today it's an even coin flip with asking |
| Show after (scale miss or a teammate's slot) | Keep; add the rule for a second miss | The only legal later date |
| Plan rating on the card | Missing | Makes E a reading of the plan, not a hidden oracle |
| Ladder line ("a win passes X") | Keep, from RankLine only | Gives the record player a reason to pick |

- **Fights page:** right place, easy to find. Show Ask only when section 5 allows it; otherwise show the reason and the day it opens.
- **Fighters:** put the button on the S410 card's next-fight area as well as the table.
- **Home, DO NEXT:** fine when it's open and a goal wants a bout.
- **Calendar:** unchanged booking.
- **Money:** "$0: the host kept the gate" is a record of a choice already made. Fine.
- **Result page:** "What it taught" is fine. Name the stat as Ring IQ until the rename.

## To reach 10/10

1. **Fix the two proof cases.** Make C a boxer who really is 3 bouts short (for example 1-1 on day 40). Play E with Counter Cara as the step up and Press Pat as the paid A NAME, with the gate taken, over full 70-day seasons.
2. **Build and measure Wait as a camp trade.** Give the sheet its pack lead (decide 8 to 12 weeks or 2 to 4 weeks, and make the pack and code match), and run the probe with camps and PEAK CAMP. Ship it only if record or safety stop being even for most fighters.
3. **Score morale, members and ladder places in the probe** (−6 for a month without a fight, +5 booked, −12 for a loss, +8 members for a win, RankLine places).
4. **Re-run cases A to G at x1.25,** on 3 seeds and the men's lightweight division.
5. **Put the plan's rating on each card when the style word is known** ("Your plan: Beats it / Works / Walks into it", from the Playbook's own rating), never as a total.
6. **Fix the camp words.** Cover 15 to 20 days, and drop "PEAK camp" below 3 weeks unless the camp rule changes.
7. **If the show after also misses the scale,** say so and show no button.
8. **Wire every entry point to section 5,** and change pack section 6 to "once a boxer has fought".
9. **Fix case D's morale or its wording** (35 is Flat), and move it during the season.
10. **Keep the raw-facts rule:** no best badge, no added-up score, no "what a win leaves".

### My 10/10 panel at 1920×1080 (Fights page, whiteboard, no pop-up)

- **Rail and top bar:** as they are. The main pane is a whiteboard for one boxer.
- **Top strip, full width, about 140 px:** the boxer's comic portrait, name, record, and place (or "unranked: enters at 4 wins"). Then the show date circled in marker with the days to it, and the camp line in the camp screen's own words. Then weight now, the limit and the forecast for weigh-in day, plus the "Weight at risk" chip. Then one road chip: bouts and the entry day, or "cannot be made from this show", or the place and wins needed for the pro offer. On the right: the teammate or scale-miss reason, when one applies.
- **Three cards across, about 560 px each:**
  - **Sheet name:** polaroid face, name, club, record, place, style word. Chance band. Plan rating against that style. Teach word. Stoppage word. "A win passes X" when RankLine says so. "Gym keeps $450". Ask button.
  - **Step up, or nearest better record:** the same layout, with the title saying what the card is.
  - **A name you pick:** a short list of names above or level, each line with its style and plan rating. The chosen name gets the full card facts. "$0: the host keeps the gate". Ask button. If no name is legal, the card is gone.
- **Wait, a full-width line under the cards:** "Next sheet: likely in [the real lead], date unknown. [Time for a full camp, or not]. A month without a fight costs mood." Then either a "Wait for the sheet" button, or "Ask for the show after, [date]" with that date's forecast.
- **After the fight:** the result page's "What it taught" in words with the stat's change. The Money page line only for a picked name.

**Bottom line:** fix C and E, add camps and morale to the probe, and re-run before drawing anything. If record or safety stops being even for most fighters, this is the board to draw.
