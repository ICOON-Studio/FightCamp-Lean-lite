# U33 Digest — PostFightRead learns the grapple

## What landed

`PostFightRead.build()` adds `grapple`, fed only from `BroadcastRead` after
U32. No second fold of the log. Counts are the broadcast `printed` strings
(em dash when unmeasured, `0` when measured and idle).

## Narrative (= “owned the pocket”)

`line` priority: submission finish → unfinished attempt (threat) →
`control_units` owner (“A owned the floor”) → shared control → takedown/throw
edge → “nobody took control”.

Fields: `measured`, `line`, `control_owner`, `ended_on_floor` (mirrors
`broadcast.on_floor`), `submission_threat`, `submission_finish`, side bags.

## Boxing / unmeasured

Key always present (additive empty contract). **`measured=false` and empty
`line`** — the card omits the block. Six em dashes under a boxing bout were
refused. `phase_change` alone does not measure.

## Refused

- Seat-time / “decided on the floor” from duration (U32 left seat pairing out;
  `ended_on_floor` is last stance only).
- `takedown_pct`, `control_seconds`, any rate without a log denominator.

## Gate

parse 2/0 · post_fight_read_test 37/0 · setpiece_panels_test 0 fail ·
`SUITE total=221 fails=3` (ceiling was ≤2; the three reds are
`grapple_adapter_contract_test`, `grapple_adapter_test`,
`grapple_clinch_contract_test` — none ours; concurrent GrappleAdapter WIP
in the tree. Named, not fixed.)
