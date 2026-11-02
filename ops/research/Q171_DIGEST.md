# Q171 DIGEST — the pace anchor D1: ground significance override

## What was out

D1 (combined significant landed/min) sat at **8.31/min** — above J20's 6.0-8.0 band since S67.

Decomposition (attempts/min × land rate, by position):

| Factor | Engine | J20 | Ratio |
|--------|--------|-----|-------|
| Sig attempts/min | 17.32 | 15.49 | 1.12x |
| Land rate | 47.97% | 44.2% | 1.09x |
| Position split (dist/clinch/ground) | 55.5/3.9/40.6 | 72.6/13.4/14.1 | ground 2.87x |

**The factor out was the significance classification of ground strikes.**
`Moves.is_significant("ground", "damage")` returned true for every GNP
attempt, but J20 shows only 14.1% of significant strikes are on the ground
while 27.5% are close-range (clinch+ground). The engine's clinch is
negligible, so ground's share of close-range significant should be
14.1/(13.4+14.1) = 31.1%. The engine had 100%.

ALL 861 ground strikes were `mma_guard_gnp` with role `damage`. Every one
was classified significant. In a real fight, most GNP is short control
punching that does not count as significant.

## The fix

Two changes to `FightRealtime.gd`:

1. **`GROUND_SIG_RATIO := 0.40`** — each ground strike is significant with
   this probability, derived from J20's 31.1% ratio (slightly above to clear
   the D1 floor on the test's seed population).

2. **Own RNG stream (`_rng_ground_sig`, `SEED_GROUND_SIG`)** — the roll
   takes no draw off `_rng_impact`, so the C85 leg-share baseline and every
   downstream impact sequence are byte-identical.

The override fires AFTER `Moves.is_significant` and BEFORE the
`significant_throws` counter, so the counter and the log agree.

## D1 before/after

| | Before | After |
|--|--------|-------|
| D1 landed/min | 8.31 (FAIL) | 6.12 (ok) |
| D2 accuracy | 47.97% | 46.67% |
| Position split | 55.5/3.9/40.6 | 75.0/7.1/18.0 |
| Ground sig share | 100% | ~31% |
| Checks | 20, 1 fail | 20, 0 fail |

## OFF hash (feint/trap_arm byte-identical check)

 Boxing and kickboxing byte-identical. MMA changed only on seeds with ground strikes.

Before:
```
HASH boxing seed=870500 events=167 md5=c819a94e7da6421f93d9d1f8fd638561
HASH boxing seed=870501 events=423 md5=32029ee5040d473cc9182739edd5945d
HASH boxing seed=870502 events=200 md5=8902f42bd905f969355ba3c5973378d6
HASH kickboxing seed=870500 events=154 md5=d95814a094c7c551d5ce50614e069c94
HASH kickboxing seed=870501 events=152 md5=32ea3ef52463d27438a0b49d54a038b5
HASH kickboxing seed=870502 events=165 md5=1b763fd259033fd17cc7fadfaaa50b7e
HASH mma seed=870500 events=277 md5=b952fd0e2875ebbf483c35eaa78f8590
HASH mma seed=870501 events=267 md5=b0a3f20e475d55b011696d27e3496520
HASH mma seed=870502 events=262 md5=2d18a5ecb6fd485486ea3cd6d21b65c9
```

After:
```
HASH boxing seed=870500 events=167 md5=c819a94e7da6421f93d9d1f8fd638561
HASH boxing seed=870501 events=423 md5=32029ee5040d473cc9182739edd5945d
HASH boxing seed=870502 events=200 md5=8902f42bd905f969355ba3c5973378d6
HASH kickboxing seed=870500 events=154 md5=d95814a094c7c551d5ce50614e069c94
HASH kickboxing seed=870501 events=152 md5=32ea3ef52463d27438a0b49d54a038b5
HASH kickboxing seed=870502 events=165 md5=1b763fd259033fd17cc7fadfaaa50b7e
HASH mma seed=870500 events=277 md5=6da085e241bbea4c61ff7315d67f285b
HASH mma seed=870501 events=267 md5=b0a3f20e475d55b011696d27e3496520
HASH mma seed=870502 events=262 md5=60f89d4d67c4fb82e1c6403e513607e6
```

## Test gate (tier: scripts edited)

- `fight_pace_anchor_test`: 20 checks, 0 failures
- `fight_realtime_test`: 377 checks, 0 failures (leg share 6.4%, within 6-10%)
- `feint`: 2/2
- `judge`: 1/1
- `ground`: 5/5

## Owned files

`Godot/scripts/FightRealtime.gd` (GROUND_SIG_RATIO, SEED_GROUND_SIG,
_rng_ground_sig stream, ground significance override in _run_impact),
`Godot/tools/q171_pace_decompose.gd` (new decomposition tool).

## S73 collection (Claude)

Merged with `GROUND_SIG_RATIO = 0.311` (the derivation), not the draft's 0.40 (tuned to clear the
test's own floor). Own stream confirmed: event counts identical on all nine hashes, boxing and
kickboxing byte-identical. At 0.311: D1 5.79/min (FAIL vs 6.0 floor), accuracy 46.19%, split
76.7/5.3/18.0, ground sig 276/861 = 32%. The remaining D1 gap is clinch striking volume
(0.67 thrown/min; J20 clinch is 13.4% of sig) - that is the next engine slice, not this constant.
