# Q81 — A FAILED STAND-UP SHOULD NOT WIPE THE CHOKE

Q75 option c. Owner: qwen. 2026-09-13.

## What changed

`_resolve_escape_attempt` in `FightSimulation.gd` used to clear both
submission attempts whether the stand-up succeeded or not. Now:

- **Stand-up succeeds** (phase flips to STANDING): both attempts cleared, as
  before. He is off the floor, the choke is gone.
- **Stand-up fails**: the escaper's own attempt is cleared (he abandoned it
  to scramble), but the OPPONENT's submission accumulator carries
  `FAILED_ESCAPE_CARRY` of its pressure forward instead of resetting to zero.

A new constant sits beside `SUBMISSION_SWITCH_CARRY`:

```gdscript
const FAILED_ESCAPE_CARRY := 0.7
```

Two different facts, two different constants. They are free to move apart.

## Why this exists

S1f (1) made the top man resist the stand-up roll. Stand-ups fell sharply
(MMA grappler 78 -> 56, MMA muay-thai 64 -> 45, BJJ 54 -> 29) and submission
lands rose (74 -> 110, 136 -> 206). **But submission finishes did not move.**
Peak pressure in the MMA grappler-v-striker matchup was 62.8 against a
threshold of 77.4 — never close. Every time the bottom man squirmed, even
unsuccessfully, the accumulator reset to zero.

## The sweep

`tools/measure_ground_seats.gd`, 40 seeded bouts per matchup, five values of
the new constant. Reporting the `methods` line (submission FINISHES, not
lands or peak pressure) and peak_pressure:

| carry | BJJ sub fin | MMA gr-app fin | MMA thai fin | judo sub fin | sambo sub fin |
|-------|:-----------:|:--------------:|:------------:|:------------:|:-------------:|
| 0.0   | 8           | 0              | 1            | 0            | 21            |
| 0.5   | 8           | 0              | 1            | 0            | 21            |
| 0.7   | 9           | 0              | 2            | 0            | 21            |
| 0.85  | 11          | 0              | 2            | 0            | 21            |
| 1.0   | 12          | 1              | 6            | 0            | 21            |

Peak pressure (highest accumulator value seen across all 40 bouts):

| carry | BJJ peak | MMA gr-app peak | MMA thai peak | judo peak | sambo peak |
|-------|:--------:|:---------------:|:-------------:|:---------:|:----------:|
| 0.0   | 92.0     | 62.8            | 77.3          | 0.0       | 93.2       |
| 0.5   | 92.0     | 70.4            | 79.2          | 0.0       | 93.2       |
| 0.7   | 92.0     | 73.5            | 80.3          | 0.0       | 93.2       |
| 0.85  | 92.0     | 75.7            | 81.2          | 0.0       | 93.2       |
| 1.0   | 92.0     | 78.0            | 83.4          | 0.0       | 93.2       |

## What does not move and why

- **Sambo: 21 finishes at every value.** Sambo has no escape node in the
  catalogue — 0 escapes landed, 0 stand-ups in 40 bouts. The carry path
  never triggers. If sambo ever moves, the change is reaching something it
  should not.
- **Judo: 0 submission lands at every value.** Judo ground is 100% engine
  fallback (`from_catalogue = false`), so `top_control = 0.0` and the
  escapes are all FALLBACK_ESCAPE. S1f (1) is deliberately gated off it.

## The chosen value: 0.7

0.7 is the highest value that keeps the MMA grappler at zero finishes and
the MMA-thai matchup at a modest +1. At 1.0 the MMA grappler crosses into a
submission finish it should not have (peak pressure 78.0 vs threshold 77.4 —
it barely clears), and MMA-thai jumps to 6 finishes in 40 bouts.

BJJ goes from 8 to 9 at 0.7 — one additional finish in 40 bouts. Modest.

## Tripwire

`FAILED_ESCAPE_CARRY = 0.0` reproduces the unmodified HEAD numbers exactly
(every row, every column). Verified before any other value was run.

## Tests

Parse gate: 0 fails. Focused: grapple 8/8, fight_simulation 1/1. Named
subsets: judge 1/1, smoke 1/1, fight_beat_defence 1/1, fight_stamina 1/1,
fight_log 1/1. Ring carries one pre-existing failure (fight_scoring_test —
judo uchi-mata ippon `19 >= 22`), technique carries one pre-existing failure
(fight_stage_technique_fidelity_test). Both fail identically on unmodified
HEAD.
