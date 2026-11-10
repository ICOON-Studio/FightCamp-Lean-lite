Seat: IBJJF black-belt referee and corner coach who plays management games. My 10/10 drawing: docs/mockups/s428/bjj_v3_10_referee.png (source bjj_v3_10_referee.html).

# BJJ live choices v3: hard review

I read the pack, the design, BjjMatch.gd, BjjRef.gd and BjjBeat.gd (to see how initiative really moves).

## Scores (0-10, depth = linked decisions against a real rival)

| Part | Depth | One line |
|---|---|---|
| Whole design | 5 | Right problem found (the access hole), too many systems that are lookups once learned |
| Rival lean and modes | 6 | Best idea in the page; the card leaks the hidden mode, decoy is a flat die, adaptation can be dodged |
| Defender's card | 7 | Fixes the real hole. Missing the 3-second hold, the only real defensive moment |
| Orders (Survive / Points / Finish) | 4 | Three buttons set by the scoreboard; gas price is probably free |
| Move card and chains | 6 | Chains link picks; the odds shown make it a calculator unless state and hidden mode enter |
| The ear | 5 | Binds on paper; matched-word refund makes the cue bar free |
| Crisis cards and cue bar | 4 | Count: one free use then no-brainer. Caught deep: the answer is visible. Cue words: a position table |
| Open day and corner minute | 7 | The only layer with real stakes (carried gas, injury, scouting the next draw) and it is built second |

Look 5 (stamps and the referee's raised hand are good, but seven new concepts on one dark screen), clarity 4, what-to-do 5, anticipation 6, reward 6.

## Where the BJJ or the rules are wrong

1. **The 3-second hold is "kept" and then not used.** IBJJF scores a pass, sweep, mount or back only after 3 s of control. The code pays on the roll (BjjMatch.resolve adds points on a hit; SETTLE_S is 0.4). The defender's whole game is those 3 s: frame, bridge, recover before the points count. The v3 card opens "on a settle" and then waits for a beat (about 11 s), so the escape window never exists. Show the 3 s as a ring on the plate and let the defender's card answer INSIDE it. This is the single most real thing missing.
2. **Initiative only moves when Ana misses.** In BjjMatch.resolve a hit keeps the initiative with Ana; only a miss gives it to Kim (BjjBeat is better: the hitter keeps it, a miss may flip it). So the defender's card appears as a punishment for a miss, not as the flow of a match. A real rival who has just been passed or swept should be the one who must act. After a score the scored-on side should defend, and the scorer defends the position. Fix the initiative rule before building the card or the card opens too rarely.
3. **"Tapping a choke is nearly never right" is wrong.** A choke you fight and lose costs the match AND a knock-out (a lost day, a concussion check). The real decision is depth: a fresh choke is escapable, a deep one is not. The card should show escape odds sliding second by second (see the drawing). With a flat "choke: fight" standing order and no depth, the card has an obvious answer.
4. **Advantage cap of 2 a match is not an IBJJF rule.** Advantages are unlimited and only break ties. The cap is fine as our rule, but call it ours. Also: an advantage "inside 0.10 of the roll" makes attempt-spam pay in a tied match; tie it to the quality of the attempt (threat from a real position), and mostly near takedowns, near sweeps and near subs, rarely passes.
5. **Stalling.** One penalty for two idle holds (66 s) is much slower than a real referee. In the real sport the referee counts 20 s aloud and the first penalty is only marked (the doc has that right). A big missing source of variety is the REFEREE himself: some call stalling at 10 s, some let it run, some give advantages for almost nothing. Put the referee in the file (see the drawing).
6. **Pin pressure is not a real thing.** Holding mount for longer does not raise the bottom player's odds; what erodes is the top player's wind and grips. Keep the cost but name it as gas and grip, not "pressure".
7. **Missing standing restarts.** A white-belt match spends a large share on the feet and in double-guard gripping. The doc has an opening card only; every out-of-bounds restart and every referee stand-up is a new neutral moment (priced by archetype, score and clock). Build a reset card, not just the bell card.
8. White belt: the straight ankle lock is the only legal leg lock; kneebar illegal. Correct. Pulling guard scores nothing: correct. Winner order points, advantages, penalties, referee: correct.

## Dominant strategies I found

- **Park a pin and say "Stay heavy".** Pin pressure is +0.03 per 10 s; "Stay heavy" is -0.05 per use, 1 ear, and a matched word refunds 1. So after the first 4 points the player parks under SURVIVE and repeats one free word. The measured "first to score keeps the bout 80%" gets worse, not better. Fix: Stay heavy must have a price (a bigger gas cost, or it fails when she is in a "scrambling" mode).
- **Cue words are a table.** A word is right in 2 or 3 visible positions. The position is on the screen, so the human says the right word every time: free refund, no decision. The probe bar "no word read right more than 60%" tests a bot, not a player who knows the table. Rightness must depend on the HIDDEN mode (Frame is wrong when she is hunting the neck from side control, right when she is passing), so the player has to read.
- **Order oscillation.** Adaptation fires after the same order for 60 s. Flip Survive, Points, Survive every 55 s: 1 ear each, adaptation never triggers. Fix: the rival adapts to what LANDED, with a decaying memory, not to a timer on the label.
- **Take the first penalty.** The first stalling penalty is marked only (free). So at the count the card has one correct answer once, and then "Show work" is correct. Fix: price the first penalty (it breaks a tie against you; the next one is an advantage for her), and show the referee's tendency.
- **Sub-first.** In BjjMatch.offers a sub's value is a flat 10 pts, so any 20% sub outranks every other kind and the first arrow is always the sub. A missed sub costs only the initiative. If gas does not bind (MOVE_GAS 0.015, MISS_GAS 0.025 a move: about 0.3 for the whole match) there is no cost to spamming subs but the rival's turn. The doc already warns "probe gas first": agreed, I expect gas to be free at white belt as coded.
- **Skip everything + clock orders** probably loses to live play by little, because one 4-point pin early decides most matches already.

## The ear: does it bind?

On paper yes: cap 4, picks cost 2, refill 1 per 20 s of quiet. That is about one pick every 40 s, so 7 or 8 picks in 5:00 against 25 or more cards. Most cards go to the plan move, which is correct. The problem is what the player spends it ON: if each card shows true odds, gas and the points, the best arrow is a computation and spending is the only decision ("is this card worth 2 ear?"). That is a real decision only when the cards differ a lot in value; show a value-of-picking hint only by the spread of the odds, never the answer. Also a matched-word refund removes the cost of the cue bar (above).

## Contradiction in section 4 and section 1

The card shows "how often she answers it in THIS mode" and the odds are mode-adjusted. That tells the player the hidden mode: the clue line, the decoy and the scouting all become redundant. Either print mode-blind base odds with a range (range narrows with tape), or let the answer-band come from the clue only. I drew the range version.

## Play one 5:00 bout, ask by ask

- 0:00 opening card (tie up / pull / shoot). Real decision, if her archetype is visible. 1 ear.
- 0:11 to 1:00: she shoots, Ana has the initiative after the sprawl, move card with the sub first. Take the sub (ev). Miss at 1:12, card now flips to the defender's card.
- 1:12 to 1:40: Kim on top. Defender's card: frame and shrimp is the plan move (41%), take it free. The player has nothing to do: skip is the best choice because ear matters more. Answer is always the plan move unless the card shows a mode clue.
- 1:40 she scores the pass. Count of points 0-3. No card (a stoppage refills 1 ear). Player has an idle 40 s: nothing to press but orders; Points. 
- 2:00 to 3:00: hold-and-count window, the count card appears when she stalls: Take the penalty (free). One correct answer.
- 3:00 to 5:00: Finish order and spam word. Ear is 4 at the cap; spend freely. The last two minutes are the first time a real tradeoff appears.
So gaps without anything to do: 40 s after each score, and the whole first minute if the opening card is a lookup.

## To reach 10/10 (most important first)

1. **Fix the initiative model and add the 3-second hold.** After a score, initiative goes to the side that must now act. Show a 3 s ring on every pass, sweep, mount and back. The defender's card opens inside it with escape, concede, counter. This is the real defence of the sport and the best card the game could have.
2. **Make cue-word rightness depend on the hidden mode, not the visible position.** Refund removed or capped by a cost: matched word refunds nothing, a wrong word costs 2. Then the cue bar is a read, not a table. Add the overheard corner (Kim's coach shouting, true 3 times in 4, truer when scouted) as the source of the clue; the decoy rate is per rival archetype and has a tell that tape reveals.
3. **Print mode-blind odds as a range.** The range narrows with tape and gas; the mode only ever reaches the player through the clue. Resolve the contradiction between sections 1 and 4.
4. **Put the referee in the file.** Referee Okafor counts stalling early and gives advantages freely, or lets everything run. It is visible at the draw and changes Points vs Finish and the count card. Cheap, real, scoutable.
5. **Make orders pay different prices by state, not by label.** Survive must cost points when she has a real lean to the beat of it; Finish must cost gas that binds (probe it first; if it does not bind, raise MOVE_GAS to where the tank is below 0.5 by 3:30 as the doc itself wants). Adaptation reads what landed, with decay, so oscillating is not free.
6. **Add grips as the free action on every card.** BjjBeat already has a grip stack (0 to 2 pips, +1 per work beat). Show the pips and put "Work the grips" on every card: no ear, costs the clock, the price is that she scores meanwhile. It is the real no-gi decision and it links to the cue words.
7. **Fix Caught deep.** Escape odds fall each second; the player chooses the second to tap. Price a choke-out (knock-out, 1-2 weeks) so tap-early is a live choice. Remove "a choke tap is nearly never right".
8. **Price the penalty ladder.** The first marked penalty breaks ties; the second gives her an advantage; show the count on the plate with the referee's tendency, so "take the penalty" is a late-match gamble, not a free first answer.
9. **A reset card at every standing restart** (out of bounds, stand-up), priced by archetype, score and clock, not just the bell.
10. **Ship the open day first, not last.** Carried gas, sore places and scouting the next opponent give the ear, the tap and the orders real stakes. Persist trust across fights so shouting wrong costs a later bout. After the bout, replay the timeline with her hidden mode drawn behind it, so every ask is graded against what she was really doing.
11. Probe bars to add: "the best arrow is the sub no more than 40% of the time", "a human-table cue strategy (right word every position) does not beat a neutral strategy by more than 3 wins in 100", "oscillating orders does not beat holding", "park-and-heavy loses to a rival who knows it".
