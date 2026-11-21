# JOHN_WEIGHT2_RESEARCH_JOHN - John answer (seat queue SQ278)

Brief: research/JOHN_WEIGHT2_RESEARCH.md
Sent: 2026-11-21 17:10 | collected: 2026-11-21 18:10 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): J_WEIGHT2_S535.md
Verify the sources before using it.

---

On it. I'll find counted numbers with a named source, sample size and year for all ten WEIGHT2 questions, and say plainly where none exist. I'll start with the cutting and regain studies and the federation weigh-in rules.

I've started the WEIGHT2 research. Every number will be tagged by how sure it is, and I'll end with game-ready numbers you can use in the weight mechanic. You'll get the full memo here when it's done.

**WEIGHT2 is done: 9 of the 10 questions have counted numbers from sources I opened.** The gaps are dehydration leading to stoppages (no direct study exists), the pro boxing miss-weight rate (UFC numbers stand in) and how much harder cuts get with age (there's only a growth-curve estimate).

The main finding: cutting weight costs stamina far more than punch power, and recovery time decides how much. Amateurs weigh in 1 to 3 hours before boxing, so they box carrying most of the cut. Pros weigh in 20 to 36 hours before, regain about 7% of body mass, and each 1% regained raises the odds of winning by 13%. Growth is the hidden driver: a median boy gains about one amateur class a year at 16 to 18.

**Caveats:**
- My count of champions who moved up is biased, so treat it as an upper bound.
- The CDC growth table came from an archive mirror.
- Three items are still unopened and tagged CHECK: the 2–5% youth cut, Nevada's 25% fine and the 4.4% amateur day-before regain.

Beast is still offline, so I can't land the memo or notify Claude yet; the full file is below.

# J_WEIGHT2_S535: real-world numbers for a weight mechanic
Tags: SOURCED (I opened it), DERIVED (my arithmetic on sourced numbers), ESTIMATE (my judgement), CHECK (cited, not opened), NOT FOUND.

**1. Performance lost per % cut.** How sure: medium. The studies are small (7 to 14 people) and there's no clean per-1% curve for boxing.
- **Repeat effort (SOURCED):** a 4.8% heat cut left repeat efforts 19% slower after 3 hours of eating and drinking, and still 14% slower at 24 hours (Barley et al., *JSCR* 2018, 14 MMA athletes).
- **Strength endurance (SOURCED):** a 3.2% cut meant 28% fewer reps after 3 hours, with peak strength unchanged (Barley, *Front Physiol* 2018, 14 athletes).
- **Punch force (SOURCED):** a 3% cut lowered it by 3.2 to 4.6%, which was not significant (Smith et al., *IJSNEM* 2001, 8 amateur boxers).
- **Meta-analysis at about 3% dehydration (SOURCED):** endurance −8.3%, strength −5.5%, anaerobic power −5.8% (Savoie, *Sports Med* 2015, 28 studies).
- **Combat athletes after regain (SOURCED):** back to normal after 3 to 36 hours. Just after the cut, the effect sizes were −0.29 for strength and −0.37 for repeat efforts (Brechney, *IJSPP* 2022).
- **Thinking (SOURCED):** attention −0.52 and coordination −0.40; reaction time showed no significant change. Losses above 2% are worse (Wittbrodt, *MSSE* 2018, 33 studies, 413 people).
- **Under 2% (SOURCED):** a loss this small is "unlikely to affect" performance (Reale, GSSI 2018).

**2. Regain after the weigh-in.**
- **Pro boxers, California (SOURCED, high):** +4.4 kg, which is +7.2%. One in five gained 10% or more (Murugappan & Reale, *Phys Sportsmed* 2022, 399 boxers).
- **Odds of winning (SOURCED, high):** each 1% regained multiplies the odds by 1.13 (Baribeau, *IJSPP* 2023, 1,392 boxers).
- **IBF title fights (SOURCED):** +3.8% with about 12 hours between weigh-ins, and no effect on results (Daniele 2016, 142 boxers).
- **Elite amateurs, 3 to 12 hours (SOURCED, medium):** men +2.1%, women +1.5%, no link to winning (Reale et al., *IJSPP* 2017, 100 boxers).
- **Amateurs, 1 hour: NOT FOUND.** ESTIMATE +0.3 to 1%.

**3. Dehydration and head injury: NOT FOUND** as stoppage or concussion rates.
- Sweating off weight enlarged the brain's ventricles in 10 teenagers (SOURCED, Kempton 2011).
- 60 to 70% of combat athletes said concussion symptoms got worse during a cut (SOURCED, Uddin 2022, 132 athletes). This is self-report, not injury rates.
- The measured risk is being the lighter boxer on the night: the weight gap predicts KO and TKO wins (SOURCED, Baribeau 2023).

**4. Safe cuts and the rules.** How sure: high on the rules, medium on what counts as "safe".
- **Expert guidance (SOURCED, Reale 2018):** a cut of at most 8% with more than 12 hours to recover, and at most 5% (no more than 3% by dehydration) with 6 hours or less.
- **Camp pace (SOURCED, Garthe 2011, 24 athletes):** losing 0.7% a week kept lean mass; 1% a week did not.
- **Boxers' last week (SOURCED, Reale 2017, 73 boxers):** they lose about 3.6%.
- **WBC (SOURCED):** at most 10% over the limit at 30 days, 5% at 14 days and 3% at 7 days.
- **IBF (SOURCED):** on fight morning, at most 10 lb over (up to 14 lb at cruiserweight).
- **BBBofC (SOURCED):** weigh-in 24 to 36 hours before. Title fights more than 3% over at 3 days need Board sanction.
- **England Boxing (SOURCED):** club weigh-in 1 hour before. At championships, at most 1 kg can be lost in the 2-hour window.
- **World Boxing (SOURCED):** a weigh-in every boxing day, at least 3 hours before, with no tolerance.

**5. Growth from 16 to 23.** Median weight gain from the CDC 2000 table (DERIVED; US population, not athletes):

| Ages | Boys, kg a year | Girls, kg a year |
|---|---|---|
| 16 to 17 | 3.6 | 1.2 |
| 17 to 18 | 2.6 | 1.0 |
| 18 to 19 | 1.9 | 1.1 |
| 19 to 20 | 1.4 | 0.9 |

- **Ages 21 to 23 (ESTIMATE):** about 0.5 to 1 kg a year.
- **Athletes (SOURCED):** elite female judoka gained 1.76 kg a year, about 1.6 times the median girl (Smaruj 2019, 12 athletes).
- **Cuts getting harder with age:** NOT FOUND directly.

**6. Moving up a class.**
- **Heavyweights (SOURCED):** pros who had boxed in lower classes were 19.9% less likely to win (Fiala, *IJSSC* 2025).
- **My count (DERIVED, biased):** 41 multi-class champions, title fights only, comparing their starting class with 2 or more classes up.
  - Wins fell from 94% to 74%.
  - KO share of wins fell from 69% to 53%.
  - Being stopped rose from 2.0 to 6.5 in 100 fights.
  - Read it as an upper bound. The per-boxer table is in the file.

**7. Size gap inside a bout.**
- **Fight-night weight (SOURCED):** the heavier boxer wins more (Baribeau 2023).
- **Reach (weak):** a 2-inch edge wins 58%, an 8-inch edge 65% (Fight Matrix blog 2008, not peer reviewed).
- **MMA height and reach (SOURCED):** do not predict wins (Kirk 2016, 474 fighters).
- **Amateur boxing:** NOT FOUND.

**8. Missing weight.**
- **Elite amateurs (SOURCED):** 1 miss in 101 boxers (Reale 2017).
- **Amateur rules (SOURCED):** under England Boxing and World Boxing a miss is a walkover.
- **UFC 2021 (SOURCED, a journalist's count):** men missed 2.8% of the time, women 4.7%.
- **Pro boxing rate:** NOT FOUND. ESTIMATE 1 to 3%.
- **Pro fines (SOURCED):** Ohio 20/25/30% of purse by how far over; Oregon and California 20%; Nevada 25% (CHECK). Under the IBF a champion loses the title on the scale.

**9. Walking weight.**
- **Pros:** about 7% over the limit on fight night (SOURCED). Between camps: ESTIMATE 8 to 15% over.
- **Amateurs:** about 3 to 5% over (ESTIMATE, based on the 3.6% they lose in the last week).

**10. Nutrition support costs (SOURCED from the providers' own pages).**
- **UK camps:** a 10-week camp costs £400 to £650 ($500 to $813), and 8 weeks costs £415 to £719.
- **UK consults:** a consult is £89 to £159, and a weigh-in night in person is £200.
- **US:** a consult is US$500 and an 8-week camp US$1,800 a month.

# What this means for the game (DERIVED or ESTIMATE as marked)

**A. The cut.** The first 2% is free. Each 1% beyond that costs:

| | Amateur | Pro |
|---|---|---|
| Stamina | −4% | −1.5%, or −3% past a 5% cut |
| Power | −1.5% | 0, or −1% past a 5% cut |
| Defence and reading | −1% | −0.5% |

- **Hard caps:** 5% for amateurs (above 3% by dehydration is marked unsafe), 8% for pros.
- **WBC checks:** fail at more than 10% over at 30 days, 5% at 14 days and 3% at 7 days.

**B. Regain.**
- Amateurs: +0.5% with a 1-hour weigh-in, +1.9% with 3 hours or more.
- Pros: +7% on average, and 1 in 5 reach 10%.
- Each 1% heavier than the opponent is about +3 wins in 100 at even odds.

**C. Missing weight.**
- Amateur: a walkover loss. ESTIMATE about 1% base chance, rising with the size of the cut.
- Pro: the bout goes on with a fine of 20%, 25% or 30% of the purse, and a champion loses the title. Two misses push the boxer up a class.

**D. Growth.** Use the table in section 5, times a per-boxer factor of 1.0 to 1.6. The cut a boxer needs grows every season.

**E. Moving up.** ESTIMATE, about half my biased count: KO share ×0.88 and stopped ×1.5 per two classes up. Moving up removes the cut penalties.

**F. Size.** Amateur weight gaps are capped by the class span (England Boxing). Reach is worth about +0.7 to 1 win in 100 per inch, from weak evidence.

**G. Nutritionist.** About $500 to $625 for an amateur camp and $875 to $1,250 for a pro camp. ESTIMATE: it halves the camp's stamina penalty.

The full memo, with source links, the 41-boxer table and the federation clauses, is in the attached file.
