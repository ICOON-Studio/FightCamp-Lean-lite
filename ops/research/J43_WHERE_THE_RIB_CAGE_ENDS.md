# J43 — WHERE DOES A RIB CAGE ACTUALLY END, AND IS A DOME THE RIGHT TOP FOR IT?

**Task:** J43 — WHERE DOES A RIB CAGE ACTUALLY END, AND IS A DOME THE RIGHT TOP FOR IT?  
**Desk:** John (research). **Date:** 2026-09-22 Asia/Nicosia (EEST / UTC+3).  
**Continuation of:** J41 (shoulder girdle / r/L), J42 (head as sphere; neck squat cylinder).  
**Scope:** Literature / web / ANSUR CSV only — no Godot, no `.gd`, no checkout, no game code.

### Why this was asked (cap over neck)

J41/J42 changed the capsule model. J42 killed endpoint inset on the head; head became a sphere. Neck stayed **0.0% reachable**. Blocking transferred to thorax: on the **1.78 m** rig, neck blocked by head on **67/128** dirs → blocked by thorax on **90/128** with zero usable either way (task brief; **DOCUMENTED** as report, not re-measured here).

Cause named in the brief: the **hemisphere cap** on the thorax capsule. Thorax runs **Chest bone → Neck bone** with hemispherical caps. Radius:

| Stature (rig) | Thorax r | Source |
| --- | --- | --- |
| 1.78 m | **0.1231 m** (123.1 mm) | Task brief (**DOCUMENTED** report) |
| 1.88 m | **0.1418 m** (141.8 mm) | Task brief; S48 narrowed from 0.1909 → 0.1418 on depth axis (**DOCUMENTED** report) |

Neck segment length ≈ **0.0594 m**. Chest dome radius is ~**2×** that length, so the superior hemisphere reaches straight up past the Neck bone and into the neck corridor. S48 radius shrink moved neck directions **zero** (brief).

**Question:** is a **dome the right shape for the top of a rib cage?**

### Label legend

| Tag | Meaning |
| --- | --- |
| **MEASURED** | Primary source opened this session (CSV / PDF text extract); numbers taken from that file. |
| **DOCUMENTED** | Confirmed via secondary live page, search extract of a named primary, or peer summary of named primary. |
| **INFERENCE** | Arithmetic conversion (breadth→half, circ→r via circular assumption) or modeling judgment stated as such. |
| **NOT FOUND** | Searched; no clean figure. Prefer this over inventing. |

Every share has a denominator (N, sex, population). A number without a denominator is not a finding. Unrounded means and column names shown where measured.

### Beast / prior access this session

| Item | Status |
| --- | --- |
| Beast machineId `fd22c5bf-e873-4d80-83a5-87ae773b2e4c` (RESEARCH_INDEX, S48, C153, D7/D9, U95, S4) | **BLOCKED** — no `ListMachines` / `CopyFromBox` / `Shell(machineId=…)` on this executor tool surface |
| Box priors J41 / J42 | **Opened** (`/workspace/j41/`, `/workspace/j42/`) |
| ANSUR II male public CSV + TR-15/007 text extract | **Opened** (local copies under `/workspace/j43/refs/`) |
| `grok` CLI deep pass | **Skipped** — `os error 6` (No such device or address) |

Parent stages to Beast `_john_delivery/` and `research/`.

---

## Q1 — WHERE DOES THE BONY THORAX END (named landmarks)?

### One-sentence verdict

**The bony thorax ends superiorly at the superior thoracic aperture (thoracic inlet): T1 body + first ribs + superior border of the manubrium / jugular (suprasternal) notch — an oblique, kidney-shaped ring ~50–65 mm AP × ~90–110 mm transverse in textbook adult figures; it does NOT fill the soft mid-chest envelope, and soft tissue / lung apex only slightly overshoots that bony ring into the root of the neck.**

### Boundaries (named)

| Border | Landmark | Label |
| --- | --- | --- |
| Posterior | Body of **T1** (+ costovertebral joints of first ribs) | **DOCUMENTED** (Wikipedia STA; Gray/clinical anatomy summaries) |
| Lateral | **First ribs** and their costal cartilages (C-shaped) | **DOCUMENTED** |
| Anterior | Superior border of the **manubrium**; surface landmark = **jugular / suprasternal notch** (ANSUR: *suprasternale*) | **DOCUMENTED** + ANSUR landmark **MEASURED** (defs) |
| Slope | Aperture slopes **antero-inferiorly** (posterior higher than anterior) | **DOCUMENTED** |

ANSUR *suprasternale* (TR-15/007): inferior point of the jugular notch / top of the breastbone (**MEASURED** from TR extract). ANSUR does **not** define a “first-rib plane” chest breadth/depth column (**NOT FOUND** in male public CSV variable list this session).

### Inlet dimensions (bony ring — textbooks + clinical notes)

These are **bony aperture** figures, not soft-tissue chest caliper dims. Sources disagree slightly on rounding; both quoted rather than averaged into a fake “true” value.

| Source | AP | Transverse | Population / N | Label |
| --- | --- | --- | --- | --- |
| Gray / Clinical Gate (Gray’s-style surface anatomy chapter) | **~50 mm** (“typically 5 cm”) | **~100 mm** (“10 cm”) | Textbook adult; N not a survey sample | **DOCUMENTED** |
| Last’s Anatomy via Wikipedia STA (McMinn 1994 cited on page) | **~65 mm** (“around 6.5 cm”) | **~110 mm** (“11 cm”) | Textbook adult | **DOCUMENTED** |
| GPnotebook clinical note | **45–60 mm** | **90–110 mm** | Clinical range; N **NOT FOUND** | **DOCUMENTED** |
| Radiopaedia STA | ~50 mm AP × ~100 mm transverse (search synthesis; live page bot-blocked this session) | same | Radiology reference | **DOCUMENTED** (secondary) |

**Honest working band for adult bony inlet:** AP **~45–65 mm**, transverse **~90–110 mm**. Sex-stratified CT series with N and unrounded means for the *full aperture ellipse* as those two axes: **NOT FOUND** this session (available CT papers measured costoclavicular / scalene gaps, or sagittal **thoracic inlet distance** T1→manubrium apex ≈ **65.9 ± 6.6 mm**, range 52–83 mm, mixed ages — that is a *sagittal chord*, not AP×transverse aperture; **DOCUMENTED** via abstract/table extract, N and sex mix per paper).

### How far does a real rib cage reach above C7 / tragion — and how far it does NOT?

Use ANSUR verticals (♂, N=4082) as soft-surface proxies between named landmarks (**MEASURED** CSV):

| Vertical (standing) | Mean (mm) | SD (mm) | Landmark pair | Label |
| --- | --- | --- | --- | --- |
| Cervicale − Suprasternale | **78.707496** | 11.646647 | C7 most-prominent → jugular notch | **MEASURED** (derived) |
| ANSUR (D20) Neck Link (from J42) | **107.77** | ~12.7 | Cervicale → tragion | **MEASURED** (J42 / same CSV) |
| Suprasternale − Chest height | **147.473542** | 18.016748 | Jugular notch → chest point anterior (widest / nipple-region height) | **MEASURED** (derived) |
| Cervicale − Chest height | **226.181039** | 19.810158 | C7 → chest point anterior | **MEASURED** (derived) |
| Suprasternale − Tenth rib | **317.923567** | 21.877004 | Jugular notch → inferior 10th rib (rib-cage vertical span proxy) | **MEASURED** (derived; TR calls related link (D27)) |

**Reading (INFERENCE + DOCUMENTED anatomy):**

1. **Bony superior end** is at the **inlet** (manubrium / first rib / T1), whose anterior surface landmark is ~**79 mm below C7** on ANSUR means — i.e. the manubrium sits near the **base of the neck**, not at mid-chest.
2. Soft **widest chest** (chest point anterior) sits another ~**147 mm below** the jugular notch — so mid-chest caliper planes are **far inferior** to the bony top.
3. **Lung apex / apical pleura** extend **slightly superior** past the inlet into the root of the neck (classically ~**25–40 mm** above the medial first rib / ~**10–30 mm** relative to clavicle in textbook/CT surface-anatomy notes — **DOCUMENTED**; not a FightCamp soft-collision envelope).
4. Soft trapezius / SCM / fat around the neck–shoulder junction sit **above** the bony ring; they are **neck / girdle**, not “rib cage volume.”

**What the rib cage does NOT do:** it does **not** continue as a full mid-chest cylinder up to the Neck bone with the same AP/breadth as nipple-level chest. A hemispherical cap whose radius equals mid-chest half-depth **overstates** the superior bony + soft thorax in the axial directions that matter for neck reach.

---

## Q2 — CHEST DIMS AT INLET vs WIDEST

### One-sentence verdict

**ANSUR II measures chest breadth/depth/circumference at the *widest* chest (chest point anterior / legacy thelion), not at the thoracic inlet; soft inlet-level chest breadth/depth columns are NOT FOUND in ANSUR — so the task’s “inlet:widest” soft ratio is NOT FOUND as a same-survey pair; the usable substitute is bony-inlet ÷ soft-widest (mixed tissue), which lands near ~0.2 AP and ~0.35–0.38 transverse.**

### Widest level — ANSUR II male (N = 4082)

Primary: `ANSUR_II_MALE_Public.csv` recomputed this session (**MEASURED**). Cross-check TR-15/007 summary means (**MEASURED** extract).

| Column (CSV) | TR name | Mean (mm, unrounded CSV) | SD (mm) | TR mean (cm) | Landmark / note | Label |
| --- | --- | --- | --- | --- | --- | --- |
| `chestbreadth` | (23) Chest Breadth | **289.441450** | 18.279344 | **28.94** | Max horizontal breadth at **chest point anterior**; tissue compressed; **max inspiration** (ANSUR II) | **MEASURED** |
| `chestdepth` | (25) Chest Depth | **253.847134** | 26.246735 | **25.38** | Horizontal chest↔back at **chest point anterior**; quiet respiration | **MEASURED** |
| `chestcircumference` | (24) Chest Circumference | **1058.705537** | 87.435272 | **105.87** | Max horizontal circ at chest point anterior; quiet respiration | **MEASURED** |
| `chestheight` | Chest Height | **1291.118569** | 56.956697 | — | Floor → chest point anterior | **MEASURED** |
| `biacromialbreadth` | Biacromial Breadth | **415.675649** | 19.161654 | — | Shoulder bony breadth (not chest) | **MEASURED** |
| `bideltoidbreadth` | Bideltoid Breadth | **510.424792** | 32.505628 | — | Soft shoulder envelope | **MEASURED** |
| `neckcircumference` | Neck Circumference | **397.648947** | 25.776764 | 39.76 (J42) | Infrathyroid | **MEASURED** |
| `neckcircumferencebase` | Neck Circumference, Base | **434.596031** | 25.674001 | — | Over neck-base landmarks | **MEASURED** |

**Half-dims at widest (INFERENCE, /2):**

| Half-dim | Mean (mm) | p80 (mm, this CSV) |
| --- | --- | --- |
| `chestbreadth` / 2 | **144.720725** | **152.0** |
| `chestdepth` / 2 | **126.923567** | **138.5** |
| max(half_b, half_d) per subject, p80 | — | **152.5** |

**Equiv. circular soft r from chest circ (INFERENCE):** mean circ / (2π) = **168.498219** mm — larger than either half-caliper; circ wraps a non-circular section.

### Tall bands matching their rigs (CSV subsample, MEASURED)

| Band | N | `chestbreadth` mean | `chestdepth` mean | half_b | half_d | p80 max(half_b,half_d) |
| --- | --- | --- | --- | --- | --- | --- |
| stature 1760–1800 mm (~1.78 m) | **913** | 291.027382 | 255.407448 | 145.513691 | 127.703724 | 152.5 |
| stature 1860–1900 mm (~1.88 m) | **184** | 301.364130 | 264.978261 | 150.682065 | 132.489130 | 158.0 |

### Inlet level — ANSUR?

| Sought | Result | Label |
| --- | --- | --- |
| Chest breadth at first-rib / thoracic inlet | **NOT FOUND** as ANSUR II column | **NOT FOUND** |
| Chest depth at jugular notch / manubrium plane | **NOT FOUND** as ANSUR II column | **NOT FOUND** |
| Soft “thoracic inlet circumference” | **NOT FOUND** in ANSUR II public male CSV | **NOT FOUND** |
| Closest soft superior tube | `neckcircumferencebase` mean **434.596031** mm → circular r **69.168107** mm (**INFERENCE**) | **MEASURED** + **INFERENCE** |

### Deciding ratio table (inlet vs widest)

**Soft:soft inlet/widest from one survey:** **NOT FOUND**.

**Bony inlet (textbook band) ÷ soft widest (ANSUR ♂ N=4082 means)** — mixed tissue, labeled **INFERENCE**:

| Axis | Inlet (bony, mm) | Widest soft (ANSUR mean, mm) | Ratio inlet/widest | Half-inlet (mm) | Their thorax r vs half-inlet |
| --- | --- | --- | --- | --- | --- |
| AP | **50** (Gray-style) | `chestdepth` **253.847134** | **0.197** | **25** | Their r **123.1 / 141.8** is **~4.9× / ~5.7×** half-inlet AP |
| AP | **65** (Last’s/Wiki) | 253.847134 | **0.256** | **32.5** | Still **~3.8× / ~4.4×** |
| Transverse | **100** | `chestbreadth` **289.441450** | **0.345** | **50** | Their r **~2.5× / ~2.8×** half-inlet transverse |
| Transverse | **110** | 289.441450 | **0.380** | **55** | Their r **~2.2× / ~2.6×** |

**Soft neck-base vs soft widest (same survey, different body region):**

| Pair | Values | Ratio | Label |
| --- | --- | --- | --- |
| Neck-base circ / Chest circ | 434.596031 / 1058.705537 | **0.410** | **MEASURED** |
| Neck-base r / half chest depth | 69.168 / 126.924 | **0.545** | **INFERENCE** |
| Neck-base r / half chest breadth | 69.168 / 144.721 | **0.478** | **INFERENCE** |

### Their thorax r vs ANSUR widest half-dims

| Rig | Their r (mm) | ANSUR band half_d mean | ANSUR band half_b mean | Comment |
| --- | --- | --- | --- | --- |
| 1.78 m | **123.1** | 127.70 (N=913) | 145.51 | ≈ mean half-**depth** (depth-axis pick, matches S48 story) |
| 1.88 m | **141.8** | 132.49 (N=184) | 150.68 | Between mean half-depth and p80 half-depth (145.7); still **widest-dominated** |

**Conclusion for Q2:** their radius is a **widest-chest** (depth) pick. Applying that r as a **hemisphere at Neck bone** imports mid-chest half-depth into a plane whose bony aperture half-dims are **~25–55 mm** — an order-of-magnitude geometry mismatch on AP.

---

## Q3 — SHIPPING RAGDOLLS / CRASH MODELS FOR UPPER TORSO

### One-sentence verdict

**Game engines wrap the upper torso in simple capsules and/or boxes (sometimes one spine/chest body, sometimes pelvis+spine stacks); the superior “dome” is only the incidental end-cap of a capsule primitive — almost nobody designs an anatomical hemispherical lid on the rib cage — while Hybrid III / THOR / WorldSID use steel rib assemblies, not capsules at all.**

| System / domain | Upper-torso primitive | Hemisphere intentionally on chest top? | Capsule common for torso? | Source grade |
| --- | --- | --- | --- | --- |
| **Unity PhysX / Ragdoll Wizard** | Wizard builds CharacterJoints + colliders from assigned limbs; community templates use **CapsuleCollider** on chest/spine/limbs; official manual emphasizes generated colliders, not anatomy | **No** — any dome is capsule end geometry | **Yes**, as cheap proxy | **DOCUMENTED** (Unity Manual ragdoll wizard; common template practice) |
| **Unreal Physics Asset / Chaos (mannequin)** | Bodies = **sphere / capsule / box** on bones; tutorials describe “a capsule around the torso”; boxes also used when flatter chest wanted | **No** as anatomical lid | **Often yes** for spine/chest bodies | **DOCUMENTED** (Epic practice + UE5 ragdoll writeups) |
| **Havok / CryEngine character proxies** | Engine-agnostic pattern: capsules for limbs, **box or capsule** for torso | **NOT FOUND** as “hemisphere lid” design | Capsule *or* box | **DOCUMENTED** (engine docs / secondary); exact Cry/Havok shipping prefab **not opened** |
| **Bullet / ODE ragdolls** | `btCapsuleShape` limbs; torso often **`btBoxShape`** (independent W/H/D) or capsule | **No** | Mixed; box common for chest | **DOCUMENTED** (Bullet/Panda3D shape docs; Vulkan bone-proxy tutorial search synthesis) |
| **Common UE mannequin PA** | Overlapping capsules on pelvis/spine/limbs; disable collision on constrained pairs | Dome = capsule ends, not rib-cage modeling | **Yes** | **DOCUMENTED** (forum + tutorial consensus) |
| **Hybrid III 50th male** | **Six steel rib units** + sternum + thoracic spine box; vinyl flesh; clavicles separate; Chest Depth **8.7 ± 0.3 in** (~221 mm), Chest Circ **38.8 ± 0.6 in** | **No capsule / no hemisphere lid** | **No** | **MEASURED** (Humanetics TPS PDF this session) |
| **THOR** | Human-like rib cage, flexible spine, multi-point deflection | **No** | **No** | **DOCUMENTED** (Federal Register / ATD literature) |
| **WorldSID** | Rib *modules* (inner/outer contour ribs), not a capsule | **No** | **No** | **DOCUMENTED** (Humanetics / LS-DYNA comparison lit) |
| **MADYMO ellipsoid / facet ATDs** | Ellipsoids or scanned facets for contact — still not “hemisphere on chest capsule” | N/A | Ellipsoid ≠ game capsule lid | **DOCUMENTED** |

**Plain statement:** If almost nobody uses a *purpose-built* hemispherical anatomical top, that **is** the finding. Capsules appear because they are **cheap jointed proxies**, not because a rib cage is a sausage with a dome. Crash dummies that care about thorax shape use **ribs**. Game systems that care about flat fronts often pick a **box**.

---

## Q4 — SHOULDER-TO-NECK CLEARANCE (collar / neck grip)

### One-sentence verdict

**Measured millimetre clearance for a hand closing on a collar tie / neck grip through the trapezius–jaw gap on standing adult males was NOT FOUND as a survey series this session; reachable neck girth proxies exist (ANSUR neck / neck-base circ), and hand size exists, but grip aperture through that gap is not a published ANSUR column.**

| Sought | Result | Label |
| --- | --- | --- |
| Trapezius–jaw / shoulder–neck soft clearance (mm), standing ♂ | **NOT FOUND** | **NOT FOUND** |
| Collar-tie / RNC hand-slot gap survey (mm) | **NOT FOUND** | **NOT FOUND** |
| Reachable neck circumference while gripping | Proxy only: ANSUR `neckcircumference` mean **397.648947** mm; `neckcircumferencebase` **434.596031** mm (♂ N=4082) | **MEASURED** |
| Hand size (grip-related) | `handcircumference` mean **212.283684** mm; `handbreadth` **88.261391** mm; `handlength` **193.277805** mm (♂ N=4082) | **MEASURED** |
| Circular “grip aperture diameter” from hand circ | **212.283684 / π ≈ 67.57 mm** | **INFERENCE** only — not a measured closed-fist inner aperture, not a neck-slot measure |
| Cervical collar “finger gap” fit notes | Qualitative fitting guidance (finger space at chin), not FightCamp grip mm | **DOCUMENTED** (device IFUs); not usable as clearance |

**Modeling implication (INFERENCE):** absence of a clearance survey does **not** rescue a fat chest dome. J42 already argued collar / RNC / guillotine live on **one neck tube + named anchors**. The thorax hemisphere is blocking the *approach* to that tube; Q4’s NOT FOUND means you cannot calibrate the gap from literature — you calibrate from playtest — but the anatomical case against the dome does not need Q4 numbers.

---

## Deciding ratio table (summary for operators)

| Quantity | Value | Denominator | Label |
| --- | --- | --- | --- |
| Bony inlet AP (working band) | **45–65 mm** | Textbook/clinical adults | **DOCUMENTED** |
| Bony inlet transverse | **90–110 mm** | same | **DOCUMENTED** |
| Soft widest AP (`chestdepth`) | **253.847134 mm** | ANSUR II ♂ N=4082 | **MEASURED** |
| Soft widest breadth (`chestbreadth`) | **289.441450 mm** | same | **MEASURED** |
| Soft:soft inlet/widest | **NOT FOUND** | — | **NOT FOUND** |
| Bony AP / soft widest AP | **~0.20–0.26** | mixed | **INFERENCE** |
| Bony transverse / soft widest breadth | **~0.35–0.38** | mixed | **INFERENCE** |
| Neck-base circ / chest circ | **0.410** | same survey | **MEASURED** |
| Their thorax r @ 1.78 m | **123.1 mm** | FightCamp brief | **DOCUMENTED** report |
| Their thorax r @ 1.88 m | **141.8 mm** | FightCamp brief | **DOCUMENTED** report |
| Their r / half bony inlet AP (50 mm → 25 mm half) | **~4.9× / ~5.7×** | — | **INFERENCE** |
| Their r vs ANSUR half chest depth (band means) | ≈ equal (1.78) / slightly above mean (1.88) | ANSUR bands | **INFERENCE** |
| Neck L vs their r | 59.4 mm vs 123–142 mm | brief | Dome ~**2×** neck segment |

---

## Argue against yourself — then land

### Strongest case that collision volume need not match anatomy

1. **Games ship fat torso capsules every day.** Unity/Unreal templates do not sculpt an inlet taper; players rarely complain about “rib cage wrong.” Cheap capsule > anatomical mesh for query cost.
2. **Grapple failure may be the grip model**, not the chest: if hands cannot close unless a query ray clears *all* capsules, a correctly fat chest will still block. Fixing the dome without fixing “usable if any corridor exists” / “ignore self-thorax for neck targets” may leave 0/128.
3. **Soft tissue at the root of the neck is real.** Trapezius, fat, and lung apex *do* occupy space above the bony inlet. A zero-radius top is also wrong.
4. **S48 already shrank r** and neck directions moved zero — maybe the blocker is axial placement (capsule end at Neck bone) more than radius, so “refuse dome” alone under-specifies the fix.

### Weakest point in *this* memo (unprompted)

**Soft inlet-level chest depth/breadth from a large N survey is NOT FOUND.** The headline ratio uses **bony** inlet over **soft** widest — different tissues. A cadaver/CT soft-envelope series at the first-rib plane could move the ratio. Also, FightCamp’s exact skin-offset / p80 procedure was not re-opened (Beast **BLOCKED**); “p80 of skin offsets over whole chest” is taken from the task brief.

### What would settle it

1. **One CT or 3D-scan series** (adult ♂, N≥30) reporting soft AP and breadth at (a) first-rib / jugular plane and (b) nipple / chest-point plane on the **same subjects** → true soft inlet:widest.
2. **A/B on the 1.78 m rig (parent/Dola):** (i) current capsule; (ii) same r but superior end truncated at Chest bone / below inlet (no Neck attachment); (iii) tapered capsule with Neck-end r ≈ neck-base soft r (~70 mm) and Chest-end r kept; (iv) box torso. Score 128-dir neck reachability.
3. Print world-space **Chest → Neck** length and the superior hemisphere’s peak height above Neck bone for current r.

### Landed recommendation

**Refuse a constant-radius hemispherical thorax top sized from mid-chest depth.** A rib cage’s bony superior end is the **thoracic inlet** (~45–65 × 90–110 mm), not a dome of radius **123–142 mm**. Their r correctly tracks **widest** chest half-depth; the shape error is exporting that r as a **capsule end-cap at the Neck bone**, which fills the neck corridor (~59 mm segment) with a chest-sized hemisphere.

**Prefer, in order:**
1. **Tapered torso volume** — Chest-end r ≈ current widest half-depth; Neck-end / superior r ≈ **neck-base soft scale** (~70 mm from ANSUR neck-base circ/(2π)) or ≤ half bony-inlet transverse (~50–55 mm) if a bony-tight envelope is acceptable; **or**
2. **End the thorax capsule below the inlet** (Chest→mid-thorax or Chest only; do **not** attach the fat capsule’s superior pole to Neck); keep a **separate thin neck** volume (per J42: no L−2r double-end inset); **or**
3. **Box / ellipsoid torso** (independent AP vs breadth) if queries allow — matches Bullet-style chests better than a dome.

**Do not** “fix” this only by shrinking r further while keeping a Neck-attached hemisphere — S48 already showed radius-alone moves neck dirs **zero**. The defect is **superior shape + attachment landmark**, not only magnitude.

---

## WHAT IS STILL WRONG / open

1. Soft inlet AP/breadth same-subject vs widest — **NOT FOUND** (ANSUR gap).
2. Sex-stratified CT full-aperture means with large N — **NOT FOUND** (textbook bands used).
3. Beast RESEARCH_INDEX / S48 / C153 / D7 / D9 / U95 / S4 files — **BLOCKED** this executor; J41/J42 box priors + brief used instead.
4. Exact FightCamp p80 skin-offset procedure — not re-derived (**DOCUMENTED** from brief only).
5. Q4 grip clearance mm survey — **NOT FOUND**.
6. `grok` CLI — os error 6; web + local ANSUR only.

**Operator decision line:**

> **A rib cage ends at the superior thoracic aperture (T1 / first ribs / manubrium–jugular notch), not at a mid-chest-radius hemisphere on the Neck bone. ANSUR only measures widest chest; soft inlet:widest is NOT FOUND — bony:soft ratios are ~0.2 AP and ~0.35–0.38 transverse. Refuse the dome; taper or stop the thorax volume below the inlet; keep neck as its own thin volume.**

---

## Sources (opened / used this session)

1. ANSUR II Male Public CSV — https://tools.openlab.psu.edu/publicData/ANSUR_II_MALE_Public.csv (**MEASURED**, N=4082). Local: `/workspace/j43/refs/ANSUR_II_MALE_Public.csv`.
2. Gordon et al., NATICK/TR-15/007 — https://tools.openlab.psu.edu/publicData/ANSURII-TR15-007.pdf (**MEASURED** defs + means extract). Local extract: `/workspace/j43/refs/ANSURII-TR15-007_extract.txt`.
3. J42 — `/workspace/j42/J42_THE_HEAD_AS_A_VOLUME.md` (neck/head priors, Q3 table style).
4. J41 — `/workspace/j41/J41_SHOULDER_GIRDLE_PROPORTIONS.md` (r/L method).
5. Superior thoracic aperture — Wikipedia (Last’s/McMinn dims; boundaries) (**DOCUMENTED**).
6. Clinical Gate / Gray’s-style thorax overview — inlet ~5×10 cm; lung apex into neck (**DOCUMENTED**).
7. GPnotebook — STA AP 4.5–6 cm, transverse 9–11 cm (**DOCUMENTED**).
8. Sagittal thoracic inlet distance CT table (TID mean 65.9 mm) — search/PMC abstract extract (**DOCUMENTED**; not full soft AP×transverse).
9. Humanetics Hybrid III 50th Male TPS PDF — rib cage construction; Chest Depth 8.7 in (**MEASURED**).
10. Unity Manual — Create a ragdoll / Ragdoll Wizard (**DOCUMENTED**).
11. UE5 Physics Asset ragdoll practice writeups — torso capsule/box bodies (**DOCUMENTED**).
12. THOR / WorldSID ATD literature — rib modules, not capsules (**DOCUMENTED**).
13. Bullet / Panda3D collision shapes — box torso pattern (**DOCUMENTED**).
14. Task brief J43 (their r, 90/128, S48, neck 0.0594 m) — **DOCUMENTED** as report only.

---

*End J43 memo. Full file on box; parent stages to Beast. Do not confuse with any GitHub stub.*
