# DESIGN_TURNPRO1_V9_CRITIC_JOHN_JOHN - John answer (seat queue SQ268)

Brief: research/DESIGN_TURNPRO1_V9_CRITIC_JOHN.md
Sent: 2026-11-21 09:54 | collected: 2026-11-21 10:40 by Tools/seat_queue.py (the 30-min reconcile)
Attachments on the bot's box (not downloaded): turnpro_10.html
Verify the sources before using it.

---

On it. I'm checking the turning pro v9 map's sums and its real pro-debut evidence first, then the scores, missing and useless options, To reach 10/10 and the 1920×1080 page.

The turning pro critic is underway. Beast is still offline, so this is a reading of the pack and the map only (no `CRITIC_ACCESS.md`). I'll check the sums against the corrected win numbers (about 60 and about 75 in 100) and post the full return here.

I redid the map's sums by hand and they're right. The house crossover is at 66 base sales. The price ask breaks even at 84 tickets for the gym and 92 for your boxer. At 85 tickets the gym gets $531 plain, $530 with the price ask, $494 with the safer ask and $563 with the harder one. With the cover loan, $932 of the $1,345 balance is left after the debut, and your boxer still gets $1,237.

The map misses three things:
- With the price ask, the ticket house overtakes on gym money from about 62 base sales, and on your boxer's money from about 53.
- Pay uses sales counted on the night. A gym at its fastest member growth adds up to 12 seats over the 4-week wait, so the real crossover sits at a forecast of about 54.
- The fee should come off the gross before the split, so both sides break even at 84.

Using S533's numbers (about 60 in 100 to win against about 75), the guarantee house is still the better pick on both money and safety below 66, which is 20 of the 29 base-sales counts where both promoters call.

# TURNPRO1_V9 critic: turning pro, design map v9

**DEPTH 6, GENERAL DESIGN 6, PLAY 7, so it isn't designed yet.** Beast is offline, so this is a reading of the pack, the v9 map and the S533 correction only, with no `CRITIC_ACCESS.md`, mockups or code. Tags: SOURCED means a source I opened, DERIVED means my own sums, ESTIMATE means my assumption, CHECK means unconfirmed, and NOT FOUND means no real figure exists.

v9 is the most careful turning-pro map so far. Every claim names code and lines, and it finds real bugs:
- the hold can never happen;
- the Stay tooltip is wrong;
- the ledger prints 25% when 10% was paid;
- the contract step is promised but never paid.

But S533 breaks two of its pillars. First, the map's win column (67% and 78.5%) and the "steep part of the curve" logic behind the safer and harder asks both come from the probe that S533 calls wrong. Second, S533 describes one fixed opponent per promoter, while the map's code line says the opponent is your boxer's power minus a gap.

**DEPTH 6**
- **Which house.** At S533's rates the safer house is the right pick almost everywhere both promoters call. From 67 to 74 the ticket house pays the gym $13–$50 more, but costs about 15 win points. One month of the member gap between a win and a loss is about $315, so 15 points of win chance is worth about $47, before morale and a 0-1 record (ESTIMATE). The ticket house is only the answer when it calls alone.
- **The asks.** The cover loan is a real choice for a gym short on cash, the price ask has a real crossover, and Later +2 is fine. But the lone-call asks are lopsided: at 85 tickets, "safer" costs the gym $37 and "harder" earns it $32, while each moves the win chance by many points. As priced, "harder" is a trap and "safer" is almost free.
- **When to turn.** Stay against Sign is a real choice, but holding the offer has no upside in game terms. While you hold, the stipend still runs, the day job still costs mornings, and nothing can be booked. Under S533's fixed opponent, holding 13 days even becomes free training that you'd always take.
- **Links it misses:** a Hard camp (+1.0 on fight night) buys back roughly the whole gap between the houses (CHECK, units), and your boxer, who gets 75% of the money and takes the punches, has no say in the choice.

**GENERAL DESIGN 6.** It's truthful, uses one money helper for five screens, makes no new screen and has a clear cut list. Against it:
1. The map and S533 disagree on how the debut opponent is made.
2. The win number is still cut "until §9 calibrates", but S533 is within 5 points of real bouts in 57 of 60 cells, which already beats §9's own bar of 10 points.
3. The price-ask fee of round(180 × cut) is a fudge, paid by the gym alone, that only keeps the crossover at 84.
4. Holding claims depth it doesn't have, and the map pauses the idle loyalty loss but not the "month without a fight" morale −6.
5. Later +2 is hidden "unless weight or recovery differs", but with the opponent fixed at signing, 2 more Build weeks always help. The real reason is the `WeekData` day-job gap.
6. The cards show the forecast, while pay uses sales counted on the night.
7. Which house comes back after you refuse both is still decided by list order.
8. The manager's licence is missing, and the fees are 2025 figures.
9. The one pulsing button is never named.

**PLAY 7.** The call is a milestone you see coming, the debut ledger pays off the forecast ("you said 64, they sold 71"), and the queue and lapse bring you back with your second boxer. It loses a point because the fork mostly has one right answer.

## Options
| Option | Verdict | What it changes |
|---|---|---|
| **Win read on each card** ("about 62 in 100, 57–67") | Missing | Makes the trade visible; S533 already meets the map's own bar |
| **Your boxer's lean**: money first, safe start or soonest | Missing | Morale +5 when you follow it; morale −5 and loyalty −3 when you go against it |
| **Opponent picked to your boxer** | Missing | Fixes the 30–90 spread and stops holding from being free training |
| **Night range on the ticket card** | Missing | Moves the crossover to about 54 for a growing gym |
| **Manager's licence**, $438 | Missing cost | Cash out on the day you sign |
| **Licence ready by** a date | Missing | The 4-week debut needs medicals booked fast (CHECK the lead time) |
| **Which house returns after Stay**, by a rule | Missing | Makes Stay a plan, not an accident of list order |
| Review later (the hold) | Keep, as a way to close and come back only | Closes the offer and keeps everything |
| Own ticket price | Keep, with the fee taken off the gross | +15 seats at $40; both sides break even at 84 |
| Cover as a loan | Keep | $0 at signing; costs the fee more than plain over the career |
| Later +2 | Keep, always shown | +2 Build weeks against a fixed opponent |
| Safer, ticket house alone | Re-price at $300 | Currently almost free |
| Harder for +10 share | Useless as priced | Needs +25 share points (about $78 at 85), or cut it |

## The owner's question
**Yes, the matchmaker should pick the opponent to each boxer.** Aim at a target per promoter, 62 ± 5 for the bigger gate and 78 ± 5 for the safer start, and freeze the opponent at signing. That's how real matchmakers use journeymen. It fixes the 30–90 spread and keeps holding from turning into free training.

## Real boxing evidence
- **Ticket deals (SOURCED):** small-hall pros are paid from the tickets they sell, so $50 seats and a break-even around 60 fit (FT; BBC 2022; Sky 2020; SportsBoom 2024). A guarantee house for a club debutant is NOT FOUND in reality; it's fine as a game device.
- **Licences (SOURCED, BBBofC 2026):** a boxer's licence is £190 ($238), where the game's $230 is the 2025 £184. The trainer's licence is £120 ($150). A club can't hold a manager's licence, so the coach needs one personally: £350 ($438), rule 6.1.
- **Medicals (DERIVED):** $875 fits real prices, but a renewal medical and MRI are due every year, about $874, and the game doesn't charge it.
- **Costs from the purse (SOURCED):** the BBBofC standard contract repays expenses before the manager's 25%. So today's "costs off the top" is the real model, and v9's loan is a gentler version for the game.
- **Debut odds:** no published share of debuts won exists (NOT FOUND). Journeymen win about 3–7% of their career bouts (DERIVED from British Boxing News 2019 and Wikipedia), so real debutants win about 90 in 100 or more (ESTIMATE). At 60 and 75 in 100 the game's debut is harder than real small-hall boxing. Targets of 65 and 80 sit closer to reality and keep the trade.
- **The way back (SOURCED):** England Boxing has let a pro with 6 bouts or fewer return to amateur boxing since 2017–18. That belongs to the ladder, so note it for later.

## To reach 10/10
1. **Pick the opponent to each boxer.** In `Roster.turn_pro`, solve the gap so the S533 win read lands on 62 ± 5 or 78 ± 5, then freeze it. Rerun the 66,000-bout check, aiming for 90% of boxers within 7 points of the target. This can be built now.
2. **Show the win read on each card** ("about 62 in 100 (57–67)", with a hover saying where it comes from) and remove the CUT line.
3. **Make the ticket house the money pick for most of the band:** set the guarantee house to $1,400. The crossover moves to 56. At 66 the ticket house pays +$63 to the gym and +$187 to your boxer, and at 74 +$113 and +$337. Check that cover still works: a $350 debut cut against a $1,345 loan.
4. **Add your boxer's lean** from a saved `goal_kind` and traits: morale +5 for following it, morale −5 and loyalty −3 against it, shown on each card. This needs `goal_kind`, which isn't built yet.
5. **Fix the price-ask fee:** take $180 off the gross before the split, and say "worth it below 84 tickets" on the button.
6. **Show a night range on the ticket card** ("64 now, 64–76 on the night if members keep growing"), and use the upper end to decide when to hide the price ask.
7. **Always show Later +2** as "+2 Build weeks; the opponent stays as signed". A stat forecast waits for the `WeekData` fix.
8. **Re-measure or cut the lone-call asks:** price safer at $300; set harder at +25 share points, or cut it.
9. **Treat the hold as Review later only:** an amber need, a daily lapse check, and pauses for both idle loyalty and the month-without-a-fight morale loss.
10. **Make the returning house a rule:** after you refuse both, the one nearer its break-even calls back, named on the Stay button.
11. **Use real costs:** a $238 licence, a $150 trainer's licence, a $438 manager's licence the first time, and the yearly medical and MRI (about $874) as a ladder bill.
12. **One pulsing button:** nothing pulses until a card is picked, then that card's Sign pulses. Card titles never carry promoter names.
13. **Test it:** a bot that values members, morale and money at game prices should pick each house 30–70% of the time across 46–74, and each ask should be the best pick somewhere in the sweep. This needs the game's balance runs, so it waits for Beast.

## The 10/10 page (1920×1080, Look B)
This is the turning-pro modal on the cream whiteboard, not a new screen.
- **Header (the only place with names):** the boxer and both promoters, 9 days left in amber, 3 declines left, and "1 more boxer waits for a call".
- **Ticket bar:** 64 sold now, a range up to 76 on the night, and the break-even marks.
- **Two equal cards, "Bigger gate" and "Safer start".** Each shows the debut date and Build weeks, "about N in 100 to win" (amber on the harder card, the only colour), pay on the night for the gym and your boxer, cash out today, the one ask with its live change, and your boxer's lean.
- **Strip:** the goal, morale, "Training mornings after signing 6 of 6 (now 4)", and the $250 stipend that ends.
- **Footer:** Stay amateur (−8 loyalty, the next gate, terms ×0.9, which promoter calls back), Review later, Plan the week, and the one pulsing Sign for the picked card.

The rendered page is below. The full critic, with every source and its year, is in `/workspace/turnpro1/TURNPRO1_V9_critic.md`.
