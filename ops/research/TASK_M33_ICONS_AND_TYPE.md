# TASK M33 - MARIA - THE ICON SET AND THE TYPE SPEC FOR THE S79 MENU PASS (art direction only)
Model: Maria (Grok bot, art direction). Owner: maria. Assigned S78, 2026-09-25. Art only: no code, no .tscn, no HANDOFF.

## Why
S79 applies your M32 guide across every screen. Two pieces of M32 are not yet specific enough to build from:
(7.5) "every rail item gets an icon" and (7.2) Inter with `tnum`. S78 found the repo ships Bebas Neue, IBM Plex Mono
and Work Sans Variable only (`Godot/assets/fonts/`) - no Inter.

## What would a human do?
An AD handing a UI pass to engineering delivers an icon map (screen/state -> named glyph from ONE set, with size,
stroke and licence) and a type spec sheet (family files, weights, sizes per role, feature flags) - not moods.

## Do
1. Icon map from ONE set (Lucide or Phosphor - pick, with licence text): the 8 rail items (The day, Gym, Staff,
   Training, Schedule, Scouting, Rankings, Office), the 10 Handbook areas (Gym, Roster, Training, Condition,
   Matchmaking, Fight Week, Weigh-in, Fight Night, Money, Rules), state pills (needs you, booked, injured, suspended,
   on weight, off weight, NOT LINKED). Name each glyph exactly as the set names it.
2. Type spec: Inter vs Work Sans (already shipped, OFL) - which, and why; the exact font files to add if Inter; weights
   per M32 7.2 role; whether `tnum` is available in that file. Keep Bebas for display only.
3. One mock: the S78 tooltip (dark card, NAME / definition / Now / Why, red NOT LINKED line) restyled to your guide.
   The live one is visible in `previews/s78_tutorial/05_tut_04_gym.png`.

## Deliverable
`research/M33_ICONS_AND_TYPE.md`, the mock PNG, `CLAUDE_LAND_NOTE_M33.md`, via your usual delivery.
