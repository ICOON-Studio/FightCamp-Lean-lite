# TASK TURNREV4 - write the turning pro map v4 (TURNPRO1_V4) from the code, answering both v3 critics

Kind: research
Status: OPEN (S529, Claude main). Discipline: boxing. Model: Goose (cloud), default. RESEARCH ONLY - no game code changes.

## Why
TURNPRO1 v3 (`ops/research/DESIGN_TURNPRO1_V3.md`, Dola, written to answer the measured probe docs/TURNPROBE2_RESULT.md:
8 of 9 pass lines failed on the BUILT v2) scored Goose 7/7 (`DESIGN_TURNPRO1_V3_CRITIC_GOOSE.md`) and Arena 5/4
(`DESIGN_TURNPRO1_V3_CRITIC_ARENA.md`). The bar is 7+ DEPTH and 7+ GENERAL from two fresh critics (owner S425/S459).
Both critics found the same root: the map's numbers do not match the code that is already in the game (split ask, defer
fee timing, the opponent-gap direction, the ticket price never reaching the gate), and the money is not one dated model.

## Your job
Write `ops/research/DESIGN_TURNPRO1_V4.md`: the whole map again (v3's sections), changed so that:
1. Every row tagged CODE matches the code - READ IT: `scripts/state/ProOfferWire.gd` (offers, forecast, expiry, asks,
   plain), `scripts/rules/ProCall.gd` (who calls, ESTIMATES), `scripts/rules/ProLean.gd` (the house's lean),
   `scripts/state/Roster.gd` check_pro / turn_pro / decline_pro / debut_night, `scripts/ui/ProWeekLines.gd`. Quote file +
   function for each CODE row. Where v3 CHANGES a built number, tag it CHANGE (old -> new, why) - never CODE.
2. ONE dated money model (Arena 1): at signing, at each week to the debut, at the debut: stipend, costs, purse, gate,
   gym share, boxer share - as one table with dates, both parties' before/after cash, and what happens if the bout is
   cancelled or the purse does not cover deferred costs. Ranges where the probe measured ranges.
3. Waiting is a real decision (Arena 2): the exact trigger for the next call (wins, rank, title), shown with its
   uncertainty; a path when only one house calls; what "not yet" costs (Goose 7: not yet must not count as a decline
   unless the code says so - the code's lapse rule, S523: a lapsed window is NOT a decline).
4. Every ask repaired end to end (Arena 3, Goose 2): each ask's before/after terms, its counter, its price, its WHEN it is
   the best ask (TURNPROBE2: 'costs' best in 68%, softer/split/no-ask never) - cut any ask that stays never-best.
5. The day-job road to pro (v3's answer to TURNPROBE2's 1-in-150) with at least two decisions on it (Goose 1), each tied
   to an existing game value (file + function) or CUT.
6. The boxer's voice: ambition -> a visible, gender-neutral preference with its morale size and duration (Arena 4);
   the age line stated as a game rule, not real-world law.
Keep: the probe pass lines (all nine v2 lines plus v3's new ones, each measurable headless), the wire map table (every
menu the mechanic appears on and what it is wired to - owner S425; the screens exist since S523: say what changes on
each), plain game words, names only in headers (owner S448), no new screen. End with a "Changed from v3" list.

## Deliverable
ONE new file `ops/research/DESIGN_TURNPRO1_V4.md`. A PR that adds only that file. Do not edit any other file. Do not run
Godot. Under 450 lines.

## Contract
OWNS: ops/research/DESIGN_TURNPRO1_V4.md
RED_TEST: none (research)
REGRESSION: none
VISUAL: no

## Prior research
DESIGN_TURNPRO1_V3.md, both v3 critics, docs/TURNPROBE2_RESULT.md, ops/research/DESIGN_TURNPRO1_V2_REVISE_KALLI_KALLI.md.
## What would a human do?
A manager lays the two contracts side by side with a calendar and a calculator, and asks for the one change that matters.
## Prefab check
None: a design map.
