---
name: feedback_callv_arity_returns_empty_dict
description: "Godot's Callable.callv with the wrong argument count returns an EMPTY DICTIONARY, not null — so `if result != null` guards pass and the test measures nothing"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: b3c5acff-9983-4ea6-a25e-39535f5691fa
  modified: 2026-09-21T11:17:41.047Z
---

**`Callable.callv` with the wrong arity returns `{}`, not `null`.** So the
natural guard — `if result != null` — is satisfied, the caller reads its fields
off an empty dictionary, gets defaults, and reports a confident wrong number.

**Why:** it cost C146 THREE vacuous assertions in one file on 2026-09-21, and
each one looked like a finding rather than a bug:

- `takedown_resolve` takes SIX args `(attacker, defender, from_stance,
  fatigue_atk, fatigue_def, roll)`; the test guessed two or three. It read
  `success` off `{}` 420 times, reported **0.0000 in both directions**, and
  called that "offence/defence asymmetry is not material".
- `submission_advance` is `(progress, attacker, defender, fatigue_def, roll)` —
  five args, **`progress` FIRST**; the test passed four with fixtures in the
  wrong slots. It compared `{}` to `{}`, printed "flat", and **survived a mutant
  that gave the finish a real stat read**.

Called correctly, the same test reproduced the implementation's own numbers from
a blind harness (0.5262 / 0.4833 against 0.5223 / 0.4923).

**How to apply:** put this trap in the task file of EVERY agent writing a test
against a module it cannot see. In the test, treat an empty Dictionary as "the
call did not happen" and return null explicitly. And never guess an arity —
read the `static func` signature first. Relates to
[[feedback_prove_contract_tests_with_mutants]] and
[[feedback_open_the_output_before_the_gate]]: the mutants are what exposed two
of the three, because a vacuous assertion passes every mutant.
