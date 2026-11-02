# SCHED1-BADGE — Schedule card eligibility
- 2026-10-03: arena/01a10421-fightcamp → master PR only; explicit task/owned-file scope overrides master/mailbox intake.
- Layout: EVENT NAME share 0.35 → 0.29; LEVEL share 0.06; all eight CARD_COLUMN_SHARE shares sum to 1.0.
- Every event_row has a Level label: non-empty open_to → OPEN; otherwise non-empty level_lock → LOCKED; otherwise empty, including missing keys.
- Palette: existing T.GOOD green / T.AMBER amber as explicitly requested, overriding the medical-only colour rule; no new tokens or factory.
- LEVEL header is automatic and non-sortable; unknown sort IDs are ignored. Grepped DayFeedPanel, FightNightScreen and HonoursBoard: no direct card_columns/event_row callers there.
- Tests only added (579 → 626 lines): required states/header/share sum, colours, OPEN precedence, missing-key fallback and inert/unknown sorting; every original line/check preserved.
- Official Godot 4.7.2 source-built headless gates: CHECK total=3 fails=0; standalone panel 108 checks/0 failures; requested jobs=2 subset SUITE total=8 fails=0.
