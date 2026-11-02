# C27 — Gym Ledger Read — Digest

## Shipped

- Added pure `GymLedgerRead` standing and settled-week reads.
- Added `GameState.get_gym_ledger_read()` and `get_gym_ledger_week_read(week)` in the read-API region only.
- The standing read exposes gym cash, labelled inflow/outflow lines, complete weekly net, floored runway, accrued billing plus bill week, and total athlete cash.
- Sponsorship is explicitly `invented`; membership dues and corner fees remain present as `absent` zeroes. No purse or manager-cap value becomes gym income.
- Weekly history is never fabricated: an unrecorded week returns the standing shape with `empty = true`; an already-shaped snapshot under `career.gym_ledger_history` is copied when present.
- Both accessors are copy-safe and do not ensure sponsorship, settle billing, save, or mutate Career.

## Verification

- Parse gate: `CHECK total=3 fails=0 autoload_refs=1`.
- Focused: `C27 gym ledger read: 15 checks, 0 failures`.
- Full suite: `SUITE total=142 passed=142 failed=0`.
