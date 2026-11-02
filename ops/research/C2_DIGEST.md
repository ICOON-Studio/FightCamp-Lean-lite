# C2 Digest — event broadcast read API

## Delivered contract

`GameState.get_event_broadcast(event_id)` now returns one defensive,
read-only projection for an event-night consumer:

- event identity, promotion, scheduled week/day and promotion tier;
- card rows in broadcast order, with preliminaries first and the stored
  headline bout last;
- stable bout IDs, segment labels, both corner identities, dictionary records,
  gym names, weight class, title flag and player-bout flag;
- `{}` for unresolved results and the recorded winner/method/clock fields once
  settlement completes;
- award rows grouped from the settlement records already stored on the event;
- the player bout's persisted purse, win bonus, monetary clause payment,
  recorded award payouts and a total equal to those exposed parts;
- `{}` for an unknown event ID.

The method never calls `FightSimulation`, `WorldPopulation.advance_world`, or
any settlement method. Returned arrays and dictionaries are deep copies, so a
screen may annotate them without changing Career state.

## Running-order rule

`WorldPopulation` stores source cards with the headliner at index `0`, then the
co-main/open player slot, main-card bouts and undercard bouts. C2 reverses that
array for broadcast order and numbers rows from `1`. Source indices map to:

| Source index | Segment |
| --- | --- |
| `0` | `main` |
| `1` | `co_main` |
| `2..4` | `main_card` |
| `5+` | `prelim` |

## Honest storage limits

C2 does not manufacture facts that settlement does not preserve:

- Ordinary world bouts persist total `duration_seconds` but usually no round.
  Their API result therefore uses round `0` and formats the stored total
  duration as `M:SS`. Player bouts use C1 playback only to fill round/time fields
  missing from the event result; the event's stored winner and method always
  remain authoritative.
- Current award settlement stores flattened `{id, fighter_id, name, payout}`
  rows. C2 groups those fighter IDs by award ID. No opponent label is currently
  persisted, so `opponent` is an empty string unless a future settlement row
  explicitly records it.
- Current player settlement persists `gate_share`, but not its transient
  performance-bonus or expense values. `ledger.clauses` therefore exposes the
  persisted gate-share clause payment only. Older or otherwise absent values
  remain zero rather than being reconstructed from expired contract terms.

## Verification

`Godot/tests/event_broadcast_test.gd` creates an isolated Career and a six-bout
stored card with one player slot. It verifies unresolved and settled states,
one-based running order, prelim-first/main-last ordering, exactly one player
bout, result presence, dictionary records, grouped awards, each ledger part,
ledger arithmetic, unknown IDs and defensive-copy behavior.

- Static gate: `CHECK total=2 fails=0 autoload_refs=1`
- Focused Godot test: `event_broadcast_test: 56 checks, 0 failures`
- Full suite: `115` test scripts, `0` failures.

## Files

- `Godot/scripts/GameState.gd`
- `Godot/tests/event_broadcast_test.gd`
- `research/C2_DIGEST.md`
- C2 status block in `HANDOFF.md`
