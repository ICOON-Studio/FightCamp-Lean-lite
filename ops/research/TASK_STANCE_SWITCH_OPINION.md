# STANCE SWITCHING — HOW SHOULD A FIGHT SIM TREAT IT? (opinion brief, S59, 2026-09-23)

Owners: grok, dola (same brief, answered blind to each other). Opinion + design, no code.

## Owned files

- `research/STANCE_SWITCH_OPINION_GROK.md`, `..._DOLA.md` - Claude saves your answers here.

## The game

A career MMA/boxing management sim. You run a gym; your fighters train techniques in a skill tree; bouts
are simulated tick by tick and shown in 3D. Every fighter has a stance, ORTHODOX (left foot forward) or
SOUTHPAW (right foot forward). The engine already models the MATCHUP: "closed" (same lead) vs "open"
(opposite leads), and the only effects allowed are which hand is the "long" hand and which body kick is
free - small, deliberate numbers, no damage multiplier.

## What does NOT exist

Nobody switches stance mid-fight. The rule so far: "no switch-hitting until a fighter owns an authored
switch skill". There is no switch skill, no in-fight decision, and no switch animation.

## The operator's ruling, verbatim - treat it as fixed

> "that happens depending on how the fighters are prepared for each other, its more like a tactic change
> to counter or match something that the current tactic lacks"

So a switch is a TACTIC, not a frequency. We will not model "switches per round" as a rate.

## What I want from you

1. **The trigger model.** When does a fighter switch? Give concrete, simulatable conditions - e.g. the
   open-stance matchup is costing him (he is eating the rear straight), he wants the power hand forward
   to finish a hurt man, he wants to change the angle for a specific kick, the corner told him to between
   rounds, the fight plan prepared it against this opponent in camp. Rank them by how often they really
   drive switches, and mark each claim as sourced or your judgement.
2. **Who can do it, and how well.** A switch skill in the tree - one node or a ladder (occasional switch
   -> comfortable in both -> true switch-hitter)? What does a fighter who switches WITHOUT the skill pay
   (worse defence, slower, telegraphed)? Name real fighters as examples of each level.
3. **Mid-round vs between rounds.** How much of real switching is a corner instruction between rounds
   versus an in-exchange decision? This decides whether it lives in the fight plan or the tick engine.
4. **Animation.** We will make one-body clips: a switch in place (small hop / shuffle), a step-through
   switch (rear foot steps forward, closing distance), and switches INSIDE combinations (e.g. a
   switch-kick). Which of these are essential for a first version, and which are polish?
5. **The counter-play.** What does the OPPONENT do about it, and should the sim model that at all?

## Rules

- Mark every number measured (with source) or your judgement.
- A section "WHAT I COULD NOT FIND".
- **ARGUE AGAINST YOURSELF**: attack your own trigger model. What is the strongest case that it is wrong,
  or that switching should stay out of the sim entirely for now?
- Female fighters never fight males; the training facility is a "gym", never a "camp" (a fight camp is
  only the pre-bout preparation).
