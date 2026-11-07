# BJJ fight design v3 - blind critic panel, round 2 (S397)

Two fresh blind critics scored ops/research/BJJ_DESIGN_V3_S397.md part by part (8 = ship as designed):

| part | critic 1 (black belt + match-engine designer) | critic 2 (sim-engine veteran, purple belt) |
|---|---|---|
| A belt meaning | 6 | 6 |
| B grappler | 6 | 6 |
| C games | 6 | 6 |
| D standing + grips | 5 | 5 |
| E guard vs pass | 7 | 6 |
| F submissions | 6 | 5 |
| G fatigue | 6 | 6 |
| H referee | 5 | 7 |
| I coach | 6 | 6 |

## Faults and "what makes it an 8"
A. IBJJF divisions never mix belts: the cross-belt bars tune a match the player rarely sees; what decides brackets is the
spread INSIDE a belt (fresh vs 4-stripe "sandbagger"). Give every athlete a hidden skill rating, a belt = a noisy band on
it (promotions take 1.5-4 years); bar in-division gaps against the rating table (0 vs 4 stripes ~ a 100-200 rating gap =
66-76%). Read mat time for defence ONCE (odds or finish gate, not both). "Defence counts more" pushes mismatch submissions
DOWN while the real favourite submits MORE (53% at a 200 gap, 76% at 500+): the senior's mat time must raise its own sub
rate; a bar "sub share of mismatches 60-75%". The belt is counted in three places (mastery bands, mat time, belt composure):
keep two. Fit MAT_ATT / MAT_DEF per pair in the harness before building on top.
B. Explosiveness is read on both sides of almost every arrow (it wins everything); aggression is read by no arrow; height /
limb length missing (triangles, retention, back control); a wrestling background should be starting mastery of the
standing lanes, not body. Each attribute leads at most 3 kinds; any one attribute 30 -> 70 moves the win <= ~8 points;
every attribute named in a result line. Hand fighting and frames read on 40+ arrows for one drill = always the best drill:
give each line a cost curve (half pace) or a cap on kinds; bar "a week on a line never beats a week on the best lane".
C. One label per athlete is wrong: real players have a standing plan + a top game + a bottom game, and every match forces
both. Leg locker has no weapons below brown (heel hooks illegal): give it straight ankle locks, entries, sweeps and back
exposures off the legs at lower belts. Back-taker overlaps Wrestler. Balance bars per belt band; the 6x6 matrix from the
harness, >= 2,000 seeds a cell; replace the blind reader with a classifier on the result lines (80% right).
D. "A pull always lands" is wrong: a pull needs a grip, a failed pull is punished (27% of takedown points at Worlds/Pans
came from punished pulls); the double pull runs a 20-s count then penalises both. One grip beat deciding initiative + 0.3
hands the match to the grip winner (first scorer wins 80-87%): lower the bar to 55-62%, decay the grip edge after the
first attempt, count restarts so the grip is not re-rolled for free. Snap down -> front headlock / turtle on the graph.
E. Action density: one arrow per 33-s beat gives ~18 attempts in 10 min; ADCC 2019 measured ~3.5 attempts per athlete a
match, 0.43 pass attempts: most beats should be holds, grip fighting, retention. Define the retention beat: a bottom
player's missed sweep keeps the pressure, a landed sweep or escape clears it, a bottom hold with the initiative is a
retention roll (frames vs pass mastery). One pressure stack of +0.35 (two never come into play). Fixed scramble node,
measured split. Let a Leg locker answer a pass with a leg entanglement. Bar: completed passes 0.17-0.25 per athlete per 10 min.
F. An escape costs nothing (it is only an advantage): each submission's escape lands somewhere (triangle -> stacked pass,
heel hook -> on top). The gate double-counts: the real per-move base rates are attempt-to-tap; fit base x (1 - gate) to
the table. Bars: back take -> finish 45-61% (Lamas 2023); sub attempts ~1.0 per athlete per 10 min; advantage-decided
2-8%; the favourite submits / is submitted by gap (nogiratings); RNC and heel hook the top two finishes, 17-25% each.
G. The tank lives in one match: in an open it carries across a 3-5 match day (recovery by minutes of rest). Being pinned
/ carrying weight costs nothing, so holders never tire: drain the bottom player under a pin. Gassed: frames and hand
fighting fall first, top position given up more readily, fewer attempts. The cardio bar likely misses (~0.13 logit late):
set GAS_W from the harness; a small effect is right (VO2max does not separate levels) but must be measurable.
H. The exemption list contradicts the rulebook: holding side control without trying to advance IS stalling; only
defending under mount / back / side / north-south, and holding mount or back properly, are exempt. Decisions: more takedown
attempts won 85% of real referee decisions, more submission attempts 58%: weight takedown attempts first (2 even on a
miss), time on top while improving, near-subs (3), then sub attempts. Double pull rule; both on 3 penalties = restart
standing; "even" = a pre-match chance 40-60%; define the judgement call as a number; bar advantages decide 3-8%.
I. In a single-elimination open only round 1 is known: full scouting makes the counter week always right (no choice).
Counter only for opponents known in advance (round 1, a rival, a superfight); between rounds a short card, no drilling;
the counter week costs that week's progress on Ana's own game (bar: its gain < that lost growth over 4 weeks, 4-6
points); tells with a confidence that grows with films watched ("probably a wrestler"); posture with prices (Hunt: a miss
hands over initiative and burns gas; Hold: the stall count climbs); no posture best against more than 3 of 6 styles.
Building: BjjWalk.gd (447) and BjjTree.gd (451) are near the 500-line cap: grip, pressure and scramble rules need their own
modules (BjjGrip.gd, BjjPass.gd).
Ready to build (critics): none as written; H after its fixes; E closest; A first (everything sits on it).
