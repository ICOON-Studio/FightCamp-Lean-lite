# G127 - THE SHAPES THAT MAKE ONE FIGHTER LOOK UNLIKE ANOTHER
Grok (Expert), delivered 2026-09-26 in grok.com/c/1a56195e-0402-4ae5-8ebc-d6b4320c298b, 91 sources. Collected by
Claude, S92, for the S93 generator pilot. Citations render as site names only (mostly github makehumancommunity/mpfb).

Exact names are MPFB bundled `.target.gz` stems under `src/mpfb/data/targets/` (same stems in presets/targets[] and MHM
modifier lines). Slider groups are `foo-decr-incr`; weights 0-1 on one extreme. SOURCED

## 1. Which modifiers exist
**Face**
- Jaw: NO jaw-width. Use `chin-width-*`, `chin-jaw-drop-*`, `chin-bones-*`, `head-square`, `head-rectangular`,
  `head-triangular`.
- Chin: `chin-height-*`, `chin-prominent-*`, `chin-width-*`, `chin-cleft-*`, `chin-prognathism-*`, `chin-triangle`.
- Cheekbones: `l/r-cheek-bones-*`, `l/r-cheek-volume-*`, `l/r-cheek-inner-*`, `l/r-cheek-trans-up/down`.
- Brow ridge: NONE. Closest: `forehead-temple-*`, `forehead-nubian-*`, `forehead-scale-vert-*`,
  `eyebrows-angle-up/down`, `eyebrows-trans-forward/backward`.
- Nose: `nose-width1/2/3-*`, `nose-scale-horiz/vert/depth-*`, `nose-hump-*`, `nose-point-width-*`, `nose-point-up/down`,
  `nose-flaring-*`, `nose-greek-*`, `nose-volume-*`, `nose-compression-compress/uncompress`, `nose-curve-concave/convex`,
  `nose-nostrils-width-*`, `nose-base-up/down`.
- Ears: `l/r-ear-scale-*`, `-scale-vert-*`, `-scale-depth-*`, `l/r-ear-shape-round/square/pointed/triangle`, `-lobe-*`,
  `-flap-*`, `-wing-*`, `-trans-*`, `-rot-forward/backward`.
- Eye spacing: `l/r-eye-trans-in/out`, `l/r-eye-push1-in/out` (+ height/scale/bag/fold).
- Lips: `mouth-upperlip/lowerlip-height/volume/width-*`, `mouth-scale-horiz/vert/depth-*`, `mouth-cupidsbow-*`,
  `mouth-philtrum-volume-*`.
**Body**
- Neck: `neck-scale-horiz-*`, `measure-neck-circ-*`, `neck-double-*`, `neck-scale-depth-*`.
- Trapezius: NONE. Proxy `neck-back-scale-depth-*`, `torso-muscle-dorsi-*`, `torso-vshape-*`,
  `l/r-upperarm-shoulder-muscle-*`.
- Shoulders `measure-shoulder-dist-*`, `torso-scale-horiz-*`; chest `torso-muscle-pectoral-*`, `measure-bust-circ-*`,
  `torso-scale-depth-*`; arms `l/r-upperarm-muscle-*`, `l/r-lowerarm-muscle-*` (+ `*-fat-*`); waist
  `measure-waist-circ-*`; thigh `l/r-upperleg-muscle-*`, `measure-thigh-circ-*`; calf: no muscle target, proxy
  `l/r-lowerleg-scale-horiz/depth-*`; fat = phenotype Weight + regional `*-fat-incr`.
- Extra CC0 target packs (not bundled): Ears 01, Nose 01, Cheek 01, Arms 01, Hands 01.

## 2. Fighter marks
- **Cauliflower ear: custom target.** Bundled ears only scale/shape/flap/lobe; Ears 01 has `ear_flatten` (pin-back, not
  a lumpy helix). Author in MPFB MakeTarget: sculpt on hm08, never add/delete verts, save `.target` (appears under Custom
  Target). Easy for a Blender sculptor.
- **Flattened nose: partial proxy** - `nose-compression-compress` + `nose-hump-incr` + `nose-scale-vert-decr` +
  `nose-width1-incr` reads as "hit" at fight camera; a custom target if it must identify the man on a portrait.

## 3. The 20 + 20 (JUDGEMENT, most difference first; weights are safe extremes at ~3 m and on a headshot; bake L/R as one)
**Face:** head-square/head-oval 0-0.55 · chin-width ±0.55 · chin-prominent ±0.45 · cheek-bones-incr 0-0.50 ·
nose-width1 ±0.50 · nose-hump-incr 0-0.40 · nose-compression-compress 0-0.45 · nose-scale-vert ±0.40 ·
nose-point-width ±0.40 · eye-trans-in/out ±0.35 · eyebrows-trans-forward 0-0.40 (heavy brow) · forehead-temple-incr
0-0.40 · ear-scale-incr 0-0.45 · ear-shape-square 0-0.50 · mouth-scale-horiz ±0.40 · mouth-upperlip-volume ±0.35 ·
chin-height ±0.40 · head-scale-horiz ±0.30 · eye-bag-incr 0-0.35 (mileage) · nose-greek ±0.35.
Skip at fight camera: cupid's bow, philtrum, ear canal, most asym-*.
**Body:** Muscle 0.45-0.90 · Weight 0.25-0.55 (>0.65 reads soft) · shoulder-dist-incr 0-0.55 · torso-vshape-incr
0-0.50 · pectoral-incr 0-0.55 · dorsi-incr 0-0.50 · neck-circ-incr 0-0.55 · neck-scale-horiz-incr 0-0.45 ·
upperarm-muscle-incr 0-0.60 · lowerarm-muscle-incr 0-0.55 · waist-circ ±0.40 · upperleg-muscle-incr 0-0.50 ·
thigh-circ ±0.40 · lowerleg-scale-horiz-incr 0-0.45 · torso-scale-depth ±0.35 · neck-back-scale-depth-incr 0-0.40 ·
upperarm-shoulder-muscle-incr 0-0.45 · Height 0.35-0.70 · BodyProportions 0.40-0.70 · upperarm-fat <= 0.25 with high
Muscle.

## 4. CC0 skin / hair + UV (licence pages opened by Grok)
- Bundled skins in makehuman_system_assets (CC0): young/middleage/old x african/asian/caucasian x male/female.
- Packs: skins01 (natural female) CC0, skins02 (natural male) CC0; skip skins03 (alien/zombie).
- Hair CC0: system afro01, short01-04, bob01-02, braid01, long01, ponytail01; pack hair01; system_hair_materials01.
  **hair02 is CC-BY - not CC0.**
- UV: skins must match the hm08 body UV; do not reuse non-hm08 maps without a bake to hm08.

## 5. Ethnicity / age axes
Macros: Macrodetails/Gender, Age, African, Asian, Caucasian; universal Muscle, Weight; Height; BodyProportions. Race
sliders renormalise to sum 1.0; Age 0 young - 1 old (never seed child targets).
**Seed without caricature:** Dirichlet-style race mix, each axis clamped 0.15-0.85 unless explicitly monoracial; age
0.28-0.62 for active fighters (head-age-incr <= 0.25 on veterans); Muscle 0.5-0.85, Weight 0.28-0.52; race first, then
6-10 face details at <= 0.5; never stack race = 1 with extreme matching nose/forehead details.

## Claude's reading (S92)
This is the S93 spec for shapes: bake the top 10 face + top 10 body from s3 for the pilot, the seed rules from s5
become FighterLook.gd's contract. Cauliflower ear = one custom target, a later slice. Community packs (skins01/02,
hair01) each get their licence page re-opened by Claude before they ship; hair02 never ships.
