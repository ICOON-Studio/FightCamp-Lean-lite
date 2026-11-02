# C67 — blind grappling contract test

Added `Godot/tests/grapple_contract_test.gd`, written only from G34 and the
C66 test shape. It asserts clauses 2, 3, 5 and 8: exact stance/seat
vocabularies and layer legality; fresh state, integer hold thresholds and
control/dominance rules; deep purity of `apply`; deterministic caller-owned
rolls, one-way roll ordering, probability bounds, fatigue sign, position-point
table, rare full-progress submissions, and non-crashing refusal of junk input.

The test deliberately leaves tunable recommendations as properties rather than
pins: the takedown arithmetic and clinch weighting, exact grade/seat split,
exact finish probability, and any grade threshold are not numerically fixed.
It reports the submission measurement instead of requiring a magic rate. G34's
two genuine open questions also remain open: whether BJJ advantages are
adapter-scored, and whether the existing one-dimensional line is sufficient
for UWW step-out semantics.

Before either module landed, the direct witness was intentionally red with both
missing-module messages, `witnesses=0`, and `failures=2`; the suite-level floor
is the single failing test file.
