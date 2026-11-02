# WRESTLE_S336 - progressing the wrestling (operator S336: "lets also progress the wrestling")

Discipline: MMA / wrestling prototype, outside the boxing demo, like the ground-move browser (Q-S294-58).
Sources the operator sent in S336, read in Chrome on 2026-11-01:

| Source | What it is | What we take |
| --- | --- | --- |
| 223wrestling.com/flowcharts (Fowlerville Wrestling, Michigan) | 7 standing "chain wrestling" charts, data in `/techniques.json` (`flowcharts[]`: `rootNode`, `nodes{id,label,type: root/action/finish/link}`, `edges{from,to}`) | The STRUCTURE: tie-up -> opponent's reaction -> technique -> finish, and links between series. No licence stated: we use the technique names (facts) and write our own chains; no text, slides or videos copied. |
| grappleflows.com/try | A BJJ game-plan builder: cards Setup -> Entry -> Finish, linked by arrows; each card has a type (action ...) and notes; "Suggest moves" | The PLANNING interaction: the plan is cards joined by arrows. UI reference only. |
| sportsreflector.com/sports/wrestling | A phone-camera coaching app; scores form 0-100 | The six numbers a coach reads: takedown success, sprawl, stance balance, hand control, escape/reversal rate, reaction time. |
| wrestleai.app | A training app: goals (position focus, weight class, schedule) -> a personal plan; drills by neutral / top / bottom, folkstyle and freestyle; match log (attempts, finishes, riding time, escapes, near-falls, pins) | The GYM side: a wrestler trains by position (neutral/top/bottom), and her match log is those counts. |

## The 7 charts in short (223 Wrestling; r = start, f = finish, l = link to another chart)
- Underhook: throw-by (go-behind, bodylock, snatch single), upgrade to bodylock (go-behind, throw), front headlock (l), whip-over, snatch single, knee tap.
- Collar tie: duck under (claw, single/double, go-behind), slide by (bodylock, go-behind), snapdown (front headlock l, go-behind).
- Head on wrist: single wrist (arm drag l, elbow pass, hand on mat -> snatch single / go-behind, snap -> front headlock l), 2-on-1 (underhook l, duck under, snatch single), both wrists (double, slide by, low single, throw-by).
- Russian tie: snatch single, keyhole lock (throw, snap), snap (go-behind), foot sweep, high crotch, fireman's carry.
- Russian tie reactions: what she does depends on what HER OPPONENT does (head position, pulls arm away, head post, squares up) -> fireman's, snapdown, foot sweep, keyhole, uchi-mata, elbow pass, double, far leg, foot block, snatch single, body lock throws.
- Elbow control: 10 techniques, same shape.
- Front headlock (offense): gator roll (assassin), go-behind, cement job (near side cradle), shuck/throw-by (arm block).

## What GrappleMap already gives us (assets/grapplemap, public domain)
Standing 125 sequences, single leg 42, double leg 27, throw 16 (S335 count). So most of the chart finishes can be SHOWN on our
two women today; the tie-ups (collar tie, underhook, Russian tie, 2-on-1, front headlock) are the positions they start from.

## Verdict (Claude decides, he approves - D49)
1. STANDING CHAINS FIRST. Our own data file `wrestle_chains.json`: the 7 tie-ups as positions, each with the opponent's
   reactions and the techniques that answer them, each technique tied to the closest GrappleMap sequence so the browser plays
   it. A "Standing" tab in the ground-move browser (jump=grapple): pick a tie-up, see its reactions -> techniques -> finishes,
   play any of them. Why first: it is data plus the browser we already have, and it covers the gap (the ground data starts
   AFTER the takedown).
2. THE PLAN BOARD (GrappleFlows + his comment C154 "wire the correct in and outs for each transition" + Q-S294-61 step 3):
   ONE mechanic for boxing and wrestling. The coach builds her plan as cards and arrows: a start (tie-up / boxing range card)
   -> an entry -> a finish. Only moves she has trained can be placed (mastery); a better coach gets more arrows. In the bout she
   follows the plan; the OPPONENT'S REACTION picks the branch (223's "reactions" chart), so a plan with an answer for each
   reaction scores more. The corner changes one arrow between periods. Built once, used by both sports.
3. THE NUMBERS: a wrestler's six coach numbers (SportsReflector) as her attributes, trained by position focus
   neutral / top / bottom (WrestleAI), and her match log = attempts, takedowns, escapes, reversals, near-falls, pins.

Order: 1 now (after the ground polish lands), 2 after the boxing move map's position cards (Q-S294-61 step 1) so the board has
cards to hold, 3 when a wrestling career exists. Boxing demo work is not displaced: 1 is data + one browser tab.
