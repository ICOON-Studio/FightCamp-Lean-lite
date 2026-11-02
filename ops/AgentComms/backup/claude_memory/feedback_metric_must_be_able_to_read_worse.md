---
name: feedback_metric_must_be_able_to_read_worse
description: "before trusting a shape or scope change, check the metric watching it is CAPABLE of reading worse - a change that only removes volume makes its own metric monotone"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 3f51d2e0-2dbf-4f29-8a38-7fb8b4bbd745
  modified: 2026-09-22T20:23:40.444Z
---

**A change that only ever removes something makes its own metric monotone, so
the metric cannot show what the change costs.** Ask, before reading any table:
*could this number have gone the wrong way?* If not, the instrument is an
advocate, not a measurement.

**Why:** S54 (2026-09-22) flattened the thorax capsule's hemispherical caps. A
flat-capped cylinder is a strict SUBSET of the capsule with the same `p0`,
`p1`, `r` — removing the domes cannot add volume — so every exposure number
could only rise and every overlap could only fall. The exposure table made the
change look free. The cost was real and invisible there: skin vertices that
after the change sit inside NO capsule at all, **155 on f01 and 162 on f02, of
which 126 and 151 were `UpperChest`** — the shoulder girdle, which is exactly
what the proposing agent's own self-objection had warned about.

**How to apply:** when a change is one-directional, measure it with a second
quantity that can read worse — usually *coverage* against ground truth (here
the rig's own skin vertices) rather than *reachability*. And count what NO
owner covers, never what one owner stopped covering: 331 and 335 vertices were
dropped from the thorax, but `Spine` and `Chest` orphaned ZERO because the
lower cap sits inside an adjacent capsule, so the raw drop count overstated
the cost by more than half.

Same family as [[feedback_a_control_that_cannot_move]] and
[[feedback_give_every_fix_a_control_arm]], one level up: there the control
could not move, here the metric could not fall. See
[[feedback_informative_failure_still_does_not_ship]] for what to do once the
real cost is visible — record the table, revert, name the next fix.
