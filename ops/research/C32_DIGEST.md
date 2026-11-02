# C32 DIGEST — THE CORNER, ONE RULE

C32 landed one organization-independent corner rule: three seconds, a required chief second, a permitted cutman within the three, referee stoppage authority, and an explicitly absent corner fee. `CornerRulesRead` loads the five-key data block into copy-safe `value` / `source` / `why` entries; `GameState.get_corner_rules_read()` exposes the read without changing simulation or UI.

Verification: parse gate 3/3; `corner_rules_read_test.gd` 14 checks, 0 failures; full `smoke_test.gd` exit 0 with Godot 4.7.2.
