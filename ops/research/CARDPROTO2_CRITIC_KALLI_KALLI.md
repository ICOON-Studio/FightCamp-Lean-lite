# CARDPROTO2_CRITIC_KALLI_KALLI - Kalli answer (seat queue SQ285)

Brief: research/CARDPROTO2_CRITIC_KALLI.md
Sent: 2026-11-22 01:10 | collected: 2026-11-22 01:40 by Tools/seat_queue.py (the 30-min reconcile)
Verify the sources before using it.

---

I'm scoring round 2 now, from the rules, the balance table and the three transcripts.

**Depth 5, Play 4, General 5. It still fails the 8/8 bar.** It's better than round 1, but it broke new things.

**What got fixed.** No single card wins on its own: the best one-card plan is the jab, at 38.4 %. Knockdowns are down to 0.62 a bout, and a fresh boxer can't go down on the first exchange. Defence no longer "lands". Pairings are same-sex and tested, and the lines now say "your boxer" and "the opponent".

**Depth 5.** The read edge of +16.6 points is measured against *random* card picks, and random is about as bad as the dumbest one-card plan (37.1 % against 38.4 %). So it doesn't show that the tells and the file matter. It shows that thinking beats not thinking. The styles flipped from round 1: pressure is now crushed, winning 23 % against out-boxers, 24 % against volume, and 31 to 36 % in the reverse seats. That's because Cut off the ring and Clinch earn nothing when they win. Pivot out wins 64.6 % of its exchanges, just under your 65 % fail line, and costs nothing to play. React does nothing at all for a boxer under Speed 65. Predict, the headline new choice, isn't in the balance table: there's no use rate, no hit rate and no break-even, so I can't score it.

**Play 4.** Roughly one exchange in three is nothing against nothing: about 7 in bout 4, 6 in bout 5 and 5 in bout 7. Bout 4 goes nine exchanges, from R2.3 to R3.5, without a punch landing. The lines make it worse: "Your boxer takes the step back out of range with step back; the opponent takes the step back out of range with step back". Some lines also contradict the table:
- In bout 4 R1.4, "slips the body hook" sits next to "body hook lands", but the slip loses to the body hook.
- Bout 7 R1.5 has the same contradiction.
- In bout 4 R2.5 and R3.3, Cut off the ring should *crush* Step back (W), yet the line reads as the escape working.

A player can't learn a table the text gets wrong.

## (1) Missing
- **A payoff for Cut off the ring and Clinch.** The README lists what a win earns for Slip, Roll, Block, Step back and Pivot out, but nothing for these two, and they are pressure's tools.
- **A cost for footwork against footwork.** Two non-punch cards meeting is free and blank.
- **Predict in the harness:** how often it's used, how often it hits at 55 / 70 / 85 % tell reliability, and its win share against React.
- **A fair read test:** a reading player against the *best non-reading* player (style weights, no tells, no file), not against random picks.
- **Four style pairs are missing from the table:** out v counter, counter v out, pressure v pressure and volume v volume.
- **Seat balance.** In the mirror pairs the left corner wins by 8 points (counter v counter 51.2 against 42.6, out v out 50.6 against 42.8). A mirror pair should split within 3 points, so something in resolution order, the random streams or the reading AI favours the left seat.
- **Still open from round 1:** Feint, Catch breath, combinations, the counter punches, five judges with no draws (draws are up to 7.4 %, and 13.4 % in counter v pressure), and a cost for camp.

## (2) Useless or dominated
- **Lead hook**: played in 11.4 % of exchanges, wins 14.5 %. It beats only Slip, Clinch and a Pivot out at range. It's the weakest card in the game.
- **Pivot out**: the opposite problem. It wins 64.6 %, loses only to the lead hook at one range, and costs nothing for being "nothing". It's a free reset that keeps a losing boxer safe.
- **Cut off the ring**: does no damage, and its win does nothing listed. Its one job is to beat Step back, and the lines show that failing.
- **Change the plan**: 6 wind to draw two extra cards for *both* corners. You pay and the opponent gets the same gift, so it's dominated by every other corner card.
- **React below Speed 65**: an empty button.

## A note on the metric
"Win when played" now counts only clean wins, so a trade counts as a non-win for the punches, while a footwork "w" that changes nothing counts as a win for Pivot out. The 65 % line is checking the wrong thing. Use bout win share when the card is played two or more times, and the points swing per play.

## (3)+(4) TO REACH 10/10, most important first (all numbers are targets)
1. **Give pressure its currency.**
   - A win with Cut off the ring moves the range inside and traps the opponent: next exchange, their Step back and Pivot out cost +1 wind and land at −50 % accuracy. Two Cut off wins in a row puts them on the ropes, and Step back can't be played until a Pivot out wins.
   - A win with Clinch costs the opponent 1 wind, gives you back 1, and takes −15 accuracy off their next punch.
   - Each exchange inside costs an out-boxer 1 wind, and each exchange at range costs a pressure fighter 1 wind.
   - *What it does:* pressure gets back into the game, and range becomes the fight. *Bar:* every style pair between 42 and 58 %.
2. **End the dead exchanges.** A non-punch card can't be played two exchanges running: the third card has to be a punch or Catch breath. Two non-punch cards meeting costs both boxers 1 wind, and the one whose style wants the current range gets a work-rate mark. Pivot out against Jab and Pivot out against Cut off the ring both become `t`.
   - *What it does:* the mirrors stop, and every exchange moves something. *Bar:* nothing-against-nothing in 10 % or fewer of exchanges, and Pivot out under 55 %.
3. **Rewrite the lines from the outcome code.** One sentence that says who won and why. "The opponent's body hook goes under your boxer's slip." "Your boxer cuts the ring off. The opponent is trapped on the ropes." "Both reset at range." Write the possessive ("your boxer's uppercut"), never "X with X", and never describe a defence against a card that wasn't a punch. Add a test: every line's verb agrees with the table cell.
   - *What it does:* the player can learn the table from the fight, which is what the read is built on.
4. **Measure honestly.**
   - Read test: reading player against the best non-reading player, target a 10-point edge or more.
   - Predict: target a 20 to 35 % use rate, a hit rate that rises with the tell reliability, and a positive return only at 70 % reliability or better.
   - All 16 style pairs, swap seats every bout, mirror pairs within 3 points.
   - Replace win when played with bout win share and points swing per play.
5. **Make React a real choice for everyone.** Under Speed 65, React gives 10 % less damage taken and shows the tell's punch shape (straight, looping or uppercut).
   - *What it does:* the safe button has a reason to exist, and Predict becomes a gamble you choose rather than the only active option.
6. **Fix the lead hook.** Lead hook against Block becomes `t` (it goes round the guard), and Lead hook against Step back becomes `t` at mid. Target a 25 % win rate or more and an 8 % share or more.
7. **Fix Change the plan.** Only your boxer draws 2 cards, for 6 wind. Otherwise remove it.
8. **Combinations.** Up to 3 cards in one exchange, costing the sum plus 1 wind for each extra card, resolved one by one. Slip followed by Cross is a counter combination.
9. **Add Feint and Catch breath.** Feint does no damage, beats Block, Slip and Roll, and loses to any punch. Catch breath gets back 3 wind and loses to every punch.
10. **Five judges and no draws.** Today 7.4 % of bouts are draws, and amateur bouts don't have them.
11. **Give camp a cost.** One week rests or tapers, picks cost fatigue, and one week can take a card out of the deck. The deck is capped at 20.

## The single most wrong thing
Pressure's two cards, Cut off the ring and Clinch, win nothing, and footwork against footwork costs nothing. So pressure loses about two bouts in three, and a third of every fight is two boxers stepping away from each other. Fix 1 and 2 together.

Round 2 scores Depth 5, Play 4 and General 5, so it still fails the 8/8 bar. That's up from 4, 4 and 5 in round 1.

What most needs fixing is that Cut off the ring and Clinch win nothing, and two non-punch cards meeting costs nothing. Pressure fighters lose about two bouts in three, and a third of every fight is two boxers stepping away from each other.

The numbers also don't prove the read yet. The +16.6 point edge is measured against random card picks, and Predict isn't measured at all.

Some fight lines contradict the table, for example "slips the body hook" next to "body hook lands". A player can't learn the table from text that gets it wrong.
