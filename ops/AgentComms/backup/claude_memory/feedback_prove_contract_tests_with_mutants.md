---
name: feedback_prove_contract_tests_with_mutants
description: A blind contract test is not collected until it FAILS on deliberate breaks of the module - C117 passed 30 checks against a lock on a swinging foot; and Codex must be told to type every load()ed value
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 8884e447-794c-498c-b905-0270a1b92aa6
  modified: 2026-09-14T01:09:09.286Z
---

**Before collecting any contract test (blind or not), run it against 4-7 deliberately broken copies of the module and
require each to fail.** A mutant that survives is a missing check - add it, then re-run the mutant.

**Why:** 2026-09-14, S4a foot lock. Codex's C116 (leg IK) caught all four hand-made solver mutants. Codex's C117 (foot
lock state machine) passed 30 checks while a mutant kept a planted foot planted after its take stopped wanting it -
a lock on a swinging foot, the exact failure class C114's blend-0 bug had the day before. One added check closed it.
Green on the real module proves nothing about what the test can catch.

**How to apply:**
- Write a scratchpad Python script: copy the good module aside, apply one `str.replace` per mutant (flip a sign, swap a
  composition order, drop a clamp, ignore a flag, make a degenerate parameter do nothing), run the test through
  `godot_run.py`, print `N checks, M failure(s)` per mutant, restore the module in `finally`.
- Pick mutants from the contract's own clauses and its degenerate parameters, not from what the test already checks.
- Record in the HANDOFF block how many mutants failed and what check was added.
- Codex cannot boot Godot: its prompt must say "type every value returned from a load()ed script" (`var s: Dictionary =
  script.f()`) - C116 arrived with nine `:=` parse errors, C117 (told) with none. And check that every expected value
  in its test comes from the contract's formula (C116 built a target ray from the origin, not the hip).
- 2026-09-14, C124 and C125: BOTH blind tests arrived broken in new ways. C124 counted in a GDScript LAMBDA
  (`checks += 1` on a local int changes a copy) - it printed FAIL lines, then `TOTAL=0 fails=0`, and exited 0: a gate
  that could never fail. Counters go in a Dictionary. C125 used `:=` on a load()ed script (did not parse) and indexed
  sorted entries by guesswork. A test with a runtime error HANGS until godot_run's timeout: give the mutant harness a
  short `--timeout` (60 s), and count "script error" as caught only after the unmutated run is green.

Related: [[feedback_gate_research_agents]], [[feedback_blind_tests_can_collide]],
[[feedback_a_gate_that_reads_its_subject_cannot_fail]].
