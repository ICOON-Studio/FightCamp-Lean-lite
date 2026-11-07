# The BJJ fight, deep - design v4 (S397, for a blind critic panel)

FightCamp (Steam, Godot 4) is a boxing + no-gi BJJ gym manager. The player coaches Ana from white belt to black: each week
picks what Ana drills (moves on a game tree of positions: grey -> felt -> owned), enters IBJJF no-gi opens (single
elimination, 3-5 matches a day, 5-10 minutes by belt, divisions by belt and weight), and watches each match simulated beat
by beat or plays it live with 3 corner calls. Every opponent is generated on the same maths. [R] = a real number (sources:
ops/research/BJJ_REAL_NUMBERS_S397.md), [G] = our choice. Each PART is judged and built alone.

THE MATCH ENGINE (kept): a walk on a position graph (49 positions, 80 moves, 135 arrows: takedowns, pulls, sweeps, passes,
back takes, escapes, submissions). A beat is ~33 s. The side with the initiative either ACTS (takes its plan's next arrow or
its best expected arrow) or HOLDS (grip fighting, framing, circling: no roll, the initiative passes). A hit moves and scores
IBJJF points (takedown 2, sweep 2, knee on belly 2, pass 3, mount 4, back 4 [R]) and keeps the initiative; a miss slides as
far as the defender knows the answer, else resets, and the initiative passes. Odds of an arrow = its even-field base rate
[R, ADCC / FloGrappling attempt-to-success tables] x the attacker's mastery of the move / the defender's mastery of its best
answer, x chain, mood, the read; then every lever below adds on the logit (a zero lever = the calibrated number; 16
within-belt bars exist: sub rates, finish types, first scorer wins 80-87% [R]). New rules live in new small modules
(BjjGrip.gd, BjjPass.gd); the walk file only calls them.

## A. What a belt means
- One hidden lever: MAT TIME, a skill level (white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 at the start of each belt;
  the steps shrink up the belts). Within a belt an athlete sits by time at the belt (0 fresh -> 1 four-stripe) plus noise
  (+-0.3 levels: some white belts are sandbaggers, some blues were promoted early). Promotions take 1.5-4 years [R].
- Read ONCE: every arrow moves by MAT_W x (attacker's level - defender's) on the logit, attack and defence alike - so the
  senior both scores more AND finishes more, as in the data (the favourite submits / is submitted 53% / 9% at a 200 rating
  gap, 76% / 1% at 500+ [R nogiratings]). No second belt bonus anywhere (no belt composure table, no seasoned moves).
- Bars [R proxy: no-gi rating gaps; the coach's per-pair bands]: INSIDE a belt (what the player meets) a four-stripe vs a
  fresh athlete 66-76% (~a 100-200 rating gap [R]); a division's favourite (top quarter by mat time) wins its matches 65-72%
  [R: rated favourites 65.7%]. Across belts (gym rolls, superfights): white->blue 80-88%, blue->purple 70-80,
  purple->brown 65-75, brown->black 60-70, two belts 85-95, three+ 95-99, never above 99%; the senior's share of finishes in
  mismatches 60-75%. MAT_W fitted per the table in the harness (n >= 2,000 a cell) before anything is built on top.

## B. The grappler
- Body and mind, 0-100: strength, cardio, flexibility, explosiveness, composure, aggression; body facts: weight within the
  division (light / mid / heavy end) and frame (long-limbed / compact). Each arrow kind reads TWO attributes a side, and
  each attribute leads at most 3 kinds: standing = explosiveness + strength vs the same (the sprawl); pass = strength +
  composure vs flexibility + frame; sweep = explosiveness + flexibility vs strength + weight; escape = flexibility + composure
  vs strength + weight; back take = explosiveness + composure vs composure + frame; chokes = composure + frame (long arms) vs
  composure + strength; arm locks = strength + frame vs flexibility + composure; leg locks = flexibility + explosiveness vs
  the answer's mastery (knowledge) + composure. Aggression is read by the chooser and the grip beat (D). Cap +-0.25 on the
  logit per arrow: a body edge is never a belt.
- A wrestling or judo background is starting MASTERY of the standing lanes (double leg, single leg, snap down at 35-50), not
  body - which is why a wrestler white belt is dangerous on the feet and lost on the ground, as in life.
- Two technique lines drilled like moves at HALF pace: HAND FIGHTING (read in the grip beat, back defence, choke defence) and
  FRAMES (pass defence, escapes from pins). Bar: a drill week on a line never beats a drill week on the best single lane by
  more than 2 points.
- Bars: any one attribute 30 -> 70 moves the win <= 8 points; the best vs worst body draw <= 20 points at equal mat time;
  every attribute named in a result line at least once in 20 matches.

## C. The games (archetypes)
- Every athlete has THREE parts, not one label: a STANDING plan (shoot / pull / front headlock / leg entry), a TOP game
  (pressure pass / speed pass / leg attack / back attack) and a BOTTOM game (closed guard / open guard / half guard / leg
  entanglement / scramble up). The six named games are common bundles: Wrestler (shoot, pressure, scramble up), Guard player
  (pull, speed pass, open guard), Pressure passer (shoot or pull, pressure, half guard), Half-guard player (pull, pressure,
  half guard), Leg locker (leg entry, leg attack, leg entanglement), Back-taker (front headlock, back attack, scramble up);
  the generator mixes parts too (a Wrestler with a leg-lock bottom game). Every match forces both a top and a bottom game.
- Below brown the Leg locker works with straight ankle locks, kneebars from the legs and leg-entanglement sweeps (2 points)
  and back exposures - heel hooks only at brown/black [R IBJJF] - so the game is real at every belt, just stronger at brown+.
- Matchups come out of the reads and lanes: a pressure top game beats an open bottom game; half guard beats pressure; a
  shooter is punished by a guillotine-ready guard and a front-headlock player; leg entanglement answers a pass.
- Bars per belt band (white-blue, purple, brown-black), the 6x6 matrix from the harness (>= 2,000 seeds a cell): each game's
  mean 0.45-0.55, its worst matchup 8-15 points off even; a classifier reading only the result lines names the opponent's
  standing plan and top game right >= 80%.

## D. The standing exchange and grips
- A match opens with a GRIP beat (and a stand-up restarts one): hand fighting + explosiveness + aggression vs the same. The
  winner takes the initiative and a grip edge of +0.15 on the logit for ONE attempt (it decays to 0 after the first
  attempt; a restart re-rolls at half weight).
- From the grip: SHOOT (double / single / snap down; answered by sprawl, guillotine, front headlock), PULL GUARD (needs the
  grip: a pull without it can be punished - the opponent gets a free takedown roll, the source of ~27% of takedown points at
  Worlds/Pans [R]), or FRONT HEADLOCK / snap down to the turtle.
- Double pull: both sit; a 20-second count runs (one beat) and both are penalised if neither comes up on top [R IBJJF].
- Bars: the grip winner scores first 55-62%; guard pulls 35-60% of openings; 20-30% of takedowns come off punished pulls;
  completed takedowns per athlete per 10 min in line with ADCC 2019 [R, Lamas 2023].

## E. Guard vs pass, scrambles
- ACTION DENSITY: most beats are holds, as in the data (ADCC 2019: ~3.5 attempts per athlete per match [R]). An athlete acts
  only when its best arrow's expected value clears its HOLD bar (set by aggression and the score); the rest of the beats are
  grip fighting, framing and pressure.
- The pass as a contest: a pass that fails into a reset leaves PRESSURE (+0.35 on the logit to the next pass, one stack);
  the bottom player's landed sweep or escape clears it; a beat the bottom player holds with the initiative is a RETENTION roll
  (frames + flexibility vs the passer's pass mastery + strength) that clears it on a win. A missed sweep keeps it.
- A miss that slides to the scramble node is a scramble: explosiveness + composure decide who comes up on top.
- A leg-entanglement bottom game may answer a pass by entering the legs (a pass attempt can land in ashi garami).
- Bars [R ADCC 2019]: completed passes 0.17-0.25 per athlete per 10 min; attempts 2.5-4.5 per athlete per 10 min; a
  completed pass takes 1.8-3 attempts; scrambles go to the more explosive side 58-65%.

## F. Submissions and defence
- The base rates are already attempt-to-tap [R]; there is no extra finish gate. An escape is a MISS of a submission arrow
  that lands somewhere: each submission arrow's miss goes to its real escape position (triangle -> the stacked passer on top,
  heel hook -> the defender comes up on top or into 50-50, armbar -> the guard), and a close one (the attacker's odds
  were >= 0.30) is a near submission: an advantage [R IBJJF].
- Leg-lock defence is knowledge: the answer moves the defender owns (knee line, heel hide), plus composure.
- LATER: injuries from a badly defended heel hook.
- Bars: even fields: black 40-55% by submission [R 45%], brown 45-60, white 35-55; submission attempts ~1.0 per athlete per
  10 min [R ADCC 2019]; a back take ends in that athlete's finish 45-61% [R]; RNC and heel hook the top two finishes at
  brown/black, 17-25% each [R]; advantages decide 2-8% [R no-gi 2.4%].

## G. Fatigue and pace
- A tank per side, carried across the open's matches: recovery by the minutes of rest between matches. Every attempt costs
  gas by its kind x (1.5 - cardio/100), a miss more; the bottom player under a pin drains each beat; a hold breathes.
- Tired effects fall where they do in life: below 0.3 a tank, hand fighting and frames read 10 points lower, the athlete gives
  up a pin more readily and takes fewer marginal shots; no corner call reaches a gassed athlete.
- Bars: a 30 vs 70 cardio gap is worth 3-8 points in a single 10-minute match and more by the open's final (small, as the
  data says VO2max barely separates levels [R], but measurable); a heavy pin game drains its opponent faster than a guard game.

## H. The referee
- Bell order [R IBJJF]: points, advantages, fewer penalties, then the referee's decision.
- Stalling [R IBJJF 2021]: a hold with no attempt to improve is a stall - including holding side control, knee on belly or
  north-south without trying to advance; exempt only: holding mount or the back properly, and defending under mount, back,
  side control or north-south. Every 2nd stall beat is a penalty; ladder 1st marked, 2nd an advantage to the other side,
  3rd two points; both on 3 penalties = restart standing. Double pull: part D.
- Decision weights from the data (the side with more takedown attempts won 85% of real decisions, more submission
  attempts 58% [R BJJ Heroes]): takedown attempts 2 (even on a miss), beats on top while improving 1, near submissions 3,
  submission attempts 1.5, other attempts 1; within 5% of even (|share - 0.5| < 0.05) the call is drawn from the shares.
- Bars on EVEN matches (pre-match chance 40-60%): decisions 2-10% [R 7%], advantages decide 3-8%, penalties decide <= 3%,
  no penalty for a properly held mount or back.

## I. The coach's part
- Scouting is real only for opponents known in advance: round 1 of an open (the draw is out on the Monday), a rival, a
  superfight. Their card shows the standing plan, top and bottom game as TELLS WITH CONFIDENCE ("probably shoots first",
  60% after one film, 90% after three). Between rounds: a short card (belt, name, one tell), no drilling.
- The COUNTER week: drill the answers of the known opponent's lane (+5 for that bout) instead of Ana's own game - it costs
  that week's growth (bar: the counter's gain 4-6 points, less than the lost growth's worth over 4 weeks).
- POSTURE for the bout, with prices: Hunt (aggression +25: acts more, never sits on a lead; a miss hands over the
  initiative and burns gas), Steady, Hold (-20: holds a lead twice as early; the stall count climbs).
- Live: 3 calls on heavy settles. After: the result card names the deciding duels in plain words, one line a lever.
- Bars: over the 6 games x 3 postures no posture is best against more than 3 games; no posture beats the best alternative
  by more than 5 points over all games.
