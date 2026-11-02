# C155 digest

Contract witness for `FighterCapsules.posed()` written from `TASK_C155.md` only.

Population: `f01_m_box_welter_rigged.glb` at 1.78 m and
`f02_m_box_heavy_rigged.glb` at 1.88 m. The pose-movement assertion is executed
before the unposed-reproduces-build assertion, and the fixture never calls
`global_transform`; instantiated rigs are freed directly.

Verification: parse gate passed (`CHECK total=1 fails=0`). The one required
headless test passed with `checks=718 failures=0`, rc=0. The host emitted two
engine lines before the test (`Failed to open log file for writing` and
`Failed to read the root certificate store`); no test assertion emitted an
error. The pinned Windows executable was access-denied, so the available
Godot 4.7.2 command on PATH ran the test.

The implementation was not opened. A scratch copy was made at
`/tmp/mutant_capsules.gd`; no mutation was applied because changing an
implementation copy without inspecting its source would not establish a
contract witness, and the test's four independent guards are present:
pose movement/opposite-side immobility, world translation, world-scaled
radius, and left/right name-specific endpoint checks.
