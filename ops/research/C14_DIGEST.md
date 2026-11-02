# C14 DIGEST — THE CREATION READ API

## Delivered

- `get_creation_markets()` exposes stable country rows for CreationChrome:
  economy, talent depth, combat popularity, labelled specialty values, city
  count, and gym count.
- `get_creation_city_board(country_name)` returns the country header and its
  city rows with rival-gym count/names, organizations, and scheduled events.
  It builds a deterministic throwaway `WorldPopulation` directly, so pre-career
  reads do not create, mutate, or save a Career.
- `get_creation_gym_take(country_name, city_name, gym_name)` exposes a starter
  floor, silhouette roster take, cash, used/total floor space, and upkeep.
  Its floor and roster generators use `gym_name` exactly as
  `finalize_new_career` does, so the preview is the saved gym.

## Verification

- Parse gate: 2/2 passed.
- Focused `creation_api_test.gd`: 20 checks, 0 failures. It verifies all reads
  begin/end with no active Career, unknown/empty inputs, and equality with a
  real finalized Career for the same gym name.
- `smoke_test.gd` reached its scene checks but failed when the sandbox denied
  writes to `user://`; this also caused its dependent save/world checks to fail.
- Full suite was attempted once through the required Git-Bash runner. It
  detached without returning a trustworthy final summary, so no suite pass is
  claimed.
