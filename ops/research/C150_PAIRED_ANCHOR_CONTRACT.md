# C150 paired-anchor contract witness

The contract test is [fight_paired_anchor_test.gd](../tests/fight_paired_anchor_test.gd). It is implementation-blind: the subject module was absent while the test was written, and the test loads it only after the explicit presence check.

## Contract coverage

- `shared_anchor` checks the exact five-field result shape, per-frame separation, midpoint anchors, `NO_ANCHOR`, inclusive contact threshold, frame/grip counts, purity, and all specified refusals.
- `to_rig_local` checks division by the non-unit f06 scale `1.890`, non-zero root and hips terms, `NO_TARGET` propagation, purity, and empty-result refusals.
- Both chain builders check the exact Left/Right dictionaries and reject all four invalid side spellings.
- Dynamic calls have positive dictionary/size/key assertions and typed values where values are read from the loaded script.

## Gates and mutant evidence

The parse gate passed: `CHECK total=1 fails=0 autoload_refs=0 autoload_warnings=0 time=0s`.

The prescribed bare executable name was not on PATH. The installed Godot 4.7.2 binary at `C:\ProgramData\chocolatey\bin\godot.exe` ran the same headless command successfully; the host emitted its unrelated certificate-store warning. With the scratch module deleted, the final result was:

```
SKIP: FightPairedAnchor.gd not present yet; contract test is inert.
checks=0 checks_failed=0
```

Each of the seven scratch mutants went red:

1. Anchor used `a_points[i]`: midpoint checks reported 2 missed checks.
2. Separation was recorded only on grip frames: size checks reported missed checks (the test was then hardened to avoid an out-of-bounds abort).
3. Grip used `<` instead of `<=`: boundary grip and midpoint checks reported 2 missed checks.
4. Rig-local conversion multiplied by `mount_scale`: arithmetic check reported 1 missed check.
5. Rig-local conversion omitted `+ hips_local[i]`: arithmetic check reported 1 missed check.
6. Lowercase `hand_chain("left")` was accepted: invalid-side check reported 1 missed check.
7. Length mismatch returned a partial success: refusal checks reported missed checks and the scratch module raised an out-of-bounds error.

The scratch `Godot/scripts/FightPairedAnchor.gd` was deleted after the mutation run and is not part of the deliverable.
