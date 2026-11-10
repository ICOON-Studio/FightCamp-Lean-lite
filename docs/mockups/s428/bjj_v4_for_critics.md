# BJJ live choices v4 (for critics)

A design for what the player decides DURING a BJJ bout. Today's live bout has one decision (3 move calls), offered only when Ana holds
the initiative (BjjMatch.can_call needs init == 0), so nothing is offered while she is being passed or choked.

## 0. Rules (real, kept and fixed)
Kept: 5:00 white-belt match, points (takedown 2, sweep 2, knee on belly 2, pass 3, mount 4, back 4), advantages for a near miss (inside 0.10, at most
2 a match), the penalty ladder (marked, advantage, 2 points, out), the winner order at the bell (points, advantages, fewer penalties, referee).
Built FIRST (today tick() calls level points a draw and decide() passes advantages as [0, 0]).
THE 3 SECOND HOLD (the real rule, and the access hole): a position scores only when held 3 s. Today a pass pays on the roll and the initiative
changes only when Ana misses. v4: a move that lands STARTS a 3 s hold; the DEFENDER'S CARD opens INSIDE it for the side that is being passed or
taken (2 or 3 answers: frame and recover guard, turn into it, bridge and escape, concede and keep guard, stand), each with odds and gas; the points
are paid at 3 s unless an answer landed. Both sides use the same card (the rival's pick is the rival AI's, by her mode and archetype).
Fixed: every PIN (mount, back, side control, knee on belly, north-south) never stalls (BjjRef.gd); the 20 s count runs only on a guard or neutral hold
with no attempt; one penalty is two idle holds, about 66 s (STALL_PER_PEN 2). White-belt subs are filtered by belt (straight ankle lock only; John
confirms). PAID_ONCE is OUR rule (repeat resets when she escapes or sweeps). A bracket is single elimination of 8 at most: a loss ends the day.

## 1. The rival is somebody, and her mode is hidden
Each rival has an ARCHETYPE in her file (Wrestler, Guard puller, Back taker, Joint hunter, Scrambler, Pin grinder) that sets her mode weights. A MODE is
what she does for the next 20 to 40 s (INVENTED): Passing, Hunting a sub, Shooting, Holding a lead, Escaping, Scrambling. The mode moves the ROLL; it is
NEVER shown in the card's numbers. The card shows mode-blind odds as a range and what she has done THIS MATCH ("she stuffed the sweep 2 of 2").
Information the player has: her file (archetype word, habit chip, visible from the offer), HER BOOK (this match: the kinds she has attempted, in 14 words),
her gas word, and a CLUE that arrives 5 s after a mode starts (1 time in 4 a DECOY: she fakes the neck). The clue shows at the START of the mode when
she is SCOUTED and the decoy never shows. SCOUTING (the camp's film room) also reveals her REACTION TABLE ("when her pass is stuffed she takes the
back, 60%"; "when I stand she shoots, 70%"), a handful of when-A-she-does-B rows. The reaction table is the reward for scouting.
ADAPTATION is a RATE she shows, not adjacency: her answer odds to a kind rise with its share of Ana's last 6 picks (+0.04 per repeat above 2 of 6,
INVENTED), and the player SEES it ("her book on you: sweeps 4 of 6, she answers sweeps +12%"), so alternating alone does nothing; mixing does.

## 2. THE CARD (one slot in the centre: the move card or the defender's card; a crisis replaces it)
2 or 3 arrows of DIFFERENT kinds, each with mode-blind odds as a range, gas, and the miss cost. A 6 to 8 s timer, then the plan move runs; skip is free.
The clock policy: the mat clock does NOT pause; the clue lands at 3 s so it can still change the pick (clue at 3 s, card timer 8 s).
- CHAINS: the result of a pick opens the follow-ups of THAT result (a missed sweep opens the posted arm and the back take; a missed armbar the sweep and
  the stand), fed by the Playbook mat tree and the "felt" links.
- BAIT (the clever move; needs a scouted reaction row): a 0-point threat (a feint to stand, a fake shot) that triggers her scouted reaction and makes the
  next card's matching arrow +0.15 (the other +0.10); with no scouted row the bait is a coin flip and costs its gas. This is what scouting buys.
- WORK THE GRIPS: a free option on every card (no points, a small gas cost, +0.03 to the next pick in the position); a real corner's default.
- SUB ECONOMY: a sub's odds depend on the position (a pin high, guard low) and her sub defence; a repeat of the same sub inside 60 s is x0.6, a different
  threat resets it; the flat 10-point value in the offer ranking is cut so a 22% sub no longer out-scores everything. Offers are ranked by expected points
  AND by kind so the plan move is not always the sub.
- The opening card at the bell: pull guard, shoot, or tie up (no points for a pull in IBJJF), priced by her archetype.

## 3. THE EAR and PREDICT (the one resource and the one skill)
Ear: cap 4, refill 1 per 20 s of quiet (any spend restarts the timer; INVENTED) and at stoppages (out of bounds, a score, a penalty). A move pick costs 2,
a prediction 1, a bait 1. At 0 the plan move runs.
PREDICT: before the clue, the player may name her next mode (one slot, 6 words: "she goes for the back"). Right: +2 ear and the clue shows at once and the
pick that fits gets +0.05; wrong: lose the ear and the clue is 5 s late (and a decoy fools you). Her priors come from her file (the archetype word) and,
scouted, from the reaction table, so a scouted player predicts well and an unscouted player guesses. Probe bar: a scouted predictor beats an unscouted one by 5
or more wins in 100; spam of one prediction earns no more than +2.
The Why names the reading: "You predicted her back take 3 s before the clue. Her book on you: sweeps 4 of 6; you mixed and she dropped it."

## 4. Crises (only when the thing happens)
- THE COUNT (guard or neutral hold, no attempt): Show work / Climb a rung / Take the penalty, no hints. The referee's tendency is in her file (early stalling
  calls, generous advantages), so the first penalty is not always free.
- CAUGHT DEEP: a choke or a joint lock STAGED in three beats; each beat is an escape roll and a decision (fight on / tap, with the tap a SHOUT she obeys by trust
  and composure, over a standing order set in the Playbook). Single elimination: a tap is a loss and never saves her; the stake is injury. A joint lock fought
  to beat 2 injures (weeks out; the card shows the NEXT BOOKED FIGHT and the weeks), a choke finished costs a recovery day as well as the loss. Tapping a joint
  lock before a booked fight is a real comparison; tapping a choke is nearly never right.
No orders dial and no scheduler filler: quiet is allowed; the clue line, her book and the tell marker say when the next moment is due.

## 5. The open day and the corner minute (built second)
Gas and sore body places carry across the day (3 matches at most). The corner minute between matches is ONE choice: warm-up (gas), ice (heals a sore place),
food, or tape on the next opponent (a reaction row or a decoy removed); scouting competes with the gas it would have bought. The bracket is shown so the
choice is about a known next opponent. A single bout is one match with the same layers.

## 6. Where it appears (menus) and what each is wired to
| Screen | Shows | Wired to |
|---|---|---|
| Live bout: mat + her book | clue line, decoys, her gas word, habit chip, "her book on you", tell marker | RivalMode.of (hidden), match log, habit table |
| Live bout: the card | arrows by kind, mode-blind ranges, gas, miss cost, timer, skip, chain, BAIT, work the grips | BjjMatch offers (ranked by kind, sub economy), PAID_ONCE, mat tree |
| Live bout: the 3 s hold | the defender's card inside the hold | BjjMatch.resolve (hold timer), the rival AI's answer |
| Live bout: ear + prediction | ear pips with refill ring, the predict slot | ear rule, RivalMode |
| Live bout: crisis cards | the count, caught deep in three beats, the next booked fight | BjjRef, injury, the booking |
| Score plate | points, advantages (live), penalties, the count ring as the referee's raised hand | BjjMatch.decide |
| Timeline strip | used cards, predictions, tell markers | the match log |
| Playbook / mat tree | owned answers, the plan path, standing orders for the tap | move mastery 30 |
| Camp: film room / scouting | her archetype, reaction table, decoys, referee tendencies | opponent file |
| Open day + corner minute | carried gas and sore places, the one choice, the bracket | gas / injury carry-over |
| After-bout Why | each pick, prediction and bait against her real mode | the match log, grading rule |

## 7. Probe first (300 headless matches), then build order
Bars: each option is the best pick 15 to 60% of the times it is shown; no card number correlates with the hidden mode above 0.3; a scouted predictor beats an
unscouted by 5+; mixing beats repeating against adaptation and alternating alone does not; no strategy (skip everything, park a pin, spam one sub) beats best play;
ear is at 0 in 40% or more of bouts; gas under 0.5 for one side by 3:30 in a fair match (if gas never binds, the cost of a pick is free); the longest gap without a
real moment is 40 s or less. Order: 0 rules (winner order, advantages, belt filter, PAID_ONCE reset, the 3 s hold); 1 the defender's card and offer ranking and
sub economy; 2 RivalMode, archetypes, the clue, her book; 3 the merged card, chains, grips, skip; 4 ear and predict; 5 the staged crises; 6 the open day and
corner minute; 7 the opening card; 8 scouting: reaction table, BAIT, referee tendencies.

INVENTED (to the probe): modes of 20 to 40 s, the 5 s clue lag, the decoy 1 in 4, the adaptation +0.04 per repeat above 2 of 6, the bait +0.15 / +0.10, grips +0.03,
the repeat-sub x0.6, ear cap 4 / pick 2 / predict 1 / refill 1 per 20 s, predict +2 / +0.05, the injury weeks.
