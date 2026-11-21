# DESIGN_TURNPRO1_V10_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ272)

Brief: research/DESIGN_TURNPRO1_V10_CRITIC_KALLI.md
Sent: 2026-11-21 14:10 | collected: 2026-11-21 14:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

Scoring TURNPRO1 v10 now. I'll send the scores and reasons first, then the options review, To reach 10/10, and the 10/10 page.

# TURNPRO1 v10: critic score (S459, fresh critic, 2026-11-21)

**Depth 6 · General design 7 · Play 6.** It clears the bar on General design but not on Depth, so the mechanic isn't designed yet.

## Depth: 6 / 10
**What works**
- The fork is finally a fork on money. At $1,400 the money crosses at 56 seats, and with the ticket ask it crosses near 54. I reworked both sums from the code's own formula: the bigger gate's purse comes out at exactly $25 a seat over the whole band, because the $25-a-seat cut below 60 and the 50% of $50 tickets past 60 are the same slope.
- The hold becomes a real decision across days, and it can't be gamed. The debutant's rating is read on the signing day, so holding never freezes a weaker opponent.
- The cuts are right. Later +4, the split, softer on the safer start and the "won't" buttons all leave.

**Why it stops at 6**
1. **"The same on average" counts only members.** A win against a loss also moves morale (+8 against −12), reputation (+5 against −2, or −4 when stopped), the stoppage rest, and a 0-1 pro record. Worked at the two aims (ESTIMATE):

   | Expected per debut | Bigger gate (60 in 100) | Safer start (75 in 100) |
   |---|---|---|
   | Members (v10 crowd) | +6.0, less 0.4 lost on a loss | +6.0, less 0.25 lost |
   | Morale | 0.0 | +3.0 |
   | Reputation | +2.2 | +3.25 |
   | Chance of a stoppage loss | higher | lower |

   So the safer start still wins on everything except money.
2. **The money can't carry that weight.** In the band the gym's side of the fork is $60 to $100 once. That's under 5% of one month's rent. The boxer's side is bigger ($187 to $292), but nothing in the code or the map makes the boxer's money do anything except feed the day-job wish. The fork is real on the card and barely real in the save.
3. **The ticket ask still has one answer.** Its own numbers are +$190 at 46 seats and +$50 at 74, so it pays at every count in the both-call band. That means "no ask" is never best for the bigger gate between 46 and 83, and the map's own pass bar in section 8 fails by its own arithmetic before the sweep runs. The only thing that stops it being free is that it takes up the house's one ask.
4. **Later's benefit can't be shown.** Section 4 says each ask shows "the win chance through `DebutRead.card` on the ask's terms". Section 1 says `DebutRead.card` "does not read `debut_weeks`". So Later +2 shows a cost and +0 win, and the 2 weeks between the houses' debut dates (about 2 points, TURNPRO6) is also invisible. Later would read as dominated on screen even when it's right.
5. **The two debutants are the same boxer.** `DebutOpp` makes every debutant a 0-0 boxer-puncher with "Heavy right hand" and "Fades after round 3". The houses differ only in the rating gap. Your boxer's style, the plan and the tape (the game's core) have no say in which house is right.
6. **The long tail isn't measured.** After the debut the houses differ only in the first 6 pro fights (tune-ups against step ups, `ProLean`). That's the biggest lasting effect of the choice, but the sweep stops 12 weeks after the debut, about one fight.
7. **The wish mostly agrees with forces already at work.** "Day job wants the bigger purse" is just money again. "Any other boxer wants the winnable night" is just safety again. Only the title-goal boxer pulls against something. Most boxers' wish adds weight to the side that already wins.

## General design: 7 / 10
**What works**
- Section 1 is a model code audit. It finds the unreachable lapse, the overwrite in `turn_pro`, the step and top that are promised but never paid, the 25% label printed on a 10% share, the age check missing from Next Step, and the morale branch that never runs. Each is cited down to the line.
- Every number is tagged CODE, ESTIMATE or CUT.
- Both critics' lists are answered point by point, and the refusals have reasons.
- The table of every menu is complete and wired.
- Names move off the buttons ("Sign this offer"), and only actionable numbers are kept.

**What it loses points on**
1. **Two claims contradict the code it quotes:** the Later win read (Depth 4), and the pass bar the bigger gate fails (Depth 3).
2. **"The same on average"** (section 3) is stated as the reason for the 10 against 8 members, and it is wrong once morale and reputation are counted.
3. **The sweep's bot hides the design.** "Values cash, members, morale and loyalty at the game's own prices": the game has no dollar price for morale or loyalty. The exchange rate the bot uses decides the 30–70% result, so it has to be written in the map. Better still, measure the brief's own question ("a second fight with money in the club") directly.
4. **New costs from a source nobody opened.** The $238 licence, the $150 trainer's licence and a new $438 manager's licence (section 9, point 11) change `start_costs`, and the costs ask depends on them. Mark them CHECK and leave them out of the build order until the source is read.
5. **A member rule with no reason in the world.** "A debut win brings 10 members with one house, 8 with the other" is a flag on the house. It would read truer as a rule on seats sold on the night (the ticket house fills the hall).
6. **Two coined labels.** "The bigger gate" and "the safer start" go on the card head, so check them against the glossary. "Gate" is real boxing language for ticket money. "Safer start" is a coined phrase.

## Play: 6 / 10
- The call is one of the career's big moments. Holding it for a few days, seeing two debutants with names, and a boxer who wants something give it a sense of weight.
- It happens once a boxer. Week to week it shows up only as an amber flag during the hold, and the ledger line after the debut.
- The best reward the map has is "sold N on the night (N at signing)", but nothing invites the player to grow those seats during the 4 to 6 weeks. Member drift, the dues band, classes and a club show are all levers the game has, and the card never points at them.
- A debut loss with the test house feels as bad as a loss with the soft one. In real boxing it doesn't: a prospect who loses a tough debut is judged more gently than one who loses a gimme.

## Options: what each changes, what's missing, what's useless (S403)

### What each option changes (as v10 writes it)
| Option | Changes | Verdict |
|---|---|---|
| Sign: bigger gate | $25 a seat (from the formula), aim 60 in 100, debut 4 weeks out, a win brings 10 members, step ups in the first 6 fights | Keep. Loses on morale and reputation (Depth 1) |
| Sign: safer start | $1,400 guaranteed, 30% past 70, aim 75, 6 weeks out, a win brings 8, tune-ups in the first 6 fights | Keep. Still the default pick for most boxers |
| Ticket ask (bigger gate) | +15 seats at $40, $180 off the purse; worth +$190 to +$50 in the band | Right everywhere it shows. Needs a price that crosses inside the band |
| Softer opponent (bigger gate) | gap +1.0 (about 5 in 100), $300 off the purse | Keep. A real trade against the ticket ask for the one ask |
| Later +2 (both) | $150 off, 2 more Build weeks | Keep, but its gain is invisible on the card until `DebutRead` reads weeks |
| Costs from the purse (safer start) | The house pays the signing costs; purse −costs −$100/$200; loyalty −6 | Keep. A real cash-crunch choice |
| Review later | Amber flag, Continue runs, lapse at day 14, no bookings for this boxer | Keep: the fix the mechanic most needed |
| Stay amateur | +1 decline, the real next gate, terms ×0.9, loyalty −8, a set house returns | Keep. The hover finally tells the truth |
| The boxer's wish | ±5 morale, loyalty −3 on the other house | Weak. Two of its three cases repeat money or safety |

### Missing
1. **A different debutant for each house** (style and habit), so your boxer's style, the plan and the tape decide which house fits.
2. **A seat forecast for the night**, from the game's own member drift (it targets at most 6 members a week). This would make the bigger gate a bet on growing the gym, one the player can act on through the dues band, classes or a club show.
3. **A debut-loss cost that depends on the house:** losing the test should hurt less than losing the winnable night.
4. **A use for the boxer's money,** such as loyalty from the debut pay. Otherwise half of the money fork is decoration.
5. **One line per card on the first 6 pro fights,** with a number: "tune-ups, about 75 in 100 each" against "step ups, about 50".
6. **The camp weeks in the win read,** so Later and the 4 against 6 weeks show.

### Useless or near-useless
- The ticket ask's "worth it under 84 seats" line. Every count where the ask shows is under 84, so the line never advises anything.
- The day-job wish as written ("the bigger purse on the night"): the money line already says it.
- The gym's money line as the deciding number: $60–100 is under 5% of a month's rent, so it can't decide anything on its own.
- The new manager's licence: unsourced, and it changes nothing a player chooses.

## To reach 10/10 (most important first; every number is an ESTIMATE until the sweep sizes it)

1. **Price the whole debut result by house, not just members.**
   - A debut loss in a bout the bigger gate picked as a test costs morale −6 and reputation −1, where the safer start's winnable night costs −12 and −2 (the code today).
   - Expected morale becomes +2.4 against +3.0, which is close enough for money and the wish to decide.
   - Real-world reason: a prospect who loses a hard first fight is judged more gently than one who loses a gimme.
   - Say it on the card's role line: "a loss here is forgiven".
2. **Make the boxer's money count.** Debut pay over $1,000 adds loyalty, +1 for every $150 (cap +4), applied with the existing +5 for signing. Loyalty already sets the 10% outside-manager rule and contract talks, so the boxer's side of the fork reaches the gym's later share.
3. **Show seats on the night, not today.**
   - Today's sales plus the member drift over the weeks to the debut: half the members are seats, and drift is capped at 6 a week.
   - Make it one number with a hover: "Move members up and this grows: dues band, classes, a club show."
   - Both cards pay on that forecast.
   - This turns the bigger gate into a bet on growing the gym that the player can act on.
4. **Give the ticket ask a price that crosses inside the band.**
   - From the code's formula, the ask's gain before the fee is $600 − $5 × seats.
   - A $270 fee crosses at 66: right from 46 to 65, wrong from 67. Then "no ask" is best for the bigger gate above 66, and section 8's pass bar can pass.
   - The button says "worth it under 66 seats" on the forecast number.
5. **Make `DebutRead.card` read the camp weeks.** Add TURNPRO6's measured weeks effect (2 weeks is about 2 points) to the read. Then Later +2 shows its gain, and the cards show the safer start's 2 extra weeks. If that can't be built, cut Later from the card and keep it as the injured-boxer answer only.
6. **Give each house its own debutant.**
   - The bigger gate picks a crowd-pleaser: a pressure fighter, habit "loads up when hit".
   - The safer start picks a cautious out-boxer, habit "stops punching on the ropes".
   - `DebutPick` still searches the gap until the read sits on 60 or 75, so the aims hold. Your boxer's style and plan now move which debutant is easier than its number.
   - Each card's hover names the habit and the plan line that answers it ("Write it" opens the Game plan).
7. **Rewrite the wish so each case pulls against one force.**
   - A day job means the boxer wants the guaranteed purse (certainty before leaving work), which pulls against money above 56.
   - The title goal means the boxer wants the test, which pulls against safety.
   - Any other boxer has no wish.
   - ±5 morale and loyalty −3 stay, in the one MORALE line.
8. **Base the members from a debut win on seats, not the house.** Use 6 + 1 for every 10 seats on the night for the bigger gate, and a flat 8 for the safer start. Size it in the sweep.
9. **Make the sweep measure the brief's question and the long tail.**
   - Run from the call through the 6th pro fight, or 40 weeks.
   - The pass metric is a second pro fight booked within 16 weeks of the debut with gym cash at or above the day of the call, plus the boxer still at the gym at week 40.
   - Morale and loyalty count only through what they cause in the game (refusals, leaving, the 10% share), with no dollar rate.
   - Keep the 30–70% house split. Put "no ask best somewhere" per house back in, now that point 4 makes it possible.
10. **One number on the first 6 pro fights,** under the role line: "Next 6 fights: tune-ups, about 75 in 100 each" or "step ups, about 50 in 100", read from `ProLean` and the ladder's pick.
11. **Hold the new fees.** Mark the $238, $150 and $438 figures CHECK, and keep them out of the build order until the BBBofC source is opened. The costs ask's numbers then follow `start_costs`.
12. **Small fixes.**
    - Delete "the same on average" from section 3.
    - Write the bot's population and outcome measure into section 8.
    - Run "The safer start" past the glossary.
    - Keep everything else in sections 5–7 as written. The hold, the Stay hover, the returning-house rule, the ledger fix and the age check are right.

**What the game can't do yet:** nothing above needs a new system. Points 3, 5 and 6 extend existing reads (`Members` drift, `DebutRead`, `DebutOpp`).

## The 10/10 page at 1920×1080: the pro offer
It's a menu modal, so it uses the whiteboard look: cream paper on the wall, Bebas Neue for headers, IBM Plex Mono for every number, and Kalam for the coach's note. Nothing is smaller than 12 px. Gold sits on one thing, the wish tag on the wished card. No green: green is only Continue, and the sign buttons are slate. All figures below are **example data**, worked through the v10 formulas plus points 3–4.

- **Header** (0–110 px): "A CALL FROM BOW LANE AND HARROW & FINCH" and "TURN (name) PRO?", the only names on the page. Under them, one line: "9 wins · rank 2 · offer stands 9 days · age 24 · declines left 3". At the right: "Another boxer's call waits behind this one."
- **Seat strip** (y 130–230, full width):
  - A ticket bar with marks at 60 and 70.
  - Seats today 54, then a dashed run to **on the night 62** (drift +4 members a week for 4 weeks).
  - Hover: "Move members up and this grows: dues band, classes, a club show."
- **Two house cards** (y 250–820, x 40–940 and 980–1880), each the same shape:
  - **Head:** the house name, then its role line. "THE BIGGER GATE: paid on the seats, a loss here is forgiven." "THE SAFER START: paid in full, debut 2 weeks later."
  - **The debutant:** a silhouette, 0-0, and the style word (pressure fighter / out-boxer). The habit sits on hover with "Write it".
  - **Win chance:** "about 60 in 100" and "about 75 in 100", camp weeks counted.
  - **Three money numbers:** Cash today $1,245 (both). The gym on the night $388 / $350. The boxer on the night $1,162 / $1,050, with "+1 loyalty" on the bigger gate's.
  - **Next 6 fights:** "step ups, about 50 in 100 each" / "tune-ups, about 75 in 100 each".
  - **Asks:** three tiles at most, each showing its price and the numbers after it.
    - Bigger gate: "Ticket ask: −$270 · gym $393, boxer $1,177 · worth it under 66 seats", "Softer opponent: −$300 · 65 in 100", "Later +2: −$150 · 63 in 100".
    - Safer start: "Later +2: −$150 · 77 in 100", "Costs from the purse: cash today $0 · boxer $41 · loyalty −6".
  - **Button:** "Sign this offer" in slate. The bigger gate's card carries the gold wish tag "Your boxer wants the test".
- **Foot** (y 850–1040):
  - The MORALE line in Kalam: "Your boxer wants the test. That offer: morale +5. The other: morale −5, loyalty −3. Signing either costs 5 while the nationals are open."
  - WHAT ENDS: stipend $250 a week; amateur bouts; the club ticket cut; "the day job ends: 6 training mornings of 6 (now 4)".
  - Buttons: "Review later" and "Stay amateur". The Stay hover reads: "Next call after 9 wins and top 3, or 11 wins · terms ×0.9 unless a title comes · loyalty −8 · the bigger gate calls back".
- **Motion:** pressing an ask tweens that card's numbers to their new values, and pressing again puts them back. Nothing opens by itself.

TURNPRO1 v10 scores Depth 6, General design 7 and Play 6, so it misses the 7+ bar on Depth.

The biggest problem is that $1,400 only evens out the money and the members. On morale and reputation the safer start still comes out ahead, so most players will still pick it. There's also a contradiction: the map wants each ask to show its new win chance, but the code that reads the win chance ignores camp weeks, so Later +2 would always show no gain.

The fixes that matter most:
- Price a debut loss by house, so losing a tough test costs less.
- Make the boxer's money matter through loyalty.
- Show the seats forecast for the night instead of today's.
- Set the ticket ask's fee at $270, so it stops being worth it from 67 seats.
- Give each house its own kind of debutant.

The score rests only on the critic pack and the map. I couldn't open `CRITIC_ACCESS.md` or any code because I can't reach the repo from here.
