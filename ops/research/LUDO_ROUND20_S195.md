# LUDO ROUND 20 (S195, 2026-10-10) - "ask Ludo to generate this" (operator comment C17 on the chairs-removed floor still)
Operator also ruled (S195, verbatim): "make sure it understands this is not a mobile game its a deep manager simulation and the mechanics/loops need to be fun for this kind of games, no mobile designs" -> every Ask Ludo now opens with the PC-deep-sim line (memory feedback_ludo_not_mobile_deep_manager_sim).
Asked: generate the target design of the approved floor (asset list with metres/material/hex/polys, floor+wall colours, lighting rig, biggest upgrade). Reply 1 = a concept IMAGE only
(in the Ludo project Asset Vault, "Unused Assets"); after the not-mobile correction, reply 2 = the written spec below ("PC Training Floor Art & Asset Specification",
premium-PC-sim look: Motorsport Manager / Two Point Campus / Football Manager). Two slices (lighting energies, the upgrade paragraph) were blocked by the browser extension
filter and are NOT recorded here; ask Ludo for them in a short follow-up if wanted.

## 1. Asset manifest (W x D x H m | material | hex | triangle limit) - total static budget ~25,400 tris
Boxing ring (elevated) 5.50x5.50x0.90 matte canvas, steel turnbuckles #1E3A8A 4,200 | Heavy bag banana 0.40x0.40x1.80 dark cowhide #3E2723 1,100 | Heavy bag 100# 0.45x0.45x1.20 vinyl #1C1917 950 |
Bag wall gantry x4 4.80x1.20x0.80 powder-coated I-beam #262626 1,400 | Speed bag platform x2 0.75x0.85x0.90 birch drum, cast-iron rig #D97706 1,200 | Taped pads square decal 3.00x3.00x0.002 cloth tape #EAB308 12 |
Slip rope 4.50x0.06x1.20 braided nylon, steel posts #DC2626 650 | Dumbbell rack 2-tier 2.40x0.65x0.85 matte steel #171717 2,800 | Urethane hex dumbbells 5-40 kg #262626 3,400 |
Curve-slat treadmill 0.90x1.95x1.60 #0F172A 2,600 | Air bike 0.65x1.30x1.35 tubular steel #18181B 3,100 | Plyo box 20/24/30in 0.50x0.60x0.75 CNC birch #B45309 450 |
Stretch mat 0.60x1.80x0.03 textured vinyl #2563EB 350 | Wall glove peg rack 1.80x0.20x0.35 steel + brass pegs #3F3F46 550 | Hanging training gloves #991B1B 1,400 |
Wall mirror section 3.60x0.05x2.10 #94A3B8 250 | Wall hydration station 0.40x0.35x1.10 brushed stainless #CBD5E1 850 (flush wall, <= 0.4 m, R19) | Industrial wall clock 0.45x0.08x0.45 #F8FAFC 400.

## 2. Surfaces (hex | roughness | metallic)
Vulcanised rubber floor #1E2022 0.82 0 (8 mm black speckle tile) | concrete runway/perimeter #64676D 0.75 0 | N/W brick walls #7C3F34 0.88 0 | accent wall stripe #1D4ED8 0.55 0 |
mortar #B0ABA4 0.95 0 | structural steel columns #2B2D42 0.40 0.75 | ring canvas #2B4C7E 0.90 0. Rule: lifting/bag/pad areas on the black rubber; concrete only at runways and
under heavy kit; contact scuffs, chalk dust by the rack, tile seam bevels (tactile material honesty).

## 3. Lighting (what was readable)
Sun DirectionalLight3D rotation (-58, 38, 0), soft contact shadows; commercial linear-LED high-bay SpotLight3D over the ring/pad area at (2.5, 7.5, -1.0) pointing down, #F8FAFC (4200 K cool white),
energy 2.4, range 10, angle 48, shadows on; ambient colour #D1D5DB energy 0.35, background #111827 (high contrast).

## Claude's verdict (to be approved by the operator on the board before any build)
KEEP: the surface table and hexes as the new floor material pass (data only, no new models needed); the 25k-tri budget as the ceiling for any generated prop.
CAUTION: the current floor is already close on dimensions; the biggest visible gap vs the image is the black rubber tile floor and real materials (our floor is flat grey) - a PBR floor + wall pass is the cheap win.
NOT NOW: generating 15 Ludo 3D models (credits, licence check, retarget/scale work) - only after the operator approves the look; D39 LUDO FIRST.
Queue if approved: GYMFLOOR-ART1 (floor+wall PBR materials from section 2, Cursor), GYMFLOOR-WATER1 (flush wall hydration station).
