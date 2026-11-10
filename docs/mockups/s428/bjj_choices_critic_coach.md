Seat: 20 years a no-gi BJJ competitor and corner coach, then game design. My 10/10 drawing: `docs/mockups/s428/bjj_choices_10_coach.png` (source `bjj_choices_10_coach.html`).

I read CRITIC_PACK, CRITIC_ACCESS and `bjj_live_choices_page.md`, plus the constants in `BjjMatch.gd` and the header of `BjjRef.gd`. I did not open Miro or any other critic's file.

# Verdict

The page is honest about its inventions and starts from a real problem: one decision in five minutes, and a duplicate option. Its map of what a real corner says is mostly right. But nine named decisions are really three, and most of them are lookups: the "Right when" column is a state-to-answer table the player will learn in three bouts. The page also leaves out the biggest decision of a real no-gi match (the first 20 seconds on the feet), and the corner's real job between matches on an open day.

## Scores (depth = linked decisions against a real rival, not wording)

| | Score | Why |
|---|---|---|
| Whole design, depth | **5** | Real axes (tempo, points vs finish, the clock), but the answers are readable from the scoreboard. The rival never adapts. |
| D1 Move call | 4 | Fixing the duplicate is necessary, not depth. "Other kind plus PAID_ONCE" gives variety. It is still "biggest % that pays". |
| D2 Pace | 5 | A real trade (initiative vs gas). Becomes "Push early, Work, Slow when ahead" unless gas really binds. As filler it is asked too often. |
| D3 Referee count | 5 | The best real-sport texture ("the first penalty is free" is correct coaching). Only 0-2 times a match. Contradicts the code, see below. |
| D4 Points or finish | 6 | The central choice of the sport. Weak only because the "Right when" is a pure function of lead and clock. |
| D5 Answer their best move | 3 | A free buff (x0.8) with a fallback option that does nothing. The opponent never adapts, so there is no rival to answer. |
| D6 Back to the feet | 4 | Real (technical stand-up, getting out of guard), but it compares two odds and picks the bigger one. |
| D7 Caught deep | 6 | A true tension, and the bracket-day saving is real. Wrong in one thing: the athlete taps, not the corner (see below). |
| D8 The 2:30 word | 3 | A free, once-only word that duplicates D4 and D2 at a fixed time. There is no half-time in a belt match. |
| D9 The last minute | 5 | Real maths (60 s = three counts) and the best story. Its four options are an obvious function of the score, and it overlaps D2 and D4. |

| Other axis | Score |
|---|---|
| Look (a text page with an asset list, no drawn card, nothing to judge) | 4 |
| Clarity (three currencies: tokens, shouts, gas; "two a minute, third at half") | 5 |
| What to do (always something, but a forced filler ask is not a task) | 6 |
| Anticipation (clock marks and the red last minute are good; nothing is foreseeable beyond that) | 5 |
| Reward (the Why grades the call, but no visible "your word worked" in the moment) | 5 |

## What the nine really are

- Tempo and gas: D2, D8 (breathe), D9 (keep moving), the "Hold and breathe" option in D1.
- Points or finish (risk): D1's other-kind slot, D4, D8 (stay heavy / go get it), D9 (everything on it).
- Position plan (where she wants to be): D1, D6.
- Events the sport forces: D3 (the count), D7 (caught).
- Information: D5.

Three axes and two events. Listing them as nine inflates the count and breaks one rule of the owner's: one place per decision.

## Where the page is wrong or contradicts itself

1. **Side control and the stall count.** Section 0 says holding side control without progressing is stalling, and D1 says Hold in side control starts the count. `BjjRef.gd` says the opposite: pins (mount, back, side control, knee on belly, north-south) are never stalling. In real events, referees do call stalling on a top player who rides side control for a long time without trying to advance, but they call it late and rarely. Settle this before D3 is built: a count that fires on side control, with the code unchanged, will never fire. My drawing shows the page's reading (pins exempt only while worked, a move ends the count). Decide it first.
2. **A corner cannot make the athlete tap.** In IBJJF the athlete taps; a coach cannot stop a match. Real coaches shout "tap" and a trained athlete may listen or not. D7's "Tap" should be a shout that Ana obeys by trust, heart and composure, not a button. Better still, it is a standing order set before the door opens (my drawing, bottom right), so the live moment is the shout, not a menu.
3. **Kneebar legality at white belt.** I believe straight ankle lock is the only leg lock legal for adult white belts in IBJJF no-gi, and kneebars start at blue. D7 names the kneebar and SUB_TAGS includes it. Check it (John) against the legality table before a white-belt bout can end on one. I am not certain of the line.
4. **The bracket.** The pack says 8-person brackets, so at most 3 matches. The page says "3-5 matches". One of them is wrong.
5. **Level points at the bell** is a draw in `tick()`. A bracket cannot have a draw. The real order (advantages, then penalties, then the referee) belongs in the build; the page already flags it. Do it before D3, D4 or D9 are built, because all three pay out in advantages and penalties.
6. **"Lute".** The referee's word is "Lutem" (plural: fight). Cosmetic, but the count ring is a good idea if it is drawn like the referee's raised hand and counting fingers, not like a game timer.
7. **"Giving a position up and taking it back scores nothing"** is a game rule, not a clear IBJJF rule. Real referees score a repeated pass if the other athlete recovered guard in between. Keep PAID_ONCE as a design choice and say so, as it is true only until the other side lands a move.
8. **Gas at white belt.** Real white-belt matches are lost in minute 3-4 on cardio. The page is right to make gas matter, but the S390 note says gas was emptied by 3:00 and was then eased (MISS_GAS 0.06 to 0.025). If gas rarely binds, D2 and D6 are free. Probe this before building pace.

## What is missing (the big ones)

1. **The opening 20 seconds.** Shoot, pull guard, or tie up and wait. It is the decision a real corner shouts first ("get the underhook", "don't pull") and the page has no ask until the first settle. IBJJF scores no points for pulling guard; ADCC takes one point off. A pre-bout and 0:00 choice of "stay on the feet, take it down" against "pull and play guard" is a live decision that depends on who the opponent is.
2. **A rival who is somebody.** Wrestler, guard puller, leg-lock player, scrambler, back-taker. The page's D5 fires when the opponent "tried the same move twice", but the opponent is built from plain positional moves at 30. A scouted habit has to change what the right ask is, and the opponent should adapt after being hit twice (the same "she has adapted" rule that is agreed for boxing).
3. **The corner minute between matches on an open day.** Most of a real corner's value is warm-up, food, ice, cool-down, watching the next opponent's last match and one change to the plan. The page only carries Ana's gas over. This is where the D7 tap becomes real, and it is the BJJ version of the boxing corner minute the pack already has.
4. **The scoreboard as information.** The real board shows points, advantages and penalties. The page asks for dots; it should be the main read, not a footnote.
5. **Cue words that do something.** "Frame", "hips out", "underhook", "hand fight", "stay heavy" are listed as labels only. A real corner's cues are positional (a position has the right cue and the wrong one). That is where a rival-aware choice could live cheaply.
6. **A player-started shout.** The page asks the player; a real coach is proactive. A shout bar that is always live (cost: ear) and a card that appears only when the mat settles gives the player agency and removes the forced filler.
7. **Quiet.** A real corner stays quiet for long stretches on purpose. A 30 s forced ask makes silence impossible.

## Useless or duplicate

- D8 (the 2:30 word) as a decision: make it information (a clock and score board, free, no choice) or cut it.
- D5's "Let it come": it is the absence of a choice. Cut it or give it a price.
- D9's "Keep moving safe" and D2's "Slow it down" are the same thing at different times.
- "Third shout in a minute at half" and "four tokens" and gas are three currencies. One is enough.
- The scheduler's filler (D2 whenever things are quiet): the answer will be "Work" about 70% of the time.

## Play one 5:00 in my head

- 0:00-0:30. Standing. Ask: pace ("Work"). No real decision, and this is where a white-belt match tilts. Nothing to do.
- 0:33. First settle (guard). D1: plan move vs "different kind" vs hold. Pick the biggest %.
- 0:55. Quiet 30 s, the scheduler fires D2. "Work" again. Same answer.
- 1:15. D1 again. Pick the biggest %. A token is spent. 
- 1:40. D5 (habit seen twice): "Name the answer" if owned, else "Let it come". Obvious.
- 2:15. D2 again after a score change. "Slow it down" if ahead. Obvious.
- 2:30. D8: the card reads the score and offers the matching word. Obvious.
- 2:50. D4 only if a sub is also on offer. This is the first real choice. It depends on the clock and lead.
- 3:30. D3 if Ana held a non-pin. Real and good, 0-2 times.
- 4:00. D9. The score decides it.
- 4:20. D1 or D3 as they come.

Result: about four real decisions (D4, D3, D7 if it comes, D1 sometimes), six that are the same answer every time, and a token that runs out by 3:00 with no rule for what a D1 does with zero tokens (the page does not say). The player also has no way to be proactive and no way to see what is coming.

# To reach 10/10 (most important first)

1. **Cut nine to three axes plus two events.** One TEMPO control (Push / Work / Slow), one RISK control (points / finish, merges D4, D8, D9 and the "other kind" slot of D1), one PLAN control (where she wants to go, merges D1 and D6), plus the two forced events: the ref's count (D3) and caught deep (D7). Drop D8 as a decision (make it the board) and D5 as a free buff.
2. **Add the opening.** A pre-bout and a 0:00 choice: take it down, pull and play, or tie up. Score it by real rules (no points for pulling, or a minus in an ADCC night), and against the scouted opponent's type.
3. **Make the opponent a rival.** Four or five archetypes with visible gas, habits and an adaptation after two failed attempts. A scouted habit changes which option is the best pick. Probe: each option is the best pick 15-60% of the time against a mixed field, not "when ahead".
4. **Hide the lookup.** Remove "Right when" from the card. Show odds, points, gas and risk only. The best pick must depend on something hidden or priced: the opponent's gas word, her trust, an owned answer, the next bracket round. Run the probe from the page's own section 7 first.
5. **One currency: the corner's ear.** Replace tokens, the two-a-minute rule, the half-strength third shout and gas-as-ask-cost with a single EAR meter: a call costs 2, a word costs 1, it refills in quiet seconds and with trust, and at zero her standing orders run. Say what a D1 does at zero (the standing order, shown).
6. **Make the shout bar player-started and always live; make the card situational.** The card opens only on a mat settle or a forced event (count, caught). Quiet is allowed. Cut the 30 s forced filler ask.
7. **Make the tap a trust shout plus a standing order.** Set "choke: fight / joint lock: tap" in the Playbook; at the live moment the player can override with a shout, and Ana obeys by trust, heart and composure. Roll an injury on a fought joint lock. Fix the bracket count (3 matches) and build the between-match corner minute (warm-up, ice, food, scout the next opponent, one change).
8. **Fix the rules the page contradicts.** Settle whether side control and knee on belly can be stalled (code says no, page says yes). Make advantages and penalties live in `BjjMatch` and decide level points by advantages, penalties, then the referee. Confirm kneebar and ankle-lock legality at white belt.
9. **Put the real scoreboard on screen.** Points, advantages and penalties for both, the clock, a count ring drawn like the referee's raised hand and counting, and a clock that turns red at 1:00. The ladder of positions under the stage shows what each step pays and whether it is exempt.
10. **Show the reward in the moment.** A ticking plate on a landed call, a "your word worked / hurt" line, and the Why grading each ask against the moment (right, ok, wrong), with the swing in win chance.
11. **Make cue words positional.** Each cue is right in two or three positions and wrong in others, as real corner words are ("frame" in side control bottom, "hips heavy" on top), so the shout bar is a skill and not a label list.
12. **Probe before building.** On 300 headless matches: longest silence 40 s or less, no repeated ask, each option best in 15-60% of its showings, calls move win chance 3-10 in 100, and gas is below 0.5 for at least one side by 3:30 in a fair match.

The drawing shows 1, 5, 6, 7 (orders) and 9 on one screen at 3:52: Ana leads 2-0 on top in side control, Dani has an advantage, the ref's count is at 14, Dani is breathing hard, and the call card, shout bar, ear meter, timeline and standing orders are all readable at once.
