# U156 — stature: engine, mount target, tape measure

Population: MMA demo R133: wrestle-grappler (A, 175 cm) vs striker (B, 185 cm), seed 92012

## Part 1 — three reads side by side (at mount, rest pose)

### Fighter A (f05_m_mma_light_rigged.glb)

- (a) engine height_cm: 175.0 cm (1.750 m)
- (b) mount target: 1.750 m from fighter height_cm; height_scale=0.9459
- (c) rest stature sole→crown: 1.750 m (delta vs engine -0.0 cm)
- U155 legacy span (Head/feet in whatever pose at mount): 1.497 m
  - 1.74/1.82 were mount targets from old HEIGHT_A/B constants (class-anchor mesh scale), not engine height_cm.
  - ~1.49 m was the legacy span in a crouched guard: Head bone to sole, not crown standing height.

### Fighter B (f06_m_mma_lhw_rigged.glb)

- (a) engine height_cm: 185.0 cm (1.850 m)
- (b) mount target: 1.850 m from fighter height_cm; height_scale=1.8500
- (c) rest stature sole→crown: 1.850 m (delta vs engine 0.0 cm)
- U155 legacy span (Head/feet in whatever pose at mount): 1.604 m
  - 1.74/1.82 were mount targets from old HEIGHT_A/B constants (class-anchor mesh scale), not engine height_cm.
  - ~1.49 m was the legacy span in a crouched guard: Head bone to sole, not crown standing height.

## Part 1d — fighting stance at t=5.0 s

- fighter A: Head above sole 1.379 m; crown stature 1.586 m
- fighter B: Head above sole 1.384 m; crown stature 1.936 m

## Part 2 — cage vs mean stature

- cage flat-to-flat: 9.144 m (UFC 9.144 m target)
- mean crown stature at 5 s: 1.761 m
- flat-to-flat / mean_stature: 5.19 (expect ~5.0 for 9.14 m / ~1.8 m)

## Part 3 — demo pair frame

- Engine heights live in `FightWorldLiveScreen.MMA_STYLES` (`height_cm` per side) and surface through `demo_fighter()` / `_fighter()`.
- MMA render mount heights now default from the same `height_cm` in `setup()` unless `configure` passes `height_a_m` / `height_b_m` (boxing still uses `HEIGHT_A_M` / `HEIGHT_B_M` until U146 spacing is re-checked at demo statures).
- MMA pair updated to 175 cm grappler (A) and 185 cm striker (B); reaches 178 / 190 cm unchanged in role.

## Verdict

- **Truth for booking/sim:** engine `height_cm` (now 175 / 185 for the MMA demo pair).
- **1.74 / 1.82 m:** stale room constants `HEIGHT_A_M` / `HEIGHT_B_M` passed to `Stage.mount`, not the engine population.
- **~1.49 m:** U155’s Head-to-sole span in a fighting guard — not tape stature; rest sole→crown matches mount within 0 cm after the room fix.
