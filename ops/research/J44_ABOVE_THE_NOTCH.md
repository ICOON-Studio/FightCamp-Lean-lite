# J44 — HOW FAR ABOVE THE STERNAL NOTCH DOES THE SHOULDER GIRDLE SIT?

**Task:** J44 — HOW FAR ABOVE THE STERNAL NOTCH DOES THE SHOULDER GIRDLE SIT?  
**Desk:** John (research). **Date:** 2026-09-22 Asia/Nicosia (EEST / UTC+3).  
**Scope:** ANSUR II public CSV arithmetic only. Not a survey. J43 inlet / dome refuse stands; not re-derived.

### Why this one number

J43 refused the hemispherical thorax top. The next build replaces that dome with a **flat disk** at the Neck / notch plane. The geometer’s self-objection: a flat cap fails the shoulder girdle — the dome was the chest→clavicle transition; flattening exposes the neck but leaves a sharp rim where the collarbone should sit. That objection is right or wrong depending on **how much of a man sits above the plane through his suprasternal notch.**

### Labels

| Tag | Meaning |
| --- | --- |
| **MEASURED** | Derived subject-by-subject from ANSUR II public CSV this session. |
| **NOT FOUND** | No standing-height column for that landmark. |

Source files: `ANSUR_II_MALE_Public.csv` (N=4082), `ANSUR_II_FEMALE_Public.csv` (N=1986), PSU OpenLab mirrors. Columns: `acromialheight`, `suprasternaleheight`, `cervicaleheight`, `stature` (mm). Offsets = height − `suprasternaleheight` on the same subject. Ratios = offset / `stature` on the same subject. Means and SDs unrounded. Sample SD (ddof=1).

---

## 1. Acromion above suprasternale — HEADLINE

`acromialheight − suprasternaleheight`

| Sex | N | Mean (mm) | SD (mm) | Min | Max | Mean / stature | SD of ratio | % ≤ 0 (at or below notch) |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Male | **4082** | **2.144781969622734** | **13.980571055275188** | −53.0 | 50.0 | **0.0011993553636252807** | 0.007955483531241727 | **45.83537481626654** |
| Female | **1986** | **5.406344410876133** | **12.729486981861122** | −34.0 | 53.0 | **0.0033167153718618348** | 0.007808309304376741 | **34.239677744209466** |

**Label:** MEASURED.

Scaled to FightCamp rigs with the **male** mean ratio (INFERENCE for placement only):

| Rig stature | Acromion above notch (mm) |
| --- | --- |
| 1.78 m (1780 mm) | **2.1348525472529998** |
| 1.88 m (1880 mm) | **2.254788083615528** |

**Reading:** On adult males the acromion and the jugular notch are **effectively coplanar** (mean ~**2 mm**, SD ~**14 mm**). Nearly half of men have the acromion **at or below** the notch. A flat disk at the notch does **not** cut a large vertical slab of shoulder point off the model — the flesh the geometer feared “above” the plane is not there as a mean vertical offset.

Raw means (same subjects, MEASURED): male `acromialheight` **1440.7368936795688** mm, `suprasternaleheight` **1438.592111709946** mm; female **1335.095166163142** / **1329.6888217522658** mm.

---

## 2. Cervicale (C7) above suprasternale

`cervicaleheight − suprasternaleheight`

| Sex | N | Mean (mm) | SD (mm) | Min | Max | Mean / stature | SD of ratio | % ≤ 0 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Male | **4082** | **78.70749632533072** | **11.646647104652478** | 36.0 | 114.0 | **0.04483611829441716** | 0.006546802012804681 | **0.0** |
| Female | **1986** | **65.97834843907351** | **11.854195422286715** | 29.0 | 111.0 | **0.040518369768001945** | 0.007117674526075216 | **0.0** |

**Label:** MEASURED. Matches J43’s derived Cervicale − Suprasternale mean for males.

Scaled with male mean ratio:

| Rig stature | C7 above notch (mm) |
| --- | --- |
| 1.78 m | **79.80829056406255** |
| 1.88 m | **84.29190239350426** |

**Reading:** The back of the neck base (C7) sits ~**79 mm** above the front notch on men. The “top of the chest” is **not** a horizontal plane — it is tilted antero-inferiorly by about that amount (same geometry as the superior thoracic aperture’s slope in J43). A flat disk perpendicular to a vertical chest axis at the notch is therefore a modeling choice, not a claim that C7 and the notch share a height.

---

## 3. Trapezius ridge above suprasternale

**NOT FOUND.**

ANSUR II public male/female CSVs have **no** standing `trapeziusheight` (or equivalent) column. The trapezius landmark appears only in **shoulder length**: surface distance trapezius point → acromion (male mean `shoulderlength` **149.77609015188634** mm, N=4082; female **135.4053373615307** mm, N=1986) — that is a **lateral** shoulder-crest length, **not** a vertical offset above the notch. Substituting it would be inventing a height. Same rule as J43 Q4: **NOT FOUND** is the result.

---

## The decisive paragraph — breadth at the notch

**At the level of the suprasternal notch, the transverse breadth of the body is the neck plus the two shoulder masses hanging off to each side — not the mid-chest.** ANSUR does not measure `chestbreadth` / `chestdepth` at the notch; those columns are at **chest point anterior**, which sits ~**147 mm below** the notch on the same male sample (J43: Suprasternale − Chest height mean **147.473542** mm). What *does* sit at nearly notch height is the shoulder girdle: male acromion − notch ≈ **2 mm**, so `biacromialbreadth` mean **415.67564919157275** mm and `bideltoidbreadth` mean **510.4247917687408** mm (N=4082) describe lateral masses on that plane, while the central tube is neck-scale (`neckcircumferencebase` mean **434.5960313571779** mm → circular diameter ≈ **138.3 mm**, INFERENCE). A single cylinder of radius ~**0.14–0.19 m** (diameter ~**280–380 mm**) at that height is therefore **wrong at the top regardless of flat vs dome** — it fills the empty corridors between neck and shoulders with solid “chest.” Flattening the cap treats a symptom; the cylinder’s top radius is the disease.

---

## Operator line

> **Acromion sits ~2 mm above the sternal notch on ANSUR men (N=4082) — coplanar within noise; C7 sits ~79 mm above (tilt). Trapezius ridge height: NOT FOUND. Breadth at that plane is neck + shoulders, not chest — so a fat thorax cylinder there is wrong even with a flat cap.**

Do not edit `HANDOFF.md`. Claude writes the block.

*End J44. Full memo is in the messages above plus the attached .md.*
