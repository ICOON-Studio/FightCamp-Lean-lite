# TRAINPLAN2 - his Fighter Training Blueprint in the game (S351 proposal, for his OK)

Operator, S351: "not that good for training" (Q-S294-73), then the picture "FIGHTER TRAINING BLUEPRINT - combat sports
periodization": block periodization (weeks 1-2 accumulation, 3-5 integration, 6-8 realization), a weekly fatigue matrix
(high CNS day / technical low-impact day / high metabolic day), trackable logs (AM/PM split, RPE log, weight + hydration).

## What would a human do?
A boxing coach plans a camp backwards from fight night: volume first, intensity in the middle, a taper so she arrives
fresh and on weight (block periodization, Issurin; high-low CNS days, never two hard days in a row; session load = RPE x
minutes, Foster - the same load our TrainingLoad acute:chronic ratio already reads).

## In the game (three layers on the S351 rounds rule, nothing thrown away)
1. CAMP PHASES (macro) - the camp's weeks split by weeks-to-fight: BUILD (first quarter: high volume, low intensity -
   roadwork, shadow, bag), SHARPEN (middle: hard sparring, pads, tactics), PEAK (last 2 weeks: low volume, sharp, the
   weight cut). Each phase writes the week's default rounds and load; the player can change any week. Out of camp: BASE.
   Effect: a real taper = she starts fight night fresh; skipping it = she carries the camp's fatigue into round 1.
2. THE WEEK (micro) - Mon-Sat as days, each a type: HARD (sparring, heavy bag), SKILL (pads, shadow, slip rope, speed
   bag), ENGINE (roadwork, intervals), REST; AM = engine, PM = skill or hard. The coach writes a high-low week; the player
   swaps a day's type. Two HARD days in a row turns the day red: fatigue and injury risk up. The days add up to the rounds
   per session (today's cards), so gains keep the S351 curve.
3. LOGS - after each day: an effort dot (RPE 1-10 from the day's load and her fatigue) and her waking weight against the
   limit; the week review shows both lines.

## Order of build (each a playable step)
1. The week as days (types, the high-low rule, red on two hard days) - feeds today's rounds.
2. Camp phases on the fight-camp page + taper -> fight-night freshness.
3. Effort and weight logs on the Training page and the week review.
Pictures (TRAINCLIPS1) stay the session cards' art; round 4 failed the visual gate, so it moves to Ziva.

## Prior research
`prior_research.py training week schedule sessions`: J62_TRAINING_DAY_REPLY (McCabe 2023: 12 elite amateur boxers, a
12-week camp), J_STRESS_S206 (functional overreaching vs non-functional), TrainingLoad.gd (Gabbett, Williams EWMA).

## Prefab check
No Godot periodization planner exists; Football Manager's training calendar (sessions in day slots, intensity) is the
nearest real UI. Built from our own rules.
