# J41 — SHOULDER GIRDLE PROPORTIONS

**Task:** J41 — SHOULDER GIRDLE PROPORTIONS  
**Desk:** John (research). **Date:** 2026-09-22 Asia/Nicosia (UTC+3).  
**Not audio.** J40/J22B audio is closed. Do not reopen Pile A.  
**Scope:** Paper only — no code, no checkout, no `.gd` edits.

### Problem statement (Dola)

FightCamp models a fighter as **CAPSULES** (segment between two bone positions + radius) so a grapple can ask “can a hand reach this body part.” Dola derived a rule that **insets each capsule endpoint by its own radius**. It works on the **NECK** (one simple segment). She warned unprompted: the rule “tapers every joint segment to a needle at both ends — scale this to spine, shoulders, hips, and you do not have an anatomical rig any more; you have a stick figure with collision balloons.” She is **not** confident about the **SHOULDER GIRDLE**, where segments overlap and curves are compound.

Dola’s rule removes **one radius from each end**. So **r/L** (radius over length) decides survival: high r/L → segment consumed → nearly nothing left; low r/L → survives. Remaining length ≈ **L − 2r**. Needle when r/L ≥ 0.5.

### Label legend

| Tag | Meaning |
| --- | --- |
| **MEASURED** | Primary source opened this session (PDF/CSV/HTML); numbers taken from that file. |
| **DOCUMENTED** | Confirmed via secondary live page, search extract of a primary paper, or peer summary of named primary. |
| **INFERENCE** | Arithmetic conversion (e.g. breadth→radius, circ→r via circular assumption) or modeling judgment stated as such. |
| **NOT FOUND** | Searched; no clean figure. Prefer this over inventing numbers to fill a table. |

Every share has a denominator (N, sex, population). Prefer NOT FOUND over interpolation.

---

## 1. The segments themselves

Primary adult-male reference for soft-tissue limb lengths/circumferences: **ANSUR II male working database**, N = **4082**, U.S. Army Total Army (Active + Guard/Reserve), ages 17–58, measured 2010–2012 (Gordon et al., NATICK/TR-15/007). Official public CSV downloaded this session from `tools.openlab.psu.edu/publicData/ANSUR_II_MALE_Public.csv` (**MEASURED**). Summary means also cross-checked against TR-15/007 PDF text extract (**MEASURED**).

Bone morphometry for clavicle/scapula is **not** in ANSUR (ANSUR is surface anthropometry). Clavicle/scapula numbers below are from named osteometric/CT/cadaver papers.

### 1.1 Clavicle

| Quantity | Value | Population | Label |
| --- | --- | --- | --- |
| Max length, right male | **155.12 ± 10.06 mm** | Madrid documented collection, n=45 males, age 20–92 (Alcina et al. 2015) | **MEASURED** (PDF) |
| Max length, left male | **157.02 ± 10.31 mm** | same | **MEASURED** |
| Midshaft circumference, right male | **38.00 ± 3.68 mm** | same | **MEASURED** |
| Midshaft circumference, left male | **37.26 ± 3.73 mm** | same | **MEASURED** |
| Sternal epiphyseal width (SEW), right male | **24.62 ± 3.62 mm** | same | **MEASURED** |
| Acromial epiphyseal width (AEW), right male | **24.35 ± 3.88 mm** | same | **MEASURED** |
| Max length, right male | **153.52 ± 8.79 mm** | KwaZulu-Natal dry clavicles, n=66 male (Ishwarkumar et al. 2016) | **MEASURED** (PDF) |
| Midshaft circumference, male R+L pooled | **38.64 ± 3.95 mm** | same | **MEASURED** |
| Length, Chinese male CT | **152.9 ± 9.3 mm** | Qiu et al. 2016, Chinese CT cohort (search synthesis; full PDF 403 this session) | **DOCUMENTED** |
| Midshaft diameter (narrowest), Indonesian male CT | **13.37 mm** (median/mean reported as 13.37; range spans) | East Java 3D-CT, male n=342 (search synthesis) | **DOCUMENTED** |
| Midshaft width/thickness minima, Chinese male | width **~12.7 mm**, thickness **~11.7 mm** (narrowest midshaft planes) | Qiu et al. 2016 (search synthesis) | **DOCUMENTED** |

**Effective cross-section radius (INFERENCE):** treating midshaft as circular from circumference:  
r_mid = MidC / (2π). Spanish right male: **r_mid = 6.05 mm**. KZN male: **r_mid = 6.14 mm**.  
End half-breadths (INFERENCE): r_sternal ≈ SEW/2 = **12.31 mm**; r_acromial ≈ AEW/2 = **12.17 mm** (Spanish right male).

**ANSUR surface proxies (not bony clavicle):**
- **Shoulder Length** = tape from trapezius (neck–shoulder) → acromion. Male mean **149.78 mm** (CSV) / **14.98 cm** (TR-15/007). **MEASURED**. Soft surface path, not bone length.
- **Clavicle Link** (derived) = ½ × Biacromial Breadth. Male mean **208.1 mm** (TR-15/007) / CSV biacromial/2 = **207.84 mm**. **MEASURED**. This is midline→acromion *breadth half*, **not** clavicle bone length. Do not use as L for a bony clavicle capsule.

### 1.2 Scapula — how literature measures “length”

Literature uses several non-interchangeable lengths:

| Measure | Definition | Male (or mixed) mean | Source | Label |
| --- | --- | --- | --- | --- |
| **Maximum scapular height** | Superior angle → inferior angle | **155 ± 16 mm** | von Schroeder, Kuiper, Botte 2001; 15 cadaver pairs | **DOCUMENTED** (PubMed/DOI abstract; full text timed out) |
| **Spine of scapula length** | Medial end of spine at medial border → lateral edge of acromion | **134 ± 12 mm** | same | **DOCUMENTED** |
| Medial-border thickness (1 cm from edge) | Plate thickness | **4 ± 1 mm** | same | **DOCUMENTED** |
| Spine AP width @ 1 cm / 4 cm from medial / spinoglenoid | Triangular spine cross-section | **7 ± 1 / 18 ± 3 / 46 ± 6 mm** | same | **DOCUMENTED** |
| Scapular length / breadth | Radiograph left scapula | length **157.22 ± 2.91 mm**, breadth **106.92 ± 2.09 mm** (male) | Bangladeshi radiological n=50 male (search/DOI synthesis) | **DOCUMENTED** |
| Scapular spine length | Medial border → lateral spine point | **107.83 ± 1.66 mm** (male, same Bangladeshi series) | same | **DOCUMENTED** |

**Capsule mapping pick (honest):** the measurement that maps most cleanly to a capsule between **two named landmarks** is **spine-of-scapula length** (medial spine terminus ↔ acromion), L ≈ **134 mm**. That is still a *plate edge*, not a fleshy limb. Maximum height (superior↔inferior angle) is a vertical plate axis and is a worse capsule for “reach this body part” grappling queries.

**Soft-tissue radius over scapula:** **NOT FOUND** as a single surveyed capsule radius (subscapular skinfold exists in some surveys; ANSUR II public CSV does not expose a scapular soft envelope radius usable here).

### 1.3 Upper-arm segment from glenohumeral joint

| Quantity | Value | Population | Label |
| --- | --- | --- | --- |
| **Acromion–Radiale length** (upper arm link) | mean **335.24 mm**, SD 17.48, N=4082 | ANSUR II male | **MEASURED** (CSV); TR-15/007 mean 33.52 cm |
| **Shoulder–Elbow length** (acromion→olecranon, elbow flexed 90°) | mean **363.71 mm**, SD 18.20 | ANSUR II male | **MEASURED** |
| **Biceps circumference, flexed** | mean **358.14 mm**, SD 34.61 | ANSUR II male | **MEASURED** |
| **Wrist circumference** | mean **175.92 mm**, SD 8.95 | ANSUR II male | **MEASURED** |
| **Forearm circumference, flexed** | mean **310.06 mm**, SD 21.99 | ANSUR II male | **MEASURED** |
| **Bideltoid breadth** | mean **510.42 mm** | ANSUR II male | **MEASURED** |
| **Biacromial breadth** | mean **415.68 mm** | ANSUR II male | **MEASURED** |
| Dempster 1955 upper-arm link length | **~293–294 mm** (11.55–11.58 in) | Michigan cadavers (search/secondary) | **DOCUMENTED** |
| de Leva 1996 upper-arm *inertial* params | mass 2.71% BM; CM 57.72% from proximal; **absolute length table not extracted this session** | young adult Caucasian (Zatsiorsky-adjusted) | **NOT FOUND** (absolute mm) / inertial ratios **DOCUMENTED** via secondary |

**Radii (INFERENCE, circular soft-tissue assumption):**  
- Proximal/mid soft radius from flexed biceps: r = C/(2π) = **57.00 mm**  
- Distal soft radius from wrist circ: r = **28.00 mm**  
- Unflexed biceps circumference: **NOT FOUND** in ANSUR II public measure list (flexed only). Using flexed **overstates** resting soft radius for a neutral-pose capsule — stated caveat.

**Landmark note:** Acromion–Radiale is the standard biomechanics upper-arm segment (near GH → elbow). Shoulder–Elbow is slightly longer (to olecranon underside). Neither is pure “humeral bone length”; both are surface/landmark distances.

---

## 2. THE DECIDING TABLE: r/L per segment

**Rule:** remaining ≈ L − 2r. **SURVIVES** if remaining ≫ 0 and still a usable collision body; **NEEDLE / nearly nothing** if r/L → 0.5 or remaining ≈ 0.  
**r definition stated per row.** Soft-tissue circular conversion labeled **INFERENCE**.

| Segment (as modeled) | L (mm) | r (mm) | r definition | r/L | L−2r (mm) | Survive? | Source / label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Clavicle bone midshaft** | 155.12 | 6.05 | MidC/(2π) | **0.039** | **143.0** (92% left) | **SURVIVES** easily | Spanish ♂ R, n=45 **MEASURED** + **INFERENCE** |
| **Clavicle bone midshaft** | 153.52 | 6.14 | MidC/(2π) | **0.040** | **141.2** | **SURVIVES** | KZN ♂ R, n=66 **MEASURED** + **INFERENCE** |
| **Clavicle if inset uses end half-breadths** | 155.12 | 12.24 avg | SEW/2 & AEW/2 | **0.079** | **130.6** | **SURVIVES** | Spanish ♂ **MEASURED** + **INFERENCE** |
| **Scapula as spine capsule** | 134 | 2.0 | half medial-border thickness 4 mm | **0.015** | **130** | **SURVIVES** as *thin plate* (geometry wrong — see §6) | von Schroeder **DOCUMENTED** + **INFERENCE** |
| **Scapula spine mid half-width** | 134 | 9.0 | half of 18 mm spine width @4 cm | **0.067** | **116** | **SURVIVES** | same |
| **Scapula soft envelope** | — | — | — | — | — | **NOT FOUND** | no single soft r |
| **Upper arm AR + flexed-biceps r** | 335.24 | 57.00 | C_flex/(2π) | **0.170** | **221.2** (66% left) | **SURVIVES**, loses ~⅓ | ANSUR II ♂ N=4082 **MEASURED** + **INFERENCE** |
| **Upper arm SE + flexed-biceps r** | 363.71 | 57.00 | same | **0.157** | **249.7** (69% left) | **SURVIVES** | same |
| **Upper arm AR + avg(biceps,wrist) r** | 335.24 | 42.5 | avg of prox/dist soft r | **0.127** | **250.2** | **SURVIVES** | same **INFERENCE** |
| **Soft “shoulder length” + deltoid thickness as r** | 149.78 | 17.8 | MRI deltoid thickness ~17.8 mm ♂ (Thai vaccine MRI; **DOCUMENTED** search) | **0.119** | **114.2** | **SURVIVES** but this is a *forced* soft path, not a true girdle capsule | ANSUR SL **MEASURED** + deltoid **DOCUMENTED** |
| **Neck (comparison only)** | — | 63.3 | neck circ/(2π); circ mean 397.65 mm | — | — | Neck L for Dola’s successful case **NOT re-derived here** | ANSUR II ♂ **MEASURED** r only |

### Verdict line for Dola (single sentence)

**On measured adult-male numbers, bony clavicle and scapular-spine plates have very low r/L (≈0.02–0.08) and survive double-end inset; the soft upper-arm capsule has r/L ≈0.16–0.17 and also survives but loses about one-third of its length — none of the three honest segments needles out. The girdle failure mode is not “high r/L needles every bone”; it is that scapula/clavicle soft volumes are compound overlapping envelopes that a single radius-and-length pair misrepresents.**

---

## 3. Where segments genuinely OVERLAP

Anatomical pairs that **legitimately occupy the same space** (or nest):

1. **Deltoid ↔ glenohumeral capsule / proximal humerus** — deltoid wraps the GH joint; a hand on the “shoulder” contacts deltoid soft tissue that covers the joint, not a bare humeral head capsule endpoint.
2. **Scapula ↔ thoracic wall / ribs (2–7)** — scapula glides on a soft-tissue plane over the rib cage; any scapular “capsule” that ignores the thorax will either float or falsely collide.
3. **Clavicle ↔ first rib / subclavius / neurovascular bundle** — clavicle sits above the first rib; inferior soft tissue and vessels occupy the subclavicular space.
4. **Clavicle ↔ acromion / AC joint / trapezius–deltoid origin** — lateral clavicle and acromion meet at AC; trapezius and deltoid share the acromial/clavicular roof.
5. **Scapular spine ↔ trapezius / infraspinatus / supraspinatus fossae** — spine is a ridge with muscle filling both fossae; a cylinder along the spine ignores the filled fossae.
6. **Proximal upper-arm capsule ↔ axillary fold / latissimus / pec major insertions** — scye region is a soft junction, not a hard capsule end at acromion alone.

**Contrast with model defect framing:** a game capsule system that treats **any** inter-capsule overlap as a bug will fight anatomy here. Overlap at the shoulder girdle is **feature**, not defect. Dola’s neck worked partly because neck is a single tube with little competing volume; the girdle is a **compound joint stack**.

---

## 4. Does it scale?

**One-sentence answer:** **Lengths track stature; soft radii track mass/BMI far more — so girdle r/L is not stature-invariant the way a clean neck tube can appear; heavier athletes raise r/L and eat more of L under Dola’s inset.**

Evidence from ANSUR II male N=4082 this session (**MEASURED** correlations on official CSV):

| Pair | Pearson r | Note |
| --- | --- | --- |
| Acromion–Radiale vs stature | **0.795** | lengths scale with height |
| Shoulder–Elbow vs stature | **0.817** | |
| Shoulder Length vs stature | **0.409** | weaker |
| Biceps flexed circ vs stature | **0.192** | weak |
| Biceps flexed circ vs weightkg | **0.812** | circ tracks mass |
| Biceps flexed circ vs BMI | **0.818** | |
| **r/L (biceps_r / AR) vs stature** | **−0.226** | slightly lower r/L when taller |
| **r/L vs weight** | **+0.554** | heavier → higher r/L |
| **r/L vs BMI** | **+0.750** | build dominates |

Clavicle bone allometry across stature in athletes: **NOT FOUND** as ANSUR bone data (surface only). Osteometric papers are population means, not stature regressions opened this session.

**Implication:** Neck “scaled cleanly” for Dola is **not** license to assume constant r/L across fighter builds. A heavyweight’s upper-arm flexed r/L will consume more under inset than a lightweight’s.

---

## 5. Argue against yourself — then land

### Strongest case that capsules are the **wrong** abstraction for a shoulder

1. **Topology:** The shoulder is a **ball-and-socket + floating plate + S-curved strut**, not a chain of constant-radius tubes. Scapula is a **triangle**; clavicle is an **S-curve** with changing cross-section (circular medial → flat lateral).
2. **One r cannot serve both ends:** Clavicle midshaft r≈6 mm vs end half-breadth ≈12 mm; upper arm flexed mid r≈57 mm vs wrist r≈28 mm. Dola’s single-r inset is already a lie at the ends.
3. **Overlap is load-bearing anatomy:** Deltoid wrapping GH, scapula on thorax — reach queries need **union of volumes**, not non-overlapping capsules.
4. **Better primitives:** mesh SDF / voxel distance field of the skinned mesh; multi-sphere (MetaHuman/physics style); ellipsoids at deltoid and thorax; wrapping surfaces (scapulothoracic); separate **bone** capsules (low r) from **soft** envelopes (high r) that are allowed to overlap.
5. **Grapple semantics:** “Can a hand reach the shoulder?” is a **surface** question on deltoid/upper trapezius, not a question about the clavicle bone midline after inset.

### Land which side

**Land: capsule model is OK for the upper-arm segment with explicit caveats; it is the wrong primary abstraction for the shoulder girdle as a whole (scapula especially). Do not roll Dola’s uniform double-end inset beyond the neck without a per-segment policy.**

Practical split:
- **Upper arm:** keep capsule; prefer r from a **resting** circumference when available (currently flexed-only → overstate); inset is survivable (r/L≈0.16).
- **Clavicle:** if you need a bony strut capsule, r_mid≈6 mm works and survives — but that capsule is **not** the grapple target surface.
- **Scapula:** do **not** force a constant-r capsule; use plate/ellipsoid/mesh or accept a multi-sphere stack.
- **Girdle soft envelope:** allow **intentional overlap**; treat overlap as anatomy.

---

## 6. WHAT IS STILL WRONG / operator decision line

Still wrong / open:
1. No ANSUR **unflexed** upper-arm circumference → soft r for neutral pose is biased high (**NOT FOUND** unflexed).
2. No surveyed **single soft radius** for scapular or clavicular soft envelopes (**NOT FOUND**).
3. de Leva absolute segment lengths in mm **NOT FOUND** this session (inertial ratios only via secondary).
4. Qiu 2016 full midshaft table PDF **403** this session — mid diameters cited as **DOCUMENTED** from search synthesis only.
5. Beast `RESEARCH_INDEX.md` grep from Windows path failed on this box; GitHub index not grepped for prior shoulder notes this pass (**NOT FOUND** priors).
6. Athlete-specific (pro fighter) morphometry beyond military ANSUR: **NOT FOUND**.

**Operator decision line for rolling Dola’s rule beyond neck:**

> **Do not apply the same double-end radius inset uniformly across the shoulder girdle.** Keep it on neck (proven). For upper arm, inset is numerically safe (r/L≈0.17, ~66% length remains) but use a resting soft radius when you have one. For clavicle bone, inset is safe but the capsule is the wrong reach target. For scapula, refuse a single capsule — pick plate/multi-sphere/mesh. Allow girdle capsule overlaps; do not “fix” anatomical nesting. Revisit if/when unflexed arm circ and a soft shoulder envelope radius exist.

---

## 7. Sources (opened / used this session)

1. Gordon et al. 2015 — *2012 Anthropometric Survey of U.S. Army Personnel: Methods and Summary Statistics*, NATICK/TR-15/007. PDF: https://tools.openlab.psu.edu/publicData/ANSURII-TR15-007.pdf (**MEASURED**)
2. ANSUR II Male Public CSV: https://tools.openlab.psu.edu/publicData/ANSUR_II_MALE_Public.csv (**MEASURED**, N=4082)
3. OPEN Lab ANSUR II page: https://www.openlab.psu.edu/ansur2/
4. Alcina et al. 2015 — *Sexual dimorphism of the clavicle in a modern Spanish sample*, Eur J Anat 19(1):73–83. PDF: https://eurjanat.com/data/pdf/eja.140256cr.pdf (**MEASURED**)
5. Ishwarkumar et al. 2016 — KwaZulu-Natal clavicle morphometry, Int J Morphol 34(1):244–251. PDF: https://intjmorphol.com/wp-content/uploads/2016/04/art_35_341.pdf (**MEASURED**)
6. Qiu et al. 2016 — *Anatomical Study of the Clavicles in a Chinese Population*, BioMed Research International. DOI: https://doi.org/10.1155/2016/6219761 (**DOCUMENTED**; PDF 403)
7. von Schroeder, Kuiper, Botte 2001 — *Osseous Anatomy of the Scapula*, Clin Orthop Relat Res. DOI: https://doi.org/10.1097/00003086-200102000-00015 / PubMed https://pubmed.ncbi.nlm.nih.gov/11210947/ (**DOCUMENTED**)
8. de Leva 1996 — *Adjustments to Zatsiorsky-Seluyanov’s segment inertia parameters*, J Biomech 29(9):1223–1230. DOI: https://doi.org/10.1016/0021-9290(95)00178-6 (**DOCUMENTED** secondary for ratios)
9. Dempster 1955 — upper-arm link length ~293–294 mm (**DOCUMENTED** secondary)
10. ADAS / ANSUR dimension definitions (Shoulder Length, Acromion–Radiale): http://mreed.umtri.umich.edu/mreed/downloads/anthro/ansur/ADAS-Dimension_Definitions.pdf (**MEASURED**)
11. Deltoid thickness MRI (Thai adult male mean ~17.8 mm at 2 fingerbreadths below acromion): PMC https://pmc.ncbi.nlm.nih.gov/articles/PMC10757374/ (**DOCUMENTED** search)
12. Bangladeshi scapula radiological means — DOI https://doi.org/10.3329/cbmj.v12i1.64269 (**DOCUMENTED** search)

---

*End J41 memo. John Research, 2026-09-22 Asia/Nicosia.*
