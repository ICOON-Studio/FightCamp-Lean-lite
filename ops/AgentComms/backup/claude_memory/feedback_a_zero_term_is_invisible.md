---
name: feedback_a_zero_term_is_invisible
description: a scoring term that reads zero is invisible to every gate - drive the pure module directly and compare to the live run
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e5ba2c13-5e41-43c4-b0d1-d80775aa057a
  modified: 2026-09-22T23:48:37.906Z
---

**A term that scores zero is invisible to every gate, because zero is a legal
score.** S58 (2026-09-23) ran a weighted chooser over 542 live decisions with
its `skill` term at 0.000 on every edge, and the output table looked clean and
plausible: seven distinct edges taken, a sensible spread, the control arm
matching integer for integer. Nothing was red. The cause was that
`FightRealtime._build_fighter` never carried `technique_progress` onto the live
fighter, so every lookup silently returned `{}`.

**Why:** a gate asserts that something is wrong, not that something is
*contributing*. A chooser weighing two of its four terms still chooses, still
logs, and still looks correct. The same shape as [[feedback_a_gate_that_reads_its_subject_cannot_fail]]
— the instrument agreed with itself.

**How to apply:** when a pure module is wired into an engine, **drive the module
directly with no engine and no RNG, sweep its input, and compare that to the
live run.** S58's tell was two authored edges at exactly 0/542 live against 21%
and 24.5% of rolls in the direct sweep — a weighted chooser cannot disagree with
itself like that. Then make it a gate: count the decisions where the term
actually answered, and FAIL when that count is zero on an arm where the
mechanism ran. Relatedly, per [[feedback_print_achieved_beside_wanted]], print
what a term contributed beside what it was supposed to contribute.
