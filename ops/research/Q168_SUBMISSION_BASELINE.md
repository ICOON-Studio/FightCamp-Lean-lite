# Q168 Submission Baseline for TRAPS

The control arm: how submissions happen in the engine TODAY, before Grok's G72 trap design.
Two populations, 40 MMA bouts each, ground_arm OFF (`current`) and ON (`graph`).

## Summary

| Population | Arm | Bouts | Attempts | Finishes | Att/Fight | Fin/Att | Control-10s % |
|---|---|---:|---:|---:|---:|---:|---:|
| A: grappler(82) vs striker(34), 77 kg | current | 40 | 62 | 9 | 1.55 | 0.15 | 100.0% |
| A: grappler(82) vs striker(34), 77 kg | graph | 40 | 44 | 8 | 1.10 | 0.18 | 100.0% |
| B: brawler(55) vs kicker(28), 70 kg | current | 40 | 40 | 3 | 1.00 | 0.07 | 100.0% |
| B: brawler(55) vs kicker(28), 70 kg | graph | 40 | 25 | 4 | 0.63 | 0.16 | 100.0% |

## Attempts by Seat

### A: grappler(82) vs striker(34), 77 kg | arm=current

| Seat | Attempts | Finishes | Escapes |
|---|---:|---:|---:|
| back | 10 | 5 | 5 |
| mount | 52 | 4 | 38 |

### A: grappler(82) vs striker(34), 77 kg | arm=graph

| Seat | Attempts | Finishes | Escapes |
|---|---:|---:|---:|
| back | 2 | 0 | 2 |
| mount | 42 | 8 | 32 |

### B: brawler(55) vs kicker(28), 70 kg | arm=current

| Seat | Attempts | Finishes | Escapes |
|---|---:|---:|---:|
| back | 5 | 1 | 4 |
| mount | 35 | 2 | 27 |

### B: brawler(55) vs kicker(28), 70 kg | arm=graph

| Seat | Attempts | Finishes | Escapes |
|---|---:|---:|---:|
| mount | 25 | 4 | 24 |

## Escape Next Actions

### A: grappler(82) vs striker(34), 77 kg | arm=current

| Action | Count |
|---|---:|
| to_mount | 19 |
| pass | 20 |
| to_back | 4 |

Defender chose between two simultaneous threats: **0** (expect: 0 - that absence is the point).

### A: grappler(82) vs striker(34), 77 kg | arm=graph

| Action | Count |
|---|---:|
| to_guard | 21 |
| to_mount | 11 |
| to_back | 2 |

Defender chose between two simultaneous threats: **0** (expect: 0 - that absence is the point).

### B: brawler(55) vs kicker(28), 70 kg | arm=current

| Action | Count |
|---|---:|
| to_mount | 13 |
| sweep | 2 |
| pass | 12 |
| to_back | 4 |

Defender chose between two simultaneous threats: **0** (expect: 0 - that absence is the point).

### B: brawler(55) vs kicker(28), 70 kg | arm=graph

| Action | Count |
|---|---:|
| to_guard | 14 |
| sweep | 1 |
| to_mount | 8 |
| pass | 1 |

Defender chose between two simultaneous threats: **0** (expect: 0 - that absence is the point).

## Engine 'Why' Fields per Finish

The `submission_finish` event carries these fields a result screen could read:

- `actor` / `target` - winner and loser side labels
- `seat` - the ground seat (mount, back, side, guard, half, over_under)
- `technique` - the named hold (bjj_armbar, bjj_triangle, etc.)
- `hold_family` - HIGH / SIDE / OTHER classification
- `hold_id` - the specific hold identifier
- `finish_mode` - TAP (the only mode the engine has today)
- `attempt_start` - the tick the attempt opened
- `attacker_side` - which side was on top

No field records whether a trap was set, whether the defender had a
meaningful choice, or whether the escape path was foreclosed. The
engine offers a *what* (seat + technique + timing) but no *why*.

## Control Precedence

Share of submission finishes preceded by at least one `control` kind event
within 10 seconds. A high share suggests control gates finishes; a low
share suggests finishes open from scrambles.
