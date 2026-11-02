# C37 Digest — The Former Read

- Added copy-safe `get_former_fighters()` and `get_former_fighter(id)` projections over stored retirement rows, `FormerRoles`, and the career epilogue.
- Missing licence and head-trauma gates remain unknown: they are never defaulted to `false`, and the FORMER row prints no false clearance.
- The FORMER tab now reads the projection, shows the stable role label, preserves newest-first order, and still routes by `athlete_id`.
- Verification: parse 2/2; focused tests `office_former` 14/0, `office_hub_api` 28/0, `office_hub_panel` 89/0, `former_roles` 0 failures; full suite 156/156 scripts green.
