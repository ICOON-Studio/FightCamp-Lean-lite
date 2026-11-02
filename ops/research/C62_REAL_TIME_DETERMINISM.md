# C62 — Can a real-time fight still replay?

## Decision

**Yes, with a hard qualification.** A fixed-step real-time fight can reproduce
the same new fight byte-for-byte from the same seed and authored inputs, but a
fixed step by itself is not enough. Simulation time must be an integer tick,
the number and order of ticks and random draws must be independent of render
frames, and authoritative accumulating values must be integer/fixed-point or
quantised at every tick boundary.

A core that repeatedly integrates unsnapped floats from variable frame
`delta` cannot meet a portable byte-exact replay contract. An input log does
not repair that: it replays the same inputs into the same unstable arithmetic.
If the intended contract spans machines, architectures, Godot builds or later
simulation versions and the builders will not accept quantised authoritative
state, the answer becomes **no** and the direction should go back to the
operator.

This finding does not mean that a new seed must reproduce the *old* atomic
fight. Continuous movement and damage change the causal model and therefore
the random draw schedule and outcomes. New-engine repeatability is achievable;
legacy seed-to-winner, event and scorecard identity is not honestly compatible
with a genuinely continuous resolution model unless the new core merely
emulates the old exchange outcomes.

## Evidence in the current implementation

- `FightSimulation.gd:95,399-514` derives `exchanges_per_round` by rounding
  `round_seconds / 14.0`. `advance_exchange()` resolves and appends one complete
  event, then increments that exchange counter (`:515-591`). A three-round,
  five-minute bout therefore has 21 exchanges per round, 63 total before a
  stoppage.
- `run_to_completion()` (`:865-873`) is exactly `begin_fight()` followed by a
  bounded loop over `advance_exchange()`. It has no renderer dependency and no
  elapsed-frame input.
- `begin_fight()` creates separate seeded RNG streams for exchange outcomes,
  judges, burst texture and optional consistency (`:405-496`). That separation
  is why optional presentation work can remain causally inert.
- `_build_fighter_state()` (`:879-1021`) contains categorical `range_band` /
  `preferred_band` state and fight counters, but no coordinates, facing,
  velocity or collision state. The only `position` field in this dictionary is
  `position_points_round`, a judging score, not geometry.
- `_write_burst()` (`:3174-3232`) is downstream of the resolved headline event,
  uses only `_burst_rng`, and writes a fixed five-field dictionary. Turning it
  off does not consume outcome RNG.
- `fight_simulation_test.gd:839-865` compares the outcome sequence for burst on
  and off, including damage formatted to six decimal places, plus winner and
  method. This is a strong same-build behavioral contract, though it is not a
  literal serialized-state comparison.
- `judge_panel_test.gd:141-153,245-263` pins ten rulesets' seeded cards to their
  pre-R38 values. These are legacy outcome fixtures, not merely replay-
  consistency checks.
- The current presentation host is atomic too: `FightNightScreen.gd:400-424`
  calls one `advance_exchange()` per Timer timeout, and its Timer interval is
  1.4 seconds (`:30,314-318`). Its test completion seam is bounded in exchange
  counts (`:738-798`).
- Active fight state is transient today. `FightNightScreen.gd:590-607` says the
  log dies with the screen after post-fight reads are extracted. Saved playback
  is deliberately compacted (`GameState.gd:9862-9875`). There is therefore no
  honest legacy mid-tick position to migrate.

## Q1 — What makes seeded replay survive

### The sufficient contract

For a given simulation version, initial snapshot, seed and ordered authored
inputs, replay is byte-exact when all of these are true:

1. The simulation advances through exactly `N` numbered ticks. Render rate,
   pause duration and speed multiplier decide only how quickly those ticks are
   requested, never which ticks occur.
2. The clock, cooldowns and scheduled actions are stored as tick numbers or
   integer tick counts. A frame-time accumulator is a host concern and is not
   authoritative replay state.
3. Positions, velocities, damage, stamina and other repeatedly accumulated
   values use bounded integer/fixed-point units, or are snapped to a declared
   grid after every tick. Quantising only when saving is too late because
   earlier float drift can already have changed a comparison or branch.
4. Iteration order is explicit. No random draw or collision winner depends on
   unordered dictionary traversal, node order, render callbacks or wall time.
5. Random work has a stable schedule. Presentation (`burst`) retains a separate
   stream and disabling it consumes no authoritative draws. Random branches
   added later either preserve the stream schedule or carry a simulation-
   version boundary.
6. The replay header identifies the simulation version, tick rate, seed,
   ruleset and initial fighter snapshots. Authored corner/control inputs are
   recorded against tick numbers.

This preserves the current `burst: false` guarantee in the new engine: burst
remains derived from an already-committed semantic event and cannot touch any
authoritative state or RNG stream.

### Where it breaks

- A variable-`delta` core is not replayable byte-exactly: different frame
  partitions produce different addition counts and collision times.
- A fixed tick with unconstrained accumulating floats is normally repeatable on
  one binary, but it is not a safe portable or archival guarantee. Platform,
  compiler, engine-version and math-library differences can move a value across
  a branch after thousands of operations.
- Recording inputs instead of state is sufficient only for the same deterministic
  simulation version. It does not protect against float drift or later code
  changes. For archival playback across versions, retain the versioned engine
  or record authoritative semantic events/snapshots as well.
- Saving the host accumulator creates avoidable ambiguity. Saving the integer
  tick and authoritative state is sufficient; the resumed renderer may start a
  fresh accumulator.
- Adding tick-level log events would break both byte shape and performance.
  Replay ticks and public semantic events are different grains.

## Q2 — Does the suite still run?

The current full-length 3x5 comparison is 63 atomic exchanges. Ignoring early
stoppages, a fixed-step core executes:

| Rate | Step | Ticks / 5-minute round | Ticks / 3x5 bout | Calls vs 63 exchanges | Per-tick cost needed to match current loop cost |
|---:|---:|---:|---:|---:|---:|
| 10 Hz | 100 ms | 3,000 | 9,000 | 143x | at most 0.70% of one current exchange |
| 20 Hz | 50 ms | 6,000 | 18,000 | 286x | at most 0.35% |
| 60 Hz | 16.67 ms | 18,000 | 54,000 | 857x | at most 0.12% |

Those ratios are the useful cost, not a wall-time prediction: a movement tick
can be far cheaper than today's full action selection, damage, logging,
analytics and judging exchange. It must be. Running today's exchange-sized
work every tick would make the suite roughly 143x / 286x / 857x slower.

The repository currently has 192 `tests/*.gd` scripts. A static call-site scan
finds 45 direct `run_to_completion()` sites across 13 files, and 151 direct
calls to `begin_fight` / `advance_exchange` / `run_to_completion` across 22
files. Loops make the runtime fight count higher than those source counts. As a
normalised lower-load illustration, only one full bout at each of the 45
completion sites would be 405,000 / 810,000 / 2,430,000 fixed ticks at
10 / 20 / 60 Hz, before loop multiplication.

The suite remains practical only if cheap integration ticks are separated from
expensive decisions, allocations, log emission and scoring. In particular,
the public log cannot grow from about 63 semantic rows to 18,000 rows at 20 Hz.
`run_to_completion()` must bypass rendering and drive the exact integer tick
count as fast as the CPU permits; it must not sleep and must not use a frame
accumulator.

### Candidate rate

The evidence supports **20 Hz** as the first measured candidate, not as an
irreversible core design choice. It gives 50 ms resolution, 18,000 maximum
ticks for a 3x5 bout, half the visible/control granularity of 10 Hz, and one
third the loop count of 60 Hz. A prototype must measure the full suite before
this becomes a commitment. If collision quality requires a finer physics
grain, that is evidence for 60 Hz; it is not evidence that decision, RNG,
logging and scoring work must also run at 60 Hz.

## Q3 — Migration and compatibility surface

### What can remain compatible

The new core can emit the existing semantic event dictionaries after resolving
continuous ticks. Keeping the current keys (`type`, actor/target, round,
outcome, damage, range, burst and chain fields), `scorecards`, `result` and
fighter summaries allows `PostFightRead`, `JudgePanel`, `ScorecardRead` and
playback consumers to keep reading the completed state.

An atomic compatibility wrapper is also possible: `advance_exchange()` can
drive fixed ticks until the next compatibility boundary and return the one
semantic event produced there, while `run_to_completion()` repeatedly drives
the same core with default inputs. The real-time host uses the fixed-step entry
point directly. This preserves old render-free callers without making the
atomic API the authority.

There is one exposed timing dependency. `BroadcastRead.gd:8,78-80` assumes
every measured action represents exactly 14 seconds. A variable-rate semantic
event log with the same keys would silently produce false per-minute numbers.
Compatibility therefore requires either:

- continued 14-fight-second aggregate rows (including a defined partial final
  interval), or
- an additive duration/tick-span field, with `BroadcastRead` using it and
  retaining 14 seconds only as a legacy fallback.

The latter is more truthful while remaining backward-readable; it changes the
shape additively, not destructively.

### What cannot remain identical

The old seed-to-event sequence and the ten pinned scorecards cannot generally
survive a genuine continuous damage/movement model. Preserving them would
require retaining the old 14-second outcome resolver as the causal authority,
which contradicts the operator's ruling that damage and movement resolve
continuously. The migration can preserve schema and repeatability, not old
outcome values. Rebaselining `judge_panel_test.gd` therefore needs explicit
operator approval; weakening or silently deleting the fixture is not a valid
migration.

Likewise, `advance_exchange()` may remain a wrapper, but tests must not mistake
it for the new core's timestep. The new contract needs direct assertions that
different render-frame chunkings produce the same tick sequence, final state,
semantic log, winner and method.

### Save migration

Existing saved bouts contain compact completed playback/result evidence, not a
live geometric fight. They can remain readable through legacy defaults and the
unchanged public event/result shape. There is no old mid-fight coordinate to
invent.

If mid-fight saving becomes a requirement, it is a new schema: persist the
simulation version, tick rate, current integer tick, quantised fighter/arena
state, pending authored inputs/decision, and the serialised state of every
authoritative RNG stream. Do not attempt to persist `RandomNumberGenerator`
objects or a fractional render accumulator as the contract.

## Test migration map

### Unavoidable new or changed coverage

- `fight_simulation_test.gd`: add fixed-step chunking equivalence, same-seed
  byte equality of the new authoritative state/log, replayed-input equality,
  save/resume equality, and burst-on/off equality. Its existing “one call
  appends exactly one log entry” test must be explicitly labelled as the
  compatibility-wrapper contract or changed if that wrapper is not retained.
- `broadcast_read_test.gd`: change/extend the 14-seconds-per-event assertions if
  semantic rows gain real tick spans; keep a legacy no-duration fallback case.
- `post_fight_read_test.gd`: add a completed real-time state so cards, result,
  range and broadcast still derive from the public event shape.
- `judge_panel_test.gd`: either remain byte-for-byte green if old outcomes are
  intentionally emulated, or receive an operator-approved rebaseline for the
  ten seeded cards. A real continuous model makes the second path likely.

### Tests coupled to one-call/one-exchange behavior

If `advance_exchange()` remains the atomic wrapper, these can stay as
compatibility tests. If it is removed or changes meaning, the directly coupled
tests that must change are `combo_chains_test.gd`, `combo_show_test.gd`,
`fight_combo_range_test.gd`, `fight_range_test.gd`,
`fight_simulation_test.gd`, `post_fight_read_test.gd`, and
`range_rail_test.gd`. `FightNightScreen`'s host-loop changes also flow into
`event_night_backend_test.gd`, `ring_stage_panel_test.gd`, `scene_router_test.gd`
and `smoke_test.gd`.

The broader direct API surface is 22 test files: the eleven above plus
`body_readiness_integration_test.gd`, `combo_training_test.gd`,
`fight_camp_test.gd`, `fight_opponent_generator_test.gd`,
`fight_plans_test.gd`, `fight_playback_test.gd`, `fight_scoring_test.gd`,
`scorecard_read_test.gd`, `setpiece_api_test.gd`,
`signature_battle_test.gd`, and `weight_cut_test.gd`. With the wrapper and
completed-state schema preserved, these are regression coverage rather than a
mandatory rewrite queue.

## Recommendation (separate from the finding)

Proceed to a measured 20 Hz prototype only if the builders accept the
determinism contract above. Keep simulation ticks integer and render-free,
quantise authoritative accumulating state, preserve isolated RNG streams,
retain `advance_exchange()` / `run_to_completion()` as compatibility wrappers,
and emit a bounded semantic log with explicit elapsed tick span. Treat old
seeded card values as an operator-owned compatibility decision, not something
the implementation can promise while also changing the causal model.

No tests were run for this research-only task.
