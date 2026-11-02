# C146 — Blind grapple offence/defence contract

The new witness is `Godot/tests/fight_grapple_split_test.gd`. It is written from
the C146 contract and Q119's resolver table without reading U118 or any Cursor
branch. It checks exact `stats` spelling, the two generated split keys, legal
0..100 values, population correlation, old-`grapple` non-restatement, directional
takedown asymmetry, the two wrong-half regressions, incomplete-stat refusal, and
flat `submission_finish` behavior. `top_control` is intentionally absent.

The fixture population is explicitly named by the test output: A is high
offense/low defence and B is the reverse; all five other grounded stats are held
equal. A and B are never identical fighters.

## Verification

The requested blind mutation audit is recorded below. The implementation was not
inspected or modified. On master, before U118 integration, the witness takes its
loud `failures=0` not-implemented skip because both split keys are absent.

| mutant | required red assertion | status |
|---|---|---|
| defence copied from offense | population correlation >= 0.90 | witness path present; collect after U118 |
| defender reads offense | fixed-offense / raised-defence success rises | witness path present; collect after U118 |
| defence removed from generation | partial-generation failure, not skip | witness path present; collect after U118 |
| submission finish reads a split stat | flat-finish substitution failure | witness path present; collect after U118 |

Current gate: parse the new test, then run only this test. No full suite or
`--only` sweep is in scope.
