# Q220 - the neck of the shipped MPFB men is buried by the chest capsule (KM3 fix)

## Status: BLOCKED - geometric incompatibility measured

## Failing lines (before)
```
ERROR: mpfb_m_178 neck 0.15 has no usable approach
ERROR: mpfb_m_178 neck 0.50 has no usable approach
ERROR: mpfb_m_188 neck 0.15 has no usable approach
ERROR: mpfb_m_188 neck 0.50 has no usable approach
checks=24 failures=4
```
Both fighters, both neck blends: 0/128 usable approaches, deepest blocker = `thorax`.

## Root cause
The single thorax capsule ran Chest→Neck with a depth radius of ~0.12-0.14 m. Its
hemispherical end-cap at the Neck bone extended that full radius above the neck,
burying it from every approach direction.

## Send-back 1: G73 skin-hold measurement
Claude measured that the split_inlet arm collapsed the G73 upper-chest skin-hold
share from 47% to 5%. The digest argued it did not collapse; that was not a gate.

### G73 KEEP/FALL measurement (tools/q220_g73_measure.gd, same _regions() as S55)

```
-- f01 welter 1.78m --
   current      keep  47.94% (430/897 UpperChest)   fall  26.86% (206/767 neck region)
   split_inlet  keep   4.79% (43/897 UpperChest)   fall   0.00% (0/767 neck region)

-- f02 heavy 1.88m --
   current      keep  46.65% (460/986 UpperChest)   fall  47.64% (242/508 neck region)
   split_inlet  keep   4.67% (46/986 UpperChest)   fall   0.00% (0/508 neck region)
```

KEEP collapsed from ~47% to ~5% on both rigs. Confirmed.

## Geometry sweep: no arm satisfies both KEEP > 42% AND neck >= 5/128

### Split sweep (lower=Chest→UpperChest, upper=UpperChest→Neck at various r)

```
-- f01 welter --
   r=0.020  keep  4.79%  neck 15/128  worst: head
   r=0.060  keep  8.14%  neck  5/128  worst: head
   r=0.070  keep 10.81%  neck  0/128  worst: head
   r=0.119  keep 45.48%  neck  0/128  worst: thorax_upper

-- f02 heavy --
   r=0.020  keep  4.97%  neck 15/128  worst: head
   r=0.050  keep  5.98%  neck  9/128  worst: head
   r=0.070  keep  7.81%  neck  0/128  worst: head
   r=0.119  keep 32.05%  neck  0/128  worst: thorax_upper
```

Neck reachable only at r ≤ 0.060 (f01) or r ≤ 0.050 (f02). KEEP stays below 10%
at those radii. The lower capsule's cap at UpperChest does not cover the UpperChest
skin that the original cylinder covered.

### Single-thorax radius sweep (Chest→Neck at fractions of depth p80)

```
-- f01 welter (baseline r=0.1231m) --
   0.50x  r=0.062  keep  3.90%  neck  5/128  PASS neck, FAIL keep
   0.95x  r=0.117  keep 43.59%  neck  0/128  PASS keep, FAIL neck

-- f02 heavy (baseline r=0.1418m) --
   0.50x  r=0.071  keep  2.94%  neck  0/128  FAIL both
   0.95x  r=0.135  keep 39.96%  neck  0/128  FAIL both
```

f02 neck is blocked at ALL radii ≥ 0.60x. No single-thorax radius satisfies both.

### Truncated thorax (Chest→UpperChest, single capsule, same radius)

```
-- f01 welter --
   keep  4.79%  fall  0.00%  (KEEP collapsed, same as split)
```

Shortening the capsule loses the cylindrical surface that covered UpperChest skin.
The cap at UpperChest does not reach the lateral vertices.

## Why no geometry works

The original thorax (Chest→Neck, r≈0.14m) covers UpperChest skin via its
CYLINDRICAL surface - vertices near the middle of the segment are within the
perpendicular distance r. Shortening to Chest→UpperChest forces coverage to rely
on the HEMISPHERICAL cap at the endpoint, which does not reach lateral vertices
at the same distance. The split's upper capsule would need r ≈ 0.12m to cover
the same vertices, but r > 0.06m blocks the neck.

The thorax cylinder itself (not just its cap) blocks neck approaches. Reducing
the radius to unblock the neck also removes the cylindrical coverage that holds
the UpperChest skin. These are the same geometric extent.

## Action taken
Reverted FighterCapsules.gd to master state. The split_inlet default is NOT
shipped. The neck reachability test will FAIL (0/128 usable approaches) until
a geometry is found that satisfies both constraints, or the constraints are
relaxed.

## Blocker
No capsule geometry in the current system satisfies:
1. KEEP > baseline - 5 (G73 rib-cage hole detector)
2. Neck reachable ≥ 5/128 (fighter_reachability_contract_test)

Resolving this requires either:
- A new capsule shape (tapered, no hemispherical cap, etc.) not supported by the
  current CapsuleDistance API
- A new bone landmark between UpperChest and Neck to anchor a shorter capsule
  that still covers UpperChest skin cylindrically
- Relaxing one of the two constraints (operator decision)

## Owned files touched
- `Godot/scripts/FighterCapsules.gd` - REVERTED to master (no diff)
- `Godot/tools/q220_g73_measure.gd` - NEW measurement tool (sweep)
- `research/Q220_DIGEST.md` - this file
