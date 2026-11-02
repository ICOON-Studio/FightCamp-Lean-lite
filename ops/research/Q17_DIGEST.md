# Q17 DIGEST — Cardio: a heart rate, not a bar

**Module:** `Godot/scripts/Cardio.gd` — 5 statics, zero preloads.
**Test:** `Godot/tests/cardio_test.gd` — 5214 checks, all pass.
**Suite:** total=203, fails=0.

## Design decisions

**from_stamina is not beats_per_minute(1.0 - stamina/100, ...).**
A full tank is not rest — fighting is hard work even fresh. Minimum fight
exertion is 0.55. Depletion adds strain through a sqrt curve (concave:
first half of tank raises rate faster than second, because by then the
fighter is already near ceiling). Conditioning is a direct strain
multiplier, not a curve exponent — a fit fighter reads lower at every
tank level but the shape of depletion does not change.

**max_bpm:** 220 - age, floored at 60 (highest possible resting rate).
**resting_bpm:** 60 - 20 * (conditioning/100), range 40..60.
**beats_per_minute:** resting + (max-resting) * pow(exertion, exponent),
exponent = 1.0 + 0.6 * (conditioning/100).
**zone:** authored cut points at 70%, 80%, 90% of max. Four words:
RECOVERY, AEROBIC, THRESHOLD, RED LINE.

**NAN/INF:** all resolve to the calm end — lowest possible bpm, never
alarming. Broken inputs default to age 18, conditioning 100, exertion 0,
stamina 100.

**Bounds:** beats_per_minute and from_stamina are clamped to
[resting_bpm, max_bpm] for all inputs including out-of-range.
