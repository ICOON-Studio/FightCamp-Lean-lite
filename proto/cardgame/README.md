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
