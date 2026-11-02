# TASK_C194 - a BLIND contract test for the gym market (Codex, test only)

Model: gpt-5.6-luna, medium (contract test, not motion). Owner: codex. Assigned S69, 2026-09-24.

## Why
S69 shipped THE GYM MARKET, slice one (Grok G74): a gym's weekly member target is no longer a function of the gym alone -
it is a SHARE of its city's pool, split with the city's rival gyms by attractiveness, and a floor crowded past its stations
trains the fight team worse. Claude wrote its test against Claude's own implementation, so it only ever agrees with it. A
test written from the DEFINITION alone, by a second hand that has not seen the code, finds defects in the contract (C142,
C152, C192, C193). **DO NOT OPEN `Godot/tests/gym_market_test.gd`, `Godot/tools/s69_market_probe.gd`, `research/S69_DIGEST.md`,
or the S69 commits' diffs, and do not read the bodies of the S69 functions listed below.** You may read
`research/G74_THE_GYM_MARKET.md` (sections 4.1, 4.2, 4.4 and "Smallest first slice"), `Godot/assets/data/membership.json`
(the data IS part of the contract), `Godot/tests/membership_test.gd` lines 1-60 (how to boot and fixture a career), and
`Godot/scripts/Membership.gd` lines 1-154 (the pre-S69 module) - nothing below line 154.

## The definition (test THIS - it is the contract; a failure against the shipped code is a candidate defect)
The operator, verbatim (2026-09-24): "how can we link income according to the equipment on the gym? Like ... the current
equipment attract that many customers. So the gym has income from that. And the motive to put more equipment and expand the
gym ability to train more fighters."

1. `Membership.city_pool(city_gym_count: int, combat_popularity: int) -> int` - D. The band is picked from the city's gym
   count by `city_pool_mid_from_gyms` / `city_pool_large_from_gyms` and `city_pool_bands`, then multiplied by
   `combat_mod_base + combat_mod_per_popularity x popularity` (popularity clamped 0-100), rounded.
2. `Membership.attractiveness(scores: Dictionary) -> float` - the sum over `coach`, `facility`, `kit`, `reputation` of
   `attractiveness_weights[key] x clamp(score, 0, 100)`; a missing key reads 0.
3. `Membership.player_scores(coach_count, gym_tier, room_tier, station_capacity: float, reputation) -> Dictionary` and
   `Membership.rival_scores(rival: Dictionary) -> Dictionary` - 0-100 scores built with the `score_note` rules in the data.
   A rival (a WorldPopulation gym: `facility_quality`, `reputation`, `coach_ids`) scores its facility_quality for BOTH
   facility and kit.
4. `Membership.market(pool: int, player: Dictionary, rivals: Array) -> Dictionary` with at least `pool`, `share`, `target`,
   `attractiveness`, `rivals` (each row `id`, `name`, `attractiveness`, `share`, `members`). share = A_player / sum of all A;
   the player's share plus every rival's share is 1; `target` = round(share x pool) clamped to `max_members`; alone in a city
   the player's target is the whole pool (capped).
5. `Membership.crowd_ratio(fighters_training: int, members: int, station_capacity: float) -> float` =
   (fighters + members x `crowd_peak_fraction`) / max(capacity, 1). `Membership.crowd_yield_factor(ratio) -> float` is 1.0
   at or under 1.0, and `1 - crowd_yield_slope x (ratio - 1)` clamped to [`crowd_yield_floor`, 1] above it.
6. LIVE (GameState): `get_floor_station_capacity() -> float` is the floor's sum of `station_capacity x condition/100`.
   `get_membership_market() -> Dictionary` is `market()` on the live career plus `city`, `station_capacity`, `crowd_ratio`,
   `crowd_yield`. The weekly settlement (`_settle_billing(payroll, upkeep, next_week)`) sets `career.membership.target` to
   that market's target unless a test override pins one, and stores the read at `career.membership_market`.
7. THE SINK: a fighter's training stat gain (`_apply_focus_stat_gains(athlete, station, coach_rating, fraction)`) is
   multiplied by `crowd_yield_factor(crowd_ratio(active_training_count, members, station_capacity))` - so with nothing else
   changed, more members on the floor can only lower the gain, and never below `crowd_yield_floor` of the uncrowded gain.
8. THE READ: the office ledger's `membership_dues` line (`GymLedgerRead.build(career)`) names the share, the city and the
   pool once a settlement has run, and still says the numbers are invented.

## Fixtures
A real career (`begin_new_career`, `generate_starter_boxing_floor`, `finalize_new_career`) in at least TWO cities of
different size bands (e.g. a 1-gym city and a 4+-gym city from `assets/data/world_regions.json`). Rivals must DIFFER from
each other and from the player - never two identical gyms as a "control".

## Owned files
A NEW `Godot/tests/gym_market_blind_test.gd` and `research/C194_DIGEST.md`. Nothing else.

## Gate (tier: a new test file only)
`python Godot/tools/check_scripts.py Godot/tests/gym_market_blind_test.gd`, then ONE run:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_market_blind_test.gd` (exe in
`%LOCALAPPDATA%\Programs\Godot\`). Prove it with at least 5 throwaway mutants of the shipped code (you may EDIT
`Membership.gd` below line 154, or the S69 lines in GameState.gd, blind - flip a sign, drop a term - WITHOUT reading beyond
the edit site, and revert every one); report each mutant's FAIL count. `GameState.gd` is ~15,000 lines - NEVER open it whole;
`grep -n` for `get_membership_market`, `get_floor_station_capacity`, `crowd_factor` and read only the edit site. No full suite.
Branch `codex/c194-blind-gym-market-test` off `origin/master`. Commit with explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C194 --body "<checks, failures, each mutant and its FAIL count, any contract disagreement>"`.
Do NOT edit HANDOFF.md, and do NOT read HANDOFF.md, CURRENT_STATUS.md or any digest.

## The one trap
A failure against the shipped code is a RESULT, not something to fix by bending the test: keep the assertion, say so in the
digest and the mail, and let Claude judge which is wrong. And check your fixture before you believe a failure: C193's two
"defects" were a `laceration` built on a leg (Injury.build returns `{}` for a region its type does not allow) and a node
path assumed to be a direct child.
