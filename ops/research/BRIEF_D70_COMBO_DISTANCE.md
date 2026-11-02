# D70 brief (Dola) - how close does a boxer start a combination, and how far do his hips travel during it?

You are a boxing biomechanics researcher. Answer from real sources (coaching manuals, biomechanics papers, fight
breakdowns, measured footage), each claim with its source. Numbers in centimetres or metres. Say "no source" where none.

## Context
We animate a boxing game. Three combinations clip (one body passes into the other) at the spacing we start them:
1. the LIVER combo: lead jab -> rear cross -> lead hook to the body (liver)
2. the 1-2-HOOK: jab -> cross -> lead hook to the head
3. a SIX-PUNCH combination ending in a rear uppercut
Our measurement: no step is taken between punches; the forward travel of the whole combination equals the lunge of its
deepest single punch (body hook 0.61-0.68 m of hip travel, rear uppercut 0.48-0.53 m, cross 0.11-0.12 m), and we start
the combination at the jab's distance (about 0.89 m between the two men's centres). The closest approach happens inside
the body hook / uppercut, not between punches.

## Questions
1. At what distance (centre to centre, or lead foot to lead foot) do real boxers START a 3-punch combination that ends
   in a body hook or an uppercut? Is it the jab's range, or do they first close to a shorter range?
2. During such a combination, do the FEET move? Describe the usual pattern: step in with the jab, drag the rear foot,
   pivot on the hook, a "level change" (bend the knees) for the body hook. Give step lengths if any source has them.
3. How far does the HIP / centre of mass travel forward during a lead hook to the body and during a rear uppercut, and
   how much of it is a knee bend (going DOWN) rather than going FORWARD?
4. What does the receiver usually do (step back, shell, pivot) that changes the distance during a combination?
5. One line: what is the most common mistake an animator makes when chaining these punches?

## Prior research (already settled, do not redo)
- G53_THE_COMBINATION_INTERVAL: the TIME between punches in a combination (we have it).
- K33_INTER_PUNCH_INTERVALS: inter-punch timing.
- G46_TWO_BODIES_IN_SPACE: general spacing between two bodies in a fight sim.
- The GAP: none of these gives the DISTANCE a combination starts at or the foot/hip travel inside it. That is this task.

## What would a human do?
A boxing coach would say where each punch is thrown from and how the feet move ("step in with the jab, sit down on the
hook"); a biomechanist would give hip displacement from motion capture. We want both.

## Prefab check
If any public motion-capture dataset or paper has measured hip/foot displacement for boxing combinations, name it and
its licence.

## Answer format
Markdown, headings = the 5 questions, each with: the answer, the numbers, the sources (title + link).
