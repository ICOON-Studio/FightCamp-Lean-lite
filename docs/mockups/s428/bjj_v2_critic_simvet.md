Seat: systems designer of competitive management and tactics games (dominant strategies, solved choices, hidden-information gaps). My 10/10: bjj_v2_10_simvet.png (+ bjj_v2_10_simvet.html), same folder.

# BJJ live choices v2 - review

## Scores (0-10)
| What | Score | One line |
|---|---|---|
| Whole design | 5 | The spine (a rival with a mode) is right. As written the mode is a label for state the player already sees, and the numbers behind the three layers leave most choices solvable by a lookup. |
| Layer A, orders | 4 | Survive / Points / Finish is chosen by score and clock. The clock arithmetic bar does the thinking. The 20 s lock is longer than a mode lasts, so orders cannot follow modes. |
| Layer B, move card | 5 | Best layer. But it shows odds, miss cost and answer rate for every arrow, so it is an EV sum. Ear (the corner's shared currency) is slack. The plan move is nearly what a player would pick. |
| Layer C, crisis cards | 5 | Her-best-move links the Playbook to the live bout (good). The count is blind or trivial. Caught deep has a logic hole (below). |
| Rival-mode idea | 5 | Real in 2 to 3 of 6 modes; the rest echo position, score or gas. |
| Look | 5 | Only the plate and chips are described, art is "after agreement". The plate carries about 14 live items. |
| Clarity | 4 | Ear refill rule is ambiguous, shout effects are undefined, 6-8 s to read about 15 numbers. |
| What to do | 6 | Mostly obvious: read the clue, pick, skip, set the dial. |
| Anticipation | 6 | The tell 5 s ahead and the 2:30 / 1:00 moments are good. All deterministic, so no dread. |
| Reward | 5 | LANDS / READ RIGHT stamps and trust are fine live feedback. The only payoff is the Why. |

## What the code says (BjjMatch.gd) that the page leans on
- Gas: MOVE 0.015, MISS 0.025 at cardio 50. A white-belt match is about 27 beats, so each side does about 13 moves and 6 misses: about 0.35 gas used. Gas ends the match near 0.65, and odds scale at only x0.6 to x1.0. The "under 0.35 tunnel vision" cliff is out of reach even with Finish at x1.4 (about 0.5 left). Section 7b admits this. Until gas is made to bind, the Finish cost is decoration.
- `ev` in `offers()` values a submission at 10 points. A sub is always the top EV, so the plan move is already "sub whenever owned". Subs have base odds 0.22 and a miss only flips the initiative. A Finish order on top of that stacks a dominant option on a dominant option.
- HOLD gives back 0.06 gas (four moves' worth) and keeps the initiative. Pins never stall (BjjRef). Together: park in a pin and hold.
- First score keeps the bout about 80% (S405 measurement, in the pack). Every later decision is working inside a settled bout.

## Degenerate play (the dominant strategies)
1. **Ear never binds.** Cap 6, refill 1 per 12 s, a card every 20 to 40 s. If refill runs on while you spend, income (about 2.5 per 30 s) beats the card price (2 per 30 s), so only shouts drain it. Banking is capped: a full tank refills in 72 s, so "hold ear for the last minute" means "do not spend in the 70 s before it" and nothing more. If the timer restarts on any spend, the rule is tight but the page does not say so. A landed read refunds 1: snowball for the player who reads correctly.
2. **Skip-all plus two dial turns.** Skip is free, shown, and the plan move is the best-EV move, which mostly equals the pick a player would make. Set Points at the bell, Survive when ahead after 3:30, Finish when behind: that bot gets most of the benefit. The probe bar ("a bot that ignores every ask") must include orders or it measures nothing.
3. **Pin parking.** Ahead and in side control, mount or back: Survive plus a free Hold, no stall count, initiative stays hers. Combined with the 80% first-score hold this ends the match at 3:00. Needs a cost: her escape attempts every beat while pinned, rising with time, with the top's pin gas falling.
4. **Orders and modes do not touch.** A mode lasts 20 to 40 s, the tell is 5 s, an order change locks 20 s. You cannot answer a tell with an order, so the mode matrix rows "Survive / Finish / Points" in section 1 are fiction. Orders are chosen from score and clock alone.
5. **The arithmetic bar solves layer A** at 2:30 and 1:00 ("riding side control can run mark, advantage, 2 points"). It gives the answer, so the player only reads. Facts, not the sum.
6. **Mode is a function of state the player sees.** `RivalMode.of(state)` reads position, initiative, gas, score and her last two attempts. Smashing = she is on top; Wrestling = standing; Sitting = she is ahead; Gassed = her gas word; Fresh and loose = nothing. A player who reads the plate already knows the mode. The only new information is the 5 s tell, and a deterministic function can be memorised in about five matches. After that it is a table (my "learnable" worry).
7. **The bell card is the most decisive choice and gets no information.** Fresh and loose is the null mode. Takedown scores, a guard pull does not, so unless Ana's guard is much better the answer is always "wrestle". The 80% first-score rule makes this the most important ask of the match.
8. **Caught deep contradicts the bracket.** "A tap saves her for the next round": in a single-elimination 8-person bracket a tap is a loss and she is out. Tapping saves her for the next open in 35 days, not the next round. So: joint lock, always tap (injury weeks); choke, always fight (no stated cost). Standing orders become a fixed table: "choke: fight, joint lock: tap". Fighting a choke needs a cost (gas -0.2, a dazed next match).
9. **The count card has no hints and no stated payoffs.** "Show work / Climb a rung / Take the penalty": taking the first penalty is free when ahead (said in Layer A) and the others depend on a pin being available, so it is a lookup or a coin flip, and it comes 0 to 2 times a match.
10. **Cards open only on her initiative.** BjjMatch `can_call` needs `init == 0`. The Smashing and Hunting rows say "better escape card", which implies a defensive card the page never creates. If cards open only when Ana has the initiative, the modes that hurt her (the ones with the most mid-match drama) never ask her anything.

## Options missing, useless, and what each changes
Missing:
- **A defensive card when she is attacked** (frame, turn in, re-guard, stand up, bridge out). This is where Smashing and Hunting live. Changes: the match has asks in the half of the time she does not hold the initiative.
- **Modes for the rival on the bottom** (sweeping, scrambling, closing the guard, shell). The list is all top-play. Ana on top gets no real mode to read.
- **The rival reading Ana.** In boxing the opponent adapts by round 2 (R25). Here nothing she sees changes her mode. Repeating a sweep should be answered after twice (the page has "her best move" only for her subs).
- **A shout effect.** The cue words are given a label, 1 ear and "READ RIGHT / WRONG", but no number: how many odds points does a right "Frame" give, for how long. Without it the stamp is a score for nothing.
- **Time cost of thinking.** The card has a 6 to 8 s timer. Is the sim paused? If paused it is a pressure ring and nothing else; if not, 6 s to read 15 numbers is a reflex test.
- **A reset beat** (stand up, restart from knees, re-guard): free options that spend gas and bank time.
- **Information that can be wrong:** at higher belts a mode clue she fakes, and scouting that widens or narrows the "she answers it" figure.

Useless or too weak:
- **Fresh and loose** as a mode (it does nothing). Replace by a lean (wrestler or puller) that comes from her file.
- **Gassed, fading** and **Sitting on the lead** duplicate her gas word and the scoreboard.
- **"Her answer rate" shown as a number** on every arrow: it makes the card an EV table (see the drawing for bands with a question mark that scouting narrows).
- **Standing orders for chokes** (never costs anything).
- **Order lock at 20 s** and **trust -2 / +1**: the asymmetry says "ask only when sure", which is fine, but with a free skip it makes "ask rarely" the equilibrium and pushes the match towards the plan move.

What the cuts change: "Slow it down", "Let it come", "Tie up and breathe" and "Set it up" going is right; Hold stays only where it has a price, which after the first bullet means "outside pins only" and so pin-parking is free.

## Do the six modes re-rank the options, or decorate?
Re-rank in earnest: **Hunting the neck** (turn-in up, sweeps down, Survive up), **Smashing the pass** (escape and stand up up, far-guard sweeps down) and, once cards exist, **Wrestling up** at the bell. **Sitting on the lead** is real only if it puts the count on HER and the player can use it, which depends on a reliable stall-count rule. The other three (Gassed, Fresh and loose, and the neutral part of Wrestling) re-rank by an amount the page never gives (just "makes better / worse"). The table needs numbers (odds shifts such as +0.10 / -0.12 per row) and the numbers need to differ by rival archetype, or the table is memorised once and every opponent is the same opponent.

## One 5:00 bout, ask by ask (Ana white belt, double leg 45, kimura 35; Kim wrestles)
- 0:00 Opening card: wrestle (about 48%, 2 points) or pull guard (0 points). Mode "Fresh and loose", no information. Takedown wins on numbers. Pay 2 ear (6 to 4) or skip, because the plan move is the takedown anyway. **Solved.**
- 0:12 Lands: 2-0. First score: about 80% of this match is decided.
- 0:41 Half guard on top, card: knee-cut pass (3, PAID once), kimura, back step. Mode Hunting the neck (she is under, going for guillotines). Pass 3 points. Worth the 2 ear? The plan move is the pass. **Skip is the same answer.**
- 1:30 Kim passes after a miss, 2-3. Smashing the pass. Ana has no initiative so no card. The only live decision: a shout (Frame, Hips out), which has no stated effect. A coin flip with 1 ear.
- 2:30 Order bar prints the 60 s arithmetic. Trailing by 1 with no count: Finish. The bar chose.
- 2:36 Tell: she changes. You cannot re-order (lock 20 s). You can only pick a card.
- 3:10 Card: Butterfly sweep, turn in, kimura. "She answers it in this mode": displayed as a number. Pick the highest EV. 2 ear.
- Real decisions made: about 3 (opening, first pass, order switch), the rest are "skip" or "which cue word". For 5:00 that is thin for a screen with a plate, an order bar, an ear meter, cue words and a card.

## An open-day bout (3 matches, gas and injury carry over)
- Round 1 against the 8 seed: Points. Finish in round 1 saves gas because a quick finish ends the match sooner. That is the one genuinely good tension in the design (a risky early win versus saving the tank for the final). Keep it.
- Between matches the corner minute (ice, food, warm-up, the next opponent's last match, one plan change) is a real set of choices and the best place for depth in the whole page. It is also listed as a prerequisite built late (step 7). Build it with layer B, not after.
- Final: Kim's mode, a joint lock catches Ana. Tap loses the day; fight and she rolls weeks out. The only reason to ever fight is a high escape chance the page never shows. Show the number and the price.
- Ear resets per match? Not stated. Carrying ear across the bracket would make the day a budget.

## To reach 10/10 (most important first)
1. **Make the mode a hidden lean the player reads, not a function of the plate.** Give each rival an archetype (wrestler, guard puller, leg locker, pressure passer) with her own mode mix and own table of odds shifts, scouted by tape study. Clue lines become fuzzy and more precise with scouting; at higher belts she can fake one. Add rival-on-bottom modes (sweeping, scrambling, shell). Cut Fresh and loose; keep Gassed as a state, not a mode.
2. **Put numbers on the table and hide the sum.** Each mode shifts named arrows by a stated amount (about +0.08 to +0.15 / -0.10). The card shows odds with a range, the miss cost in words, and "she answers it" as a band that scouting narrows; the exact EV is never printed. Make the plan move mode-blind and visibly dumber so skipping costs something.
3. **Tighten the ear.** Cap 4, refill 1 per 20 s, the timer restarts on any spend, a landed read refunds 1 at most once per 30 s, shouts and orders 1, picks 2. Probe bar: ear hits 0 in at least 40% of matches and the player who skips everything is 6 or more wins in 100 behind the player who spends well.
4. **Rival reads Ana.** After she sees the same kind twice, or the same order for 40 s, her mode drifts to answer it (a visible adapted note, 14 words). This kills repeating the same order and makes orders a mind game.
5. **Fix layer A:** no arithmetic conclusion (facts only; a better coach reads the count aloud at 1:00); lock 10 s with a small cost to flick (grips); Finish must cost real gas, so make gas bind first (probe MISS_GAS; target under 0.5 for one side by 3:30). Add an escape ramp in pins (pin parking has a price).
6. **Defensive card and a bell card with information.** A card when she holds the initiative: frame / turn / re-guard / stand up. The bell card priced by her file (wrestler or puller) and Ana's drills, with scouting visible.
7. **Define the shout.** Each cue: +0.05 odds on that position's best kind for 12 s if right, -0.05 if wrong, with a visible range per position. Cut to 5 cues.
8. **Fix caught deep and the count.** Single elimination means tap = out: show the number (escape chance, injury weeks) and give fighting a choke a price (gas, dazed carry). Count card: show her gas and pin state, a real set of three answers with different costs.
9. **Pause or price the card.** Either the sim stops while the card is open and thinking costs the shown ear, or the timer is in match time so thinking is a beat. Show at most four numbers per arrow.
10. **Build the open-day corner minute with layer B**, carry ear and gas across the bracket, and add a bout-level "first score" dampener (a +0.03 odds a point trailing) so the late asks still matter when 80% of bouts are decided early.

Probe bars to add: no pick dominated in every mode; the Finish order wins more than 55% of its uses is a fail; pin-parking win rate under 60%; a bot that sets orders by score and skips every card loses to a best-play bot by 8 or more.

The drawing shows the live screen at 2:31 with these changes in: fuzzy bands, a mode-blind skip, ear with a refill clock, facts not answers on the order bar, the adapted note, and the tell marker on the match log.
