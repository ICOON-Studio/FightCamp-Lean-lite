# C6 Digest — FIGHTER CARD read API

`GameState.get_fighter_card(athlete_id)` now returns one stable projection for
the kit fighter card: identity, current ratings, record, next bout, week plan
and offers, flags, goals, titles, division ranking, loyalty/request, awards,
weight, camp, contract, fight log, and both clearance decisions.

All existing getters run against a deep-copied Career, including the offer and
lazy-migration paths; the live Career is restored before the result returns.
Unknown ids return `{}`. World fighters return `identity.roster = false` and
keep every roster-only region present but empty.

Verification: parse gate 2/2; focused fighter-card contract 45/45;
`profile_revamp_test.gd` and `smoke_test.gd` exit 0; full suite 120/120.
