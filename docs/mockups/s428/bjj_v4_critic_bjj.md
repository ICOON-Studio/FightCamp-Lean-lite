Seat: BJJ black belt (world no-gi competitor, academy coach). My 10/10 drawing: docs/mockups/s428/bjj_v4_10_bjj.png (source bjj_v4_10_bjj.html)

# BJJ live choices v4: critic review

Read: CRITIC_PACK, CRITIC_ACCESS, bjj_v4_for_critics.md, scripts/rules/BjjMatch.gd, BjjRef.gd. No earlier version or score seen.

## Scores (0-10)

| Part | Depth | One line |
|---|---|---|
| WHOLE DESIGN | 5.5 | Best ideas in the game so far, but three of the five systems are lookups once scouted, and the 3 s hold contradicts the card timers |
| Hidden rival mode and her book | 6.5 | The strongest part. Hidden intent, decoy, a visible adaptation rate. Weak: the mode barely moves the roll, and modes ignore the position |
| The card: chains, bait, grips, sub economy | 5.5 | Chains and sub economy are real BJJ. Bait is dominant once scouted. "Work the grips" is either an exploit or a stall, undecided |
| The 3 s hold and defender's card | 6 | The truest rule in the page and it opens the defence. But the timing is impossible as written, the attacker gets no choice, and the answers are generic |
| Ear and PREDICT | 5 | Good instinct (the coach's voice is scarce). The predict payoff is an ear pump and the +0.05 is too small to read |
| Staged crises (count, caught deep) | 4.5 | Great tension, one decision (tap or not) that a single fact decides |
| Open day and corner minute | 4 | Carrying gas and sore places is right. One pick of four, and one of them is always correct |
| Look (as described) | 5 | A good layer cake in the list, but it is 12 things in one table. No picture was given |
| Clarity | 5 | Seven currencies: ear, gas, grips, clock, score plus advantages, penalties, her book. A white belt coach needs three |
| What to do | 6 | Clear when a card is up. Unclear when the ear is empty: the answer is "nothing", and then the screen is a film |
| Anticipation | 7 | Clue lag, tell marker, hold ring, refill ring. This is where it shines |
| Reward | 5 | The Why naming "you predicted her back take 3 s before the clue" is superb. In-bout feedback for a good read is +0.05 and a pip |

## What a black belt sees is right

- The 3 second hold is the actual rule. Points for a takedown, sweep, pass, mount and back are paid on control held 3 s. Defending inside those 3 s is where half of all real scrambles are decided. Making it the defender's moment is the single best idea here. It also fixes the hole in BjjMatch.resolve (line 326), where a hit pays the points at once and the other side never gets to act.
- Sub economy (a repeat of the same sub is read, a different threat resets it) is how real sub chains work (armbar to triangle to omoplata). A flat "10 points for any sub" at line 269 is wrong and the fix is right.
- Pins never stall, the count only runs on guard and neutral, one penalty is about 66 s of idle holds. IBJJF does not call the top for sitting in mount.
- Winner order (points, advantages, penalties, referee) matches the sport. The code today does call level points a draw (BjjMatch.tick line 352) and passes advantages as [0, 0] (decide, line 216): both must be built first, as the page says.
- Referee tendencies in the file ("early stall calls, generous advantages") are exactly what a team scouts.
- A decoy (the neck fake) is a real thing: a feint to choke that is meant to make you uncover your arm.
- Bracket of 8 and single elimination is right for an open. The gas and sore places carrying through the day is correct.
- Showing the odds as a RANGE and her book on you as a RATE ("sweeps 4 of 6, +12%") is clean design: the player sees the rival learning.

## Where the BJJ or the rules are wrong or unclear

1. THE TIMING CONTRADICTION. The hold is 3 s. The defender's card opens "inside" it. But a card has a 6 to 8 s timer, the clue lands at 3 s (section 2) or 5 s (section 1: the two disagree), and "the mat clock does not pause". The defender's card cannot be read in 3 s. As written the defence is a reflex test, and the ear spent beforehand decides it. Either the clock slows during the hold (I draw 0.3x) or the card is dropped.
2. THE ATTACKER HAS NO CHOICE IN THE HOLD. In real BJJ the 3 s is the attacker's decision too: consolidate the position, go for the finish while the defender is still moving, or transition. Without it the hold is half a decision, and the "Passing" mode has no player-visible face. BjjMatch is single-initiative (a move that lands keeps the initiative, a miss hands it over, lines 307-337). The hold needs simultaneous resolution, not alternation. That is a rules change, not a card.
3. THE DEFENDER'S ANSWERS ARE ONE GENERIC LIST. "Frame and recover guard, turn into it, bridge and escape, concede and keep guard, stand" does not fit all positions. Against a shot: sprawl, whizzer, pull guard (and "stand" is wrong). Against a knee cut: frame and shrimp, underhook to knees, a kimura trap on the cut, give the pass and guard the neck. Against a back take: protect the neck, strip a hook, turn in. "Concede and keep guard" is contradictory: conceding a pass IS losing guard. Each position needs its own 3 to 4 answers.
4. "WORK THE GRIPS" IS GI LANGUAGE. In no-gi it is hand fighting: underhooks, wrist control, head position. More important: it is undecided whether it counts as an attempt for the stall. If it does, it is a free ear-less filler that never stalls and buys +0.03 each time: an exploit. If it does not, it is a stall risk in guard, which is right.
5. PENALTY LADDER IS TOO SLOW TO MATTER. 66 s per penalty, first penalty free, third is 2 points: in a 5:00 match the stall can barely reach penalty 2. "Take the penalty" is then nearly always correct on the first one. The referee tendency helps only a little. "Climb a rung" is never explained.
6. THE CAUGHT-DEEP DECISION IS A LOOKUP. In single elimination a tap loses the match and a finished choke loses it too. The only stake is injury and recovery. So: if a bout is booked inside N weeks, tap the joint lock; else fight on. That is one fact deciding. For a choke, tap is "nearly never right" the page says: that is the same lookup in reverse. Real choke defence is chin tuck, hand fight, turn in: that decision is missing.
7. THE ADVANTAGE CAP. "At most 2 a match" is invented and the sport has no cap. Mark it as ours.
8. NO PACE. The boxer has Push, Steady, Save (CRITIC_PACK 4.8). The BJJ athlete has none, yet gas is the whole story of the last minute of a 5:00. The page itself admits gas "never binds" (BjjMatch S390 halved MISS_GAS because both women were empty by 3:00). A 1.5 to 4 point gas cost per pick (MOVE_GAS 0.015 x drain 100) is invisible beside a pass.
9. NO SCORE AND CLOCK STRATEGY. The plan move is "best expected points" (offers() sorts by ev). That ignores the scoreboard. Trailing by 2 with 40 s left you must chase. Leading, you protect. Real coaches shout "we need two" or "hold it". This is the game plan of the sport and it is not a player decision here.
10. PRONOUNS. The page's screen text ("she stuffed the sweep", "her book", "she goes for the back") breaks tests/no_pronoun_test.gd and the S412 sandbox rule. Use the name or "the rival".
11. CLUE TIMING IS SELF-CONTRADICTORY. Section 1 says the clue arrives 5 s after a mode starts, section 2 says clue at 3 s, and a wrong PREDICT makes it "5 s late" (10 s?). One number.
12. PAID_ONCE as designed ("repeat resets when she escapes or sweeps") is not what the code does: resolve() resets the OTHER woman's ledger after ANY hit by `me` (line 332). Pick one.
13. WHITE-BELT LEG LOCKS. Straight ankle lock only is right for the rule set. Kneebar sits in TAG_SYLLABUS as a syllabus move, so make sure BeltRoad.OWNED_AT cannot teach it to a white belt.

## Play one 5:00 bout, ask by ask

Ana (white, owns double leg, knee cut, armbar from guard, kimura trap, arm drag) against Kim, Wrestler, scouted twice. Ear 4, pick 2, predict 1, bait 1.

1. 0:00 OPENING CARD: Shoot / Pull guard / Tie up. Kim is a Wrestler, her book says she wins shots. Pull guard would be right but earns nothing and Kim can pass. I take Tie up (a hands pick). Ear 2.
2. 0:11 Clue line is empty. PREDICT slot: Kim's modal mode is Shoot or Pass at about 40 percent. I predict Passing for 1 ear. Right: +2 net. This is the ear pump (see dominant strategies). Ear 3.
3. 0:24 CARD: arm drag / double leg / hands. The scouted reaction row says "when I stand she shoots 70%". I BAIT (stand-up feint, 1 ear) and the next card gives my sprawl +0.15. Ear 2.
4. 0:37 Card with the sprawl arrow. Kim shot as predicted. I take it, +0 (Kim's takedown stuffed, scramble). Ear 0. I am out of ear at 0:40 and I have spent all of it on offence.
5. 0:55 Kim has her pass: HOLD STARTS. The defender's card opens. Ear 0. The plan answer runs. This is the right design problem (offence versus defence for ear), but unfixable as written: I had no pip held back and 3 s is too short.
6. 1:02 Kim +3 (pass). Score 0-3. The clue line says "Kim, PASSING, 1:58" arrived late.
7. 1:10 A pin: Kim sits in side control. Pins never stall. I have no card (ear 0). The film is on and I watch.
8. 1:30 Ear back to 1 at 20 s of quiet. A crisis would be OK here but none comes. The "longest gap" bar (40 s) is missed here by a lot: 35 s with no decision, since the pin is owed 3 s of hold only.
9. 1:50 Kim goes to the back. CAUGHT DEEP beat 1: Fight on / tap. I fight on.
10. 2:07 Beat 2: fight on. Escape rolled. I live. Score 0-7.
11. 2:40 Ear 2. Card: guard recovery / sweep (stuffed 2 of 2, Kim answers sweeps +12%) / kimura trap. I mix: kimura, Kim hadn't been shown it. Hit, sub threat resets, Kim flinches.
12. 3:20 Sweep chain opens from the missed kimura: posted arm to back take. I take it. Hold, Kim defends, +4 at 3 s. 4-7.
13. 4:10 Count (guard, no attempt) on Kim: Kim "climbs a rung" automatically. I do nothing. The page does not give me a player decision here.
14. 4:50 I have 1 ear and a 3-point deficit. No Chase stance. The plan move (best EV) plays a 22% sub for 10 points EV, which lost. Loss 4-7.

What the run shows: the best decisions were the mixing and the one kimura bait, both real. The worst were: forced ear starvation (4 ear is 2 picks, so offence and defence compete, and the defence arrives in 3 s), a 35 s film at 1:10, and no way to say "we need points".

## Dominant strategy test: yes, there are four

1. SCOUT THEN BAIT. Once a reaction row is scouted at 60 to 70 percent, bait costs 1 ear and 0 points and gives +0.15 or +0.10 to the next pick. Bait before every pick beats picking alone. Fix: the table drifts with use.
2. THE PREDICT PUMP. Right: +2 ear. Wrong: lose 1. At a hit rate p above 33 percent the expected ear is positive. A Wrestler's modal mode is at 35 to 45 percent. Spam "Passing" and refill the ear forever. The cap "no more than +2 from spam" works only if the probe measures it: make it structural (one prediction per mode window; right refunds the 1, does not add 2).
3. PARK A PIN. Take mount (+4, 3 s), then sit: a pin never stalls, PAID_ONCE stops more points, and the clock runs. Winning 4-0 by riding is real BJJ, so the answer is not to forbid it. The answer is a price: heavy top pressure drains gas on the top, and the bottom's escape odds rise every beat the top makes no attempt. The "Holding a lead" mode is the rival doing this to you; the player needs the matching tool.
4. TAKE THE FIRST PENALTY. The first penalty is marked only. If the referee is not "early", taking it every time is free. Fix: refs carry a visible count, and the first penalty costs the first advantage when the file says "early".
Also checked: skip-everything (plan move) loses to a mixed player because the plan move is best-EV and the rival adapts to repeats: good. A 22% sub spam is cut by x0.6: good.

## Where it is useless or missing

- Useless: Ear 0 as a normal state. A resource that is empty in more than 40 percent of the bouts is a gate, not a resource, and it hits exactly when a defence card arrives.
- Useless: the predict slot's +0.05 on the fitting arrow. Nobody can feel 5 points on a 40 percent pick. The pick effect must be at least +0.10 to +0.15 or the clue does nothing.
- Missing: what a mode does to the roll. The page says "the mode moves the roll" and never says how much or in which direction. Without a 6 x 8 matrix (mode by kind of move) the design is a promise. This is the foundation of the depth.
- Missing: modes ignore position. A Passing mode while Kim is on bottom makes no sense. Each mode is valid only in certain positions.
- Missing: an attacker choice in the hold; position-specific defence answers; pace; chase/protect stance; a stall that has a price; the choke defence (chin tuck, hand fight) in the caught-deep beats.
- Missing: any link to existing mechanics. Trust (the morale table in the pack: Low 0.7 of the corner's word), Fight IQ and composure must set the ear cap and the tap obedience. The page mentions composure only for the tap.
- Missing: a reason to scout beyond the lookup. The reaction table, the decoy removal and the referee tendency are three lookups.
- Missing: the open day's real choice is time, not four buttons. A rest of 10 to 40 minutes should be a budget.

## To reach 10/10 (most important first)

1. FIX THE TIME MODEL. Slow the mat to 0.3x during a hold (draw the 3 s ring and "mat at 0.3x") so a 3-pip hold gives the player about 10 real seconds. Make the hold two-sided: the attacker gets a mini-card (Consolidate / Go for the finish / Transition), the defender gets the position-specific card, both resolve at the 3 s line. Replace single-initiative alternation in BjjMatch with this simultaneous step. One clue number (5 s) everywhere.
2. WRITE THE MODE x KIND MATRIX AND MAKE IT NON-TRANSITIVE. Six modes, eight kinds of move, a visible spread of at least 0.15 so reading the mode matters more than the pick. Make each pick the best response to two modes and the worst to one. Condition modes on position and score ("Kim leads: Holding a lead is up"). Probe for that before building.
3. MAKE SCOUTING NOT A LOOKUP. A scouted reaction row weakens each time it is used (70 to 45 after one use) and the rival re-reads by minute 3. The rival picks modes from a mix, not a table. The player must mix baits and picks; scouting gives a probability, not an answer.
4. REBUILD THE EAR. Cap from Fight IQ and trust (the existing morale trust factor). One pip is a defence reserve. Predict: one per mode window; right refunds the 1 and shows the clue now; wrong loses it and delays the clue. Fitting-arrow bonus +0.12. Raise the cap or lower the pick cost so ear is empty in 20 to 30 percent of bouts, not 40.
5. ADD THE PLAN LAYER OF THE SPORT. A standing PACE (Push, Steady, Save) and a STANCE (Chase, Even, Protect) that rewrites the plan move by score and clock. Trailing with 60 s left auto-offers Chase. Make the plan move the Playbook's lines ("when she cuts the knee: frame and shrimp"), not best expected points, so boxing and BJJ plans match.
6. GIVE THE DEFENDER REAL, POSITION-SPECIFIC ANSWERS. Shot: sprawl, whizzer, pull guard. Knee cut: frame and shrimp, underhook to knees, kimura trap, give the pass and guard the neck. Back: protect the neck, strip a hook, turn in. The "give it and protect the neck" answer is the true points-versus-finish tradeoff.
7. REBUILD THE CAUGHT-DEEP BEATS. Each beat has technical defences (chin tuck, hand fight, turn in; stack, hitchhike, posture) with different odds and gas, plus tap. Show the weeks out and the booked fight on the card, but the stake must not be a single fact. A tap should cost nothing but the match; a heavy fight-on should cost composure and a sore place that carries to the next round of the day.
8. PUT A PRICE ON PARKING AND ON GRIPS. A pin held with no attempt costs the top 2x gas and gives the bottom +0.03 escape per beat. "Win the hands" (not "grips") is stall-prone in guard and neutral, one use per position, never in a hold.
9. REBUILD THE CORNER MINUTE AS A TIME BUDGET. The rest between matches is 10 to 40 minutes: three slots out of five (warm-up, ice a sore place, food, watch the next opponent live, one plan line edit). The carried gas and sore places show their value in numbers.
10. FIX THE SMALL RULE ERRORS. Pronouns off the screen; the count "climb a rung" explained or cut; the advantage cap marked ours; PAID_ONCE rule stated to match the code; the penalty cadence tightened (the count after 20 s, a penalty each time) so the stall ladder is reachable in 5:00; white belt kneebar blocked in OWNED_AT.
11. PROBE ADDITIONS. Predict-pump EV; bait-always EV after a scouted table; pin-park; take-first-penalty; and the gap bar must be measured per position (35 s of a pin with no card is a gap). Add a 'chase when trailing' bar: the stance must win 10 or more in 100 against the same plan without it.
