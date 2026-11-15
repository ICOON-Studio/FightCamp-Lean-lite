# DESIGN_CLUBWEEK1_V8_CRITIC_JOHN_JOHN - John answer (seat queue SQ157)

Brief: research/DESIGN_CLUBWEEK1_V8_CRITIC_JOHN.md
Sent: 2026-11-15 04:10 | collected: 2026-11-15 04:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

On it. I'm checking CLUBWEEK1 v8's place maths and money against the critic pack first, then I'll score it. Beast is still offline, so `CRITIC_ACCESS.md`, the board and the mockups aren't open.

**Logic check.** I recomputed the place table, the money and the twists. Some numbers hold up:
- An ordinary week is 9 places asked against 9 owned, so FULL.
- One fight week is 10 asked against 9, so BAG 1.
- A class week is 9 asked against 6, so BAG 3.
- A class plus a fight week is SHORT 2, and a class plus two fight weeks is SHORT 4.
- Four boxers is BAG 3.
- The sponsorship's 4 × $250 is $1,000, and over a year 52 × $250 is $13,000.
- A class every week is 52 × $117, about $6,100.
- 28 covers at $130 is about $3,640.
- The fight week's 360 units against 720 is a 50% volume cut, inside Bosquet's 41–60%.
- The twist split is right: 7 reworded cards plus 9 kept makes the code's 16.
- The 10% pro share is the code's 25% minus the 15% manager part.
- There are no names outside headers and no fixed he or she.

Fourteen things don't hold or aren't stated:

1. **The table's two-fight-week row is wrong.** Need is 4 + 4 + 2 = 10 against 9 owned, so that week is **SHORT 1**, not BAG 2. The same error is in the IN 2 WEEKS example and the collision line ("BAG 2"). It breaks the map's own claim that "only stacked choices go SHORT": with a sessional coach, two fight weeks together always leave someone short.
2. **Two fight weeks together aren't rare (DERIVED).**
   - Amateur bouts only happen at club shows every other Saturday (GAME), so fight weeks can only fall in 26 of 52 weeks.
   - With 3 boxers at about 7 bouts each, a boxer has a fight week in about 27 in 100 show weeks.
   - At least two of three then share one in about 18 in 100 show weeks, about 9 in 100 of all weeks.
   - So SHORT comes from bouts alone about one week in 11, before any class is sold.
3. **Places have no per-night rule, and two features need one.**
   - The pad hours sit on three nights (Tue and Thu for Coach, Fri for You), 3 places each, and Want is "one per evening". A class on Thursday then takes all three Thursday places, so every boxer goes to bag that night.
   - **Lock can't do what its own example says.** "The class takes the 60 kg boxer's Thursday instead" only works if a hour holds fewer places than there are boxers.
   - **A fight week asks 4 places from 3 pad nights,** so one night must give the same boxer two places, or the film and plan night needs coach time outside the pad hours.
   - The Friday pad hour is also the weigh-in day for a Saturday show.
   - State whether places are pooled for the week or tied to a night, and whether one boxer can hold two in one night.
4. **"Place" is already two game words.** A roster place (premises "3 places", "+1 roster place") and a ranking place (take their place, $400 per place) both exist. The map even writes "+1 roster place, no places" on one card. A third meaning breaks one word per concept.
5. **The film night isn't pad rounds.** A place is defined as about 20 minutes of the coach on the pads, but a fight week's fourth place is a film and plan night. Either call it coach time, or give it its own counter.
6. **The class still pumps money, through members.** A class plus cover nets −$13 a week, but the class also brings about 1 new member in 4 weeks. That's about 13 members a year at $35 a month, worth far more than $676 a year in net cost. And cover is always on offer after a class, because the class itself makes BAG 3. Say whether the class's member raises the code's member target (capped by premises), or adds members directly.
7. **Coached mornings stack on the coach factor without saying so.**
   - In the code, every morning already runs at the coach factor (0.5 + rating × 0.7%: Luke Reid 0.91, Marcus Hale 1.02, no coach 0.6).
   - "Uncoached 1.0" isn't a state the code has, so 1.3 and 1.1 are either a pure bonus on top or a hidden cut to every other morning. Say which.
   - **Shared is beaten on totals.** Six solo mornings give +1.8, and six shared give +1.2. MORNINGS1's "each best in 30–70 in 100" is unlikely unless the headroom clamp bites.
8. **The day job is the biggest change, and it has no probe.**
   - Losing Tue and Thu takes about 2 of 5 training mornings from every unsponsored boxer: about 0.4 stat points a week before the headroom clamp (DERIVED from pace 1.0, a morning a fifth).
   - That runs into the pack's own measure: 5 points better in stats wins about 72 in 100.
   - It lands on every existing save, which has optional stipends today.
   - Nothing in section 9 measures it. The "28 bouts, +$31k, 80% close" figures aren't in the pack, so I can't verify them.
9. **Loyalty climbs on its own.**
   - FULL is the default week, and Want met gives +1, so every boxer gains about +50 a year and sits at Loyal.
   - No starting value or decay is given.
   - The talk then turns up only for a gym that sells classes, and LOYAL1's "2–4 a season" depends on that one choice.
10. **Loyalty does touch the corner.** Under 25, it costs morale −4 every Monday, and morale is the corner's trust (0.85 at Flat, 0.7 at Low). That contradicts "Loyalty never touches the corner".
11. **"The visible Coachability" doesn't exist.** The pack says traits are learned through the coach's notes, not shown as numbers. Showing Loyalty as a 0–100 bar is also a change to that rule, and it needs the owner's yes.
12. **Several twist answers are beaten by another option:**
    - **Heating breaks:** Run cold plus cover costs $130, which beats Fix it at $180.
    - **Old coach visits:** "Thank them" is never right.
    - **Southpaw in town:** at $40 it does what the $160 camp partner does, and the code rule is about sparring a southpaw, not pads.
    - **Visiting pro:** lists the injury cost but no gain.
13. **The later date can run out of time.** The offer has its own answer-by date (GAME), but the host's answer comes "with Monday's need". Say what happens when the answer-by falls before Monday.
14. **Small things:**
    - Pro camps of "4 or 6 weeks" aren't marked.
    - Rest up's 3 places and Train through's places (AMATEURWEEK1) aren't counted.
    - Amateur PEAK weeks (2 out: hardest, sparring twice) aren't on the table.
    - **Hold pads** lowers the club's total mastery (0.7 against a full place), and the holder's own evening is unstated.
    - **COACHFIT1 match:** if COACHFIT1 counts places plus coached mornings, the sessional coach matches its 8 (6 + 2). The full-time coach is one short of its 12 (9 + 2 = 11).

The John CHECK on pad rounds per boxer on a real club night isn't researched in this pass, so the 20 minutes stays an ESTIMATE.

I score CLUBWEEK1 v8 at depth 6, general design 5 and play 6, so it doesn't meet the owner's bar yet. General design needs 6+, and three fixes would get it there: one new word for "place", the corrected place table, and a per-night rule for places. Beast is offline, so I judged it from the critic pack and the map, without `CRITIC_ACCESS.md`, the board or the mockups.

## Scores

**Depth 6.** There are real trades:
- **Class:** $117 against bag nights for named weight classes.
- **Sponsorship:** $1,000 a block against mornings lost to the day job and loyalty.
- **At Accept:** cover, a later date, or take the bout.
- **The talk:** three answers, with different costs.

They connect to bouts, money, members and the pro share.

What holds it at 6:
- Coach's deal still decides most weeks (the map admits it).
- Solo mornings beat shared on totals.
- Lock can't work inside its own night geometry.
- Four of the seven twists have an option that's beaten or empty.
- Loyalty drifts to Loyal on a normal week, so the talk barely exists for a gym that doesn't sell classes.

**General design 5.** v8 answers every v7 point, keeps the code's twist deck, restores the code's rates, and marks every number. But at its core:
- "Place" is a third meaning of a game word.
- The two-fight-week row is wrong (it's SHORT 1).
- There's no rule for which night a place sits on, so Lock and the fight week's 4 places can't be built as written.
- The morning rates ignore the coach factor.
- Loyalty breaks two pack rules: it moves morale, and it needs traits shown as numbers.
- The day job, the largest gain change on the page, has no probe.
- It adds 5 modules, needs 4 owner answers, and no probe has run.

**Play 6.**
- The Monday board is a good ritual: stickies saying why, the NEXT WEEK line two weeks ahead, the collision line at Accept, and a reward line when a squeeze passes.
- But most weeks are FULL and one click.
- The day job only takes away.
- Loyalty rises by itself, so the player rarely feels a fighter wavering. The tension the map promises shows up mainly when the player sells classes.

## What each option changes, and verdict
| Option | What it changes | Verdict |
|---|---|---|
| Coach deals it / row order | Who goes to bag first | Keep; it's the default |
| Lock | Stops a class, photo or Hold pads taking one boxer's places | **Useless as written:** a class takes every place that night. Keep only with a per-night rule where an hour holds 2 boxers |
| Edit magnets / Back to Coach's deal | Hand changes | Keep as plain editing |
| PADS / CLASS per pad hour | +$117 and members, against 3 bag nights | Keep; the core lever. Route its member through the code's member target |
| Cover $130 | +3 places once a week | Keep; offer it only at SHORT, not BAG, or the class pump stays open |
| Pads volunteer $120 | +3 places at 0.8 every week | Keep |
| Rest week | Frees 3 places, +4 morale | Keep |
| Solo / shared / morning pads | Mastery spread against total | **Shared is beaten on totals** until it's rebalanced |
| Sponsorship give / renew / pass on / let end / stop | Cash, mornings lost to the day job, loyalty | Keep; "Renew" needs its own reason over "Give" |
| Talk: place back / promise / straight | Loyalty, places next week | Keep; straight can't print odds from a hidden trait |
| Hold pads | Loyalty +3 against less total mastery | **Weak:** worth it only to stop a −5. Say what the holder's own evening gives |
| Ask for a later date | Moves the bout 2 weeks, 1 in 2 | Keep |
| Twists | See check 12 | Fix Heating, Old coach, Southpaw, Visiting pro |
| Let a fighter go | Roster place now, −5 to team-mates | Keep |
| Saturday corner You / $100 | Who corners a clash | Keep; rare |

**Missing options**
- **Swap a pad hour's night.** Move Friday's hour off weigh-in night, so the fight week's sessions don't fall on the scale day.
- **A shorter class.** Half an hour as a class sells half the price and costs 1 or 2 places, not 3. It gives the money lever a middle step.
- **Lend the coach** to a team-mate's corner, or to film night, as its own choice. This separates film from pads.
- **A loyalty reason to keep a promise,** such as the bout a boxer asked for, linked to the goal talk the code already has, so promises aren't made up from nothing.

## To reach 10/10
1. **Rename "place" to "pad turn".** "Pad turn" is the coach's pad rounds for one boxer on one evening. Keep "place" for the roster and the rankings.
2. **Write the per-night rule.**
   - A pad hour holds 3 pad turns, one boxer per turn, and a boxer takes at most one turn a night.
   - A class takes a whole hour. Then Lock works only by moving the locked boxer to another night that has a free turn. Show that on the magnet, or cut Lock.
   - Move You's hour off weigh-in night (Wednesday).
3. **Fix the table, and the lines that copy it:**
   - Two fight weeks with a sessional coach is SHORT 1.
   - Change "only stacked choices go SHORT" to "two fight weeks, or any class week with a bout".
   - Correct the IN 2 WEEKS line and the collision line.
   - Run SHORTWEEK1 with bouts only on show Saturdays (DERIVED: about 9 in 100 weeks).
4. **Split the fight week:** 3 pad turns for the sessions, plus 1 coach evening for film and plan, counted separately. Count Rest up at 2 and Train through at 3 plus a sparring night, matched to AMATEURWEEK1's names.
5. **Write the coached morning as a multiplier on the coach factor.** Solo is ×1.25, shared ×1.15 each (2.3 against 1.25 per pair), so solo is focus and shared is spread at near equal totals. Every other morning stays at today's rate, so it's a bonus, not a cut.
6. **Give the day job a probe (DAYJOB1)** that reports stat gain and wins in 100 at 0, 1 and 2 lost mornings. Default to 1 lost morning until it runs, and ask owner question 3 with that table.
7. **Make loyalty move:**
   - Start at the trait's value.
   - Want met gives 0, and FULL weeks drift 1 point a week toward 60.
   - Short −5, again −8.
   - The talk's odds use a band the coach's notes reveal ("listens: usually"), not a hidden number.
   - Admit that under 25 touches morale, and say so on the bar's hover.
8. **Shut the members leak.** The class raises the member target by 4, capped by premises, and cover is offered only at SHORT.
9. **Fix four twists:**
   - **Fix the heating:** $120.
   - **Old coach visits:** "Ask them to corner Saturday" (+3 morale) instead of "Thank them".
   - **Southpaw in town:** one sparring night with a southpaw at $80, applying the code's round-1 rule.
   - **Visiting pro:** +1 tell of the boxer's own habit (the coach's notes), so it gains something.
10. **The later date:** the host answers inside the offer's answer-by date, or the offer is extended to the next Monday.
11. **Fix the small things:**
    - Mark pro camp lengths as an ESTIMATE.
    - Count amateur PEAK weeks.
    - Make Hold pads 0.85 and the holder's night a bag night.
    - Give the full-time coach 3 coached mornings, so COACHFIT1's 12 matches (9 + 3).
12. **Run probes 1–3 and DAYJOB1** under the pad-turn unit, then draw the page and get owner questions 1–4 answered.

**Real evidence:** amateur boxers in England aren't paid for bouts, so a day job fits the real sport. Bosquet et al. (2007, a meta-analysis) found the best results with an 8–14 day taper that cuts volume 41–60% and keeps intensity, so the code's 1-week fight week is at the short end. Both are from earlier reading, not reread today.

## The 10/10 page (1920×1080, Look B; FIGHTERS, CLUB WEEK)

**Shell (0–64 px):** dark top bar; CONTINUE reads "to Mon 9 Feb, the week review".

**Counter strip (64–170):** four magnets:
- PAD TURNS "Asked 10 · Need 8 · Owned 9 · BAG 1"
- COACHED MORNINGS "Solo 4 · Shared 2"
- SPONSORSHIP "1 of 3 · ends 2 Mar"
- RUNWAY "11 weeks"

Under them, the red marker line: "IN 2 WEEKS: two fight weeks, SHORT 1. Cover a night or ask for a later date."

**Left (40–440): the coach's week as a grid of 3 nights × 3 turns.**
- Tue and Thu belong to Coach, Wed to You.
- Each turn has a small face chip with the weight class.
- Each hour flips PADS or CLASS. CLASS greys its three turns and reads "+$117 · +4 member target · 3 boxers on bag Thursday", the turns are draggable between nights, and "move this hour to another night" is on hover.
- COVER only appears when the counter reads SHORT.

**Centre (480–1480): one row per boxer, the name once in its header cell, with the weight class.**
- The morale word, and the loyalty bar with its last cause ("+1 drift to 60").
- Up to two stickies (WEAK SPOT, WEAPON, GOAL, AHEAD).
- Seven morning cells (coached ones marked with your face or Coach's, WORK greyed with "Tue: day job").
- Evening magnets in solid PADS, hatched BAG and FIGHT WEEK. Fight week shows 3 turn magnets plus one FILM magnet on Coach's evening counter.
- Drag to reorder.
- The grappler's row last.

**Right (1520–1880):**
- The twist card with 2 priced answers.
- The talk card, its odds in words from the coach's notes.
- PROMISES OPEN with dates.

**Bottom (980–1060):** Back to Coach's deal, plus one pulsing gold "Start week". On a quiet week the page folds to the counters and "Same as last week". Hover on any BAG magnet: "half the mastery tonight, 1.05 an hour against 2.1".

**Stress state on the same layout:** a class on Thursday plus a fight week. PAD TURNS reads SHORT 2 in red, two rows show hatched Thursday magnets, and the class magnet lists the weight classes that pay for it.

## Sources
No new outside sources this pass. Every figure is DERIVED from the critic pack (4.1, 4.2, 4.3, 4.5, 4.13, S448, S451) and the map's own numbers.
