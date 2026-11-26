# PUNCHCHANCE2 - the Puncher's chance, second pass (S561)

Owner S559/S560 left one open item from PUNCHCHANCE1: **C lifts the comeback from 10% to 18% but its cost is knockdowns 2.6 a bout against a bar of 2.5** (the page today has 2.4), so C shows **7 of 9 bars**, not 8. The owner will switch it onto the page copy only when a version **holds 8 of 9 bars AND has the comeback pooled at 15-30%**.

This session tried the two follow-ups PUNCHCHANCE1 listed, plus their combination, behind one small probe option only:

- **N.pcFree** (new, in `proto/twohands/tools/probe_punch_chance.mjs`, off by default): a man dropped by an all-in punch gets up on his knockdown health and that knockdown does **NOT** count toward the three-knockdown stoppage — it still scores 3 points. Implemented as one `applyKnockdown` rule in the probe bout loop, gated on `N.pcFree`; when unset, every other tweak measures exactly as before (verified by the unchanged 13+1 tests).
- **N.pcGap** (already in C): the trigger gap in health behind after round 1 (C = 4, A = any, this pass tries 5).

Three new tweak files beside `punch_chance_c.json` (`ops/research/s558_balance/`):
- **E** = C with `pcGap` 5 (trigger 5+ behind).
- **F** = C with `pcFree` 1 (all-in knockdown gets up, free of the stoppage count).
- **G** = C with `pcGap` 5 and `pcFree` 1 (both).

Each tweak was trialled at n=12 first, then run 84 bouts x 2 seeds (`seed=1`, `seed=2`), saved to `punch_chance_out/{e,f,g}84.txt` and `{e,f,g}84_s2.txt`. Commit + push after every finished run. No page was changed; no test was deleted. Rules test 37 passed, punch-chance test 14 passed (incl. the new free-KD test).

## The bars (same 9 bars as PUNCHCHANCE1, plus the comeback bar)

The bar that fails on the page today and in every version is the same one: the jab / overhand land too often (70%+); not this task's. The stoppages/knockdowns bar is 0.5-2.5 KDs a bout, 10-40% stoppages.

| Version | Bars | Comeback: 4+ behind after round 1 wins (bar 15-30%) | Used when open (bar <= 33%) | Of all beats (bar <= 10%) | Loop: open for both in a round (bar <= 20%) | Lands | Stoppages / knockdowns |
|---|---|---|---|---|---|---|---|
| Page today, no switch (seed 1) | 8 of 9 | 11% (4 of 35) | - | - | - | - | 23% / 2.4 |
| Page today, no switch (seed 2) | 8 of 9 | 9% (5 of 53) | - | - | - | - | 25% / 2.4 |
| A: health under his | 7 of 9 | 16% (7 of 43) | **35%** FAIL | 7% | 16% | 33% | **45%** / **2.6** FAIL |
| B: behind on cards, last round | 8 of 9 | 11% (4 of 35) | 18% | 1% | 0% | 47% | 25% / 2.4 |
| C: health 4+ under his (seed 1) | 7 of 9 | **15%** (6 of 39) | 30% | 3% | 2% | 38% | 25% / **2.6** |
| C (seed 2) | 7 of 9 | **20%** (8 of 40) | 33% | 3% | 1% | 27% | 30% / **2.6** |
| D: C at +3 stamina | 8 of 9 | 9% (3 of 35) | 23% | 2% | 0% | 24% | 23% / 2.3 |
| **E: C at gap 5 (seed 1)** | 7 of 9 | 19% (8 of 42) | 31% | 2% | 0% (1/248) | 38% | **39%** / **2.9** |
| **E (seed 2)** | 7 of 9 | 27% (11 of 41) | 32% | 2% | 0% (0/251) | 37% | 21% / 2.6 |
| E pooled | 7 of 9 | 23% (19 of 83) | 32% | 2% | 0% | 38% | 30% / 2.75 |
| **F: C + free all-in KD (seed 1)** | **8 of 9** | **18%** (8 of 45) | 33% | 3% | 2% (4/252) | 38% | 23% / **2.5** |
| **F (seed 2)** | **8 of 9** | 13% (5 of 40) | 33% | 3% | 1% (2/252) | 25% | 14% / **2.3** |
| F pooled | **8 of 9** | **15% (13 of 85)** | 33% | 3% | 1% | 32% | 19% / 2.4 |
| G: C at gap 5 + free KD (seed 1) | 7 of 9 | 24% (8 of 34) | 34% FAIL | 2% | 1% (2/252) | 40% | 26% / **2.6** |
| G (seed 2) | 8 of 9 | 11% (4 of 38) | 28% | 2% | 0% (0/251) | 38% | 18% / 2.5 |
| G pooled | 7-8 of 9 | 17% (12 of 72) | 31% | 2% | 1% | 39% | 22% / 2.55 |

Pooled comeback (this task's contract): page today **10% (9 of 88)**; C **18% (14 of 79)**; **E 23% (19 of 83)**; **F 15% (13 of 85)**; **G 17% (12 of 72)**.

## What it says

- **E (trigger 5+ behind)**: widening the gap does nothing for the bars. Both seeds still 7/9 — the stoppages/KD bar fails (2.9 then 2.6), because fewer comebacks means the all-in drop that F would have freed is still counted. Comeback is healthy (23% pooled) but it does not clear 8/9. **Rejected.**
- **F (free all-in knockdown, C + pcFree)**: this is the winner. **8 of 9 bars on both seeds** — the only bar still failing is the pre-existing jab/overhand landing bar that fails on the page today too. The KD cost is gone: 2.5 then 2.3 a bout, inside the 2.5 bar (pooled 2.4, the page's own number). Comeback pooled **15% (13 of 85)**, inside 15-30%. Used-when-open stays flat at 33% pooled (s1 33%, s2 33%) — it neither falls (per the F check) nor rises; it is still a rare, chosen switch (3% of beats) and the loop stays shut (1% of rounds). **Holds the contract: 8/9 and pooled 15-30%.**
- **G (gap 5 + free KD)**: the free-KD fix helps, but raising the trigger to 5+ quietly bleeds the comeback on seed 2 (11%) and seed 1 still fails the KD bar at 2.6 (fewer comebacks fired the free rule). 7/9 then 8/9, pooled 17%. **Rejected** — strictly worse than F: same idea, worse trigger.

So the one follow-up that works is the all-in knockdown getting up and not counting toward the stoppage. **No further idea is needed** — the contract is met by F on the first try, so per the task we stop rather than invent a fourth letter.

Page version to ship: **F** — C's Puncher's chance (health 4+ behind, once a round, all-in power punch drops him on double damage) with the `pcFree` rule: an all-in knockdown leaves him on his knockdown health, scores 3, and does **not** count toward the three-knockdown stoppage.

## Next (for the session)
1. Build the page copy (a new page beside `order.html`, like `kick.html` / `head.html`) with the switch beside the clinch, "his puncher's chance is loaded" shown to both men, and his play — using F (C + `pcFree`). No page was touched in this measuring session.
2. Not run here: `balance.mjs play` against the three page opponents (the probe is the mirror only).

PUNCHCHANCE2 DONE
