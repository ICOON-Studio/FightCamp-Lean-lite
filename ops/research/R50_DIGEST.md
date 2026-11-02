# R50 DIGEST — THE PROMOTION: C24's organization read gets a screen

**Claude, 2026-09-07. COMPLETE.** Read-only. No `GameState.gd`,
`Sanctioning.gd`, `OrganizationRead.gd` or `FightSimulation.gd` edit; no new
UIKit factory and no new token.

## What shipped

One read, one shared module, two hosts — each drawing the half that matches
its own charter, not the same slab twice.

- **`Godot/scripts/PromotionsBoard.gd`** (new, ~430 lines): the shared half.
  `read_all()`, the sourcing dress, `sourcing_tag()`, `provenance_block()`
  and `org_row()`. The sourcing is drawn HERE and only here, so the two tabs
  cannot disagree about how well a rule is known.
- **`SCHEDULE > PROMOTIONS`** (`ScheduleHubPanel.gd`, fourth tab): the fight
  half — disciplines, the sanctioned ruleset per discipline, the round
  structure (`3 x 5:00, 1:00 REST`), where the researched ruleset differs
  from the played one, and the cards they actually have coming. The drill-in
  THE CARDS implies.
- **`OFFICE > PROMOTIONS`** (`OfficeHubPanel.gd`, third tab): the business
  half — signed, goodwill, bouts taken, last result. The hub's own charter.
- **`Godot/tests/promotions_board_test.gd`** (new): 39 checks.

## The sourcing ruling

Sourcing is ranked by **ink weight, never by hue**. Every hue is already
spoken for — GOLD is the verdict, SODIUM/ICE are the belt (R47), GOOD /
AMBER / BAD are M6's medical family (R48) — and an evidence grade is none of
those. A sourced grade sits on `CHIP` at full ink; an unsourced one is
recessed onto `TRACK`. The word is always printed (`DIRECT`, `INHERITED`,
`SECONDARY`, `UNKNOWN`) and never blank, because a blank reads as verified.
`fallback` demotes the dress whatever the evidence says and adds its own
`FALLBACK` chip: a binding the game guessed is not a citation. The test
asserts the same organization wears the identical tag on both tabs and that
both side cards report the same weakest grade.

## ENGINE GAP (named, not widened)

`get_organizations_read(country)` falls back to `selected_country` when the
country is empty, so **there is no way to ask C24 for the world**. In a
seeded career it answers with 1 row while the world holds 22 organization
records (18 catalog entries; ONE and IJF appear in three markets each) and
`get_cards_board()` — which is worldwide — names all 22. A PROMOTIONS tab
showing one organization beside a cards board showing twenty-two would be
lying by omission, so `PromotionsBoard.read_all()` gathers ids from the
player's market read plus every organization named on the cards board, then
projects each through `get_organization_read()`. **C24 wants an "all
markets" argument (a sentinel country or an `include_all` flag); that is an
engine change and was not made from a screen.**

## Verification

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/promotions_board_test.gd
```

`promotions_board_test: 39 checks, 0 failures`. Also green:
`organization_read_test` (28), `schedule_hub_panel_test` (57),
`office_hub_panel_test` (89), `office_nav_and_profile_overlay_test`, and the
full suite before the commit.

## One trap worth keeping

The row's trailing facts are stacked two deep, not laid side by side. Laid
out horizontally, the widest sourcing tag (`UNKNOWN` + `FALLBACK`) pushed the
last fact off the row — so the fact vanished on exactly the rows the board
exists to be honest about. `row_cells` in both panels' `promotions_for_test()`
reads the MINIMUM cells drawn across rows and the test pins it.
