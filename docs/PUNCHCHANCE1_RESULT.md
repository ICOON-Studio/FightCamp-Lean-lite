# PUNCHCHANCE1 - the Puncher's chance, measured (S560 console worker)

Owner S559: "can you add a jumpswitch on the board for the card game . We will name it "Puncher's chance" for now".
No page was changed. Everything is tweak files on order.html (with the S560 pull counter on it) and one new probe.

## The rule as built (tweak files)
- A switch beside the clinch, open only to the man behind, **once a round**. Never open in the round a puncher's chance dropped him (the loop cap).
- On: the first power punch he throws that beat (lead hook, lead uppercut, cross, overhand, rear uppercut) is all in: **double damage, and if it lands he goes down** whatever his health.
- Price: **+2 stamina**; if that punch is blocked or falls short, he is **wide open**: the other man's punches for the rest of the beat land through his guard and count as counters (+1). Beaten to the punch = the switch is spent, not wide open.
- The look-ahead sees it: `plansFor` adds an all-in copy of every plan with a power punch when the switch is open and paid for, so `solveBeat` and the opponents choose it like any plan.

Files: `ops/research/s558_balance/punch_chance_a.json` (open when his health is under the other's), `_b` (behind on the cards, last round only), `_c` (health 4+ under), `_d` (C at +3 stamina).
Rule test: `node proto/twohands/tools/punch_chance_test.mjs` -> PUNCH_CHANCE_TEST 13 passed.
Probe: `node proto/twohands/tools/probe_punch_chance.mjs [tweak=<f>] n=84 [seed=2]` - the same bout loop as `balance.mjs play who=mix opp=mirror` (the solved mix against itself), plus each bout written down; prints the 9 bars and the comeback bars. Outputs in `ops/research/s558_balance/punch_chance_out/`.

**The value table was not rebuilt, on purpose:** the table's states are two men at the same health in round 1, where every trigger is closed (tested: "the value table states never see it"), so `balance.mjs table` with these tweaks gives the page's own table. The table does not know about health, so it cannot value "keeping the switch for later"; the switch is chosen beat by beat.

## Results (84 bouts each, the solved mix against itself)

| Version | Bars | Comeback: 4+ behind after round 1 wins (bar 15-30%) | Used when open (bar <= 33%) | Of all beats (bar <= 10%) | Loop: open for both in a round (bar <= 20%) | Lands | Stoppages / knockdowns |
|---|---|---|---|---|---|---|---|
| Page today, no switch (seed 1) | 8 of 9 | 11% (4 of 35) | - | - | - | - | 23% / 2.4 |
| Page today, no switch (seed 2) | 8 of 9 | 9% (5 of 53) | - | - | - | - | 25% / 2.4 |
| A: health under his (63-bout trial) | 7 of 9 | 16% (7 of 43) | **35%** FAIL | 7% | 16% (trial passed) | 33% | **45%** / **2.6** FAIL |
| B: behind on cards, last round | 8 of 9 | 11% (4 of 35) - no change | 18% | 1% | 0% | 47% | 25% / 2.4 |
| **C: health 4+ under his (seed 1)** | 7 of 9 | **15%** (6 of 39) | 30% | 3% | 2% | 38% | 25% / **2.6** |
| **C (seed 2)** | 7 of 9 | **20%** (8 of 40) | 33% | 3% | 1% | 27% | 30% / **2.6** |
| D: C at +3 stamina | 8 of 9 | 9% (3 of 35) | 23% | 2% | 0% | 24% | 23% / 2.3 |

Pooled: the page today **10% (9 of 88)**; C **18% (14 of 79)**. The RED number (comeback without the switch) is 10%: under the bar.
The bar that fails on the page today and in every version is the same one: the jab / overhand land too often (70%+); not this task's.

## What it says
- **A (any health gap) is too strong and too common**: open most beats, used in 35% of them, stoppages 45%. Rejected.
- **B (the cards) does nothing**: it only opens in round 3, used 0.4 a bout, the comeback number is the page's own. Rejected as the trigger (it could later be an extra way in, not the only one).
- **C (4+ health behind) is the candidate**: it lifts the comeback from 10% to 18% (into the 15-30% bar), is a choice (30-33% of open beats, at the bar's edge), rare (3% of beats), and the loop stays shut (1-2% of rounds). Its one cost: knockdowns 2.6 a bout against a bar of 2.5 (the page has 2.4), so it shows 7 of 9 bars, not 8.
- **D (+3 stamina)** keeps the bars at 8 but kills the comeback (9%) - the price is too high; it lands 24%.
- The samples are small (35-53 bouts with a 4+ gap per run), so each comeback number is about +-6 points; C's lift was seen on both seeds.

## Next (for the session)
1. One more tweak on C to bring knockdowns under 2.5 without losing the comeback - try, in this order: the all-in knockdown leaves him on his knockdown health but does NOT count toward the three-knockdown stoppage; or the trigger at 5+ health. 84 bouts x 2 seeds each (~15 min a pair at jobs 3).
2. When one holds 8 of 9 and the comeback 15-30%: a page copy (like kick.html / head.html) with the switch beside the clinch, "his puncher's chance is loaded" shown to both men, and his play.
3. Not run here: `balance.mjs play` against the three page opponents (the probe is the mirror only); the PC went AMBER with his game open (RAM 90%), so further runs were stopped.

Regression: rules_test 37 passed, page_play_test 4 passed (no page touched).

PUNCHCHANCE1 DONE
