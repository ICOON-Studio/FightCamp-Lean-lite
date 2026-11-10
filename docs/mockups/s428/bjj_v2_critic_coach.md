Seat: BJJ coach (ex world-level no-gi competitor, game designer). 10/10 drawing: docs/mockups/s428/bjj_v2_10_coach.png (+ bjj_v2_10_coach.html)

# BJJ live choices v2: review

## Scores (0-10)
| Part | Score | One line |
|---|---|---|
| Whole design | 5 | Good bones (rival with a mode, a real-sport crisis layer). Still mostly a re-ranked menu: the state decides the answer, and the player's best play is a table lookup. |
| Rival mode | 6 | The best idea on the page, but it is defined as a function of state, so it adds a word, not a decision. Contradicts the code on who gets a card (see 1). |
| Layer A, orders | 4 | Three settings that follow the score and the clock: ahead = Survive, behind = Finish, level = Points. Changing costs ear, but nobody wants to stay on the wrong one. |
| Layer B, move card | 5 | Arrows of different kinds with odds and miss cost is right. No chain between cards, no memory, ear never binds, and it cannot open when the rival has the ball. |
| Layer C, crisis cards | 6 | "Tap!" as a shout over a standing order (choke: fight, joint lock: tap) is genuinely BJJ and the best-written idea. Too rare, and no decision at all in a single match. |
| Look | 5 | Plate, count as a raised hand, tell marker, timeline are good. Eight overlapping controls on one dark screen, no picture of it. |
| Clarity | 4 | Ear, trust, order lock, card timer, mode, tell, shout, standing orders and crisis cards: too many dials for a 5:00 match. Three of them say the same thing. |
| What to do | 5 | Busy at the start of each mode, empty in every pin and every defended stretch. |
| Anticipation | 6 | The tell marker and the "you are about to be hunted" beat are strong. The clock arithmetic hands you the answer instead. |
| Reward | 6 | LANDS / READ RIGHT stamps and the Why are fine. 8 to 15 wins in 100 is a sensible target. |

## 1. Where the rules or the code disagree with the page
1. **The card cannot open when the mode matters.** `BjjMatch.can_call` needs `init == 0` (Ana has the initiative), and `offers()` builds only Ana's attacks. But "Smashing the pass" and "Hunting the neck" are exactly the stretches where Kim has the initiative, and the mode table promises that escapes get better there. In code the player gets no card in those modes. v2 needs a defender's card (frame, recover guard, come up, turn in) that opens when she attacks. Without it, 40 to 60 s of every match is watching.
2. **The clock arithmetic example is self-contradictory.** It says "riding side control for 2 points can run mark, advantage, 2 points". Side control is a pin, pins never stall (v2's own rule), and a pass there pays 3, not 2. Also `BjjRef.STALL_PER_PEN = 2` holds of about 33 s each, so one penalty is about 66 s, not one 20 s count. "60 s is three 20 s counts" is false against the code. Fix the words before they are on screen.
3. **Mode as a function of state is a lookup in disguise.** "Sitting on the lead" is "she is ahead", "Gassed" is "gas under x", "Smashing the pass" is "she is on top passing". The player already sees all of these. A tell 5 s before a mode that is computed from state is not a tell, it is a countdown. A mode has to be a commitment (she picks it from her file and holds it 20 to 40 s even if the state changes) or the whole table is a restatement.
4. **Kneebar at white belt: not legal.** IBJJF no-gi at white allows the straight ankle lock only; kneebar opens at blue, heel hook at brown and black (John to confirm the exact table). `SUB_TAGS` and `TAG_SYLLABUS` list knee_bar, heel_hook, monoplata; they must be filtered by belt. Also no slams, no reaping, no bicep or calf slicer at white.
5. **"Lutem" / "Lute"**: the referee says "Lutem" (plural) in practice. Minor.
6. **PAID_ONCE is a real rule, not a design choice.** IBJJF pays a position again only after the opponent has improved or escaped. The code resets on any move the opponent lands (including a plain "advance"); it should reset on her escape, sweep or guard recovery only. Say so on the page.
7. **"Guard pull makes worse vs wrestling-up" is half wrong.** At white belt, pulling against a shooter is the standard safe answer (0 points, no takedown). It should be good if Ana's guard is better than her wrestling and bad only if the rival's pass is better. Let the file decide, not the mode.
8. **Advantages are capped at 2 a match and come from a roll inside 0.10.** IBJJF has no cap. Fine as a design number, but show the roll to the player ("near miss") or a missed Kimura that earns an advantage looks like luck.
9. **Ev ranking favours subs always.** In `offers()`, a 22% sub scores 10 x 0.22 - 1.5 x 0.78 = 1.03 against a pass at 0.9 and a sweep at 0.55. So the plan move is the sub nearly every time, and the Finish order's "subs weighted" is redundant. Fix the ranking before the probe or the probe will say "the top pick is the same 60% of the time" and pass for the wrong reason.

## 2. Playing it in my head, ask by ask
**One 5:00 white-belt bout (Ana v Kim, Kim a wrestler who fades after 3:30).**
- Bell. Opening card: pull or wrestle, "priced by her mode". Mode at the bell is "Fresh and loose", which makes nothing better or worse, so the price is blank. The answer is whatever Ana drilled. Always the same, unless the scouted file already says Kim is a wrestler. It must read the file, not the mode.
- 0:15 to 1:00. Ana in guard with the ball. Cards open, three arrows. Ear 6 to 4 to 2. Highest odds wins, because there is no mode difference to read. Nothing to learn.
- 1:00 Kim switches to Smashing the pass. Ana is under half guard, Kim has the initiative: **no card opens** (point 1). The player can change the order (1 ear, locked 20 s) or shout. Survive is correct because Ana is behind or even; shout "Frame" because it is the cue word right in that position. Same answer every time.
- 2:30 clock arithmetic bar: Ana ahead by 2 means Survive; behind means Finish. It decides for you.
- 3:30 Kim fades. Finish and a sub card. This is the one live decision, and the best one: reading the file ("fades after 3:30") and committing the tank. It works.
- Last minute: the same arithmetic, the same answer.
- Counted decisions that are real: about three. Counted decisions that are lookups: the rest.

**One open-day bout (8 bracket, match 2 of 3).** As written, v2 sets gas and injury carry-over as step 7 of 9 and "caught deep" with it. That is a mistake: the open day is where the design is deepest. Spending tank to finish match 1 fast (saves tank for match 2, but costs a tank now, and a failed Finish gives the initiative away), versus riding a safe decision, is a real budget. Scouting the next opponent from her last match, the warm-up/ice/food minute, a sore knee that removes the left-side sweeps: all linked, all with a price. Build gas carry-over first, not seventh.

**Where the player has nothing to do:** every stretch where Kim holds the initiative (no card), every pin (no shout is right except "Frame", the same word), the whole 20 s lock after an order, any quiet stretch after the ear is spent. Pinned in mount for 25 s the screen offers one right word.

## 3. The ear economy, tried to break it
- Refill is 1 per 12 s of quiet, cap 6, 5:00 = 25 refills plus the starting 6 = about 15 move picks if the player picked every time. A 5:00 white-belt bout has maybe 6 to 9 cards (call gap, heavy settle). Ear never runs out. The "last minute is a learnable play" claim is false at these numbers; at the cap, refill is wasted, so the optimum is to spend, not to save.
- A shout that is READ RIGHT refunds 1. A shout costs 1. So a right shout is free. Positional cue words are "right in two or three positions", so one word is always right in each position. Spam the table: infinite shouts, trust rising +1 each. This is the degenerate line. Fix: the refund only for a read that matched her *mode* (not her position), a cap of one refund a minute, wrong = 2 ear and -2 trust.
- A bot that ignores every ask must lose by 8; but a bot that sets the Playbook standing orders well and then never touches the screen is the other benchmark and it is missing. If the table is a lookup, that bot ties the live player. Add: a live bot must beat a pre-set-only bot by 6 or more, and a pre-set bot must beat an empty plan by 4 or more.
- Ear, trust, order lock and gas-hurts-the-card all limit the same thing (how often you talk). Keep one: ear, and drop the time refill for stoppages (below).

## 4. Options missing, useless, and what each one changes
**Missing (most important first):**
1. **Chains.** BJJ is "if she answers like that, then this". A missed sweep that gets a posted arm opens the Kimura or the back. Each card should be fed by the last pick's result: the arrows are the follow-ups to what just happened. v2 has no link between one card and the next except the mode. This is the biggest depth gap (depth = linked decisions).
2. **Restarts.** In a real match the referee stops for out of bounds, penalties and scores; the athletes restart standing or in the stopped position. That is a natural decision point: pull, shoot, or sit; tempo; a word. Use it to refill ear (1 per restart) instead of "12 s of quiet". It is a real moment, it is not filler, and it answers the empty stretches.
3. **A defender's card** (above), and a **"Time check" shout**: a real coach shouts the clock and the score at the athlete. It costs 1 ear, shows the arithmetic only when asked.
4. **Choke sleep.** A fought choke needs a timer: hold too late and she goes to sleep, loses, and is out a week for a concussion-like rest. Without it, "fight it" is free in a choke.
5. **Body parts.** The boxing game has six body places. A sore knee or elbow after match 1 should remove or cut a family of moves in match 2. That links the open day to the bout card.
6. **The rival adapts.** Repeating a pick that landed within 60 s loses 8 points of odds. The page has this for Ana ("her best move") but not for Kim; add it for both. It kills spamming one arrow.
7. **A "pull or wrestle" restart read from the scouted file,** not from the mode.

**Useless or redundant:** the 20 s order lock plus the ear cost on an order (pick one); the 6 to 8 s card timer if the mat does not slow while the card is open (state it: 25% speed, or the card is a coin flip about reflexes); the "tunnel vision" cliff at 0.35 and the "under 0.5 fewer arrows" rule (one threshold is enough); "Finish +0.04 odds" (a number too small to feel); the trust meter (it duplicates ear).

**What each option changes:** Survive trades points for tank and gives Kim beats; Points keeps the ball and takes the free first penalty; Finish converts tank to a sub chance; a card pick changes the next position and the next card; a shout changes the odds of the next beat for a cost; a standing order decides what Ana does when you are silent. State each on the screen in one line, as in the drawing.

## 5. Layers: what would make each worth 8
- **Orders:** add a second axis. Not "how hard" but "where": Wrestle / Pull guard / Scramble (stand, top, bottom). Today's three are a thermostat. Make Survive vs Finish depend on the rival's gas (a gassed rival makes Finish cheap, a fresh one makes it a tank burn); show it as her tank on the plate.
- **Move card:** chains, a repeat tax, defender cards, a 25% mat speed, and a cap of 3 arrows of different kinds that never repeat in the same mode twice in a row.
- **Rival mode:** a committed, hidden-until-read mode picked from her file, with a decoy (she shows Hunting the neck for 4 s, then wrestles), a tell the player can misread, and an adaptation to Ana's habits (she stops posting her left hand after Ana hits the Kimura twice).
- **Crisis:** a single-match decision for caught deep (the sleep timer), the count card with a real fork (first penalty free, so "take it" is right early, wrong later: show the penalty pips), and an open-day injury choice.

## To reach 10/10 (most important first)
1. Fix the access hole: build a defender's card that opens when the rival has the initiative, and rank offers so the plan move is not always the sub.
2. Chain cards: each card offers the follow-ups of the last pick's result (posted arm after a missed sweep, back after a missed armbar), fed by the Playbook mat tree and "felt" links.
3. Make the mode a hidden commitment from the rival's file with decoys, adaptation to repeated picks (both sides), and a tell the player can misread. Not a function of state.
4. Ear: refill at stoppages (out of bounds, scores, penalties) and one clean read a minute; a right word refunds only if it matched the mode; wrong costs 2 and trust. Target: ear binds in a 5:00 bout.
5. Build the open day first: gas, sore body places and the corner minute between matches carry across three matches; scout the next opponent from her last match.
6. Add restarts as the real decision point (pull, shoot, sit), and a "Time check" shout; drop the order lock and one of ear/trust.
7. Choke sleep and the count card with visible penalty pips; one fork each, no hints needed because the state is on the plate.
8. Rules: filter subs by belt (white: straight ankle lock only), reset PAID_ONCE on her escape or sweep only, fix the clock arithmetic words ("pins never stall", one penalty is about 66 s), and make the near-miss roll visible.
9. Probe bars to add: a pre-set-only bot beats an empty plan by 4 or more and loses to live play by 6 or more; ear binds in at least 40% of 5:00 bouts; no shout is READ RIGHT in more than 60% of its uses.
10. Draw the screen once and keep to eight controls at most (the drawing shows the budget: orders, ear + words, move card, standing orders, plate, timeline, tank and trust, clue line).
