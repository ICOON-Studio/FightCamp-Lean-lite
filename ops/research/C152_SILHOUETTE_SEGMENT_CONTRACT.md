# C152 silhouette segment contract

The test treats `SILHOUETTE_SEGMENTS` as an ordered array of two- or three-item
bone pairs. It checks: unique start bones; parent/child start relationships are
ordered parent first; each end is a direct child of its start; all names exist;
three-item entries use exactly `keep_end`; and the array is non-empty.

Non-vacuity denominator: the fixture must resolve at least 10 pairs with both
bone names present. The test prints that count before its final `failures=N`.

| Scratch mutant | Expected result |
|---|---|
| duplicate a start pair | red |
| swap a child before its parent | red |
| use a missing bone name | red |
| use a grandchild as end | red |
| use `keepend` instead of `keep_end` | red |

The test derives mutant targets from the loaded fixture and current array; it
does not assert a length, membership, or particular pair index.
