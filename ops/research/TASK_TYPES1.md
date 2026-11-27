# TASK TYPES1 - the owner's four card types (Attack / Counter / Feint / Defend) measured on Puncher's chance (S570)

Kind: probe. Model: Opus 5.5 or Fable console worker (PC, balance runs jobs=2) or Arena. Discipline: boxing (order.html).
Seat rules: ops/research/WORKER_S566.md. Rule: MECHANICS NEED 8 - measured first, then two fresh critics, then built.

## His words (S570, verbatim, the idea he pasted, then "what do you think ?")
"1. Attack Cards (Red) ... Beats Feint (hits them before they finish faking). Loses to Counter (walks into a trap). Deals
direct damage. 2. Counter Cards (Blue) ... Beats Attack (negates their damage and deals bonus counter-damage). Loses to
Feint (you swing at air and lose stamina). High damage if it hits, high stamina penalty if it whiffs. 3. Feint / Setup
Cards (Yellow) ... Beats Counter (baits out their big counter, draining their stamina). Loses to Attack (gets clipped
while faking). Deals 0 damage, but lets you draw a card, recover stamina, or boost your next Attack. 4. Defend Cards
(Green) ... Neutralizes Attack (blocks all or most damage). Ties against Feint and Counter (nothing happens). Blocks
incoming damage and restores a small amount of Stamina." + a 5th, Takedowns (Purple): MMA, after boxing (one art first).

## Claude's answer (S570)
It targets the measured broken plan (the feint loop 35-53%, bar 30; every top league seat named the feint): Attack beats
Feint is a cap inside the rules. Risks: a pure triangle is a coin flip - each type needs a READ condition (a Counter only
works if his attack reaches at that range; a feint loses power each time it is repeated); Defend as written is dominant
(stops Attack, ties the rest, gives stamina) - it must cost ground (the ropes), points or a passivity warning.

## Versions (tweak files, `src` patches only; order.html never edited)
- T0: today's page with its own table - the control.
- T1: every switch gets a TYPE (punches = Attack; a punch thrown in the moment after his miss/block or into his step =
  Counter; feint and the empty step = Feint; a hand held home + stay put / back off = Defend). Each moment, when both men
  act, the triangle decides first (Attack > Feint > Counter > Attack; Defend stops Attack, ties the rest), then today's
  range / guard rules size the damage. Counter whiffed = -2 stamina; Feint won = +1 stamina or +1 to his next Attack;
  Defend = +1 stamina and gives ground (one ropes mark).
- T2: T1 + the reads: Counter only answers an Attack that reaches at that range; a Feint repeated in consecutive beats
  loses its win over Counter.

## Do
1. One-rep trials n=12 seed 1 for T1 and T2 (gate: no switch over 40%, stoppages 5-50%).
2. Each version: its own table, then n=56 on seeds 1 and 2: the nine page bars, the feint loop (Arena's loop measure,
   TELLS5M / FEINTFIX2 tools), the comeback share, how often each TYPE is picked and wins.
3. docs/TYPES1_RESULT.md - a table per version, the verdict, and for the owner in plain words what the player would
   feel; last line `TYPES1 DONE` or `TYPES1 BLOCKED: <why>`. A version that passes goes to two fresh critics (CRITIC_PACK
   first) for DEPTH and PLAY 8+.

## Feedback loops
- Feint won -> stamina / next Attack boosted -> more Attacks -> Feint loses more: self-limiting (Attack beats Feint).
- Defend -> stamina back -> more actions later: capped by the ropes mark (two = on the ropes, no back off).
- Counter whiff -> stamina loss -> fewer actions: the floor is today's recovery (+1 a beat).
- Trial first (one rep) before the full runs; stop if T1's plan mix equals T0's.

## Contract
- OWNS: ops/research/s558_balance/types1_*.json, ops/research/s558_balance/results/types1_*.txt, docs/TYPES1_RESULT.md
- RED_TEST: the feint loop on T0 (today's number to beat)
- REGRESSION: node proto/twohands/tools/rules_test.mjs (the page is not changed)
- VISUAL: none (a measure)

## Prior research
docs/FEINTFIX2_RESULT.md, TELLS5M (cut), COUNTERS2_RESULT.md (counters as reads failed: 90-100% when cut off),
MMC_PLAYTEST_S569.md (Mixed Martial Cards' attack / counter / feint words), the agents' league S567.

## What would a human do?
A boxer reads: jab the man who is faking, counter the man who commits, fake the man who waits to counter, cover up when hurt.

## Prefab check
Not applicable (our rules); the triangle is a common game shape, written in our own words.

## Not yours
Every page and rule file. No public push. Never "Ring Switches".
