# DESIGN_WEIGHT2_V2_CRITIC_JOHN_JOHN - John answer (seat queue SQ280)

Brief: research/DESIGN_WEIGHT2_V2_CRITIC_JOHN.md
Sent: 2026-11-21 22:10 | collected: 2026-11-21 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): weight2_v2_10.html
Verify the sources before using it.

---

On it. First I'm checking WEIGHT2 v2's numbers against my WEIGHT2 research: the 0.9 regain share, the size fit, the miss slope and the probe-4 tables. Then I'll score it against the new bar of 8+ on DEPTH and 8+ on PLAY. Beast is still offline, so this will be a reading of the pack and map.

The WEIGHT2 v2 critic is underway. When it's done I'll post the logic check, then the full return with the page image, then the HTML file.

**Logic check for WEIGHT2 v2.** The arithmetic holds, but two numbers that decide the result aren't real-world numbers, and one of the mislabels came from my own memo.

- **Pro regain share.** 7.2 ÷ 8 = 0.90 checks out. But Murugappan & Reale 2022's 7.2 % is the body mass regained between weigh-in and fight night, not a share of the cut. The one measured cut-and-regain pair runs the other way: an 8.0 % cut and 11.7 % back, a ratio of 1.46 (Matthews & Nicholas 2017, 7 fighters). So the 0.9 share should be tagged DESIGN, not DERIVED.
  - It also gives the field a built-in edge. The field always rings 7.2 % over the line, but your boxer rings only 0.9 × the cut.
  - After a 4 % cut your boxer is still 3.6 % lighter than the field, and staying in class leaves 5.1 to 5.9 %.
  - At 3 wins in 100 per 1 %, that gives the field 11 to 17 wins in 100 before any decision. "Cutting pays as a pro" comes mostly from this.
- **Correction to my memo.** The maths behind the +3.05 is right, but Baribeau 2023's ×1.13 odds is per 1 % *regained*, not per 1 % heavier than the opponent. My memo relabelled it, and the map copied that and calls it "counted". The corrected tag is: size per 1 % of ring-weight gap is NOT FOUND, and 1.2 to 3 wins in 100 is an ESTIMATE.
- **Diet price.** The sums check: 2.5 % held keeps 0.70 over 3.57 weeks, and 5 % keeps 0.40 over 7.14 weeks. But the direction runs against Garthe 2011, where the 0.7 %-a-week group *gained* lean mass and strength. Lean should cost almost nothing, and the price belongs to Strip.
- **Miss slope, the biggest red flag.** 1.55 to 1.8 misses in 12 bouts means 12.9 to 15.0 % of scales. Real rates are 0.99 % for elite amateurs (Reale 2017, 1 boxer in 101) and 2.78 % for UFC men and 4.69 % for women. That makes the model 13 to 15 times the amateur rate, and the whole "an amateur shouldn't cut" result rests on it. In the bouts actually boxed, cutting wins as often as staying.
- **Cutting harder.** 65 ÷ 0.935 = 69.5 kg, which leaves 4.0 % of water after the diet. That is legal on England Boxing's 1-hour scale but past the safe line. Juniors may change only 300 to 700 g during the weigh-in (EB 7.1.14), so hard water should be locked for them.
- **Other checks:**
  - Moving down is dominated in every cell.
  - The refusal moves the ladder 0.6 points, which is noise.
  - Height follows the class limit, so size gets counted twice.
  - The growth sums are right: a 16-year-old boy outgrows a 5 kg gap in 1.54 years.
  - The same-day amateur scale is real (EB 7.1.3; World Boxing has 3 hours or more).

# WEIGHT2 v2: DEPTH 6 · GENERAL DESIGN 6 · PLAY 6
It's below the 8 and 8 bar, so it doesn't stay as written. This is a static reading: Beast is offline, so I couldn't open the code, the mockups or the probe outputs.

v2 is serious work. It follows one kilo from the diet to the ring, the dead `eat_kg` gets a job, and the cage goes. But inside one scale the class choice is solved once: never cut on a club scale, always cut as a pro. On top of that, moving down is dominated and the refusal has no bite.

**DEPTH 6.** There are three real levers on three time scales: the diet on Monday, the water in fight week and the class between bouts. Growth forces decisions over a career.
- Each scale has one right answer, and the player learns it once.
- The water call ignores the bout. It doesn't care whether it's 3 rounds or 10, or whether the opponent presses or counters.
- The opponent's weight is only a tape row. There's no plan line, no clause and no catchweight ask that uses it.

**GENERAL DESIGN 6.** It's one model with its deletions named, and the probe method is sound.
- The regain share and the size number are mislabelled, and the size one is my fault.
- The miss chance runs 13 to 15 times the real rate.
- The diet price runs against Garthe.
- The field gets back more weight than your boxer does.
- The boxer's frame follows the class limit, so size counts twice.
- The club's boxers don't age yet.
- The map caps the weight at one screen but its own menu table lists 11.
- **Words:** the map uses "he/his" for the boxer throughout and names in the body (Samira, Kira, Lucy, Josh, Tess, Danny). Screen copy should say "your boxer", for example "Box at 65 kg from the next bout: your boxer's answer".

**PLAY 6.** The scale moment, the round-3 cost of the water and the boxer's ask are all good beats.
- Monday's diet is set-and-forget.
- A miss is a 1-in-7 coin the player can't read.
- The class card comes rarely and has a solved answer.
- Nothing builds anticipation from week to week.

**Real boxing to use:**
- **Davis–Garcia 2023:** a 136 lb catchweight with a 146 lb fight-morning cap.
- **Canelo–Chávez Jr 2017:** a 164.5 lb catchweight with a $1M fine per pound over.
- **Garcia–Haney 2024:** came in 3.2 lb heavy on purpose ("Why would I force my self to make weight so I can be weak"), lost the title chance and forfeited about $600k (reported).
- **IBF:** a second weigh-in on fight morning.

**Missing and useless options:**
- **To add:**
  - **A rehydration clause on pro offers**, with accept, counter or refuse. It caps how much weight a boxer can put back on by fight morning.
  - **A catchweight ask**: a fee or a better split in return for meeting at an agreed weight.
  - **Come in heavy (pros only)**: pay 20 % of the purse and lose the title chance, but keep the strength.
  - **The opponent's weight story as a plan line**, such as "cuts hard, so push the pace late".
  - **The championship 3-hour scale.**
  - **The fight-morning check for title fights.**
- **To fold or cut:**
  - Fold "cut harder" into diet plus water, since it isn't a class move.
  - Give moving down an emptier ladder, or cut it.
  - Cut the tolerance-with-age line: there's no evidence for it and no ages in the code.
  - Drop the coach-slot nutrition plan and keep the bought one.

**Answers to the open questions:**
- **A class under the lightest and over the heaviest:** yes, one of each per sex.
- **The same-day scale:** yes, because it's the rule.
- **"Wait" is too cheap:** give it a clock. Each wait adds 10 to the next refusal, and the third becomes a goal with a deadline.
- **Make cutting depend on the bout:** use the number of rounds, the opponent's style, clauses, and your boxer's Stamina and Recovery.
- **What moving down should offer:** open places and a vacant belt on the lower ladder, or cut it.

**To reach 10/10, most important first:**
1. Use one regain rule for both corners: min(cut × r, clause cap), with r drawn per boxer from 0.8 to 1.5. Then re-fit without the −10.9 field offset.
2. Recalibrate misses: 1 % as the base, plus 3 points per 1 % past the safe line, scaled by Discipline, for 3 to 5 % at a hard cut. Most misses should come from a misread tolerance the player can see coming. Then run probe 5.
3. Put weight terms on pro offers: a contracted weight or catchweight, plus an optional fight-morning cap, using the S523 ask pattern. Show the promoter's answer before the press. This is the bout-to-bout decision the mechanic lacks.
4. Make the water call read the bout: cost × √(rounds ÷ 3), ×1.3 against pressure and ×0.8 against a counter-puncher. Add the opponent's weight tell as a plan line.
5. Fold "cut harder" into diet plus water.
6. Give moving down a reason (an open ladder, a vacant belt, weeks to a title shot), or cut it.
7. Make Lean almost free, and have Strip stop lean gains (gains ×0.5), charged only while the scale is falling.
8. Fix the size tags: an ESTIMATE of 1.2 to 3 wins in 100 per 1 %.
9. Take the frame from natural weight, not the class limit.
10. Make the refusal cost something on the ladder: if your boxer refuses a move up and then misses the scale, loyalty drops by 5.
11. Add a deliberate "come in heavy" for pros.
12. Give the club's boxers birthdays before growth ships.
13. Under 18, lock hard water and use EB's 300 to 700 g window.
14. Fix the words: no fixed he or she, and names only in headers.
15. Keep it to four places: the BODY card, the diet chip in the Week, fight week THE WEIGHT, and the Why.

**What the game can't do yet:** ages, offer terms beyond money and date, a second scale on fight morning, the 3-hour championship scale, a frame taken from natural weight, and the 3D body (after FIGHTPLAYER2).

**The 10/10 page:** fight week, THE WEIGHT, for a pro bout with a clause on the table.
- **Left:** the scale from natural weight down to the line.
- **Centre:** the water as None, Light and Hard, priced for 10 rounds against a pressure fighter.
- **Right:** the opponent's weight story and their cap ask, with accept, counter or refuse.
- **Button:** "SET THE WATER: HARD, COUNTER AT +6 %" is the only one that pulses.

The full text is in `/workspace/weight2/v2critic/WEIGHT2_V2_critic.md`.
