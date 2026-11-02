# C66 — The test that would have caught all seven

Added `tests/fight_reaches_its_modules_test.gd`, an implementation-blind
integration test that drives 40 real seeded `FightRealtime` bouts and asserts
occurrence rather than permission:

- at least one bout finishes with visible face trauma, and the observed pip
  range is non-degenerate;
- one fighter's heart rate rises from early to late as fatigue accumulates,
  with a non-degenerate observed range away from the physiological bounds;
- two runs of one seed agree on both final trauma and heart rate;
- `FightTrauma.aggravate` leaves its input and nested site dictionaries intact.

The test prefers `FightHudRead.fold(state)` when Q18 is present and uses the
contract's direct-state fallback while that sibling lands. It pins no rate and
no BPM; both measurements are printed for humans.

## Gates observed before R87

- Parse: `CHECK total=1 fails=0 autoload_refs=0`.
- Focused test: red by design, `failures=2`. It printed trauma `0/40` bouts and
  range `0..0` pips, proving today's engine still does not reach trauma. Cardio
  moved `115 -> 148` bpm, with observed final range `134..149`.
- Full suite, run once before commit: `SUITE total=206 fails=1`. C66 was the
  single failing script, as required until R87 lands.

The assertions were not weakened to make the pre-R87 suite green.
