# DESIGN_CLUBWEEK1_V7_CRITIC_MARIA_MARIA - Maria answer (seat queue SQ136)

Brief: research/DESIGN_CLUBWEEK1_V7_CRITIC_MARIA.md
Sent: 2026-11-14 22:10 | collected: 2026-11-14 22:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I give CLUBWEEK1 v7 **DEPTH 7, GENERAL DESIGN 5, PLAY 6**, so it misses the owner's bar on general design. v7 fixes most of v6's faults:
- A place is now a whole 240-unit pad night.
- The game's three starts are kept.
- Core is cut to four meters.
- Pulls are printed as words.
- The bout page warns about a collision before Accept.
- The grappler is out of the deal.

It still fails general design for three reasons. It clashes with two sister maps on the same coach's evenings and on the word for fight-night fuel. It cuts everyday training by design without asking the owner. And it adds a loyalty system and a new start with no code behind either.

## Scores

**1. DEPTH: 7/10**

What works:
- **Selling a class night is a real fork.** +$117 a night drops owned places from 8 to 6, which is exactly the ordinary Need. Any fight week then leaves someone short, and the counter says who before Start week. Money and training now pull against each other every Monday, which is the game's own rule that "every week costs something".
- **Two fight weeks close together are the real crunch,** and the bout page shows it at Accept. That makes taking an offer a club decision, not just a boxer decision. Real small amateur clubs live this: one or two coaches, two boxers on the same club show, and someone gets less pad time.
- **The Protect pin is a clean answer to the default winning.** You pick who gets the full week, and the cost prints first ("the 60 kg boxer drops to 2 of 3").
- **The valves are priced:** cover for $80, borrow against next week, a rest week, holding pads for a team-mate. Each has a different cost.
- **The fight week at half volume is true to tapering research** (Bosquet 2007, a 41–60% cut).

What holds it back:
- **Most of the depth only exists because the map takes training away.** Today every boxer gets 3 pad nights. Here an ordinary week leaves one boxer on 2 of 3. The shortage is real only because the map creates it. That's a fair design move, but it's a nerf to the game's core that the owner hasn't approved.
- **Loyalty may become a chore, not a choice.** With Need +1, Want +1, and short −3 or −6, Coach's deal will keep everyone Settled most weeks. LOYAL1's own pass line says the coach's deal keeps the lowest loyalty at 50 or more. If so, the talk and the promise rarely appear.
- **Shared and solo mornings** (×1.3 alone against 0.8 each shared) is a small sum the player will solve once.

**2. GENERAL DESIGN: 5/10**

What works:
- Every point from the last critic has a row.
- The code numbers are kept: the 240-unit pad night, the $350 first class, the $250 stipend, the 25% pro share, camp nights, rest week +4.
- Words sit beside every colour.
- Names appear only in header cells.
- No fixed pronouns.
- 7 build modules, down from 12.
- A cut rule for weak choices (under 1.5 wins in 100 and no season effect means cut).
- The v2 list is honest.

What fails:
- **It clashes with COACHFIT1 on the same thing.** COACHFIT1 v7 gives each coach a coach-time budget (sessional 8, full-time 12) with prices per pad night and per morning. This map gives Coach 3 evenings, 2 places per second hour and 2 coached mornings. Two maps now ration the same coach's week in different units. One must own it, and the other must read from it.
- **It uses the wrong word for fight-night fuel.** This map says "Tank". WEIGHT1 round 4 says Energy (the code's own word, BoutNight._energy) and asks CLUBWEEK1 v7 to switch. That breaks one word per concept across the game.
- **It cuts training volume without the owner.** An average boxer drills 11% less, and a boxer on Need a third less. Steps rise about 4 a week instead of 6 (an estimate, not checked against the code). VOLUME1 is the right probe, but the owner should hear "every boxer trains less, so the coach's time matters" before it's built.
- **Loyalty is mostly new.** The code holds a Loyalty value but it isn't on the board (pack section 3). Moves, bands, the talk, leaving for Eastside ABC, and a 10% pro share for a boxer who signs with an outside manager are all NEW. The 10% share is invented: the code has 25% and contract talks. Mark it GAME VALUE and get the owner's OK, because it changes the money of the whole pro road.
- **The coach's 3 evenings are a CHECK.** If the code has no evening count for the coach, the whole place maths rests on an estimate.
- **The fourth start breaks the roster rule.** Its 4 roster places are a one-off exception to the code's 3. It has starter data for 57 and 75 kg boxers who have no pro table (owner question 4). It's a new start for a map whose job is the week.
- **It replaces a built system.** The club twist deck takes over from WeekTwist once two fighters are signed. That's 12 cards to write and balance, when only 6 of today's cards would need rewording.
- **The Club week is a new screen.** It waits on owner question 1 and a drawing, which the map says plainly. That's correct, but it means nothing is buildable yet.

**3. PLAY: 6/10**

There's a weekly beat:
- The counter reads OK, FULL or SHORT.
- The NEXT WEEK line warns two weeks ahead.
- A class night is a tempting sale.
- A collision at Accept forces a call.
- The talk gives a person a voice.

A quiet week is one click, which keeps the pace. But the reward is mostly avoiding a loss (no short week, no lost loyalty), not gaining something you can see. The one visible win is cash from classes.

## Options: missing, useless, and what each changes

**Missing**
- **Hire a second evening coach for places.** The second club coach adds no places by design, so the only lasting fix for a shortage is the $80 cover each week. A real club would bring in a volunteer for pads. Add "Pads volunteer" at about $120 a week (EXAMPLE) for +2 places, with a lower coach factor.
- **Move a session to a morning.** A pad session in the morning at a lower rate, for a boxer left short in the evenings.
- **Delay a bout to avoid a collision.** At Accept, a "later date" request, which the code already allows for weight ("a boxer over the class can get a bout he can make, a later date").
- **See the season cost of selling a class:** "a class every week: about 1 boxer short in 2 weeks", next to the +$117.

**Useless or near-dominant**
- **Borrow a place:** next week pays it back, and the probe target is "best in under 1 week in 4". It will rarely be the right answer. Cut it, or let it borrow from two weeks ahead.
- **By hand:** the map itself expects it to fall under 4 in 100 and be cut. The Protect pin already does its job.
- **Pass on the sponsorship:** +5 loyalty to the new holder at no cost. It's always taken over Let end when anyone is wavering.
- **"Tell it straight" at 60% odds:** with +4 or −4 it's a coin flip with no lasting stake, when "Give the place back" gives +4 for sure.

**What each option changes**
- **PADS or CLASS on a second hour:** 2 places, or +$117 that night plus about 1 member every 4 weeks.
- **Cover a night:** +2 places for $80.
- **Borrow:** +1 place now, −1 next week.
- **Rest week:** that boxer's Need goes to 0, morale +4.
- **Freed places:** give them to a row or sell them as a class.
- **Hold pads:** a loyal veteran gives one place to a team-mate at 0.7, loyalty +3 a week for up to 4 weeks.
- **Protect pin:** that boxer gets the full week, and the others absorb the shortfall.
- **Drag a row:** sets the deal order.
- **Solo or shared morning:** ×1.3 for one boxer, or 0.8 each for two.
- **Sponsorship:** −$1,000 a block, 6 free mornings, no job rota, loyalty +5. Renew +2, stop −8.
- **The talk:** Give the place back (+4), a dated promise (+5 kept, −12 broken), Tell it straight (+4 or −4).
- **Let a fighter go:** frees the roster place now, −5 loyalty to each team-mate, pay out the block or a week.
- **Rest up, Tick over, Train through (fight week):** sets the fight-week bill, about +2 to +4 in 100 against Coach's.
- **Saturday corner:** you or a $100 mat coach when a boxer and the grappler both compete.
- **Accept with the collision line:** shows who goes short before you commit.

## To reach 10/10

1. **Give the coach's week one owner.** COACHFIT1's coach time or CLUBWEEK1's places, not both. I recommend places, since a place is a whole pad night in the code's units and the player can count it. COACHFIT1 then reads its fit and bond from who holds each place.
2. **Use Energy, not Tank,** across this map, as WEIGHT1 and the code do.
3. **Ask the owner about the training cut before VOLUME1:** "Every boxer trains a little less so the coach's time matters: yes?" If he says no, Owned becomes 9 and the shortage comes only from class nights and fight weeks.
4. **Settle the coach's evenings and the second class in the code** (the two CHECKs that decide the whole place maths) before any probe runs.
5. **Mark the 10% pro share and leaving for Eastside GAME VALUE,** and put both in owner question 5. Without his yes, a boxer with low loyalty only lowers their own morale and coachability, using existing values.
6. **Take the fourth start out of this map** into its own row (START2). CLUBWEEK1 then only needs "the Club week appears when a second fighter signs".
7. **Keep WeekTwist and reword it** for two fighters ("Coach off Wed: one of your boxers loses a night") instead of a new 12-card deck. New cards come in v2 when ROTATWIST1 passes.
8. **Add a pads volunteer** as the lasting answer to shortages: about $120 a week for +2 places at a lower coach factor. Probe it alongside COVER1.
9. **Add "Ask for a later date" at Accept** when a collision shows, reading the code's existing later-date rule.
10. **Make loyalty bite.** Run LOYAL1. If Coach's deal never drops anyone below 50, raise "short" to −5 and halve the Need-met gain, so the talk turns up a few times a season.

**My 10/10: Fighters > Club week, 1920×1080, Look B whiteboard**
- **Dark top bar:** the date, cash, and CONTINUE reading "to Mon 9 Feb, the week review".
- **Top strip (0–120):** counter magnets with words and numbers: "PLACES Need 6 · Asked 9 · Owned 8 · OK", "MORNINGS 6", "SPONSORSHIP 1 of 1", "Runway 11 weeks".
- **Under it (120–180), in marker, only when it matters:** "IN 2 WEEKS: two fight weeks, Need 10 of 8. Cover a night or ask for a later date."
- **Left (40–440), COACH'S EVENINGS:**
  - Four flippable magnets, PADS or CLASS, each with its price written underneath.
  - Cover a night ($80).
  - Pads volunteer (+2 a week).
- **Centre (480–1480), THE SQUAD:**
  - One row per boxer, with the name once in the header cell and the weight class beside it.
  - A mood word, and the loyalty bar with its last cause in words ("−3: short of a pad night").
  - Up to two stickies: WEAK SPOT, WEAPON, GOAL or AHEAD.
  - Night magnets reading "3 of 3 nights" or "2 of 3 nights", with FIGHT WEEK printed on doubled magnets.
  - A rest switch and the Protect pin.
  - The grappler's row last, with the sponsorship and the corner clash only.
- **Right (1520–1880):**
  - The twist with its priced answers.
  - The talk card with its three answers and the odds printed.
  - PROMISES OPEN with dates.
- **Bottom (980–1060):** "Coach deals it" (it reads "Same as last week" when nothing changed), Keep my changes, and Start week in gold.
