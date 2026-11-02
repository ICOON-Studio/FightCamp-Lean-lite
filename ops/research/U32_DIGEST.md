# U32 Digest — BroadcastRead learns the grapple

## What landed

`BroadcastRead.build(log)` folds `type == "grapple"` per side as **counts**:
takedowns, throws (separate), submission_attempts, submissions_finished,
clinches, control_units. `grapple_measured` is true when any grapple event
exists in the log; otherwise every grapple print is an em dash.

No `takedown_pct`. No `control_seconds` from units.

## Control

Units are the engine's weighted integral (RealtimeRoundStats: 1 for
half/clinch, 2 for dominant). G38 §3: duration ≠ that integral. Printed as
`control_units`. Seat time omitted — `_seat_ends` pairing left to
RealtimeRoundStats; two pairings of one log would be worse than none.

## Zero vs dash

- No grapple events → unmeasured (—). Boxing never writes the stream;
  `build()` cannot see `FightRealtime.grappling`, so this is also the answer
  for a grappling bout that somehow logged nothing.
- Any grapple event → measured; a side that never shot prints `0`.

## Engine finding

R91 finishes with `kind == "submission_finish"`, not `finished == true` on
`submission_attempt`. Both are counted.

## live_line

Striking-only unchanged. When grapple is measured: append `FLOOR` if the
last seat is ground/clinch, else `TD <n>`.

## Gate

parse 2/0 · broadcast_read_test 143/0 · setpiece_panels_test 0 fail ·
`SUITE total=219 fails=1` (ceiling ≤1; sole red is
`grapple_clinch_contract_test.gd`, C73 blind until R93 — not ours).
