# TASK Q43 — QWEN — AT WHAT DISTANCE DOES A STRIKE ACTUALLY HAPPEN?

Model: qwen `--yolo`, **medium** effort.
Owner: qwen. Deliverable: `research/Q43_THE_STRIKING_DISTANCE.md`.
Owned files: `Godot/tools/measure_exchange.gd` (append a section 8),
`research/Q43_THE_STRIKING_DISTANCE.md` (new). **Nothing else.**

**Tier: parse gate on `measure_exchange.gd`, then run your own harness.
NO test suite. NO `run_tests.py`.** This edits a tool, not a script the suite
loads. `python Godot/tools/check_scripts.py Godot/tools/measure_exchange.gd`.

## Why this exists — R101 is about to draw three lines and does not know where

R101 gives the fight a move palette. Every technique in
`Godot/assets/data/technique_catalog.json` carries a `range_band` of
`LONG` / `MID` / `POCKET` / `CLINCH`, and the engine measures a **separation in
metres**. Somebody has to map metres onto those four words, once.

**The trap, already paid for, and you must not walk back into it.** G47's
anatomy says long 1.1–1.5 m, pocket 0.6–1.1 m, clinch ≲0.5–0.6 m. But
`FightRealtime.STRIKE_RANGE` is **1.1 m** and `_run_impact` returns `{}` above
it — so if the bands are taken from G47's prose, `LONG` becomes **structurally
unreachable** and a jab, the most thrown punch in boxing, becomes unthrowable.
The bands must be cut from **the engine's own measured distribution**, not from
anatomy prose.

Q34 measured the histogram over 178,024 scored strikes and it **starts at 0.6**:

```
[0.6,0.7) 9.3%   [0.7,0.8) 12.4%   [0.8,0.9) 13.9%
[0.9,1.0) 17.6%  [1.0,1.1) 23.9%   [1.1,1.2) 0.0%
```

Those six buckets sum to **77.1%**. So roughly **23% of scored strikes happen
below 0.6 m and nobody has ever looked at them.** That missing 23% is where
`POCKET` and `CLINCH` have to come from, and R101 cannot cut a boundary through
a region it has never measured.

## What to measure

Append **section 8** to `Godot/tools/measure_exchange.gd`, in the same shape as
your sections 6 and 7. Run MMA and boxing separately — **two rulesets, two
tables, never pooled**, because C85 has just changed boxing's target
distribution and the two engines are no longer the same fight.

1. **The full separation histogram at impact time, in 0.05 m buckets, from 0.0
   to 1.15 m.** Not from 0.6. The whole thing. Report the count and the share
   in every bucket, and name the denominator in the same sentence as every
   percentage (it is *scored strikes*, not ticks).
2. **The floor.** What is the smallest separation the engine ever produces at an
   impact, and the 1st and 5th percentile? If there is a hard floor — a body
   radius, a `Space` clamp — say what it is and where it lives. If the engine
   can put two men at 0.0 m, say that instead.
3. **The same histogram over TICKS, not strikes** — the distribution of
   separation on every impact-subsystem tick, including the ones above 1.1 m
   that produce nothing. Two men circling at 1.6 m are in a state R101's band
   mapping has to have a word for.
4. **The terciles.** Give the two separation values that cut the *scored strike*
   distribution into three equal thirds, MMA and boxing separately. R101 will
   use these to place `POCKET | MID | LONG` so that all three bands actually
   occur. Report them; do not edit any engine constant.
5. **Reach-scaled distance.** Q34's fighters are reach 183 and 176 cm. Report
   the same histogram in units of **D = separation / arm_length**, taking
   `arm_length = 0.44 * reach_cm / 100` (AUTHORED — say so in the deliverable,
   it is a body-proportion figure and not a measurement of ours). Report D per
   side, because the two men have different arms and the same metre is a
   different D to each of them.
6. **How much of the separation range is reachable at all.** Share of impact
   ticks with `separation > 1.1` (the gate refuses them), and the share of
   ticks in each of the three tercile bands from (4).

## The traps

- **A SHARE IS ONLY MEANINGFUL AGAINST THE RIGHT DENOMINATOR.** Q34's 77% is a
  share of *scored strikes*. A share of *ticks* is a different quantity and the
  two must never appear in the same column.
- **Do not compare our in-gate tick share to pro boxing's 35.6% direct contact
  time.** Q42 already recorded that warning: the near-match is a coincidence,
  they are not the same quantity, and citing it as validation repeats the
  hand-travel-versus-separation error.
- **Do not touch `FightRealtime.gd`, any test, or any pinned card.** This task
  measures. R101 decides.
- Measurement harnesses live in `Godot/tools/`, never `Godot/tests/`. Sections
  6 and 7 are already there; follow them.
- Reuse Q40's seed discipline: state the seed block you used, so the numbers can
  be reproduced exactly.

## Deliverable shape

`research/Q43_THE_STRIKING_DISTANCE.md`: the six answers above, each with
its denominator named, the two rulesets kept apart, the seed block, and a
closing three-line recommendation — **"cut POCKET|MID|LONG at X and Y metres,
and here is the share each band then gets"** — for MMA and for boxing.
If a band cannot be made to occur, **that is the finding**; report it, do not
widen a boundary until it does.

## When you are done

`git fetch origin && git rebase origin/master`, stage **only** your two files,
commit, push `master`, then one line:
`python Tools/agent_comms.py send --from qwen --to claude --subject "Q43-done" --body "<sha> <the two boundaries, MMA and boxing>"`.
Do **not** edit `HANDOFF.md`.
