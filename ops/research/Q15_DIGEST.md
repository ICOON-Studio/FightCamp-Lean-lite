# Q15 Digest — FightIntent.gd

## What was built

`FightIntent.gd` — a pure static module that decides what a fighter is trying
to do each decision tick (2 Hz from TickBudget). Four intents: CLOSE, HOLD,
RETREAT, CIRCLE. The caller passes the roll; this module creates no RNG.

## Four static functions

1. `preferred_range(stats, reach_cm) -> float` — desired fighting distance in
   metres. Longer reach and higher technique extend it; higher power shrinks
   it. Clamped 0.4–2.0. Empty stats default to 50 per attribute.
2. `tolerance(stats) -> float` — how much slop around preferred still counts
   as "at range." Higher fight_iq → tighter. Clamped 0.1–0.6.
3. `decide(stats, distance, preferred, stamina, place, roll) -> String` — the
   decision. CORNER never yields HOLD. Too far → CLOSE dominant. Too near →
   RETREAT dominant. At range → HOLD dominant. Low stamina redistributes
   CLOSE weight into HOLD and CIRCLE. Roll selects from the weighted
   distribution deterministically.
4. `is_aggressive(intent) -> bool` — true for CLOSE only.

## Traps avoided

- **No RNG.** No `randf`, no `RandomNumberGenerator`, no `randomize`. The
  caller's seeded stream owns all randomness. Determinism is asserted in the
  test: same six arguments called twice return the same string.
- **Seven attributes only.** power, technique, speed, defense, conditioning,
  fight_iq, grapple. No eighth added.
- **Unrecognised place ≠ corner.** Treated as open floor. Unrecognised intent
  in `is_aggressive` returns false.
- **Edge cases clamped, not refused.** Roll outside 0–1, negative distance,
  stamina outside 0–100 — all clamped.

## Files

- `Godot/scripts/FightIntent.gd` — new, 57 lines.
- `Godot/tests/fight_intent_test.gd` — new, 87 lines, 40+ assertions.
- `research/Q15_DIGEST.md` — this file.

## Test results

Parse gate: pass. Own test: PASS. Full suite: fails=0.
