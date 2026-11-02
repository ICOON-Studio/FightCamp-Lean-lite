---
name: feedback_tier_the_test_gate
description: "Name a test TIER in every task file; the full suite is Claude's once at integration, not every agent's private gate"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 47e37ea4-ab16-495f-bd15-4e950ac50427
  modified: 2026-09-10T10:11:30.727Z
---

Operator report 2026-09-10: agents spend most of their wall clock inside the
suite, Qwen worst. They were right, and most of those runs could not have
found anything.

**Why:** the suite is 220 tests, each one a FRESH GODOT BOOT, run strictly
serially — about twenty minutes. The cost is the boot, not the work.

**How to apply:** name the tier in every task file, because an agent not told
a tier runs everything.

- research task, no `.gd` touched → **no gate at all**, not even the parse
  gate; `git status -s` before staging is the whole check
- a NEW test file only, no script edited → parse gate + that ONE test. **A new
  test file cannot break another test**, so the suite buys nothing. This is
  most blind-contract-test work.
- a script edited → parse gate, focused test, `run_tests.py --only <subset>`,
  and name the subset yourself rather than making the agent guess
- **the full suite is CLAUDE's, once, at integration** — give an agent a suite
  ceiling only when its change genuinely reaches across the tree

`run_tests.py --jobs N` exists (defaults to 1) but is **UNPROVEN**: prove it
against a serial run verdict by verdict on a QUIET TREE first, because
concurrent Godot has produced false failures before. See
[[feedback_godot_verification_gate]] for why the exit code alone is never the
gate.
