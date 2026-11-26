# TASK PROGP4 - the Sharp choice: a pair of its own for each punch, measured (S566, probe P4 of DESIGN_PROGRESSION1)

Kind: probe. Model: Arena (cloud) or a console worker. Discipline: boxing (Puncher's chance, order.html).
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite when it has room; else a console worker (read ops/research/WORKER_S566.md
first, jobs=2). Estimate: 4-6 hours.

## Why
Owner Q-340 "Yes, a choice": at Sharp (mastery 60) the player picks ONE of two upgrades for a move, for that fighter, for
good. PROGP2 (`docs/PROGP2_RESULT.md`, read it first) measured "cheaper or faster" for every punch: a real choice for the
Overhand only (57% / 55%), nearly for the lead uppercut (59 / 53). For the others one card is dead or one is always the
pick, and the jabs have nothing to give. PROGP2 lists one candidate pair for each, unmeasured. This probe measures them.

## The pairs (card a v card b; each is one change to that man's own copy of the punch)
| punch | card a | card b | PROGP2 said |
|---|---|---|---|
| Jab | keeps him out one beat longer (+1 keep) | reaches Long | no cheaper or faster to give |
| Body jab | +1 damage | reaches Long | same |
| Lead hook | +1 damage (3 -> 4) | reaches Long | cheaper is dead (43%) |
| Body hook | cheaper | +1 damage | faster is dead (46%) |
| Cross | cheaper | reaches Long | both too strong (62 / 63): ALSO run "reaches Long" against NO upgrade |
| Rear uppercut | faster | reaches Mid | cheaper too strong (59%) |
| Body cross | faster | +1 damage | cheaper bends the fight (67%, 44% of beats) |
| Lead uppercut | cheaper | faster | 59 / 53: run again at n=84 on seed 2 only, to see if 59 is noise |
The Overhand is settled (cheaper / faster) and is not run. Where a punch already reaches the range named, say so and
propose the nearest other card (do not invent a third family: cost, speed, damage, reach, keep).

## What to measure
1. Extend `proto/twohands/tools/probe_sharp.mjs` (its per-man table `tb` holds stamina and speed today) so a man's own
   copy also carries DAMAGE, REACH and the jab's KEEP, read wherever the rules read them for a man; the patch throws if a
   replaced text is not on the page; `probe_sharp_test.mjs` grows a test for each (red first), and its old five still pass.
2. One-rep trial: the Body cross pair at n=24. Stop a card that wins over 75%.
3. Each card: man A (the card) v man B (no upgrade), the solved mix both sides, `iters=400 n=84 seed=1`. Then seed 2 for
   every pair whose two cards are both inside 52-58% and within 6 points on seed 1.

## The bars (PROGP2's, unchanged)
A card is IN at 52-58% of decided bouts; under 52% dead, over 58% too strong. A PAIR is a choice when both cards are in and
within 6 points, on both seeds. Stoppages 10-40% in every run. Report for each card how much more the mix throws the punch
(A's share of beats v B's): over 2x is "bends the fight" and is flagged even when the win share is in.

## Feedback loops
- Upgrade -> the punch is thrown more -> more wins -> (in the game) more mastery for that punch. In the probe the first
  two links are measured; the cap is the 58% bar and the 2x use flag.
- +1 damage on a body punch -> his stamina bar shrinks faster -> he throws less -> the body punch lands more. Cap in the
  rules: `N.capMin`. Report his stamina bar at the last bell for the two body "+1 damage" cards beside no upgrade.
- Reach Long -> more beats spent at Long -> fewer exchanges -> draws. Report the share of beats at Long and draws for
  every reach card; a reach card that puts Long over 45% of beats is failed whatever its win share.
- The look-ahead table `vtable.json` is built for equal men: say so again, and for the two cards with the biggest effect
  rebuild the table with that card on BOTH men and re-run, to see if the number holds.
- One-rep trial first (step 2).

## Not allowed
No page edit, no `rules.mjs` / `balance.mjs` edit, no test deleted or loosened. No `*.vt.json` committed.

## Contract
- OWNS: proto/twohands/tools/probe_sharp.mjs, proto/twohands/tools/probe_sharp_test.mjs,
  ops/research/s558_balance/results/sharp4_*.txt, docs/PROGP4_RESULT.md
- RED_TEST: PROGP2: hook cheaper 43%, lbody faster 46%, cross 62 / 63, rup cheaper 59, rbody cheaper 67
- REGRESSION: probe_sharp_test.mjs (5 old + the new), rules_test.mjs 37, page_play_test.mjs 4
- VISUAL: none

## Result
`docs/PROGP4_RESULT.md`: one table - punch | card a: A wins, use v B | card b: A wins, use v B | gap | seed 2 | verdict
(choice / one card dead / one card always / too strong) - then for the player, in plain words, the two cards of every punch
that holds, and for each that does not, the next pair to try. End with `PROGP4 DONE` or `PROGP4 BLOCKED: <why>`.

## Prior research
docs/PROGP2_RESULT.md, docs/PROGP3_RESULT.md (attributes on the fight board), ops/research/DESIGN_PROGRESSION1.md (3b,
5.3, 6), memory S565 (Sharp choice: overhand only).

## What would a human do?
A designer gives each move the upgrade that fits what the move is for: a jab controls range, a hook hurts, a body punch
drains. Two cards of one move should pull the fighter toward two different ways of fighting, not toward one number.

## Prefab check
Not applicable (our rules).
