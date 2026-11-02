# Q131 DIGEST — thorax sensitivity probe: is the live overlap the same capsule defect?

**Answer: YES. S47 and Q130 are ONE bug.**

## What was tested

Two censuses on seed 810039, discipline=mma, 900 frames, same fighters, same
catalogue. The ONLY difference: the `Chest-UpperChest` (thorax) capsule radius
scaled to 55% of its p80 value. This is a PROBE, not a derivation.

- Fighter A thorax: 0.1724 → 0.0948 m (x0.55)
- Fighter B thorax: 0.1114 → 0.0613 m (x0.55)

## Per class-pair results (control | probe)

| class pair  | ctrl frames | ctrl p50 | ctrl p90 | ctrl max | probe frames | probe p50 | probe p90 | probe max |
|-------------|-------------|----------|----------|----------|--------------|-----------|-----------|-----------|
| torso>leg   | 4           | 0.1031   | 0.2060   | 0.2080   | 0            | —         | —         | —         |
| torso>foot  | 4           | 0.0988   | 0.1790   | 0.1838   | 0            | —         | —         | —         |
| arm>leg     | 5           | 0.0791   | 0.1651   | 0.2019   | 0            | —         | —         | —         |
| arm>foot    | 4           | 0.0782   | 0.1113   | 0.1224   | 0            | —         | —         | —         |
| head>leg    | 3           | 0.0681   | 0.0756   | 0.0773   | 0            | —         | —         | —         |
| head>foot   | 3           | 0.0423   | 0.0509   | 0.0531   | 0            | —         | —         | —         |
| foot=foot   | 37          | 0.0528   | 0.0661   | 0.0749   | 17           | 0.0715    | 0.0986    | 0.1114    |
| leg=leg     | 7           | 0.0339   | 0.0556   | 0.0580   | 44           | 0.0602    | 0.1053    | 0.1330    |
| leg>foot    | 5           | 0.0766   | 0.1329   | 0.1506   | 8            | 0.0618    | 0.0722    | 0.0735    |

## Refused-pair verdict

- Control refused frames: **11** (4 involving torso = 36.4%)
- Probe refused frames: **44** (all leg=leg, none torso)
- Control refused frames that survive in probe: **0 (0.0%)**

The narrower thorax removes ALL torso-related refused overlap. Every control
refused frame is gone in the probe. But the probe creates NEW refused frames
(leg=leg explodes from 7 → 44) because the bodies can now get closer without
the over-wide thorax pushing them apart.

## What this means

The 0.197 m `torso>leg` from Q130 IS the same defect as S47's over-wide thorax
capsule. The thorax p80 includes deltoid skin, making it wider than half its
segment length. Narrowing it to a chest-depth probe value removes all the
torso-related refused overlap.

The fix for S47 (correcting the thorax radius derivation in FighterCapsules)
will also fix Q130's refused overlap. But the fix must account for the
cascading effect: narrower torso → bodies get closer → more leg=leg overlap.
The leg=leg allowance needs to be part of the same fix.

## Test results

- Parse gate: PASS (0 fails)
- `--only overlap`: 1/1 FAIL (fight_body_overlap_test — RED on purpose from Q130)
- `--only body`: 8/9 pass, 1 fail (same fight_body_overlap_test)

## Files

- `Godot/tools/probe_overlap_census.gd` — extended with control+probe arms
