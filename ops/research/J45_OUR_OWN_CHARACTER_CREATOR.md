# J45 — Can we SHIP our own character creator? Licences of the open body bases

**Agent:** John (research desk)  
**Date:** 2026-09-24 Asia/Nicosia (EEST)  
**Assigned:** S63 / TASK_J45 (operator named John; second opinion vs G85)  
**Kind:** Licence facts only. No code. Not legal advice — quotes are from published licence/FAQ text retrieved 2026-09-24.  
**Why:** Reallusion Character Creator EULA §5 lets baked fighters ship but bans a live in-game generator (and copying its morphs). Lead wants an in-game creator on an OPEN base + shape targets in Godot. Before build: licence facts.

**Labels:**  
- **VERIFIED-FROM-LICENCE-TEXT** — quoted from the project's own LICENSE.md / model licence / official FAQ that restates that licence.  
- **SECONDARY** — reputable third-party summary or project docs that are not the licence file itself.  
- **UNKNOWN** — not established from primary text this pass.  
- **JUDGEMENT** — product/architecture opinion, not a licence claim.

**Priors on disk (index only, not re-read as licence sources):** C179 / G78 / G81 / S60–S61 Character Creator physique path — Reallusion pipeline, not open-base licences.

---

## Operator one-liner

> **Yes for MakeHuman / MPFB2 core assets (CC0): a closed-source Godot creator may ship the base mesh + targets modified, with no attribution required — but must not ship MakeHuman (AGPL) or MPFB2 (GPLv3) program code. SMPL/SMPL-X research downloads forbid commercial incorporation. MB-Lab / CharMorph MB characters are AGPL on the database and poison closed shipping. Quaternius / Kenney / Blender Studio Human Base Meshes are CC0 but are not parametric body creators (few or no body shape keys).**

---

## Q1–Q3 — Licence table

| Item | Code licence | Assets / exports licence | Commercial closed-source game may ship mesh + morphs inside build? | Attribution required? | Shape keys / targets? | Rigged? | Label |
| --- | --- | --- | --- | --- | --- | --- | --- |
| **MakeHuman 1.x / Community** (bundled core) | **AGPL** (python, scripts, GLSL, UI images) | **CC0 1.0** for bundled graphical assets: base mesh & proxies, targets & modifiers, textures, MHCLO clothes, poses & expressions. Output (FBX/OBJ/DAE/MHX2, MPFB import, screenshots, saved models) claimed as **your data**. Third-party asset-repo downloads: **their own licence**. | **YES** for bundled core assets, including building your own character generator. FAQ: *"Take all mesh and target assets and build a character generator of your own, with no restriction on what license that character generator needs to have."* Do **not** ship MakeHuman application source as the in-game tool (AGPL). | **No** for CC0 core (FAQ: closed-source game without attribution). | **Yes** — large target/modifier set (body, face, etc.). | **Yes** — MH skeleton / exports. | **VERIFIED-FROM-LICENCE-TEXT** ([LICENSE.md](https://github.com/makehumancommunity/makehuman/blob/master/LICENSE.md); [FAQ: Are MakeHuman files free?](https://static.makehumancommunity.org/makehuman/faq/are_makehuman_files_free.html); [2020 licence change FAQ](https://static.makehumancommunity.org/oldsite/faq/what_changed_regarding_the_license_in_2020.html)) |
| **MPFB2** (MakeHuman Plugin for Blender) | **GPLv3** (addon program logic) | **CC0 1.0** for bundled assets: base mesh & proxies, targets & modifiers, textures, MHCLO clothes, **rigs**, poses & expressions, JSON mesh info. Exports / Blender files / renderings: **your data** (project makes no claim). | **YES** for core assets / exported meshes in a closed-source game. FAQ: *"All core assets (the base mesh, targets, skins…) are shared under CC0."* Do **not** ship the MPFB2 addon code inside a proprietary game binary (GPLv3). A mesh exported from MPFB2 using core assets is treated as **yours to ship**. | **No** for CC0 core. Third-party assets: follow that asset's licence. | **Yes** — same MakeHuman-family targets when loaded. | **Yes** — rigs listed as CC0 assets. | **VERIFIED-FROM-LICENCE-TEXT** ([mpfb2 LICENSE.md](https://github.com/makehumancommunity/mpfb2/blob/master/LICENSE.md); [FAQ: closed-source game](https://static.makehumancommunity.org/mpfb/faq/use_in_closed_source.html)) |
| **SMPL** (research download) | MPI research software licence (not GPL/CC0) | Same instrument covers model data (meshes, blend weights, blend shapes, etc.) | **NO** under free download. *"Any other use, in particular any use for commercial purposes, is prohibited. This includes, without limitation, incorporation in a commercial product…"* Commercial use requires separate licence (Meshcapade / Max-Planck contacts). | N/A (cannot ship under research licence). Research pubs require paper citation. | **Yes** — shape blend shapes + pose blend shapes. | **Yes** — standard skinned model. | **VERIFIED-FROM-LICENCE-TEXT** ([SMPL model licence](https://smpl.is.tuebingen.mpg.de/modellicense.html)) |
| **SMPL-X** | Same class of MPI research licence | Same | **NO** under free download — commercial / pornographic / military / surveillance use prohibited; no redistribution to third parties without prior written permission. Commercial path via Meshcapade / `ps-license@tue.mpg.de`. | N/A for commercial ship. | **Yes** — shape + expression + pose. | **Yes**. | **VERIFIED-FROM-LICENCE-TEXT** ([smplx GitHub LICENSE](https://github.com/vchoutas/smplx/blob/main/LICENSE); [SMPL-X modellicense](https://smpl-x.is.tue.mpg.de/modellicense.html)) |
| **Blender Studio Human Base Meshes** | N/A (asset bundle) | **CC0** (stated on blender.org Demo Files: "49 MB – CC0") | **YES** — CC0 commercial OK. | **No** (CC0). | **Partial** — Generic Head Topology includes **example head shape keys** (Blender 4.0 asset-bundle notes). Full-body parametric muscle/fat/shoulder targets: **not** a MakeHuman-class target set (**SECONDARY** / product feature, not a licence claim). | Bundle is sculpt/modeling bases; not shipped as a game-ready Humanoid fight rig out of the box (**SECONDARY**). | Licence: **VERIFIED-FROM-LICENCE-TEXT** ([blender.org/download/demo-files](https://www.blender.org/download/demo-files/)). Shape-key scope: **SECONDARY** ([Blender 4.0 asset bundles notes](https://developer.blender.org/docs/release_notes/4.0/asset_bundles/)) |
| **Quaternius Universal Base Characters** | N/A | **CC0 1.0** (itch.io Asset license; site: free personal/educational/commercial) | **YES**. | **No**. | **No** body morph target set advertised — mix/match hairstyles + eye/skin colour shaders, not muscle/fat/shoulder blend-shape banks (**SECONDARY** feature list). | **Yes** — Humanoid rig; Godot/Unity/UE packs. | Licence: **VERIFIED-FROM-LICENCE-TEXT** / pack page ([quaternius.com](https://quaternius.com/packs/universalbasecharacters.html); [itch.io](https://quaternius.itch.io/universal-base-characters)). Shape keys: **SECONDARY** |
| **Kenney Animated Characters** (and similar Kenney character packs) | N/A | **CC0** (Kenney standard: commercial OK; credit optional not required) | **YES**. | **No** (optional credit). | **No** parametric body shape keys (**SECONDARY** — stylized low-poly characters). | **Yes** — animated / node or skinned depending on pack. | Licence: **VERIFIED-FROM-LICENCE-TEXT** for Kenney CC0 policy on pack pages ([kenney.nl](https://www.kenney.nl/assets/animated-characters-protagonists); itch/OGA mirrors). Shape keys: **SECONDARY** |
| **MB-Lab** (ManuelBastioniLAB fork) | **GPLv3** (python) | **AGPLv3** on database: meshes, blend files, images, JSON morph data | **NO** for closed-source shipping of those characters/morphs — generated models default to **AGPL** as derived from AGPL database (*"the AGPL will propagate from the base models and from the database to the output models"*). Historical ManuelBastioniLAB 1.6.1 had a **CC-BY 4.0 escape** discussed in community issues for *unmodified official* software — **do not rely on that for MB-Lab forks without reading the exact fork licence you ship from** (**SECONDARY** / **UNKNOWN** for current forks). | If somehow using a CC-BY escape: yes, attribution. AGPL path: source obligations. | **Yes** — rich morph JSON / shape system. | **Yes**. | **VERIFIED-FROM-LICENCE-TEXT** ([animate1978/MB-Lab license.txt](https://github.com/animate1978/MB-Lab/blob/master/license.txt)) |
| **CharMorph** (MB-Lab successor tooling) | **GPLv3** | **Per character**: MB-Lab-based characters remain **AGPL**; docs/community note other bases (e.g. Vitruvian CC0, some CC-BY) — verify the selected character's licence file before ship. | **MB-Lab characters: NO** for closed proprietary morph shipping. **CC0 bases inside CharMorph: YES** if that character's licence is truly CC0. | Depends on character. | **Yes** for parametric characters. | **Yes**. | Code/MB: **VERIFIED-FROM-LICENCE-TEXT** ([Upliner/CharMorph license.txt](https://github.com/Upliner/CharMorph/blob/master/license.txt)). Non-MB bases: **SECONDARY** until each character licence file is opened. |

### Quoted clauses (primary)

**MakeHuman — assets vs code (LICENSE.md §B–D):**  
> "The MakeHuman source … is released under AGPL."  
> Assets include "The base mesh and proxies / Targets and modifiers / Textures / Clothes … / Poses and expressions" — "released under CC0 1.0 Universal."  
> "The MakeHuman project makes no claim whatsoever over output such as: Exports to files (FBX, OBJ, DAE, MHX2…) / Exports via direct integration (import via MPFB) …"  
> "If you use a third part asset … it is your own responsibility to make sure you abide by its specific license."

**MakeHuman FAQ (restates CC0 for generators):**  
> "Take all mesh and target assets and build a character generator of your own, with no restriction on what license that character generator needs to have"  
> "Use a character model in a closed source game without need for attribution"

**MakeHuman 2020 change (targets no longer AGPL):**  
> "BEFORE: Targets, proxies and the base mesh are considered source code, covered by AGPL … AFTER: Targets, proxies and the base mesh are considered graphical assets, covered by CC0"  
> "AFTER: Targets are CC0 no matter how you got hold of them"

**MPFB2 LICENSE.md:**  
> "GPLv3 as source code license rather than AGPL"  
> Assets (including "Rigs, poses and expressions" and "JSON data with mesh information") "released under CC0 1.0 Universal."  
> "no claim whatsoever over output such as: Exports to files … Saved model files" — "yours to handle as you see fit."

**SMPL modellicense:**  
> use "for the sole purpose of performing non-commercial scientific research, non-commercial education, or non-commercial artistic projects"  
> "Any other use, in particular any use for commercial purposes, is prohibited. This includes, without limitation, incorporation in a commercial product…"

**MB-Lab license.txt:**  
> Code GPL3; database (meshes, blend, images, json) AGPL3.  
> "The default license for models generated by the software is AGPL 3 … As derived product of the AGPL'd database, the models must be distribuited under AGPL 3"

---

## Q4 — What an in-game body creator needs that a base alone lacks

Short answers. Feature inventory is **SECONDARY** / **JUDGEMENT** unless noted; this is not a licence claim.

| Need | Why it matters for FightCamp | MakeHuman / MPFB2 core provide? | Blender Human Base / Quaternius / Kenney? | SMPL family (licence blocked for commercial) |
| --- | --- | --- | --- | --- |
| **Body + face shape targets as deltas** | Live sliders (muscle, fat, shoulder width, face) in Godot | **Yes** — targets/modifiers are the product (**VERIFIED** as licensed CC0 assets) | Blender: head example keys only. Quaternius/Kenney: **no** parametric body bank | Yes (shape blend shapes) — **cannot ship** under research licence |
| **Own slider / formula layer** | Map fighter numbers → weights without Reallusion | Must be **your code** (do not ship MH/MPFB GPL/AGPL logic). Licence allows any licence on *your* generator (**FAQ**) | You author all morphs | N/A if not licensed |
| **Joint / pose corrective shapes** | Elbows/knees/shoulders don't collapse at extreme morph × pose | Partial: community docs describe **manual** corrective shape keys driven by bones in Blender — not a complete shipped game corrective library (**SECONDARY**) | No | Strong pose blend shapes (licence blocked) |
| **Per-target or shared detail normals / displacement** | Extreme muscle/fat still reads under fight lighting | Base **skins/textures** exist (CC0); full **per-morph normal sets** are not a documented complete bank — expect to author or bake (**SECONDARY** / **JUDGEMENT**) | Textures vary by pack; not morph-driven | Often research textures; still licence-blocked |
| **Clothing / gear that follows morphs** | Trunks, gloves, tape must fit fat↔lean | **MHCLO** proxies + fit pipeline exist; clothes do **not** auto-inherit every corrective — workflow is re-fit / duplicate keys onto cloth (**SECONDARY**, MPFB clothes docs) | Separate meshes; you build fit | Separate cloth systems |
| **Hair / eyes / teeth as separate pieces** | Face sliders without shearing a monolithic mesh | Proxies / separate assets in MH ecosystem | Quaternius: mix-match hair | Partial |
| **Stable topology + UVs across morph range** | One skin, one mocap retarget, one capsule set | MH base topology is fixed; targets displace verts — good for one pipeline (**JUDGEMENT**) | Fixed meshes | Fixed topology + PCA shapes |
| **Game LOD / morph compression** | Ship size, 60 Hz many fighters | Not provided — your engine work (**JUDGEMENT**) | Same | Same |
| **Honest collision volumes under morph** | Teleports / overlap (prior J41–J44) | Mesh changes; capsules must be **re-derived from morph** or driven by the same sliders (**JUDGEMENT**) | Same | Same |

**Bottom line for Q4 (JUDGEMENT):** MakeHuman/MPFB2 core give the rare combination that matches the lead's plan — **CC0 base + rich targets + clothes proxies** — but an in-game creator still needs **your** slider math, **your** joint correctives (or accept deformation flaws), **authored or baked** detail maps at extremes, **clothes re-fit** across the morph range, and **LOD/capsule** work. Quaternius/Kenney/Blender bases are licence-clean but are **not** a drop-in parametric fighter physique system. SMPL is technically closest to "PCA body creator" and is **licence-blocked** for commercial incorporation without Meshcapade.

---

## Direct answers to the four questions

1. **MakeHuman:** Code **AGPL**; bundled assets **CC0**. Yes — commercial closed-source game may ship modified base mesh + targets. Attribution **not** required for CC0 core. Do not ship the MakeHuman program. Watch third-party asset-repo licences. **VERIFIED-FROM-LICENCE-TEXT.**

2. **MPFB2:** Addon **GPLv3**; bundled assets **CC0**; exports treated as **your data**. Yes — a mesh exported from MPFB2 (core assets) is yours to ship in a closed game. Do not ship the addon code. **VERIFIED-FROM-LICENCE-TEXT.**

3. **Other bases:** See table. SMPL/SMPL-X: commercial forbidden on free download. Blender Human Base / Quaternius / Kenney: CC0 commercial OK, weak/no body shape-key banks. MB-Lab / CharMorph-MB: AGPL database — avoid for closed morph shipping.

4. **Gaps:** Correctives, morph-following clothes, per-morph normals, LOD, slider formulas, collision retarget — open parametric bases only partially cover these; MH/MPFB2 cover targets + MHCLO best among CC0 options.

---

## Argue against this reading (strongest counter)

- **Not a lawyer.** A court could treat a near-clone of MakeHuman's modifier *stacking algorithm* as AGPL-tainted program logic even if targets are CC0 — mitigate by writing **original** slider formulas and treating targets as pure vertex deltas. **JUDGEMENT.**
- FAQ language is strong but is FAQ, not a signed warranty; licence file + CC0 text are the binding instruments. **JUDGEMENT.**
- Third-party MH community clothes/skins often are **not** CC0 — inventory every file before ship. **VERIFIED** caveat in LICENSE.md.
- Cheapest 80%: use MH/MPFB2 **offline** to sculpt a **finite roster** of baked fighters (still CC0), skip live in-game generator until slider/corrective/cloth pipeline exists — still clears Reallusion §5 live-generator ban without building a full creator. **JUDGEMENT.**

---

## Sources retrieved 2026-09-24

- https://github.com/makehumancommunity/makehuman/blob/master/LICENSE.md  
- https://github.com/makehumancommunity/mpfb2/blob/master/LICENSE.md  
- https://static.makehumancommunity.org/makehuman/faq/are_makehuman_files_free.html  
- https://static.makehumancommunity.org/makehuman/faq/can_i_sell_models_created_with_makehuman.html  
- https://static.makehumancommunity.org/oldsite/faq/what_changed_regarding_the_license_in_2020.html  
- https://static.makehumancommunity.org/mpfb/faq/use_in_closed_source.html  
- https://static.makehumancommunity.org/about/license.html  
- https://smpl.is.tuebingen.mpg.de/modellicense.html  
- https://github.com/vchoutas/smplx/blob/main/LICENSE  
- https://github.com/animate1978/MB-Lab/blob/master/license.txt  
- https://github.com/Upliner/CharMorph/blob/master/license.txt  
- https://www.blender.org/download/demo-files/  
- https://quaternius.com/packs/universalbasecharacters.html  
- https://quaternius.itch.io/universal-base-characters  

*End J45. Claude: transcribe/save to `research/J45_OUR_OWN_CHARACTER_CREATOR.md` if not already copied from staging.*
