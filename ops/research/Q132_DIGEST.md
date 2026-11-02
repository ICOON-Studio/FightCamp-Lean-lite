# Q132 DIGEST - Capsule Census: Every Capsule, Every Rig

## Population

- **12 rigs**: f01-f12, all `*_rigged.glb` under `res://assets/models/fighters/`
- **Target heights**: from `FighterPhysique.reference_height_m(class_limit, sex)` via `CaptureFighterRoster.ROSTER`
- **15 capsules** per rig from `FighterCapsules.CAPSULE_DEFS`
- **180 capsule-rig pairs** total
- **Hand radius**: each rig's own `forearm_r` radius, range 0.0396-0.0765 m
- **Stature range**: 1.619 m (f03 flyweight female) to 2.020 m (f10 bare heavyweight)

## The two numbers

1. **Ball ratio** = `r / segment_length`. Over 0.5 means the capsule is wider than half its length - a sphere, not a capsule.
2. **Self-exposure %** = fraction of 320 surface samples (20 along x 16 around) where a hand of radius `forearm_r` can touch without entering any other capsule of the same body.

## Per-capsule-type summary (averaged across 12 rigs)

| Capsule       | Avg ball ratio | Avg exposed % | n_ball (>/=0.5) | n_buried (<10%) |
|---------------|---------------|---------------|-----------------|-----------------|
| neck          | 0.909         | 0.0%          | 12              | 12              |
| head          | 1.261         | 52.6%         | 12              | 1               |
| shoulder_span | 0.136         | 0.0%          | 0               | 12              |
| pelvis        | 0.826         | 89.3%         | 12              | 0               |
| thorax        | 0.613         | 60.5%         | 12              | 0               |
| foot_l        | 0.519         | 78.3%         | 8               | 0               |
| foot_r        | 0.480         | 69.6%         | 3               | 0               |
| upper_arm_l   | 0.302         | 93.0%         | 0               | 0               |
| upper_arm_r   | 0.300         | 93.0%         | 0               | 0               |
| femur_l       | 0.278         | 67.4%         | 0               | 0               |
| femur_r       | 0.276         | 67.3%         | 0               | 0               |
| forearm_l     | 0.216         | 74.2%         | 0               | 0               |
| forearm_r     | 0.220         | 74.6%         | 0               | 0               |
| shin_l        | 0.200         | 58.0%         | 0               | 0               |
| shin_r        | 0.202         | 62.0%         | 0               | 0               |

## Pooled summary

- **59 of 180** (32.8%) have ball ratio > 0.5
- **25 of 180** (13.9%) have exposure < 10%
- **13** are BOTH ball AND buried

## Verdict: NOT a lone outlier, but not systemic either - THREE distinct populations

### 1. Balls that are fine (high exposure despite high ball ratio)
- **pelvis** (0.83 ball, 89% exposed): a ball, but sits at the base where it is mostly reachable
- **head** (1.26 ball, 53% exposed): always a ball, but sits on top so most of its surface is reachable
- **foot_l/r** (~0.50 ball, 74-78% exposed): borderline, mostly exposed

These prove the ball ratio alone does NOT predict exposure. A capsule can be a sphere and still be grippable.

### 2. Balls that are unreachable (0% exposed on ALL 12 rigs)
- **neck** (0.91 ball, 0% exposed): buried by thorax on every rig. The neck is a short segment with an authored 0.055 m radius, and the thorax's cap reaches past it.
- **shoulder_span** (0.14 ball, 0% exposed): NOT a ball, but buried by thorax by construction - a cross-body capsule passes through the chest. This is the adjacency declaration doing its job.

### 3. The thorax is in between
- **thorax** (0.61 ball, 60.5% exposed): always a ball across all 12 rigs, but 60% of its surface is reachable. It is NOT the worst offender - the neck is.

## What this means for S48

The thorax is **not a lone outlier** - the neck is worse (100% buried vs 60% exposed). But the derivation is not wrong in several places either: most balls (pelvis, head, feet) are fine.

**The fix is local to the trunk**: the neck and the thorax share an adjacency declaration, and the thorax's radius pushes past the neck's segment. Narrowing the thorax (Q131's finding) would expose the neck as a side effect. The neck's own authored radius (0.055 m) on a 0.05 m segment is also a ball by construction and may need its own adjustment.

The limbs, femurs, shins, and forearms are all well under 0.5 and well exposed. The derivation is sound there.

## Files

- `Godot/tools/q132_capsule_census.gd` - the census tool (new)
- `research/Q132_DIGEST.md` - this file

## Gate

- Parse gate: `CHECK total=1 fails=0`
- Test gate: `SUITE total=2 fails=0` (capsule tests, no ERROR lines)
