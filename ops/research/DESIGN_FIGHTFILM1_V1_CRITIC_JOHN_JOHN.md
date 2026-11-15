# DESIGN_FIGHTFILM1_V1_CRITIC_JOHN_JOHN - John answer (seat queue SQ192)

Brief: research/DESIGN_FIGHTFILM1_V1_CRITIC_JOHN.md
Sent: 2026-11-15 22:10 | collected: 2026-11-15 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score FIGHTFILM1 v1 as a fresh critic, starting with the coach's check maths and how a false read plays out. The owner's computer is still offline, so I can't open `CRITIC_ACCESS.md` or the mockup.

**Logic check.** I recomputed the mockup's numbers and the map's rules by hand. The owner's computer is offline, so none of this was checked against the code.

**These hold:**
- The jab line adds up: 9 landed, 14 blocked and 8 missed make 31.
- "36 lines of 164" is right: 31 jabs plus the 5 habit lines.
- Head 19 plus body 6 is 25. That matches the landed totals by round (10, 9 and 6, so 25 landed of 74 thrown).
- "That's her" on 5 of 31 passes the check rule: k is 5, which is at least 3, and the rest's rate is 0.
- "Nothing there" on 1 of 3 is correct.
- Section 1 traces every data source to a named file. Storing the beats once, so a watched, read and skipped round all log the same, is the right fix.

**What doesn't hold:**
1. **The list prints the answer.** Habit fires get their own amber lines that say the habit in words ("right hand drops"), and there's a Show habit lines picker. A player who filters her jabs sees the tell written out. Nothing else ever produces those lines (the mockup shows 0 of 58), so every claim that ends in one of them gets an unlimited contrast. Checks end up confirming what the screen already says, not searching for it.
2. **Some tells are free, unlimited and uncapped.** Her games and her best weapon are filed straight from the report at 70% with no check, and Watch the tape opens the same page outside film nights with no checks. So every opponent with tape gives three tells at 70% for nothing. That's already more than the coach's one a night.
3. **The best weapon uses two different counts.** FilmBout makes her best weapon the punch she throws most, but the report files the best weapon from her most landed punch, and the mockup says "the cross". In real boxing the jab is usually the most thrown punch, so "thrown most" would say jab for nearly every opponent. Use one count, landed clean.
4. **The report says what it promised not to.** Section 2.1 says the report's sentences never name a tell, but the mockup's sentence offers "File 'best weapon: the cross'".
5. **"0 of 58" doesn't add up.** She threw 74 punches and 31 were jabs, so her other punches number 43, not 58.
6. **The punch counts disagree.** Section 1 says about 9 punches or steps a side per exchange, which is up to 324 beats a bout. Section 5 and the mockup say about 160. Pick one number, because it decides how much storage tape needs and how often noise passes the check.
7. **Three of the claims can't be counted the way 3.3 counts.**
   - "She throws less" (after the last 30 seconds, round 1 or a body shot) is a rate over a window, not "THEN followed WHEN k of n times".
   - "She loses the exchange" is one result per 30-second exchange, not a punch.
   - 3.3 needs its own rule for these, such as her punches a minute inside the window against outside it, at a contrast of 1.5 or more.
8. **The confidence numbers change nothing.** Truth is fixed (the claim matches her file or it doesn't), and the map never says 50%, 70% or 90% affects edge, plan rating or corner trust. As written, they're labels. They also need measuring: run the rule over 1,000 generated films and check how often each word is actually right.
9. **Extra tells may be worth nothing.** The main gain over the coach is up to three tells instead of one. But FilmEdge is capped at `FILM_EDGE_MAX`, and neither the pack nor the map gives that value or `FILM_PER_ANSWER` (NOT FOUND). If the cap is about two answers, the third check pays nothing.
10. **The cost of a wrong read is misstated.** The map says changing the line costs one of the corner's "two instructions". The two-instructions limit is for shouts during a round. The corner minute has its own "change one plan arrow" job.
11. **One test is a rate, not a rule.** The test "a noise claim reaches That's her on a short film, and never on two" can't be guaranteed, because chance can repeat. Make it a measured rate instead, such as under 5% across two films.
12. **The live log contradicts the owner's ship-on rule.** It ships Off by default, but the owner's rule is that everything new ships ON.
13. **Owner writing rules (S412).** The pickers and claims fix one gender for every opponent ("her jab", "she lunges in"), and the map calls the player "he" ("what he has today"). Labels need to follow each opponent's gender, and the text shouldn't fix the player as he or she.
14. **The live log leaks tells.** If it shows habit fires in the warning colour, it hands out tells during the bout that the player never found on film.

I score FIGHTFILM1 v1 at depth 5, general design 6 and play 7, so it doesn't reach the owner's 7 and 7 bar. The idea is right and so is the plumbing: reading her tape yourself, a coach who checks the counts, and a corner minute that says whether you read her right. But the page shows the answer before you look for it, and three tells come free, so the checks are left with nothing to decide.

## Scores

**Depth 5.**
- **What earns it:**
  - Watching yourself against letting the coach watch is a real fork.
  - A false read costs a plan line in the ring and shows up as CLEARED.
  - A second film to reach 90% is a real trade against a night on the pads.
  - Two boxers sharing the coach's seats creates real pressure.
- **What stops it:**
  - Habit lines print the tell in words.
  - The report files games and the weapon free at 70%, and you can do that outside film nights too.
  - Watching yourself always finds as much as the coach or more, at no cost inside the game. So it always wins, and the only thing it costs is the player's own time.
  - The confidence figures don't change anything in the bout.
  - Extra tells may hit the FilmEdge cap.
- With 72 claims and 3 checks it looks like a search, but the screen has already narrowed it to one.

**General design 6.**
- **What's good:**
  - The best-traced map I've scored: every gap is named with its file.
  - It keeps one source for the beats.
  - It uses FilmTruth, which is built but not wired to anything yet.
  - It retires the Tape Room instead of keeping two film screens.
  - It has one golden-path test.
- **What costs points:** the faults in the logic check, mainly the weapon counted two ways, the uncountable rate claims, the punch count, the ship-on and gender rules, and the report naming a tell.

**Play 7.** Reading a rival's tape and hearing "you saw it right" in the corner minute is the detective version of "the plan is the star", and Punch by punch on your own bouts gives the player a reason to come back after every fight. It's held back because the search is too easy to feel earned.

**Real boxing.** Coaches do study an opponent's past fights for repeat habits (a dropped hand after the jab, a pull straight back, fading late), and counting services such as CompuBox count thrown and landed jabs and power punches per round. That's CHECK from memory; I didn't look up sources this round. I have no sourced figure for how often a read from tape turns out wrong (NOT FOUND). The usual advice is that one fight isn't enough and you watch several, which supports the second-film rule.

## Each option and what it changes
| Option | What it changes | Verdict |
|---|---|---|
| Watch it with the coach | Up to 3 tells, the player's pick, some risk of a false one | Keep; give it a real cost (below) |
| Let the coach watch | 1 tell in tape order, safe | Keep |
| SHOW ME pickers | What the list shows | Keep, but **drop Show habit lines** |
| Check it with the coach | Spends a check; the coach's word from the counts | Keep; add a rule for rate claims |
| File it | Seen tell, with a confidence figure | Keep; **make the figure mean something** |
| File from report (games, weapon), no check | 70% tell for nothing | **Useless as it is (free)**: make it cost one check |
| Next film | Second bout, checks carry over | Keep |
| Done for tonight | Unused checks are lost | Keep |
| Watch the tape outside a film night | Film and report open freely | Keep for watching; **no filing and no full punch list** |
| Your bout: Fix it on the pads | Habit-fix drill on the next pad night | Keep; it's actionable now |
| Pro stats: clean, range, rounds strip | Support the weapon, game and fade tells | Keep |
| Pro stats: pressing share | Repeats "her games by share" | **Cut** |
| Pro stats: singles against combos, accuracy by length | No tell or action uses them | **Cut**, or make "lands singles, misses combos" a tell with an answer |
| **Missing:** a reason for a FilmEdge value per confidence figure; a cost in the game week for watching yourself | | **Add** |

**The pro video stats in 2.1b, in short.**
- **Matter:** clean against landed, range, and the rounds strip. Each one feeds a tell the plan can answer.
- **Noise:** pressing share, because it repeats "her games by share", and accuracy by combination length, because nothing acts on it.
- **Right to leave out:** the prediction of who wins each round, and the per-punch power, quality and balance numbers. The sim doesn't make any of those.

**Should the live fight log exist?** Yes, but one line per 30-second exchange rather than one per punch. That would be about six lines a round: her game, who won, your shout and how it landed, and the fire of a tell you've filed. One line per punch is about 50 lines a round, and the player can't act on any of them (owner rule). Ship it ON, and let unfiled habits show only as plain punch results, never in the warning colour.

**Is three coach checks a night the right cost?** The number is fine, but checks aren't the real cost while the list gives the answer away. Once the habit lines are hidden, set checks by the coach's rating: 2 below 60, 3 at 60–79 and 4 at 80 or more. With today's coaches that gives Luke Reid (58) 2 and Marcus Hale (74) 3.

## Section 8 open points
1. **Checks:** set them by the coach's rating, as above.
2. **Let the coach watch:** yes, with a rating of 75 or more it opens two tells, in tape order. A good reader still beats it by choosing which tells.
3. **The 50% read when watching alone:** yes, but allow only one filed claim per night alone, and only when k is 3 or more on the visible counts.
4. **Rivals filming your boxer:** amateur rivals should wait for the small living world. But pros already have `ProRead` built, the opponent's corner waiting for your most thrown punch from your last two pro bouts. So for a pro, show now "their corner will wait for your cross", with Fix it on the pads beside it.

## To reach 10/10
1. **Stop printing the tell.**
   - Remove the habit lines and the Show habit lines picker.
   - Show what the tell does as a plain punch result, for example "R2 0:45 the other's cross lands to the head (her right was low)".
   - Have FilmBout also make "right low" moments from tiredness and missed hooks at a set base rate (P, about 1 in 15 of her punches), so the rest's rate is never 0 and the 3-times contrast means something.
2. **Charge for report tells.** Filing her game or weapon costs one check, and filing from Watch the tape outside a film night is off. Outside a night, the page shows the film and the report but not the full punch list.
3. **Give the confidence figure a job.** FilmEdge pays a filed tell's answer at its confidence: 50% pays half, 70% pays 0.7 and 90% pays the full amount. A line written on a filed tell is rated Works, never Beats it, until it's CONFIRMED.
4. **Price watching yourself inside the game week.** A coached film night you watch yourself takes the coach's evening, so that night's pad card can't run (in BUILD and PEAK weeks). Letting the coach watch is quick and keeps the pads, as today.
5. **Measure it.** Run the check rule over 1,000 generated films. Report how often "That's her" is right for a true claim against a noise claim, and set the filed figures to the measured ones. Publish `FILM_PER_ANSWER` and `FILM_EDGE_MAX`, and check that a third tell is worth something.
6. **One count for the weapon:** most landed clean (the `big` beats), both in FilmBout and on the report.
7. **A rule for rate claims.** For the time-window claims, compare punches a minute inside the window against outside it: 1.5 times or more is "That's her", 1.2 to 1.5 is "Maybe", and under 1.2 is "Nothing there". Count "loses the exchange" per exchange.
8. **Fix the numbers.** Pick one punch rate (about 160 or about 320 lines a bout) and fix "0 of 58" to 43.
9. **The report's sentences** describe only numbers and never offer File on a tell.
10. **Live log:** one line per exchange, ON by default, filed tells only in the warning colour.
11. **Checks by coach rating**, and a coach rated 75 or more opens two tells when left to watch.
12. **For pros,** add "what their corner will wait for" from `ProRead`, with Fix it on the pads.
13. **The writing rules:** labels follow each opponent's gender (her or him), and nothing fixes the player as "he".
14. **Rewrite the false-read cost:** a CLEARED tell uses the corner minute's plan-arrow change.
15. **Make the noise test a rate,** under 5% across two films.
16. **Re-probe,** then send it to two fresh critics.

## The 10/10 page (1920×1080, Look B: Fight prep > "Film night")
**Shell (0–64):** dark top bar, with a FILM NIGHT flag and CONTINUE.

**Header (64–150):** the opponent's comic portrait and name once, the bout ("club show, Mar 2026, won on points"), and on the right three sticky notes: "Film 1 of 3", "Coach checks: 2 of 3" as pips, and "Tonight replaces: pads (the one-two)".

**Left whiteboard (40–900)**
- **The film:** the past bout on the game's ring from the ringside camera, paused at R2 0:45, with play controls at 0.5x, 1x and 2x.
- **The timeline:** three rounds with grey ticks for the lines shown, plus the rounds strip of three judges' cards per round, the reasons on hover and knockdowns marked.
- **MARK A PATTERN** below on cream paper:
  - WHEN "her jab" and THEN "the other's counter lands";
  - the coach's handwritten word "That's her: 5 of 31 jabs, against 3 of 43 other punches";
  - Check it (the one pulsing button) and File it at 70%;
  - MARKED TONIGHT with each claim's counts.

**Middle (920–1400), THE PUNCHES:**
- SHOW ME pickers for corner, hand, punch, result (with Clean) and range.
- "36 lines of 164" and "landed 9 of 31, clean 2".
- Lines by clock with a corner dot.
- A thin divider at each 30-second exchange, naming her game.
- No habit colour anywhere.

**Right (1420–1880), THE REPORT:**
- thrown, landed and clean bars per punch;
- head against body;
- landed by round 10, 9, 6;
- landed by range;
- her games by share, with "File it, 1 check";
- her combinations with clickable times;
- three sentences from the numbers only.

**Stress state shown:**
- a "Maybe, watch another" claim on file at 50%;
- a "Nothing there" check;
- a filed tell from film 1 marked "looked again: 90%";
- Next film greyed with the hover "no checks left".

**Sources:** every game number above is DERIVED from the critic pack and the design map. The real-boxing points (tape study, CompuBox counting, the jab as the most thrown punch) are CHECK from memory. No web sources were used.
