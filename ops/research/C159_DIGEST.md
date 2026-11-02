# C159 digest

The held-pair witness was written from `TASK_C159.md` without opening the
solver, capsule module, or S48 material. It covers literal contacts, body-0
and body-1 grip key order, the 2x4 cross product, one-hop-only expansion,
two-sided allowance sums, max-wins duplicates, empty anatomy/fields, and empty
inputs.

Gates:

- Parse: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- One requested test: `checks=42 failures=0`.
- No full suite was run.

Mutant evidence from temporary injected scratch modules:

- `one_hop_off`: RED, `checks=34 failures=10`.
- `key_order_fixed`: RED, `checks=29 failures=14`.
- `allow_one_side`: RED, `checks=42 failures=12`.
- `min_wins`: RED, `checks=42 failures=12`.
- `contacts_expanded`: stayed GREEN, `checks=42 failures=0` (required
  control; the witness did not over-specify contact non-expansion).

One initial exploratory assertion expected a contact allowance of `0.0`; the
shipped module returned `0.22` for pelvis/pelvis with `0.11` on each side.
The contract says allowances sum from both capsules, so the witness asserts
`0.22`. The combined case has no pelvis allowance in its anatomy and correctly
asserts the absent-value default `0.0`.
