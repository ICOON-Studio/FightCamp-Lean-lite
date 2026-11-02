# TASK K77 - KALLI - THE WORDS: HANDBOOK LINES AND COACH LINES IN ONE HOUSE VOICE
Model: Kalli (Grok bot). Owner: kalli. Assigned S78, 2026-09-25. Words only: no code.

## Why
M32 says the words are Kalli's. S78 shipped two text sets written quickly by Claude: the Gym Handbook
(`Godot/scripts/Glossary.gd`, 46 terms: `short` <= 15 words, `why` <= 12 words) and the tutorial's 19 coach lines
(`Godot/scripts/CoachMarks.gd`, `STEPS`, each <= 2 sentences, the voice of a head coach). Read both files whole.

## What would a human do?
A game writer makes one voice sheet (who is talking, how they talk, banned words) and then rewrites every string to
it against its length budget - in a spreadsheet, not inline.

## Do
1. A voice sheet for the Handbook (neutral, plain) and for the coach (senior head coach, warm, blunt), with 5 banned
   words/constructions.
2. Every Handbook `short` and `why`, rewritten inside the same budgets, sentence case.
3. Every coach line rewritten, <= 2 sentences, one action per step.
Output as a table: id | current | proposed | words. Claude applies it.

## Deliverable
`research/K77_HANDBOOK_WORDS.md`.
