# Q121 - What cage size does to the fight

## Population

MMA grappler (grapple 82, tech 60) vs striker (grapple 34, tech 72). Both legal for
MMA, both keep every fundamental. Differentiated by style and stats, never by
removing techniques. Same two men at every cage size. 64 bouts per size, 3x5 min
rounds. Catalogue: technique_catalog.json (LIVE, 272 nodes, 15 disciplines).

## Control arm (half_width 3.0, two independent seed bases)

| | fence | corner | td/min | str/rd | sep |
|---|---|---|---|---|---|
| Seed A | 2.80% | 3.30% | 0.07 | 33.3 | 1.080m |
| Seed B | 2.58% | 3.01% | 0.05 | 32.4 | 1.096m |
| **Noise** | **0.22pp** | **0.28pp** | **0.020** | **0.9** | **0.015m** |

## Sweep

| size | half_width | fence | corner | td/min | td_succ | clinch/m | sep | str/rd | head | body | leg |
|---|---|---|---|---|---|---|---|---|---|---|---|
| gym_6m | 3.0000m | 2.80% | 3.30% | 0.07 | 188% | 0.00 | 1.080m | 33.3 | 54.8% | 40.0% | 5.2% |
| abc_18ft | 2.7432m | 4.45% | 5.38% | 0.07 | 183% | 0.00 | 1.085m | 31.2 | 53.9% | 40.6% | 5.5% |
| ufc_25ft | 3.8100m | 0.76% | 0.75% | 0.07 | 214% | 0.00 | 1.081m | 32.9 | 53.8% | 40.6% | 5.6% |
| ufc_30ft | 4.5720m | 0.19% | 0.15% | 0.06 | 195% | 0.00 | 1.087m | 31.3 | 53.3% | 41.5% | 5.3% |
| abc_32ft | 4.8768m | 0.17% | 0.13% | 0.06 | 210% | 0.00 | 1.083m | 31.6 | 52.9% | 42.2% | 4.9% |

## Findings

**Cage size changes WHERE, not WHAT.** The fence and corner shares drop sharply with
cage size -- 2.80%% to 0.17%% at the fence, 3.30%% to 0.13%% at a vertex -- because a
bigger floor has more centre and less boundary per unit area. But the things that
the R150 anchors are calibrated against do not move:

- **Takedown rate**: flat at 0.06-0.07/min across all five sizes. Every difference
  is within the control arm's noise of 0.020/min.
- **Strikes per round**: flat at 31-33. Noise is 0.9.
- **Strike mix (head/body/leg)**: flat. Head 53-55%%, body 40-42%%, leg 5-6%%.
  The J20 anchors (61-65%% head, 19-23%% body, 14-18%% leg for significant strikes)
  are not walked off by cage size.
- **Mean separation**: flat at 1.08-1.09m. The fighters maintain the same fighting
  distance regardless of how much floor there is.
- **Clinch entries**: 0 across all sizes. The grapple system's clinch probability
  does not fire at these stats, so there is nothing to measure here.

## Ruling

**A championship octagon is a presentation change, not a re-baseline.** The engine's
striking, takedown and distance numbers are insensitive to cage width from 5.5m to
9.8m. The only thing that moves is the share of time spent at the boundary, which
is a geometric consequence of more floor area, not a change in fighter behaviour.
S7 can build venues at any of these sizes without repricing the R150 anchors.

Half-width assertions: 0 failures across all 448 bouts.

---

## INTEGRATION VERIFICATION — Claude, 2026-09-21

Merged and checked against the raw `q121_sweep.json` rather than read off the
tables above. **The ruling stands. Two of the columns do not, and the study's
most important sub-question is not actually answered.**

### WHAT STANDS

The conclusion — *cage size changes WHERE, not WHAT* — rests on `td/min`,
`str/rd`, the head/body/leg mix and mean separation. All four are simple rates
over a fixed denominator, all four are flat across 5.5 m to 9.8 m, and every
difference is inside the control arm's own noise. The control arm is real: two
independent seed bases at the same width, with the noise quoted per column and
each claim judged against it. **A championship octagon needs no re-baseline of
the R150 anchors.**

### RETRACTED: `td_succ`

**It reads 183%–214%. A success rate cannot exceed 100%, and that alone should
have stopped the table being published.**

The cause is in `q121_cage_sweep.gd:247/256`: `takedown_attempt` and `takedown`
are counted as two disjoint event kinds and then divided as if they were an
attempt/outcome pair. They are not nested. The raw counts:

| row | attempts | landed |
|---|---:|---:|
| gym_6m | 25 | 47 |
| abc_18ft | 24 | 44 |
| ufc_25ft | 22 | 47 |
| ufc_30ft | 20 | 39 |
| abc_32ft | 20 | 42 |
| control run_b | 34 | 34 |

`run_b` returning exactly 34/34 while `run_a` returns 25/47 is the giveaway: the
relationship between the two counters changes with the seed, so it is not a
ratio of anything. **`td/min` is unaffected** — it is landed takedowns over
minutes and never touches the attempt counter.

### NOT ANSWERED: the takedown against the fence

TASK_Q121 called this "the one most likely to move" and asked for the takedown
rate split by whether the defender was against the fence. The sweep collected:

| row | attempts at fence | landed at fence |
|---|---:|---:|
| gym_6m | 1 | 2 |
| abc_18ft | 1 | 2 |
| ufc_25ft | 0 | 1 |
| ufc_30ft | 0 | 0 |
| abc_32ft | 0 | 0 |

**A sample of nought to two events.** Nothing can be concluded from it in either
direction, and two rows again report more landed than attempted. The digest
above presents `fence_success_rate` without saying the sample is empty.

### ALSO REAL, AND FLAGGED HONESTLY BY QWEN

**Clinch entries are 0 in all 448 bouts** — a grappler (grapple 82) against a
striker in MMA, and the clinch never fires once. Qwen reported this rather than
hiding it. It is not a cage-size finding; it is an engine finding, and it means
the grappling half of this instrument measured almost nothing.

### WHY THE GATE PASSED ANYWAY

`Q121_check.py` exits 0. It recomputes the headline numbers from the same
counters that produced them and never asserts the one invariant that would have
caught this — **landed <= attempts**. A gate that inherits its subject's
assumption cannot test that assumption. Any successor must assert that bound.
