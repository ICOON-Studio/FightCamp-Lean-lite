# BJJ fight model - critic round 1 (S397), the reviews in short (for the designer seats)

Design reviewed: ops/research/BJJ_REALISM_S397.md sections 1-3 (v1). Scores: BJJ black-belt coach 6/10, game systems
designer 6/10, sports-sim veteran 5/10. v2 (section 5 of the same doc) answered most points; what is below is what they said.

## Coach (6/10)
- v1 penalised riding mount/back as stalling (every hold = a penalty); even black fields finished 77% (real no-gi black 45%).
- Strength over-weighted (passes, chokes, escapes are position and hand fighting); flexibility wrong on choke and heel-hook
  defence; leg-lock defence is knowledge (the answer's mastery), not composure.
- MISSING: hand fighting (wrist control, 2-on-1, underhooks: decides no-gi takedowns, back defence, choke defence) as a
  trainable technique line; frames (guard retention, escapes) as technique; weight within the division; hips in escapes.
- Body cap too wide: a body edge must never be worth a belt (except the D1-wrestler white belt).
- Belts: defence above all ("higher belts simply do not get tapped"); per-pair bands: white->blue 80-88%, blue->purple 70-80,
  purple->brown 65-75, brown->black 60-70; two belts 85-95; three+ 95-99 (white vs black ~99); 4-stripe vs fresh 62-70.
- Games: a matchup wheel (8-15 points each): pressure passer > guard player and leg locker; half-guard > pressure passer;
  wrestler > half-guard; leg locker > wrestler (brown/black only); guard player > wrestler (guillotines, triangles off the
  shot). MISSING game: the back-taker / scrambler (RNC ~21% of no-gi black finishes). IBJJF guard pulls blunt the Wrestler.
- Stalling: never on a pin; 2 hold beats in neutral/guard; both sides when both do nothing; bottom-guard stalling is common.
- Ideas: stall fix; season defence harder; READS fix; compressed bands; back-taker + wheel (later); hand fighting + weight (later).

## Systems designer (6/10)
- As a system the player plays it is thin: the only real choice is which moves to drill; body/mind are dice Ana cannot steer.
- Explosiveness dominates (read in 9 of 10 rows); composure is a hidden defence stat that the field gains by belt and Ana
  did not; aggression dead for Ana; cardio invisible (equal tanks cancel, no note says "tired").
- Seasoning (v1) made drilling old moves pointless and jumped at promotion.
- A style is a label: the player feels it only with (1) a scouting card (style, two tells, ranges that narrow), (2) a result
  line naming the duel ("his explosiveness against her sprawl"), (3) a counter the player can pick (drill the answers of that
  lane, an aggression setting).
- Referee order readable; stall trap is silent unless the player chose to hold.
- Ideas: aggression as the player's call per bout (Hunt / Steady / Hold the lead), best setting differs by style, none
  dominant (+-5 points); scouting card + duel line + counter-drill (drilling the counter moves that bout 8+ points); train
  body and mind in the Week; balance shapes so every style cell is 0.40-0.60; seasoning that builds class by class.

## Sports-sim veteran (5/10)
- Mastery factor moves odds ~0.6% a point: seasoning cannot carry a belt; the top saturates while one gap is too weak.
- Few beats (9 in 5 min, 18 in 10): gas and stalling tallies are coarse; a lucky tap sets an upset floor (~8-12%).
- Multiplicative stacking is uneven across base rates: use a logit sum for levers; EPS 17% is per-beat noise, hurts the
  favourite; add a per-match FORM term for both sides (mood is Ana-only, asymmetric); EPS by IQ.
- Tune order: structure (logit, a separate mat-time term, a finish gate: the defender's escape before the tap) -> 1-gap
  cells -> monotone 2-4 gaps <= 99% -> favourite finish share by gap -> within-belt -> styles -> stalling/referee -> bars 1-16.
- Probe: per-beat odds by gap; favourite / underdog sub shares by gap (real 53/9 at a 200 rating gap, 76/1 at 500+);
  underdog wins by method; error bands, n >= 2,000 for top cells. Bug: penalty results were binned as advantages.
- Referee tally: a miss counted like a hit; top time only on attempt beats; initiative starts on a coin.
- Live engine should share the walk's model (skill gap/200 additive is uneven; skill_of is a flat mean).
- Ideas: logit + mat time; finish gate; form + EPS by IQ; stall every 2 holds with pin exemption; 15-s beats (later);
  align the live engine (later).
