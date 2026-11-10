Seat: designer of competitive hidden-information games (poker-style bluffing, fighting-game mind games, auto-battler economies). My 10/10 drawing: docs/mockups/s428/bjj_v4_10_economy.png (source bjj_v4_10_economy.html).

# BJJ live choices v4: review

Read: CRITIC_PACK, CRITIC_ACCESS, bjj_v4_for_critics.md, scripts/rules/BjjMatch.gd (numbers checked). No earlier version or score seen.

## Scores (0-10)

| Part | Depth | One line |
|---|---|---|
| Whole design | **6** | Right skeleton (scarce resource, hidden state, scouting that buys information). The numbers that decide whether it is a game are missing, so it is a 6 on structure and unproven on content. |
| Hidden rival mode and her book | 6 | Archetype, mode, decoy, reaction table, book are the right layers. But the rival's mode is exogenous: it never reacts to what the player has done, so there is no mind game, only a weather forecast. |
| The card: chains, bait, grips, sub economy | 6 | Chains are a real tree. Bait is priced wrong (see below). Grips are close to free and stackable. At white belt the sub economy collapses to ONE sub. |
| The 3 s hold and defender's card | 6 | The best idea in the page: the bottom player finally decides. But a 6-8 s card inside a 3 s hold is a contradiction, and its ear cost is not stated. |
| Ear and PREDICT | 4 | The ear is a good rationing device. PREDICT is mostly a tax on a clue the player can wait for. |
| Staged crises | 5 | The count is fine. Caught deep is nearly "always fight on" under single elimination. |
| Open day and corner minute | 6 | Gas and soreness carried across 3 matches is the strongest long link. The corner minute is a thin menu of four, one of them usually obvious. |

Look 5 (no picture in the doc, only a screen inventory; about 14 elements compete for a 6-8 s window, so I fear it). Clarity 5. What-to-do 6 (the plan-move default is a good safety net). Anticipation 7 (clue line, tell marker, count ring, ear refill ring all say "a moment is coming"). Reward 6 (the Why names the read, but nothing marks the moment a read lands, live).

## The maths

**1. The size of the mode effect is the whole game and it is not written.** The mode "moves the roll", but by how much, and for which kind? Without a mode x kind matrix with magnitudes nothing here can be checked. If the effect is about 0.05, reading modes is worth about 0.1 points a pick and the page is decoration. If it is about 0.15, reading dominates and bait (+0.15) is the same size as a free read. Also: that matrix is static and game-wide. Players learn it in about 10 bouts through the Why, after which the only hidden thing is the mode, and the design reduces to "guess the mode, look up the answer". That is fine for depth 6, not 8. The matrix needs a per-rival or per-archetype twist so it cannot be memorised once.

**2. PREDICT is not a coin flip, but it is a skill about the wrong thing.**
- Unscouted: six modes, archetype weights, best guess about 30%. Ear value: right = net +1 (spend 1, get 2 back), wrong = -1. EV = 0.3(+1) + 0.7(-1) = -0.4 ear. Do not predict. The bet is correctly punished.
- Scouted, on a trigger ("sweep stuffed, she passes 60%"): EV = 0.6(+1) - 0.4 = +0.2 ear. Predict. This is real skill: reading when a row fires. Good.
- Scouted, off a trigger, about 35 to 45%: EV about 0 to -0.2. Skip.
- The flaw: the clue arrives 5 s after the mode starts, a mode lasts 20-40 s, the card window is 6-8 s and the mat clock does not pause. A player can simply WAIT for the clue and lose nothing real. So predict buys (a) +0.05 odds on one pick, about +0.1 points, and (b) at most 1 net ear. The page's own bar ("scouted beats unscouted by 5+ wins in 100") is hard to reach on those numbers: 3 right reads x 0.1 points is about 0.3 points a match, roughly 2 to 3 wins in 100. The bar will fail on the numbers as written.
- Fix: make the clue cost something. Either lock the pick before the clue shows (the clue then shows at lock-in, so predicting is the only way to know), or put the clue behind the ear (1 to look). Then the bet is worth what it claims.
- The doc has an inconsistency: "clue 5 s after a mode starts" and "clue at 3 s". Pick one.

**3. Adaptation punishes repeating but does not make mixing a decision.** +0.04 per repeat above 2 of 6 gives 3 of 6: -0.04, 4 of 6: -0.08, 6 of 6: -0.16. The doc's own example says 4 of 6 shows "+12%": the formula gives +8%. Fix one. Strategically: a three-kind rotation (2-2-2) is free, so the rule collapses to "never use a kind more than twice in six unless it is better by more than 0.04 per extra use". That is a heuristic a player solves in three bouts. Worse, kinds are position-gated (from guard the card offers sweep or sub or recover), so a guard player's sweep share is forced high; the design quietly punishes being on the bottom. Mixing becomes interesting only if (a) the rival's adaptation changes her MODE choice, not just her answer odds (she starts waiting for the sweep, so a sweep feint draws her into the back take), and (b) the player can use the book as a bait channel: feed four sweeps, then the sub. Today bait only exists through a scouted row, so the one hidden-information trick (false tells) is not available from the book.

**4. Does the ear bind?** Offence: yes. Start 4, pick = 2, refill 1 per 20 s of quiet, every spend restarts the timer. A sustained spender gets about 1 pip per 30 s and affords about 1 pick per 60 s after the opening burst, so about 7 to 9 picks in 5:00 against about 27 beats. Plan runs the rest, so the bar "ear at 0 in 40%" will likely pass. Good: "which card is worth it" is a real decision. Three problems:
- Defender's card ear cost is not stated. If it costs 2, a player who spent on offence cannot defend: "keep 2 in reserve" is the best tension in the page (I drew it). If it is free, there is no tension. State it: 2.
- Chain follow-ups at full price (2 each) make a 3-step line cost 6 ear: nobody builds chains. Follow-ups of a chain must be cheaper (1), or the chain tree is decoration.
- Scores refill the ear for both sides at a stoppage, so a trailing player is not starved; fine, keep.

**5. Does bait give a real tree?** Priced against a plain pick it loses. Bait (1 ear) plus the matched pick (2) costs 3 ear and 2 beats for +0.15 odds on one arrow. On a 2-point sweep: +0.3 points. A plain pick at about 0.35 x 2.5 gives about 0.9 points. Bait only wins when the matched arrow is a finish (a sub ends the match) or a 4-pointer. White belts have one legal sub, so it is almost never. Make bait pay in win chance rather than points, show that number on the card, and raise it when it targets a finish or a 4-point position.

**6. Grips.** Free in ear, +0.03 to the next pick, small gas. Nothing stated about stacking, and nothing says whether grips count as an "attempt" for the 20 s count. If they do, grips are a free refill engine: grip, grip, wait for ear, pick with +0.03. If they do not, they feed the stall clock and are a fair gamble. Say which. Cap the bonus (one stack).

**7. Dominant lines I can find (probe these, the bars do not catch them):**
- Park a lead on a pin. "Pins never stall" plus PAID_ONCE plus 3+4+4 up the ladder: take top, climb once, sit. The defender's card is the only exit and its escape odds are not given. If escape from a pin is under 30%, top game wins and the bottom archetypes (Guard puller, Joint hunter) are dead. Guard needs an offsetting edge: passing costs gas, a gassed top is sweepable.
- Take penalties when leading. A penalty is two idle holds, about 66 s. The first is "marked" (free). Two penalties burn about 130 s of a 300 s match. The referee tendency only makes the first not always free. That is a dominant lead-protection line unless the second penalty hurts (+1 advantage to the opponent).
- Caught deep: with single elimination a tap changes nothing but injury. With no booked fight, always fight on. That decision is empty most of the time.
- Gas does not bind as coded. With MOVE_GAS 0.015, MISS_GAS 0.025, cardio 50 (drain 1.0), about 14 moves each: about 0.42 lost, so gas is about 0.58 at the bell and about 0.65 at 3:30. The bar "gas under 0.5 by 3:30" fails, and a pick's gas cost (1.5 points of 100) is a rounding error against mastery factors. Raise the costs 2-3x, or drain gas while being pinned. The old HOLD (breathe, +0.06 gas, about four moves' worth) vanished from v4: bring it back as the rest option so gas has a use.
- White-belt sub economy: filtered to ONE sub, and repeats of the same sub inside 60 s are x0.6, "a different threat resets it". With no different threat available there is nothing to reset, so a sub is once a minute. Say what the other threats are at white belt (takedown feints, back take threats), or the rule is dead code for the shipped belt.

**8. Rival decision quality.** The rival AI uses the same card. What makes its answer exploitable? If it picks by mode and archetype only, it never responds to the player's last move, so an observant player beats it by pure forecasting. A real rival needs one thing that reads the player: a count of recent kinds (the same book) shifting its mode weights, and a visible "tell" of that shift ("Kim is waiting for the sweep"). The book already exists; use it for the rival's mode, not just its answer odds.

## One bout, ask by ask (white belt, scouted Wrestler Kim, Ana strong in guard, ear 4)

1. 0:00 Opening card: pull guard (0 pts), shoot, tie up. The Wrestler shoots; pull gives away points, shoot into a Wrestler is a coin flip. I tie up. **Wanted:** the three options priced by archetype so the choice is visible. Doc says "priced by her archetype": the card is where that shows. OK.
2. 0:11 Neutral card, ear 4: shoot, trip, grips. Grips are free, +0.03. I grip. Free action with no downside reads as correct, so I will always do it. (Dominance 6.)
3. 0:22 Kim shoots (clue "she is shooting" at once, scouted). Defender's card inside the 3 s hold: sprawl / underhooks / pull guard. The 3 s window is shorter than any card timer. I skim, pick sprawl. Ear 2. First moment of feeling busy, and real.
4. 0:50 Kim holds a takedown lead, mode "Holding a lead". The count starts. Choices: show work, climb a rung, take the penalty. I take the penalty (free first one). That is pure arithmetic, no cleverness.
5. 1:10 Sweep card, ear 2: sweep 29%, back take 37%, recover 58%. Book says sweeps 4 of 6, Kim answers +8%. I know "sweep stuffed, Kim passes 60%". I **predict** Passing (EV +0.2 ear). Right: clue comes at once, ear back to 3. I pick back take. Hits (+4). Feels clever: this is the page working.
6. 1:48 Ear 3. I want to set up a trap: bait "stand", Kim shoots 70%. Cost 1, then sweep +15% (hits, +2). Feels clever too, but the arithmetic above says a plain pick was worth more points. I did it because it felt good. The doc does not show me that it was right.
7. 2:20 Kim passes me (defender card, only 3 s, I had spent the ear: pick nothing). Plan answer runs, fails, Kim +3. This is the best moment: the ear price was visible. No complaint.
8. 2:51 I predict Hunting a sub off no row, it is Scrambling. Wrong, -1 ear and a late clue. Lesson learned, but unscouted a player does this and quits predicting. Expected.
9. 3:30 to 5:00 Leading 6-5. The only live choice is risk dial: protect or gamble. The card shows points and odds, not win chance. I cannot tell if the 37% back take at -5 win-chance risk is worth it. **The biggest missing instrument.**
10. 4:50 Bell. Why shows reads 2 of 3, bait sprung 1.

**What is still missing for the player to feel clever:**
- A **risk dial**: every arrow shows its effect on win chance given the score and the clock, not points. Leading, trailing and the last minute change the answer. This is poker's pot odds and the single best clarity gain.
- A **live read marker**: when a prediction lands or a bait springs, the screen says so on the spot ("you saw it 5 s before the clue"). Today the payoff waits for the Why.
- A **probe**: a cheap, visible action that reveals the rival's mode with a cost (poker's check). Right now the player either waits for a free clue or pays 1 ear to guess.
- The rival must **read the player** too. Otherwise "I outplayed the machine" is only forecasting.
- Chains that **save ear** (a planned two-step costs 3, not 4), so planning ahead is rewarded, not just reacting.

## To reach 10/10 (most important first)

1. **Write the mode x kind matrix with magnitudes** (per archetype) and probe that the best-kind-per-mode answer differs by archetype, so it cannot be memorised once. Without it nothing else can be tested.
2. **Show win-chance change per arrow, with the score and clock folded in**, next to points and odds. Narrow the odds range when the clue lands or the rival is scouted, so information visibly shrinks uncertainty. (Drawn.)
3. **Make PREDICT worth more than waiting.** Lock the pick before the clue shows, or charge 1 ear for the clue. Show the EV of the bet on the slot ("+0.2 ear at 60%, -0.4 at 30%"). Fix the 3 s versus 5 s clue lag contradiction.
4. **Fix the defender's card**: state its ear cost (2), give it a 3 s timer that matches the hold, show escape odds for each pin so the park-a-pin line can be probed, and give guard a counter-edge (a gassed top is sweepable).
5. **Make the rival read the player.** The book (last 6 kinds) must change the rival's MODE weights, not only her answer odds, and show it ("Kim is waiting for the sweep") so bait works through the book too. Fix the +8% / +12% mismatch.
6. **Reprice bait and chains**: chain follow-ups at 1 ear; bait displays its win-chance gain and is strongest toward a finish or a 4-point position; cap grips at one stack and say whether they stop the stall count.
7. **Make gas bind**: raise move and miss cost 2-3x, drain while pinned, bring HOLD back as the rest option. Bar to pass: gas under 0.5 for one side by 3:30.
8. **White-belt sub economy**: name the other threats that reset the x0.6, or drop the rule for white belts.
9. **Crises**: caught deep gets a real price: show the escape odds per beat and the injury weeks against the booked fight; with no booked fight, show "nothing to protect" so the default is explicit. Stalling when leading: a second penalty must cost an advantage.
10. **Live read markers** on the mat (read landed, bait sprung, decoy took you) and a **probe** action. Corner minute: add a 5th choice that trades gas for a read, so the four options stop being "ice if sore, else warm-up".
11. **Probe additions**: park-a-pin, take-penalties-when-leading, always-grips, never-predict, always-skip, each compared with best play, over scouted and unscouted rivals and over all six archetypes at white belt.
