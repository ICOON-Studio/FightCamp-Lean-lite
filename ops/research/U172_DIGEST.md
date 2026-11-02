# U172 digest — defence_model slice 1 (pass 2 gate)

## Switch
- `defence_model` option, default **OFF** — byte-identical OFF path.

## Module
- `FightDefenceModel.gd`: perceive (tell + speed/IQ/fatigue), choose (block/evade/reduce + height), execute (timing + evade vs strike speed), consequence (opening flag, block stamina). `slice2_anticipate_counter_reserved()` hook only.
- `FightMoves.gd`: `GUARD_HEIGHT_*` constants.

## Pass 2 gate (rebased on `origin/master`, parse gate 5/5)
| Subset | Result |
|--------|--------|
| `fight_defence_model` | 1/1 pass |
| `fight_realtime` | 1/1 pass |
| `feint` | 2/2 pass |
| `judge` | 1/1 pass |
| `fight_pace` | **1 fail** — `fight_pace_anchor_test` D1 pooled **5.79/min** (anchor 6.0–8.0); **same failure with U172 scripts reverted to `origin/master`** (not introduced by defence_model) |
| `fight_hit` | 2/2 pass |

## Measurement (`u172_defence_measure.gd`, 64 bouts/arm)
Population: MMA grappler vs striker; boxing out-boxer vs pressure fighter (legal, non-identical).

| Arm | model | def_rate | D1/min | read_ok | read_none | wrong_h | block_ok | evade_ok | family B/E/R | timing e/r/l |
|-----|-------|----------|--------|---------|-----------|---------|----------|----------|--------------|--------------|
| mma | OFF | 0.529 | 6.24 | — | — | — | — | — | — | — |
| mma | ON | 0.473 | 6.96 | 3159 | 6315 | 398 | 1003 | 860 | 1401/1073/685 | 320/431/252 |
| boxing | OFF | 0.535 | 5.82 | — | — | — | — | — | — | — |
| boxing | ON | 0.476 | 6.37 | 4356 | 8962 | 452 | 1579 | 1242 | 2031/1395/930 | 505/715/359 |

Pooled MMA ON (test fixture, 64 bouts): def_rate **46.7%** (45–65%); zone landing head **0.528** < body **0.538** < legs **0.546**; D1 **6.99/min** (6.0–8.0). Rate emerges from read + family + height + timing tallies, not a single tuned probability.

## Tests
- `fight_defence_model_test.gd`: 16 checks, 0 failures (`run_tests.py --only fight_defence_model`).

## OFF hashes (`s70_feint_off_hash.gd`, `defence_model` off) — matches `origin/master` before/after U172
```
HASH boxing seed=870500 md5=c819a94e7da6421f93d9d1f8fd638561
HASH boxing seed=870501 md5=32029ee5040d473cc9182739edd5945d
HASH boxing seed=870502 md5=8902f42bd905f969355ba3c5973378d6
HASH kickboxing seed=870500 md5=d95814a094c7c551d5ce50614e069c94
HASH kickboxing seed=870501 md5=32ea3ef52463d27438a0b49d54a038b5
HASH kickboxing seed=870502 md5=1b763fd259033fd17cc7fadfaaa50b7e
HASH mma seed=870500 md5=26a6521e92c2d3248fcc8ba7a8cf3637
HASH mma seed=870501 md5=b0a3f20e475d55b011696d27e3496520
HASH mma seed=870502 md5=f94bff866454a9ff66a5fe51e2c94919
```
