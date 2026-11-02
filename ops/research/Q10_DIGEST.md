# Q10 DIGEST — Medal Table Test

**Agent:** qwen · **Date:** 2026-09-08

## Delivered

`Godot/tests/medal_table_test.gd` — 52 assertions over the five static
functions in `MedalTable.gd`, written from the contract in TASK_Q10.md
before the module was opened.

## Coverage

* **table()**: ordering by gold/silver/bronze desc, name asc case-insensitive,
  id asc; shared rank with skipped next rank; merge of same-id entries
  (summed counts, first non-empty name kept); zero-medal competitor kept and
  ranked last; non-Dictionary entries skipped; missing keys default.
* **rank_of()**: present id returns its rank; absent id returns -1, never 0.
* **totals()**: five keys summed correctly; empty array gives five zeroes.
* **row_words()**: name upper-cased; id substitutes for empty name; both empty
  drops name section and separator; zero counts still print (0G).
* **leader()**: returns rank-1 row as a copy; {} for empty table; {} when
  more than one row shares rank 1 (tied table has no leader).

## Results

* Parse gate: 1/1 pass.
* medal_table_test.gd: 52/52 OK, 0 failures.
* smoke_test.gd: 53/53 OK, 0 failures.
* Full suite: running (185 files expected, baseline 184/0 at 3b5f65c).

## Module notes

No defects found. The module matched every contract assertion on the first
run. Did not need to open `MedalTable.gd` during test construction.
