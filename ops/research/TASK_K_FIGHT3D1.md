# TASK K-FIGHT3D1 - KALLI - the minimum watchable fight night in 3D (lean restart, week 5)

Model: Kalli (Grok bot, game design). Discipline: boxing (demo). Design only: no code, no repo.

## What exists (the game today, weeks 1-4, all in words)
A boxing gym manager (PC, deep management sim, think Football Manager match view). The player runs a gym in London and
manages women amateur boxers (51/57/60/66 kg classes). Fight night today is a modal in words: 3 rounds (amateur) or 4
rounds (pro debut), each round shows a few lines of what happened ("Lucy doubles the jab and walks Holly onto the
right hand"), a round winner and three judges' cards (10-9 per round). Between rounds the player picks a corner call
(e.g. "Box behind the jab", "Go to the body", "Stay off the ropes") that nudges the next round. The result (decision,
draw, stoppage) is computed BEFORE the watch from stats, camp, film study and "weapons" (moves at mastery 30+).

Week 5 adds a 3D VIEW of that same bout. The rule: the 3D view never decides anything. It only shows what the words
and the cards already say. Same winner per round, same corner call effect.

## What we have to show it with
- Two female MetaHuman boxers (realistic, game camera), a ring.
- Clean punch clips: jab, cross, lead hook. Guard idle. Rear uppercut, body hook, slip, pull, catch exist in an older
  pipeline. Hit reactions: head hit, body hit, knockback. Knockout winner / loser. Footwork steps and a duck.
- No commentary audio (the operator wants no sounds in tests; the game may get sound later).

## The questions (answer every one; give the longest complete answer you can, no cap)
1. How long should one watched round last in real seconds (a real round is 2 or 3 minutes)? Can the player skip or
   speed it up, and how?
2. What happens on screen in one round: how many exchanges, how many must land, how do you make the round's winner
   readable to someone who did not read the words (who presses, who lands, who backs up)?
3. What the player sees at the same time: the round's words as captions? a punch counter? the cards after each round?
   Keep it to the minimum a manager sim needs.
4. Between rounds: the corner call. Does the 3D show the corner (stool, coach) or cut to the same 2D picker?
5. Camera: one broadcast camera or cuts (close-up on a big shot, a replay of the round's best punch)?
6. Knockdown, stoppage, decision, draw: what does each look like at the end, in the fewest shots?
7. What NOT to build for the first version (we want it watchable in one week of work).
8. Give the exact data format the view plays, as JSON: a "round script" per round, made from the round winner and the
   words. Use this shape and fill one full example 3-round bout (Lucy Hart vs Holly Marsh, Lucy wins 2-1):
   {"rounds":[{"n":1,"winner":"a|b","seconds":0,"beats":[{"t":0.0,"who":"a|b","move":"jab|cross|lead_hook|body_hook|rear_uppercut|step_in|step_out|slip|clinch","result":"lands|blocked|misses|none","caption":""}],"end":"bell|knockdown|stoppage"}]}
   and give the rule that turns a round winner (and a margin: close / clear / dominant) into how many beats land for
   each side.

## Prior research
Our older full 3D fight engine (10,000 lines, real-time AI) was too big to keep; this restart makes the 3D a thin view
on the same bout data. Real amateur boxing: 3 x 3 min women elite (2 min youth), 10-point must, judges score clean
punches on the target area.

## What would a human do?
Football Manager's match engine: a highlights mode (key moments only) and a full mode, captions, the score always on
screen, the manager's touchline shouts between phases. Fight Night / Undisputed broadcast camera at the ring apron.

## Prefab check
Clips and boxers already exist (listed above). The view uses them as they are.
