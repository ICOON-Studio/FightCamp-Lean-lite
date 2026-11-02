# D70 - combination start distance and hip/foot travel (Dola, 2026-10-04)

Raw capture (whole thread, uncurated): `research/_captures/D70_raw.txt`. Brief: `BRIEF_D70_COMBO_DISTANCE.md`.

## What it settles (Claude's reading, against Arena's Q213H measurement)
- Real boxers START a jab-cross-hook / -uppercut at jab range, 0.85-0.95 m centre to centre - the same as our 0.89 m.
  So the START distance is right.
- Real forward hip travel is SMALL: lead hook to the body ~0.10-0.15 m (the strongest source, a 3D motion-capture study
  of an elite boxer's left hook: centre of gravity 109 mm forward, +9 mm vertical); rear uppercut ~0.08-0.15 m. The
  body hook's height comes from a KNEE BEND of ~0.15-0.25 m, not from going forward. Closest approach in reality:
  0.45-0.60 m (body hook), 0.40-0.55 m (uppercut).
- OUR clips lunge 0.61-0.68 m (body hook) and 0.48-0.53 m (rear uppercut) on their own (Q213H: identical alone and in a
  combination). That is 4-6x the real forward travel. Dola read our numbers as cumulative over the combination; Arena's
  measurement shows they are each punch's own lunge, so her "no source" caveat does not apply.
- Feet: jab step 15-30 cm with the rear foot following; cross and hooks pivot on planted feet (rear foot arcs 10-20 cm);
  body hook = plant + knee bend; uppercut 0-15 cm.
- Her named animation mistake is exactly ours: "lunging into the hook/uppercut instead of rotating from a stable base".

## Decision for Q213H-FIX
Cap the root's forward travel of `boxing` body hook and rear uppercut to the measured band (~0.15 m), carrying the body
hook's height as a knee bend, instead of re-spacing the combinations. Gate: the 3 combinations PASS the honest clipping
gate at their certified spacing, singles stay PASS, and the punch still reaches its target (C223 contact).

## Source quality
One peer-reviewed mocap case study (n=1, elite boxer) + coaching sites. Treat bands as order-of-magnitude, the 109 mm as
the anchor. Prefab check: FreeMoCap (Apache 2.0) is the only commercially usable 3D source named; no dataset isolates
per-punch hip travel in a combination.
