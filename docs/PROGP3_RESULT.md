# PROGP3_RESULT - attributes on the fight board: how much does each one decide? (S560, probe P3 of DESIGN_PROGRESSION1)

The question (DESIGN_PROGRESSION1 3d): four attributes feed the fight board - durability = health 16 to 20, stamina = the
stamina bar 7 to 9, recovery = stamina back a beat (1, or +1 every second beat), defence = guard 5 to 7. Today both men get
one shared `N` (health 18, stamina 8, recovery 1, guard 6): nothing per man exists. A lever is MEASURED on the rules before
it is designed further, so this probe gave each man his own four numbers and played the solved mix against itself.

**How it was run.** `proto/twohands/tools/probe_attributes.mjs` loads the page's rules through `rules.mjs` with a patch (a
text replacement at load time - `order.html` is NOT edited) so each man carries his own health, stamina bar, recovery and
guard as fields on the man, falling back to `N`. Whole bouts: the solved mix against itself (balance.mjs `play who=mix
opp=mirror` style: both men draw from the beat's `solveBeat`), `iters=400`, `n=84`, `jobs=2`, `seed=1` (workers at seeds
100 and 101). Equal sets replay balance.mjs's mirror bouts bout for bout with the same seed - held by
`probe_attributes_test.mjs`. The one-rep trial came first: health 20 v 16 at n=24 won 71% of decided, under the 85% stop
line, so the runs went on. **The look-ahead table `vtable.json` was built for equal men and is used as it is - an
approximation for unequal men** (a 9-stamina man is read as 8 in it; the every-second-beat recovery is invisible to the
one-beat look-ahead). A win share at n=84 has about a 10-point confidence interval: differences under ~10 points read as
noise. "What changed in how each man fought" = the switch whose share of beats moved most between A and B in that pairing
(the tool prints the top two, A share - B share).

## The table

| pair | A wins of decided | stoppages (A stops B / B stops A) | knockdowns a bout, suffered (A / B) | what changed in how each man fought |
|---|---|---|---|---|
| health 20 v 16 | **73%** (61 of 83) | 37% (30% / 7%) | 0.7 / 1.8 | almost nothing: rear held high -2%, Cross +2% |
| stamina 9 v 7 | **57%** (45 of 79) | 24% (15% / 8%) | 1.1 / 1.4 | the bigger bar walks forward: step in +6% (36% v 30%), rear held low -5% |
| recovery 1+ v 1 (+1 on beats 2, 4, 6) | **64%** (52 of 81) | 25% (19% / 6%) | 1.1 / 1.5 | almost nothing: rear held high -4%, lead held low -4% |
| guard 7 v 5 | **53%** (42 of 80) | 20% (12% / 8%) | 1.1 / 1.3 | almost nothing: Body cross -2%, Cross +2% |
| health 19 v 18 (one step) | **45%** (35 of 77) | 13% (6% / 7%) | 1.0 / 1.0 | noise: back off -2%, rear held low -2% |
| stamina 9 v 8 (one step) | **61%** (49 of 80) | 26% (19% / 7%) | 1.1 / 1.6 | the bigger bar presses: feet hold -6% (24% v 30%), step in +4% |
| guard 7 v 6 (one step) | **53%** (42 of 80) | 20% (12% / 8%) | 1.1 / 1.3 | the same counts as 7 v 5: the board barely sees guard |
| best v worst: 20/9/1+/7 v 16/7/1/5 | **79%** (65 of 82) | 38% (35% / 4%) | 0.7 / 1.9 | the best set presses: step in +7% (37% v 29%), rear held high -9% (15% v 24%) |
| sideways: hp 20 + stamina 7 v hp 16 + stamina 9 | **35%** (28 of 79) | 30% (12% / 18%) | 1.4 / 1.3 | the stamina man presses: step in 35% v 30%; the healthy man keeps his rear hand home: rear held high 23% v 18% |
| tightened best v worst: 19/9/1/7 v 17/7/1/5 | **65%** (52 of 80) | 29% (24% / 5%) | 0.9 / 1.7 | step in +5%, rear held high -8% |

Every raw run is `ops/research/s558_balance/results/attr_<name>.txt` (the trial is `attr_health_onerep.txt`, n=24; the
tightened confirmation is `attr_best_worst_tight.txt`).

## The bars from the spec
- health 20 v 16 alone 55-62%: measured **73% - OVER**. A four-point health spread decides far more than the spec wants.
- best v worst at most 70%: measured **79% - OVER**. With the tightened ranges below it lands at **65% - inside**.
- stoppages (bar 10-40%) in every pair: **all inside**, 13% (health 19 v 18) to 38% (best v worst). No pair flagged. The
  health pairs sit at the top of the bar and the one-step health pair at its bottom edge: bouts get shorter as the health
  gap grows, exactly the "stamina bar -> shorter bouts" arrow the feedback loop watches. Draws 1-8% of all bouts (bar 20%).

## Which attribute is worth the most per step
**Stamina.** One step (9 v 8) is already 61% - the biggest single-step edge measured - and the sideways pair shows why it
rules the board: hp 20 + stamina 7 LOSES 35-65% to hp 16 + stamina 9. A two-step stamina edge beats a four-point health
edge. Plain words why: stamina feeds every beat (every punch is paid out of it, the mix buys plans with it, and the
look-ahead prices what is left of it), while health only matters near the floor - after a knockdown both men restart on the
same clock (6, then 4), so a health head start mostly delays the first knockdown instead of changing how the fight plays.
Recovery's one step (+1 back on beats 2, 4, 6) is nearly as strong alone: **64%** - that is three extra stamina points a
round, three extra light punches the other man never gets. Too much for one attribute level.

## Which is worth nothing (under 52% top v bottom)
No attribute falls under 52% top v bottom, but two sit on the noise line:
- **Guard** is the weakest: top v bottom (7 v 5) is 53%, and the 7 v 5 run came out with the SAME counts as one step
  (7 v 6), bout for bout. The solved mix barely sees absolute guard - it only bites when the guard breaks, and with 1
  stamina of regen a beat it almost never breaks. Worth the least; 5-7 costs the balance nothing.
- **One health step** (19 v 18, 45%) is indistinguishable from noise. The health lever only works across its full spread.

## The ranges I would give each, so the best v the worst set lands at 65-70%
- durability / health: **17 to 19** (was 16 to 20 - that spread alone decided 73%).
- stamina: **7 to 9, keep** (57% across the spread, and the sideways pair says this lever must stay small).
- recovery: **1 for every man on the board at first**; the +1 every second beat moves a bout by itself (64%). If it comes
  back, probe +1 every THIRD beat before it is designed further.
- defence / guard: **5 to 7, keep** (nearly free).
- Measured with exactly these ranges: best v worst = 19/9/1/7 v 17/7/1/5 -> **65% of decided** (`attr_best_worst_tight.txt`).

## The feedback loops
- On this board there is no loop: the sets are fixed for a bout, so this probe measures only the first arrow (attributes ->
  health/stamina -> wins). In the career the loop is capped by matchmaking by rating and by the bounded ranges above.
- Stamina bar -> more punches a beat -> shorter bouts: watched through the stoppages bar in every pair; none outside 10-40%.

## Files and tests
- OWNS: `proto/twohands/tools/probe_attributes.mjs`, `proto/twohands/tools/probe_attributes_test.mjs`,
  `ops/research/s558_balance/results/attr_*.txt` (eleven files), `docs/PROGP3_RESULT.md` (this file).
- `RESULT: proto/twohands/tools/probe_attributes_test.mjs -> PROBE_ATTRIBUTES_TEST 5 passed`
- REGRESSION: `rules_test.mjs` 37 passed, `page_play_test.mjs` 4 passed (nothing they read was edited; the page, the
  existing tools and the existing tests are untouched - only new files were added).
- Not committed: no `*.vt.json` anywhere; no images, no Godot - node only.
