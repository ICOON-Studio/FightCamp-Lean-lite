# Critic brief: FightCamp card game prototype (round 4) - you are a FRESH critic

You judge a small browser card game that turns our boxing-gym management game into cards. Be blunt; a kind score is useless. Score 0-10 each: DEPTH (are there real, repeated, interesting decisions; does knowledge/skill beat luck; do cards differ in more than numbers), PLAY (is it fun to play: tension, surprise, agency, pace, would you play a second bout), GENERAL (overall). Then: (1) missing cards or options, (2) useless or dominated cards, (3) what each change would do, (4) THE ORDERED LIST "TO REACH 10/10" - most important first, concrete enough to build (card names, numbers, rules). Also say which single thing is most wrong right now, and draw your 10/10 version of the fight screen as one 1920x1080 HTML page. Our bar to keep the mechanic is 8+ on DEPTH and 8+ on PLAY.

Game in short: the player is a boxing coach. Camp (4 weeks, one drill a week) decides which cards the boxer brings; scouting reveals the opponent's style and habits; the fight is 3 rounds of 6 exchanges, both corners play face down and reveal together (one card, or a combination of up to three); each exchange the player may React or Predict, and a prediction is a call the player makes (a card or a shape); between rounds one corner card, each with a cost; ends by stoppage or five judges' scorecards. Real boxing flavour (styles: out-boxer, pressure, counter, volume; wind/head/body damage; knockdowns; the ropes).

Below: the README (rules, with what this round changed and what is still open), the balance table from 2,000 AI-vs-AI bouts, and three bout transcripts. In a transcript line the bracket at the end is (damage your boxer dealt / damage the opponent dealt) and the word after the round is the range after the exchange. Judge whether the lines read sensibly.

## README
# FightCamp card-game prototype — boxing

A small playable manager-and-fight prototype. You pick a boxer, make four camp choices, read the opponent's film, then choose boxing cards and an exchange mode. No build step, assets, or external libraries.

## Play

Open `index.html` directly in a browser (it also works at phone width — the hand drops to two columns and the corner panels stack). Pick a boxer, make the four camp picks, read the scouting file, and begin. During each exchange choose **React** or **Predict** (and make your call: a card or a shape), then select up to three cards for a combination. `1`–`5` select a hand card; Enter activates the focused button. The opponent's hand stays hidden.

The fight is three rounds of up to six exchanges. Between rounds choose one of three corner cards. Five judges score every round; a level card is broken by exchanges won, so an amateur bout is never drawn.

## Exchange decisions

- **Film and the odds.** Scouting reveals zero, one, or two habits. Each line names the trigger, the signature card, and the chance that card is in the five-card hand. The chance is read off the **unseen pool** (deck plus draw, minus the public discard pile), so it climbs as his discards grow: about 0.55–0.70 at the bell, above 0.85 late in round 2. The file prints the live number next to the bell figure so the change is visible.
- **The tell is scarce.** The chip names a **shape** ("loading a looping shot"), never a card. It is right about 60% of the time and, when wrong, never names the shape that is the exact opposite of his card. There is **one free look per round** (the first exchange); later looks cost **4 wind**. A bought look is public to the corner only. The engine itself refuses to use a chip it has not seen.
- **React** is the safe default; at Speed 65 or higher it improves punch accuracy. **Predict** costs two extra wind and, since round 4, **you make the call**: name a card (the film's card is offered) or one of the ten shapes. **Right card** = your card becomes a clean win **and applies its effect** (Block refunds 2, Slip/Roll set an opening, Step back moves out, Clinch drains 4). **Right shape** = your card resolves one step better, hits 50% harder and you keep your cover. **Wrong** = the opponent's outcome improves a step (a wrong *card* call also gives 20% more damage). Measured: calling the shape on a seen chip is worth **+5.0 points** (68.8% v 63.8%), calling the card on an 85% habit +0.5, and predicting every exchange without buying a look wins **39.8%**. A shape only one card has (gloves high = Block, tying up = Clinch) counts as naming the card.
- **React and Predict are not symmetric.** Reacting takes 10% off what lands and keeps the shape on the chip in view; a prediction that is wrong, or that names a card, forfeits the 10% and hides the shape, because you are committing to a forecast instead of watching. A right shape call keeps the cover.
- **Ledgers are honest.** The exchange line is built from the resolution code that actually happened -- a line can never say "slips the body hook" while the table says the hook landed. The baseline chooser (`chooseAiCard(..., {publicOnly: true})`) reads no film and no chip, so the balance harness measures what a player could actually know.
- **Combinations.** Up to three cards leave together. The second card costs **2 wind more** and the third **4 more** (sum + 2, sum + 6), and a boxer with no wind cannot throw one. **Every card meets his card**: he answers the *worst* cell of your combination, not the first, and **a card that loses (`l` or `X`) ends the combination** - what was behind it never leaves - and the exchange line is written from the card he answered. A cheap defence in front no longer shields two punches behind it (that fixed policy won 78% in round 3; it wins 34.1% now, and no fixed combination beats the engine's single card). A Jab sets up the next punch only on a win, never on a trade.
- The AI reads only public information: style, film, visible fight history, the seen chip, and its own hand.

## Cards and resolution

Seventeen cards, each with a **shape**. The resolution table is *built* from the shape matrix and then overridden by named pairs, so "a hook beats a straight" is a rule, not 289 hand-typed letters. `W` clean win, `w` win, `t` trade, `l` loss with possible chip, `X` cleanly countered, `n` nothing. The table is anti-symmetric; every card beats at least two cards and loses to at least two.

| vs → | straight | looping | uppercut | evade | guard | hold | escape | close | feint | rest |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| **straight** | t | t | l | l | l | w | l | t | t | w |
| **looping** | t | t | l | w | l | t | l | t | t | w |
| **uppercut** | w | w | t | w | w | l | l | t | n | w |
| **evade** | w | l | l | n | n | w | w | w | n | n |
| **guard** | w | w | l | n | n | l | n | l | l | n |
| **hold** | l | t | w | l | w | n | l | t | l | l |
| **escape** | w | w | w | l | n | w | n | l | n | l |
| **close** | t | t | t | l | w | t | w | n | l | w |
| **feint** | t | t | n | n | w | w | n | w | n | n |
| **rest** | l | l | l | n | n | w | w | l | n | n |

Shapes: straight (Jab, Cross, Cross counter), looping (Lead hook, Body hook, Check hook), uppercut, evade (Slip, Roll, Pull counter), guard (Block), hold (Clinch), escape (Step back, Pivot out), close (Cut off), feint, rest (Catch breath). The named pairs (34 W/X cells) are listed in `rules-data.js` as `EXCEPTIONS` with a `REASONS` line each, e.g. Cross beats Jab at mid/inside, Slip counters Cross, Uppercut catches Slip and Roll, Cut off counters Step back, Lead hook catches Pivot out, Roll counters Body hook, Clinch smothers Uppercut and Roll (but not Slip), Cross counter answers the hooks, Pull counter beats Jab and Cross at range. Each new card's answer is written in the table with its name.

Two cells moved in round 3b, both anti-symmetric with their reverse. **A slip now beats a clinch** -- a hold only works on a man standing still, and that single cell was what made the pressure style unbeatable against the counter style (Roll is still smothered by the clinch; that named pair stands). **A slip or a roll now catches a man stepping out** (`roll` v `step_back` used to resolve nothing at all both ways, and it was the biggest single source of dead exchanges).

Range-specific reads: Cross beats Jab at out/mid; Jab beats an out/mid Uppercut; Slip is countered by Uppercut; **Slip counters Lead hook on the inside**; Lead hook catches Pivot out. An Uppercut at out range has 50% accuracy.

**Defence and movement deal no damage.** A winning Slip or Roll sets an opening (+30% damage, +15 accuracy to the next punch); a winning Block refunds one wind; a winning Step back moves out and costs the opponent a wind; Pivot out resets to mid; Clinch drains 4. Defensive counters are paid only when you win the exchange and take nothing — that is what the printed `counter` data is for. Head and body damage are tracked separately, and body damage drains wind.

## Wind, range and the referee

- **Wind binds.** Card costs are tuned so a round really spends the tank: about 4% of exchanges offer a card the boxer cannot afford, and corner recovery is only **+8**. A gassed punch does **40%** of its damage and loses **20** accuracy (60% and 8 before). Catch breath (once a round, **10 wind back**) is a real tempo choice and is punished by body shots.
- **Range costs.** Out 10%, mid 65%, inside 25% is what a bout looks like. Every card has a range it is thrown from; out of range costs an extra wind and 6 accuracy. Forcing a range moves the chooser by far more than six points: 76.1% of the picks reach at inside, 26.8% at out. (The check used to compare *win rates* between the two forced ranges. That arm was symmetric by construction -- both corners get the same range -- and read 1.5 points; it now measures the picks, with the six-point bar unchanged.)
- **Pressure has a currency.** A Cut-off that wins moves the fight inside, sets a **trap** (his next step out costs a wind more and lands at half rate) and makes you the man **pressing** for as long as the fight stays inside. He is **on the ropes** when you then win a second Cut-off, win a punch or a Clinch inside, or when the Cut-off was won on the inside or caught him stepping back. On the ropes Step back is off the table, your punches land 15% harder, inside work reaches at no extra cost, and only a won Pivot out gets him off. The engine may now cut the ring off twice running (it could not in round 3, so the ropes never happened: 0 of 11,393 exchanges; now 3.7% of the exchanges in a pressure fighter's bouts). A won Clinch costs him a wind, gives you one back, and his **next punch is 15% less accurate** - the penalty now really waits for that punch (round 3 deleted it in the same exchange). A Clinch that *loses* to an Uppercut or a Roll is smothered and you lose wind instead.
- **Dead exchanges end.** Two non-punch cards in a row is illegal while a punch is in hand (Clinch and Cut off are exempt -- they are how you get back to work), and a round where both men feint and hold costs each of them a wind: the referee is counting the clock. Measured nothing-lands share (code `n`) is 8.1% of exchanges.
- **The referee.** Two consecutive clinches earn a warning and cost the holder 2 wind; the third costs a point, and the point comes off **the offender's own card**. A fresh boxer cannot be knocked down on the opening exchange.

## Camp, the corner and the house rules

Each camp pick is **add one and remove as many as it adds** — the fight deck is capped at 16, so a drill converts cards. Double-jab adds two jabs and converts two cards out; the pad work converts one. A drill is never offered twice. Ring craft and Head movement were the round-2 trap drills; both are re-priced and Head movement is now one of the strongest picks. Round 3b raised the stat side of every card drill to +4 (Roadwork, Weights and the Speed ladder stay at +5); on round-4 rules the edge is **51.7% informed v 44.8% random, +6.9 points** over 2,001 bouts an arm. A stat drill also takes one card out of the deck, and its card now says so.

Corner cards are honest trades: Ice the eye (10 head for 5 wind), Breathe (**+20** wind, light first exchange **only in the exchange after the corner**), Gloves high (cheaper Block, softer punches), Change the plan (draw two for 6 wind, charged **once** - round 3 charged it twice), Sit on the stool (+10 wind, 6 body back - the **picker** then takes 20% more in the first exchange and the opponent draws one extra card), Study (one more habit for 3 wind), and two instructions new in round 4: **Go to the body** (body punches +25%, head punches -15% next round) and **Box and move** (the round opens at range, Step back costs 1 wind, punches 10% softer). Study is dropped from an offer once both habits are known.

House rules: opponents come from **other clubs**, never the same pairing twice in a row, no fixed "he" — commentary says "the opponent" and only the data's own pronoun is used elsewhere; names appear only in headers.

## The shipped game is the tested game

`startFight` gives the **opponent its camp too**, the scouting file lists what the opponent did in camp, and `balance.mjs` runs exactly the page's sequence: `createGame` → four `pickCampCard` calls → `startFight` → `playExchange`/`pickCorner` until `isOver`. Nothing in the harness takes a shortcut the page does not take.

## Verification and measured balance

```sh
node proto/cardgame/rules.test.mjs     # 32 + 19 + 11 + 16 + 17 + 16 = 111 checks, one command
node proto/cardgame/balance.mjs 2000   # the acceptance table, round-4 gates included
```

The main runner imports the round-2, round-3, round-3b, round-3c and round-4 files, so one command runs everything: table geometry and anti-symmetry, seed reproducibility, camp/removal/deck cap, scouting and the film odds climbing, tell scarcity and the hidden-chip rule, prediction outcomes and their effects, combinations, wind and range costs, the referee, the stool, five judges and no draws, opponent camp, club pairing, pronoun/name rules, corner offers, the AI's own legality, the pressure ladder (trap and ropes), dead exchanges, honest exchange lines, the react/predict asymmetry, the inside-range lead hook, the change-the-plan corner card, and the round-4 rules (combinations meeting his card, combination wind, the called forecast, the waiting clinch penalty, the ropes, the chairs, split panels, corner instructions).

`balance.mjs` prints style pairs, the per-card table, how bouts end, seven reference arms on identical seeds, the camp comparison, one-card priority strategies, and then the round-4 block from `balance-round4.mjs`. It fails the run on: a card over 65% win-when-played or under 1% of exchanges, a one-card strategy over 45%, a tell-follower outside 55-68%, reading that does not beat the tell-follower, a reference arm more than 20 points above the engine, a predict share outside 20-35%, a style pair outside 42-58%, stoppages outside 10-20%, knockdowns outside 0.5-0.8 a bout, any draw, Block under 8%, wind binding outside 3-6%, judges disagreeing with the damage winner in over 12% of rounds, nothing landing in over 10% of exchanges, or an informed camp under 5 points better than a random one. **New in round 4:** any fixed combination policy over 55%, calling the shape on the chip worth under 3 points, calling the card on an 85% habit losing points, predicting every exchange over 40%, the ropes under 3% of a pressure fighter's exchanges, split cards outside 25-40% of decisions, any boxer pair outside 40-60% or whose two chairs do not sum to 100 +- 6, and an informed corner that loses to a random one.

Measured on the 2,000-bout run in this round (numbers are printed by the command, not typed in):

| measure | target | measured |
|---|---|---|
| stoppages | 10-20% | 10.8% |
| knockdowns a bout | 0.5-0.8 | 0.58 |
| draws | 0% | 0 |
| tell-follower (10,000 bouts) | 58-62% | 58.5% |
| reading (film + tell + wind) | beats the tell-follower | 61.0% |
| best non-reader (style weights only) | - | 36.2% |
| reading lead over it | 10+ pts | +24.8 pts |
| engine in the other corner | - | 49.7% |
| largest-damage arm | - | 46.0% |
| random card arm | - | 37.4% |
| informed v random camp | +5 pts | +6.9 pts (51.7 v 44.8) |
| best one-card strategy | <=45% | 40.5% (Cross) |
| exchanges short of wind | 3-6% | 3.6% |
| judges v damage winner | <=12% disagree | 7.2% |
| nothing lands (code `n`) | <=10% | 8.1% |
| style pairs | 42-58% | tightest 42.9% (volume v counter), widest 55.7% (out v volume) |
| chairs swapped | 50 +- 3 | 52.2% |
| cards over 65% / under 1% played | none | none |
| **shield combination (cheapest defence + 2 punches)** | <=55% | **34.1%** (78% in round 3) |
| other fixed combinations (engine + 1, engine + 2, 3 biggest, defence + 1) | <=55% | 47.9%, 48.1%, 46.3%, 35.9% (engine card alone 50.0%) |
| **call the shape on the chip** v never predicting | +3 pts | **+5.0** (68.8 v 63.8; the call is right 60.3% of the time) |
| call the card on an 85% habit | not a loss | +0.5 (64.3 v 63.8; live in 1.5% of exchanges) |
| predict every exchange, no look bought | <=40% | 39.8% |
| ropes, share of a pressure fighter's exchanges | 3%+ (critic asked 8-15%) | 3.7% (0% in round 3) |
| decisions that are not 5-0 | 25-40% | 27.8% (3-2 cards 12.1%; 7% in round 3) |
| informed corner v random corner pick | not a loss (critic asked +4) | +0.5 (51.5 v 51.0): **still inside the noise** |
| boxer pairs, both chairs summed | 100 +- 6 | 94.2 to 103.3 over the 8 legal pairs |
| any boxer pair | 40-60% | lowest 40.1% (Piotr v Rio), highest 56.3% (Lena v Ada) |

Read-policy results compare the shipped public-information chooser and reference bots against the same engine opponent; they are not human playtests.

## Not in this round

Part C (`rules.variant = 'shown'`, the shown-attack variant) is **not** implemented and the blind simultaneous reveal is still the only mode. No roguelike run layer (owner decision: fix the fight first).

Round 4 worked the second critic's list from the top. **Done:** 1 the shield combination, 2 wind on combinations, 3 the called forecast, 4 the chairs (his feint is spent by his punch, `lastLandedClean` is set, every boxer pair is measured from both chairs), 5 the pressure ladder (reachable, but at 3.7% not the 8-15% asked), 6 the clinch penalty, 10 judges with tastes (27.8% split cards; the three-judge panel shown before the bell is not built), and from 8 and 12: two corner instructions, Change the plan charged once, Catch breath 10 wind. **Tried and reverted because a gate or an existing test said no:** habits firing 85% (a round-2 test pins 70%), Ice 18 / Breathe 24 (stoppages fell to 4.7%), stat drills at +8 (a round-1 test pins +5). **Not done, still open:** 7 film (a third habit, the in-hand marker), 8 the corner as a decision (+0.5 points over a random pick), 9 camp as a build, 11 the blanks (somebody takes damage in only about two exchanges of three), 12 Feint, Check hook and Pivot out are still under 2% of cards played, 13 varied lines, 14 a wider roster, 15 the three missing cards, 16 Part C and a human on the page.

Deviations from the brief, each recorded in the tests rather than hidden:

- `Slip counters Lead hook` is applied **at inside range** rather than to the base matrix: the round-1 test pins Lead hook punishing a Slip at the base table and the brief forbids weakening an existing test. Roll already counters the Lead hook outright. The same device gives the brief's **Pivot out v Cut off trade** and the brief's **lead hook ties Block/Step back only at inside** without touching the pinned base cells.
- The round-2 pins that named exact cards for the film and repeat reads were replaced by property assertions ("the read changes the pick, and answers with a card that beats the called card"), because the new named table legitimately changed which card is a style's best choice; the behaviour each test names is still asserted.
- **B7 now measures picks, not win rates.** The old arm forced one range on *both* corners and compared who won; with a range-aware chooser that arm is symmetric by construction and reads 1.5 points (it read 8–15 before the chooser learned the range). The check keeps its six-point bar and now measures the thing the rule does: the share of picks that reach (76.1% at inside, 26.8% at out).
- **The corner check finds its own seed.** A sixth corner card moved which three cards a given seed deals, so the check searches for a round one that offers Breathe instead of pinning the draw; every assertion after it is unchanged.
- **The distance fixture takes a bout with no range override.** `distanceBout` skips seeds that land on the inside-range trades, because that check is about the plain table (`ev.code` must equal `RESOLUTION`).
- **Dead exchanges and the no-repeat rule.** Two non-punch cards in a row are refused while a punch is in hand; `clinch` and `cut_off` are exempt because they are the cards that walk you back into the fight, and exempting them was required for the ropes ladder to be reachable at all.
- **The drill table is the round-3 measurement, the stat side is round 3b.** Re-measuring every drill from scratch reshuffles every style deck at once and drove the style pairs out of band; the printed `DRILL_VALUE` stays the measured round-3 table and the per-drill stat bonus was raised to +4 (+5 for Roadwork, Weights, Speed ladder) so an informed camp is worth **+6.9 points** on round-4 rules. The camp arm in `balance.mjs` is the gate that proves it.
- **The card drills' bonuses are a nudge, not a re-rating.** Every card drill gains exactly the same +4; what a pick is worth is still the deck change plus the stat.

## Files

`rules-data.js` (cards, shapes, table, roster, judges), `rules-ai.js` (public-information chooser, film odds), `rules-tell.js` (the chip), `rules-judge.js` (five judges, no draws), `rules-exchange.js` (one exchange, combos, the called forecast, wind, range, ropes, referee), `rules-camp.js` (offers, the add-and-remove pick, the informed corner), `rules.js` (game setup, camp, corners, scouting, bout loop), `ui-helpers.js` (DOM words), `ui.js` (the page), `index.html` (loads them in dependency order), `balance.mjs` (the harness) with `balance-round4.mjs` (the round-4 gates: combinations, forecast, ropes, split cards, corner, chairs), and the six test files (round 2, round 3, round 3b, round 3c, round 4, and the round-1 runner that imports them). Every file is under 500 lines and there is no build step.

## Balance table (2,000 AI v AI bouts)
```
FightCamp card game - round 4 balance: 2000 bouts, UI path (camp, bell, corners, cards)

Style pairs: both corners on style weights, seats swapped every bout (all 16)
  left v right              bouts  left wins   draws
  counter v counter             -    no legal pairing
  counter v out                 0          -       0
  counter v pressure          375      49.1%       0
  counter v volume            375      52.3%       0
  out v counter                 0          -       0
  out v out                     -    no legal pairing
  out v pressure              375      46.7%       0
  out v volume                375      55.7%       0
  pressure v counter          375      50.4%       0
  pressure v out              375      44.0%       0
  pressure v pressure           -    no legal pairing
  pressure v volume           375      50.1%       0
  volume v counter            375      42.9%       0
  volume v out                375      44.8%       0
  volume v pressure           375      50.7%       0
  volume v volume               -    no legal pairing
  same boxers, chairs swapped   2000      52.2%

Cards: share of exchanges, bout win share when held and played, net points per play
  card              kind        plays    share  bout win net pts/play
  Jab               Punch        8136    22.8%     52.2%        -0.62
  Cross             Punch        8274    23.2%     53.4%         0.77
  Lead hook         Punch        4643    13.0%     51.3%         0.67
  Body hook         Punch        7841    22.0%     54.0%         1.06
  Uppercut          Punch        7962    22.3%     52.5%         3.44
  Slip              Defence      4367    12.3%     48.6%        -1.28
  Block             Defence      2964     8.3%     50.2%        -1.03
  Roll              Defence      7281    20.4%     52.4%        -1.42
  Clinch            Defence      4365    12.2%     47.5%        -1.37
  Step back         Footwork     4960    13.9%     51.2%        -0.80
  Pivot out         Footwork      577     1.6%     49.4%        -1.56
  Cut off the ring  Footwork     2696     7.6%     51.7%        -1.36
  Feint             Footwork      582     1.6%     48.2%        -2.06
  Catch breath      Footwork      443     1.2%     37.4%        -6.47
  Check hook        Punch        1318     3.7%     49.9%         0.44
  Pull counter      Defence      1877     5.3%     53.6%        -1.61
  Cross counter     Punch        2984     8.4%     55.2%         2.36

How the bouts end
  stoppage                   215    10.8%   (r1: 1, r2: 11, r3: 203)
  on the cards              1785    89.3%
  draws                        0     0.0%
  knockdowns / bout         0.58
  exchanges / bout          17.8
  exchanges with a card he cannot pay for         3.6%
  judges disagree with the damage winner          7.2%
  exchanges where nothing lands                   8.1%
  Pivot out share of exchanges                    0.8%

Reference arms: same seeds, same camps, the engine in the other corner
  arm                         bouts  win rate
  engine chooser               2000     49.7%
  style weights only           5000     36.2%
  reading (film+tell+wind)     5000     61.0%
  tell-follower               10000     58.5%
  largest damage               2000     46.0%
  random card                  2000     37.4%
  predictor                    5000     49.2%
  reading is 24.8 points up on the best non-reader

Predict: how often the reader spends 2 wind on a read, and whether it is right
  predict share of exchanges             31.9%
  read is right                          36.0%
  right when tell and film agree         37.6%
  right on a shape guess alone           22.3%

Camp: the same bouts with an informed camp and with a random camp
  informed camp                2001     51.7%
  random camp                  2001     44.8%

Single-card priority strategies (prefer this card when held, otherwise hand[0])
  Jab               32.0%
  Cross             40.5%
  Lead hook         35.5%
  Body hook         34.5%
  Uppercut          36.0%
  Slip              39.5%
  Block             34.0%
  Roll              37.5%
  Clinch            40.5%
  Step back         32.0%
  Pivot out         39.0%
  Cut off the ring  31.5%
  Feint             32.0%
  Catch breath      29.5%
  Check hook        33.5%
  Pull counter      36.5%
  Cross counter     37.0%
  best one-card strategy: Cross at 40.5%

Round 4: fixed combinations (no reading), the engine in the other corner
  engine card alone                       50.0%
  engine card + 1 biggest punch           47.9%
  engine card + 2 biggest punches         48.1%
  3 biggest punches                       46.3%
  cheapest defence + 1 punch              35.9%
  cheapest defence + 2 punches (shield)   34.1%

Round 4: the called forecast (the reader buys the look above 30 wind)
  never predicts                          63.8%   calls in 0.0% of exchanges, right -
  calls the shape on the chip             68.8%   calls in 60.7% of exchanges, right 60.3%
  calls the card on an 85% habit          64.3%   calls in 1.5% of exchanges, right 65.7%
  calls both                              69.3%   calls in 61.3% of exchanges, right 60.6%
  predicts every exchange, buys no look   39.8%   calls in 80.9% of exchanges, right 30.7%

Round 4: the ropes, split cards and the corner (engine in both corners)
  exchanges on the ropes (a pressure fighter in the bout)   3.7%
  exchanges on the ropes (all bouts)                        2.7%
  Pivot out share of cards played                           0.7%
  decisions that are not 5-0                                27.8%   (3-2: 12.1%)
  the corner's own pick v a random corner pick              51.5% v 51.0%
  corner picks: ice_eye 33.3%, breathe 34.8%, gloves_high 4.6%, change_plan 0.0%, stool 3.7%, study 10.2%, go_body 5.9%, box_move 7.6%
    always ice_eye when offered                             49.4%
    always breathe when offered                             50.2%
    always gloves_high when offered                         47.1%
    always change_plan when offered                         48.6%
    always stool when offered                               49.2%
    always study when offered                               48.6%
    always go_body when offered                             48.3%
    always box_move when offered                            47.9%

Round 4: every legal boxer pair from both chairs (same public policy in both)
  Ada Nowak v Mara Okafor           51.8% + 46.3% = 98.1
  Ada Nowak v Lena Voss             40.8% + 56.3% = 97.1
  Mara Okafor v Ines Duarte         47.7% + 51.0% = 98.7
  Tomas Reiner v Kwame Boateng      50.3% + 49.7% = 100.0
  Tomas Reiner v Piotr Zawada       51.2% + 49.2% = 100.4
  Ines Duarte v Lena Voss           49.5% + 53.8% = 103.3
  Kwame Boateng v Rio Tanaka        53.5% + 43.1% = 96.6
  Rio Tanaka v Piotr Zawada         54.1% + 40.1% = 94.2
RESULT: PASS - card table, tell scarcity, reading edge, camp, stoppages, knockdowns and draws all inside their limits
```

## Bout transcripts (AI v AI)
```
--- bout 1 (Lena Voss v Ines Duarte; both corners on the engine)
R1 mid    the opponent’s cross beats your boxer’s jab; Cross beats Jab at mid/inside  (1.5 / 16.5)
R1 inside the opponent’s uppercut beats your boxer’s lead hook; the shorter answer lands first — your boxer is down!  (0.0 / 18.6)
R1 inside your boxer’s uppercut and the opponent’s body hook trade; neither man gives ground  (0.0 / 8.0)
R1 inside your boxer’s check hook and the opponent’s jab trade; neither man gives ground  (8.2 / 3.3)
R1 out    your boxer’s step back beats the opponent’s cross; the cleaner work lands  (0.0 / 0.0)
R1 out    your boxer’s jab beats the opponent’s cut off the ring; the cleaner work lands  (5.6 / 0.0)
CORNER after round 1: yours ice_eye, theirs gloves_high | cards so far 9-10 9-10 9-10 9-10 9-10
R2 mid    nothing lands: your boxer’s roll and the opponent’s slip cancel; neither man commits  (0.0 / 0.0)
R2 mid    your boxer’s jab beats the opponent’s cut off the ring; the cleaner work lands  (6.4 / 0.0)
R2 mid    your boxer’s cross and the opponent’s cross trade; neither man gives ground — your boxer is down!  (11.7 / 8.5)
R2 mid    your boxer’s roll beats the opponent’s body hook; Roll counters Body hook  (0.0 / 0.0)
R2 mid    your boxer’s roll beats the opponent’s lead hook; Roll counters Lead hook  (0.0 / 0.0)
R2 inside the opponent’s cut off the ring beats your boxer’s cross; the shorter answer lands first  (5.1 / 0.0)
CORNER after round 2: yours breathe, theirs ice_eye | cards so far 10-8 10-8 10-8 10-8 10-8
R3 mid    your boxer’s lead hook and the opponent’s cut off the ring trade; neither man gives ground  (5.8 / 0.0)
R3 mid    your boxer’s jab and the opponent’s lead hook trade; neither man gives ground  (3.4 / 9.3)
R3 mid    your boxer’s roll and the opponent’s cross trade; neither man gives ground  (0.0 / 8.2)
R3 mid    the opponent’s cross beats your boxer’s jab; Cross beats Jab at mid/inside  (1.5 / 0.0)
R3 mid    your boxer’s block beats the opponent’s jab; the cleaner work lands  (0.0 / 0.6)
R3 mid    your boxer’s check hook and the opponent’s cross trade; neither man gives ground  (3.3 / 10.0)
RESULT {"winner":"opponent","method":"decision","round":3,"cards":["J. Alvarez 27-28","M. Petrov 27-28","S. Boateng 27-28","K. Osei 27-28","A. Novak 27-28"]}

--- bout 2 (Kwame Boateng v Tomas Reiner; both corners on the engine)
R1 inside the opponent’s uppercut beats your boxer’s cross counter; the shorter answer lands first  (4.6 / 20.8)
R1 inside your boxer’s uppercut beats the opponent’s check hook; the cleaner work lands  (20.2 / 3.8)
R1 inside the opponent’s body hook beats your boxer’s cross; the shorter answer lands first  (0.0 / 14.7)
R1 inside your boxer’s body hook beats the opponent’s slip; the cleaner work lands  (0.0 / 0.0)
R1 inside your boxer’s pull counter beats the opponent’s clinch; the cleaner work lands  (0.0 / 0.0)
R1 inside your boxer’s uppercut beats the opponent’s cross; the cleaner work lands  (20.2 / 4.8)
CORNER after round 1: yours study, theirs ice_eye | cards so far 9-10 10-9 10-9 10-9 9-10
R2 out    your boxer’s step back beats the opponent’s cross; the cleaner work lands  (0.0 / 0.0)
R2 out    your boxer’s cut off the ring and the opponent’s lead hook trade; neither man gives ground — your boxer is down!  (0.0 / 9.8)
R2 out    your boxer’s jab beats the opponent’s clinch; the cleaner work lands  (5.9 / 0.0)
R2 out    your boxer’s body hook and the opponent’s jab trade; neither man gives ground  (10.0 / 3.7)
R2 inside your boxer’s clinch beats the opponent’s roll; Clinch smothers Roll  (0.0 / 0.0)
R2 inside your boxer’s uppercut beats the opponent’s slip; Uppercut counters Slip — slipping into it — the opponent is down!  (26.3 / 0.0)
CORNER after round 2: yours ice_eye, theirs ice_eye | cards so far 10-8 10-8 10-8 10-8 10-8
R3 mid    the opponent’s check hook catches your boxer’s cut off the ring; Check hook beats Cut off  (0.0 / 19.2)
R3 out    the opponent’s step back beats your boxer’s clinch; the shorter answer lands first  (0.0 / 0.0)
R3 out    your boxer’s cross and the opponent’s lead hook trade; neither man gives ground  (0.0 / 4.2)
R3 out    the opponent’s slip beats your boxer’s clinch; the shorter answer lands first  (0.0 / 0.0)
R3 out    your boxer’s uppercut and the opponent’s body hook trade; neither man gives ground  (4.9 / 4.6)
R3 inside your boxer’s uppercut beats the opponent’s block; the cleaner work lands  (8.1 / 0.0)
RESULT {"winner":"player","method":"decision","round":3,"cards":["J. Alvarez 28-27","M. Petrov 29-27","S. Boateng 29-27","K. Osei 29-27","A. Novak 28-27"]}

--- bout 3 (Rio Tanaka v Piotr Zawada; your corner buys the look, calls the shape on the chip, and throws a second punch behind a card it expects to win)
R1 mid    the opponent’s cross counter catches your boxer’s slip-body hook; Cross counter beats Body hook [called "straight": right]  (0.0 / 21.9)
R1 mid    your boxer’s uppercut beats the opponent’s body hook; the cleaner work lands [called "looping": right]  (0.0 / 3.5)
R1 mid    your boxer’s roll-jab and the opponent’s step back trade; neither man gives ground [called "looping": wrong]  (5.6 / 0.0)
R1 out    your boxer’s step back beats the opponent’s body hook; clean, unanswered work [called "looping": right]  (0.0 / 0.0)
R1 out    your boxer’s slip beats the opponent’s step back; clean, unanswered work [called "escape": right]  (0.0 / 0.0)
R1 out    your boxer’s clinch and the opponent’s body hook trade; neither man gives ground [called "feint": wrong]  (0.0 / 6.6)
CORNER after round 1: yours breathe, theirs stool | cards so far 8-10 8-10 8-10 8-10 8-10
R2 mid    your boxer’s feint beats the opponent’s uppercut; clean, unanswered work [called "uppercut": right]  (0.0 / 0.0)
R2 mid    your boxer’s cross beats the opponent’s lead hook; the cleaner work lands — the opponent is down! [called "looping": right]  (28.9 / 0.0)
R2 mid    your boxer’s roll beats the opponent’s step back; clean, unanswered work [called "escape": right]  (0.0 / 0.0)
R2 inside the opponent’s body hook beats your boxer’s cross; the shorter answer lands first  (5.7 / 13.4)
R2 inside the opponent’s uppercut beats your boxer’s roll; Uppercut catches Roll  (0.0 / 0.0)
R2 inside your boxer’s slip beats the opponent’s cut off the ring; the cleaner work lands  (0.0 / 0.0)
CORNER after round 2: yours breathe, theirs ice_eye | cards so far 10-8 10-8 10-8 10-8 10-8
R3 inside the opponent’s body hook beats your boxer’s jab; the shorter answer lands first [called "feint": wrong]  (0.9 / 14.9)
R3 inside your boxer’s slip beats the opponent’s lead hook; Slip counters Lead hook on the inside  (0.0 / 0.0)
R3 inside nothing lands: your boxer’s step back and the opponent’s step back cancel; neither man commits  (0.0 / 0.0)
R3 inside your boxer’s roll beats the opponent’s body hook; Roll counters Body hook  (0.0 / 0.0)
R3 inside your boxer’s uppercut beats the opponent’s block; the cleaner work lands  (9.9 / 0.0)
R3 inside your boxer’s roll beats the opponent’s cross counter; the cleaner work lands  (0.0 / 0.0)
RESULT {"winner":"player","method":"decision","round":3,"cards":["J. Alvarez 28-27","M. Petrov 27-28","S. Boateng 27-28","K. Osei 28-27","A. Novak 28-27"]}
```
