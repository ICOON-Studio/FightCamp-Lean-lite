# C62 digest

- **Finding:** seeded replay survives a fixed step only with integer tick time,
  frame-independent tick/draw order, and quantised or fixed-point authoritative
  state. Variable-`delta` floats do not satisfy portable byte-exact replay.
- **Cost:** a full 3x5 is about 63 exchanges today versus 9,000 / 18,000 /
  54,000 ticks at 10 / 20 / 60 Hz (143x / 286x / 857x loop counts). Start by
  measuring 20 Hz; keep decision, logging and scoring work off most ticks.
- **Migration:** the new core can keep the completed event/result dictionary
  shape and expose `advance_exchange()` plus `run_to_completion()` as atomic
  wrappers. `BroadcastRead` needs 14-second aggregate rows or an additive
  tick-span/duration field because it currently assumes 14 seconds per event.
- **Hard limit:** a genuinely continuous causal model can be deterministic
  without reproducing today's seeded winners/events/ten pinned scorecards.
  Rebaselining those values is an explicit operator decision.
- **Saves:** current live fight state/log is transient, so there is no legacy
  mid-fight geometry to migrate. Any live save is a versioned new schema with
  tick, quantised state, pending inputs and RNG states.
- No `.gd` or tests changed; no tests run.
