# DESIGN_CLUBWEEK1_V7_CRITIC_JOHN_JOHN - John answer (seat queue SQ135)

Brief: research/DESIGN_CLUBWEEK1_V7_CRITIC_JOHN.md
Sent: 2026-11-14 22:10 | collected: 2026-11-14 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading CLUBWEEK1 v7 against the pack now. The logic check comes first, then the scores, options, To reach 10/10 and the page.

# CLUBWEEK1 v7: critic

Scores: **depth 6/10, general design 5/10, play 6/10**. It **fails the owner's bar on general design.**

v7 answers all ten of Maria's points, cuts the build from 12 modules to 7, and adds the collision warning at Accept, which is the best addition in the map. Three faults still sink the design:
- a "place" is a whole 75-minute pad night, yet two of them fit into one coach hour;
- cover plus class makes free money;
- several pieces aren't defined: the job rota, the 12 twists' answers, and what "shared 0.8" is compared against.

Your computer is offline, so I couldn't open `CRITIC_ACCESS.md`, the board or the mockups. I judged from the map and the pack, and checked the taper evidence and the pro weight limits myself.

Names and pronouns: the body uses "the 65 kg boxer", "your coach", "the grappler" and "a team-mate" throughout. I found no person's name outside a header and no fixed he or she. "Eastside ABC" is a club, not a person.

## Logic check

**1. Two whole pad nights don't fit in one coach hour.**
- A pad night is 75 real minutes, which the code counts as 240 units (pack 4.2 and S448).
- The map has Coach's second hour hold pads for two boxers, "a pad night each": 150 minutes of pad nights inside 60 minutes.
- Real clubs work the other way. A boxer's evening is mostly bag, shadow and rounds, and the coach takes boxers on the pads a few rounds each in turn.
- **Fix:** a place is **the coach's pad rounds** inside a boxer's night, not the night itself.
  - A boxer with a place drills at the pads rate (2.1 an hour).
  - A boxer without one still trains that evening, at the heavy-bag rate (1.05, CODE).
  - So being SHORT halves mastery that night, using code numbers. "About a third less drilling" goes, and VOLUME1 gets simpler.

**2. Cover plus class is a money pump.**
- A CLASS hour pays +$117 and removes 2 places. "Cover a night" adds 2 places for $80.
- Sell a class and cover it, and you clear +$37 an hour with the same places. Do it on all four hours and that's about +$148 a week for nothing, so it's the dominant play.
- **Fix:** price cover at or above the class ($120 or more), or allow one cover a week, used only when the counter reads SHORT.

**3. MONEYFOUR2's target needs boxers who are always short.**
- "1 sponsorship plus 2 class nights stays level" means owned drops from 8 to 4, against a Need of 6. Someone is SHORT every week, so loyalty bleeds −6 a week.
- That makes the money probe test a club that falls apart.
- **Fix:** set the target at 1 class night (owned 6), and measure what loyalty and cash look like over 52 weeks.

**4. "Mornings" means two different things, and the job rota is never defined.**
- The coached mornings are a club pool of 6. The sponsorship gives a fighter "6 free mornings, no job rota".
- `JobRota` is wired on the Club week, and rows print "rota or sponsorship", but v7 never says what the rota takes away. From the wording, it seems a fighter without the sponsorship loses mornings to a job.
- Two words for one thing breaks the pack's "one word per concept" rule, and an undefined rule can't be built.
- **Fix:** write the rota as a rule, for example "no sponsorship: 3 mornings lost to work", or cut it and give the sponsorship a different benefit.

**5. "Shared 0.8" has nothing to compare against.**
- Mornings with no coach train "at the code's rate", which already includes the coach factor (pack 4.1). So a coached solo morning at ×1.3 is a pure bonus.
- If shared is 0.8 of that same rate, sharing is **worse than training alone**, and nobody would pick it.
- The 9.6 against 7.8 sum only adds up if shared counts as a bonus too.
- **Fix:** write each as "against an uncoached morning". For example solo +30% and shared +10% each. MORNINGS1 then has two real options.

**6. The Protect pin does what row order already does.**
- Coach deals in row order, and Protect gives Want first, taking the shortfall "in deal order".
- Dragging a row to the top does the same thing.
- **Fix:** keep one. Either the pin, which also locks that boxer's places against a class or borrow, or drag order. Not both.

**7. The fight week costs more coach time at half volume, and cuts too many sessions.**
- Two one-to-one sessions take 4 places (two whole coach hours) for 360 units. That's the main cause of shortages, and it rests only on ESTIMATE.
- Bosquet et al. 2007, a meta-analysis of 27 studies: the best taper cuts volume 41–60% **without** changing intensity or frequency, keeping frequency at 80% or more of pre-taper.
- Going from 3 pad nights to 2 sessions keeps 67% of the frequency.
- The same review found the best length was 2 weeks. The code's TAPER is 1 week after PEAK, which is fine to leave, since PEAK is the code's choice.
- **Fix:** 3 shorter one-to-one sessions (each about 120 units, 360 in all), each taking 1 coach slot under the fix in point 1. That keeps the extra coach time as the real cost of a fight week.

**8. Loyalty is a second mood meter.**
- Morale already moves on wins, losses, goals, rest and booking, and it sets how far the fighter trusts the corner (pack 3).
- Loyalty adds a second 0–100 meter, with its own "talk" and the fighter leaving.
- The pack lists loyalty as a trait that isn't on the board. The "leaves for a rival" rule is a small version of the rival gym's poaching, which is AGREED, NOT BUILT.
- The Low-morale loop break is a change to morale and doesn't belong in this map.
- **Fix:** say plainly that loyalty is the code's Loyalty trait shown as a bar, and keep morale for the fight. Move the loop break to a morale map. Write "leaves" as its own one-line rule, separate from the rival gym.

**9. The twist cards are named but not written.**
- 12 cards are named with no answers and no prices. "Another club asks a kilo" doesn't say what is asked.
- "The clock waits for an answer; with none, Coach picks on Monday" says two opposite things.
- **Fix:** write each card's 2–3 answers with prices, and keep the code's rule (no answer means Coach's pick on Monday).

**10. Ordinary weeks have almost no decision.**
- With 3 boxers, Need 6 against 8 owned is never short. A missed Want costs no loyalty, and Coach deals it.
- The only ordinary-week choice is the class night. That's honest, since a quiet week is one click.
- It does mean PLAY rests on fight weeks and money, so the class magnet has to print what it costs ("+$117: the 60 kg boxer drills at bag rate Thursday").

**11. The fourth start's 70 kg pro has no table.**
- Pro welterweight tops out at 147 lb (66.7 kg); 70 kg is super welterweight (154 lb, 69.9 kg).
- The code's world tables are lightweight and welterweight only, so a 70 kg pro has no ladder.
- The 60 kg woman fits lightweight (135 lb, 61.2 kg).
- **Fix:** make the male pro a 66 kg welterweight, or add a super welterweight table. Owner question 4 should cover the pro as well as the 57 and 75 kg amateurs.

**12. Things that hold.**
- The collision line above Accept, naming the weight class.
- Places, Need and Asked printed as words beside the colours.
- Class nights sitting beside the code's +$350, not replacing it.
- The sponsorship is the stipend, and a pro can't hold it (CODE).
- The 10% share when a fighter turns pro under 50 loyalty is the 25% minus the 15% manager part, which matches GYM_SHARE.
- The second club coach adds no places, which is true to the code's fitness classes.
- The fourth start sits beside the three existing starts instead of replacing them.

## Scores, with reasons

**Depth 6.**
- The real trade is coach time against money against loyalty:
  - a class night pays and leaves someone short;
  - two fight weeks on one show night leave a boxer SHORT, and the bout page says so before Accept;
  - the sponsorship costs $13,000 a year against loyalty and mornings.
- It reaches into the rest of the game: offers, camps, TAPER, perks through the pulls, the pro share, and the Why line.
- Held to 6:
  - cover plus class is a dominant money play (point 2);
  - ordinary weeks carry one decision (point 10);
  - sharing mornings looks dominated (point 5);
  - Protect duplicates row order (point 6).

**General design 5.**
- Good: marks on every number, probes with cut rules, 7 modules, a wiring table for every menu, words beside every colour, and no names or fixed pronouns.
- Held to 5:
  - the place unit can't happen in real time (point 1);
  - the arbitrage (point 2);
  - a money target that requires a broken club (point 3);
  - the undefined job rota and the two meanings of "mornings" (point 4);
  - unwritten twist cards with a contradictory clock rule (point 9);
  - loyalty overlapping morale (point 8);
  - a 70 kg pro with no table (point 11).
- Each is fixable, but together they mean the map can't be built as written.

**Play 6.**
- The NEXT WEEK line and the collision warning create anticipation two weeks out. The talk, with its odds and dated promises, gives Monday a person to deal with.
- A quiet week is one click.
- What's missing is a reward the player feels: nothing in the week review celebrates a squeeze handled well. The Why line "Short of pads in the fight week" only shows the downside.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Fourth start, Take over a club | A squad of 4 from day 1 | Keep, with a pro in a weight that has a table (point 11) |
| Coach deals it / Keep my changes | The default deal | Keep |
| By hand | Manual deal | Keep only if it beats Coach's deal by 4+ in 100 (probe 2) |
| Protect pin | Want first for one boxer | **Duplicates row order.** Merge (point 6) |
| Drag row order | Deal priority | Keep (or the pin, not both) |
| PADS / CLASS for each hour | 2 places or +$117 | Keep. The core lever |
| Cover a night ($80) | +2 places | **Dominant with CLASS.** Re-price or limit it (point 2) |
| Borrow a place | +1 now, −1 next week | Keep (probe 6) |
| Rest week switch | Need 0, +4 morale | Keep |
| Freed places | Give away or sell | Keep |
| Hold pads (Loyal 70+) | Gives a place at 0.7, +3 loyalty | Keep. Real club practice, useful only when SHORT |
| Solo or shared morning | ×1.3 or 0.8 each | **Shared is useless as written** (point 5) |
| Sponsorship give, renew, pass on, let end, stop | Cash against loyalty and mornings | Keep, once the rota is defined (point 4) |
| The talk: place back / promise / straight | Loyalty | Keep. "Straight" is the free option when no place is spare |
| Club twist (12) | One weekly trade | Can't be judged until the answers are written (point 9) |
| Accept with the collision line / Pass | Booking with the cost in view | Keep. The best addition |
| Rest up / Tick over / Train through | The fight-week bill | Keep. AMATEURWEEK1 shares it |
| Saturday corner (You / $100 mat coach) | Who corners a clash | Keep. Rare |
| Let a fighter go | Frees a place, −5 to team-mates | Keep |

**Missing options:**
- **A one-cover-a-week valve tied to SHORT,** in place of unlimited cover.
- **"Short night at bag rate"** printed on the row, so the price of a class night is visible in mastery, not just a word.
- **A Monday review line when a squeeze was handled** ("Two fight weeks, nobody short: +2 loyalty each"). That's the reward PLAY is missing.
- **The fight week as 3 short sessions,** true to keeping frequency up in a taper.

## To reach 10/10

1. **Redefine a place** as the coach's pad rounds inside a boxer's night. Without one, the boxer drills at bag rate (1.05) that night. Recount owned places from coach minutes, and re-run the shortage table.
2. **Close the arbitrage.** Cover costs at least as much as a class ($120 or more), or one cover a week, and only when SHORT.
3. **Rewrite MONEYFOUR2** around 1 class night (owned 6), and report loyalty beside cash over 52 weeks.
4. **Write the job rota as a rule** (what a fighter without the sponsorship loses) or cut it. Rename the sponsorship's "free mornings" so "mornings" means one thing.
5. **Write the morning rates against an uncoached morning** (solo +30%, shared +10% each, or similar), so MORNINGS1 tests two real options.
6. **Merge the Protect pin with row order.** If the pin stays, it also locks that boxer's places against a class or a borrow.
7. **Make the fight week 3 shorter one-to-one sessions** (about 120 units each, 360 in total), keeping frequency at or above 80% (Bosquet 2007), each taking one coach slot.
8. **Say what loyalty is in code** (the Loyalty trait shown as a bar), keep morale separate, and move the Low-morale loop break out of this map.
9. **Write all 12 twist cards** with 2–3 priced answers each, and use the code's rule: no answer means Coach's pick on Monday.
10. **Fix the fourth start's pro:** a men's 66 kg welterweight, or add a super welterweight table. Extend owner question 4 to cover the pro.
11. **Add the reward line** to the week review when a squeeze passes with nobody SHORT, and a Why line for the upside ("Full fight week: one-to-one rounds"), not only the downside.
12. **Run probes 1–3** under the new place unit, then settle the five CHECKs.

## The 1920×1080 page (Fighters > Club week, Look B whiteboard)

**Top strip (0–120):** four counter magnets, each a word plus numbers:
- PLACES "Need 6 · Asked 9 · Owned 8 · OK";
- MORNINGS "Solo 4 · Shared 2";
- SPONSORSHIP "1 of 1 · block ends 2 Mar";
- RUNWAY "11 weeks".

Under the strip, the NEXT WEEK line in red marker: "IN 2 WEEKS: two fight weeks on one show; Need 10 of 8: one boxer at bag rate twice."

**Left (40–440), COACH'S EVENINGS:**
- Four hour magnets, Tue, Wed, Thu (Coach) and Fri (You), each flipping PADS ("2 boxers on pads") and CLASS ("+$117, one boxer at bag rate").
- Below them, one COVER card ($120, "only when SHORT, 1 a week") and BORROW ("1 out: next week 7").

**Centre (480–1480), THE SQUAD, one row per boxer (the name once in its header cell), then:**
- the morale word;
- the loyalty bar, with its last cause in marker ("+1: full week");
- the WEAK SPOT / WEAPON / GOAL / AHEAD stickies;
- the week as night magnets: pads nights solid, bag-rate nights hatched and printed "BAG", fight-week nights split into three short sessions and printed FIGHT WEEK;
- the rest switch.

Drag a row to change deal order. The grappler's row is last, with the sponsorship and the corner clash only.

**Right (1520–1880):** the twist card with its answers and prices, the talk card ("Wants a word": three answers, odds printed on the straight one), and PROMISES OPEN with dates.

**Bottom (980–1060):** Coach deals it (default, "Same as last week" when quiet), Keep my changes, and Start week in gold.

**The stress state on the same page:** a class on Thursday plus two fight weeks. The PLACES magnet reads SHORT 2, one row shows two BAG nights, and the class magnet's price line names the weight class that pays for it.

## Sources
- Bosquet L., Montpetit J., Arvisais D., Mujika I., ["Effects of tapering on performance: a meta-analysis"](https://journals.lww.com/acsm-msse/fulltext/2007/08000/effects_of_tapering_on_performance__a.19.aspx), *Med Sci Sports Exerc* 39(8):1358–65 (2007). Read on 2026-11-14 from the abstract (the PubMed page returned a 429, so I read the journal page) and the [Far West Nordic summary](http://www.farwestnordic.org/articles/Effects%20of%20Tapering.pdf). MEASURED, from 27 studies:
  - a 2-week taper is best;
  - volume cut 41–60%, intensity and frequency unchanged;
  - frequency kept at 80% or more of pre-taper.
- WBC, [The professional boxing divisions](https://wbcboxing.com/en/the-wbc-presents-the-professional-boxing-divisions/), read 2026-11-14. OFFICIAL: lightweight 135 lb (61.235 kg), welterweight 147 lb (66.678 kg), super welterweight 154 lb (69.853 kg).
- Everything else is DERIVED from the critic pack (4.1–4.13, S448, S451) and the map's own numbers. The arbitrage arithmetic is $117 − $80 = $37 an hour.
