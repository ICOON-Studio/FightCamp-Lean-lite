# The BJJ fight, deep - design v6, parts A, F, H (S397, for a blind critic panel)

FightCamp (Steam, Godot 4) is a boxing + no-gi BJJ gym manager. The player coaches Ana, a woman competing in women's
divisions, from white belt to black: each week picks what Ana drills (moves on a game tree of positions: grey -> felt ->
owned at mastery 30), enters no-gi opens (IBJJF rules; single elimination, 3-5 matches a day), and watches each match
simulated beat by beat or plays it live. Every opponent is generated on the same maths. [R] = a real number (sources:
ops/research/BJJ_REAL_NUMBERS_S397.md), [G] = our choice, fitted in the headless harness. This page covers three parts.

THE ENGINE (kept): a walk on a position graph (49 positions, 80 moves, 135 arrows; 32 are submissions). A beat is ~33 s:
9 beats in a 5-minute white match, 11 blue, 13 purple, 15 brown, 18 black [R IBJJF match lengths]. The side with the
initiative ACTS (one arrow) or HOLDS (no roll); after a hold, a miss or a reset the initiative passes to the other side; a
hit keeps it. Odds = the arrow's even-field base rate (attempt-to-success: a submission's base already includes the
defence) x the attacker's mastery of the move / the defender's mastery of its best answer x chain x mood x the read, then
levers add on the logit (all levers 0 = today's calibrated odds).

## A. What a belt means
- MAT TIME is one hidden skill level. A belt starts at white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9. Inside a belt an
  athlete sits at start + t x SPREAD + n, where t is the time at the belt (0 fresh .. 1 four-stripe), SPREAD = 0.9 of the
  step to the next belt (white 0.9, blue 0.72, purple 0.54, brown 0.45; black 0.4 over its first 300 classes), and n is a
  personal offset, uniform +-0.15 [G]. So the top of a belt overlaps the bottom of the next: a four-stripe white and a fresh
  blue are nearly the same person a week apart. Sandbaggers: 10% of a white or blue division draws t from 1.0-1.6 [G; R:
  promotions take 1.5-4 years; IBJJF art. 5.5 enters experienced wrestlers at blue].
- Read ONCE: every arrow adds MAT_W[belt] x (attacker level - defender level) on the logit, attack and defence alike, so the
  senior both scores and finishes more [R: favourites submit 53% / are submitted 9% at a 200 rating gap]. MAT_W has one value
  per belt (5), because a belt's match length differs (9 beats at white, 18 at black).
- FITTING ORDER: (1) MAT_W per belt on the INSIDE-belt bars; (2) SPREAD is the fallback knob if the across-belt checks fail
  (never the move-list bands, which other parts read); (3) then the submission and action bars of the other parts are re-run.
  INSIDE bars: a four-stripe vs a fresh athlete of the same belt 66-76% [R proxy: a 100-200 rating gap]; a division's top
  quarter by mat time wins 65-72% against the rest [R: rated favourites 65.7%]. ACROSS checks, average athlete vs average
  athlete: white->blue 80-88, blue->purple 70-80, purple->brown 65-75, brown->black 60-70, two belts 85-95, three+ 95-99, no
  cell above 99%; and four-stripe white vs fresh blue 45-60%.
- Where belts meet: IBJJF never mixes belts, but small local women's divisions do - a division with fewer than 4 entrants
  merges with the next belt up (blue+purple, brown+black) [G; common at local opens]. So the across-belt table is played.
- Player sees: the opponent's belt, stripes and a word for the time at the belt ("fresh blue", "four-stripe blue");
  "sandbagger?" when the opponent has won 80%+ of 10+ matches at the belt; the result line names mat time when it decided.
- Lives in: BjjBody.mat_time (exists), BjjOpp (t, n, the tail), the harness.

## F. Submissions and defence
- No extra finish gate: the base rates already include the defence [R attempt-to-tap tables].
- THE MISS: a missed submission slides to its escape position with chance S, else it is a reset - the attacker keeps the
  position and the initiative passes to the defender (the engine's one turn rule). S = clamp(0.50 + (the defender's answer
  mastery - the attacker's mastery of the move) / 80, 0.30, 0.70) when the answer is owned (30+), 0.15 when it is only felt
  (15-29), 0 when unknown [G]. Never certain either way.
- Escape positions per arrow (data, all 32 today: e.g. outside heel hook -> 50-50, darce and ankle lock -> a scramble,
  mounted armbar -> back to closed guard, RNC -> the defender turns into half guard on top). The three most common get two
  weighted landings [G]: triangle - posture out to the top of closed guard 60%, stacked into side control 40%; guard armbar -
  the arm pulled out to open guard 70%, stacked pass 30%; RNC - turned to half guard 60%, a scramble 40%.
- NEAR = an advantage [R IBJJF]: a missed submission, sweep, pass or takedown whose roll missed by 0.10 or less (r < odds +
  0.10) scores an advantage; at most 2 a match an athlete from near misses.
- Legality by belt from the IBJJF table (per move in the data): white to purple: straight ankle lock only; brown and black:
  kneebar, toe hold, heel hooks and reaping [R IBJJF 2021]. Leg-lock defence is knowledge: the answer moves owned.
- Bars (even fields: same belt, mat time within 0.2), WOMEN's divisions: black 50-58% by submission [R no-gi Worlds women
  54-56%], brown 45-60%, purple 45-60%, white and blue 45-60% [R anchor: even rated matches finish ~55%]; RNC and heel hook
  the top two at brown/black, 17-25% each [R]; a back take ends in that athlete's finish 45-61% [R]; after a missed choke
  from the back at black the back is kept 55-75% [G from the same]; advantages decide 2-8% [R no-gi 2.4%].
- Lives in: BjjWalk (the slide S, near, the cap), assets/data/bjj_tree.json (two landings on 3 arrows).

## H. The referee
- Bell order [R IBJJF 2021]: points, advantages, fewer penalties, then the referee's decision.
- STALLING: an idle hold - a side's second hold in a row on the same position with no attempt of its own in between - is a
  stall; this applies to BOTH sides of a closed guard (the passive top as much as the passive bottom). Exempt only: holding
  mount or the back, and defending under mount, back, side control or north-south [R IBJJF 2021]; an idle hold of side
  control, knee on belly or north-south IS a stall. Every 2nd stall is a penalty. Ladder [R]: 1st marked, 2nd an advantage to
  the opponent, 3rd two points, 4th disqualification; both on 3 penalties: a restart standing.
- DOUBLE PULL, on the standing position: when one side pulls guard, the other may answer on the very next beat with its own
  sit (a base arrow from the top of the pulled guard to a new BOTH SEATED position). Both seated runs the 20-s count for one
  beat: each side may come up on top (explosiveness + hand fighting, an even contest); the first to land it scores an
  advantage [R IBJJF]; if neither does, both take a penalty and the match restarts standing.
- DECISION weights from the data (the side with more takedown attempts won 85% of real decisions, more submission attempts
  58% [R BJJ Heroes]): takedown attempts 2 (hit or miss), beats on top after acting 1, near misses 3, submission attempts 1.5,
  other attempts 1; the larger share wins; inside 0.45-0.55 the call is drawn from the shares.
- Bars on EVEN matches (pre-match win chance 40-60%): decided by the referee 2-10% [R 7% black]; by advantages 3-8%; by
  penalties <= 3%; among referee decisions, the side with more takedown attempts wins 75-90% [R 85%]; at white at least one
  stall penalty in 5-20% of matches [G]; never a penalty for holding mount or the back.
- Lives in: BjjRef.gd (exists; idle stalls both sides, the 4th penalty, the weights); bjj_tree.json (+1 position, +3 base
  arrows for the double pull); BjjWalk calls it.

## Structural note (not for scoring)
The engine has one acting side per 33-s beat (9 beats at white). Critics found that white-belt action density, holds and
stalling cannot all fit that budget; the fix is a beat-length change measured in the harness first (part E, later).
