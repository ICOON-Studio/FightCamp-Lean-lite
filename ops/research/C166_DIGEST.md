# C166 — Approach sweep contract

I wrote the blind contract witness at `Godot/tests/approach_sweep_contract_test.gd`.
It does not create or preload `ApproachSweep.gd`; when the module is absent it
prints the named absence marker and `SUITE total=0 fails=0`. The witness covers
the promoted-sphere (`p0 == p1`) distance path, endpoint-clamped segment
distance, unit Fibonacci directions and clamped indices, deepest blocker in
both array orders, the empty blocker result, isolated and buried sweeps,
unknown targets, full-band identity, inverted bands, and a count grid with
bounds and percentage properties. Its deliberately blocked fixture reports
`checks_failed=`, not runner-reserved failure vocabulary.

The requested research-index grep was limited to the two patterns. The
`sweep|exposure` search found existing entries including C108, C165, and older
exposure/sweep probes; it did not establish an ApproachSweep module. The
`reachab` search found C158 reachability and related research, but no C166
ApproachSweep implementation. Those are search results, not implementation
evidence; the three probe files remained unread.

Gates:

- `python Godot/tools/check_scripts.py Godot/tests/approach_sweep_contract_test.gd`
  — `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0`.
- `python Godot/tools/run_tests.py --only approach_sweep` — `SUITE total=1
  fails=0`. The filter matched this test; it was not a zero-test filter miss.

The strongest case against this contract is that `sweep` returns nine keys and
most callers want one: usable exposure, a blocker name, or a banded percentage.
That dictionary will likely gain a tenth field for the next caller and never
lose one. I would keep `blocker` and `sweep` as two functions because the
deepest-overlap primitive is independently useful and makes the sweep loop
clear, but I would consider a small result type or narrower caller-facing
queries instead of making every consumer unpack nine fields. My own weakest
point is the buried fixture: a huge concentric neighbour proves blocker
selection and zero usability, but it does not exercise realistic capsule
geometry or reveal whether an implementation handles ties consistently.
