# NIGHTLY5B DIGEST (2026-10-13) - face_drawn_foe culprit: separation_strip_velocity

## Culprit switch
`separation_strip_velocity` - newly added to `DEMO_SWITCHES` by SWITCHALL1 (174f3a23).
Before SWITCHALL1 it was not in DEMO_SWITCHES, so the test's `engine_options()` did not
pass it to the fight engine (defaulted OFF). After SWITCHALL1 it is ON in the engine,
changing fight dynamics: fighters separate more cleanly after contact (inward velocity
stripped), stay further apart during whole takes, and the body's facing diverges from
the track.

## Root cause
`_toward_drawn_foe` in FightWorldLiveScreen.gd computes the drawn-foe aim as the actual
body-to-body direction rotated by the engine's bearing lag (angle from engine line to
engine forward). The lag is computed from the TRACK line, but applied to the DRAWN body
line. When `separation_strip_velocity` is ON, the body (frozen during a whole take) and
the track (which kept simulating) diverge. The lag compensation then rotates the drawn
direction by an angle appropriate for the track but wrong for the body, sending the body
further off than the engine forward alone.

## Fix
In `_toward_drawn_foe`: continuous slerp blend from engine_forward to lag-compensated
drawn direction, weighted by `clampf(dot / 0.5, 0.0, 1.0)`. Full compensation when the
drawn and engine lines agree within ~60 deg (dot >= 0.5), fading to engine forward at
>= 90 deg (dot <= 0.0). No hard switch, no visible snap.

## Numbers
Baseline (before fix):      FAIL face_drawn_foe: body-vs-drawn-aim p90 ON 41.2 < OFF 23.8
After NIGHTLY5B (hard cut): PASS face_drawn_foe: body-vs-drawn-aim p90 ON 15.0 < OFF 23.8
After FIX1 (slerp blend):   PASS face_drawn_foe: body-vs-drawn-aim p90 ON 13.8 < OFF 23.8

## Continuity (max frame-to-frame facing delta, ON arm, same bout)
NIGHTLY5B (hard cut): 90.56 deg  ->  FIX1 (slerp blend): 15.77 deg

## Binary search log
1. All 6 new DEMO_SWITCHES removed -> PASS (ON 3.4 < OFF 12.1)
2. separation_strip_velocity excluded alone -> PASS (ON 3.4 < OFF 12.1) - culprit named
3. Lag clamp to [-30, 30] deg -> no effect (ON 41.2, identical to baseline)
4. Agreement-based lag scaling (cosine blend) -> worse (ON 47.6)
5. Fallback to engine_forward when dot < 0 -> PASS (ON 15.0 < OFF 23.8)

## Tests
- face_drawn_foe: PASS (ON 13.8 < OFF 23.8)
- game_switches: PASS
- hold_pair_geometry: PASS (ON 0.461 < OFF 1.119)

## Owned files
- Godot/scripts/FightWorldLiveScreen.gd (_toward_drawn_foe fallback)
- research/NIGHTLY5B_DIGEST.md (this file)
