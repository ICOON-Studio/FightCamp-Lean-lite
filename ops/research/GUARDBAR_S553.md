# Ring Switches: the guard bar never breaks (S553, measured)

Question left for the owner in S552: "The guard bar almost never breaks as tuned. Should I make it matter?"
This is the number behind it. Tool: `node proto/twohands/tools/probe_guard_bar.js 300` (a measurement only: it reads
`probe_switch_bots.js`, counts on the bout's own beats and changes no file). 300 bouts a man, 3 rounds of 6 beats, the
probe's sensible player and its careless one (1 choice in 4 off) against the three men (hp 20 / 26 / 22).

## For the owner
1. **As tuned it never breaks: 0 times in 1,800 bouts.** The bar starts at 6 and never went under 4.
2. **Why:** only a blocked BIG punch wears it (1 point), and a whole bout has 2 to 5 of those. It gets 1 point back every beat.
3. **The two first guesses do not fix it.** No point back in a beat that blocked a big punch: still 0 breaks (lowest 1).
   A bar of 4: still 0 breaks. Both together: 1 or 2 breaks in 100 bouts.
4. So the bar is on the screen and does nothing. It is a keep-or-cut call: cut it, or rebuild it so blocking costs
   something every time (for example every blocked punch wears it, a big one 2, and it only comes back in a beat with
   no block). The rebuild is a new rule and gets a probe first.

## The table (wins / stoppages are the player's; "big" = a punch worth 3 or more)
| Arm | Blocked punches a bout (big) | Guard breaks a bout, yours / his | Lowest bar seen |
|---|---|---|---|
| As tuned: 6 points, +1 every beat | 4.8-12.3 (1.7-4.9) | 0.00 / 0.00 | 4 |
| No +1 in a beat it blocked a big punch | 4.9-12.4 (1.6-4.7) | 0.00 / 0.00 | 1 |
| 4 points, +1 every beat | 5.0-12.7 (1.7-4.8) | 0.00 / 0.00 | 2 |
| 4 points and no +1 after a big block | 4.8-12.5 (1.6-4.8) | 0.00-0.02 / 0.00-0.01 | 0 |
Wins moved inside the dice in every arm (sensible 74-94%, careless 55-83%): the bar changes no result.

## Honest limits
- The players are the probe's bots, not a person: a person who only blocks would wear the bar more. The Slugger arm is
  the nearest to that (4-5 big punches blocked a bout) and still never broke it as tuned.
- A first run counted the beats the test player replays in his head (430 "blocked punches" a bout): fixed, only the
  bout's own beats count now.
- No rebuild was tried: that is a rule change and his call first.
