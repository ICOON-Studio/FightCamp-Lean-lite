A design for what the player decides DURING a BJJ bout. Today's live bout has one decision (3 move calls), offered only when Ana
holds the initiative (BjjMatch.can_call needs init == 0), so nothing is ever offered while she is being passed or choked.

## 0. Rules kept from the real sport, and the ones fixed
Kept: 5:00 white-belt match, point table (takedown 2, sweep 2, knee on belly 2, pass 3, mount 4, back 4), 3 s to hold a position,
advantages for a near miss (inside 0.10, at most 2 a match), the penalty ladder (marked, advantage, 2 points, out), the
winner order at the bell (points, advantages, fewer penalties, referee; today tick() calls level points a draw and decide() passes
advantages as [0, 0]: built FIRST).
Fixed (an earlier draft was wrong): every PIN (mount, back, side control, knee on belly, north-south) never stalls (BjjRef.gd); the
20 s "stalling" count runs only on a guard or neutral hold with no attempt; one penalty is two idle holds, about 66 s (BjjRef
STALL_PER_PEN 2 at about 33 s a hold), not 20 s. White-belt submissions are filtered by belt: straight ankle lock is the only leg lock
(John to confirm; the kneebar goes). PAID_ONCE is OUR rule (a position paid once scores nothing more until she escapes or sweeps it;
the repeat resets then). A bracket is single elimination of 8 at most: a loss ends the day.

## 1. The rival is somebody, and her lean is hidden
Each rival has an ARCHETYPE from her file (Wrestler, Guard puller, Back taker, Joint hunter, Scrambler, Pin grinder) that sets her
mode weights; the mode is what she is doing for the next 20 to 40 s (INVENTED): Passing, Hunting a sub, Shooting, Holding a lead,
Escaping, Scrambling (modes include the ones where SHE is underneath). The player does not see the mode as a label computed from the
scoreboard. What shows is a CLUE LINE that arrives 5 s after the mode starts, a DECOY 1 time in 4 (she fakes the neck and goes for the
arm; INVENTED), and her gas word. SCOUTING (tape of her last match, the camp's film room) turns the clue into her file's lean ("goes to
the back when the pass is stuffed, 60%") and removes the decoys; a scouted rival's clue shows at the start of the mode.
ADAPTATION: if Ana picks the same kind twice in a row, or holds the same order for 60 s, the rival's weights move toward the counter
(INVENTED +0.15 on that counter mode), and Ana's drilled answers shift them back. Each mode changes the ODDS of each kind by a stated
amount that differs by archetype (a table, in the probe) and the plan move is mode-blind (a pre-set plan is a bet, not a script).
Source: BjjMatch has her plan and the habit table (V6); a function `RivalMode.of(rival, state, rng)` draws the mode.

## 2. THE ACCESS HOLE and the defender's card
A card opens on a settle whoever has the initiative. When Ana holds the initiative the move card is as before; when the RIVAL does, the
DEFENDER'S CARD opens: 2 or 3 answers of different kinds (frame and recover guard, turn into it, bridge and escape, concede the pass
and keep guard, stand), each with odds, gas and what a miss costs (the pass scores for her). Real corners spend most of a match on this
card. Offers are ranked by what they are worth AND by kind, so the plan move is not always the sub (a 22% sub already out-scores a
sweep or a pass on expected points today).

## 3. Layer A - ORDERS (replaces pace, the 2:30 word and the last minute)
One standing dial, SURVIVE / POINTS / FINISH. Changing it costs 1 ear. There is NO lock (a mode lasts 20 to 40 s; a lock longer than
that cannot answer a mode). The bar prints FACTS ("two idle holds is a penalty; Ana has one", "she is breathing hard", "3:52 left,
two points up"), never the answer. Prices (so none is a dominant park):
- SURVIVE: lowest-loss moves, +gas; her mode weights shift toward the mode that beats it (adaptation, section 1), and a PIN held under
  Survive builds the PIN PRESSURE below.
- POINTS: scoring moves weighted; first penalty is free to take when ahead; a pin is cashed in for the next position.
- FINISH: subs and near-miss advantages weighted, odds +0.04, gas x1.4; below gas 0.35 the card shows one arrow (tunnel vision).
PIN PRESSURE (the price of parking): each 10 s held in a pin without moving on raises her escape and reversal odds by +0.03 (INVENTED),
so a lead earned and parked erodes unless Ana advances; the card shows "advance to mount / back / sub" as the cash-in.

## 4. Layer B - the MOVE CARD and the chain
One card, 2 or 3 arrows of different kinds, odds, gas, miss cost, how often she answers it in this mode (a BAND, narrowed by
scouting). It never says which is right. A 6 to 8 s timer, then the plan move; skip is free. CHAINS: each pick's result opens the
follow-ups of THAT result (a missed sweep opens the posted arm and the back-take; a missed armbar the sweep and the stand), fed by
the Playbook mat tree and the "felt" links, so picks are linked, not isolated. The opening card at the bell: pull guard, shoot, or
tie up (no points for a pull in IBJJF), priced by her archetype.

## 5. One currency, the corner's EAR (it must bind)
Cap 4. A move pick costs 2; an order change or a cue word costs 1. Refill 1 every 20 s of QUIET (any spend restarts that timer; INVENTED), and
at stoppages (out of bounds, a score, a penalty). A cue word that MATCHED the mode refunds 1, at most once per 30 s; a wrong word costs 2 and
trust. At 0 her STANDING ORDERS run (set in the Playbook before the bell) and the card runs the plan move. PROBE BARS: ear is at 0 at some
point in 40% or more of 5:00 bouts, and no word is READ RIGHT in more than 60% of its uses.

## 6. Crisis cards (only when the thing happens) and the cue bar
- THE COUNT (guard or neutral hold, no attempt): Show work / Climb a rung / Take the penalty. Facts on the plate, no hints.
- HER BEST MOVE (she tried the same kind or sub twice): Name the answer (owned: her odds x0.8; felt: x0.95) / Beat it to the punch /
  Change the order. It costs ear, so it competes with the move card.
- CAUGHT DEEP: a choke or a joint lock. A corner cannot make an athlete tap: the live moment is the SHOUT "Tap!", obeyed by trust and
  composure, over a STANDING ORDER (set in the Playbook: "choke: fight, joint lock: tap"). A bracket is single elimination, so a tap
  is a loss and does NOT save her for the next round: the stake is injury. A fought joint lock that fails rolls an injury (weeks
  out, INVENTED); a choke that fails is only the loss. The card shows the NEXT BOOKED FIGHT and the weeks an injury would cost, so
  tapping a joint lock before a booked fight is a real choice and tapping a choke is nearly never right.
- THE CUE BAR is player-started and always live (a real coach is proactive): positional cue words ("Frame", "Hips out", "Underhook",
  "Hand fight", "Stay heavy", "Time"), each right in two or three positions and wrong elsewhere (its effect is a stated table: Frame +0.06
  to the escape from side control and half guard, Hips out +0.05 to the guard recovery, Stay heavy lowers her escape odds by 0.05 in a
  pin, Time shows the clock and her count, free), 1 ear each, stamped READ RIGHT / READ WRONG. No scheduler filler: quiet is allowed,
  and the clue line and the tell marker say when the next moment is due.

## 7. The open day and the corner minute (built second, after the rules)
On an open day (3 matches at most) gas and sore body places carry from one match to the next, the corner minute between matches has
warm-up, ice, food, the next opponent's last match to scout, and one change to the plan, and the bracket's draw shows who she can meet.
This gives scouting, ear and the tap their stakes. A single bout is a single match with the same live layers.

## 8. Results stamped live, and the size of the effect
Every pick stamps LANDS / MISSED; every word and order stamps READ RIGHT / READ WRONG with a live trust meter (right +1, wrong -2).
The Why grades each ask against her mode: right, ok, wrong. Probe target: good live play against a pre-set-only bot by 8 to 15 wins in 100,
and the pre-set-only bot beats an empty plan by 4 or more (so the Playbook matters) and loses to live play by 6 or more.

## 9. Where it appears (menus) and what each is wired to
| Screen | Shows | Wired to |
|---|---|---|
| Live bout: mat + clue line | her clue, decoys, her gas word, habit chip, tell marker | RivalMode.of, BjjMatch gas, habit table |
| Live bout: the move / defender's card | arrows by kind, odds, gas, miss cost, her answer band, 6-8 s timer, skip, chain follow-ups | BjjMatch offers (de-duplicated, ranked by kind), PAID_ONCE, mat tree |
| Live bout: orders bar and cue bar | SURVIVE / POINTS / FINISH with facts, cue words, the EAR meter, standing orders | order lever, ear, the match log |
| Live bout: crisis cards | the count, her best move, caught deep with the next booked fight | BjjRef count, match log, injury, the booking |
| Score plate | points, advantages (live), penalties, count ring drawn as the referee's raised hand, trust | BjjMatch.decide |
| Timeline strip | used cards, tell markers, red flags | the match log |
| Playbook / mat tree | owned answers, the game-plan path, standing orders | move mastery 30 |
| Camp: film room / scouting | her archetype, lean, decoys | opponent file |
| Open day and corner minute | carried gas and sore places, scouting the next opponent | gas and injury carry-over |
| After-bout Why | each pick, word and order against her mode | the match log, grading rule |

## 10. Probe first (300 headless matches), then the build order
Bars: each option is the best pick 15 to 60% of the times it is shown; no strategy (skip everything and set an order by the clock; park
a pin under Survive; spam cue words) beats best play; ear at 0 in 40% or more of bouts; longest gap without a real moment 40 s or
less; gas under 0.5 for one side by 3:30 in a fair match (if gas never binds, Push and the cliff are free: probe it first).
Order: 0 rules (winner order, advantages live, belt filter, PAID_ONCE reset); 1 the defender's card and offer ranking; 2 RivalMode,
archetypes and the clue line; 3 the merged card, chains, skip; 4 ear and the orders bar with pin pressure; 5 crisis cards and the
cue bar; 6 the open day, injury carry-over and the corner minute; 7 the opening card; 8 scouting and camp links.

INVENTED (to the probe): the six modes' 20 to 40 s, the 5 s clue lag, the decoy 1 in 4, adaptation +0.15, pin pressure +0.03 a 10 s,
ear cap 4 / pick 2 / word 1 / refill 1 per 20 s / refund 1 per 30 s, the cue words' odds, the injury weeks, the 8 to 15 target.
