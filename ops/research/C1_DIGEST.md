# C1 — fight-night playback data

## Public contract

`GameState.get_fight_playback(bout_id: String) -> Dictionary` returns a
defensive, read-only projection for a settled live bout:

- `rounds`: chronological round rows with authored `moments`; each moment has
  `text`, `big`, `who`, and one of `knockdown`, `hurt`, `takedown`,
  `submission_attempt`, `finish`, or `plain`. Each round also carries its own
  six-region condition snapshot for timeline consumers.
- `condition`: the latest round-end condition keyed by both athlete IDs, with
  `head`, `torso`, `left_leg`, `right_leg`, `arms`, and `core`, all `0..100`.
- `result`: `winner_id`, method, round, `M:SS` clock, and a `0.0..5.0` quality
  rating derived from finish type, total knockdowns, and competitiveness.

Unknown IDs and legacy fights recorded before C1 return `{}` because no real
playback evidence exists for them.

## Data flow

`FightSimulation` already owned the exchange log and live six-region body
state. C1 captures body condition once per completed or interrupted round and
exports defensive copies of those existing values in `finalize_result()`.
`record_live_fight_result()` strips transient event fields, freezes the compact
source into the settled career fight-log row, and the accessor projects it
without re-running or estimating a fight.

The same trace exposed a clock edge case: a finishing exchange happened before
`exchange_in_round` incremented and could show `0:00`; a doctor/technical
stoppage reached after scoring could count its full round twice. Duration now
includes the finishing exchange only when the current round has not already
been scored.

## Files

- `Godot/scripts/FightSimulation.gd`
- `Godot/scripts/GameState.gd`
- `Godot/tests/fight_playback_test.gd`

No screen, UIKit, manifest, catalog, or generated-metadata file changed.

## Verification

- Parse gate: 5 integrated C1/G7 files, 0 failures.
- `fight_playback_test.gd`: 39 checks, 0 failures.
- `fight_log_test.gd`: 15 live and mapper checks, 0 failures.
- `fight_simulation_test.gd`: 203 checks, 0 failures.
- `body_readiness_integration_test.gd`: full live settlement path, 0 failures.
- Repository-wide suite: 112/112 test scripts passed, including
  `smoke_test.gd` (Godot 4.7.2 headless).
