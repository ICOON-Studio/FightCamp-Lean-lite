# TASK G101 - GROK - WHAT WORDS DO COACHES AND SCOUTS USE FOR A FIGHTER'S LEVEL? (research only)
Model: Grok Expert (Research mode, NEVER Build). Owner: grok. Assigned S78, 2026-09-25. Pure research, no code.
Blind pair: Dola runs D23 on the same question without seeing this answer.

## Why
FightCamp's tooltips (S78) follow J52's template: TERM / one-line definition / **Now: value -> band word** / Why. The
band word is missing: a fighter shows PROFICIENCY 60, CONDITION 61%, FIGHT IQ 45, POTENTIAL 72 on 0-100 scales, and
the tooltip should say what 60 MEANS in the words a real coach would use ("solid club amateur", "national level").

## What would a human do?
Answer first: how does a real boxing/MMA coach, a scout, a matchmaker describe a fighter's level out loud? (novice,
carded, club, regional, national, international, journeyman, prospect, contender, world class...) How do amateur
federations grade boxers (England Boxing / USA Boxing classes, bout counts, novice/open/elite)? How do management
games that show 0-100 or 1-20 attributes put words on them (Football Manager's 1-20 attributes and star ratings, Fight
Night / UFC ratings, EA FC)?

## Questions (tag each SOURCED / PROXY / JUDGEMENT)
1. The real-world ladder of level words for boxing and for MMA, lowest to highest, with what each means in bouts
   fought, record or titles.
2. Condition/readiness words a trainer uses for a fighter's state on a given day (fresh, flat, overtrained, sharp...).
3. How 3 management/sports games map numbers to words (FM, EA UFC 5, one more), with the actual thresholds if public.
4. A proposed band table for FightCamp's 0-100 scales: PROFICIENCY, CONDITION (%), FIGHT IQ, POTENTIAL, MORALE -
   5 to 7 bands each, threshold + one-to-three-word label + tag.

## Deliverable
One markdown memo ending with the band table. Claude saves it as `research/G101_SKILL_BAND_WORDS.md`.
