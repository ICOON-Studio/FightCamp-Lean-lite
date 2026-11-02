# C9 — Office + Staff read API

## Delivered

- `get_office_desk()` projects cash, separate athlete/staff payroll,
  upkeep, the next weekly projection and cash balance, monthly billing, and
  the purses plus win bonuses already attached to booked bouts.
- `get_office_books()` exposes every athlete and staff contract plus the
  weekly objectives in a draw-ready shape. A contract is **expiring at four
  weeks or fewer**; the threshold is returned with the projection.
- `get_staff_board()` exposes coach stats, gym capacity, every fighter-coach
  rapport pair and the current inferred corner coach. Assignment is visibly
  blocked with the explicit C10 handoff reason; C9 does not write a coach id.
- `get_weight_move_card()` is a thin read-only wrapper around the existing
  weight-move APIs, including targets, progress and refusal wording.

Every public projection evaluates against a disposable deep copy of Career,
so lazy billing, objective and contract access cannot alter the active save.

## Verification

- Parse gate: `CHECK total=2 fails=0 autoload_refs=1`
- Focused test: `C9 office hub API: 21 checks, 0 failures`
- `smoke_test.gd`: `failures=0`
- Full headless suite: completed with no failing test exit.
