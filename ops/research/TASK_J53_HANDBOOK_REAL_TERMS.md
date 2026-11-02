# TASK J53 - JOHN - THE GYM HANDBOOK'S REAL-WORLD TERMS, CHECKED AGAINST THE RULEBOOKS (research only)
Model: John (Grok bot, deep research). Owner: john. Assigned S78, 2026-09-25. Research only, no code, no HANDOFF edits.

## Why
S78 shipped the Gym Handbook: `Godot/scripts/Glossary.gd`, one entry per term (name, a <=15-word definition, a
<=12-word "why it matters"). Your J52 §6b rule 6 said real-world terms must match real usage and be checked against
the federation sources. The first 46 entries were written from the game's side; the fight-business terms were not
checked. Every tooltip, the tutorial and the future Handbook screen read these lines.

## What would a human do?
A new gym owner learns these words from the head coach and from the federation's rulebook and officials' handbook
(England Boxing, USA Boxing, ABC unified MMA rules, a state commission). So: take each term from the rulebook first,
then say it in the coach's plain words.

## Do
1. For each term, give: the rulebook meaning (quoted <= 15 words, with source), a plain definition <= 15 words, a
   "why it matters to a gym owner" <= 12 words, and whether amateur boxing / pro boxing / MMA differ.
   Terms: weigh-in, weight class, agreed/catch weight, walk-around weight, weight cut (rehydration clause), medical
   suspension (days after KO / RSC / TKO), RSC, OIC / referee / judges / 10-point must, sanctioning body vs
   commission, matchmaker, promoter, purse vs show money vs win bonus, carded / registered boxer, record (W-L-D, NC),
   corner (cutman, one-minute rest), fight camp, fight week, ranking, title eliminator, mandatory challenger.
2. Flag every place `Godot/scripts/Glossary.gd` (read it whole, ~260 lines) says something the rules contradict.
3. Add any term a first-month player will meet that is missing (J52 §6d steps 7-18).

## Deliverable
`research/J53_HANDBOOK_REAL_TERMS.md` plus `CLAUDE_LAND_NOTE_J53.md`, via your usual delivery. Research only.
