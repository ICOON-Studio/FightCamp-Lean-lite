---
name: feedback_anchor_miss_is_not_its_own_constant
description: An anchor miss is not evidence its own constant is wrong - find the ratio the anchor is a share of and measure the denominator first
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a3475d8c-1635-429c-ad7f-025c0811adb7
  modified: 2026-09-20T11:21:28.721Z
---

A per-fight total is a **product of volume and rate**, so tuning it moves whichever of the two you
happen to have a dial on. Before scaling the constant that produces the thing the anchor counts,
find the RATIO the real-world anchor is actually a share of, and measure the engine's denominator.

S25 (2026-09-20) is the cleanest case. J20's D5 says 0.41-0.52 knockdowns a fight; the engine gave
1.704, and the stage was scoped to close that gap. The constants that produce a knockdown turned
out to be **too low**: the engine converts 1.07% of landed power head strikes where FightMetric
measures 3.9%. It reaches 1.704 by landing **159.9** power head strikes a fight where the real
number is 10.5-13.3. Scaling `KNOCKDOWN_FROM_SHOCK_BASE` by 0.28 would have hit the anchor exactly,
made the one *sourced* rate four times worse, and hidden a 6.9x volume error behind a green number.

**Why:** an anchor is usually a derived quantity. Hitting it by moving the nearest constant is
always possible and is almost always the wrong edit - it removes from view the number that would
have told you where the defect really is.

**S26 (2026-09-20) confirmed it and added the sequel.** Landing the pace anchor took the knockdown
count from 1.704 to 0.333 against 0.41-0.52 with **neither knockdown constant touched** - S25's
thesis proved. But the COUNT being near anchor hid that its two factors are still wrong in opposite
directions: 31.4 landed distance power-head strikes a fight against the 10.5-13.3 implied (2.8x
over) at 1.06% against 3.9% (0.27x under), and 2.8 x 0.27 = 0.76 against the 0.75x count observed.
**So "the total is now at anchor" is not evidence the mechanism is right** - decompose it again.

**AND A RATE ANCHOR IS NOT A PER-FIGHT ANCHOR.** J20's "71.3 landed a fight" and "6.85 a minute"
are one statistic and agree only at its own 10:25 mean duration. The engine runs 14.46 min, so both
could not be hit and a compromise would have half-missed each. Take the one the source calls
primary (D1 says "per fight-MINUTE"), hit it, then PROVE the residue is the other variable:
1.02 x 1.39 = 1.42, exactly the per-fight ratio, so the whole remainder is fight length and belongs
to a different stage.

**How to apply:** for any anchor of the form "X per fight", ask what X is a share OF in the source,
measure that denominator in the engine, and compare the RATIO first. Only then decide which side is
wrong. Pair it with the standing rule to measure the share of events a constant touches before
scaling by it. Related: [[feedback_gates_must_derive_not_copy]],
[[feedback_run_the_instrument_on_the_old_tree_first]], [[feedback_never_test_identical_fighters]].
