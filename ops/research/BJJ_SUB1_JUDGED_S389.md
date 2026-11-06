# BJJ one-minute submission, judged (S389, 2026-11-06)

Operator: "have a 1 minute submission fight judged but reviewers and critics and playtesters pls".
All judges are blind Claude sub-agents reading eyes contact sheets of the film, not people. The playtesters are simulated personas,
not playtest data. Real strangers come after the plain screens (bible section 12).

## Why the film is the last minute of a longer match
8 full white-belt matches, the film tool's own calls: 0 finished inside 66 s, 4 ended by submission (1:40, 1:57, 1:59, 4:45), 3 on points or a draw,
1 run did not finish. Ana made 0 submission attempts in those 8; Kim made 18. The film is seed 6, the last 62 s up to an omoplata at 1:57.
Film: E:/FightCamp/tmp/s389/sub1/bjj_submission_1min.mp4. Sheets: E:/FightCamp/tmp/s389/judge1.

## BEFORE (no clash panels)
| Judge | Score | Could tell why it was won? |
| --- | --- | --- |
| Games reviewer | 2/10 as trailer footage | Only from the text; "the bodies never show why" |
| BJJ black belt + animator | Animation 3/10, technique 2/10 | Finish not believable as an omoplata |
| Sam (management player, persona) | Fun 4, clarity 3 | No |
| Priya (BJJ hobbyist, persona) | Fun 3, clarity 3 | No |
| Tom (boxing and MMA games, persona) | Fun 5, clarity 4 | No |

Bar "nothing visibly broken to an ordinary player": NO. The operator's own view is that the clips look fine; his eye outranks these judges.

Defects named, worst first: bodies merged in the final held pose (58.5-61.9); torso into pelvis (20-23); legs through torso (15-18); no arm isolation
and no tap at the finish; standing to guard in 0.2-0.4 s with no takedown (12.2-12.6); pops (27.6, 36.6, 47.8); idle standing while the panel says "on top" (10-12).
Clarity defects: "Omoplata - missed" stayed on the panel as the win landed; "Other" as a position; clock read 3:02 left beside a win stamped 1:57;
orbiting camera; a top-position omoplata that is really a bottom attack; side panel jumped at the verdict.
What all three personas most wanted: to see the submission tightening, then an unmistakable tap.

## Causes found in code
- Only Ana was held to her syllabus; Kim could try any submission in the graph. Fixed: both fight with what they drilled.
- Finishes showed GrappleMap step names ("Bottom Leg Freed", "To Side"). Fixed: named by the submission.
- BjjMatch.offers only lets the woman on top finish, so guard submissions (omoplata, triangle, armbar from guard) come out backwards. Open.

## AFTER (clash panels, both women on drilled moves, fixed camera, plain clock and positions)
Film: E:/FightCamp/tmp/s389/sub2/bjj_submission_1min_after.mp4, seed 28, bracket opponent, armbar owned, last 62 s to a monoplata at 3:07.
Same blind judges and questions. Not the same match, so this is a read of direction, not a measurement.
| Judge | Before | After | Can tell why? |
| --- | --- | --- | --- |
| Games reviewer | 2 | 3 | From the cards, not the bodies |
| Critic, animation | 3 | 4 | |
| Critic, technique | 2 | 3 | Finish still not believable |
| Sam, fun / clarity | 4 / 3 | 6 / 5 | Partly: "what raises that chance?", keeps playing for the numbers |
| Priya, fun / clarity | 3 / 3 | 3 / 3 | No: bodies contradict the card |
| Tom, fun / clarity | 5 / 4 | 4 / 5 | From the text; "needs a struggle" |

Bar "nothing visibly broken": still NO. The clash fixed the words, not the bodies.
All judges, unprompted: the finish must happen on the bodies. A readable lock, a visible tap, a release; the word TAP over a limp pose does not land.
Persona note: they read the chance as 9%; the frame says 15%. The sheets blur the small text.
Other notes: "STOPPED" while Ana ends underneath (0:36): a miss plays a feint that can look like a loss. Inverted Beth with no support (0:51). Top-down camera at times.

## Open after S389
1. The finish on the bodies: lock, tap, release, per submission family. This is the top item from every judge.
2. Who finishes: BjjMatch.offers only lets the woman on top finish, so guard submissions come out backwards.
3. Gas: both women at 0 by 3:00 of 5:00, so "is tiring" becomes the reason for every move. Misses cost too much; tune against real rolls.
4. Tree-only moves (f["tree"]) do not reach the match; syllabus moves do.
5. Why a move is on offer: Sam's question, "what raises that chance?", wants a line pointing back to training.
