# BJJ fight design v4 - blind critic panel, round 3 (S397)

Two NEW fresh blind critics scored ops/research/BJJ_DESIGN_V4_S397.md part by part (8 = ship as designed):

| part | critic 3 (black belt coach + sports-game consultant) | critic 4 (sports-sim systems designer, trains no-gi) |
|---|---|---|
| A belt meaning | 7 | 6 |
| B grappler | 5 | 7 |
| C games | 6 | 5 |
| D standing + grips | 5 | 7 |
| E guard vs pass | 6 | 6 |
| F submissions | 7 | 7 |
| G fatigue | 5 | 5 |
| H referee | 7 | 5 |
| I coach | 7 | 6 |

The two disagree on B, D and H (the first contradictions, round 3): the shared cause is the beat budget (one acting
side a 33-s beat, ~9 beats in 5 min) - stalling, advantages and density all hang on it.

## What would make the closest parts an 8
A. State the split: INSIDE a belt the lever is mat time alone; ACROSS belts it is mat time + the move list (a white owns
8-12 moves, a blue 25-36 - say it, it is a belt bonus). Fit MAT_W on the inside-a-belt cells only and read the
across-belt table as a result. State the inside-belt spread as a share of the belt step (~0.5-0.6), widest at white;
sandbaggers as a skewed tail, not +-0.3. Fit per belt band (a 10-min black match has twice the rolls of a 5-min white).
E (shared). Density per belt: whites act more and miss more (white/blue gi: ~1.24 sub attempts a match, scrappier,
more scrambles); the hold bar scales with mat time; scrambles read wrestling mastery too. Split a hold into WORKING
(framing, gripping: never a stall) and IDLE.
F. A near submission judged on how close the roll came (or relative to the arrow's own base rate, e.g. odds >= 1.5x base),
capped per match; near-POSITION advantages as IBJJF gives most of them (a missed sweep / pass / takedown that slid past
halfway); each submission's escape position in bjj_tree.json; a missed RNC usually keeps the back (re-attack chain, Lamas
45% next step); white sub bar toward the regional 48-63%; check after E's density is set.
H. A stall is an IDLE hold only (declined a positive-value arrow, or the same spot 2 beats running); fit the per-penalty
count to "penalties decide <= 3%"; advantages from near sweeps / passes / takedowns, not only near subs; the 4th
penalty = DQ; the grip-less pull penalty (gi idea - check it for no-gi); first up after a double pull gets an advantage.
I. Define the 3 live calls (when offered, what each changes, what it costs); posture moves WHAT is picked (Hunt raises
submission and back-take picks; Hold raises frames and retention), not only how often; the counter week's +5 has a unit
and a cap; scouting the next opponent's earlier round on the day gives one tell at 60%; write 5 example result lines.
B. One checkable table: each kind with its two attributes a side and the sign of frame and weight; "leads" = weight >= 0.5;
each attribute leads <= 3 kinds (composure and strength break it now); no attribute worth more than 1.5x another per point;
armbar defence = hand fighting / posture, not flexibility; grip endurance folded into hand fighting; IBJJF art. 5.5 puts
wrestlers at blue (a wrestler white belt is a sandbagger). The code still disagrees with the page (strength in pass attack,
BELT_COMPOSURE still in code).
C. Leg locker below brown: encode the legal-technique table by belt from the rulebook PDF (kneebars and toe holds may be
brown/black only too); let it sit at 0.40-0.47 below brown (an investment that pays later); write the intended 6x6
direction; run the matrix on PARTS (80 builds, none above 0.58); classifier bar per open, per part.
D. No-gi: a pull needs no grip (the punished-pull 27% and the pull shares are gi numbers - mark as a gi stand-in or use no-gi
figures); odds of a punished pull by grip state as a number; the grip beat counts inside the beat budget; check +0.15 can
reach "first scorer 55-62%".
G. Gas cost x mat time and composure (a white burns 1.5-2x a black: over-gripping, panic), an adrenaline dump early for low
composure; a smooth tired curve, not a 0.3 cliff; pin drain and rest recovery as numbers; bar over the open day (match 1
vs the final); a gassed athlete takes one call at half effect. As written the cardio gap is ~1 point (unreachable bar).
Ready to build (critics): F and H with their fixes (critic 3); none yet, B, D, F buildable as tuning bars (critic 4);
A first in both.
