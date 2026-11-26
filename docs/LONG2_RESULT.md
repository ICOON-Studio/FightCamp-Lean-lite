# LONG2 RESULT - Long is a corridor: Kalli's waiting cross and the jab that meets him (S565, probe)

Task: `ops/research/TASK_LONG2.md`. Branch `arena/193e5c2c-fightcamp-lean-lite`. No page edit, no edit to rules.mjs,
balance.mjs or a test; no `*.vt.json` committed (the tables live in `/home/user/long2_vt/`, outside the repo).

**Order run.** `long2_check.mjs` printed `LONG2_CHECK 15 passed` first. K0 (the page, its own `vtable.json`) seed 1, then
its Long count, seed 2, its count, the lazy run. Next, the one-rep trials of K1, K2 and K3 (n=12, the page's table), all
three before any table. Then for each version: table, seed 1, seed 2, the Long count on seed 1 and on seed 2, and the lazy
run (`who=sensible,random opp=mirror n=42 seed=1`, on the version's table). Every run was committed and pushed right after
it finished. Regression at the end: `rules_test.mjs` printed `RULES_TEST 37 passed`, and `long2_check.mjs` printed 15 passed.

**The Long count** is `proto/twohands/tools/probe_long2.mjs`. It is a counting copy of balance.mjs's bout loop: the same
calls, the same worker seeds and the same bouts a worker. So with the same n / seed / jobs / tweak / table it plays the SAME
bouts as `balance.mjs play`. Its first line checks this, and it matched on all 8 runs (wins, beats, knockdowns, ranges). A
"cross from Long" is one thrown in a moment that STARTS at Long. A cross thrown after the man has already stepped in is a
Mid punch. "Unhit" means he took no landed punch from the step's moment to the end of the beat. The rear-hand bar uses
cross + body cross, counted for each man in each beat that starts at Long. Outputs are in
`ops/research/s558_balance/results/long2_<k0|k1|k2|k3>[_s2].txt`, `long2_<v>_count[_s2].txt`, `long2_<v>_trial.txt`,
`long2_<v>_table.txt` and `long2_<v>_lazy.txt`.

**Trials (n=12, seed 1, the page's table).** K1: Long 38%, stoppages 50%. K2: Long 38%, stoppages 50%. K3: Long 27%,
stoppages 25%. All three are inside the gate (Long at most 60%, stoppages 5-50%), so all three went on. K1 and K2 sat
exactly on the 50% edge (6 bouts of 12). With their own table and n=84 they came down to 17-19%.

**Two facts read off the instrument, not guesses.**
- The page's solver is BLIND TO POINTS. `worth()` counts health, stamina, the stamina bar, guard, ground and being kept
  out. It never counts points. So a rule that changes only points changes no choice:
  - the K3 table is byte-identical to the page's `vtable.json`;
  - the K1 table is byte-identical to the K2 table;
  - K3 plays exactly K0's bouts (same ranges, punches, knockdowns and stoppages; also checked on the n=12 trial), and only
    the cards change. The same holds for K2 against K1.
- The page today already uses the waiting cross a lot. At Long with 6 beats left, the solved mix's top plan is "1 Cross,
  2 Back off" (18%), and "1 Back off, 2 Body cross" is another 9% (`balance.mjs mix`).

## The table (n=84 each; K0-K3 x seeds 1 / 2)

| version | seed | page bars | task bars | Inside / Mid / Long | Jab / Body jab / Cross / Body cross (a man a beat) | Long beats a bout (start), none thrown | rear at Long: thrown / lands | cross from Long: lands / onto a stepping man / blocked / short | counters off the short cross | jabs from Long a bout, land, on a stepping man a bout | step in from Long a bout: high / low / lead busy, unhit | step in, lead held high (a beat) | from Long a bout: points / health | rounds won by Long points | stoppages, knockdowns, draws, level rounds | lazy: 2nd cross running (share of Long beats, lands); any rear | sensible / random v mirror wins | same bouts |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| K0 | 1 | 7 of 9 | 7 of 11 | 30% / 37% / 33% | 8% / 17% / 26% / 23% | 7.9, 2% | 29% / 13% | 11% / 11% / 4% / 85% | 7% | 7.3, 66%, 0.73 | 5.4: 11% / 39% / 50%, 54% | 32%, 8% | 5.82 / 8.76 | 7% | 20%, 2.4, 5%, 13% | 3%, 0%; 7%, 15% | 29% / 0% | yes |
| K0 | 2 | 8 of 9 | 8 of 11 | 33% / 35% / 32% | 6% / 18% / 23% / 24% | 7.8, 1% | 30% / 11% | 11% / 11% / 13% / 75% | 9% | 7.5, 66%, 0.83 | 5.5: 16% / 36% / 48%, 50% | 34%, 9% | 5.86 / 8.88 | 8% | 21%, 2.4, 1%, 11% | 2%, 30%; 7%, 21% | (seed 1 only) | yes |
| K1 | 1 | 8 of 9 | 9 of 14 | 29% / 35% / 36% | 6% / 18% / 25% / 24% | 8.3, 2% | 34% / 12% | 8% / 8% / 10% / 81% | 9% | 7.5, 67%, 0.71 | 5.1: 23% / 33% / 44%, 51% | 30%, 10% | 6.65 / 9.54 | 13% | 19%, 2.3, 7%, 14% | 3%, 21%; 10%, 21% | 38% / 0% | yes |
| K1 | 2 | 8 of 9 | 8 of 13 | 28% / 35% / 36% | 7% / 19% / 23% / 26% | 8.3, 1% | 32% / 8% | 7% / 7% / 10% / 84% | 6% | 7.9, 61%, 0.73 | 5.0: 20% / 30% / 50%, 53% | 30%, 9% | 6.21 / 8.52 | 11% | 17%, 2.3, 6%, 13% | 2%, 13%; 9%, 8% | (seed 1 only) | yes |
| K2 | 1 | 8 of 9 | 9 of 14 | 29% / 35% / 36% | 6% / 18% / 25% / 24% | 8.3, 2% | 34% / 12% | 8% / 8% / 10% / 81% | 9% | 7.5, 67%, 0.71 | 5.1: 23% / 33% / 44%, 51% | 30%, 10% | 5.94 / 9.54 | 11% | 19%, 2.3, 6%, 13% | 3%, 21%; 10%, 21% | 36% / 0% | yes |
| K2 | 2 | 8 of 9 | 8 of 13 | 28% / 35% / 36% | 7% / 19% / 23% / 26% | 8.3, 1% | 32% / 8% | 7% / 7% / 10% / 84% | 6% | 7.9, 61%, 0.73 | 5.0: 20% / 30% / 50%, 53% | 30%, 9% | 5.49 / 8.52 | 8% | 17%, 2.3, 5%, 14% | 2%, 13%; 9%, 8% | (seed 1 only) | yes |
| K3 | 1 | 7 of 9 | 8 of 14 | 30% / 37% / 33% | 8% / 17% / 26% / 23% | 7.9, 2% | 29% / 13% | 11% / 11% / 4% / 85% | 7% | 7.3, 66%, 0.73 | 5.4: 11% / 39% / 50%, 54% | 32%, 8% | 6.55 / 8.76 | 9% | 20%, 2.4, 5%, 12% | 3%, 0%; 7%, 15% | 29% / 0% | yes |
| K3 | 2 | 8 of 9 | 8 of 13 | 33% / 35% / 32% | 6% / 18% / 23% / 24% | 7.8, 1% | 30% / 11% | 11% / 11% / 13% / 75% | 9% | 7.5, 66%, 0.83 | 5.5: 16% / 36% / 48%, 50% | 34%, 9% | 6.69 / 8.88 | 11% | 21%, 2.4, 1%, 10% | 2%, 30%; 7%, 21% | (seed 1 only) | yes |

Task bars missed:
- K0 seed 1: page bars 8-9 and >= K0; rear at Long 5-15%, lands 30-65%; jab 10%+ of beats; steps in from Long 60%+ unhit
- K0 seed 2: rear at Long 5-15%, lands 30-65%; jab 10%+ of beats; steps in from Long 60%+ unhit
- K1 seed 1: rear at Long 5-15%, lands 30-65%; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit; sensible / random <= K0 (seed 1)
- K1 seed 2: rear at Long 5-15%, lands 30-65%; no-punch Long beats down v K0; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit
- K2 seed 1: rear at Long 5-15%, lands 30-65%; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit; sensible / random <= K0 (seed 1)
- K2 seed 2: rear at Long 5-15%, lands 30-65%; no-punch Long beats down v K0; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit
- K3 seed 1: page bars 8-9 and >= K0; rear at Long 5-15%, lands 30-65%; no-punch Long beats down v K0; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit
- K3 seed 2: rear at Long 5-15%, lands 30-65%; no-punch Long beats down v K0; points from Long +50% v K0; jab 10%+ of beats; steps in from Long 60%+ unhit

How to read the table:
- "Page bars" are the nine bars from balance.mjs. K0 seed 1 fails two of them: Push off is just under 3%, and the Jab and
  Overhand land too often.
- "Task bars" count the bars of TASK_LONG2 that can be judged on that row. For K0 there is no "against K0" bar, and the
  lazy bar is judged on seed 1 only. Draws must be at most 20%.
- The range shares are where each beat ENDS, as balance.mjs counts them. "Long beats a bout (start)" counts the beats
  that START at Long: 45-47% of all beats, because every round starts at Long.

## What it says
1. The page already catches the man who steps in, but it is a lottery: each man throws a cross or body cross from Long in 29-30% of his Long beats, twice the 5-15% bar. Only 11-13% land, almost all on a man stepping in; 75-85% fall short. The head cross alone is worth 0.55 points and 0.8 health a bout, and he counters off a short cross only 7-9% of the time.
2. K2, the cross half (+1 health when he walks onto it): he steps in behind a high lead more (11-16% -> 20-23%), so the waiting cross lands less (7-8%) and falls short more (81-84%). Long rises from 33/32% to 36/36%; knockdowns 2.3, stoppages 17-19%. The +1 is spent on the high lead it causes.
3. K3, the jab half (2 points): the solver cannot see it, and the bouts are K0's own. Points from Long +12-14% (bar +50%), rounds won by points from Long 7-8% -> 9-11%, draws unchanged (5/1%), level rounds 13/11% -> 12/10%.
4. K1, both halves: K2's bouts with K3's scoring. Points from Long +14% / +6%.
5. The rear hand has no real job at Long in any version: thrown in 29-34% of Long beats, landing 8-13% (bar 5-15% thrown, 30-65% landing). The head jab stays at 6-8% of beats (bar 10%).
6. The man walking in gets in, but under the bar already on K0: 50-54% of steps from Long are unhit (bar 60%). "Step in" stays at 30-34% of beats and "lead held high" at 8-10%; neither is a must.
7. No lazy plan: a second cross from Long running happens in 2-3% of Long beats and lands 0-30%, so Kalli's cap is not needed. Sensible v mirror wins 29% (K0, K3) and 36-38% (K1, K2; n=42, about +-7 points); random wins 0%.
8. The solver values health, never points, so a scoring-only rule cannot move the instrument or the page's opponents (they play `worth()` too).

put on the page: none. The nearest is K2: 8 of 9 page bars on both seeds, one up from K0 seed 1. It misses the rear-hand bar (thrown 32-34%, lands 8-12%), points from Long +50% (it gets +2% / -6%), the jab at 10% (6-7%), 60% of steps in unhit (51-53%) and the lazy bar (sensible 36% against 29%). K1 is K2 with the jab's points, which the solver cannot see.

Next change to try, as one tweak pair: put the jab half into HEALTH, which the solver can see, instead of points. A jab or body jab that lands in the moment he steps in from Long is a counter (+N.counter: 2 health). Pair: (a) that change alone; (b) that change plus K2's cross half. Score it on the same bars, with K2 as the reference.

LONG2 DONE
