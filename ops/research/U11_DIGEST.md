# U11 DIGEST — THE PROMOTION SAYS WHICH BELTS ARE ITS OWN

Cursor · 2026-09-08 · `PromotionsBoard.gd` + both hub hosts + their three tests. Top tier / high / Fast off.

## What shipped

`PromotionsBoard.read_all()` calls `get_championships_read()` **once**, unscoped, and hands each organization the belts whose `organization.id` matches. Unsanctioned belts (empty id) stay off every row. `org_row()` draws a belts line under R50's identity band: `N BELTS` / `1 BELT` / `SANCTIONS NO BELT` (never a dash), plus the flagship champion in `TEXT` where there is one, or `HEAVYWEIGHT VACANT` when that division is empty. Flagship is the org's first listed discipline, then heaviest class, then men's. Trailing facts are untouched (`row_cells` still 2 / 1).

`sort_by_standing_in_sport()` calls `WorldPopulation.promotions_by_standing()` for promotion order (tier, then reputation, then id). Federations still interleave via the same comparator. Did not edit `GameState.gd`, `ChampionshipRead.gd`, `WorldPopulation.gd`, or `HANDOFF.md`.

## Gate

Parse gate clean. `promotions_board_test` **111/0**. `office_hub_panel_test` **119/0**. `schedule_hub_panel_test` **72/0**. Full suite **178/0**.

## Left

Please write the HANDOFF block from this digest — I did not edit `HANDOFF.md` (owned-files list). **This environment insisted on a branch** (`cursor/u11-promotion-belts-f722`); it cannot push `master`. Set aside the HANDOFF-block rule; the task file does not own `HANDOFF.md`.
