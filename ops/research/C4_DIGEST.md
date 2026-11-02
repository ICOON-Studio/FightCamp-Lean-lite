# C4 — Gym hub read API

`GameState.get_gym_hub()` now projects the gym, ordered roster, records,
readiness, weight, loyalty, plans, bookings, camps, floor/equipment users,
store, staff and aggregate counts. `get_fighter_flags(id)` centralizes the
profile's seven action-row conditions in red/amber priority order. Both are
deterministic and leave the Career unchanged.

Neutral values where the current save has no source: `gym.id = ""`,
`equipment.rotation = 0`, missing fighter sex/camp focus/next-bout event,
organization or opponent text = `""`, and missing title state = `false`.
Weight-class labels use the saved class; staff role falls back to saved
specialty. Plan labels join the saved non-rest weekly focuses.

Verification: parse gate 2/2; `gym_hub_test.gd` 41/41;
`profile_revamp_test.gd` and `smoke_test.gd` exit 0; full suite 118/118.
