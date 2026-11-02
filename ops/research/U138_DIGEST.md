# U138 digest — last two sweep copies

**Branch:** `cursor/u138-sweep-cutover`  
**Owner:** cursor

## s54 option

**Chose (b) partial cutover.** `ApproachSweep.direction`, `hand_position`, and all non-vacuity / overlap direction sampling now call `ApproachSweep`. The blocker scan inside `_exposure` stays on `CapsuleDistance.surface` with an inline comment: `ApproachSweep.blocker()` is hemispherical (`point_to_segment` clearance only). Forcing it here would measure the dome on the `thorax` flat-cap arm and duplicate the control — the failure mode the task file names.

## s53

Full cutover of the duplicated sweep helpers: `_sphere_direction` removed; `_exposure` uses `ApproachSweep.direction`, `hand_position`, and `blocker` (equivalent to the prior `segment_distance` depth path on hemispherical capsules).

## Before / after tool output

Both tools run on unchanged tree first (`U138_s53_before.log`, `U138_s54_before.log`), then after conversion (`U138_s54_after.log`, `U138_s53_after.log` — local only, not committed). Stripping Godot stderr noise, **no printed measurement line differed** between before and after for either tool.

- **s53:** `SUITE total=1 fails=0` before and after; non-vacuity unchanged (`head 0.1301 m -> 0.0000 m under promotion; neck band +0..+90, unknown region -90..+90 (default)`).
- **s54:** `SUITE total=1 fails=0` before and after.

## s54 non-vacuity (quoted in full)

f01:

```
  non-vacuity: control path agrees to 0.000000000 m; subset invariant holds on 768 samples (worst deviation 0.000000000 m); 0.0616 m above the Neck bone reads dome=-0.0616 flat=+0.0616; barrel identity 0.000000000 m
```

f02:

```
  non-vacuity: control path agrees to 0.000000000 m; subset invariant holds on 768 samples (worst deviation 0.000000000 m); 0.0709 m above the Neck bone reads dome=-0.0709 flat=+0.0709; barrel identity 0.000000000 m
```

## Gates

- `check_scripts.py` on both tools: `CHECK total=2 fails=0`
- `run_tests.py --only approach_sweep`: `SUITE total=1 fails=0`

## Recommendation

If more flat-cap tools need a shared “worst blocker” scan, consider extending `ApproachSweep` with a pluggable signed-distance callback (e.g. `Callable` or enum + `flat_names` dict) rather than overloading `blocker()`. The blind `approach_sweep` contract pins today’s hemispherical signature; changing it belongs to a dedicated task that owns that test.
