# DESIGN_CLUBWEEK1_V8_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ158)

Brief: research/DESIGN_CLUBWEEK1_V8_CRITIC_MARIA.md
Sent: 2026-11-15 03:10 | collected: 2026-11-15 03:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give CLUBWEEK1 v8 **DEPTH 7, GENERAL DESIGN 6, PLAY 6**, so it clears the owner's bar for the first time. The big fix is the unit. A place is now the coach's pad rounds inside an evening, and an evening without one is a bag night at the code's heavy-bag rate. So an ordinary week with a sessional coach and 3 boxers is FULL at today's volume, and shortages come only from choices: a class, fight weeks, a fourth boxer, a twist.

v8 also does these:
- It closes the class and cover money pump (now −$13).
- It makes CLUBWEEK1 the one owner of the coach's week.
- It uses Energy, not Tank.
- It keeps WeekTwist and rewords 7 cards.
- It moves the fourth start out.
- It asks the owner about leaving and the 10% share.

It stays at 6 for three reasons:
- The pad-hour counts (2 and 3) and a second class an evening are both unconfirmed CHECKs, and the whole count rests on them.
- The day job is a new penalty on the built stipend.
- Two new ideas appear without a probe or an owner line: a fight week costing 4 places, and Lock.

## Scores

**1. DEPTH: 7/10**

What works:
- **Selling a class is now a clean fork.** +$117 turns 3 places into bag nights, and the magnet names the weight classes that pay ("60 and 75 kg boxers go to bag"). A class on a fight week is SHORT 2, which costs loyalty. Money against training, every Monday, in the game's own units.
- **The valves are each priced differently:**
  - cover at $130, once a week, only at BAG or SHORT;
  - the pads volunteer at $120 for 3 places at 0.8 of the pads rate;
  - full-time hire for 12 places;
  - a later date at a collision, about 1 time in 2;
  - a rest week.
- **The fight week is real taper practice.** 3 one-to-one sessions at half volume with frequency kept fits Bosquet 2007, and the extra place for film and plan makes a bout cost the club coach time.
- **Loyalty now bites:** Need met gives 0 and short gives −5, then −8. Tell it straight has a real trade (no place given, +6 or −4 on visible Coachability) against giving a place back, which names the team-mate who drops one.
- **Passing on the sponsorship now costs the giver −3,** so it's no longer free.

What holds it back:
- **Coach's deal will be the default almost every week,** and the map accepts that. The deal's own levers (row order, Lock, editing) are thin. Most of the depth lives in class, cover and the talk.
- **Solo against shared mornings (1.3 against 1.1 each)** is a small sum. Shared gives 2.2 against solo's 1.3, so shared wins on total and solo only when one pull matters. That's solvable once per gym.
- **The day job's 2 lost mornings is the only reason the sponsorship matters for training.** If the owner says no to question 3, the sponsorship becomes loyalty only and one of the four scarce things goes soft.

**2. GENERAL DESIGN: 6/10**

What works:
- Every critic point has a row.
- One word list: place, bag night, coached morning, WORK, fight week, Energy.
- The counter's four words with colour only repeating them.
- Every price is tagged ESTIMATE, CODE or REAL.
- Five rule modules.
- A quiet week is one click.
- Names appear only in header cells, and no fixed pronouns.
- The menu table is complete.
- The held list is gated by probes.

What fails:
- **The pad-hour counts are the foundation, and they're CHECKs.** Sessional 2 and full-time 3 pad hours, 20 minutes a place, 3 places an hour are all estimates. If the code has no pad-hour count, these are new design values the code must adopt (the map's own risk). Then "an ordinary week is FULL" is a design choice, not a finding.
- **The day job changes a built system.** The stipend (CODE) is optional money today. The map turns not paying it into 2 lost mornings a week for every unsponsored amateur. That cuts training for most boxers by default unless the club pays $250 a week each. It's a bigger nerf than v7's bag nights, and it's only owner question 3. With MONEYFOUR1's "4 sponsorships close 80% of gyms", most players will run unsponsored boxers on 5 mornings.
- **A fight week costing 4 places, and Lock, are new and unprobed.** TAPER1 tests volume, not the 4-place cost. LOCK1 is listed but Lock isn't an owner line, even though it changes who goes to bag.
- **The coached-morning count of 6 (You 4, Coach 2) is invented** and overlaps COACHFIT1's budget. CHECK 7 covers places, not mornings.
- **The twist rewording adds new prices:** heating $180, southpaw $40, photoshoot +$150, gym rental +$60. That's fine, but "Visiting pro: injury ×1.15" leans on an AMATEURWEEK1 rule that isn't built.
- **The Fight night Why line "Short of pads in the fight week"** depends on a bout effect from bag nights. The map doesn't say what a short fight week does on fight night beyond mastery.

**3. PLAY: 6/10**

Each week has a clear beat:
- the counter reads FULL, BAG or SHORT;
- the NEXT WEEK line warns two weeks out;
- the class is a temptation;
- a collision shows at Accept;
- the talk gives a fighter a voice.

The reward line ("Two fight weeks, nobody short: +2 loyalty each") finally gives a positive beat for handling a squeeze. Quiet weeks stay one click. But the gain is still mostly avoiding bag nights and loyalty loss. The only visible upside is cash from classes.

## Options: missing, useless, and what each changes

**Missing**
- **A cheaper middle on the day job:** pay half the stipend ($125, ESTIMATE) for 1 lost morning instead of 2, so sponsorship isn't all or nothing. Many real amateurs work part-time around training.
- **A fight-week Rest up option on the Club week itself** (2 sessions, 3 places), so the player can trade the taper for a place when two fight weeks collide. The map leaves it to AMATEURWEEK1.
- **The bout effect of a short fight week,** printed on the collision line ("a bag night in the fight week: about −1 in 100", ESTIMATE). Without it the player can't price SHORT against cover.
- **A way to buy a place for one boxer from the volunteer only in fight weeks,** instead of every week.

**Useless or near-useless**
- **Editing magnets by hand:** expected under 4 in 100 against Coach's deal, so it's kept but not taught. That's fine, but it doesn't belong in the decision table.
- **Old coach visits, "Thank them: nothing":** a free +3 places is always taken. Give the visit a price (a night of your Monday talk, for example).
- **Southpaw in town, "Pass":** with a booked southpaw opponent, $40 for a lifted round-1 penalty is always right. Without one, the card shouldn't come.

**What each option changes**
- **Coach deals it:** Want dealt in row order.
- **Drag row order:** who gets places first.
- **Lock:** one boxer's places can't be taken by a class, the photo twist or Hold pads.
- **Edit magnets:** move one night between rows.
- **PADS or CLASS on a pad hour:** 3 places, or +$117 and about 1 member in 4 weeks.
- **Cover:** +3 places for $130.
- **Pads volunteer:** +3 places a week at 0.8, $120 a week.
- **Hire full-time:** places 9 to 12, wage $450 to $1,090.
- **Rest week:** Need 0, +4 morale.
- **Freed places:** give to a row or sell as a class.
- **Hold pads:** a team-mate trains at 0.7, and the holder gets +3 loyalty a week.
- **Solo morning:** 1.3 for one boxer.
- **Shared morning:** 1.1 each for two.
- **Morning pads:** one place at 0.8, using up that coached morning.
- **Sponsorship give, renew, pass on, let end, stop:** +5, +2, +5 and −3, 0, −8 loyalty. It also returns or loses the 2 WORK mornings.
- **Give the place back:** +4, and a team-mate drops a place.
- **Promise:** +5 kept, −12 broken.
- **Tell it straight:** +6 or −4 on Coachability.
- **Twist answers:** the priced trades in 3.9.
- **Accept with the collision line:** commit to BAG or SHORT.
- **Ask for a later date:** the bout 2 weeks later, about 1 time in 2.
- **Saturday corner:** you, or a $100 mat coach.
- **Let a fighter go:** frees the roster place, costs the block or a week, and −5 loyalty to each team-mate.

## To reach 10/10

1. **Settle CHECKs 1 and 2 before anything else.** If the code has no pad hours, write "places are a NEW design value" and put "a sessional coach gives 2 pad hours" to the owner beside question 2.
2. **Soften the day job and make it an honest owner question:** "Without sponsorship, a boxer works and loses 2 mornings (or 1 at half sponsorship). Yes?" Add the half-sponsorship tier at $125, ESTIMATE.
3. **Print what a short fight week costs on fight night** on the collision line and in the Why, measured by TAPER1. Then SHORT against cover against later date is a priced choice.
4. **Put the coached-morning count under CHECK 7 with COACHFIT1** so both maps read one count of places and mornings.
5. **Add the fight week's 4 places and Lock to the owner questions** in one line each, since both change who goes to bag.
6. **Fix the free twist answers:** give Old coach visits a cost, and only draw Southpaw in town when a southpaw is booked or in the region.
7. **Offer Rest up on the Club week in fight weeks** (2 sessions, 3 places), so the player can trade the taper.
8. **Move "edit magnets" out of the decision table into plain editing,** and keep the table to choices that pass the cut rule.
9. **Run probes 1, 3, 4 and 7 (SHORTWEEK1 and LOYAL1, VOLUME1, TAPER1, MONEYFOUR2) and paste the tables.** If MONEYFOUR2 shows a class every week is always right, raise the class's member cost or cut its price.
10. **Make solo mornings matter,** for example solo coached counts double toward a WEAK SPOT pull, so solo against shared isn't a one-time sum.

**My 10/10: Fighters > Club week, 1920×1080, Look B whiteboard**
- **Dark top bar** with CONTINUE "to Mon 9 Feb, the week review".
- **Top strip (0–120), counter magnets with words:** "PLACES Asked 10 · Need 8 · Owned 9 · BAG 1", "MORNINGS Solo 4 · Shared 2", "SPONSORSHIP 1 of 3 · 2 boxers on WORK", "Runway 11 weeks".
- **Under it, in red marker, only when it matters:** "IN 2 WEEKS: two fight weeks, BAG 2. A bag night in a fight week costs about 1 in 100. Cover, Rest up, or ask for a later date."
- **Left (40–440), PAD HOURS:**
  - Three magnets flipping PADS or CLASS, each with "+$117: 60 and 75 kg boxers go to bag".
  - COVER ($130, at BAG or SHORT).
  - The volunteer's line with "fight weeks only" as a choice.
- **Centre (480–1480), THE SQUAD:**
  - One row per boxer, with the name once in its header cell and the weight class.
  - The morale word, and the loyalty bar with its last cause in marker.
  - Up to two stickies.
  - Night magnets: solid PADS, hatched BAG, three FIGHT WEEK session magnets with a Rest up switch.
  - WORK on day-job mornings, with "half sponsorship: 1 morning back".
  - The rest switch and Lock with its price.
  - The grappler's row last.
- **Right (1520–1880):** the twist with 2 priced answers, the talk card with "holds: 60 in 100", and PROMISES OPEN with dates.
- **Bottom (980–1060):** Coach deals it ("same as last week" when quiet), Back to Coach's deal, and Start week in gold.
