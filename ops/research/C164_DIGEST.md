# C164 digest — capsule shape blind contract

The blind contract test is `Godot/tests/capsule_shape_contract_test.gd`. It
does not create or inspect `CapsuleShape.gd`; when that module is absent it
prints `CAPSULE_SHAPE_ABSENT module=Godot/scripts/CapsuleShape.gd` and exits
with `SUITE total=0 fails=0`, as required.

The test contains the zero-length `INF` trap, both sides of all three inclusive
boundaries, all six measured S52 capsule rows, John's clavicle and upper-arm
rows, the 0.0044 m / 7.4% neck finding, and a length/radius agreement grid that
requires `accepts_endpoint_inset` to agree with `shape`. It also covers extent
clamping and flooring without assuming unspecified negative-radius behavior.

`RESEARCH_INDEX.md` was searched for `capsule`, `presence`, and `present ratio`;
there were no matching lines. The two named memos were the only research files
read, in the prescribed order.

## Gates

The parse gate and the requested `--only ball` gate were run after the files
were added. The module is intentionally absent in this checkout, so the test
was a loud, non-vacuous absence result rather than a contract execution. No
full suite was run.

## Argument against the contract

The strongest case against it is that four bands invite policy theater: a
caller can still treat every result as “inset” or “do not inset,” while STOUT
and NEEDLE merely describe severity without forcing a different downstream
decision. The 0.25 threshold is especially a modeling choice, unlike 0.50,
which follows directly from `L - 2r`; without a measured gameplay outcome at
0.25, it may create false precision. My weakest point is that this criticism
assumes the consumer will ignore the labels. A stable vocabulary plus a grid
test can make that boundary auditable and let future policy distinguish a
surviving but costly inset from a destructive one; the contract's real weak
point is not arithmetic but the absence of a named gameplay action for STOUT.
