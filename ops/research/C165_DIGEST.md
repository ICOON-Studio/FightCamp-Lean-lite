# C165 — Elevation-banded exposure contract

Implemented the blind contract test at `Godot/tests/elevation_band_contract_test.gd`.
The test does not create or stub `Godot/scripts/ApproachBand.gd`; when that module
is absent it prints an explicit absence line and `SUITE total=0 fails=0`. When the
module exists it checks the exact region bands and provenance, the full-sphere
clavicle and unknown-region defaults, Y-up elevation including zero-vector
handling, inclusive boundaries, inverted-band rejection, a -90 to +90 degree
grid, and the bounded percentage arithmetic cases.

Gate results:

- `python Godot/tools/check_scripts.py Godot/tests/elevation_band_contract_test.gd`
  — `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=0s`.
- `python Godot/tools/run_tests.py --only elevation` — pending; the `total=` line
  matched this file and returned `SUITE total=1 fails=0`. The module is absent,
  so the test took its explicit skip path; the filter match is confirmed by the
  one discovered test and zero failures.

The strongest case that this contract is wrong is that four hand-picked regions
with `"estimate"` sources form a lookup table pretending to be geometry, and
the fifth region anyone adds will silently receive the unbanded default. The
`"default"` row saves backward compatibility and prevents an unknown region from
being accidentally narrowed, but it mostly hides the coverage problem: it does
not discover anatomy, validate a new region, or prove that an estimate is honest.
The per-region clavicle exception is still necessary because Dola's self-objection
shows that one global horizon would turn a buried shoulder girdle into a false
exposure success.
