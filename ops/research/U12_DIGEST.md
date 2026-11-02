# U12 digest — the organization says what kind of thing it is

Branch: `cursor/u12-org-kind-fields-ae2f`

Three catalogue fields, C47/C49 tables, no invention. `unknown` is stored.

- `ranking_mode` `discretionary` | `published_criteria` | `mixed`. UFC is `mixed` with Meta weights UNKNOWN. IBJJF/UWW/IJF/WT are `published_criteria`. House boards with no published method store `discretionary` + UNKNOWN evidence. Never a formula.
- `regulator_kind` `athletic_commission` | `house_plus_officials` | `national_sport_authority` | `unknown`. GLORY/RWS/LUX/ROAD FC/Kunlun/IBJJF/UWW/IJF/WT keep `unknown`. Size and country did not fill those in.
- `outfitting_policy` `house_kit` | `fighter_sponsors`. UFC is the only sourced `house_kit` (DIRECT). The other twelve promotions are `fighter_sponsors` with UNKNOWN evidence. Federations/IBJJF keep the same enum as a non-card fallback (DOC).

Generated-market default (no catalogue row): `discretionary` / `unknown` / `fighter_sponsors`. **Defaults, not findings.**

`OrganizationRead.build` exposes all six kind/evidence keys in one read. WorldPopulation's whitelist does not copy these fields (R70 owns that file); the read overlays the catalogue by `catalog_id` via `FileAccess`/`JSON.parse_string`. No JSON conflict with R70 on this pass.

`Sponsorship` branches fight-night patch income on `outfitting_policy`. `house_kit` does not attach a fighter patch and never rolls `recent_fight_card`. No logos, no kit cheque.

Parse gate 5/0. `organization_read_test` 38/0. `sponsorship_test` failures=0. Full suite **179/0**. Did not edit `HANDOFF.md` (task rule; set aside the general HANDOFF-block rule). C51 can consume `regulator_kind`.
