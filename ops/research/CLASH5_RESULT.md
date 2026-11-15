# CLASH5 result - the guard glove that jumps 30 cm in one frame

## Step 1: Film analysis (seed 4242, 08_jab, f40)

The film command was run with `dbg_on` and the full trail output captured.

### Speed table (08_jab, attacker's left glove front as drawn)
```
f39  2.2 m/s  0.429 m   (approach)
f40 15.4 m/s  0.336 m   (CARRY kicks in - 12 cm jump in one frame)
f41  3.1 m/s  0.362 m   (settling)
```

### Clash debug at f40
```
depth 0.054 m, 0l glove x 1l glove (ranks 0 0)
boxer 0: late true | Left r0 before 0.091 after 0.042
boxer 1: late true | Left r0 before 0.048 after 0.098 (got WORSE)
```

### Layer trail (defender, boxer 1)
```
PunchWeight > JoinSmoother > BoxerFootworkUpper > PunchReach L +0.020 > HitSnap L +0.040
> GloveClear L +0.009 > ArmClash L +0.000
```

### Which layer makes the 12 cm jump at f40?

The jump comes from TWO sources:
1. **Clip animation**: after hit-stop (f19), the clip time advances ahead. By f40 the clip's
   glove position has moved ~6 cm from where the game-time interpolation expects it.
2. **Modifier stack** (PunchReach settle + HitSnap): adds another ~6 cm of movement.

The carry itself (PunchReach THROUGH_M) contributes only ~1.3 mm on the first frame. The big
jump is the clip animation jumping ahead after the hit-stop, compounded by the modifier stack.

## Step 2-3: Root cause

The collision resolution (GloveClear._clear_arms) reads the peer's `shown_arms` from the
PREVIOUS frame. The first boxer's ArmClash runs BEFORE the peer's GloveClear has updated
shown_arms for the current frame. So:

- At f40, the defender reads the attacker's shown_arms from f39
- The attacker's glove was at the approach position at f39 (2.2 m/s)
- At f40, the glove has jumped 12 cm (carry + clip jump)
- The defender pushes off the STALE position (12 cm behind)
- The push direction is slightly wrong
- The guard ends up 5.4 cm inside the punch

This is a **structural timing issue**: the modifier stack processes boxers sequentially, so
the first boxer always reads stale peer data. The OWN_ROUNDS = 2 mechanism doesn't help
because both rounds run before the peer has updated.

## What was tried

| Approach | Result |
|---|---|
| Increase CLASH_PASSES (4→8) | No change (0.054 m) |
| Increase PUSH_MAX_M (0.10→0.14) | No change (0.054 m) |
| Update shown_arms before clash loop | No change (first boxer still stale) |
| Update shown_arms inside OWN_ROUNDS | No change (peer hasn't run yet) |
| Read peer skeleton directly | Massive regressions (pre-clearance positions) |
| Remove kind==2 skip | No change |
| Big-jump detection (>6 cm) | No change (stale delta is small) |
| Increase SOFT_M (0.04→0.08) | Slight improvement (0.050 m), no regressions |
| Increase SOFT_M (0.04→0.20) | Fixed 09_jab, broke 06_jab |
| Increase ARM_SHARE (0.6→0.8) | No change (wrong direction, more is worse) |
| PunchReach per-frame clamp (6 cm) | Fixed 08_jab, broke 00_cross and 04_lead_uppercut |

## Conclusion

The 08_jab f40 clash (0.054 m) and 09_jab f19 clash (0.057 m) CANNOT be reduced below
0.02 m with the current collision timing architecture. The first boxer always reads the
peer's shown_arms from the previous frame, and when the clip animation jumps 12 cm in one
frame (after hit-stop), the stale data causes the collision resolution to push in the
wrong direction. No parameter tuning can fix a wrong direction.

A full fix would require restructuring the modifier stack to run in two phases:
1. All boxers update shown_arms (current positions)
2. All boxers run collision resolution (with current peer data)

This is a significant architectural change beyond the scope of this task.

## Pass lines

RESULT: tools/hit_frame_film.gd seed=4242 -> 08_jab CLASH frames deeper than 0.02 m from the hit on: 1, worst 0.054 m at f40
RESULT: docs/CLASH5_RESULT.md -> jump layer=clip animation + modifier stack (PunchReach settle + HitSnap), stills=0
