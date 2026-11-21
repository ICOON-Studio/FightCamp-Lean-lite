# Critic brief: FightCamp card game prototype (round 2) - you are a FRESH critic

You judge a small browser card game that turns our boxing-gym management game into cards. Be blunt; a kind score is useless. Score 0-10 each: DEPTH (are there real, repeated, interesting decisions; does knowledge/skill beat luck; do cards differ in more than numbers), PLAY (is it fun to play: tension, surprise, agency, pace, would you play a second bout), GENERAL (overall). Then: (1) missing cards or options, (2) useless or dominated cards, (3) what each change would do, (4) THE ORDERED LIST "TO REACH 10/10" - most important first, concrete enough to build (card names, numbers, rules). Also say which single thing is most wrong right now. Our bar to keep the mechanic is 8+ on DEPTH and 8+ on PLAY.

Game in short: the player is a boxing coach. Camp (4 weeks, one drill a week) decides which cards the boxer brings; scouting reveals the opponent's style and habits; the fight is 3 rounds of 6 exchanges, both corners play one card face down and reveal together; between rounds one corner card, each with a cost; ends by stoppage or three judges' scorecards. Real boxing flavour (styles: out-boxer, pressure, counter, volume; wind/head/body damage; knockdowns).

Below: the README (rules), the balance table from 2,000 AI-vs-AI bouts, and AI bout transcripts. The game also has a React / Predict choice each exchange and a tell chip before each reveal. Judge whether the lines read sensibly.

## README
# FightCamp card-game prototype — boxing

A small playable manager-and-fight prototype. You pick a boxer, make four camp choices, read the opponent's film, then choose a boxing card and an exchange mode. No build step, assets, or external libraries.

## Play

Open `index.html` directly in a browser. Pick Ada or Mara, make the four camp picks, read the scouting file, and begin. During each exchange choose **React** or **Predict**, then play one card. `1`–`5` select a hand card; Enter activates the focused button. The opponent's hand stays hidden in the interface.

The fight is three rounds, with up to six exchanges in each. Between rounds choose one of three corner cards. Three judges score the rounds; knockdowns, damage, empty wind, and referee deductions affect the result.

## Exchange decisions

- **Film and tells.** Scouting reveals zero, one, or two habits. Each line says the situation that triggers the habit, the signature card, and its estimated chance of appearing in the five-card hand. The estimate uses deck composition, not the hidden hand. Before each reveal a tell chip names a possible action: calibrated reliability is 55% with no habits known, 70% with one, and 85% with two. The opponent adapts its card weights to your last three cards; a card repeated twice gets twice the counter weight.
- **React** is the safe default. At Speed 65 or higher it improves punch accuracy, scaling up with Speed. **Predict** costs two extra wind. A correct forecast turns your outcome into a clean win; a wrong forecast improves the opponent's outcome by one step and boosts their damage by 20%.
- The AI's reading policy uses only the opponent's public style, film, visible fight history, and its own hand. It does not inspect the opponent's hidden hand.

## Cards and resolution

Punch shapes are **straight** (Jab, Cross), **looping** (Lead hook, Body hook), and **uppercut**. The row in the table is your card; the column is the opponent's. `W` is a clean win, `w` a win, `t` a trade, `l` a loss with possible chip, `X` a clean counter, and `n` no result. The stored table is anti-symmetric; a few range-specific reads are listed after it.

| vs → | Jab | Cross | Lead hook | Body hook | Uppercut | Slip | Block | Roll | Clinch | Step back | Pivot out | Cut off |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **Jab** | t | t | t | t | l | l | l | t | w | w | l | w |
| **Cross** | t | t | t | l | l | l | l | t | w | l | l | l |
| **Lead hook** | t | t | t | t | l | w | l | l | w | l | t | t |
| **Body hook** | t | w | t | t | t | w | t | l | l | l | l | t |
| **Uppercut** | w | w | w | t | t | t | w | w | l | l | l | t |
| **Slip** | w | w | l | l | t | n | n | n | l | n | n | l |
| **Block** | w | w | w | t | l | n | n | n | l | n | n | l |
| **Roll** | t | t | w | w | l | n | n | n | t | n | n | l |
| **Clinch** | l | l | l | w | w | w | w | t | n | l | l | t |
| **Step back** | l | w | w | w | w | n | n | n | w | n | n | X |
| **Pivot out** | w | w | t | w | w | n | n | n | w | n | n | w |
| **Cut off** | l | w | t | t | t | w | w | w | t | W | l | n |

Range-specific outcomes: Cross beats Jab at out/mid; Jab beats an out/mid Uppercut; Slip is countered by Uppercut; Lead hook catches Pivot out. An Uppercut thrown at out range has 50% accuracy. The jab's setup applies only after a clean exchange win. A losing card can still deal 30% chip damage, but a lost exchange cannot move range or earn the Jab setup.

**Defence and movement do not deal damage.** A winning Slip or Roll creates an opening for the next punch (+30% damage, +15 accuracy); a winning Block refunds one wind; a winning Step back moves out and costs the opponent one wind; Pivot out resets to mid. The HUD keeps head and body damage separate. Body damage drains wind. Gloves high reduces punch damage by 15% and discounts Block by one wind for the next round.

## Habits, camp, and the corner

A habit names a trigger and signature card. Its signature appears at least three times in that boxer's fight deck; when its condition is true and the card is held, the opponent AI follows it 70% of the time. Camp has four weekly picks from three offers. The current drills add cards or stats; there is not yet a deck-replacement/removal budget.

Corner cards include recovery, scouting, a punch-power tradeoff, and Change the plan. Change the plan costs six wind and draws two extra cards for both corners. Study is removed from an offer once both habits are known. Between rounds, each boxer also recovers wind and some body damage. Two consecutive clinches draw a referee warning; a third costs a point.

A fresh boxer cannot be knocked down on the opening exchange. Knockdowns depend on shot, chin, existing damage, and wind. A stoppage occurs after three knockdowns, at 53 head damage, or with an empty tank and at least 32 head damage. These thresholds are prototype tuning, not medical guidance.

## Verification and measured balance

```sh
node proto/cardgame/rules.test.mjs
node proto/cardgame/balance.mjs
```

The main test runner imports `rules.round2.test.mjs`; together the checks cover the resolution table, range overrides, separate RNG streams, same-sex pairings, scouting/tell calibration, camp, corner, prediction outcomes, defence benefits, referee deductions, and seeded bouts. The balance command prints style pairs, card usage and outcome rates, stoppages/knockdowns, a 5,000-bout reading-policy comparison against 5,000 random-policy bouts, and single-card priority results. It fails if a card exceeds 65% exchange wins, is used in under 1% of exchanges, the read edge is below 15 points, stoppages fall outside 10–20%, Block is under 8% of exchanges, or any single-card priority beats 45% of non-draw bouts.

Balance figures are generated by the command, not hand-entered. Read-policy results compare the shipped public-information chooser with random hand selection against the same engine opponent; they are not human-playtest results. The harness randomizes seeded card decisions separately from combat RNG.

## Not in this round

The implemented work addresses Part A, prediction/tell and exchange-reading work from Part B, and selected Part D items (defence's own currency, range outcomes, referee holding, habit frequency, first-exchange knockdown protection, and split RNG streams). Still open: Feint/Catch breath, camp replacement/removal and deck cap, full defensive-card win-rate balance, ropes/style range costs, combinations, expanded counter cards, five judges/no-draw scoring, and full club matchmaking rules. Part C's switchable shown-attacker variant was not attempted; this round kept the blind simultaneous reveal.

`rules.js` composes the small UMD data, AI, and exchange modules. `index.html` loads them in dependency order and needs no local server; Node uses the same modules.

## Balance table
```
FightCamp card game - balance: 2000 AI-vs-AI boxing bouts

Style pairs (left corner v right corner)
  pair                      bouts  left wins  right wins   draws
  counter v counter           162      51.2%       42.6%    6.2%
  counter v pressure          172      47.1%       39.5%   13.4%
  counter v volume            166      51.8%       42.2%    6.0%
  out v out                   180      50.6%       42.8%    6.7%
  out v pressure              154      69.5%       23.4%    7.1%
  out v volume                166      42.8%       51.2%    6.0%
  pressure v counter          160      51.9%       36.3%   11.9%
  pressure v out              167      30.5%       62.3%    7.2%
  pressure v volume           173      35.8%       59.0%    5.2%
  volume v counter            167      44.9%       48.5%    6.6%
  volume v out                171      57.9%       39.2%    2.9%
  volume v pressure           162      66.0%       24.1%    9.9%

Cards: share of all exchanges and exchange wins (W/w) when played; defence deals zero damage
  card              kind         plays    share win when played  avg dmg
  Jab               Punch        13638    38.5%           25.2%      3.2
  Cross             Punch         7102    20.0%           21.4%      6.4
  Lead hook         Punch         4048    11.4%           14.5%      7.0
  Body hook         Punch         8814    24.9%           16.8%      3.9
  Uppercut          Punch         7970    22.5%           35.7%      6.1
  Slip              Defence       3885    11.0%           26.8%      0.0
  Block             Defence       3328     9.4%           31.8%      0.0
  Roll              Defence       4343    12.3%           20.7%      0.0
  Clinch            Defence       3618    10.2%           35.7%      0.0
  Step back         Footwork      4947    14.0%           45.8%      0.0
  Pivot out         Footwork      4635    13.1%           64.6%      0.0
  Cut off the ring  Footwork      4574    12.9%           38.7%      0.0

How the bouts end
  stoppage                 260    13.0%   (round 1: 3, round 2: 29, round 3: 228)
  on the cards            1740    87.0%
  draws                    148     7.4%
  knockdowns / bout       0.62
  exchanges / bout        17.7

Reading policy vs random policy: 5,000 bouts each, both against the same engine AI
  reading player        53.6%
  random player         37.1%
  reading edge          +16.6 pp

Single-card priority strategies: each policy prefers one card when held, otherwise hand[0]
  Jab               38.4%
  Cross             38.1%
  Lead hook         28.8%
  Body hook         33.3%
  Uppercut          35.1%
  Slip              34.1%
  Block             38.0%
  Roll              37.9%
  Clinch            30.1%
  Step back         31.4%
  Pivot out         33.1%
  Cut off the ring  29.5%
  best one-card strategy: Jab at 38.4%
RESULT: PASS - no card over 65% win-when-played, no card under 1% of exchanges played
```

## Bout transcript (AI v AI)
```
--- bout 4
R1.1 [inside] Your boxer uppercut lands; the opponent lead hook misses
R1.2 [inside] Your boxer body hook lands in a trade; the opponent uppercut lands in a trade
R1.3 [inside] Your boxer cross misses; the opponent body hook misses
R1.4 [inside] Your boxer slips the body hook with slip; the opponent body hook lands
R1.5 [inside] Your boxer uppercut misses; the opponent body hook lands in a trade
R1.6 [inside] Your boxer body hook misses; the opponent body hook lands in a trade
R2.1 [mid] Your boxer jab lands in a trade; the opponent jab lands in a trade
R2.2 [mid] Your boxer uppercut is mostly smothered; the opponent jab lands
R2.3 [mid] Your boxer cuts off the ring against the body hook with cut off the ring; the opponent body hook misses
R2.4 [mid] Your boxer rolls under the pivot out with roll; the opponent pivots away from the roll with pivot out
R2.5 [inside] Your boxer cuts off the ring against the step back with cut off the ring; the opponent takes the cut off the ring out of range with step back
R2.6 [inside] Your boxer rolls under the pivot out with roll; the opponent pivots away from the roll with pivot out
R3.1 [mid] Your boxer takes the step back out of range with step back; the opponent takes the step back out of range with step back
R3.2 [mid] Your boxer slips the block with slip; the opponent blocks the slip with block
R3.3 [mid] Your boxer cuts off the ring against the step back with cut off the ring; the opponent takes the cut off the ring out of range with step back
R3.4 [mid] Your boxer uppercut misses; the opponent cuts off the ring against the uppercut with cut off the ring
R3.5 [mid] Your boxer takes the step back out of range with step back; the opponent takes the step back out of range with step back
R3.6 [inside] Your boxer cross misses; the opponent uppercut lands
RESULT: The opponent wins on points. (27-29, 26-30, 26-30 on the three cards.)
--- bout 5
R1.1 [mid] Your boxer jab lands in a trade; the opponent lead hook lands in a trade
R1.2 [mid] Your boxer cross misses; the opponent jab is mostly smothered
R1.3 [mid] Your boxer jab misses; the opponent jab lands in a trade
R1.4 [mid] Your boxer jab lands; the opponent uppercut is mostly smothered
R1.5 [mid] Your boxer pivots away from the pivot out with pivot out; the opponent pivots away from the pivot out with pivot out
R1.6 [mid] Your boxer takes the slip out of range with step back; the opponent slips the step back with slip
R2.1 [out] Your boxer lead hook is mostly smothered; the opponent takes the lead hook out of range with step back
R2.2 [out] Your boxer rolls under the cross with roll; the opponent cross misses
R2.3 [out] Your boxer rolls under the jab with roll; the opponent jab lands in a trade
R2.4 [out] Your boxer uppercut is mostly smothered; the opponent jab lands
R2.5 [out] Your boxer rolls under the block with roll; the opponent blocks the roll with block
R2.6 [out] Your boxer pivots away from the slip with pivot out; the opponent slips the pivot out with slip
R3.1 [mid] Your boxer uppercut misses; the opponent jab lands
R3.2 [mid] Your boxer pivots away from the block with pivot out; the opponent blocks the pivot out with block
R3.3 [mid] Your boxer blocks the lead hook with block; the opponent lead hook is mostly smothered
R3.4 [mid] Your boxer rolls under the pivot out with roll; the opponent pivots away from the roll with pivot out
R3.5 [mid] Your boxer cross lands; the opponent jab is mostly smothered
R3.6 [mid] Your boxer blocks the step back with block; the opponent takes the block out of range with step back
RESULT: The opponent wins on points. (28-29, 28-29, 29-28 on the three cards.)
--- bout 7
R1.1 [mid] Your boxer uppercut lands in a trade; the opponent uppercut misses
R1.2 [mid] Your boxer body hook misses; the opponent rolls under the body hook with roll
R1.3 [mid] Your boxer body hook misses; the opponent rolls under the body hook with roll
R1.4 [mid] Your boxer takes the roll out of range with step back; the opponent rolls under the step back with roll
R1.5 [inside] Your boxer body hook lands; the opponent slips the body hook with slip
R1.6 [inside] Your boxer jab is mostly smothered; the opponent blocks the jab with block
R2.1 [mid] Your boxer jab is mostly smothered; the opponent slips the jab with slip
R2.2 [mid] Your boxer takes the slip out of range with step back; the opponent slips the step back with slip
R2.3 [out] Your boxer takes the cross out of range with step back; the opponent cross is mostly smothered
R2.4 [out] Your boxer lead hook misses; the opponent lead hook lands in a trade
R2.5 [out] Your boxer pivots away from the pivot out with pivot out; the opponent pivots away from the pivot out with pivot out
R2.6 [inside] Your boxer cuts off the ring against the step back with cut off the ring; the opponent takes the cut off the ring out of range with step back
R3.1 [mid] Your boxer lead hook lands in a trade; the opponent jab lands in a trade
R3.2 [mid] Your boxer body hook is mostly smothered; the opponent pivots away from the body hook with pivot out
R3.3 [mid] Your boxer takes the slip out of range with step back; the opponent slips the step back with slip
R3.4 [inside] Your boxer cuts off the ring against the slip with cut off the ring; the opponent slips the cut off the ring with slip
R3.5 [inside] Your boxer jab lands in a trade; the opponent cross lands in a trade
R3.6 [out] Your boxer takes the cross out of range with step back; the opponent cross is mostly smothered
RESULT: A draw. (28-28, 28-28, 28-28 on the three cards.)
```
