# U193 digest — blind back-seat band test (S113)

**Branch:** `cursor/u193-back-bands` (from `origin/master`, pre-Q208).  
**Test:** `Godot/tests/fight_back_bands_contract_test.gd` — 45 MMA bouts × 3 populations + 8 non-MMA sanity bouts.

## Contract checks (structural)

| Check | Result |
|-------|--------|
| Boxing: zero `back` / `back_end` | pass |
| Kickboxing: zero `back` / `back_end` | pass |
| MMA: every `back` paired with `back_end` or bout ends inside | pass (0 events today) |

## G142/U193 bands (achieved vs wanted)

Populations are distinct MMA-legal pairs (`stats` key, not `attributes`); no `untrained` blocks on MMA men.

| Population | Median visit | Sub-finish share | Back visits / bout |
|------------|--------------|------------------|---------------------|
| grappler vs striker | **0.0 s** (want 10–30 s) | **0.0%** (want 12–32%) | **0.000** (want 0.1–1.0) |
| wrestler vs BJJ player | **0.0 s** (want 10–30 s) | **0.0%** (want 12–32%) | **0.000** (want 0.1–1.0) |
| two strikers (grapple gap) | **0.0 s** (want 10–30 s) | **0.0%** (want 12–32%) | **0.000** (want 0.1–1.0) |

**`FIGHT_BACK_BANDS FAILS=9`** on master-line engine (no `back` / `back_end` log events yet — expected until Q208 lands).

## Mutant proof (not committed)

Scratch: `VISITS_PER_BOUT_LO` flipped `0.1 → 0.0`. Same census; **`FAILS=6`** (three visits/bout bands falsely pass). Restored before commit.

## Gate

- `check_scripts.py` on the test: **pass**
- One test run (post-`--import`): **exit 0**, prints `FIGHT_BACK_BANDS FAILS=9`
