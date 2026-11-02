# R46 — THE DESK, THE MONEY (digest)

Claude · 2026-09-07 · task file `research/TASK_R46.md`

The second stage of THE SCREENS CATCH UP CYCLE, and the one that spends the
oldest orphan read on the newest art. `OfficeHubPanel.gd`'s THE DESK tab drew
C9's five-line `get_office_desk()` projection through `UIKit.desk_ledger()`.
It now draws C27's labelled gym ledger and C28's per-bout purse, composed as
M10's desk: **two wallets that are never totalled.**

## What shipped

1. **THE GYM'S WEEK replaces the ledger strip.** `get_gym_ledger_read()`
   gives cash now, the labelled inflow lines — **including R44's membership
   dues, which have had no screen since they started paying** — the labelled
   outflow lines, and `net_weekly` as the centre of the block in the largest
   type on the desk. `UIKit.desk_ledger()` is untouched; the panel simply
   stopped calling it, so the Kit Book still renders it and its parity test
   still holds.
2. **M8's grammar, drawn from tokens.** The amount carries the state:
   `evidenced` → `TEXT`, `invented` → `LINK` under an **AUTHORED** pill,
   `absent` → `MUTED`. A falling balance and a falling runway read `DIM`.
   **No money figure on this desk wears GOLD, SODIUM, BAD, AMBER, GO or
   GOOD** — negative cash included, where `desk_ledger()` used `BAD`.
3. **RUNWAY is a countdown, not an alarm.** `runway_weeks` in `DIM` when it
   is falling; `-1` reads **NOT FALLING** in `TEXT` with a `MUTED` line
   saying the week pays for itself. No projection curve, no bankruptcy
   plate, no loan offer, no member trend, no sparkline.
4. **THE FIGHTER'S PURSE is the desk's right column.**
   `get_athlete_purse_read(athlete_id)` gives `wallet_now`,
   `career_earnings` and the bouts newest first — four gross lines, three
   deduction lines and the one wallet credit, every line present. A
   never-collectible manager share is a **$0 row wearing ABSENT**, never a
   missing row; a gate share the save never wrote is the same. Logistics is
   named as **the fighter's own uncovered travel and accommodation** (J6 A1)
   and is never a commission, a tax or a gym cut.
5. **The purse has its own subject.** A new `purse_id`, resolved to the first
   fighter under contract and picked from a surname strip of at most five
   (the open fighter is never crowded off it). It is deliberately **not**
   `selected_id`, which belongs to THE BOOKS' contract rows — the test proves
   picking a surname leaves THE BOOKS' selection alone.
6. **The header caption states C27's week too.** It printed C9's
   `weekly_projection`, which predates R44 and carries no membership dues —
   left alone it would have put a *different* weekly net at the top of the
   same screen. The ledger read is therefore taken on both tabs (it walks
   roster, staff and floor, not the fight log); the purse read stays gated to
   THE DESK.
7. **What survives unchanged:** `_build_month`, `_build_sponsor`, the gold
   **OPEN THE BOOKS** hand-off, and NEEDS ANSWERING — now compact under the
   purse, and the only thing on the desk still allowed a warning colour.

## What was NOT done

No `GameState.gd`, no `UIKit.gd`, no `.tscn`, no `assets/data/`, no new read,
no write. No combined total across the two wallets and no `gym_cut`. No
membership trend or growth (J8 N2/N3 froze the count). `MODULE_TABS` and the
`books` tab id are untouched, so `CareerRoot.gd:48` and `SceneRouter.gd:101`
still resolve. Maria's M10 boards are referenced, never imported. C24
(`get_organization_read`) and C26 (`get_championship_read`) are still uncalled
and are the cycle after this one.

## Contract changes

`contract_for_test()` drops `has_ledger` / `ledger_short` / `ledger_bill` —
those were `desk_ledger()`'s own metas — and gains `has_gym_week`, `cash`,
`net_weekly`, `inflow_lines`, `outflow_lines`, `runway_weeks`,
`runway_falling`, `has_purse`, `purse_id`, `purse_wallet`, `purse_bouts` and
`desk_alerts`. `set_purse_for_test(id)` joins the other `*_for_test` hooks.
No other test reads the dropped keys.

## Verification

- Parse gate: `CHECK total=2 fails=0`.
- `office_hub_panel_test.gd`: **89 checks, 0 failures** (a settled bout is
  installed by the test so all three source states are drawn on one card, and
  the purse card is proved to hold what it draws).
- Green with it: `sponsorship_test`, `weight_move_test`,
  `objectives_board_test`, `live_refresh_test`, `gym_ledger_read_test`,
  `athlete_purse_read_test`.
- Full suite: see the HANDOFF block.

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/office_hub_panel_test.gd
```
