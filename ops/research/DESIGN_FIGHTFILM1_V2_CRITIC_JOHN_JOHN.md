# DESIGN_FIGHTFILM1_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ194)

Brief: research/DESIGN_FIGHTFILM1_V2_CRITIC_JOHN.md
Sent: 2026-11-15 22:54 | collected: 2026-11-15 23:11 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'll score FIGHTFILM1 v2 as a fresh critic, starting with the section 3.4 probe numbers and the new check and payout maths. The owner's computer is still offline, so I can't open `CRITIC_ACCESS.md`, the mockup or the probe script.

**Logic check.** I recomputed the mockup's numbers and the map's maths by hand. I couldn't run `tools/film_check_probe.py` because the owner's computer is offline, so the probe numbers are checked against the map's own rules only.

**These hold:**
- **Punches thrown:** 31 + 18 + 12 + 9 + 4 = 74.
- **Landed:** 9 + 8 + 4 + 3 + 1 = 25. Head 19 plus body 6 is 25, the round totals (10, 9 and 6) give 25 of 74, and the range totals (11, 9 and 5) give 25 of 74.
- **Clean:** 8 in all. The cross's 4 clean meets the best-weapon rule (at least 3, and more than any other punch).
- **Their games:** 9 + 6 + 3 is 18 exchanges, and "boxes at range" holds 50%, over the 40% bar.
- **The jab line:** 9 landed, 14 blocked and 8 missed make 31.
- **The check:** 7 of 31 (22.6%) against 3 of 43 (7.0%) is 3.2 times, so it's a pass. 43 is now right (74 − 31), and 3 of 43 matches the 1-in-15 base rate.
- **The film-edge cap:** three tells at 70% pay 3 × 0.28 = 0.84, which is under the 1.2 cap.

**What doesn't hold, or looks wrong:**
1. **The check tells the player nothing new.** The count line already shows k of n and "after their other punches" for any filter. The coach's word is worked out from exactly those counts, so a careful player knows every answer before checking. A check is just a fee for filing; it doesn't buy information.
2. **A second film barely helps for the most common habits, which suggests the bar is set at the habit's own strength.** A punch habit goes from 57–69% found on one film to 58–71% on two pooled. Doubling the counts should push that far higher, unless the 3-times bar sits about where a true habit already is. With a base rate of 1 in 15 (6.7%), a habit that fires on about 15% of jabs lands near 22% against 6.7%, roughly 3.2 times. Near the bar, more film only pulls the result toward 50/50. The combination habit (62% to 92%) shows what a habit well above the bar does. That kills the "watch-list it for 90%" choice for the most common habits.
3. **The figures fit an average player, not the actual reader.** A reader's "That's her" on one film is right 91% of the time but pays 0.7. A guesser's on two films is right 79% but pays 0.9. A pooled Maybe is right 18% but still pays 30%.
4. **The probe covers only half the noise.** It tests 31 noise claims, but 72 claims minus the 9 true ones leaves about 63. The worst noise claim measured is 4.8% over two films, and the test asserts under 5% on 200 films. That's a margin of 0.2 points against a sampling error of about ±1.5 points, so the test will fail on many seeds.
5. **The fade check may assume steady output.** If FilmBout makes every boxer throw less as they tire (the game has a Tiring game and fatigue), "last minute → throws fewer" reads as a fade on boxers who don't have one. The probe's 3% noise for window claims holds only if output is flat (CHECK in the probe).
6. **Hurt habits need at least 3 hurt moments.** At about 2 a bout, most single films can't show k ≥ 3 at all. That matches the 23% figure, but the page should say "not enough hurt moments on this film" rather than "Nothing there".
7. **Checks reward having no assistant.** You with no assistant get 3 checks, but Luke Reid (58) gives 2, so letting your coach go buys film checks.
8. **Neither coach reaches the second tell.** It needs a rating of 75, and Marcus Hale is 74, Luke Reid 58. The pack names no coach rated higher (NOT FOUND).
9. **Checks are only scarce in a one-week booking.** With Marcus Hale, 3 coached nights × 3 checks is 9 checks a week against at most 4 films and about 7 real tells. Over a multi-week camp (pros, the nationals) checks run into the dozens, and the 1.2 film-edge cap stops paying after 3 answered tells.
10. **Neither side of "watch it yourself" is in wins.** In a TAPER fight week (light, three rest days, no sparring) a lost evening often costs a rest night or one light pad night. "0.28 power" also has no measured worth in wins (NOT FOUND). Without both numbers, it can't be shown that letting the coach watch is ever the better pick.
11. **When a confirmation pays is unclear.** A tell confirmed at a corner minute moves from 0.28 to 0.4 "on the night". The map doesn't say whether that applies only to the rounds after the confirmation.
12. **The wording is clean.** "Their" and "That's her / him" follow the opponent, and names appear only in the header. The example count line still says 36 lines where the mockup says 31 (minor).

I score FIGHTFILM1 v2 at depth 6, general design 7 and play 7. It clears general design but misses the depth bar by one point, so it doesn't reach the owner yet. Every fault I named in v1 is fixed. The tell is no longer printed, report tells cost a check, the confidence figure pays, watching yourself costs the evening, the noise check is a rate, and the figures come from a probe. But the screen still works out every check for free, a second film barely helps the common habits, and checks are plentiful outside one-week bookings. So the real decision comes down to filing what passes on screen until the checks run out.

## Scores

**Depth 6.**
- **What earns it:**
  - Watching yourself against letting the coach watch now has a price in the week.
  - Confidence figures that pay, plus Works becoming Beats it once a tell is CONFIRMED, link film to the plan and the corner minute.
  - Hurt habits needing two films is a real timing choice.
  - The Watch list is a good low-cost option.
- **What stops it at 7:**
  - The check repeats the counts already on screen, so it buys no information.
  - The pass bar sits near the habit's own strength, so more film doesn't settle punch habits.
  - With a full-time coach or a multi-week camp, checks outnumber the tells worth finding.
  - Neither side of the evening trade is measured in wins.

**General design 7.**
- **What's good:**
  - It's traced to code, with named constants.
  - It has three clear counting rules.
  - It retires the Tape Room.
  - The wording is clean, and the live log is right-sized and ships ON.
- **What costs points:**
  - having no assistant gives more checks than Luke Reid;
  - the 75 bar for a second tell that no coach reaches;
  - the probe covering half the noise;
  - a test that sits within its sampling error;
  - a pooled Maybe still paying 30%;
  - possibly the wrong output assumption for fade claims.

**Play 7.** Filtering a rival's jabs, seeing "right low 7 of 31", filing it, and then hearing "you read it right" in round 2 is the best moment this game's planning has. The risk is the tenth fight week. Once the player knows the routine (filter each punch type by each AFTER fact and file the top contrasts), it becomes a chore, and letting the coach watch takes over.

**Real boxing.** Coaches scout an opponent by watching several fights and noting habits (a hand that drops after the jab, how they react when hurt, fading late). Commercial punch counters such as CompuBox count thrown, landed and power punches per round. Both are CHECK, from memory. I found no published figure for how often a read from tape is wrong (NOT FOUND). The common advice to watch more than one fight supports pooling films.

## Each option and what it changes
| Option | What it changes | Verdict |
|---|---|---|
| Watch it yourself | 2–4 checks, your pick, the evening lost | Keep; **show the lost evening's price** |
| Let the coach watch | 1 tell in tape order, pads still run | Keep; **fix the 75 bar** |
| Over the seats, alone | One claim at 30% | Keep |
| SHOW ME (After, Range, Result) | Finding | Keep |
| Count line with "after their other punches" | Shows the check's answer | **Change**: show it only for what the camera saw (below) |
| Check it with the coach / Check it (1) | Files at the coach's word | Keep; **make it reveal counts the list doesn't show** |
| File it | A tell at its figure; FilmEdge pays at that figure | Keep |
| Watch list | A claim saved for the next film | Keep |
| Next / Previous moment | Jumps the film between shown lines | Keep |
| Next film / Done for tonight | Next bout; unused checks are lost | Keep |
| Rounds strip | Supports fade tells; your own bout's cards | Keep |
| Your bout: Fix it on the pads, "their corner will wait" | A drill on the next pad night | Keep; it's actionable now |
| **Missing:** a cap on checks per opponent; the evening's cost on the stop; "not enough hurt moments" as an answer | | **Add** |
| **Useless:** none left | | |

## Section 8 open points
1. **The AFTER facts:** keep them, but the visible counts are too exact. Show the AFTER fact only for punches the ringside camera sees clearly, about 2 in 3, while the coach's check counts every punch. Then the screen gives an estimate and the check gives the answer, so finding stays free and checking means something.
2. **20 minutes against the whole evening:** the shape is fair, but it's not priced. Put the cost on the stop ("Tonight's pads: one-two, +2.6 mastery, lost if you watch"). Measure two automated players over 1,000 bouts, one that always lets the coach watch and one that always watches itself. Letting the coach watch must win sometimes (a pad night that takes a move to Usable, or a rest night when tired).
3. **The 30% figure:** keep it for a one-film Maybe and for a read alone. Pay a pooled Maybe at 20%, as measured.

## To reach 10/10
1. **Make the check buy information.**
   - The list shows AFTER facts only for camera-clear punches (P, 2 in 3), and the count line says "seen: 5 of 21".
   - The coach's check counts every punch ("all of them: 7 of 31").
   - Probe again so a careful reader's precision from the visible counts sits around 75% and the check lifts it to the measured figures.
2. **Replace the 3-times bar with an evidence test,** so more film always helps. "That's her / him" when k ≥ 3 and k is at least the expected count (n × the rest's rate) plus 2 standard deviations (2 × √expected). Rerun 3.4 and check that two films lift a punch habit to 85% or more while noise stays under 3% on average.
3. **Cap checks per opponent, not just per night:** at most the opponent's films × 2 (P) across the whole fight week or camp. Say how many nights a camp gets.
4. **Measure the evening trade in wins:**
   - find what 0.28 and 0.4 film power are worth in wins over 1,000 bouts;
   - run the coach-watch and watch-yourself bots in TAPER weeks and in BUILD/PEAK camp weeks;
   - put the lost evening's mastery on the stop.
5. **Fix the coach table:**
   - with no assistant, 2 checks;
   - Luke Reid 2, Marcus Hale 3;
   - lower the second-tell bar to 70, or name the coach rated 75+ who can be hired.
6. **Pay figures by evidence:** one film 70%, two films 85% (the measured guesser floor is 79%), a one-film Maybe 30%, a pooled Maybe 20%. Pay the confirmed full 0.4 only from the round after the corner minute.
7. **Finish the probe:**
   - all of the roughly 63 noise claims;
   - FilmBout boxers who tire in round 3, to test fade claims;
   - assert an average under 3% and the worst claim under 8%, on 1,000 films with a fixed seed.
8. **Answer "Not enough hurt moments on this film (2)"** instead of Nothing there when n is under 3.
9. **Add a quick read to stop routine fatigue:** the coach's 20-minute watch also marks which punch types are worth filtering ("look at her jab and her hooks"), without naming the AFTER fact.
10. **Re-probe,** then send it to two fresh critics.

## The 10/10 page (1920×1080, Look B: Fight prep > "Film night")
**Shell (0–64):** dark top bar, with a FILM NIGHT flag and CONTINUE.

**Header (64–150):** the opponent's comic portrait and name once, the bout line, then three sticky notes:
- "Film 1 of 3";
- "Coach checks: 2 of 3" as pips, with "this opponent: 4 left this week" on hover;
- "Tonight costs: pads, one-two, +2.6 mastery".

**Left whiteboard (40–900)**
- **The film:** ringside camera, paused at R2 0:44, with Previous and Next moment.
- **The timeline:** grey ticks for the lines shown, and the rounds strip with the judges' reasons on hover.
- **MARK A PATTERN** on cream paper:
  - WHEN their jab, THEN right hand low;
  - "Seen on camera: 5 of 21 jabs, 2 of 30 other punches";
  - the coach's handwritten word after the check: "All of them: 7 of 31 against 3 of 43. That's her. 70%";
  - Check it (the one pulsing button), File it and Watch list;
  - MARKED TONIGHT with film 1 and film 2 columns, including a "Not enough hurt moments (2)" row.

**Middle (920–1400), THE PUNCHES:**
- SHOW ME pickers for corner, hand, punch, result, range, round, their game and after.
- "31 lines of 164, landed 9 of 31, clean 2".
- Columns for clock, punch, range, AFTER (blank when the camera didn't see it) and result.
- Gold dividers at each change in their game, and no tell colour anywhere.

**Right (1420–1880), THE REPORT:**
- clean, landed and thrown bars;
- head 19, body 6;
- by round 10/27, 9/25, 6/22;
- by range;
- their games, with Check it (1);
- combinations with clickable times;
- three sentences of numbers only.

**Sources:** all game numbers above are DERIVED from the critic pack and the map's own figures. The probe wasn't rerun because the owner's computer is offline. The real-boxing points are CHECK from memory, and no web sources were used.
