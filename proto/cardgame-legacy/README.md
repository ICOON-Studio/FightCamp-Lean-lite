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
