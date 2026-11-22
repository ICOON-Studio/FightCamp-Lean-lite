# DESIGN_TURNPRO1_V14_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ288)

Brief: research/DESIGN_TURNPRO1_V14_CRITIC_KALLI.md
Sent: 2026-11-22 11:40 | collected: 2026-11-22 12:10 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm scoring TURNPRO1 v14 now, from the pack and the map, with a look at `CRITIC_ACCESS.md` first.

**Depth 6, General design 7, Play 6. It fails the 8/8 bar.** That's up a point on Depth and Play from v13's critics, but it isn't probed: the map says itself that it "goes to no critic until `docs/TURNPROBE14_RESULT.md` exists". So every score here is on paper, and I wouldn't give 8 to an unprobed design.

**Depth 6.** Handing the kind of fight to the player is the right fix, and there are now about seven real decisions: the house, the debut night and five bookings. But the numbers collapse two of them:
- **At the ticket house, one road wins every way.** A step up earns +5 reputation, +1 favour, a ranked place and the title door. The "favour-keeper" and the "name-chaser" are the same bot there, so nothing is traded.
- **At the guarantee house, the door pays the wrong party.** $300 more a purse is the boxer's money, so the gym gets $75 a fight. Against the 3 reputation a step up earns instead (about $14.50 a week while there's room), keeping favour there is not worth chasing.
- **+2 against +5 doesn't separate the two kinds.** A tune-up read at 82 earns about +1.3 expected reputation after the losses, and a step up read at 50 earns about +1.2 after the -2 / -4 on a loss. A tune-up's next fight is also 6 weeks away against 12. So per week the win-chaser out-earns the name-chaser, and bar 10 (the name-chaser 3+ ahead) will likely fail. The step up's real payoff is the ranked place and purse, which isn't the lever the map is selling.
- **The ticket house's test debut outweighs the whole road.** +5 reputation plus 1 for every 4 seats, capped at 20, means about +21 at 64 seats, plus a ranked seat after one fight, for 10 more losses in 100. That's more name than five road wins put together. Expect the test night to be the one answer at the ticket house in every cell with room, so bar 16 fails.

**General design 7.** It's the best-cited map in the loop: v13's false line was fixed, the cuts are clean, and the build order is honest. Points off:
- A ranked seat after one pro fight isn't how real tables work. It also skips the game's own 5-win review rule (`REVIEW_WINS`).
- After fight 6 the favour and the duck count both run, so there are two patience systems at once.
- The area title row assumes the boxer's division has a table, but the world holds four. That's a CHECK against WEIGHT2.
- Probe 14 died at 31 of 222 rolls on memory. That's an engineering fix (run it in batches), not a design one, and it's still the blocker.

**Play 6.** This is the first version with anticipation. The favour pips, "2 more step ups open the title shot" and the +2 / +5 line on each row give a reason to look at every set. But the reward is a reputation number, and in a full gym reputation brings nobody (A3 wasn't taken). The boxer has no voice in "keep busy or test", so a choice about a person feels like a choice about a meter.

I'd read `CRITIC_ACCESS.md` in an earlier session (the 16 November checkout). It has nothing on turning pro, so it doesn't change the scores.

## Missing, useless, and what each option changes (S403)

### What each option changes
| Option | Changes | Verdict |
|---|---|---|
| The house | debut weeks (4 / 6), which kind earns favour, which door opens at 8 | Keep. Often forced anyway: one house calls under 46 seats and over 74 |
| The debut night (test / build) | about 10 in 100 debut wins against a seat bonus and, at the ticket house, a ranked seat | Keep, but resize it: today it's the dominant choice |
| The kind on each set (tune-up / step up) | the win chance (82 against 50), +2 or +5, favour ±1, the gap (6 or 12 weeks), place and purse | Keep. This is the mechanic. It needs a price beyond the reputation number |
| Favour, 0 to 10 | the doors at 8, 4-day offers and the house's kind only under 3 | Keep. Make the guarantee door pay the gym |
| Area title shot | the belt and 10 rounds after 4 pro wins | Keep, as a decision: accept or wait |
| Later +2, with a cause | a calendar fix for an injury or the weight | Keep. Small and honest |
| Payday row | +5, favour 0 | Fine as it stands |

### Missing
1. **A price for keeping the ticket house sweet.** Today its favour, the name and the title all point at the same booking.
2. **A door at the guarantee house that the gym feels**: camp and cutman bills, or a faster next fight. Not the boxer's purse.
3. **The boxer's voice from traits the game already has.** A confident boxer bored of soft fights, a low-heart boxer shaken after a loss. Confidence and Heart exist in `FighterProfile`, so this needs no new goal system.
4. **A bot that reads the state**: tune-up after a loss or a hard night, step up when the title is two wins off. That's the only honest test of depth. The map admits fixed bots can't show it.
5. **Name per week, not per fight.** The road is counted in fights, but money and members run on weeks.
6. **A Stamina read for 10 rounds on the title row**, for a boxer who has only done 4 to 6 rounders.

### Useless or broken as written
- **The guarantee house's +$300**: $75 a fight to the gym. Nobody will play for it.
- **Favour under 3 at the ticket house**: the "punishment" is a set of step ups only, which is what the name-chaser wants anyway.
- **"The table's last seat" after a debut win**: unrealistic, and it outweighs every later booking.
- **The favour after fight 6** running next to the duck count: two rules doing one job.

## To reach 10/10, most important first (numbers are ESTIMATES for the probe)

1. **Finish probe 14 first.** Run it in batches: one boxer at a time, 37 rolls each, with each batch appending to the result file, so the memory guard can't kill it. No critic should see v15 without `TURNPROBE14_RESULT.md`.
2. **Shrink the test debut.** Seats give +1 for every 8 at the ticket house and every 16 at the guarantee house, capped at +6. No ranked seat after one fight. Instead, a test won makes the first set's step up read nearest 0.55, not 0.50, and the 5-win review (`REVIEW_WINS`) drops to 4 for that boxer. *Bar 16:* the test is behind on wins and ahead on name or cash, and neither night is the one answer in more than 6 of 10 cells.
3. **Give the ticket house's favour a price.** Its preferred step ups are booked 4 weeks out, not 6 (`LEAD_DAYS` per row), so there's no full camp: Hard intensity is off and PEAK CAMP can't happen. Keeping the house sweet then means fighting under-prepared, the way real short-notice step ups go. *Bar 7:* at the ticket house the keeper and the name-chaser end a line apart on some axis.
4. **Make the guarantee house's door pay the gym.** At favour 8 the house pays the pro camp and cutman bills (`GymDeals.pro_camp`), and the next fight after a tune-up comes 4 weeks later, not 6. That's "keep your boxer busy" made real: more fights, more wins and more members a year. Cut the $300.
5. **Price the name by risk and time.** Make a win's reputation follow its read: round(2 + 6 × (0.82 − read) / 0.32), so a tune-up earns 2 and a 0.50 step up earns 8. The week review should show reputation per 10 weeks for each road. *Bar 10, rewritten:* by week 40 the name-chaser is 3+ reputation ahead AND the win-chaser is 1+ pro win less loss ahead, in every cell with room.
6. **Add the boxer's voice from the traits.**
   - Confidence 70+: a third tune-up booked in a row costs 4 morale (wants a real fight).
   - Heart under 40: a step up booked straight after a loss costs 4 morale.
   - Show it on the row in plain words ("wants a real fight"), and never block the booking.
7. **Add a state-reading bot**: tune-up after a loss or after a fight where your boxer lost 30+ head damage, step up when favour is 7+ or the title is open. *Depth bar:* it beats every fixed bot by a line in at least half the cells. If it can't, the choice isn't deep, whatever the critics say.
8. **Make the title row a decision.** It shows a 10-round Stamina read ("fades by round 7"). Saying no keeps the favour, and the row comes back after the next win. Draw it only where the boxer's division has a table, as a CHECK with WEIGHT2.
9. **Use one patience rule after fight 6.** Either the favour carries on and the duck count is retired for good, or the favour ends with the road. Not both.
10. **Make the name count in a full gym.** The room line also prints what reputation still does there: "+3 reputation: about +6 seats at your next club show, grant odds +2". The numbers come from `ClubShow.draw`, `Grants.chance` and `CardAsk.chance`. That's A3 in the smallest form the game can do now.
11. **Measure in weeks.** Add a stage F line: 80 weeks, cash, members and pro record, with the favour on against off, for the state-reading bot as well as the keeper and the rebel.

The only thing that needs a new system is the trait line in step 6, and even that is one read of two existing numbers.

## The 10/10 page at 1920×1080: Fights (pro), the road after the debut
Look B gym whiteboard on the warm plaster wall, Kalam marker, numbers in IBM Plex Mono, Bebas Neue heads, nothing under 12 px. One figure: your boxer's comic portrait, head to feet, as a polaroid. Gold on one thing, the coach's pick. No green except Continue. All figures are **example data**.

- **Header** (0–90 px): "THE ROAD: FIGHT 3 OF 6", the boxer's name once, women's 60 kg, pro record 2-0, unranked.
- **Top strip, the road:** six magnets, the debut and five sets. Two are filled (TEST won, TUNE-UP won) and one is circled. Under them are the favour pips, 7 of 10 lit, and one line: "The house wants a step up. At 8: an area title shot (4 pro wins, you have 2)."
- **Left third:** the polaroid; morale "Steady"; the trait line in marker: "Wants a real fight: a third tune-up in a row costs 4 morale"; last fight "won, 12 head damage".
- **Centre, two rows** on cream paper cards, side by side:
  - **TUNE-UP:** win chance 78 to 86, "+2 reputation", "favour −1", "next fight 6 weeks out", "full camp".
  - **STEP UP (the #14):** win chance 46 to 54, "+8 reputation and the #14's place", "purse $1,500 to $2,300", "favour +1", "4 weeks out: no Hard camp".
  The gold box goes around the step up, with the coach's note "She's ready. Take the place." Hovering any number breaks it into parts.
- **Right third:** "What the name does now: room for 9 members; +8 reputation brings about 5." Under it, a ten-week sparkline of reputation for each road.
- **Foot:** "No row taken by Friday: the house calls again next week." The buttons are "Book the step up" in slate and Continue in green, once the booking is made.
- **Motion:** the pips tween on hover over a row to show where the favour would land. Nothing opens by itself.

TURNPRO1 v14 scores Depth 6, General design 7 and Play 6, so it fails the 8/8 bar. It also hasn't been probed yet: probe 14 stopped at 31 of 222 rolls, and the map says itself that no critic should see it before the result exists.

Letting the player pick the kind of each fight is the right fix, but the numbers undo it in four ways:
- At the ticket house a step up wins on every count, so there's nothing to trade off.
- At the guarantee house, favour pays the boxer, not the gym, and only $75 a fight reaches the club.
- Per week, tune-ups earn about as much name as step ups.
- At the ticket house, a test debut win is worth about 21 reputation and a ranked place, more name than the whole road after it.

The fixes that matter most:
- Finish the probe in batches so it doesn't run out of memory.
- Shrink the test debut's reward.
- Give the ticket house's favour a cost: its step ups come 4 weeks out, so there's no full camp.
- Make the guarantee house's reward pay the gym.
- Scale the reputation a win earns by how risky the fight was.
