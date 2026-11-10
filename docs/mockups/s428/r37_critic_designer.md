Seat: designer of management sims (football and boxing managers, Two Point, tycoon). My 10/10 drawing: docs/mockups/s428/r37_10_designer.png (+ r37_10_designer.html).

# R37 Ask for a fight: critic review

## Scores
| | Score |
|---|---|
| Depth, whole design | 5 |
| 1 When to ask (readiness) | 3 |
| 2 Which channel | 5 |
| 3 What kind of fight | 5 |
| 4 The wait and the reply | 4 |
| 5 When it falls through | 6 |
| 6 What it leaves behind (favours, reputation, the Why) | 5 |
| Look (a table of words; no screen drawn) | 3 |
| Clarity | 7 |
| What to do | 6 |
| Anticipation | 4 |
| Reward | 4 |

Depth means linked decisions with real rivals. Today the design has a good skeleton (ask, wait, reply, counter, fall-through) but most decisions are one-axis picks with a hidden dice roll behind them, and the player never sees the thing a manager sim runs on: who is actually out there.

## The economy by hand

Favours. 3 to 6 known clubs. Say 4 clubs with 1 to 2 favours each, so about 6. A clean show with a club earns 1 with that club, and an ask spends 1. A boxer fights about 4 to 6 times a season (lead 8 to 12 weeks plus a week or three of waiting), so the player makes about 5 asks a boxer a year. Each ask to a club that then delivers the fight spends 1 and earns 1 back. Net zero. Favours only bite when asks fail or when you pull out, and the design does not say whether a "nobody" reply still spends the favour. Today a favour is a counter that refills itself and has nothing else to buy. It is not a currency.

The app. $10 a month is $120 a year, against $9,000+ of cash and $450 a home ticket cut. It is a rounding error, so it is a toggle, not a choice. By hand: take 4 clubs with a 15% chance each of a free matching fighter, versus 15 clubs on the app. Network "nobody" is 0.85^4 = 52%. App "nobody" is 0.85^15 = 9%. In a thin pool (the one case the design says matters) the app wins every time, for $10. The catch is a higher pull-out rate, but a pull-out costs only camp weeks and the $450 cut, about $500 to $800 of lost time. At 15% pull-out that is roughly $100 to $120 an ask, a fair price. At 8% it is a bargain. The probe's bar ("no channel best in over 60% of asks") will pass overall because thick pools favour the free channels, and still hide that in every thin-pool ask the app is the answer. Test the bar per pool thickness, not overall.

Matchmaker. Free, an 8 to 12 week lead (so a full camp), a reply in about a week. This is today's offer system with a button. It is the dominant default for a thick pool and it is the baseline the other two must beat. The design never says what happens to the offers that arrive on their own today. If they stay, nobody has to ask. If they go, the player is forced to ask. Decide: the unsolicited offer becomes the matchmaker's pick, worse in fit on purpose, so asking beats waiting.

Lead against camp weeks. Ask day 0, reply day 1 to 7, fight 8 to 12 weeks after the card is set. About 9 to 13 weeks of the boxer sitting in BASE, no bout. The existing rule "a month without a fight: morale -6" lands at week 4 of that wait, and "bout booked +5" lands on booking. So the speed of the reply is worth about 11 morale points, which is a real reason to pay for a fast channel. The design does not mention it. It is the best hook for the wait and it is unused. The network and app channels also have no stated lead (a network ask lands on the other club's next show, which could be 2 weeks or 10).

Kinds. Amateur bouts have no purse. "Win chance down, growth and purse up" for a step-up is wrong for amateurs. What does a step-up win give? A rank place only after the 4-win entry, and a quicker road to "7 wins plus top-3" (instead of 9 wins). That is a real trade: two fewer fights needed against a lower win chance. It is not written in the design, so today step-up has no visible reward. A skills bout counts half a bout, has no stake, and is safe: it is a free +half bout, so every young boxer takes it, once. It is not a recurring choice. Like for like is the default and carries no decision.

## Is the wait dead time?
Mostly yes. Press CONTINUE, a flag lights on day 3, a card appears. Nothing the player does in those days changes the outcome, and the reply is a dice draw from a pool the player cannot see. The wait carries decisions only if: (a) the player can hold two asks and pick the better reply, (b) the pool is visible and changes (a club books its boxer, a boxer gets hurt) so a patient or fast ask pays, (c) the morale clock is shown. None is in the design.

## What the player decides that old offers did not give
Genuinely new: a choice of who to call, the weight gap he will take, a window, home or away, accept or reask on a counter, take or pull on a replacement. Not new in substance: the offer still arrives as a card with Accept or Pass. What is missing is the one thing an ask should add: choosing the opponent. Pros can already ask for a named boxer. Amateurs ask for a category, so the rival file, Frank Doyle's club and rematches never touch the ask.

## One season, ask by ask
1. Week 8, after the debut win. Readiness says ready. Matchmaker, like for like, 12-week window. Reply in a week: yes, a fair girl on 16 May. Accept. Two clicks, no information used, no feeling of cleverness.
2. After a win. Step up through the network, via the rival club. 3 days later a counter: "heavier by 1 kg, 2 more bouts". Accept or reask. The player cannot tell whether the counter is better or worse than what the app would give. Coin flip.
3. App for a hard weight: "nobody". Subscribe for a month, ask again: yes. The $10 never mattered.
4. A favour spent on Mile End, a clean show, a favour earned back. Bookkeeping.
5. A replacement comes late. Take or pull: a real beat, but the design does not price it (win chance, injury risk, the $450 cut, favour lost). Drawn in my 10/10.
6. Season ends. The Why says "you asked X and got Y". A nice line. The player never saw anything to be clever about.

What is missing for the player to feel clever: a visible pool (who is free at my weight, who is booked, which club owes me), odds shown before the ask (not just a thin-pool word), one tell worth acting on (a club's boxer unbeaten, a rival who beat you), a way to beat the dice (ask two clubs, watch a show to open a new club, spend a favour at the right moment).

## Too much, cut
- The Home card, the Mail reply and the Fights flag all show the same open request. One flag on the top bar, one card on the Fights page.
- A separate Club > People / Network screen. Fold the favour ledger and the club list into the ask screen itself.
- Readiness as a decision. It is a gate with a coach's word. Keep it as one line and four chips, not a full decision with its own band.
- The skills bout as a standing kind. Only while the boxer has fewer than 5 bouts.
- The "NO REPLY" outcome for the app. It is the same as nobody with another wording.
- Replies landing on three different days stop the clock three times a month. Land replies on the Monday page, except a counter with a deadline.

## To reach 10/10 (most important first)
1. Show the pool. A "Who is out there at this weight" board: each club in the network, how many free at her weight, booked or hurt, favours owed, and what they say, plus a count of unknown boxers on the app. Hover or watch a show to open a name. This is the information a manager sim lives on. Without it the channel choice is a coin flip.
2. Show odds before the ask. Chance of yes, days to reply, lead to the fight, pull-out risk, venue money (home $450 against away travel) on each channel card, each as a plain figure. The player is clever by reading them. The thin-pool word is not enough.
3. Fix the app so it is not a toggle: either a fee per ask or per accepted fight (about $60 to $100, close to the $160 outside partner), or a real pull-out rate (12 to 18%) with a cost the player sees (the $450 cut and a morale hit). Then probe the 60% bar separately for thin and thick pools.
4. Give favours something to buy. A favour also buys a free sparring partner of the opponent's style from that club (normally $160), a reserved slot on their card, or a reply a day sooner. Decide whether a failed ask spends one. Show favours as pips by club on the ask screen.
5. Make the wait carry weight. Show the morale clock on the ask (-6 on day 28, +5 on booking), let the player hold two asks (cost: two favours, one reply kept), and let the pool move (a club books its boxer before the reply). Replies land on a Monday page except a counter with a deadline.
6. Price every kind in the player's currency. Step up: win chance down about 15 points, +5 rep and a place, two fewer fights to a top-3 pro offer. Like for like: the safe volume road to 9 wins. Skills bout: half a bout, no risk, only under 5 bouts. Write the step-up reward as the shortcut to the pro offer, not a purse.
7. Counter offers should be a choice, not accept or reask. Offer two counters ("58 kg, same date" or "57 kg, three weeks later") and show the win chance change on each, with one button that asks the other channel.
8. Let the player name a club (and later a rival or a rematch) in the ask. This ties the ask to the rival file and the Why.
9. Price the fall-through: take the replacement (win chance, injury risk shown) or pull out (lose the $450 cut and one favour). Show both numbers on the card.
10. Settle the unsolicited offers: they become the matchmaker's default pick, worse fit on purpose, so asking beats waiting. Fix the doc clash (the pack says no ask until the first bout is fought, and also says "always once a boxer is signed").
11. A visible timeline under the ask: ask, reply, fight night, when the camp must start, the weigh-in margin, so the weeks cost is on screen.
