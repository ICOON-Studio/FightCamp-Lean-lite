# K-PROLINE1 - Kalli's answer, verbatim (4048 chars, 2026-10-28 S297)

**Part A** (the numbers are game-tuned guesses, NOT COMPUTED against real UK purse data)

1. **When the offer comes:** at 7 amateur wins *and* a top-3 London ranking. That's about 4 wins on top of her 3-1, so roughly 5-6 bouts or 6-8 months of game time. Both conditions are needed, so a padded record alone can't trigger it.
2. **First pro terms:**
   - **Purse:** $1,500 for the 4-round debut, rising $500 per win to $3,000 by fight 4.
   - **Gym's share:** 25% of every purse as manager share. Her trainer's 10% goes to the same gym, so the gym takes 35%.
   - **Stipend:** the $250/week club stipend stops when she signs.
   - **Signing fee:** $1,000 to her, none to the gym.
   - **Ticket duty:** she must sell $1,200 of tickets per show. Any shortfall comes off her purse first.
3. **The trade-off:**
   - **What the gym loses:** the $450 ticket cut per bout, the amateur bouts, and the London ranking, which freezes for good. The gym also loses the reputation that comes from a ranked amateur.
   - **What the gym gains:** 35% of $1,500 is $525 a fight, only a little above $450. The real gain is the growth: about $1,050 per fight by fight 4, plus gym reputation that counts at national level.
   - **The risk:** a pro loss early on costs far more reputation than an amateur loss, so turning her pro too soon is a real way to lose.
4. **Declining:** yes, it's allowed. The same promoter comes back after 2 more amateur wins. A decline after the second offer brings in the other promoter with terms 10% worse. A third decline ends the arc until she's top-1.

Arguing against myself: needing both 7 wins and top 3 may stall a player who keeps losing close fights. The fallback would be 9 wins with any ranking. Whether that's needed is NOT COMPUTED.

**Promoters (fictional):** Bow Lane Promotions, and Harrow & Finch Boxing.

**Part B**
```json
{
  "trial_open": [
    "{name} turned up at {gym} at nine sharp with her own gloves and a nervous grin.",
    "{name} has come in for a trial. The coach wants three rounds on the pads, then sparring.",
    "A trial at {gym} today: {name}, recommended by a coach from across the river.",
    "{name} wrapped her own hands, which the coach noticed straight away.",
    "{name} arrived early for her trial and was skipping before anyone else got in.",
    "{name} is in for a trial. She says she's had a few bouts and wants a proper gym."
  ],
  "trial_good": [
    "Good trial. {name}'s {best} is the real thing. I'd sign her today.",
    "{name} took everything we threw at her. Her {best} stands out. Worth a place.",
    "She listens and she learns fast. {name}'s {best} is already better than most here.",
    "Three hard rounds and {name} didn't fade. That {best} will win her fights.",
    "I've seen a lot of trials. {name}'s {best} is the best I've seen this year.",
    "{name} is ready to work. Her {best} gives us something to build on."
  ],
  "trial_mixed": [
    "{name}'s {best} is good, but her {worst} needs months of work.",
    "Mixed day. Strong {best}, but {name}'s {worst} let her down in sparring.",
    "There's something there with the {best}. The {worst} worries me.",
    "{name} has a real {best}. Whether we can fix her {worst} is the question.",
    "Half a fighter today: {best} was sharp, {worst} was poor.",
    "{name} could be useful if we're patient with her {worst}. The {best} is real."
  ],
  "pro_offer": [
    "{promoter} rang about {her}: a 4-round debut on their next show, {purse} purse.",
    "{promoter} wants {her} on their card. Pro contract, {purse} for the debut.",
    "{promoter} has watched {her} box and is offering a pro deal, starting at {purse}.",
    "A call from {promoter}: they think {her} is ready to turn pro. {purse} to start."
  ],
  "pro_debut": [
    "{her} makes her pro debut against {opp} over four rounds.",
    "It's official: {her} turns pro and meets {opp} on her debut.",
    "{her}'s first pro fight is booked. Opponent: {opp}, four rounds.",
    "From the amateurs to the pros: {her} faces {opp} on her debut."
  ]
}
```
