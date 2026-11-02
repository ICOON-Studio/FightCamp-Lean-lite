# J42 — IS A HEAD A CAPSULE? THE SKULL AND NECK AS COLLISION VOLUMES

**Task:** J42 — IS A HEAD A CAPSULE? THE SKULL AND NECK AS COLLISION VOLUMES  
**Desk:** John (research). **Date:** 2026-09-22 Asia/Nicosia (UTC+3).  
**Continuation of:** J41 (shoulder girdle; r/L + L−2r framework now project working tool).  
**Scope:** Paper only — no code, no checkout, no `.gd` edits.

### Problem statement (Dola / rig measurement)

Same day as J41, the stature-scaled capsule measurer refused Dola’s **double-end radius inset** on the **HEAD**, not the girdle:

- **`head` volume:** Head bone → skull vertex centroid, **L ≈ 0.0774 m** on a **1.88 m** fighter; radius = skull half-width **larger than L** → inset collapsed volume to **0.0% present**.
- **`neck`:** **L ≈ 0.0594–0.0774 m**, **r = 0.0550 m** → **r/L ≈ 0.71–0.93** (needle by L−2r).

Question for this memo: is that a **rig/landmark bug** (segment too short), or a **fact about adult-male heads and necks** (too squat for any L−2r inset to survive)?

### Label legend

| Tag | Meaning |
| --- | --- |
| **MEASURED** | Primary source opened this session (CSV/PDF); numbers taken from that file. |
| **DOCUMENTED** | Confirmed via secondary live page, search extract of a named primary, or peer summary. |
| **INFERENCE** | Arithmetic conversion (breadth→radius, circ→r via circular assumption) or modeling judgment stated as such. |
| **NOT FOUND** | Searched; no clean figure. Prefer this over inventing. |

Every share has a denominator (N, sex, population). A number without a denominator is not a finding.

---

## Q1 — Real adult-male dimensions (with denominators)

Primary survey: **ANSUR II male working / public database**, **N = 4082**, U.S. Army (Active + Guard/Reserve), ages 17–58, measured 2010–2012 (Gordon et al., NATICK/TR-15/007). Official CSV recomputed this session; TR-15/007 PDF definitions and derived **(D20) Neck Link** means cross-checked (**MEASURED**).

### Q1.1 Skull / head

| Quantity | Mean | SD | N | Landmark definition (TR-15/007) | Label |
| --- | --- | --- | --- | --- | --- |
| **Head Breadth** | **154.33 mm** | 5.53 | 4082 | Max horizontal breadth of the head **above the plane of attachment of the ears** (spreading caliper) | **MEASURED** |
| **Head Length** | **199.50 mm** | 7.02 | 4082 | **Glabella → opisthocranion** (spreading caliper) | **MEASURED** |
| **Head Circumference** | **574.37 mm** | 16.05 | 4082 | Max circ above ear attachment; tape just above eyebrow ridges → back of head | **MEASURED** |
| **Menton–Sellion Length** | **122.64 mm** | 6.67 | 4082 | **Menton** (inferior mandible midsagittal) → **Sellion** (nasal root depression); teeth lightly occluded | **MEASURED** |
| **Tragion–Top of Head** | **131.15 mm** | 6.16 | 4082 | Vertical distance from right **tragion** to horizontal plane of top of head (Frankfurt plane) | **MEASURED** |
| **Bizygomatic Breadth** | **142.62 mm** | 6.22 | 4082 | Face breadth at zygomatic arches (not cranial vault) | **MEASURED** |
| Vertex → C7 (`stature − cervicaleheight`) | **238.91 mm** | 12.86 | 4082 | Crown to most prominent C7; **includes skull + soft tissue + neck above C7** — not “skull height alone” | **MEASURED** (derived) |

**TR means check (cm):** Head Breadth male mean **15.43 cm**; Head Circumference **57.44 cm**; Menton–Sellion **~12.3 cm** (50th) — agree with CSV within rounding (**MEASURED**).

**What a single “radius” should be if one is used (INFERENCE):**

| Choice of r | Formula | Mean (mm) | When to use |
| --- | --- | --- | --- |
| **Half-breadth (lateral)** | HeadBreadth / 2 | **77.17** | Side / temple contacts; matches “skull half-width” language in the bug report |
| **Half-length (AP)** | HeadLength / 2 | **99.75** | Front/back thickness; **this is what C153 already picked for its head sphere** |
| **Equiv. circular from circ** | Circ / (2π) | **91.41** | Soft “hat-band” envelope; overstates AP relative to half-breadth |
| **Half bizygomatic** | Bizyg / 2 | **71.31** | Face cheek plane — **not** cranial vault |

**Honest single-r pick for a game collision sphere:** prefer **half Head Length (≈99.8 mm)** if the sphere must cover forehead↔occiput (C153), or **half Head Breadth (≈77.2 mm)** if temple width is the acceptance criterion — **they are not interchangeable**. A true head is an **ellipsoid** with three unequal semi-axes, not one radius. Absolute cranial vault height (vertex↔menton as one ANSUR column) is **NOT FOUND** as a direct measure; Menton–Sellion is **face** length only.

**r/L if their head capsule L = 77.4 mm and r = half-breadth 77.2 mm:** r/L ≈ **0.997**, L−2r ≈ **−77 mm** → **0% present**. That is not a surprising failure; it is the definition of treating a **sphere** as a short capsule whose axis equals its radius.

### Q1.2 Neck

**ANSUR does not ship a single “neck length” direct tape** in the male public CSV. It **does** define a derived link:

| Quantity | Mean | SD / notes | Landmark pair | Label |
| --- | --- | --- | --- | --- |
| **(D20) Neck Link** | **107.8 mm** (TR mean **10.78 cm**; CSV recompute **107.77 mm**) | SD 12.7 mm (CSV) | Vertical: **cervicale (C7 most prominent) → tragion** = `stature − tragiontopofhead − cervicaleheight` | **MEASURED** |
| Neck Circumference (infrathyroid / Adam’s apple) | **397.65 mm** (TR mean **39.76 cm**) | SD 25.78 | Circ at infrathyroid; plane ⊥ long axis of neck | **MEASURED** |
| Neck Circumference, Base | **434.60 mm** | SD 25.67 | Circ over drawn lateral + anterior neck-base landmarks | **MEASURED** |
| Cervicale − Suprasternale (vertical) | **78.71 mm** | SD 11.65 | C7 height − suprasternale height (not anterior surface path) | **MEASURED** (derived) |
| Vertex − C7 | **238.91 mm** | — | Includes whole head above C7 | **MEASURED** |

Landmark notes (TR-15/007, **MEASURED**):

- **Cervicale:** most prominent palpable point of the spine of **C7** (ANSUR II changed from “superior palpable” to “most prominent” for ISO 7250-1 compliance; typically ≤1–2 mm shift).
- **Tragion:** notch at upper margin of tragus (ear).
- **Suprasternale:** superior margin of sternal notch.
- Classic ANSUR *anterior* / *posterior* surface “Neck Length” tapes (suprasternale→jaw–neck junction; nuchale→cervicale) appear in older ADAS manuals; **they are not columns in the ANSUR II male public CSV opened this session** → treat those surface paths as **NOT FOUND** in this CSV (definitions **DOCUMENTED** via ADAS manual extract only).

**Radii (INFERENCE, circular soft-tissue):**

| r source | r (mm) |
| --- | --- |
| Neck circ / (2π) | **63.29** |
| Neck-base circ / (2π) | **69.17** |

**r/L for neck (same soft r = 63.29 mm):**

| L definition | L (mm) | Landmark pair | r/L | L−2r (mm) | Survive L−2r? |
| --- | --- | --- | --- | --- | --- |
| **ANSUR (D20) Neck Link** | **107.8** | C7 → tragion | **0.587** | **−18.8** | **NO — needle** |
| Cervicale − suprasternale | **78.7** | C7 → sternal notch (vertical) | **0.804** | **−47.9** | **NO** |
| Their fighter Lo | **59.4** | (rig Neck→Head span) | **1.065**† | **−67.2**† | **NO** |
| Their fighter Hi | **77.4** | (rig) | **0.818**† | **−49.2**† | **NO** |
| Hybrid III C7→occipital joint | **143.6** | ATD published span (**DOCUMENTED**) | **0.441**‡ | **+17.0**‡ | Marginal with *soft* r; ATD neck is rubber/aluminum, not soft circ |

† Using **their** r = 55.0 mm for the “their” rows; using ANSUR r = 63.29 for ANSUR rows.  
‡ Soft ANSUR r on Hybrid III *bony/ATD* length — mixed apples; shown only as upper-bound geometry.

**Literature cross-check of Neck Link:** Zhang et al. / PLOS ONE neck musculoskeletal scaling paper reports ANSUR II 50th-percentile male neck length (**C7–tragion**) = **10.8 cm** — matches TR (D20) 50th = **10.80 cm** and our mean (**DOCUMENTED** + **MEASURED**).

**Compare literature neck lengths to their 0.0594–0.0774 m:**

| Definition | Typical male value | Their 59–77 mm is… |
| --- | --- | --- |
| ANSUR (D20) Neck Link C7–tragion | **~108 mm** | **~0.55–0.72× too short** |
| Cervicale − suprasternale (vertical) | **~79 mm** | **≈ their upper bound (77.4 mm)** |
| Hybrid III C7–occiput | **143.6 mm** | Far shorter |
| Cervical *spinal cord* length C1–C7 (MRI ALSC, mixed clinical) | **~108 mm** order (**DOCUMENTED**; sample not healthy Army male N=4082) | Their span is shorter than bony-column order |

**Closest ANSUR-derived number to their L:** **cervicale − suprasternale ≈ 78.7 mm**, not Neck Link. If the rig’s Neck→Head bone distance is landing near **0.06–0.08 m**, it is behaving like a **C7↔sternal-notch vertical** (or a truncated neck), **not** like C7↔tragion / C7↔occiput.

Tall subsample check (stature 1860–1900 mm, N=184): neck circ mean **406.1 mm** → r ≈ **64.6 mm**. Their r = **55.0 mm** is **~15% thinner** than ANSUR males near 1.88 m — possible fighter/lean build or different measure plane; not the main failure mode.

---

## Q2 — Decisive: is their neck length wrong, or is a real neck that short?

### One-sentence verdict

**Both — but the anatomy decides the inset: a real soft adult-male neck on ANSUR (D20) Neck Link already has r/L ≈ 0.59 and fails L−2r; their L (59–77 mm) is additionally short vs that link (~108 mm), which makes the collapse look worse but is not required for the rule to die.**

### Numbers that settle it

| Case | L (mm) | r (mm) | r/L | L−2r | Reading |
| --- | --- | --- | --- | --- | --- |
| **Real soft neck (ANSUR ♂ N=4082)** | 107.8 (C7–tragion) | 63.3 (circ/2π) | **0.59** | **−19 mm** | Anatomically **squat cylinder**; double-end inset **cannot** survive |
| **Their rig neck** | 59.4–77.4 | 55.0 | **0.71–0.93** | **−67 to −49 mm** | **Too short** vs Neck Link **and** already in the squat regime |
| **If only length were “fixed” to Neck Link, keep their r** | 107.8 | 55.0 | **0.51** | **−2 mm** | Still ~needle |
| **If length fixed to Hybrid III 143.6, ANSUR soft r** | 143.6 | 63.3 | **0.44** | **+17 mm** | Barely positive — still a terrible capsule after inset |

**Against the “≈0.4 → fix upstream only” fork:** soft anthropometric L that ANSUR itself calls **Neck Link** already sits at **r/L ≈ 0.59**, not 0.4. Reaching r/L ≈ 0.4 requires either (a) a **longer bony/ATD** axis (Hybrid III ~144 mm) with a **smaller** r than soft circ, or (b) refusing soft circumference as the capsule radius.

**Against the “≈0.9 → pure squat fact” fork alone:** their measured L is **not** equal to Neck Link. It is ~**25–45 mm short** of C7–tragion and suspiciously near **cervicale−suprasternale**. So there **is** an upstream landmark/span issue — but fixing L to 108 mm **does not** rescue Dola’s double-end soft-radius inset.

**Cervical column / biomechanics segment notes:**

- Hybrid III 50th male: separate **head** (cast aluminum skull + vinyl skin) and **neck** (segmented rubber/aluminum + center cable); C7→occipital-joint length cited **143.6 mm** in ATD neck design literature (**DOCUMENTED**).
- de Leva 1996 / Dempster: head and head–neck **inertial** parameters (mass %, CoM % of segment); **absolute neck length in mm NOT FOUND** this session as a clean table extract.
- C153 (project prior, **DOCUMENTED**): already sets neck r from ANSUR neck circ / (2π·stature) and treats **head as a zero-length capsule (sphere)** from headlength/2 — i.e. the project previously knew the head is not a long capsule.

---

## Q3 — What shipping systems actually use

### One-sentence verdict

**Shipping ragdolls and ATDs treat the head as a sphere (or short capsule / ellipsoid) and usually give the neck either a thin dedicated capsule or no soft volume of its own; almost nobody models “head” as a bone→centroid capsule whose L ≈ r.**

| System / domain | Head primitive | Neck its own volume? | Source grade |
| --- | --- | --- | --- |
| **Unreal Physics Asset / Chaos** | Sphere or capsule on skull/head bone; cloth docs push simple spheres/capsules | Optional thin capsule on neck bones; many assets omit a fat soft neck and rely on head+torso | **DOCUMENTED** (Epic Chaos cloth / Physics Asset practice) |
| **Unity PhysX ragdolls** | Capsule or sphere on head | Often a short neck capsule or skipped (head constrained to spine/chest) | **DOCUMENTED** (common template practice; no single Unity manual page opened mandating one layout) |
| **Bullet / generic game ragdolls** | Sphere/capsule | Frequently **no** separate neck collider | **DOCUMENTED** (engine folklore / templates); project-specific layouts vary |
| **Hybrid III 50th male** | Aluminum skull + vinyl skin (≈ sphere/ellipsoid) | **Yes — separate** segmented neck; mass ~3.4 lb; length ~144 mm C7–occiput | **DOCUMENTED** (Humanetics TPS) |
| **Medical / FE neck models** | Mesh / multi-body vertebrae | Yes, but as **linked vertebral solids**, not one soft capsule | **DOCUMENTED** |
| **Mocap solvers** | Rarely a collision volume at all; joint hierarchy | N/A | **INFERENCE** from domain practice |
| **FightCamp C153 prior** | **Zero-length capsule = sphere** (headlength/2) | Yes: Neck→Head with circ-derived r | **DOCUMENTED** (C153 memo) |

**Plain statement:** Most **game** systems do **not** give the neck a large soft collision volume comparable to limbs; when they do, it is a **connector**, not the primary hit target. **ATD / medical** systems that care about neck loads **do** isolate the neck — but as a **mechanical stack**, not as a soft cylinder meant to survive radius inset from both ends.

---

## Q4 — Grip separability (collar / RNC / guillotine)

### One-sentence verdict

**Collar, RNC, and guillotine are separable by named height/aspect anchors on one neck tube — not by three independent collision volumes — because the relevant cervical levels sit within roughly one Neck Link (~0.11 m), and mid-neck pairs are often ≤ ~0.03–0.05 m apart.**

| Grip | Anatomical target | Typical vertebral / landmark level | Label |
| --- | --- | --- | --- |
| **Collar tie** | Upper-posterior neck + base of skull / occiput | Occiput / **C1–C2** region; hard palate ~C1 | **DOCUMENTED** (standard topographic anatomy) |
| **Rear-naked choke (RNC)** | Mid-posterior / lateral neck — carotids | Carotid bifurcation most often ~**C3** on CT series (Mirjalili et al. 2012, Clin Anat) | **DOCUMENTED** |
| **Guillotine** | Anterior neck at laryngeal level | Thyroid cartilage ~**C4–C5** (men often C5 in same CT series); larynx spans ~C3–C6 | **DOCUMENTED** |

**Height budget on a soft neck:** ANSUR Neck Link ≈ **0.108 m**. Individual cervical body heights are order **~12–15 mm** (**DOCUMENTED** vertebral morphometry tables). Collar (C1) → laryngeal (C4–C5) is on the order of **~40–60 mm** of column; RNC (C3) → guillotine (C4–C5) is often **~15–30 mm**. Exact soft-surface millimetre separations for BJJ grips as a surveyed series: **NOT FOUND**.

**Modeling implication:** If all three grips live inside one ~0.11 m tube and mid pairs are within ~0.03 m, **one neck volume + named anchors** (posterior-upper, posterior-mid, anterior-laryngeal) beats three capsules. Three volumes would overlap almost completely after any soft radius ≥ 55 mm.

---

## Deciding table (r/L head & neck + Survive L−2r?)

| Segment as modeled | L (mm) | r (mm) | r definition | r/L | L−2r (mm) | Survive L−2r? | Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **Head as their capsule** (bone→centroid) | 77.4 | 77.2 | half Head Breadth (ANSUR ♂) | **0.997** | **−77** | **NO (0%)** | Their L + **MEASURED**/ **INFERENCE** |
| **Head as sphere** (C153-style) | 0 (degenerate) | 99.8 | half Head Length | n/a | n/a | **N/A — not a capsule** | C153 + ANSUR **MEASURED** |
| **Head as sphere** (temple) | 0 | 77.2 | half Head Breadth | n/a | n/a | **N/A** | **MEASURED** + **INFERENCE** |
| **Neck ANSUR Neck Link + soft r** | 107.8 | 63.3 | circ/(2π) | **0.587** | **−19** | **NO** | **MEASURED** |
| **Neck their span + their r** | 59.4–77.4 | 55.0 | their measure | **0.71–0.93** | **−67 to −49** | **NO** | Their report |
| **Neck Hybrid III length + soft r** | 143.6 | 63.3 | mixed | **0.441** | **+17** | Marginal | **DOCUMENTED** + **INFERENCE** |
| **Upper arm (J41 recall)** | 335 | 57 | flexed biceps | **0.17** | **+221** | **YES** | J41 |

**Comparison to their 1.88 m fighter**

| Item | Their number | ANSUR ♂ reference | Comment |
| --- | --- | --- | --- |
| Stature | 1.88 m | mean 1.756 m; tall band 1.86–1.90 N=184 | Tall athlete |
| Head L | 0.0774 m | half-breadth 0.0772 m; half-length 0.0998 m | Their L ≈ **one cranial semi-axis**, not a capsule axis |
| Head r (half-width) | > L (collapse) | 0.0772 m mean half-breadth | Expected if capsule L ≈ r |
| Neck L | 0.0594–0.0774 m | Neck Link 0.108 m; cerv−supra 0.079 m | Closer to **cerv−supra** than Neck Link |
| Neck r | 0.0550 m | 0.0633 m mean; ~0.0646 m in tall band | Slightly thin vs ANSUR |

---

## Argue against yourself — then land

### Wrong reading of this answer

**Wrong reading A:** “Just lengthen the neck bones to 108 mm and Dola’s inset will work.”  
**Rebuttal:** At L=108 mm and soft r=63 mm, L−2r is still negative. Lengthening helps the *measurement story* but does not rescue double-end soft inset.

**Wrong reading B:** “Necks are impossible; delete the neck capsule.”  
**Rebuttal:** Hybrid III and C153 both keep a neck segment. The failure mode is specifically **double-end radius inset on a soft squat cylinder**, not “neck volumes are useless.” Keep a neck volume; **change the inset policy** (one-sided inset, tapered capsule, or no inset).

**Wrong reading C:** “Head must be a long capsule along the cervical axis.”  
**Rebuttal:** That conflates head with neck. Cranial vault is better a **sphere/ellipsoid**; neck is the cylinder under it.

**What would settle remaining doubt:** (1) print the rig’s exact world-space **Neck bone → Head bone** and **Head bone → mesh vertex centroid** distances on the 1.88 m fighter with named landmarks; (2) recompute r from the same mesh neck slice used for collision, not a stale constant; (3) A/B inset policies (none / one-sided / L−r only) on Neck Link geometry.

### Landed recommendation

1. **Head:** stop modeling as a finite-length capsule with L≈r. Use a **sphere (or ellipsoid)** centered on the cranial vault — C153’s zero-length capsule is the correct prior. Do **not** apply L−2r to the head.
2. **Neck:** treat as a **soft squat cylinder** (r/L ≈ 0.5–0.6 on C7–tragion). **Do not apply Dola’s double-end radius inset** to the neck; prefer no inset, one-sided inset at torso join only, or a tapered capsule. Separately, **audit** Neck→Head span — if it stays ~0.06–0.08 m it is short vs ANSUR Neck Link (~0.11 m) and should be lengthened toward C7–tragion / C7–occiput semantics.
3. **Grips:** one neck volume + **named anchors** (collar / RNC / guillotine), not three capsules.
4. **Policy continuity with J41:** uniform double-end inset is **not** a universal law. Neck joins head on the “do not roll inset” list for a *different* reason than scapula (squat soft r/L vs wrong abstraction).

---

## WHAT IS STILL WRONG / open

1. Exact FightCamp 1.88 m rig landmark print (Neck↔Head↔centroid) **not re-measured this session** — numbers taken from task brief (**DOCUMENTED** as report, not re-MEASURED on mesh).
2. de Leva / Dempster **absolute** head–neck lengths in mm **NOT FOUND** this session.
3. ANSUR anterior/posterior surface neck-length tapes **not in public male CSV** — **NOT FOUND** as columns.
4. BJJ grip height survey in millimetres **NOT FOUND**; vertebral-level mapping used instead.
5. Beast `CopyFromBox` / `Shell(machineId=fd22c5bf-…)` **not on this executor tool surface** — parent must stage files to Windows paths.
6. D7/D9 neck-reachability and S4 body-radius priors: RESEARCH_INDEX is huge; C153 found and used; specific D7/D9/S4 filenames **not opened** this pass beyond index mention of C153 (**partial NOT FOUND**).

**Operator decision line:**

> **A head is not a capsule with L ≈ r — it is a sphere/ellipsoid. A real soft male neck is a squat cylinder (ANSUR Neck Link r/L ≈ 0.59) that cannot survive double-end radius inset; their Neck→Head span is also short vs that link. Refuse L−2r on head and neck; keep one neck volume with named grip anchors; audit bone span toward ~0.11 m C7–tragion semantics.**

---

## Sources (opened / used this session)

1. ANSUR II Male Public CSV — https://tools.openlab.psu.edu/publicData/ANSUR_II_MALE_Public.csv (**MEASURED**, N=4082). Local copy: `/workspace/j42/refs/ANSUR_II_MALE_Public.csv`.
2. Gordon et al., NATICK/TR-15/007 — https://tools.openlab.psu.edu/publicData/ANSURII-TR15-007.pdf (**MEASURED** defs + (D20) Neck Link). Local: `/workspace/j42/refs/ANSURII-TR15-007.pdf`.
3. J41 — `/workspace/j41/J41_SHOULDER_GIRDLE_PROPORTIONS.md` (r/L method).
4. C153 — `research/C153_CAPSULE_SET.md` on Guru-Meditation/FightCamp (head as zero-length capsule; neck r from circ) (**DOCUMENTED**).
5. Neck musculoskeletal model / ANSUR neck length 10.8 cm — https://journals.plos.org/plosone/article?id=10.1371/journal.pone.0219954 (**DOCUMENTED**).
6. Hybrid III 50th Male TPS — Humanetics PDF (head/neck construction, segment masses) (**DOCUMENTED**).
7. ATD neck design citing Hybrid III C7–occiput **143.6 mm** — OSU thesis / handle http://hdl.handle.net/1811/84557 (**DOCUMENTED**).
8. Mirjalili et al. 2012, Clin Anat — vertebral levels of neck landmarks (DOI 10.1002/ca.22124) (**DOCUMENTED**).
9. ADAS Dimension Definitions (classic ANSUR neck length anterior/posterior) — http://mreed.umtri.umich.edu/mreed/downloads/anthro/ansur/ADAS-Dimension_Definitions.pdf (**DOCUMENTED**; not in II public CSV).
10. Epic Chaos cloth / Physics Asset guidance — simple spheres/capsules preferred (**DOCUMENTED**).
11. de Leva 1996 DOI 10.1016/0021-9290(95)00178-6 — inertial params; absolute mm lengths **NOT FOUND** this session.

---

*End J42 memo. Full file on box; do not confuse with any GitHub stub.*
