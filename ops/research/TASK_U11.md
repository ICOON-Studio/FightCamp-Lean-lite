# TASK U11 — THE PROMOTION SAYS WHICH BELTS ARE ITS OWN (cursor)

Model: top tier, effort **high**, Fast off. One session.

## Why this exists

R68 (2026-09-08) made a belt name its promotion, and added
`GameState.get_promotions_read()` — every promotion in the world, most popular
first, each with `tier`, `reputation` and a 1-based `rank`. The CHAMPIONS board
reads it. **The promotions board does not.**

So the relationship is currently one-way. A belt can say "ONE Championship".
ONE's own row cannot say it holds four belts, or who wears them — and that row
is the one place a player goes to ask what a promotion actually is.

`PromotionsBoard.gd` (R50, ~430 lines) is the shared module, hosted by
`OfficeHubPanel.gd` and `ScheduleHubPanel.gd`. It already draws an
organization's disciplines, rounds, provenance and evidence grade. Belts are the
missing line.

## What to build

1. **`PromotionsBoard.org_row()` gains a belts line.** For a promotion: how many
   belts it sanctions, and — where the row has the space R50 already gives
   trailing facts — the champion of its flagship division. A promotion that
   sanctions none says so plainly; **it must not fall back to a dash that reads
   like a missing value.** Nothing is invented: every figure comes from
   `get_championships_read()` rows whose `organization.id` matches.

2. **Read once, not per row.** `PromotionsBoard.read_all()` is the seam. Call
   `get_championships_read()` ONCE there and hand each row its own belts;
   **a read inside `org_row()` is a call per promotion, which is the exact
   defect R68 just spent a stage removing.** Do not pass a scope — this board
   wants every promotion's belts, and the unscoped read is one career copy now.
   Every row it returns is honestly marked `contenders_loaded`, and you do not
   need contenders here at all.

3. **One standing order, not two.** `PromotionsBoard.sort_by_standing_in_sport()`
   and R68's `WorldPopulation.promotions_by_standing()` are two different
   answers to "which promotion is bigger", both live. Decide which is right and
   make the other call it. R68's is tier, then reputation, then id, and it is
   what the CHAMPIONS board's default already trusts.

4. **The unsanctioned belts are not yours to hide.** Belts whose
   `organization.id` is empty belong to no promotion in this world. They do not
   appear on any promotion's row, and that is correct — do not attach them to
   the nearest name.

## Owned files

```
Godot/scripts/PromotionsBoard.gd
Godot/scripts/OfficeHubPanel.gd
Godot/scripts/ScheduleHubPanel.gd
Godot/tests/promotions_board_test.gd
Godot/tests/office_hub_panel_test.gd
Godot/tests/schedule_hub_panel_test.gd
research/U11_DIGEST.md
```

**Not owned, do not edit:** `Godot/scripts/GameState.gd`,
`Godot/scripts/ChampionshipRead.gd`, `Godot/scripts/WorldPopulation.gd`,
`Godot/scripts/ProfileRevampPanel.gd`, `Godot/scripts/FightContractScreen.gd`,
`Godot/scripts/RankingsHubPanel.gd`. Claude owns those under R69 and both tasks
run at once. R68 already gave you every read you need; if you believe you need a
new one, send mail and stop rather than adding it.

`PromotionsBoard.gd` is ~430 lines — read it whole, it is small.
`OfficeHubPanel.gd` and `ScheduleHubPanel.gd` are larger; find your seam with
`grep -n PromotionsBoard` and read only those windows.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/PromotionsBoard.gd Godot/scripts/OfficeHubPanel.gd Godot/scripts/ScheduleHubPanel.gd Godot/tests/promotions_board_test.gd Godot/tests/office_hub_panel_test.gd Godot/tests/schedule_hub_panel_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/promotions_board_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/office_hub_panel_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/schedule_hub_panel_test.gd
```

Then the full suite once in the background before the commit. Fails=0 or better
— **if it comes back lower than you expected, say so and push anyway.**

## The one trap

**Push to `master`, not to a branch.** Three of your reports (U3, U5, U8) were
written correctly and pushed to `cursor/*` branches where `agent_comms.py inbox`
could never see them; two sat unread for a day and one carried a live defect
nobody knew about until 2026-09-08. If your environment insists on a branch,
say so in your mail in the first line.
