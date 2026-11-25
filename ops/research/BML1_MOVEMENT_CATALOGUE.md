# BML1 - the movement the owner wants matched: the Boxing Movement Lab shorts, in our own words (S559)

Owner S559: "https://www.youtube.com/shorts/wrZGz52Icss this looks so good, can you match this kind of movement", then
"check all these animations i want you to match those : https://www.youtube.com/@BoxingMovementLab", then "can we make
perfect animations clips since the game knows what to play and how to blend it if we make it for all possible combinations".
Watched (S559, Claude): all 21 shorts on the channel's Shorts page, 12 frames each across the whole clip. They are
illustrated (comic / anime style) drill videos, most look AI-generated. Nothing of theirs is copied: no frames, art or text
in the repo. What we take is the TECHNIQUE (real boxing, nobody's property) and what makes it read well.

## The 21 shorts (one line each, our words)
| # | Short (id) | The movement |
|---|---|---|
| 1 | Footwork star drill (wrZGz52Icss) | From stance, a step out in 8 directions (in, 2 forward diagonals, 2 sides, 2 back diagonals, out), back to the centre each time; the foot nearest the direction moves first; knees bent deep on the sides; feet never cross |
| 2 | Taller opponent (lwzaPuQrhIY) | The short man closes with head movement AND a step together, under the long jab; inside, short punches while the tall man cannot extend |
| 3 | Advanced footwork 1/3 (Zjh45YJetsk) | Four levels: a light bounce on the balls of the feet; small shuffles in and out; step-drag (front foot leads, back follows); lateral shuffle and a pivot |
| 4 | Defend the jab-cross 3 ways (Zv1AKaZRVzE) | Catch the jab + slip the cross outside + counter; step back out of range + step in with your own 1-2; roll under the cross + come up punching |
| 5 | Pirog-style head movement (1tNGdPhsGOU) | Sink into a deep low stance and fold forward at hips and knees so the head drops low and off the centre line, gloves up; come back up (3 counted steps) |
| 6 | Cuban partner drill (EvDYk7DsmG4) | A called, unbroken chain against a partner: step back, uppercut, jab, cross, slip and jab, 3 uppercuts, slip and pivot, cross |
| 7 | Create angles (SlE88E5aEy0) | As he comes forward, step off his line (lead foot out to the side, rear follows) and counter with a hook or cross while he faces empty space |
| 8 | Side-step counter drill (mGMJoM1m1R4) | Solo over a floor line: a side step across the line, then step and pivot and throw, balanced |
| 9 | Partner boxing drill (qvv5xgDfQcU) | One throws jab-cross, the other catches/parries and returns; roles swap in rhythm |
| 10 | In and out 1-2 (d_88_IosgJs) | Jab as the rear foot drives the body in, cross, push off the front foot straight back out, reset - the body travels with the punches |
| 11 | Make them miss, make them pay (UbKWkGUtrj0) | Lean or slip just out of reach so the punch misses; counter while the attacker is still extended |
| 12 | Beginner footwork (PaD6AyS0EHs) | Shuffle keeping the stance width; lateral steps (nearest foot first); in and out |
| 13 | Head movement tutorial (O05jYbkzluo) | With a rope line: slip left/right of it; bob under and weave along it; slip + jab; roll under and come up throwing |
| 14 | Peek-a-boo (4Mrng4IuXdo) | Gloves tight on the cheeks, crouched; bob and weave against a partner's punches; slip into a counter; roll under and come up with hooks / uppercuts |
| 15 | Mirror footwork (ecpCxDJBpOU) | Two partners face to face: one leads, the other mirrors each step; lateral circling; pivots together |
| 16 | Partner drills (4kmVV9TobZo) | Jab and parry; catch and return; slip the jab outside and counter; roll under the hook and counter |
| 17 | Angles in a crouch (paxaYowABls) | Crouched high guard; the SHIFT (step through with the rear foot while throwing - the stance switches, a new angle); pivots off the line. (Its real fight footage is not used.) |
| 18 | Shadow levels (l6o3PBZ8yHw) | Duck under; slip and jab; cover and parry; duck and come up with an uppercut or hook |
| 19 | Footwork is 80% (lOxZAzc5Pbc) | Agility disc: step on and off; hop sideways over; pivot around; quick step-ins |
| 20 | Feet and head together (q1eNPHHtWH0) | Walk and slip; jab and slip; walk and roll; slip left-right then roll left-right while moving |
| 21 | Staying elusive (PUXAs45FSxM) | Slip outside the jab; lean back from the cross; slip and counter close |

## What makes them look good (the target, in five lines)
1. NEVER STILL: between actions a light bounce and a weight shift; knees always bent; guard always up.
2. THE BODY TRAVELS: every step pushes off one foot and lands the other; punches carry the body in and out (#10).
3. FEET AND HEAD TOGETHER: a slip or a roll happens while the feet move (#2, #20) - not one after the other.
4. BOTH MEN MOVE: the defender's answer (catch, slip, roll, step off the line) is a motion, not a frozen block.
5. THE CAMERA: in front and to the side, a little above - both legs and both gloves visible (the owner's camera ask).

## The vocabulary, and where our game stands (Ring Switches + MoveTree)
| Family | Moves in the shorts | In our game today | Gap |
|---|---|---|---|
| Footwork | bounce; step in / out with push-off; lateral; diagonals; pivot; shuffle; step-drag; shift | step in / back off switches (pictures barely move: STEPFIX1 running); MoveTree has pivot_out, cut_off, herd | bounce idle; lateral / pivot as a picture; the shift |
| Head movement | slip left / right; roll (bob and weave); duck; lean back (pull) | NONE as a switch (the holds high / low only) | a whole family: a head-movement switch would be a RULE change - measured first |
| Hand defence | parry, catch, cover, high guard | holds high / low = cover (S559 retake: rear glove by the jaw) | parry / catch as the blocked pictures |
| Counters | slip-counter, roll-counter, step-off-the-line counter, in-and-out 1-2 | counters exist in the rules (+1 after a miss / block) | the picture of a counter after a slip |
| Partner rhythm | catch-and-return, mirror | a beat = both men act at once in 3 moments | the defender's reaction run timed to the attacker's contact |

## The owner's question: "perfect clips for all possible combinations"
Yes - but not by rendering every pair. A beat is three moments, both men act at once; two men each with ~25 switch
choices in ~6 orders and 3 ranges make tens of thousands of two-man clips, and every new move multiplies them. The way
that stays perfect AND finite: render each MAN ALONE on his own transparent layer, one clip per (action, outcome, range,
corner) - "jab, landed, at Mid, blue" - and let the page (or the game) put the two layers together at the right distance
and time the defender's reaction to the attacker's contact frame (the contact frame is already in frames.json).
Counted: about 25 actions x 3 outcomes x 3 ranges x 2 corners + holds, steps, slips = a few hundred clips per corner,
each made once and checked once; combinations then cost nothing. Every clip starts and ends in the same guard pose
(the joint), so any clip can follow any other with no pop - the blending the 3D player already does, baked.
Today's pictures render both men in one frame, so this is a change to the picture tools (two layers per frame) and to
the page's player (compose two layers) - the plan for a worker after MASK1, which already renders per-limb layers.

## Next (Claude's plan)
1. STEPFIX1 (running): steps carry the body. 2. The camera (his save) + full re-render. 3. LAYERS1: one man per layer,
the guard joint, compose on the page. 4. FOOTFEEL1: the never-still bounce between beats. 5. HEADMOVE1: a head-movement
family (slip / roll / pull) - a rule first, measured on the balance tool, then its clips.
