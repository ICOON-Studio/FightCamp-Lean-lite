# C194 — blind gym-market contract test

Added `tests/gym_market_blind_test.gd` from the C194 definition and G74's
smallest-slice rules. It covers city-pool bands/popularity clamping,
score normalisation, rival facility/kit parity, share conservation and
rounding/capping, crowding yield bounds, two real careers in Suva (1 gym) and
Toronto (4 gyms), the live market read, and the invented-labelled ledger read.

The test is intentionally independent of `gym_market_test.gd` and does not
change a failing assertion to match the shipped implementation. Gate results,
including the required throwaway mutants and any shipped-code disagreement,
are:

- Parse: `CHECK total=1 fails=0`.
- Final contract run: `GYM_MARKET_BLIND checks=43 failures=0`.
- Mutants, each reverted immediately: popularity sign — 7 failures; crowd
  member-load term dropped — 3; crowd-yield slope sign — 3; market denominator
  dropped — 2; condition weighting dropped from live capacity — 1.

No shipped-code contract disagreement remains after fixture correction. The
first run's five failures were test-fixture errors (one arithmetic expected
value, popularity's live location, settlement timing, and ledger timing), not
reasons to weaken the definition; the corrected test is green.
