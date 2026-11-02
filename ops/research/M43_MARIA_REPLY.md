# FightCamp: Boxer kit art direction (M43)

**From:** Maria, Art Director
**Scope:** Art direction only. No game code.
**View:** 3D bout, TV-style broadcast camera (wide, slightly high). 12 MetaHuman boxers (men and women). Warm-lit ring, dark crowd. Every boxer wears Epic's MetaHuman Hightops boxing boots, tinted per kit.
**Goal:** the operator can tell the two boxers apart at a glance, in stills and in motion, at 1920x1080 and on a phone.

Conventions in this document:
- **EXAMPLE** marks an invented name, string or target value (all kit names, the environment target colours, and every hex in this doc are our own design choices, not real-world standards).
- **NOT VERIFIED** marks any real-world claim I could not source.
- Teal is reserved for the game UI. No kit uses teal or teal-adjacent cyan-green.
- Gym walls are brick red `#b8402e`. They're shown for context only and aren't a kit constraint (see the note in §4).

---

## 1. Rule set

### 1.1 What real promotions and federations do (sourced)

| Claim | Source |
|---|---|
| Amateur (IBA, formerly AIBA): boxers wear a red or blue vest and shorts matching their corner allocation. Gloves (and headguard where worn) also match the corner. Allowed shades are Red Pantone 185, 199 or 485 and Blue Pantone 286, 293 or 661. The belt line of the shorts must be white and 6–10 cm wide. | AIBA Open Boxing Competition Rules 2015, §19.1, §20.2, §22.3–22.4: https://www.iba.sport/wp-content/uploads/2015/02/AOB-Competition-Rules-2015-09-11.pdf ; 2016 edition §20.1, §23.3–23.4: http://www.boxingscotland.org/version2/wp-content/uploads/2015/10/AIBA_AOB_RULES_2016-11-17.pdf |
| The current IBA Technical & Competition Rules took effect on 15 April 2026 and have a section on athlete competition uniform (§49). | https://www.iba.sport/about-iba/boxing-rules/ and https://www.iba.sport/wp-content/uploads/2026/06/20260415-IBA-Technical-Competition-Rules.pdf. I only saw the table of contents. **NOT VERIFIED:** that the 2026 text keeps the exact Pantone list and white belt line from the 2015/2016 rules. |
| Nevada (pro): "The unarmed combatants may not wear the same colors in the ring … without the approval of the Executive Director or the Executive Director's designee." (NRUC 4.020(2)) | https://www.boxing.nv.gov/siteassets/faq/sections/2024-11-20-NRUC-OFFICIAL-FINAL.pdf |
| ABC (pro): the ring has red and blue corners ("buckets and stairs in red and blue corners"). The referee inspects trunks. | ABC Regulatory Guidelines: https://www.abcboxing.com/abc-regulatory-guidelines/ |
| ABC judges are told to make sure they can identify the fighters, "especially if they have the same color trunks." So in pro boxing under ABC, matching trunks can happen and is handled by officials. | ABC Boxing Judge Manual 2024: https://www.abcboxing.com/wp-content/uploads/2024/09/abc-boxing-judge-manual-2024.pdf |
| A.P.B.C. rule 1.18: boxers must bring two pairs of trunks in different colours, and the Inspector decides any colour clash. This is a real precedent for our alternate-kit rule. | https://apbcboxing.com/?page_id=28 |
| WBC rules on trunk colour or corner colour. | **NOT VERIFIED.** I didn't find a source. |
| Olympic boxing red/blue rules beyond the IBA/AIBA documents above (for example, the 2024 Paris rules under the IOC Boxing Unit). | **NOT VERIFIED** |
| Pro broadcasts in general put the favourite or champion in the red corner. | **NOT VERIFIED.** It's a common belief, but I found no source. Don't present it as fact in-game. |

### 1.2 FightCamp corner logic (our design decision)
1. **Pro bouts (default):** boxers wear their **personal kit** (one of the 12 below). This matches the sourced pro practice: personal outfits, approved by the commission, with no same-colour clash (Nevada) and a second pair available (A.P.B.C.).
2. The **red/blue corner is a UI and data concept**: the corner pad, the stool, the bucket, the scorecard header and the UI side colour. We don't put it on the boxer's body in pro bouts.
3. **Amateur or tournament mode (optional EXAMPLE mode):** override every kit with a corner kit. Red corner = vest/trunks `#c8102e`, blue corner = `#1f45c8`, both with a white `#f4f4f2` waistband 6–10 cm tall in world scale, and gloves that match the corner. Our hexes are screen approximations of the sourced Pantone ranges, not official conversions.
4. If two kits clash under §1.3, the **away boxer** switches to their alternate (§5).

### 1.3 Minimum contrast (numbers)
Everything below was computed in Python (colorspacious 1.1.2 plus my own CIEDE2000 implementation, which matches Sharma's published test pair: 2.0425). CVD simulation uses Machado 2009 at severity 100 (full dichromacy).

**Environment targets (all EXAMPLE assumptions, not measured):**
- Ring canvas: `#cfcac2` (warm light grey)
- Ropes: `#e6e3de` (off-white)
- Crowd, average under house lights down: `#1c1916`
- Warm ring light: a multiply by `#ffb674` in linear light. That's the Tanner Helland approximation of 3200K, with no white-balance correction, so it's a deliberately harsh worst case.

**Boxer vs boxer (trunk base colours). A pair is SAFE only if all three hold:**
- **R1, colour:** CIEDE2000 ΔE00 ≥ **20** in the *worst* of six conditions: normal, protan, deutan, warm, warm+protan, warm+deutan. (Tritan is computed and reported, but because it's rare it doesn't gate a pair.)
- **R2, luminance (greyscale and colour-blind proof):** WCAG relative-luminance contrast ratio ≥ **1.5:1** between the two trunk bases.
- **R3, structure:** both waistbands are different. One is light (Y > 0.4) and one is dark (Y < 0.1), or they differ in hue by ΔE00 ≥ 30.

**Boxer vs environment (base or waistband):**
- **E1:** each trunk base must reach ΔE00 ≥ 20 **or** WCAG ≥ 3:1 against the canvas. The high camera puts the canvas behind the hips. If the base fails, the waistband *and* the trim must pass at WCAG ≥ 3:1.
- **E2:** the same rule against the crowd, which sits behind the torso in tight shots and near the ropes.
- **E3:** against the ropes, the base must reach ΔE00 ≥ 15 or have a dark trim (the ropes cross the trunks in corner shots).
- Kits that fail a base-level rule (White, Silver and Gold on canvas; Black on crowd) are fixed by the waistband and trim colours in §2, as noted per kit.

Why 20? ΔE00 ≈ 2 is a just-noticeable difference side by side. Mid-motion on a phone at about 40 px per boxer, we need about 10× that. 20 also matches where pairs *look* different in the swatch PNG (my judgement, not a standard).

---

## 2. The twelve kits (all names and hexes EXAMPLE)

| Kit | Trunks base | Trim | Waistband | Boots (shoe) | Socks | Gloves | Hand-tape |
|---|---|---|---|---|---|---|---|
| K01 Crimson | `#c8102e` | `#f4f4f2` | `#f4f4f2` | `#c8102e` | `#f4f4f2` | `#c8102e` | `#f4f4f2` |
| K02 Royal Blue | `#1f45c8` | `#f4f4f2` | `#f4f4f2` | `#1f45c8` | `#f4f4f2` | `#1f45c8` | `#f4f4f2` |
| K03 White | `#f4f4f2` | `#121212` | `#121212` (fixes canvas) | `#f4f4f2` | `#121212` | `#121212` | `#f4f4f2` |
| K04 Black | `#121212` | `#f5c400` | `#f5c400` (fixes crowd) | `#121212` | `#121212` | `#f5c400` | `#f4f4f2` |
| K05 Gold | `#f5c400` | `#121212` | `#121212` (fixes canvas) | `#f5c400` | `#121212` | `#121212` | `#f4f4f2` |
| K06 Purple | `#5b2a8c` | `#f5c400` | `#f5c400` (fixes crowd) | `#5b2a8c` | `#f4f4f2` | `#5b2a8c` | `#f4f4f2` |
| K07 Kelly Green | `#1b8a2e` | `#f4f4f2` | `#f4f4f2` | `#1b8a2e` | `#f4f4f2` | `#121212` | `#f4f4f2` |
| K08 Magenta | `#d6197f` | `#121212` | `#121212` | `#d6197f` | `#121212` | `#d6197f` | `#f4f4f2` |
| K09 Orange | `#ff6a13` | `#121212` | `#121212` | `#121212` | `#121212` | `#ff6a13` | `#f4f4f2` |
| K10 Silver | `#a7abb0` | `#121212` | `#121212` (fixes canvas) | `#a7abb0` | `#121212` | `#121212` | `#f4f4f2` |
| K11 Sky Blue | `#6fb3ee` | `#1f45c8` | `#1f45c8` | `#6fb3ee` | `#f4f4f2` | `#1f45c8` | `#f4f4f2` |
| K12 Maroon | `#6b0f22` | `#f4f4f2` | `#f4f4f2` (fixes crowd) | `#6b0f22` | `#f4f4f2` | `#f4f4f2` | `#f4f4f2` |

Hand-tape is white on every kit because that's how real tape reads. It's an EXAMPLE choice, not sourced. Hand-tape is mostly hidden by the gloves and is not used to tell boxers apart.

Swatch check: `/workspace/m43/m43_kits.png`. The rows are Normal, Deutan, Protan and Warm 3200K.

### 2.1 Computed simulations and contrast (trunk bases)
| Kit | Trunk base | Y (rel. lum.) | Protan sim | Deutan sim | Tritan sim | Warm 3200K | Warm+deutan |
|---|---|---|---|---|---|---|---|
| K01 Crimson | `#c8102e` | 0.1285 | `#544c2d` | `#7e7127` | `#dd0020` | `#c8080f` | `#7f7100` |
| K02 Royal Blue | `#1f45c8` | 0.0872 | `#005bcc` | `#004bc6` | `#006880` | `#1f2e59` | `#122e59` |
| K03 White | `#f4f4f2` | 0.9035 | `#f4f4f2` | `#f4f4f2` | `#f4f4f3` | `#f4ae6e` | `#d4c36f` |
| K04 Black | `#121212` | 0.006 | `#121212` | `#121212` | `#121212` | `#120903` | `#0e0c04` |
| K05 Gold | `#f5c400` | 0.5889 | `#ddc200` | `#e8cf1e` | `#ffb1a7` | `#f58b00` | `#c5af01` |
| K06 Purple | `#5b2a8c` | 0.0577 | `#00438f` | `#00448a` | `#514057` | `#5b1b3c` | `#36373b` |
| K07 Kelly Green | `#1b8a2e` | 0.1861 | `#8c7d23` | `#807436` | `#008677` | `#1b610f` | `#5b5119` |
| K08 Magenta | `#d6197f` | 0.1652 | `#4a5b81` | `#7e7d7b` | `#e8004d` | `#d60e36` | `#877a2f` |
| K09 Orange | `#ff6a13` | 0.3162 | `#958300` | `#baa502` | `#ff435c` | `#ff4904` | `#ae9b00` |
| K10 Silver | `#a7abb0` | 0.4048 | `#a9abb0` | `#a8aab0` | `#a5acad` | `#a7794e` | `#92864e` |
| K11 Sky Blue | `#6fb3ee` | 0.4179 | `#9ab4f1` | `#89a7ed` | `#1dc1c7` | `#6f7f6c` | `#7d7a6d` |
| K12 Maroon | `#6b0f22` | 0.0358 | `#2b2922` | `#423c1f` | `#760018` | `#6b0709` | `#423a04` |

### Trunk base vs environment (WCAG ratio / dE2000 / dE2000 under warm light)

| Kit | Canvas | Ropes | Crowd | Gym wall (context) |
|---|---|---|---|---|
| K01 Crimson | 3.61 / 43.9 / 30.2 | 4.6 / 47.9 / 34.5 | 2.97 / 37.0 / 36.6 | 1.07 / 7.3 / 3.9 |
| K02 Royal Blue | 4.69 / 53.5 / 55.9 | 5.98 / 56.4 / 63.3 | 2.29 / 36.4 / 24.0 | 1.39 / 43.4 / 42.4 |
| K03 White | 1.48 / 9.9 / 9.1 | 1.16 / 4.0 / 3.4 | 15.89 / 85.5 / 65.9 | 5.0 / 47.9 / 36.1 |
| K04 Black | 11.49 / 70.5 / 53.7 | 14.64 / 83.8 / 61.8 | 1.07 / 3.4 / 4.0 | 3.4 / 38.4 / 37.3 |
| K05 Gold | 1.01 / 26.4 / 10.2 | 1.28 / 28.0 / 9.6 | 10.65 / 73.8 / 58.2 | 3.35 / 48.0 / 31.6 |
| K06 Purple | 5.98 / 58.7 / 50.9 | 7.61 / 61.9 / 58.7 | 1.8 / 31.5 / 22.6 | 1.77 / 38.7 / 30.6 |
| K07 Kelly Green | 2.73 / 36.2 / 46.5 | 3.47 / 40.3 / 50.7 | 3.93 / 41.5 / 35.8 | 1.24 / 61.9 / 58.0 |
| K08 Magenta | 2.99 / 42.0 / 31.5 | 3.81 / 44.9 / 35.2 | 3.59 / 41.3 / 38.8 | 1.13 / 24.6 / 11.5 |
| K09 Orange | 1.76 / 31.4 / 19.1 | 2.24 / 34.7 / 21.3 | 6.1 / 53.1 / 49.4 | 1.92 / 21.7 / 17.9 |
| K10 Silver | 1.42 / 11.2 / 9.9 | 1.8 / 15.3 / 15.4 | 7.58 / 53.3 / 40.4 | 2.39 / 36.9 / 22.7 |
| K11 Sky Blue | 1.38 / 26.8 / 29.2 | 1.75 / 27.2 / 32.2 | 7.8 / 58.8 / 39.4 | 2.46 / 51.8 / 40.0 |
| K12 Maroon | 7.5 / 63.5 / 43.4 | 9.56 / 67.7 / 52.1 | 1.43 / 24.9 / 22.0 | 2.22 / 20.9 / 17.4 |

### Pairwise matrix: worst-case dE2000 across normal, protan, deutan, warm, warm+protan, warm+deutan (S = safe, X = clash)

| | K01 | K02 | K03 | K04 | K05 | K06 | K07 | K08 | K09 | K10 | K11 | K12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| K01 | — | X 41.3 | S 26.6 | S 23.0 | S 21.9 | S 30.7 | X 2.6 | X 5.2 | X 15.5 | X 11.4 | X 19.7 | X 14.3 |
| K02 | X 41.3 | — | S 51.7 | S 23.0 | S 60.5 | X 8.1 | S 42.3 | X 11.1 | S 50.4 | S 35.9 | S 30.4 | S 33.1 |
| K03 | S 26.6 | S 51.7 | — | S 62.9 | X 9.6 | S 60.7 | S 34.2 | S 22.9 | X 13.2 | X 17.9 | S 23.2 | S 53.9 |
| K04 | S 23.0 | S 23.0 | S 62.9 | — | S 53.6 | X 14.1 | S 27.0 | S 24.2 | S 40.0 | S 39.9 | S 35.9 | X 8.3 |
| K05 | S 21.9 | S 60.5 | X 9.6 | S 53.6 | — | S 55.0 | S 22.9 | X 19.8 | X 6.3 | X 15.3 | X 23.0 | S 44.0 |
| K06 | S 30.7 | X 8.1 | S 60.7 | X 14.1 | S 55.0 | — | S 23.7 | X 10.8 | S 43.6 | S 35.8 | S 25.2 | X 19.2 |
| K07 | X 2.6 | S 42.3 | S 34.2 | S 27.0 | S 22.9 | S 23.7 | — | X 11.3 | X 4.2 | X 15.4 | S 20.2 | X 7.8 |
| K08 | X 5.2 | X 11.1 | S 22.9 | S 24.2 | X 19.8 | X 10.8 | X 11.3 | — | X 13.8 | X 6.2 | X 16.2 | X 14.6 |
| K09 | X 15.5 | S 50.4 | X 13.2 | S 40.0 | X 6.3 | S 43.6 | X 4.2 | X 13.8 | — | X 9.7 | X 18.6 | S 29.3 |
| K10 | X 11.4 | S 35.9 | X 17.9 | S 39.9 | X 15.3 | S 35.8 | X 15.4 | X 6.2 | X 9.7 | — | X 10.2 | S 27.8 |
| K11 | X 19.7 | S 30.4 | S 23.2 | S 35.9 | X 23.0 | S 25.2 | S 20.2 | X 16.2 | X 18.6 | X 10.2 | — | S 26.1 |
| K12 | X 14.3 | S 33.1 | S 53.9 | X 8.3 | S 44.0 | X 19.2 | X 7.8 | X 14.6 | S 29.3 | S 27.8 | S 26.1 | — |

### Full pair list (computed)

| Pair | WCAG ratio | Normal | Protan | Deutan | Tritan | Warm | Warm+deutan | Warm+protan | Greyscale ΔL* | Verdict |
|---|---|---|---|---|---|---|---|---|---|---|
| K01 Crimson vs K02 Royal Blue | 1.3 | 41.9 | 46.0 | 59.3 | 58.0 | 43.1 | 51.9 | 41.3 | 7.1 | CLASH |
| K01 Crimson vs K03 White | 5.34 | 50.7 | 54.4 | 42.2 | 48.1 | 37.3 | 26.6 | 41.0 | 53.6 | SAFE |
| K01 Crimson vs K04 Black | 3.18 | 38.8 | 23.0 | 38.1 | 42.0 | 38.9 | 39.0 | 26.4 | 37.1 | SAFE |
| K01 Crimson vs K05 Gold | 3.58 | 55.8 | 47.1 | 30.7 | 31.9 | 33.1 | 21.9 | 31.3 | 38.7 | SAFE |
| K01 Crimson vs K06 Purple | 1.66 | 36.0 | 41.1 | 52.3 | 33.9 | 30.7 | 33.7 | 33.4 | 13.7 | SAFE |
| K01 Crimson vs K07 Kelly Green | 1.32 | 71.5 | 21.2 | 2.6 | 61.4 | 62.7 | 13.2 | 5.3 | 7.7 | CLASH |
| K01 Crimson vs K08 Magenta | 1.21 | 19.9 | 32.1 | 21.3 | 10.9 | 8.7 | 5.2 | 8.9 | 5.1 | CLASH |
| K01 Crimson vs K09 Orange | 2.05 | 26.9 | 25.3 | 19.8 | 14.2 | 17.6 | 15.8 | 15.5 | 20.5 | CLASH |
| K01 Crimson vs K10 Silver | 2.55 | 39.7 | 41.1 | 32.2 | 39.4 | 25.2 | 11.4 | 18.8 | 27.3 | CLASH |
| K01 Crimson vs K11 Sky Blue | 2.62 | 55.2 | 53.7 | 50.9 | 63.6 | 42.6 | 19.7 | 22.5 | 28.2 | CLASH |
| K01 Crimson vs K12 Maroon | 2.08 | 19.1 | 15.0 | 21.2 | 21.0 | 18.5 | 20.4 | 14.3 | 20.3 | CLASH |
| K02 Royal Blue vs K03 White | 6.95 | 58.0 | 51.7 | 56.7 | 47.8 | 68.4 | 74.1 | 65.5 | 60.7 | SAFE |
| K02 Royal Blue vs K04 Black | 2.45 | 35.4 | 37.1 | 35.3 | 31.1 | 23.0 | 24.4 | 23.7 | 30.0 | SAFE |
| K02 Royal Blue vs K05 Gold | 4.66 | 79.0 | 73.4 | 80.2 | 56.4 | 63.5 | 70.9 | 60.5 | 45.8 | SAFE |
| K02 Royal Blue vs K06 Purple | 1.27 | 14.4 | 10.4 | 8.3 | 33.5 | 22.4 | 16.1 | 8.1 | 6.6 | CLASH |
| K02 Royal Blue vs K07 Kelly Green | 1.72 | 57.2 | 59.4 | 57.0 | 19.7 | 45.5 | 42.3 | 44.7 | 14.8 | SAFE |
| K02 Royal Blue vs K08 Magenta | 1.57 | 33.3 | 11.1 | 33.2 | 59.7 | 42.3 | 50.8 | 33.9 | 12.2 | CLASH |
| K02 Royal Blue vs K09 Orange | 2.67 | 58.1 | 63.0 | 73.5 | 60.6 | 53.7 | 63.6 | 50.4 | 27.6 | SAFE |
| K02 Royal Blue vs K10 Silver | 3.32 | 39.7 | 35.9 | 40.3 | 31.9 | 46.0 | 50.9 | 45.6 | 34.4 | SAFE |
| K02 Royal Blue vs K11 Sky Blue | 3.41 | 37.3 | 30.4 | 32.8 | 30.9 | 38.5 | 37.1 | 36.9 | 35.3 | SAFE |
| K02 Royal Blue vs K12 Maroon | 1.6 | 36.4 | 38.1 | 47.2 | 53.2 | 34.0 | 40.2 | 33.1 | 13.2 | SAFE |
| K03 White vs K04 Black | 17.01 | 90.5 | 90.5 | 90.5 | 90.5 | 67.5 | 70.0 | 62.9 | 90.7 | SAFE |
| K03 White vs K05 Gold | 1.49 | 30.0 | 30.2 | 29.2 | 23.7 | 10.9 | 9.6 | 11.4 | 14.9 | CLASH |
| K03 White vs K06 Purple | 8.85 | 63.7 | 61.7 | 61.6 | 57.7 | 64.0 | 60.7 | 62.0 | 67.3 | SAFE |
| K03 White vs K07 Kelly Green | 4.04 | 42.9 | 39.5 | 40.4 | 41.5 | 52.8 | 40.9 | 34.2 | 45.9 | SAFE |
| K03 White vs K08 Magenta | 4.43 | 46.9 | 48.6 | 32.2 | 45.5 | 37.8 | 22.9 | 38.0 | 48.5 | SAFE |
| K03 White vs K09 Orange | 2.6 | 37.5 | 39.0 | 33.0 | 39.1 | 23.4 | 13.2 | 22.3 | 33.1 | CLASH |
| K03 White vs K10 Silver | 2.1 | 18.1 | 17.9 | 18.2 | 18.0 | 18.7 | 18.7 | 18.4 | 26.3 | CLASH |
| K03 White vs K11 Sky Blue | 2.04 | 27.3 | 25.3 | 28.7 | 28.9 | 34.1 | 28.4 | 23.2 | 25.4 | SAFE |
| K03 White vs K12 Maroon | 11.11 | 70.3 | 73.9 | 63.0 | 68.8 | 57.8 | 53.9 | 54.9 | 73.9 | SAFE |
| K04 Black vs K05 Gold | 11.4 | 75.7 | 71.8 | 78.0 | 70.7 | 59.9 | 63.1 | 53.6 | 75.8 | SAFE |
| K04 Black vs K06 Purple | 1.92 | 30.5 | 28.5 | 27.7 | 21.8 | 24.5 | 14.1 | 16.0 | 23.4 | CLASH |
| K04 Black vs K07 Kelly Green | 4.21 | 42.8 | 42.5 | 38.0 | 40.7 | 34.5 | 27.0 | 31.1 | 44.8 | SAFE |
| K04 Black vs K08 Magenta | 3.84 | 41.9 | 28.4 | 35.9 | 43.5 | 40.9 | 40.4 | 24.2 | 42.2 | SAFE |
| K04 Black vs K09 Orange | 6.53 | 55.4 | 46.0 | 58.8 | 50.3 | 51.5 | 54.5 | 40.0 | 57.6 | SAFE |
| K04 Black vs K10 Silver | 8.11 | 54.9 | 55.1 | 54.7 | 54.9 | 42.5 | 43.5 | 39.9 | 64.3 | SAFE |
| K04 Black vs K11 Sky Blue | 8.35 | 59.4 | 62.4 | 57.6 | 61.2 | 38.9 | 35.9 | 37.1 | 65.3 | SAFE |
| K04 Black vs K12 Maroon | 1.53 | 26.3 | 8.3 | 18.6 | 27.6 | 25.0 | 21.0 | 13.1 | 16.8 | CLASH |
| K05 Gold vs K06 Purple | 5.93 | 81.9 | 76.1 | 77.0 | 51.0 | 59.0 | 56.1 | 55.0 | 52.4 | SAFE |
| K05 Gold vs K07 Kelly Green | 2.71 | 40.7 | 22.9 | 30.5 | 52.4 | 54.2 | 37.8 | 26.1 | 31.0 | SAFE |
| K05 Gold vs K08 Magenta | 2.97 | 68.0 | 59.6 | 37.0 | 29.5 | 36.1 | 19.8 | 32.0 | 33.6 | CLASH |
| K05 Gold vs K09 Orange | 1.74 | 32.7 | 19.6 | 11.4 | 21.7 | 18.7 | 6.3 | 14.0 | 18.2 | CLASH |
| K05 Gold vs K10 Silver | 1.4 | 34.3 | 32.6 | 33.8 | 26.9 | 17.8 | 17.9 | 15.3 | 11.4 | CLASH |
| K05 Gold vs K11 Sky Blue | 1.37 | 58.7 | 52.9 | 56.4 | 46.4 | 36.4 | 29.2 | 23.0 | 10.5 | CLASH |
| K05 Gold vs K12 Maroon | 7.44 | 72.3 | 65.9 | 58.6 | 56.1 | 49.2 | 47.8 | 44.0 | 59.0 | SAFE |
| K06 Purple vs K07 Kelly Green | 2.19 | 54.6 | 56.9 | 50.5 | 40.0 | 59.1 | 23.7 | 37.1 | 21.4 | SAFE |
| K06 Purple vs K08 Magenta | 2.0 | 26.3 | 10.8 | 31.8 | 31.9 | 28.3 | 33.9 | 27.1 | 18.8 | CLASH |
| K06 Purple vs K09 Orange | 3.4 | 56.8 | 60.6 | 68.4 | 38.0 | 45.0 | 47.7 | 43.6 | 34.2 | SAFE |
| K06 Purple vs K10 Silver | 4.22 | 45.0 | 45.4 | 44.9 | 43.5 | 40.8 | 35.8 | 40.4 | 41.0 | SAFE |
| K06 Purple vs K11 Sky Blue | 4.34 | 49.6 | 43.9 | 39.6 | 56.7 | 46.4 | 25.2 | 33.4 | 41.9 | SAFE |
| K06 Purple vs K12 Maroon | 1.26 | 27.8 | 30.8 | 39.4 | 24.2 | 19.2 | 21.5 | 24.6 | 6.6 | CLASH |
| K07 Kelly Green vs K08 Magenta | 1.1 | 81.3 | 44.1 | 19.2 | 65.7 | 67.3 | 15.3 | 11.3 | 2.6 | CLASH |
| K07 Kelly Green vs K09 Orange | 1.55 | 60.4 | 4.2 | 19.9 | 64.0 | 63.7 | 30.8 | 10.4 | 12.8 | CLASH |
| K07 Kelly Green vs K10 Silver | 1.93 | 33.8 | 30.9 | 30.1 | 26.9 | 37.2 | 20.4 | 15.4 | 19.6 | CLASH |
| K07 Kelly Green vs K11 Sky Blue | 1.98 | 50.6 | 50.1 | 48.5 | 20.5 | 21.9 | 20.2 | 21.0 | 20.5 | SAFE |
| K07 Kelly Green vs K12 Maroon | 2.75 | 66.4 | 35.2 | 21.3 | 59.7 | 55.2 | 7.8 | 19.5 | 28.0 | CLASH |
| K08 Magenta vs K09 Orange | 1.7 | 39.6 | 47.4 | 29.7 | 9.2 | 19.7 | 13.8 | 18.2 | 15.4 | CLASH |
| K08 Magenta vs K10 Silver | 2.11 | 34.4 | 32.4 | 15.6 | 29.3 | 27.5 | 6.2 | 16.7 | 22.2 | CLASH |
| K08 Magenta vs K11 Sky Blue | 2.17 | 52.4 | 32.4 | 26.6 | 79.8 | 43.7 | 16.2 | 16.4 | 23.1 | CLASH |
| K08 Magenta vs K12 Maroon | 2.51 | 25.6 | 26.9 | 26.5 | 23.2 | 21.5 | 22.8 | 14.6 | 25.4 | CLASH |
| K09 Orange vs K10 Silver | 1.24 | 32.6 | 31.8 | 31.2 | 25.8 | 20.8 | 12.9 | 9.7 | 6.8 | CLASH |
| K09 Orange vs K11 Sky Blue | 1.28 | 49.7 | 51.8 | 53.9 | 62.2 | 41.7 | 25.0 | 18.6 | 7.7 | CLASH |
| K09 Orange vs K12 Maroon | 4.27 | 43.6 | 38.8 | 44.4 | 31.6 | 34.8 | 38.1 | 29.3 | 40.8 | SAFE |
| K10 Silver vs K11 Sky Blue | 1.03 | 17.7 | 17.0 | 18.2 | 20.8 | 24.6 | 13.7 | 10.2 | 0.9 | CLASH |
| K10 Silver vs K12 Maroon | 5.3 | 52.6 | 49.9 | 46.8 | 53.5 | 33.1 | 27.8 | 30.3 | 47.6 | SAFE |
| K11 Sky Blue vs K12 Maroon | 5.45 | 63.0 | 59.4 | 56.5 | 71.6 | 43.7 | 26.1 | 30.2 | 48.5 | SAFE |

**Result: 35 of 66 pairs are SAFE, 31 CLASH** and use the alternate-kit rule below.

| Kit | Clashes with | Away alternate | Still clashes after swap |
|---|---|---|---|
| K01 Crimson | K02, K07, K08, K09, K10, K11, K12 | Alt Black `#121212` | K12 Maroon |
| K02 Royal Blue | K01, K06, K08 | Alt White `#f4f4f2` | none |
| K03 White | K05, K09, K10 | Alt Black `#121212` | none |
| K04 Black | K06, K12 | Alt White `#f4f4f2` | none |
| K05 Gold | K03, K08, K09, K10, K11 | Alt Black `#121212` | none |
| K06 Purple | K02, K04, K08, K12 | Alt White `#f4f4f2` | none |
| K07 Kelly Green | K01, K08, K09, K10, K12 | Alt Black `#121212` | K12 Maroon |
| K08 Magenta | K01, K02, K05, K06, K07, K09, K10, K11, K12 | Alt Black `#121212` | K06 Purple, K12 Maroon |
| K09 Orange | K01, K03, K05, K07, K08, K10, K11 | Alt Black `#121212` | none |
| K10 Silver | K01, K03, K05, K07, K08, K09, K11 | Alt Black `#121212` | none |
| K11 Sky Blue | K01, K05, K08, K09, K10 | Alt Black `#121212` | none |
| K12 Maroon | K01, K04, K06, K07, K08 | Alt White `#f4f4f2` | none |
**Reading the matrix:** Red/green-family kits (Crimson, Kelly Green, Magenta, Orange, Maroon) are where protan and deutan collapses happen. Crimson vs Kelly Green drops to ΔE00 2.6 for deutan viewers, and Kelly Green vs Orange to 4.2 for protan viewers. Under warm light, White vs Gold (10.9) and Gold vs Orange (18.7) merge. Black and White are the strongest anchors.

---

## 3. Hightops boot tint rules
MetaHuman Hightops are tinted per kit in three zones: **shoe**, **laces** and **sole**.

| Kit | Shoe | Laces | Sole |
|---|---|---|---|
| K01 Crimson | `#c8102e` | `#f4f4f2` | `#121212` |
| K02 Royal Blue | `#1f45c8` | `#f4f4f2` | `#121212` |
| K03 White | `#f4f4f2` | `#121212` | `#121212` |
| K04 Black | `#121212` | `#f5c400` | `#f4f4f2` |
| K05 Gold | `#f5c400` | `#121212` | `#121212` |
| K06 Purple | `#5b2a8c` | `#f5c400` | `#121212` |
| K07 Kelly Green | `#1b8a2e` | `#f4f4f2` | `#121212` |
| K08 Magenta | `#d6197f` | `#121212` | `#121212` |
| K09 Orange | `#121212` | `#ff6a13` | `#121212` |
| K10 Silver | `#a7abb0` | `#121212` | `#121212` |
| K11 Sky Blue | `#6fb3ee` | `#1f45c8` | `#121212` |
| K12 Maroon | `#6b0f22` | `#f4f4f2` | `#121212` |

Rules:
- **B1:** the sole contrasts with the canvas. A `#121212` sole on the `#cfcac2` canvas computes to WCAG 11.5:1. K04 Black uses a white sole so the black boot doesn't merge with the dark crowd at the apron edge. White on canvas is only 1.48:1, but the black shoe above it outlines it.
- **B2:** the shoe matches the trunk base, or the trim when the base is too close to the canvas (Orange gets a black shoe, because otherwise the orange would wash out under the warm light).
- **B3:** the laces use the trim colour so footwork reads as a two-tone shape.
- **B4:** never use gum or tan soles, or skin-tone shoes (see §4).
- **B5:** alternate kits re-tint the boots with the same rules. Shoe = alt base, laces = alt trim, sole = black. White soles go only on a black alternate.

---

## 4. What NOT to do
- **Tan, beige, camel and skin-adjacent colours.** Under a ~3200K multiply, skin and tan converge, so the trunks read as bare skin and the silhouette breaks. This hits every skin tone across our 12 MetaHumans.
- **Orange-on-orange, gold-on-orange, white-on-gold.** Computed under warm light: Gold vs Orange is ΔE00 18.7 (6.3 with warm+deutan), and White vs Gold is 10.9. Warm light pushes all three toward the same yellow-orange.
- **Low-luminance navy, maroon, purple or black against the crowd.** Black vs crowd is 1.07:1 (ΔE00 3.4) and Purple vs crowd is 1.8:1. The trunk outline disappears. This is fixed only with a bright waistband and trim.
- **White or silver on a light canvas without a dark waistband.** White vs canvas is 1.48:1 (ΔE00 9.9) and Silver vs canvas is 1.42:1.
- **Red vs green or red vs magenta as the only difference between two boxers.** Crimson vs Kelly Green is 2.6 deutan, and Crimson vs Magenta is 8.7 under warm light.
- **Brick-red and rust kits.** Crimson vs the gym wall `#b8402e` is ΔE00 7.3 (3.9 warm). It's context only, but in gym and training cutscenes a crimson kit melts into the wall. Give it a white trim there.
- **Teal or cyan-green:** reserved for the UI.
- **Patterns that shimmer at distance:** fine pinstripes, small checks, houndstooth, tight logo repeats and metallic micro-texture. At 1920x1080 a whole boxer is about 150–250 px tall in the wide shot, and on a phone it's about 40–80 px. Stripes narrower than about 2 px on screen alias against the pixel grid (moiré) and crawl in motion, more so with TAA and temporal upscaling. Rule: the smallest pattern element is ≥ 8 cm in world scale, at most 2 colours per panel, and trim bands ≥ 5 cm.
- **Glossy satin with strong specular highlights in the base colour.** The highlights go white under the key light and erase the hue. Cap roughness at ≥ 0.45 (EXAMPLE value).
- **Telling corners apart by glove colour alone.** Gloves are small and move fast. Trunks, waistband and boots are the identification shapes.

---

## 5. Matchmaking (clash) rule
1. Before the bout, check the two kits against the §2.1 matrix. If the pair is SAFE, both wear their home kits.
2. If it's a CLASH, the **away** boxer wears their alternate (table above). The alternate uses the same trim logic. A black alt gets a gold `#f5c400` waistband (crowd fix), and a white alt gets a black `#121212` waistband (canvas fix).
3. If the away alternate *still* clashes (computed cases: Crimson, Kelly Green or Magenta at home vs Maroon or Purple away), the away boxer's alternate is White instead. Computed fallbacks: Crimson vs White alt ΔE00 26.6 / 5.34:1, Kelly Green vs White alt 34.2 / 4.04:1, Magenta vs White alt 22.9 / 4.43:1. All are SAFE.
4. Never let both boxers wear the same alternate. If both resolve to Black or both to White, the home boxer keeps their home kit.
5. Amateur/tournament mode skips all of this and uses red/blue corner kits (§1.2).

---

## 6. Sources used
- https://www.iba.sport/wp-content/uploads/2015/02/AOB-Competition-Rules-2015-09-11.pdf
- http://www.boxingscotland.org/version2/wp-content/uploads/2015/10/AIBA_AOB_RULES_2016-11-17.pdf
- https://www.iba.sport/about-iba/boxing-rules/
- https://www.iba.sport/wp-content/uploads/2026/06/20260415-IBA-Technical-Competition-Rules.pdf (table of contents only)
- https://www.boxing.nv.gov/siteassets/faq/sections/2024-11-20-NRUC-OFFICIAL-FINAL.pdf
- https://www.abcboxing.com/abc-regulatory-guidelines/
- https://www.abcboxing.com/wp-content/uploads/2024/09/abc-boxing-judge-manual-2024.pdf
- https://apbcboxing.com/?page_id=28

The computation scripts are in `/workspace/m43/` (`calc.py`, `alt.py`, `png.py`, `doc.py`). The raw numbers are in `calc.json` and `alt.json`.

— Maria
