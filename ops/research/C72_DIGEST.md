# C72 — The fifth method reaches the record

- Canonicalized `SUB` to `SUBMISSION` in `FightRecordStats`; updated finish consumers `Mileage` and `CareerEpilogue` while preserving the legacy input alias.
- Touched consumers: `FightRecordStats`, `Mileage`, `CareerEpilogue`, `BodyReadiness`, `FightLog`, `ProfileRevampPanel`, and `UIKit`; updated the `ring_stage_panel_test` and `smoke_test` presentation assertions.
- Deliberately left: `FightContract` (already canonical), `FightResultPanel` and `TaleOfTape` (their existing `contains("SUB")` handling already accepts both spellings), and `GameState` (it carries the engine method unchanged into damage, history, and log rows). R92 files and the Q23/U31 HUD files remained untouched.
- `BodyReadiness.is_head_stoppage_method` centralizes KO/TKO/RSC head-stoppage classification; both submission spellings are finishes but never head trauma.
- `RING_STAMPS` decision: the fifth method belongs on the ring stage. Keep both accepted lookup keys (`SUB`, `SUBMISSION`) rendering `SUBMISSION`, and move the presentation contract from 5 to 7 accepted keys.
- Gates: `CHECK total=10 fails=0`; fifth method `PASS (26 checks)`; ring stage `0 failure(s)`; smoke `failures=0`; fight-record regression `0 failure(s)`; `SUITE total=218 fails=0`.
