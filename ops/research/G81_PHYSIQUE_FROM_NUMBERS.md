# G81 - the fighter's NUMBERS become a Character Creator BODY: sliders, values, licence (Grok)

Source: grok.com chat "MMA Physique Slider Mapping Guide", Expert mode, 112 sources, collected S62
2026-09-24 by Claude from Grok's pasted artifact. Task: TASK_G81_PHYSIQUE_FROM_NUMBERS.md. Grok's
labels kept: MEASURED (study, N) / DERIVED (formula shown) / JUDGEMENT / NOT FOUND.

## THE THREE THINGS CLAUDE TAKES FROM IT (lead's reading, 2026-09-24)
1. **A generator is LEGAL only OFFLINE.** Reallusion EULA §5 allows selling/publishing "Original
   Character Creations" in games, BUT forbids (A) "use in any character generation system", (C) "any
   character-generating business", (D) selling the base mesh on a marketplace. So: our CC5 Python
   script shapes a body per athlete and EXPORTS a baked FBX; the game ships baked, selectable
   fighters. **The game must never expose CC sliders or morph targets to the player.** Forum counsel
   summary (Dec 2025) draws the same line. Not legal advice; send §5 and the content table to counsel
   before a store build.
2. **Trial exports are not a shipping path.** 30 exports, no reset, staff will not raise it; a
   bought CC5 licence (perpetual ~$299-498 or CC 365) removes the cap, clock, watermark, resolution
   caps. The calibration that turns Grok's JUDGEMENT cells into MEASURED ones is 18 sliders x 2 sexes
   x 2 scales = 72 exports - a bought-licence job. This is the `reallusion-licence` item on the board.
3. **Class anthropometry exists for men (Santos N=127, Kirk 2,229 bouts, Reale DXA, Matthews N=616),
   is thin for women (Reale N=5), and NO MMA study gives biacromial width or girths** - the only
   girths with N are boxers (Lunt HW N=237, Khanna N=35). Every slider value below is JUDGEMENT
   anchored on those; Character Scale A is the only slider with a measured slope (93 cm/unit, ours).

## Inputs the generator may use
height_cm, weight_kg (prefer fight-night; else competition_weight_kg), sex, reach_cm; optional
leg_reach_cm. Lean reference BMI = 23. Character Scale A = 93 cm per unit (operator-measured, S60).

## 0. Classes
Unified MMA limits (kg): Atom 47.6, Straw 52.2, Fly 56.7, Bantam 61.2, Feather 65.8, Light 70.3,
Super Light 74.8, Welter 77.1, Super Welter 79.4, Middle 83.9, Super Middle 88.5, LHW 93.0,
Cruiser 102.1, HW 120.2, Open no cap. Boxing extras: Light-fly 49.0, Fly 50.8, Super-fly 52.2,
Bantam 53.5, Super-bantam 55.3, Feather 57.2, Super-feather 59.0, Super-light 63.5, Welter 66.7,
Super-welter 69.9, Middle 72.6, Super-middle 76.2, LHW 79.4, Cruiser 90.7, Bridger 101.6.

## 1. Anthropometry by weight class

### 1.2 Shared constants
- MEASURED Matthews et al. 2022, UFC 2020-22, N=616 men, stature 177.1 +- 4.7 cm: -6.7% body mass
  in the 72 h before weigh-in; +9.7% weigh-in to competition.
- MEASURED Reale et al. 2024, N=33 pros / 80 fights, DXA subset N=26 / 40 fights. Chronic-phase
  body fat: men 15.6 +- 3.1% -> 12.8 +- 2.5%; women 21.3 +- 2.5% -> 17.6 +- 3.3%. FFM as % of
  division limit after chronic phase: men 97.5 +- 2.5%, women 91.6 +- 3.5%. Men by class: fly
  98.2, bantam 97.7, feather 98.5, light 95.8 (+- 2-3). Acute loss ~5.7 +- 1.3% BM.
- DERIVED fight-night mass: k_regain = 1.09 (<93 kg), 1.05 (93-120), 1.02 (>120); mass_fn =
  competition_weight_kg * k_regain (heavyweight steps are JUDGEMENT).
- DERIVED BF_fn = BF_chronic * (mass_chronic / mass_fn); FFM = mass_fn * (1 - BF_fn); FFMI = FFM / h^2.
- NOT FOUND: class-stratified DXA BF% and girths for every class in both sexes.

### 1.3 Men, MMA (stature: Santos et al. 2024 N=16 per class, total 127; Kirk 2024 2,229 bouts)
| Class | Limit | Stature cm | Comp BMI | FN BMI | BF% WI | BF% FN | FFMI | Biacromial | Girths |
|---|---|---|---|---|---|---|---|---|---|
| Fly | 56.7 | 168.4 +- 3.6 MEASURED (Kirk armspan 170.8, N=109 bouts) | 20.1 +- 0.9 MEASURED | 21.9 DERIVED | 10.6-13.2 MEASURED (Reale individuals) | 11 JUDGEMENT | 19.5 DERIVED | NOT FOUND | NOT FOUND |
| Bantam | 61.2 | 171.5 +- 4.1 MEASURED (armspan 175.0, N=241) | 20.9 +- 1.0 | 22.8 DERIVED | Reale pool | 11 JUDGEMENT | 20.4 DERIVED | NOT FOUND | NOT FOUND |
| Feather | 65.8 | 175.0 +- 5.2 MEASURED (armspan 180.0, N=258) | 21.7 +- 1.3 | 23.7 DERIVED | Reale FFM/limit 98.5% | 12 JUDGEMENT | 20.9 DERIVED | NOT FOUND | NOT FOUND |
| Light | 70.3 | 175.8 +- 4.1 MEASURED; Kirk W/L 177.5 / 177.9, N=307 | 22.5 +- 1.4 | 24.5 DERIVED | Reale 95.8% | 12 JUDGEMENT | 21.7 DERIVED | NOT FOUND | NOT FOUND |
| Welter | 77.1 | 182.6 +- 3.5 MEASURED; Kirk 182.9 / 181.8, N=326 | 22.8 +- 1.0 | 24.9 DERIVED | 12.8 MEASURED pooled | 11.7 DERIVED | 21.7 DERIVED | NOT FOUND | NOT FOUND |
| Middle | 83.9 | 184.9 +- 4.1 MEASURED; Kirk 184.9 / 184.3, N=234 | 24.4 +- 1.2 | 26.6 DERIVED | 12.8 pooled | 11.7 DERIVED | 22.8 DERIVED | NOT FOUND | NOT FOUND |
| LHW | 93.0 | 191.3 +- 3.0 MEASURED; Kirk 188.7 / 187.9, N=182 | 25.8 +- 1.9 (listed 94.6 kg) | 27.1 DERIVED | 14 JUDGEMENT | 13 JUDGEMENT | 23.3 DERIVED | NOT FOUND | NOT FOUND |
| HW | 120.2 | 191.5 +- 4.3 MEASURED; Kirk 191.1 / 190.2, N=181 | 31.5 +- 2.0 (listed 115.7) | 33.1 DERIVED | 18 JUDGEMENT | 16 JUDGEMENT | 26.3 DERIVED | NOT FOUND | boxing proxy 1.6 |
Super Light, Super Welter, Super Middle, Cruiser, Open: NOT FOUND as populated MMA means; interpolate stature between neighbours (JUDGEMENT).
Kirk 2016 whole sample N=474: stature 177.49 +- 9, mass 74.26 +- 14.86, S:W 1:1.024 MEASURED. Evans 2022 DXA N=22 men: 180.3 +- 6.7 cm, 86.5 +- 11.5 kg.

### 1.4 Women, MMA (heights are roster scrapes = JUDGEMENT; Reale women N=5)
| Class | Stature | Comp BMI | FN BMI | BF% WI | BF% FN | FFMI |
|---|---|---|---|---|---|---|
| Atom 47.6 | 155.2 JUDGEMENT | NOT FOUND | - | - | - | - |
| Straw 52.2 | 160.2-161.0 JUDGEMENT | 20.3 DERIVED | 22.1 | 16.4 MEASURED Reale N=5 | 15.0 DERIVED | 17.3 DERIVED |
| Fly 56.7 | 165.4-168.2 JUDGEMENT | 20.0 DERIVED | 21.8 | 16-18 JUDGEMENT | 15 | 16.9 DERIVED |
| Bantam 61.2 | 170.2 JUDGEMENT | 21.1 DERIVED | 23.0 | 16-18 JUDGEMENT | 15 | 17.8 DERIVED |
| Feather 65.8 | 174.0 JUDGEMENT | 21.7 DERIVED | 23.7 | NOT FOUND | NOT FOUND | 18.3 DERIVED |
Evans 2022 DXA N=6 women: 164.3 cm, 63.3 kg, lean 46.7 kg -> FFMI ~17.3, BF ~26% DERIVED. UFC PI guidance mid-camp BF men 7-14%, women 14-24% = JUDGEMENT.

### 1.6 Boxing series (the only girths with N; shape priors, not MMA means)
- MEASURED Khanna et al. 2023, elite Indian boxers ISAK N=35: light (n=16) 168.7 cm / 55.9 kg / upper arm 26.4 relaxed 30.2 flexed / forearm 25.0; middle (n=8) 176.3 / 70.5 / 29.5 / 32.8 / 27.4; heavy (n=11) 183.9 / 87.0 / 33.0 / 37.3 / 29.2. Waist per band NOT FOUND in the public extract.
- MEASURED Lunt et al., heavyweight boxers 1889-2019, N=237: height 187.3 +- 6.5 (N=236), reach 195.2 +- 9.4 (222), mass 97.5 +- 11.5, BMI 27.8 +- 2.4, waist 87.9 +- 6.2 (184), neck 44.5 +- 2.4 (178), chest 109.1 +- 6.7 unexpanded / 116.0 expanded, biceps 39.8 +- 3.6 (182), forearm 33.3 +- 3.0, thigh 61.3 +- 5.9 (178), calf 40.3 +- 3.8 (180). Champions vs challengers +3.4 cm stature, +3.6 cm reach, +3.7 kg, same BMI and waist.
- Chaabene 2015 review, Bruzas series: no class x girth table with N found - do not invent.
- Reale 2019/2020 Olympic combat DXA: men FFM 90-95% of BM, women 80-85%; MMA sits above (97.5%).

### 1.7 Biacromial breadth
NOT FOUND in any MMA study. Population prior: men 36-41 cm, women 33-36; ratio to stature ~0.225 / 0.210. Fighter prior JUDGEMENT: biacromial_cm ~ k_sex * height_cm, k = 0.230 men / 0.215 women (Shoulder Width A is a soft-tissue morph and reads wider than bone).

## 2. Mapping to CC5 sliders
```
BMI      = weight_kg / (height_cm/100)**2
g        = clip(BMI / 23.0, 0.85, 1.30)          # the game's own girth
H = height_cm; R = reach_cm; sex_m = 1 if male else 0
bf_hat   = clip(0.11 + 0.004*max(0, BMI-23), 0.06, 0.28)   # men   (JUDGEMENT, Reale-anchored)
bf_hat   = clip(0.16 + 0.005*max(0, BMI-22), 0.06, 0.28)   # women
FFMI_hat = (weight_kg * (1 - bf_hat)) / (H/100)**2
Href     = mesh height at Character Scale A = 0 -> NOT FOUND, calibrate; placeholders male 180, female 168
```
| Slider | Stands for | Formula | Tag | Two-point calibration |
|---|---|---|---|---|
| Character Scale A | stature | (H - Href) / 93 | DERIVED (slope ours), Href NOT FOUND | set 0 and +1, measure vertex height; slope must reprint 93 |
| Shoulder Width A | biacromial/stature + deltoid | clip(((R/H) - 1.02)*8 + (g-1)*0.6, -1, 1) | JUDGEMENT | measure acromion-acromion at 0 and 1 |
| Shoulder Top Height A/B | acromion height | NOT FOUND | NOT FOUND | measure acromion-to-vertex at 0 and 1 |
| Deltoid Outer Curve | deltoid ML bulk | clip((FFMI_hat-21)*0.25 + (g-1)*0.8, -1, 1) | JUDGEMENT | bi-deltoid circumference |
| Deltoid Depth | deltoid AP | clip((FFMI_hat-21)*0.20, -1, 1) | JUDGEMENT | AP deltoid depth |
| Neck Scale | neck girth | clip((g-1)*1.2 + (FFMI_hat-21)*0.08, -1, 1) | JUDGEMENT (Lunt 44.5 cm) | neck circumference |
| Pectoral Scale | chest girth | clip((g-1)*1.4 + (FFMI_hat-21)*0.10, -1, 1) | JUDGEMENT (Lunt 109.1) | chest circumference |
| Abdomen Scale | waist vs BMI-23 lean | clip((g-1)*2.0 - (FFMI_hat-22)*0.15, -1, 1) | JUDGEMENT (Lunt waist 87.9 at BMI 27.8) | waist at navel |
| Upper Arm Scale | mid-arm girth | clip((g-1)*1.2 + (FFMI_hat-21)*0.15 + 0.5*((R/H)-1.03)*6, -1, 1) | JUDGEMENT + Khanna | mid-upper-arm |
| Upperarm Inner Scale | biceps peak | clip((FFMI_hat-21)*0.22, -1, 1) | JUDGEMENT | flexed arm |
| Forearm Scale | forearm girth + reach spill | clip((g-1)*0.9 + 0.5*((R/H)-1.03)*6, -1, 1) | JUDGEMENT | forearm girth |
| Forearm Inner Upper Scale | proximal forearm | NOT FOUND | NOT FOUND | 3 cm distal to crease |
| Hip Width A | hip breadth | clip((g-1)*1.0 + (0 if sex_m else 0.25), -1, 1) | JUDGEMENT | bi-iliac / bi-trochanteric |
| Quad Lower Inner Scale | medial thigh | clip((g-1)*1.1 + (FFMI_hat-21)*0.10, -1, 1) | JUDGEMENT (Lunt thigh 61.3) | mid-thigh |
| Hamstring Scale | posterior thigh | clip((FFMI_hat-21)*0.18, -1, 1) | JUDGEMENT | posterior thigh depth |
| Lower Leg Scale | calf | clip((g-1)*0.9 + (FFMI_hat-21)*0.08, -1, 1) | JUDGEMENT (Lunt calf 40.3) | max calf |
| Male Muscular pack | mesomorph overlay | clip((FFMI_hat-22)/6, 0, 1) if male else 0 | JUDGEMENT; packs are not cm-linear | measure chest/arm/thigh at pack 0 and 1; interaction with Scale A NOT FOUND |
| Male Skinny pack | ectomorph overlay | clip((20-FFMI_hat)/4, 0, 1) if male else 0; skinny = pack_s*(1-pack_m) | JUDGEMENT | same |
No slider is a reach or leg-reach control; reach is spent on Shoulder Width A + Upper Arm + Forearm (+0.15 for R/H 1.08). Leg reach: NOT FOUND - measure inseam at Lower Leg / Scale A 0 and 1.

### 2.2 Worked rows (Href_male 180 JUDGEMENT)
| Row | H | W | BMI | g | FFMI | ScaleA | ShW | Pect | Abd | UArm | Hip | Musc | Skinny |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| M fly | 168 | 57 | 20.2 | 0.88 | 19.3 | -0.13 | -0.15 | -0.20 | -0.20 | -0.20 | -0.12 | 0 | 0.18 |
| M fly tall | 178 | 57 | 18.0 | 0.85 | 17.2 | -0.02 | -0.10 | -0.25 | -0.30 | -0.22 | -0.15 | 0 | 0.70 |
| M bantam | 172 | 61 | 20.6 | 0.90 | 19.7 | -0.09 | -0.10 | -0.16 | -0.18 | -0.16 | -0.10 | 0 | 0.08 |
| M feather | 175 | 66 | 21.6 | 0.94 | 20.4 | -0.05 | -0.05 | -0.10 | -0.12 | -0.10 | -0.06 | 0 | 0 |
| M light | 178 | 70 | 22.1 | 0.96 | 20.8 | -0.02 | -0.02 | -0.07 | -0.08 | -0.06 | -0.04 | 0 | 0 |
| M welter lean 1.88 | 188 | 77 | 21.8 | 0.95 | 20.6 | +0.09 | +0.02 | -0.08 | -0.10 | -0.05 | -0.05 | 0 | 0 |
| M welter stocky 1.72 | 172 | 77 | 26.0 | 1.13 | 23.4 | -0.09 | +0.10 | +0.22 | +0.20 | +0.20 | +0.13 | 0.23 | 0 |
| M middle | 185 | 84 | 24.5 | 1.07 | 22.7 | +0.05 | +0.06 | +0.12 | +0.08 | +0.12 | +0.07 | 0.12 | 0 |
| M LHW | 190 | 93 | 25.8 | 1.12 | 23.4 | +0.11 | +0.10 | +0.20 | +0.16 | +0.18 | +0.12 | 0.23 | 0 |
| M HW listed | 192 | 116 | 31.5 | 1.30 | 26.3 | +0.13 | +0.22 | +0.55 | +0.45 | +0.50 | +0.30 | 0.72 | 0 |
| M HW tall | 198 | 116 | 29.6 | 1.29 | 25.2 | +0.19 | +0.20 | +0.50 | +0.40 | +0.45 | +0.29 | 0.53 | 0 |
| W straw | 160 | 52 | 20.3 | 0.88 | 17.1 | n/a | -0.2 | -0.2 | -0.24 | -0.2 | +0.13 | 0 | 0 |

### 2.3 Calibration protocol (the only way to replace JUDGEMENT)
Base at Scale A 0, all sliders 0, packs off: measure the landmark. Set slider to 1: re-measure.
slider = (cm_target - cm_0) / (cm_1 - cm_0). Repeat at Scale A for 165 cm and 198 cm; if cm/unit
changes >15% the morph is not scale-invariant and the generator stores two slopes. 18 sliders x 2
sexes x 2 scales = 72 exports -> bought licence.

## 3. Licence and export limits (Grok, verbatim where quoted)
Sources: Software EULA https://www.reallusion.com/Content/EULA/AP/EULA_DEAP.htm ; Content License Policy https://www.reallusion.com/license/content.html ; Content EULA https://www.reallusion.com/Content/EULA/EULA.htm ; CC5 trial comparison table; Reallusion staff forum replies.

### 3.1 Trial
MEASURED (Reallusion's trial-vs-full table): time limit 30 days; export FBX/OBJ/USD 30 times (full: unlimited); video 30 s / 720p / watermark; image 800x600; save project unlimited. Staff: extra export credits are NOT granted on the trial; buy (14-day money-back). NOT FOUND: any statement that the counter resets on reinstall or a new machine - treat as one 30-day clock, 30 exports, no reset. A bought licence (perpetual ~$299-498 or CC 365) removes cap, clock, watermark and resolution caps; subscription outputs made during the paid term remain yours (EULA 2.3.D).

### 3.2 Shipping exported characters in a commercial game
EULA §2.1 (verbatim): "For Reallusion Software purchased under a perpetual license or used under an active subscription license, Reallusion grants you: A. A non-exclusive, non-sublicensable, non-transferable, revocable right to use the Software to generate images, videos, avatars, models, and/or animations. ... B. The right to export generated models and/or animations to external software and include them in your games, applications, web services, or other interactive projects."
EULA §2.2 (verbatim): "You may sell or redistribute images and videos created with properly licensed Reallusion Software, with full ownership and usage rights. You may also sell or distribute models and/or animation assets only when embedded within games, applications, interactive projects, or in 3D print format, provided such use does not infringe the Character Creator Base Model License (Section 5) or Reallusion's content usage rights."
EULA §5 Character Creator Base Model License (verbatim): "Reallusion grants you a perpetual, non-exclusive, non-sublicensable, revocable, nontransferable right to use CC Avatar to generate your Original Character Creations. You may sell, distribute, and publish your Original Character Creations for any commercial use, including but not limited to image/video outputs, games, XR, interactive online services, and 3D printing, without limitation, except for the following restrictions: A. Use in any character generation system. B. Use for AI training, machine learning, or synthetic data generation purpose. C. Use in any character-generating business. D. Selling the 3D model created from Character Creator's Base Model as a content asset in any third-party marketplace, regardless of file format. If the CC Avatar is not your original creation, or if you do not have the license or permission from the original creators ... you may not sell, distribute, or publish the CC Avatar in any content marketplace or for any commercial use ..."
KB "Can I sell the characters I create with Character Creator?" (Print53107): the CC topology is Reallusion's property; do not transform CC models into other formats for marketplace distribution (5.1) or use the characters or morph assets to build another character generation system in games or interactive services (5.2).
Content licence, games row: Standard - export to 3rd-party software yes; embed into any application or service: dash (Enterprise yes); 2D/3D assets deploy in games yes; CC Components on unlimited commercial characters yes.
How it lands on FightCamp: baked morphs exported as finished selectable fighters = allowed (§2.1.B, §5) provided the base is not resold and the PLAYER cannot drive CC sliders/morphs live (§5.A / KB 5.2). A live in-game character creator on RL morphs is the banned "character generation system" (Enterprise or no). Store-bought clothes/hair follow the Content EULA; "embed into any application" is an Enterprise tick that staff have invoked for some embeddings. Trial exports are not a commercial-shipping path: buy the licence first. Not legal advice.

## 4. Against itself - which slider breaks first
Abdomen Scale first: g = BMI/23 collapses a lean 1.88 m welter, a dense 1.72 m welter and a fat 1.72 m welter onto one number; bf_hat will be off by three points (Reale's 12.8% is a fly-to-light pool) and the mesh grows a gut on a stocky wrestler or irons one off a walking-heavy HW. The best waist anchor is boxers (Lunt N=184), a different sport. Male Muscular pack second: an authored overlay built on default-height Aaron, applied AFTER Scale A has stretched a 1.65 m fly or 1.98 m HW - the interaction is NOT FOUND and is what the 72-export calibration is for. Character Scale A is least likely to be directionally wrong but a 5 cm Href error is a 5 cm fighter on every card. Reach has no slider: spending it on shoulder and arm scales widens the torso before it lengthens the humerus.

## Sources (short)
Reale, Wang et al. 2024 IJSNEM (PMID 38871343); Kirk 2024 RQES 95(2) 450-457; Kirk 2016 (N=474); Kirk 2018 Human Movement; Santos et al. 2024 (UFC top-16 x 8, N=127); Matthews et al. 2022 (N=616); Evans et al. 2022 (DXA 22 M / 6 F); Lunt et al. 2019/2020 (HW boxers N=237); Khanna et al. 2023 (N=35 ISAK); Chaabene et al. 2015; ABC Unified Rules; Reallusion EULA §2, §5; Content License Policy; CC5 trial comparison; Reallusion forum staff replies.
