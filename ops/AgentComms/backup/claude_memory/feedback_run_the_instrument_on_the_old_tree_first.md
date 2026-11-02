---
name: feedback_run_the_instrument_on_the_old_tree_first
description: "S2 2026-09-13 - run a measurement tool on the UNCHANGED tree before trusting it for a before/after; R138's sweep had rotted, printed its header and zero rows, then hung"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 0f65a0d6-58b6-49a7-b942-a85c31d49103
  modified: 2026-09-13T02:05:29.417Z
---

Before a stage measures "before vs after" with an existing tool, run the tool on the
unchanged tree and read its rows. On 2026-09-13 `tools/measure_ruleset_sweep.gd` (R138,
written one day earlier) called `FightBeatAdapter.advance_tick`, which no longer existed:
it printed its banner and table header, zero rows, then HUNG on a script error in
`_initialize` (a SceneTree `--script` does not quit on a runtime error).

Two more defects surfaced only because the rows were read:
- it counted presenter BEATS - one shown event per ~1 s window - not the engine's log,
  so even a live loop undercounted; count `state["log"]` action events instead;
- J20's anchor is a share of SIGNIFICANT strikes; the tool compared all landed strikes.

**Why:** a broken instrument looks like a quiet number. The same session's `-- detail`
breakdown then found the real story (MMA body 53% from `mma_guard_gnp` at 85% torso;
footwork nodes LANDING as strikes, ~20% of boxing) that no aggregate showed.

**How to apply:** run any measurement headless through a wrapper with a hard timeout
that taskkills both Godot exes; check it prints a row per population before the first
data commit; prefer a per-technique breakdown over an aggregate when a share misses its
anchor. Related: [[feedback_a_gate_that_reads_its_subject_cannot_fail]],
[[feedback_assert_the_quantity_the_user_sees]], [[feedback_never_test_identical_fighters]].

Second S2 lesson, same root: **an adjudicated target is not a calibrated distribution.**
Qwen's Q77 named 86 of 104 punches "head" - anatomically defensible, but applied as a
0.85 head target it would replay the recorded C85 defect (boxing 68% -> 88% head, 16/16
stopped). Punches kept the ruleset split; only kicks, knees, elbows and submissions got
explicit targets.
