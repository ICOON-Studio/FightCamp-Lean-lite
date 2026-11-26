# PROGP4_RESULT — each punch's own Sharp pair, measured (S566)

**Result: no new pair clears the required two-seed bar.** Body jab looked like a choice on seed 1 and failed on seed 2.
Lead uppercut's borderline result did not settle. Cross reaching Long is decisively too strong, even after rebuilding
its look-ahead. Body hook damage is **table-sensitive**, not a settled 68% advantage. Keep the task's already-settled
Overhand pair; do not ship another permanent choice from this probe.

## Method and order

Read `PROGP2_RESULT.md` first, then the whole `TASK_PROGP4.md`; worked on the supplied Arena branch based on `main`.
No page, `rules.mjs`, or `balance.mjs` edit. `probe_sharp.mjs` now gives each man his own punch stamina costs, speed,
**damage, reach and jab keep** through eleven guarded source replacements. Resolve's shot carries its owner's action, so reach,
health damage, guard damage, points, stun and body-cap effects all read that action. Cost checks and speed grouping
remain per man. Every replacement throws when its source text is absent.

Two necessary corrections to the proposed cards:
- **Both jabs already reach Long**, `[2,3]`. Those upgrades are refused as no-ops. The nearest other reach card measured
  here is **reaches Inside**, `[1,2,3]`, for each jab; no third effect family was invented.
- Today's jab has no active keep (`N.keep=0`, and no `ACT.jab.keep`). **+1 keep means 0 → 1 beat**, not 1 → 2.
  Only the upgraded man's landed jab keeps the opponent from stepping in on the following beat; it then expires.

Order followed: new tests red first; implement and pass old/new tests and regressions; Body cross trials; full seed-1
cards; qualifying seed-2 pairs; the requested Lead uppercut seed-2 repeat; the two largest-effect table rebuilds and
reruns; finally an equal/no-upgrade control for the stamina comparison and final regressions. **One run at a time,
`jobs=2`; each completed result file was committed and pushed before starting the next.**

All full bouts use the solved mix on both sides, `iters=400`, `n=84`; seed 1 uses workers 100/101, seed 2 uses 200/201,
42 bouts each. A has one card; B has no upgrade. Cross Long versus **no upgrade** is explicitly included, not merely
Cross Long versus cheaper. Lead uppercut seed 1 is inherited from PROGP2, as requested; only seed 2 was rerun. Overhand
was not run. The added equal/no-upgrade control uses the same seed-1 settings.

**Trials first:** Body cross faster won **11/24 = 45.83%**, damage **13/23 decided = 56.52%** (one draw), at `n=24`.
Neither exceeded the 75% stop line. Stoppages were 8/24 and 6/24 respectively; both cards proceeded.

Bars are applied to **unrounded counts**: IN = 52–58% of decided bouts; gap ≤6 percentage points; both seeds must pass.
Stoppages must be 10–40%; reach cards fail if Long exceeds 45% of beats. A use ratio **strictly over 2×** is flagged
regardless of wins. A sample this size has roughly an 11-point 95% win-share margin near 50%; narrow boundary failures
are operational bar failures, not proof that a move is intrinsically bad. The equal/no-upgrade control itself won
**42/80 = 52.50%**: a single IN result is not proof of an upgrade edge. Do not average seeds to rescue a failed pair.

## The table

Wins are A's share of **decided** bouts, followed by wins/decided. Use is the punch's **A / B share of all beats**,
counting selected plans containing it, even if resolution later prevents the throw; it is not a hit rate.
**† = bends the fight, >2× use**. Gap is in percentage points. Columns a/b use the stock, equal-baseline look-ahead.
Lead uppercut's inherited use is only available rounded to whole percentages; all other use below is shown to one decimal.

| punch | card a: A wins; use A / B | card b: A wins; use A / B | gap, seed 1 | seed 2: a / b | verdict |
|---|---|---|---|---|---|
| Jab | +1 keep: **60.00%** (48/80); 10.5 / 7.9% | reaches Inside instead of already-owned Long: **44.87%** (35/78); 9.5 / 6.9% | 15.13 | Not eligible | **Too strong / one card dead**; keep always wins the comparison, but is not an acceptable card |
| Body jab | +1 damage: **52.50%** (42/80); **27.7 / 13.4%†** | reaches Inside instead of already-owned Long: **53.66%** (44/82); 22.0 / 17.8% | 1.16 | a **50.00%** (42/84), use 27.5 / 14.7%; b **40.96%** (34/83), use 20.7 / 17.8%; gap 9.04 | **One card dead (both on seed 2)**; not a two-seed choice |
| Lead hook | +1 damage, 3→4: **53.75%** (43/80); 7.1 / 7.9% | reaches Long: **40.24%** (33/82); 8.3 / 5.9% | 13.51 | Not eligible | **One card dead**; damage is always the pick of these two |
| Body hook | cheaper: **54.32%** (44/81); **15.0 / 3.7%†** | +1 damage, 2→3: **67.90%** (55/81); **15.0 / 2.4%†** | 13.58 | Not eligible | **Too strong** on stock table; damage falls to **50.62%** with rebuilt table, so its advantage is not robust |
| Cross | cheaper: **61.73%** (50/81); 39.0 / 24.5% | reaches Long: **71.43%** (60/84); 35.6 / 21.7% | 9.70 | Not eligible | **Too strong**, both; Long also fails stoppages |
| Rear uppercut | faster: **51.85%** (42/81); 8.0 / 5.4% | reaches Mid: **51.81%** (43/83); **21.3 / 4.9%†** | 0.04 | Not eligible | **Both cards dead by the strict bar**, each just below its floor |
| Body cross | faster: **58.33%** (49/84); 23.9 / 25.1% | +1 damage, 2→3: **65.85%** (54/82); 36.7 / 28.5% | 7.52 | Not eligible | **Too strong**, both; damage always wins the comparison |
| Lead uppercut | cheaper: **59.49%** (47/79, PROGP2); **14 / 6%†** | faster: **53.16%** (42/79, PROGP2); **10 / 4%†** | 6.33 | a **56.96%** (45/79), use 13.4 / 7.1%; b **58.75%** (47/80), use 10.2 / 5.2%; gap 1.79 | **Too strong on each seed, but a different card**; not a confirmed choice |

PROGP2's rounded Rear uppercut “52%” is actually 51.85%; Body cross “58%” is 58.33%; Lead uppercut's rounded gap “6” is
6.33. These have not been silently rounded into this probe's bars. Body jab was the only seed-1 pair eligible for an
automatic seed-2 run. Lead uppercut's cheaper 59% does fall back inside on seed 2, consistent with sampling noise, but
its faster card then sits above the ceiling. The permanent choice is still unconfirmed.

## Feedback loops and limits

### More use is measured; more wins does not necessarily follow

- Body jab damage: **2.071×** use on seed 1 (flagged despite its IN win share), **1.870×** on seed 2.
- Body hook cheaper: **4.036×**; damage: **6.286×** stock, **5.605×** rebuilt. All flagged, including cheaper at 54.32%.
  The rebuilt damage card still gets used much more, yet wins only 50.62%: use is not the same thing as advantage.
- Rear uppercut reaching Mid: **4.315×**, yet 51.81% wins. It bends use without clearing the win floor.
- Both inherited Lead uppercut seed-1 uses exceed 2× even allowing for rounding (14/6 and 10/4). Seed 2 does not:
  cheaper **1.896×**, faster **1.962×**.
- Every other P4 card/run is ≤2×. Lead hook damage actually reduces use (0.897×); Body cross faster does not increase
  it (0.954×). Cross Long is too strong at only 1.643× use (1.658× rebuilt): the 58% cap still matters independently.

The career links “wins → more mastery → more use” are not simulated. These are fixed-card bouts, not mastery farming.
The design still needs its per-bout mastery cap as well as the 58% and 2× checks.

### Body damage, the stamina bar, and the floor

These are **capacity (`cap`)**, not remaining stamina (`st`). At the final bell of completed bouts, mean **A / B** bars:
- **No upgrade on either man:** **5.97 / 6.24**, 67 completed bouts.
- **Body hook +1 damage:** **5.80 / 5.64**, 61 completed bouts; with rebuilt look-ahead **5.63 / 5.65**, 60 completed.
- **Body cross +1 damage:** **5.57 / 5.16**, 61 completed bouts.

Including stoppages instead, mean bars at each bout's endpoint are respectively **5.98 / 6.12** (control),
**5.71 / 5.57** (Body hook stock), **5.42 / 5.65** (Body hook rebuilt), and **5.67 / 5.04** (Body cross).
B is the unupgraded recipient of A's stronger body punch. His last-bell bar is lower than control, especially against
Body cross. These are aggregate comparisons with different surviving bouts, not an isolated causal estimate.
B's planned punches per beat barely fall: **1.003** in control, **0.999** against Body hook damage, **0.987** rebuilt,
**0.986** against Body cross damage. Do not claim a large “he throws less” cascade from these numbers.

Important rule detail: **+1 damage does not remove another stamina-cap point per hit.** `a.body` still removes exactly
one, clamped by **`N.capMin=4`**. The upgrade can affect capacity indirectly through changed use and landing patterns.
The 2→3 damage step also crosses the existing two-point, stun and guard-damage thresholds; it is not merely one extra
health point. Body hook lands 1.23 times/bout versus B's 0.23 (rebuilt 1.25 / 0.29); Body cross 3.10 / 2.17.
**Body jab has no `body` cap-drain flag**, even after +1 damage; it must not be described as shortening the stamina bar.

### Reach, Long beats and draws — every reach card

Range share is measured at the **end of each resolved beat**, as in the original probe, not across individual moments.
- Jab reaches Inside: **34.57% Long**, **6/84 draws (7.14%)**.
- Body jab reaches Inside: seed 1 **35.15% Long**, **2/84 draws (2.38%)**; seed 2 **33.83% Long**, **1/84 (1.19%)**.
- Lead hook reaches Long: **33.02% Long**, **2/84 draws (2.38%)**.
- Cross reaches Long: **26.66% Long**, **0/84 draws**; rebuilt **27.53% Long**, **2/84 (2.38%)**.
- Rear uppercut reaches Mid: **33.06% Long**, **1/84 draws (1.19%)**.

**No reach card fails the >45% Long rule.** Reach did not create the hypothesised Long/draw lock here. Cross Long
instead enables damaging exchanges: its Long share is below the no-upgrade control's **32.91%** and its stoppages soar.

### Stoppages — every run checked

Cross Long fails: **51/84 = 60.71%** stock and **52/84 = 61.90%** rebuilt. Every other P4 bout run, including trials,
seed 2, rebuilt Body hook and the no-upgrade control, is inside **10–40%** (observed range **19.05–33.33%**).
The inherited PROGP2 Lead uppercut runs are also inside (17% / 14% rounded). No other stoppage failure is hidden.

### The look-ahead approximation, checked rather than assumed

The default **`vtable.json` was built for equal, unupgraded men**, and is an approximation for unequal men. It does not
index either man's punch table, and does not add independent cap/keep dimensions when rebuilt. The two sensitivity
cards were selected by the largest **absolute departure from 50% decided wins on seed 1**: Cross Long and Body hook
damage. For each, the unchanged `balance.mjs` builder used the same guarded patch and that card on **BOTH men**, all
six layers, `iters=400`, `jobs=2`. The rerun still has the card on A only, stock B, `n=84 seed=1`.

- **Cross Long:** **60/84 = 71.43% → 59/82 = 71.95%** (+0.52 points). Use **35.6 / 21.7% → 36.0 / 21.7%**.
  Its excessive win share and stoppage failure hold under this check.
- **Body hook damage:** **55/81 = 67.90% → 41/81 = 50.62%** (−17.28 points). Use **15.0 / 2.4% → 16.3 / 2.9%**.
  Its large win edge **does not hold**, although the >2× use flag does. Do not certify it as either intrinsically
  overpowered or balanced from the stock table. Resolve this sensitivity before final tuning.

An equal-upgraded table is still not an exact unequal-men solution. These checks cannot establish a “true” win rate;
they show Cross's rejection is stable here and Body hook's rating is not. No seed-2 choice was manufactured by mixing
stock-table and rebuilt-table card results.

## For the player, and the next pairs to try

**The pair to retain, by the task's settled Overhand exception:** “**Takes 2 stamina instead of 3**” OR “**Lands at medium
speed instead of slow**.” PROGP2 measured 57% / 55%; P4 did not rerun it or claim a new two-seed confirmation.
**None of the eight new/retested pairs above holds**, so none is offered as a newly approved permanent choice.

Next candidates, **unmeasured proposals, not implemented or approved**. They stay within cost, speed, damage, reach,
and keep; a once-per-round limit means a smaller dose of the same effect, not a new effect family. New keep carriers
and per-round limits would need their own follow-up implementation and tests; this probe's keep remains jab-only.

- **Jab:** “the first jab you land each round keeps him out for one beat” versus “the first jab you land each round
  deals +1 damage.” Reduce the unconditional keep edge; Inside reach was dead.
- **Body jab:** “+1 damage” versus “the first body jab you land each round keeps him out for one beat.” Replace the
  unstable Inside card; recheck damage on both seeds and watch its >2× use, rather than treating seed 1 as approval.
- **Lead hook:** “+1 damage” versus “the first hook you land each round keeps him out for one beat.” A check-hook
  control card is the next keep-family candidate; neither the measured cheap nor Long card supplied a viable partner.
- **Body hook:** “the first Body hook you throw each round costs one less” versus “the first Body hook you land each
  round deals +1 damage.” Both current cards bend use; **first resolve the table sensitivity**, then measure these
  bounded doses. Do not tune only against the stock-table 68% number.
- **Cross:** “the first Cross each round costs one less” versus “the first Cross each round reaches Long.” Both full
  doses overshoot; limit the frequency before trying either as a permanent upgrade.
- **Rear uppercut:** “faster” versus “+1 damage (4→5).” Mid reach raised use fourfold without an acceptable edge;
  damage supplies a different partner. Faster is only 0.15 points below the floor, but still needs confirmation.
- **Body cross:** “the first Body cross each round is faster” versus “the first Body cross you land each round deals
  +1 damage.” Both full doses overshoot, with a 7.52-point gap; try bounded doses, not the already-rejected cheap card.
- **Lead uppercut:** “the first Lead uppercut each round costs one less” versus “the first Lead uppercut each round is
  faster.” Both full cards cross the ceiling on one seed; reduce frequency and require both seeds again.

## Files, reproducibility and tests

All 25 new raw/log files are in `ops/research/s558_balance/results/sharp4_*.txt`: two `*_onerep` trials, fourteen stock
seed-1 card runs, four seed-2 runs (Body jab and Lead uppercut), two `*_rebuild` logs, two `*_s1_rebuilt` reruns, and
`sharp4_baseline_s1.txt`. **23 bout runs, 1,812 bouts**, excluding the inherited PROGP2 runs and unit tests.
Each bout result contains its command, seed/table manifest, human report and exact `RAW_JSON` counts. The inherited
Lead uppercut sources are `sharp_lup_cheaper.txt` / `sharp_lup_faster.txt`; their original files were not edited.

Example reproduction (the table files are local scratch only):
```sh
node proto/twohands/tools/probe_sharp.mjs a=hook:long n=84 jobs=2 seed=1
mkdir -p .cache/progp4
node proto/twohands/tools/probe_sharp.mjs rebuild=lbody:damage out=.cache/progp4/lbody_damage.vt.json jobs=2
node proto/twohands/tools/probe_sharp.mjs a=lbody:damage table=.cache/progp4/lbody_damage.vt.json n=84 jobs=2 seed=1
```

Tests ran before measurements and again after the last run:
- **RED first:** the new damage, reach and keep tests each failed with `unknown upgrade`; the original five passed.
- **`PROBE_SHARP_TEST 8 passed`**: all five old tests unchanged, plus a resolving hit's per-man damage (including the
  3-damage threshold and body-cap behaviour), per-man reach with the two already-Long refusals, and jab keep's duration,
  plan legality, expiry and unupgraded fallback.
- **`RULES_TEST 37 passed`**, **`PAGE_PLAY_TEST 4 passed`**.
- Equal tables still replay `balance.mjs` mirror bout for bout with the same seed. No test deleted or loosened.

Only the two owned tools, `sharp4_*.txt`, and this report changed. No page/rules/balance changes, no images or Godot,
no committed `*.vt.json` or new `vt.json`; generated tables and orchestration scratch stay out of Git. All runs finished;
research completion does not imply approval to ship the failed choices.

PROGP4 DONE
