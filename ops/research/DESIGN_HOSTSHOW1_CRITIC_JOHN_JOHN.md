# DESIGN_HOSTSHOW1_CRITIC_JOHN_JOHN - John answer (seat queue SQ75)

Brief: research/DESIGN_HOSTSHOW1_CRITIC_JOHN.md
Sent: 2026-11-13 21:10 | collected: 2026-11-13 21:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm reading the HOSTSHOW1 round 3 map against the pack now. The full critic return comes next.

# HOSTSHOW1 round 3 (S459): critic

Scores: depth **6/10**, general design **5/10**, play **7/10**. That misses the owner's bar on general design. I couldn't open `CRITIC_ACCESS.md`, the Miro board or `screen_r3.png`, because your computer is offline, so I judged from the map and the pack.

## Logic check

**Names outside headers: this breaks the S448 rule throughout.** Every tile and line identifies people by name:
- "Lucy wins N in 100"
- "No. 3 only if Danny boxes and wins and Liam wins"
- "counts only if Lucy boxes Maria and wins"
- "Priya Nair and Ellie Ward free: may meet"
- The Home notes "Priya Nair said no: ask for Lucy before the posters" and "Samira: weight answer"
- NEXT BOUT "main event v Erin Doyle" and "Asked: Erin Doyle"
- The read option "ANA SELLS"

A matchmaker screen has to say who, but the place for that is each card's own header, not the rows. "Ana sells" also assumes the gym has that athlete, which breaks the sandbox rule.

**The hall choice is dominated for this club.** The draw hardly depends on the hall: the community hall gets 220.6, and the town hall only 238.6 because of 18 extra visiting supporters. So the 120-seat gym floor sells out every night. Worked through the same way as section 6:
- **Gym floor:** 6 bouts, so 4 visiting pairs plus Laura and Erin makes 10 visitors at $40 = $400. Costs are $300 + $1,200 + $300 + $400 = $2,200. Takings are 120 × $35 = $4,200 plus about $1,000 of raffle. That's **+$3,000 every night, with +3 reputation for sure.**
- **Community hall:** +$2,990 likely, and +4 reputation only 36 in 100 times.
- **What the gym floor costs:** Erin's yes drops from 6 to 4 in 10. Lucy's pro offer goes from 0.6 × 0.45 + 0.4 × 0.33 = 40 to 0.4 × 0.45 + 0.6 × 0.33 = 38 in 100.

Two in 100 of a pro offer buys a sure full room. The raffle is a fixed $600–1,400 whatever the crowd, which makes the small room look even better. There's also no check that a 120-seat show with a ring fits on an opening floor of 22 places. And $35 is above your own [R] range of GBP 12–20 ($15–25).

**Favours are close to free.** Every clean bout against a club's boxer earns +1, home or away, up to 3. Four boxers at about 8–10 bouts a year is roughly 35 clean bouts against about six clubs. That fills every club to 3 within a season. Spending is about 2–4 favours a show, three shows a year. So "with a favour" beats "as it is" almost every time, and the swap is nearly always taken. The probe bars (a favour best in no more than 3 of 4 asks, the swap in no more than 2 of 3) will fail once the ledger fills. The earning rule has also drifted from R37's "a clean show with a club", and beating a club's boxer isn't goodwill in real life.

**Promising a return bout is nearly free for anyone not near the pro offer.** It gets the same 9 in 10 as a favour, and its only listed price is breaking it by turning pro. For a boxer with no pro chance (Samira, Danny), the hidden costs go unshown:
- The boxer's next bout is fixed for up to 12 weeks, and with one offer at a time, other offers are blocked.
- The rematch is away, on the opponent's terms.

**Danny's choice is built on a likely defect.** A conditioning goal "missed, −20" because a bout happened 2 days before its deadline isn't a coaching truth. It's `BoutNight` 426–432 judging every goal at every bout. The map turns that into the main price of the Danny tiles, so his three options become a read-off of one −20. Fix the judge, then give Danny's options real prices. The goal also reads "Conditioning +2.5", and Conditioning is a summary stat since S448; the goal should be on Stamina.

**The novice rule contradicts the Danny case.** The pack says a novice has 0–10 bouts. Liam is 7-5 (12 bouts), yet the map says "open after one more bout".
- If Liam is still a novice, Dean v Liam breaks the novice rule (Dean has 13 bouts), and Liam is a legal name for Danny. Then the outside novice and the skills bout shouldn't be offered ("only when the pool holds no legal name").
- If Liam is open, the line about the novice pool is wrong.

**The pull-out rate is a third of the real one or less.** The map uses 1 in 10 in the last week. My S449 sources found 25–50% of matched amateur bouts fall over in the final week. At real rates a 9-bout card loses 2–4 bouts, so a short night (under two-thirds of the card) becomes a normal outcome. Rejecting a standby reserve bout was decided on the wrong rate.

**Weight is judged against the wrong real-world rule.** The map keeps the code's day-before weigh-in and class-limit matching. England Boxing weighs on the day (rule 7.1.3, in my S449 note) and matches bouts within a gap of 2.5 kg at 57–65 kg. At a host's own show, 0.1 kg over is a talk between corners, not an automatic call-off. Samira's three answers are missing the real one: ask the other corner to accept.

**The card counts are one bout short.** The community hall card is 9 bouts: 2 of ours plus 7 visiting pairs means 16 visitors, $640 of travel and 48 supporters, not 6 pairs, $560 and 42. The town hall's 12 bouts with 9 visiting pairs is 11. Either the cards are smaller or the forecasts are wrong.

**The win bands look generous.** On the pack's measured curve (5 points better wins about 72%):
- Erin is 3 points above Lucy, so Lucy is about 37, not 45.
- Maria is 1 point below Lucy, so Lucy is about 54, not 65.

The order of the routes survives, but every printed figure should come from `BoutRead.band`, not from hand numbers.

**Undefined rules:**
- Whether the swap's "both say yes 7 in 10" is each club (so 49 in 100 together) or the pair.
- What MOVE DOWN does to tickets already sold at one hall's price.
- Whether a boxer can be kept free for the show between booking (8 weeks out) and the card opening (19 days out). Away offers arrive 8–12 weeks ahead and will land on the date.

## Depth: 6/10

**The real decisions:**
- **Lucy's route** is the best decision in the game so far. Six routes trade the yes chance, the win chance, rank conditions, the region's show, poster seats and favours, and waiting is a real option with a real price (no posters, one ask left).
- **Samira's weight** is a genuine trade in different coins. Worked out:
  - Keeping the cut is about +0.22 reputation and −0.17 favours on average.
  - The harder week is about +0.22 reputation and −0.04 favours, but costs about 1.5 morale more on average from the lower win chance.

**Where it breaks:**
- **The hall is dominated for any club whose draw beats the gym floor's seats.**
- **Favours fill up**, so their cost disappears and "with a favour" and the swap become the default.
- **Danny's three tiles** come down to one −20 from a defect.
- **At the ticket read,** "Ana sells" costs 1.1 on a BJJ syllabus move for $250, so it's always taken. Selling costs 2.6 mastery for $250 a boxer, which the cut rule lets through but which is almost never wrong.
- **Every tile prints the combined pro-offer number,** so once favours are free the route pick is a read of the biggest number.

It does connect to the rest of the game: rank, the pro offer, members against the room limit, cash, the region's table, and R37. That keeps it at 6.

## General design: 5/10

What it gets right: it's carefully wired to named code, it states its changes, and it follows the cut rule.

What pulls it down:
1. It breaks the owner's names rule on nearly every row.
2. It builds a decision on a goal-judging defect.
3. It uses a summary stat name.
4. The novice rule contradicts itself.
5. Two worked examples miscount the card.
6. It keeps a weigh-in and matching model that differs from England Boxing's.
7. It sets the pull-out rate well under the real one.
8. It leaves three rules undefined (how swap odds combine, MOVE DOWN, holding a boxer for the date).

It also has the heaviest build cost I've seen on a map: 12 tasks, about 2,400 new lines, and four world fixes first. The rank-line conditions ("No. 3 if Liam beats Dean (38 in 100), else No. 4") pile up as visiting pairs are added, which pushes against "only actionable information" and plain words.

## Play: 7/10

Hosting your own show is a strong fantasy, and the timeline gives a real build-up:
- the card opening
- a no landing
- the posters
- the region's show deciding a rank
- the read
- weigh-in, then the night and the sheet

A home main event that can bring the pro offer that night is a moment players will remember. It happens about three times a year, so it stays an event.

What holds it back: the 5 weeks between booking and the card opening are empty, and the sheet is mostly a recap.

## Options

| Option | What it changes | Verdict |
|---|---|---|
| Date (4 Saturdays) | Who can box, the region clash at ×0.8 | Keep. Add holding boxers free for the date. |
| Hall | Seats, price, yes chances, card size | Re-price (the gym floor dominates). |
| A name above | Rank, pro offer, +5 reputation | Keep. |
| A name below | Safe win, +3 reputation | Keep. |
| Outside novice / skills bout | A bout when there's no legal name | Keep, once the novice rule is consistent. |
| Wait for the region's show | Better information for no posters | Keep. |
| Not on the card | Training weeks | Keep. Needs a real price once the goal judge is fixed. |
| Ask as it is / with a favour | Yes chance | Keep, once favours are scarce. |
| Promise a return bout | 9 in 10 yes | Price the lock on future offers, or it's dominant. |
| Stand down | Seats, a favour | Keep. |
| Keep cut / harder week / stand down | Weight risk | Keep. Add asking the other corner to accept. |
| Ladder swap | Rank certainty | Keep. Define how the odds combine. |
| Read: keep / door / sell | Seats against pads | Keep. |
| Read: Ana sells | Seats against nothing | Useless as priced, and it names a person. |
| Read: move down | Undefined | Define it or cut it. |
| Read: cancel | Escape hatch | Keep. |
| Pull-out answers | Replacement | Keep, at the real rate. Add standby reserves. |

**Missing:**
- Hold a boxer for our show from booking day.
- Ask the other corner to accept a small overweight.
- Standby reserves.
- Earning a favour by service: boxing on a club's show at short notice, or hosting its boxers.

## To reach 10/10 (most important first)

1. **Make favours scarce.**
   - **Earn:** +1 only for a service, either our boxer taking that club's short-notice slot or boxing on its show away, or the club's boxer getting a bout on our card.
   - **Cap and lapse:** at most 2, and a favour lapses after 26 weeks unused.
   - **Probe:** at about 4–6 favours earned a year across all clubs, check that "as it is" is best in at least 1 of 3 asks.
2. **Price the promise.** A promised rematch locks the boxer, so no offers arrive until it's fought. The other club picks the date, 4–12 weeks out, and the tile shows "no other bouts until then". Breaking it costs −2 favours, as now.
3. **Fix the hall maths.**
   - The draw grows with the hall's reach: gym floor ×0.8, community ×1.0, town ×1.25 (ESTIMATE, to be probed).
   - Gym-floor seats are equipment places × 4 (88 on the opening floor), at $25.
   - The raffle pays per head, about $5 a seat sold.
   - The probe checks that each hall is best for one of the three test clubs.
4. **Fix the goal judge before using it as a price.** Stat goals are judged at their deadline, and only a "next bout" or "win" goal is judged at a bout. Then Danny's tiles carry real prices:
   - Boxing costs the fight week's taper (about 2.5 days of gains, from `Sim.daily_gain`), the 6% injury roll, and a stoppage's 30 days out.
   - Leaving him off costs the seats, the rank chance and, once MOODIDLE1 lands, the idle month.
   - The goal is written on Stamina, not Conditioning.
5. **Set pull-outs to the real rate, with standby reserves.**
   - Each invited bout falls over 25 in 100 in the final week ([R], my S449 sources).
   - The host can keep up to 2 reserves: an outside novice or a free regional name at $40 to stand by, with travel paid only if used.
   - A short night is fixed by a reserve or costs −2 reputation.
   - The fight week becomes the host's real headache, which it is in boxing.
6. **Make weight the England Boxing way.**
   - Weigh-in on the day, about an hour before boxing (rule 7.1.3).
   - A fourth answer, "Ask the other corner to accept": up to 0.5 kg over, −1 favour, a yes 7 in 10.
   - "Keep the cut" only risks the bout if that ask is refused.
   - This needs a day-of weigh-in for home shows, which the game can't do today (`Bouts.weigh` runs the day before).
7. **Keep a boxer free for the show.** From booking, each boxer's row has a toggle that passes away offers landing within 14 days of the date. The offer card says "held for our show".
8. **One novice rule.** Correct Liam's record or the novice text, and say whether Dean v Liam is legal and whether Danny has a legal name.
9. **Count the card properly** (ours plus visiting pairs). Fix 6.4 (7 pairs, 48 supporters, $640) and 6.11 (11 bouts, or 10 pairs).
10. **Take every win figure from `BoutRead.band`.** The hand numbers run 8–11 in 100 above the pack's curve.
11. **Names in headers only.** Each opponent and each of our boxers is a face card with the name in the card's own header. Rows say "the opponent", "your boxer", "the No. 2", "the name above". Home notes read "An opponent said no: ask again before the posters". The read option becomes "A no-gi athlete sells", priced as one no-gi class lost to its paying members, or it's cut.
12. **Define the rest.**
    - The swap needs each club's yes at 8 in 10, so 64 in 100 together, and the tile prints the joint figure.
    - MOVE DOWN keeps the tickets already sold, refunds any sold beyond the smaller hall's seats, and costs −2 reputation.
    - The gym floor needs a check that a ring and the seats fit the floor.
13. **Rank lines as one number.** Print "No. 3 or better: 56 in 100", with the condition tree on hover.

## The 10/10 page at 1920×1080 (Fights > Our show, 16 days out)

- **Header strip, 96 px:** the club crest, "Our show", the date circled in marker, the hall and its seats, ticket price, days out, and the timeline as magnets (asks close, posters and read, the region's show, the weigh-in on the day, the night).
- **Left column, 520 px: OUR BOXERS.**
  - One whiteboard row per boxer: face card with the name in its header, weight on the day against the limit, condition, morale, a hold toggle.
  - Under each, up to three route tiles: the opponent's face card with the name in its header; yes, win and rank lines as single numbers ("No. 3 or better 56 in 100"); pro offer from the show; seats.
  - How to ask: As it is, Favour (with "also half the swap" shown when that's true), or Promise ("no other bouts until then").
  - Weight answers on the row with a miss chance each.
- **Centre, 840 px: THE CARD AND THE LADDER.**
  - The bout sheet as cream paper: our bouts in red marker, visiting pairs in pencil, the main event boxed.
  - Beside it, the division table with arrows showing who our night and the region's show can move.
  - Ladder pairs highlighted, each swap with its joint yes and its price in favours.
  - Two reserve slots, each with a standby fee.
- **Right column, 560 px: THE NIGHT.**
  - A seats bar split into club, followings, posters and visitors, with the full and half-empty marks.
  - Money against the away line, with the likely, bad and good nights.
  - Reputation in parts, and members against the binding limit, with Add places.
  - The favours ledger: each club's chips, and what earns one.
- **Bottom strip, 120 px:** your assistant's note (portrait, one reason, no names in the text), Back to the coach's card, and the one pulsing button, **Send the asks**.
