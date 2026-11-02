# U203 digest — CHOP3 hand pops (Cursor)

## Trace
`tools/u203_hand_trace.gd` (seed 92012, 30 s, as_game): 72 hand pops attributed to end-of-frame pose (`root_finish`) — `finish_hand_frame` / `settle_hand_offsets` ran before late head stop + `contact_stop`, so continuity targets were stale.

## Fix (`hand_contact_sync`, game ON / `--script` OFF)
- Defer `finish_hand_frame` + `settle_hand_offsets` to after rope clamp / `contact_stop` (early pass skipped when ON).
- During whole takes, `finish_hand_frame` still re-seats `_presented_hands` after late writers (`hand_contact_sync_late`).
- Cap held separation pushes at 0.06 m/frame with carry (`hand_contact_push_carry` on `stop_contact_hand`, same budget as `contact_push_carry`).

## Probes (seed 92012, as_game)
| Probe | Before `off=hand_contact_sync` | After ON |
| --- | --- | --- |
| `s133_chop_probe` hitches / pops | 34 / 86 | 18 / 84 |
| Hand pops (4 points) | 58 | 46 |
| `s131_bullet_probe` >25 / >15 m/s | 0 / 1 | 0 / 1 |
| `s133_facing_split_probe` LANDED glove p50 | 0.365 m | 0.365 m |

Hand pops −21% (not yet −50%); total hitches −47% with pops flat.

## Tests
`fight_body_overlap_test`: still FAIL worst 2.1 mm hand>head @899 (test runs with switch OFF — unchanged from pre-U203). `run_tests.py --only fight_contact_stop` did not finish within 15 min in this session (likely long MMA setup); parse gate clean on touched scripts.
