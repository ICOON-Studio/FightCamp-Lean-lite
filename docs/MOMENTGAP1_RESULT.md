# MOMENTGAP1 — a free moment, measured (S562)

## Decision

put on the page: B

**B means only feet may be delayed**, not arbitrary hand timing. It preserves the owner's example: body jab in moment 1, wait in 2, step in in 3. A, the unrestricted free wait, loses punch variety on both seeds. B preserves the historical page's eight passing bars on both seeds. This is a recommendation only: **no page or shipped value table was edited**.

## Rules tried

- **Page:** every permutation of active slots, packed from moment 1; no wait.
- **A** ([tweak](../ops/research/s558_balance/moment_gap_a.json)): keep every original permutation and optionally insert one `wait` anywhere, if the result has at most three moments. A wait has neither hand out, does not act, and costs nothing. Includes leading, internal and trailing waits, and wait-only plans when no slot acts. Only three source patches: recognize wait as active, name it, enumerate it. Existing resolve and cost already make it a guarded, free empty moment; neither was rewritten.
- **B** ([tweak](../ops/research/s558_balance/moment_gap_b.json)): the ONE follow-up, motivated by A seed 1's dead feint/overhand and two-punch rate of 9%. Insert wait immediately before feet **only when feet is the last active slot**, with at most three moments. Removing wait leaves both hand indices unchanged. Thus `lead>wait>feet` and `wait>feet` are allowed, but `wait>lead` and `wait>feet>lead` are not. Free wait; no price, damage, counter, guard or recovery rule changed. No third variant and no retuning after results.

All rule changes live in each tweak's **src patches only**. Full-stamina plan counts: page 514, A 1010, B 566 (52 delayed-feet copies).

## Method and run order

Node v22.22.3 only; two available cores, **jobs=2**. Each variant got its own freshly rebuilt six-layer table at the tool's default **500 iterations**. Bouts are `balance.mjs play who=mix opp=mirror`, default **400 solver iterations**, 84 bouts per seed, seeds 1 and 2. Each worker plays 42 bouts; tool RNG seeds are 100/101 and 200/201 respectively. No rounded-up sample size. A and B each ran **n=12 first** (6 bouts/worker, seed 1); neither trial is pooled into the 84-bout estimates.

- A table → n=12: **5/9**, wait in **68.57%** of fighter-beats; loaded and chosen. Trial committed/pushed as `01114e1` before full runs.
- A n=84 seed 1: **7/9**, committed/pushed `d3bd043`; then A seed 2: **7/9**, committed/pushed `aa81043`.
- After A seed 1 established the miss, B table and n=12: **6/9**, wait **7.41%**; committed/pushed `6ebd413` before B full runs. B seed 1 **8/9** (`9e35c94`), then seed 2 **8/9** (`88125ce`), each committed/pushed immediately. Independent A/B work overlapped on the same two-core machine; seeds within each variant stayed sequential.
- Fresh unchanged-page controls, n=84 seed 1 then seed 2, use the page's committed `vtable.json` (its N matches the page). Each control was committed/pushed too: `0b4653f` and `e4f2338`.

**Baseline honesty:** prior research reports **8/9** for today's page. With this task's jobs=2 split, the fresh controls are **7/9 at seed 1, 8/9 at seed 2**: push off slips below 3% at seed 1. No seed was rerun or selected to hide that. B passes that bar on both seeds. PASS/FAIL uses the instrument's unrounded values; a displayed 3% or 65% can still fail at the boundary.

## All nine bars, beside today's page

| Bar | Page s1 | Page s2 | A s1 | A s2 | B s1 | B s2 |
|---|---:|---:|---:|---:|---:|---:|
| Every range: each 15–55% | PASS | PASS | PASS | PASS | PASS | PASS |
| No switch must: none >40% | PASS | PASS | PASS | PASS | PASS | PASS |
| No switch dead: each ≥3% | FAIL | PASS | FAIL | FAIL | PASS | PASS |
| Punches: land 30–65%, miss ≤40% | FAIL | FAIL | PASS | PASS | FAIL | FAIL |
| Endings: stops 10–40%, draws ≤20%, KD 0.5–2.5 | PASS | PASS | PASS | PASS | PASS | PASS |
| Punch variety: two 15–45%, none 5–25% | PASS | PASS | FAIL | FAIL | PASS | PASS |
| Clinch rescue: ≤2/bout | PASS | PASS | PASS | PASS | PASS | PASS |
| Order: ≥40% ordered, no first slot >60% | PASS | PASS | PASS | PASS | PASS | PASS |
| Fair mirror: wins 40–60% of decided | PASS | PASS | PASS | PASS | PASS | PASS |
| **Total** | **7/9** | **8/9** | **7/9** | **7/9** | **8/9** | **8/9** |

### Numbers behind the bars (tool rounding retained)

| Version / seed | Ranges I/M/L | Stoppages / draws / KD | Two / none | Clinches/bout | Ordered / most-first | Decided wins |
|---|---|---|---|---|---|---|
| Page s1 | Inside 30%, Mid 37%, Long 33% | stoppages 20%, draws 5%, knockdowns 2.4 | two 16%, none 11% | 1.1 | ordered 69%, most often first 56% | 53% |
| Page s2 | Inside 33%, Mid 35%, Long 32% | stoppages 21%, draws 1%, knockdowns 2.4 | two 17%, none 13% | 1.2 | ordered 68%, most often first 57% | 45% |
| A s1 | Inside 30%, Mid 38%, Long 31% | stoppages 29%, draws 6%, knockdowns 2.5 | two 9%, none 4% | 1.2 | ordered 89%, most often first 39% | 57% |
| A s2 | Inside 29%, Mid 38%, Long 33% | stoppages 13%, draws 6%, knockdowns 2.3 | two 10%, none 4% | 1.5 | ordered 88%, most often first 39% | 49% |
| B s1 | Inside 29%, Mid 34%, Long 37% | stoppages 25%, draws 2%, knockdowns 2.5 | two 16%, none 14% | 1.1 | ordered 72%, most often first 50% | 44% |
| B s2 | Inside 29%, Mid 36%, Long 35% | stoppages 15%, draws 7%, knockdowns 2.0 | two 19%, none 14% | 1.4 | ordered 72%, most often first 53% | 53% |

Switch and punch details:

- **Page s1:** no switch is a must (none in over 40% of beats): **PASS**, back off 35%, step in 32%, Cross 26%. no switch is dead (each in at least 3% of beats): **FAIL**, Push off 3%. every punch lands 30-65% of the time and falls short at most 40%: **FAIL**, Jab lands 70%, short 4%; Overhand lands 74%, short 16%.
- **Page s2:** no switch is a must (none in over 40% of beats): **PASS**, step in 34%, back off 33%, Body cross 24%. no switch is dead (each in at least 3% of beats): **PASS**, none under 3%. every punch lands 30-65% of the time and falls short at most 40%: **FAIL**, Jab lands 66%, short 2%; Overhand lands 71%, short 20%.
- **A s1:** no switch is a must (none in over 40% of beats): **PASS**, step in 37%, back off 36%, Cross 26%. no switch is dead (each in at least 3% of beats): **FAIL**, Feint 3%, Overhand 3%. every punch lands 30-65% of the time and falls short at most 40%: **PASS**, Jab 54%, Body jab 61%, Lead hook 34%, Lead uppercut 63%, Body hook 59%, Cross 43%, Rear uppercut 53%, Body cross 46%.
- **A s2:** no switch is a must (none in over 40% of beats): **PASS**, step in 36%, back off 35%, Cross 25%. no switch is dead (each in at least 3% of beats): **FAIL**, Overhand 3%. every punch lands 30-65% of the time and falls short at most 40%: **PASS**, Jab 62%, Body jab 62%, Lead hook 37%, Lead uppercut 58%, Body hook 57%, Cross 43%, Rear uppercut 54%, Body cross 50%.
- **B s1:** no switch is a must (none in over 40% of beats): **PASS**, back off 37%, step in 33%, Cross 24%. no switch is dead (each in at least 3% of beats): **PASS**, none under 3%. every punch lands 30-65% of the time and falls short at most 40%: **FAIL**, Jab lands 65%, short 1%; Overhand lands 75%, short 19%.
- **B s2:** no switch is a must (none in over 40% of beats): **PASS**, back off 37%, step in 33%, Body cross 24%. no switch is dead (each in at least 3% of beats): **PASS**, none under 3%. every punch lands 30-65% of the time and falls short at most 40%: **FAIL**, Jab lands 68%, short 2%; Overhand lands 69%, short 27%; Rear uppercut lands 48%, short 43%.

A's apparent punch-accuracy improvement is qualified: its overhand falls below **one attempted punch per bout summed over both fighters**, so the existing accuracy bar excludes it. The pass is not evidence that overhand accuracy was fixed. The instrument's zero-punch numerator excludes clinch plans (its denominator is still all beats); it was not redefined here.

## How often, and in which moment?

A **fighter-beat** is one fighter's selected plan, so its denominator is twice the bout-beat count. “Either” and “both” use bout beats. All selected waits are counted, even if a clinch cancels the beat or a knockdown prevents a subsequent punch; these are choices, not only executed actions.

| Version / seed | Bout beats | Wait/fighter-beat | Either fighter waits | Both wait | Wait at moment 1 / 2 / 3 (% fighter-beats) | Wait precedes a later action |
|---|---:|---:|---:|---:|---|---:|
| Page s1 | 1483 | 0.00% | 0.00% | 0.00% | 0.00% / 0.00% / 0.00% | 0.00% |
| Page s2 | 1495 | 0.00% | 0.00% | 0.00% | 0.00% / 0.00% / 0.00% | 0.00% |
| A s1 | 1474 | 67.10% | 87.79% | 46.40% | 35.45% / 19.23% / 12.42% | 49.66% |
| A s2 | 1498 | 65.82% | 86.05% | 45.59% | 35.08% / 17.96% / 12.78% | 47.80% |
| B s1 | 1499 | 8.14% | 15.34% | 0.93% | 5.14% / 3.00% / 0.00% | 8.14% |
| B s2 | 1500 | 7.73% | 14.80% | 0.67% | 5.23% / 2.50% / 0.00% | 7.73% |

A raw wait need not delay anything: a trailing wait (or wait-only plan) is behaviorally redundant. The last column counts only a wait with an active slot after it. Among A's selected waits, moment 1/2/3 shares are **52.83/28.67/18.50%** (s1), **53.30/27.28/19.42%** (s2). B's are **63.11/36.89/0%** and **67.67/32.33/0%**; moment 3 is impossible because feet must follow the wait. Cap remains one wait and three moments.

## Did a single order become a must?

| Version / seed | Most common slot order (both fighters pooled) | Largest share on either individual side | Orders >40% |
|---|---|---:|---|
| Page s1 | `feet>rear` 15.27% | 15.37% | none |
| Page s2 | `feet>rear` 15.15% | 15.72% | none |
| A s1 | `wait>feet>rear` 10.85% | 11.26% | none |
| A s2 | `wait>feet>rear` 10.08% | 10.68% | none |
| B s1 | `feet>rear` 14.64% | 15.01% | none |
| B s2 | `feet>rear` 14.93% | 15.13% | none |

Slot orders group all punch identities, foot directions and guard heights. No grouped order exceeds 40%, even on either side separately; therefore no more-specific complete plan/order can exceed 40% either. This is distinct from the instrument's existing “first slot >60% of ordered beats” bar, which also passes for A and B on both seeds.

## Counter → health gap → waiting feedback

“Counter” counts landed events whose existing text says “as a counter” (+N.counter); a pull-only +1 is not counted as that counter. “Beaten to the punch” counts cancelled attacks, not misses.

| Version / seed | Counters/bout (both men) | Beaten-to-punch cancellations/bout |
|---|---:|---:|
| Page s1 | 2.54 | 0.49 |
| Page s2 | 2.60 | 0.51 |
| A s1 | 2.93 | 0.87 |
| A s2 | 3.11 | 0.85 |
| B s1 | 2.64 | 0.69 |
| B s2 | 2.79 | 0.64 |

A raises counters from the controls' **2.54/2.60** to **2.93/3.11** per bout, and cancellations from **0.49/0.51** to **0.87/0.85**. B is much closer: **2.64/2.79** counters and **0.69/0.64** cancellations. A's waiting is prevalent, but does the health gap then make it grow?

Conditional share of fighter-beats choosing a wait (raw count/choices in parentheses):

| Version / seed | Behind by ≥4 HP | Within 3 HP | Ahead by ≥4 HP | After own counter last beat | No own counter last beat |
|---|---:|---:|---:|---:|---:|
| A s1 | 67.18% (395/588) | 68.34% (1211/1772) | 63.27% (372/588) | 61.49% (107/174) | 67.45% (1871/2774) |
| A s2 | 64.66% (300/464) | 67.21% (1390/2068) | 60.78% (282/464) | 55.96% (108/193) | 66.50% (1864/2803) |
| B s1 | 10.77% (49/455) | 7.66% (160/2088) | 7.69% (35/455) | 5.96% (9/151) | 8.25% (235/2847) |
| B s2 | 7.04% (33/469) | 7.90% (163/2062) | 7.68% (36/469) | 4.61% (7/152) | 7.90% (225/2848) |

No consistent self-reinforcing health-gap signal appears in these two seeds: A waits **less** when ≥4 ahead than near level, and less after its own counter on the previous beat; B's behind-on-health increase at seed 1 does not repeat at seed 2. B also waits less after a counter on both seeds. Previous-counter tracking resets at round/bout boundaries; first beats are in “no counter last beat.” These are associations, **not a causal loop proof**: health gaps and round position are endogenous, samples after counters are small, and the table has no health-gap dimension. The practical failure of A is already clear without claiming runaway feedback: its timing options crowd two-punch and zero-punch choices out. B keeps waiting occasional (~8% of fighter-beats, ~15% of bout beats), with no new failed bar on either seed.

## Artifacts and reproduction

Raw commands, default reports, nine bars and exact `MOMENTGAP_METRICS` JSON counts:

- [A seed 1 + n=12 + table log + full measurement loader + page control s1](../ops/research/s558_balance/results/moment_gap_a.txt)
- [A seed 2 + page control s2](../ops/research/s558_balance/results/moment_gap_a_s2.txt)
- [B seed 1 + n=12 + table log](../ops/research/s558_balance/results/moment_gap_b.txt)
- [B seed 2](../ops/research/s558_balance/results/moment_gap_b_s2.txt)

The measurement-only Node import hook is embedded verbatim in A's first result file. It instruments the private bout loop in `balance.mjs` in memory to count orders, wait positions, counters, cancellations, and pre-beat health-gap/previous-counter bins. It does **not** patch page rules, selection, iteration counts, RNG calls, judging or bars. Original instrument files are untouched. Tables and transient harnesses are scratch artifacts, not Git payloads. To restore the loader and reproduce (all commands from repo root):

```sh
node --input-type=module -e 'import fs from "node:fs"; fs.mkdirSync(".cache/momentgap1",{recursive:true}); const t=fs.readFileSync("ops/research/s558_balance/results/moment_gap_a.txt","utf8"); fs.writeFileSync(".cache/momentgap1/measure.mjs",t.split("Measurement-only loader (no rule changes):\n")[1].split("\nCOMMAND:")[0]);'
node proto/twohands/tools/balance.mjs table tweak=ops/research/s558_balance/moment_gap_a.json out=.cache/momentgap1/a-table.json jobs=2
node --import ./.cache/momentgap1/measure.mjs proto/twohands/tools/balance.mjs play tweak=ops/research/s558_balance/moment_gap_a.json table=.cache/momentgap1/a-table.json n=12 seed=1 jobs=2
node --import ./.cache/momentgap1/measure.mjs proto/twohands/tools/balance.mjs play tweak=ops/research/s558_balance/moment_gap_a.json table=.cache/momentgap1/a-table.json n=84 seed=1 jobs=2
node --import ./.cache/momentgap1/measure.mjs proto/twohands/tools/balance.mjs play tweak=ops/research/s558_balance/moment_gap_a.json table=.cache/momentgap1/a-table.json n=84 seed=2 jobs=2
```

For B substitute `moment_gap_b.json` and `b-table.json` throughout, including its own table and n=12 first. For the page controls omit tweak/table arguments, n=84 with seed 1 then 2. All runs default to mix/mirror.

SHA256 fingerprints:

| File | SHA256 |
|---|---|
| Unchanged order.html | `166bec887777789d2ffc78ecc50aed40c987e9543beac0fc5f5a4982b533f442` |
| Page vtable.json | `b239e19715a712ca210f76fb6c416ada45256b5c6344db813e12424167f7215a` |
| Rebuilt A table | `056acc0f086d1f2aee476f5b84cfd43db45ad9a96bbdafabad0bb2f09ffe6ddc` |
| Rebuilt B table | `b2808cc80af5991ed1c9d93a4fcebaf7176b017029e43aeb9ed5f26fe987ad60` |

## Verification and limits

- `node proto/twohands/tools/rules_test.mjs` → **RULES_TEST 37 passed**, before measurement and again after full variant runs.
- Node assertions: all A/B generated plans obey the one-wait/three-moment cap; ordOf preserves each generated order; cost is unchanged by wait; planWords accepts it. A's wait keeps both hands home and costs no health/stamina; a delayed step resolves in moment 3. B's wait always immediately precedes final feet and never moves either hand's moment.
- Final Node audit: **34,128 generated plans** checked across stamina 0–8, ropes 0–2, and kept 0/1. Every original no-wait plan remains identical; affordability, naming, order preservation and caps hold, with B hand moments unchanged. All **8 metric blocks** reconcile orders to beats, positions to wait counts, and health/counter bins to fighter-beats. Embedded-loader extraction matches the source used for all runs.
- No page changed, no test deleted or modified, no instrument or shipped table changed. Only the two owned tweaks, four result texts, and this report belong in the patch.
- Mirror/solved-mix probe only, not visual or human playtesting and not the three styled opponents. B's 8/9 is preservation of the baseline bars, **not** a claim of 9/9 balance: jab/overhand accuracy remains a known failure, and B seed 2 rear-uppercut misses also cross that same accuracy bar. No page was built as part of this measurement.

MOMENTGAP1 DONE
