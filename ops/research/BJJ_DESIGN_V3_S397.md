# The BJJ fight, deep - design v3 (S397, for a blind critic panel)

FightCamp (Steam, Godot 4) is a boxing + no-gi BJJ gym manager. The player coaches Ana from white belt to black: each week
picks what Ana drills (moves on a game tree of positions: grey -> felt -> owned), enters IBJJF no-gi opens (single
elimination, 5-10 minute matches by belt), and watches each match simulated beat by beat or plays it live with 3 corner calls.
Every opponent is generated on the same maths. Real numbers are marked [R] (sources: ops/research/BJJ_REAL_NUMBERS_S397.md),
our choices [G]. Each PART below is judged and built alone.

THE MATCH TODAY (kept): the match is a walk on a position graph (49 positions, 80 moves, 135 arrows: takedowns, pulls, sweeps,
passes, back takes, escapes, submissions). One beat ~33 s; the side with the initiative takes its plan's next arrow or its
best expected one; a hit moves and scores IBJJF points (takedown 2, sweep 2, knee on belly 2, pass 3, mount 4, back 4 [R]),
keeps the initiative; a miss slides as far as the defender knows the answer, else resets, and the initiative passes. Odds of an
arrow = its even-field base rate [R per kind, ADCC/FloGrappling tables] x the attacker's mastery of the move / the
defender's mastery of its best answer, x chain, mood, the read (the defender has seen the plan before). Within a belt this is
calibrated on 16 bars (sub rates, finish types, first scorer wins 80-87% [R]).

## A. What a belt means
- Mat time: a level per belt - white 0, blue 1.0, purple 1.8, brown 2.4, black 2.9 (+0.4 over a black belt's first 300
  classes) - plus the share of classes towards the next belt, so it grows class by class and a promotion is no jump.
- Every arrow moves on the logit by the mat-time gap, but defence counts more than attack [coach: "higher belts simply do
  not get tapped"]: MAT_ATT x gap when the attacker is the senior, MAT_DEF x gap (bigger) when the defender is.
- Finish gate: a submission that lands is still escaped before the tap: base by tier [G: white/blue 10%, brown/black 35%],
  moved by the defender's mat time over the attacker's. An escaped submission is a near submission: an advantage [R IBJJF].
- Moves stay what was drilled; a belt is not a free boost to them.
- Bars [G from the R rating-gap proxy: a 200 no-gi rating gap wins 76-84%, 400+ 90-93%; per-pair from a black-belt coach]:
  white->blue 80-88%, blue->purple 70-80, purple->brown 65-75, brown->black 60-70; two belts 85-95; three+ 95-99; never
  above 99%; a 4-stripe vs a fresh athlete of one belt 60-70%; the senior's finish share rises with the gap (the real
  favourite submits / is submitted: 53% / 9% at a 200 gap, 76% / 1% at 500+ [R]).

## B. The grappler
- Body and mind, 0-100: strength, cardio, flexibility, explosiveness, composure, aggression. Each arrow reads only what
  matters for its kind, the attacker's against the defender's, as a weighted edge on the logit capped +-0.25 (a body edge is
  never worth a belt): standing shots = explosiveness + strength vs the same (the sprawl); pass = strength + explosiveness +
  composure vs flexibility + explosiveness; sweep = explosiveness + flexibility vs strength + composure + explosiveness;
  escape = explosiveness + hips (flexibility) + composure vs strength + composure; back take = explosiveness + composure vs
  composure + explosiveness; chokes = composure + strength vs composure + explosiveness; arm locks = explosiveness +
  strength vs flexibility + composure; leg locks = explosiveness + flexibility vs composure + explosiveness (leg-lock
  defence is mostly the answer's mastery: knowledge).
- NEW: two technique lines the player drills like moves: HAND FIGHTING (wrist control, 2-on-1, underhooks: read in every
  standing exchange, in back defence and choke defence) and FRAMES (guard retention against passes, escapes from pins).
  Each is a mastery 0-100 read side against side on its arrows (+-0.30 on the logit at a 40-point gap).
- Steering the body and mind: composure grows with matches fought (+0.5 a bout, up to +10) and with the belt (white -6 ..
  black +7, for everyone); strength and cardio come from the Week's sessions (already in the game for Ana); the rest is who
  Ana is (her profile shown: "flexible, calm").
- Bars: at an equal belt the best vs worst body draw moves a match <= 20 points; drilling a line from 30 to 60 moves the
  arrows it reads by 6-10 points.

## C. The games (archetypes)
- Six: Wrestler, Guard player, Pressure passer, Half-guard player, Leg locker, NEW Back-taker/scrambler (front headlock,
  turtle attacks, seatbelt, RNC - the RNC is 21-22% of no-gi black finishes [R]). Each = a body + mind shape with noise (two
  Wrestlers differ), lanes it prefers, a go-to route, and how it fights (a Wrestler shoots first and holds top, a Guard
  player pulls, a Leg locker enters early and goes all in - heel hooks only at brown/black [R IBJJF]).
- A loose matchup wheel from the coach [G]: Pressure passer > Guard player, Leg locker; Half-guard > Pressure passer;
  Wrestler > Half-guard; Guard player > Wrestler (guillotines and triangles off the shot); Back-taker > Wrestler (front
  headlock off the shot); Leg locker > Wrestler at brown/black. It comes OUT of the reads and lanes, not from a table.
- Bars: each style's mean vs the other five 0.45-0.55; its worst matchup 8-15 points off even; a blind reader names the
  opponent's style from the result card's lines 80% of the time.

## D. The standing exchange and grips
- A match opens (and every stand-up restarts) with a GRIP beat: hand fighting + explosiveness side against side decides
  who has the initiative and a grip edge (+0.3 on the logit) on the first shot or pull.
- From the grip: shoot (double / single / snap down, answered by sprawl and guillotine), pull guard (no points, always
  lands [R IBJJF: a pull is not a takedown]), or a front headlock. Guard pulls outnumber takedowns in no-gi IBJJF [R weak].
- Bars: a Wrestler shoots on >= 60% of its openings, a Guard player pulls on >= 50%; pulls 35-60% of openings overall
  (existing bar 11c); the grip winner scores first 60-70%.

## E. Guard vs pass, scrambles
- A pass is a contest over several beats: a pass attempt that fails without being swept (a reset) builds PRESSURE on that
  guard (+0.25 on the logit to the next pass, up to 2 stacks); a sweep, an escape or a retention beat (the bottom player's
  frames won) clears it. Frames read on every pass defence.
- A miss that slides to the scramble position starts a scramble: explosiveness + composure decide who comes up on top.
- Bars: a completed pass takes 1.8-3 attempts on average; pressure passers finish more passes in a row than others.

## F. Submissions and defence
- Built from A and the graph: the finish gate, near subs as advantages, answers as knowledge (a leg lock is stopped by the
  answer moves the defender owns). LATER: injuries from a heel hook defended badly.
- Bars: even fields: black 40-60% by submission [R 45%], brown 45-60, white 30-55; RNC the top single finish at brown/black.

## G. Fatigue and pace
- A tank per side: every attempt costs gas by its kind x (1.5 - cardio/100), a miss more, a hold breathes; the tank gap
  moves every arrow on the logit (equal tanks cancel). Gassed (< 0.3) the athlete takes no corner call (tunnel vision).
- LATER: 15-second beats (the design's own pacing bars would all need re-calibrating; measured separately first).
- Bars: a 30 vs 70 cardio gap is worth >= 6 points in a 10-minute match and <= 3 in a 5-minute one.

## H. The referee
- Bell order [R IBJJF]: points, advantages, fewer penalties, then the referee's decision on who was more offensive.
- Stalling: a hold off a pin (no attempt for a beat) is a stall; every 2nd one a penalty; riding mount, back, side control,
  knee on belly or north-south, or defending under one, is never stalling [R IBJJF]. Ladder: 1st marked, 2nd an advantage to
  the other side, 3rd two points [R IBJJF 2021].
- Decision: an offence tally - attempts weighted (submission 3, pass / sweep / takedown / back 2, entry 1; a miss half) and
  every beat on top; within 5% of even it is a weighted judgement call, never a flat coin.
- Bars: referee decisions 2-10% of even matches [R 7% black]; penalties decide <= 3%; no penalty ever for a pin.

## I. The coach's part
- Before the match: a SCOUTING CARD - the style, two tells from the opponent's body and lanes ("shoots first", "weak off
  the back"), its record; and a COUNTER: pick one lane Ana's drilling focused on this week (the answers of that lane).
- The POSTURE call for the bout: Hunt (aggression +25: takes marginal shots, never sits on a lead) / Steady / Hold (-20:
  starts holding a lead twice as early). The best posture differs by opponent; none is best against all.
- Live: 3 calls on heavy settles (exists). After: the result card names the deciding duels in plain words, one line a lever
  ("the pass went through: more mat time", "the armbar was escaped before the tap", "penalised for stalling at 4:10").
- Bars: against each of the six styles a different posture or counter is best; no posture beats the best alternative by
  more than 5 points over all styles; a counter-drill week moves that bout 8+ points.
