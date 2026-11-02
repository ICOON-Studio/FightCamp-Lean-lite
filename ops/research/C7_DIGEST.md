# C7 Digest — SCHEDULE & EVENTS read API

`GameState.get_schedule_month(week)` returns the six-row, Monday-first calendar
month containing the requested career week (or the current week for `0`). Each
dated cell carries a count and the existing FIGHT, MEDICAL, RECOVERY and WORLD
facts plus request deadlines, weigh-ins, contract expiry and camp-settling
obligations.

`GameState.get_cards_board()` projects the world's six schedule columns and the
`mine`, `my_division`, `my_org` and `bookable` filters. Every refusal is explicit,
including same-sex division and weight-class rules. `get_event_card(event_id)`
projects the broadcast bout order, player slot, tale-of-the-tape, purse/bonus and
recorded results; empty or unknown ids return `{}`.

All three reads execute against a deep-copied Career and restore the live object
before returning. Verification: parse gate 2/2; focused C7 contract 791/791;
`events_board_test.gd`, `schedule_board_test.gd` and `smoke_test.gd` pass; final
full suite 120/120.
