# TASK U7 — CURSOR — THE GYM'S WEEK, ANY WEEK

Model: mid tier, effort **medium**, Fast off. One session, one branch.

You own `Godot/scripts/OfficeHubPanel.gd` and its test. Nobody else touches
that file this cycle. This task depends on nothing — start it first.

## Why this exists

C27 built two ledger reads. The office spends one of them:

- `get_gym_ledger_read()` (`GameState.gd:10424`) — the running book. Called at
  `OfficeHubPanel.gd:186`, drawn by `_build_gym_week()` (`:315`).
- `get_gym_ledger_week_read(week)` (`GameState.gd:10434`) — the SAME shape for
  ONE named week, including that week's amateur entry fees
  (`_with_entry_fee_ledger`). **Zero callers outside `Godot/tests/`.**

So the desk can say what the gym nets in a typical week and cannot say what it
netted in the week you just played. A management game whose books only speak in
averages is a management game you cannot audit.

## Owned files

- `Godot/scripts/OfficeHubPanel.gd` (1,574 lines — **never open it whole**).
  Read these windows only: `rebuild:155` (the reads, `:177-187`),
  `_build_desk:283`, `_build_gym_week:315`, `_build_runway:388`,
  `_build_books:820`, `_build_objectives:863`, `_money_line:537`,
  `_source_pill:560`, `_figure:594`, `_on_tab:1355`.
- `Godot/tests/office_hub_panel_test.gd`.

Read whole (small): `Godot/scripts/GymLedgerRead.gd` (135 lines) — `build()`
and `build_week()` are the two shapes, and they match.

## The work

**A week stepper on the BOOKS tab.** `_build_books()` (`:820`) is contracts,
filters and objectives; the money for a named week belongs there, under them.
Default to the CURRENT week, step back and forward, and never past the current
week — the future is a projection and M10/J8 forbid this screen from drawing
one.

Take the week read ONCE per rebuild beside the running read at `:186`, into its
own var. Draw it with the existing helpers — `_money_line()` (`:537`) already
carries the labelled-source pill, `_figure()` (`:594`) already draws a figure
with a key. Nothing new is needed.

**The honest week.** `GymLedgerRead.build_week()` labels a missing real-world
amount as a zero WITH a source, exactly as the running read does — keep the
pill. A week before the career started, or a week with no rows at all, prints
**NOTHING RECORDED FOR THIS WEEK**, never a column of `$0`.

**The desk stays the desk.** `_build_gym_week()` (`:315`) is the running book
and `net_weekly` is the largest figure on the desk by M10's ruling. Do not
change it, do not point it at the week read, and do not give the desk a
stepper.

## Refusals

- No new UIKit factory, no new token, no new tab, no new rail item (K10 stands).
- No projection curve, no growth line, no member trend, no bankruptcy state
  (J8 N3/N19/N20).
- No `gym_cut`. It does not exist.
- Do not touch `GameState.gd`, `GymLedgerRead.gd` or any other panel.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/OfficeHubPanel.gd
```

Then, from `Godot/`: `tests/office_hub_panel_test.gd`,
`tests/gym_ledger_read_test.gd`, `tests/office_hub_api_test.gd`, then the full
suite once in the background before the commit.

## The trap

`_ledger` is read once in `rebuild()` and used by the header at `:253-254` as
well as by the desk. Do NOT repoint `_ledger` at the week read to save a
variable — the header's CASH and run-rate line would then report one week
instead of the running book, and `office_hub_panel_test.gd` asserts it.
