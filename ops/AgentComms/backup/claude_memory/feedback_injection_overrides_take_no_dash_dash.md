---
name: feedback_injection_overrides_take_no_dash_dash
description: "A Godot test's --foo=path injection override behind a `--` separator silently tests the REAL module, so every mutant passes green and the mutant run proves nothing"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 94da2c41-2c25-4d0f-9f7b-327dda4c66ad
  modified: 2026-09-22T08:29:19.392Z
---

S47, 2026-09-22. `ui_region_panel_contract_test.gd` takes `--uikit=res://...` so
a mutant copy can be injected. Run as

```
--script tests/ui_region_panel_contract_test.gd -- --uikit=res://tests/_mutant_uikit.gd
```

**both mutants came back `checks=86 failures=0`.** Read at face value that says
"the test cannot tell a broken module from a good one" — the opposite of what was
actually true.

**Why:** Godot splits the command line at `--`. `OS.get_cmdline_args()` returns
only what is BEFORE it; everything after is `OS.get_cmdline_user_args()`. The
test's loop over `get_cmdline_args()` never saw the flag, fell back to the
default `res://scripts/UIKit.gd`, and cheerfully tested the real module twice.

Drop the `--` and the same two mutants go red at 3 failures each.

**Why it is dangerous rather than merely annoying:** a mutant pass that catches
nothing and a mutant pass that catches everything produce the same shape of
output — a green control and green mutants read as "all clear" unless you notice
the mutants were supposed to be RED. The failure is silent in the direction of
false confidence.

**How to apply.**
- Godot injection overrides take **no `--` separator**. Same for any test that
  reads `OS.get_cmdline_args()`.
- **A mutant that does not go RED is a broken harness until proven otherwise.**
  Before concluding a test is weak, prove the injection point works at all — make
  the mutant absurd (radius 0.25, segment collapsed) and check it still fails.
- Keep an unmutated control arm in the same run: real module green, mutants red.
  Green/green is the signature of an override that never landed.

Related: [[feedback_prove_contract_tests_with_mutants]],
[[feedback_a_control_that_cannot_move]],
[[feedback_ready_true_is_not_proof_it_launches]].
