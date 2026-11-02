# C70 — grappling blind-test audit

Removed the four `is_dominant` assertions, including the defective line 92.
G34 does not define `is_dominant` or require that API from `GrappleSeat.gd`;
its enforceable rule is the section 2 `control_units` table, already witnessed
for standing, clinch, guard, half, side, mount, and back. In particular,
clinch-with-top and half each accrue 1 unit, while side/mount/back accrue 2.

I read all 236 lines and audited every assertion against all 436 lines of G34,
checking for `not X == Y` precedence traps, condition/label disagreement,
conditions that cannot fail, and conditions that pass opposite behavior.
Nothing else of that class was found. The only ambiguity was the prose term
"dominant" versus the numeric control table; because G34 never makes it a
boolean module contract, the test keeps the exact numeric witnesses and makes
no implementation-shaped classification claim. Neither grapple module was
read.

Verification:

- Parse: `CHECK total=1 fails=0 autoload_refs=0 time=0s`
- Focused: `GRAPPLE_CONTRACT_TEST SUMMARY witnesses=550 submission_rate=18/121 (0.149)` and `GRAPPLE_CONTRACT_TEST failures=0`; all remaining assertions exercised.
- Full suite: `SUITE total=214 fails=214`. This is not a pass: the runner classified every test as `engine-error` from `ERROR: Failed to read the root certificate store.`
