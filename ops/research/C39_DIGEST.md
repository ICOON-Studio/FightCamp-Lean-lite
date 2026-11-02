# C39 digest — amateur circuit plumbing

- Added a copy-safe amateur read, stable real-athlete opponent pool, and deterministic amateur offers carrying complete pathway terms.
- Amateur booking stays on `book_fight()`: known fees debit atomically and appear in the gym ledger; unknown fees debit nothing; authored division prizes pay only on a win.
- Settled amateur bouts persist a separate record and never move professional ranking points. `_turn_pro()` now records the irreversible cause/week from a promotion contract or paid bout.
- Parse gate 2/2; `amateur_circuit_test.gd` 28/28, `entity_pathways_test.gd`, `smoke_test.gd`, `contract_clauses_test.gd`, `press_conferences_test.gd`, and `tournaments_test.gd` green.
- Full suite green: 162/162 on stable HEAD after Claude corrected the two legacy fixtures to select a signing organization instead of array element zero.
