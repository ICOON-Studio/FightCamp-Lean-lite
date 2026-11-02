# U14 digest — the promotion that never says who it is

Branch: `cursor/u14-promotion-kind-identity-3774`

CHAMPIONS now prints the settled promotion's identity beside the belt board.

- `EntityPathway.kind_read()` once per rebuild, after the promotion is settled. Guard is `game_state.has_method("get_world_organization_by_id")`, same shape as `:169` on `get_promotions_read`. Never per row.
- The argument is the catalogue organization dictionary: world org via `get_world_organization_by_id(champ_promotion)`, then `OrganizationRead._kind_source` so the R70 whitelist does not strip the three kind fields. A promotions-read row (id/name/tier/rank) is never passed; that shape reads every promotion as discretionary / unknown / fighter_sponsors.
- Words, not enums: `mixed` → "published ranking and matchmaker", `house_kit` → "supplies the kit", `unknown` as a regulator VALUE → "—". UNKNOWN evidence still prints, marked with a MUTED UNSOURCED chip recessed onto TRACK. Never blank, never "none", never `0`.
- Absent read (`omit_kind_for_test`, missing method, empty org, unsanctioned): no Kind node, eight belt entries, list does not move.

Did not edit `HANDOFF.md` (task rule; set aside the general HANDOFF-block rule). Did not touch `DevelopmentPanel.gd`, `EntityPathway.gd`, `OrganizationRead.gd`, `GameState.gd`, `UIKit.gd`, `UITokens.gd`.

Parse gate 2/0. `rankings_hub_panel_test` 116/0. `organization_read_test` 38/0. `smoke_test` failures=0. Full suite **182/0**.
