Seat: veteran tactics and fighting-manager designer (solved choices, dominant strategies, hidden information, UI that tells the answer). My 10/10: `docs/mockups/s428/bjj_v3_10_tactics.png` (+ `.html`).

# BJJ live choices v3: hard review

Checked against `scripts/rules/BjjMatch.gd` (KIND_BASE, odds(), offers(), resolve(), can_call()) and the pack.

## Scores (0-10)

| Part | Depth | Why in one line |
|---|---|---|
| Whole design | 6 | The right skeleton (hidden mode, ear that binds, chains, open day) but three of its levers are lookups and the hidden mode leaks. |
| Rival lean and modes | 6 | Best idea on the page. Leaks through the card's odds and through the clue timing; scouting is worth about nothing as written. |
| Defender's card | 6 | Closes a real hole (a bout where you only watch). Shown odds make it an arithmetic choice. |
| Orders (Survive / Points / Finish) | 4 | A function of the scoreboard; the facts bar prints the input. Adaptation turns it into a toggle ritual. |
| Move card and chains | 7 | Chains are the only place where picks are linked. Under-specified; no deliberate set-up. |
| The ear | 5.5 | Binds well. Words are cheaper than picks and, being positional, are a lookup. |
| Crisis cards and cue bar | 4.5 | Choke is "always fight", joint lock is one comparison, cue bar is a table. Count and Her best move are good. |
| Open day | 6.5 | The stakes engine (carried gas, sore places, scouting). One paragraph; needs a rule that the corner minute is a choice. |

| Other | Score |
|---|---|
| Look (as specified: about 12 HUD elements on one screen) | 5 |
| Clarity | 4 |
| What to do | 5 |
| Anticipation | 6 |
| Reward | 6 |

## What is solved or leaks (read these first)

1. **The card's odds leak the hidden mode.** Section 1 says each mode changes the odds of each kind "by a stated amount", and the card prints odds plus "how often she answers it in this mode". A player reads the mode off the numbers (sweep odds fell 9 points, so she is passing). The clue lag, the decoys and the scouting are then decoration. Print mode-blind odds (own skill vs her skill, gas) and let the mode act only on the roll; show her answer history as what HAPPENED this match, never a mode-conditioned band.
2. **The clue lag collides with the card timer.** A card timer of 6 to 8 s and a clue 5 s after the mode starts means the clue arrives 1 to 3 s before the plan move auto-runs. If the clock pauses on the card the lag costs nothing; if it runs, the clue is too late to use and the only thing that matters is the pre-clue prior. The spec must say which. I assume it runs; then the clue is a post-mortem for the next beat, which is fine only if the next beat is in the same mode (a 20 to 40 s mode gives 2 to 3 beats of 11 s).
3. **Scouting is worth about 2 to 3 wins in 100 as written.** It buys a 5 s earlier clue and removes 1 decoy in 4. A player who just obeys the clue is right 75% of the time unscouted. The lean ("goes to the back when the pass is stuffed, 60%") is the one useful piece, because it predicts BEFORE the clue, but nothing in the design lets the player act on a prediction early. Fix in the list below (PREDICT).
4. **Cue words are two different mechanics.** Section 6 says each word is "right in two or three positions" (the position is on screen: a lookup, solved). Section 5 refunds a word that "matched the mode" (a read). Pick one. A positional word is a free table lookup that costs 1 ear; the probe bar "no word READ RIGHT in more than 60%" cannot hold with a 1-in-4 decoy rate and a clue the player obeys (75%).
5. **A word is cheaper than a pick.** At 75% right a word costs on average 0.5 ear (1 paid, 1 refunded when right, 2 when wrong) for +0.05; a pick costs a flat 2. The cheap thing is the lookup. The cap of one refund per 30 s helps but spam in the gap is still positive.
6. **Adaptation can be dodged by rote.** "Same kind twice in a row" is beaten by alternating A B A B; "same order for 60 s" is beaten by toggling the order every 55 s for 1 ear, cheaper than +0.15 on her counter. Both become rituals (never repeat, toggle on the clock). The rival must adapt to a RATE over the match (kinds she has answered, shown), not to an adjacency a player can read off a rule sheet.
7. **Orders are scoreboard-solved.** Ahead: Survive. Behind: Finish. Level: Points. The facts bar prints "3:52 left, two points up", the answer in factual form. The only real price is pin pressure and gas x1.4, and with MISS_GAS cut in S390 gas may never bind (the design itself says probe it first).
8. **Choke tap is solved.** A tap is a loss with no save in a single-elimination bracket, and a failed choke only costs the loss, so "fight a choke, always" is dominant. The joint-lock tap is one comparison against the weeks shown on the card. No timing: there is one shot, not a tightening choke.
9. **Sub EV dominates.** From `offers()`: ev = p x 10 - (1-p) x 1.5 for a sub against p x (pts + 0.5) - (1-p) x 0.5 for the rest. At KIND_BASE 0.22 and mastery 60 (x1.4) p is 0.31 and the sub ev is about 2.1 against about 1.3 for a 3-point pass. The design only ranks by kind; it does not change the number. Under FINISH (+0.04, then x1.4 gas) the white belt's best button is whichever owned sub exists. Bounded by owned subs (mastery 30 needed), so it is "spam the one sub you own, from any position", not a fight.
10. **The ladder only goes up.** TOP_RANK makes guard < half < side < mount < back strictly better for the top woman. Advancing has a cost only on a miss (init handed over). Nothing makes mount-to-back a trade (give the mount to take the back, risk the sweep in between).

## The dominant strategy (as specified)

Open "tie up". Orders POINTS until she scores once, then SURVIVE if ahead and FINISH if behind. Bank the ear at 4; skip every card that is not a sub or a ladder step (skip is free and the plan move is a sub or an advance anyway). Answer each clue with its matching word once per 30 s (refund keeps it free). Never repeat a kind, toggle the order every 55 s. Cash a pin only when the pressure bar says. Tap joint locks only with a booked bout inside the injury window, never a choke. This takes about 5 clicks a minute, no read, no risk. The pre-set-only bot loses to it by a few wins in 100, not 8 to 15 as the design hopes, because most of the live value is in the free lookups.

## Play a 5:00 bout ask by ask

White belt Ana (owns butterfly 45, kimura 40, knee slice 35, armbar 32) vs Kim Doyle, Wrestler, scouted from 2 tapes. Ear starts 4. Standing orders: choke fight, joint lock tap. Orders: POINTS.

| Time | What shows | I pick | Ear | Note |
|---|---|---|---|---|
| 0:00 | Opening card: pull guard / shoot / tie up | Tie up (her file: she shoots first) | 4 | Cost of the opening card is not stated. |
| 0:11 | Kim shoots. Defender's card: sprawl and go behind (38%), pull guard (55%), concede 2 | Sprawl | 2 | Odds shown: I take the highest value, no read. Miss: Kim 2-0. |
| 0:25 | Kim passing. Card: frame, turn in, concede | Skip (free, plan = frame) | 2 | Quiet, so +1 at 0:31. The skip is correct because the plan move is mode-blind and was right. |
| 0:40 | Clue line "clearing the knees". Cue bar | "Frame" | 3 | Matched, refunded. Free. |
| 1:10 | Ana holds guard. Move card: sweep 38 / kimura 30 / hold | Sweep (the clue and the odds agree) | 1 | LANDS 2-2. Real moment. |
| 1:30 | Kim on top again, card shows "she posts 2 of 2" | Skip | 1 | Saving ear for a real moment. |
| 1:55 | Count starts (no attempt, guard hold) | Show work | 0 | The first real crisis; fine. Ear 0, standing orders run. |
| 2:15 | Kim stalls; penalty | nothing to do | 1 | A flat stretch of about 40 s: no real decision. |
| 2:40 | Move card: armbar 24 (best EV by far) | Armbar (EV) | 0 | Miss, she is on top. The EV spike made it free money. |
| 3:12 | Kim on top, ahead 3-2. Defender's card | Frame and recover | 0 | Poor ear: runs the plan. |
| 3:30 | Order dial | FINISH (behind, 1:30 left) | 0 | The scoreboard told me; the change costs 1 ear I do not have, so it stays POINTS. |
| 4:05 | Caught deep: Kim's front headlock choke | Fight (standing order) | 0 | Choke: the card is a formality. |
| 4:40 | Tapped: loss on a submission. | | | |

What I felt: three genuine moments (0:11, 1:10, 2:40), one flat 40 s, a card that told me the answer (the odds on 2:40), two cards where my action was forced by the scoreboard (3:30, 4:05). I never felt clever: I never predicted anything before it happened.

## What is missing for a player to feel clever

1. A **prediction I can make and be proven right on** (calling her mode before the clue). Now I can only react.
2. A **deliberate set-up**: "I feed her the reaction I scouted, then cash the opening it makes". The chain only opens after a miss; there is no bait that works as designed.
3. A visible **"you read it 3 s before her clue"** line in the Why and a stamp on the timeline. Reward today is LANDS/MISSED, which is luck language.
4. A **cost to the player's own deception**: nothing in v3 lets Ana lie. A rival that cannot be bluffed makes the mode game one-way.
5. **Information that costs something to get**, so scouting competes with the other uses of the corner minute.
6. A **tightening choke** or sub with stages, so the tap is a timing choice.

## To reach 10/10 (most important first)

1. **Stop the card leaking the mode.** Show mode-blind odds and gas; show her answer history (what she did this match), never a mode-conditioned band. Mode only moves the roll. Probe bar: no card number correlates with the hidden mode at above 0.3 across 300 bouts.
2. **Add PREDICT (name her next mode).** One slot, 1 ear, before the clue. Right: +2 ear and the clue shows at once; wrong: lose the ear and the clue is 5 s late. Priors come from her file (visible archetype word) and, scouted, from lean triggers ("stuffed pass -> back take 60%"). This is what makes scouting and the lag matter; probe that scouted prediction beats unscouted by 5 or more wins in 100.
3. **Make a scouted lean a TRIGGER table, not a clue speed-up.** Scouting reveals "when I do A she does B" pairs (her reaction table). Add the BAIT pick: a 0-point threat with a scouted reaction that opens the follow-up at +0.15 and the other at +0.10. This is the felt-clever move and links scouting, the chain and the Playbook.
4. **Fix the sub economy.** Sub odds depend on position control (a pin high, guard low) and on the rival's sub-defence; a second attempt at the same sub inside 60 s x0.6; a different threat resets it. Remove the EV 10 weight or cap it so a 22% sub no longer out-scores everything. Probe: no one option is best more than 60% of the times it is shown.
5. **Make orders cost something real.** Remove facts that print the answer ("two points up" is fine, "3:52 left" with a verdict is not); keep only the quantities. Give SURVIVE a real price beyond pin pressure (a held lead draws the count in a guard hold), FINISH a price in the rival's counter-chance, and make the order change a cost that scales (1, 2 if flipped twice in 90 s).
6. **One cue-word rule.** Words are right against her MODE only (a read); the position is never a hint. Price a word at 1 and a wrong word at 2 plus trust, but cap refunds per 30 s and make a repeat of the same word in 40 s cost 1 more. Probe bar: spam of the matching word earns no more than +2 wins in 100.
7. **Rival adapts to a rate, and the player sees it.** "Her book on you" shows the kinds and orders she has seen this match; her answer odds rise with the share of the last 6 picks that were the same kind. No adjacency rule; alternation no longer helps. It is shown (14 words) so the player can play around it.
8. **Stage the sub (CAUGHT DEEP).** A choke tightens in three beats; each is an escape roll and a decision (fight / tap). A fought choke that finishes costs a recovery day (not only the loss). A joint lock injures at stage 2. The tap becomes a timing call.
9. **The corner minute is a choice.** Pick one: warm-up (gas), ice (heals a sore place), food, or tape on the next opponent. Scouting then competes with the carried gas it would have bought. Show the bracket so the choice is about a known next opponent.
10. **Say the clock policy.** Does the mat clock pause on a card? If not, put the clue before the card timer ends (clue at 3 s, timer 8 s).
11. **Cut HUD load.** One decision slot at a time in the centre (move card or defender's card), crisis cards replace it, and the cue bar folds to six words. The screen in my drawing has 8 panels on 1920x1080; keep it at that and no more.
12. **Credit reading in the Why.** "You called her back take 3 s before the clue." "Her book on you: sweep x3, her answer +20%; you changed the order and she dropped it." Grade each ask against her real mode.

## My 10/10 drawing

`docs/mockups/s428/bjj_v3_10_tactics.png`: the live screen at 3:12 of an open-day match. The centre card shows mode-blind odds (38 / 55 / 21) with the BAIT pick, the chain it opens and "she has stuffed this 2 of 2 this match" (history, not mode). Under it the PREDICT strip with the cost and refund. Left: the mat, tanks, and Kim's book (file lines, this-match lines, "her book on you"). Right: ear pips with a refill ring, orders with their prices (no verdict), the cue bar with stamps. Bottom: the facts bar (quantities only) and the timeline with her tell marker.
