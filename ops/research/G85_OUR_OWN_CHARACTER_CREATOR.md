# G85 - can we ship our own character creator? Licences of the open body bases (Grok, delivered)

Collected S64, 2026-09-24, by Claude from grok.com chat "Licence Analysis for Open Character Creators"
(Research mode, Expert, 87 sources). Reply captured verbatim from the page's innerText; table cells were
tab-separated in the capture and are re-laid as Markdown tables here, wording unchanged.
Agrees with John's J45 (`J45_OUR_OWN_CHARACTER_CREATOR.md`) on every shared row.

---

Verdict: Yes — ship a live in-game creator from MakeHuman / MPFB2 core assets (base mesh + targets + bundled skins/clothes). Assets are CC0. Do not ship MH/MPFB source. SMPL/SMPL-X is a no without a paid commercial licence.

## Q1–Q3

| Item | Licence | Commercial closed-source ship of mesh+targets? | Attribution? | Shape keys / morphs? | Rigged? | Label |
|---|---|---|---|---|---|---|
| MakeHuman 1.x CODE | AGPL-3.0+ | No (viral on code). Do not embed the app or its logic. | AGPL notices if you ship code | n/a | n/a | VERIFIED-FROM-LICENCE-TEXT |
| MakeHuman 1.x ASSETS (base mesh, proxies, targets/modifiers, textures, MHCLO clothes, poses/expressions) | CC0 1.0 | Yes, modified, inside a closed game, including a live slider generator | No | Yes — targets are the morphs | Separate skeletons exist; not the asset licence | VERIFIED-FROM-LICENCE-TEXT |
| MakeHuman output / copies of those assets | CC0 (project claims no logic in output) | Yes | No | Yes if you keep targets | As exported | VERIFIED-FROM-LICENCE-TEXT |
| Community MH assets (not bundled) | Often CC0 or CC-BY | Only if that asset’s own licence allows | CC-BY: yes | Varies | Varies | VERIFIED-FROM-LICENCE-TEXT (bundled vs 3rd-party split) |
| MPFB2 add-on CODE | GPLv3+ | No — do not ship the add-on | GPL notices if you ship code | n/a | n/a | VERIFIED-FROM-LICENCE-TEXT |
| MPFB2 bundled ASSETS (same list + rigs + JSON mesh data) | CC0 1.0 | Yes | No | Yes | Yes (several rigs incl. game/Rigify) | VERIFIED-FROM-LICENCE-TEXT |
| Mesh exported from MPFB2 | Project: combination of CC0 assets + your input; “no claim” over FBX/OBJ/DAE/MHX2 etc. | Yes — treat as yours | No (unless you added a CC-BY 3rd-party asset) | Whatever you baked/kept | Whatever you exported | VERIFIED-FROM-LICENCE-TEXT |
| SMPL / SMPL-X model (shape components, blend weights, model files) | MPI non-commercial research licence. Commercial = paid Meshcapade/MPI deal. Patents on SMPL. | No (free licence). Paid licence required. | Academic cite; commercial per contract | Yes (shape + pose correctives) | Yes | VERIFIED-FROM-LICENCE-TEXT |
| SMPL-Body (a baked body, no shape-model tools) | CC-BY 4.0 | Yes as a baked character, not as a live SMPL generator | Yes (BY) | Pose/dynamic shapes may travel with the body file | Yes | VERIFIED-FROM-LICENCE-TEXT |
| Blender Studio Human Base Meshes | CC0 1.0 | Yes | No | No parametric body-fat/muscle target set (sculpt/multires bases, face sets, UVs) | Not a game creator rig as shipped | SECONDARY (studio/demo pages + CC0 on files; not a full legalcode dump in-repo like MH) |
| Kenney humanoids | CC0 1.0 | Yes | No | No (fixed low-poly chars) | Yes + anims | VERIFIED-FROM-LICENCE-TEXT (pack pages) |
| Quaternius humanoids | Older packs: CC0. Site now QAL v1.0: commercial games OK, no credit; cannot resell/redistribute the assets as a standalone pack/template | In-game use: yes. Shipping a creator kit made of their meshes as the product is the QAL risk | No | No parametric morph base | Yes + anims | VERIFIED-FROM-LICENCE-TEXT (QAL §2–3) |

## Quoted clauses

MH code vs assets (makehuman/LICENSE.md):

> The MakeHuman application consists of two separate parts: Source code… Assets…
> The MakeHuman source … is released under AGPL.
> The assets are defined as any data contributing to the graphical output of MakeHuman. This includes: The base mesh and proxies; Targets and modifiers; Textures; Clothes (any MHCLO-based asset); Poses and expressions. These assets have been released under CC0 1.0 Universal.

MH output / live reuse (same file §D):

> no output from MakeHuman contains any trace of program logic… As the assets have been released under CC0, there is no limitation on what you can do with this combined output.

Explicit chargen permission (project FAQ, SECONDARY to the CC0 text but on-point):

> Take all mesh and target assets and build a character generator of your own, with no restriction on what license that character generator needs to have.
> It is perfectly fine to take the base mesh, the targets and the system assets pack and use these to create a full character generator… There are already several platform-specific endeavors of this kind, for example a character generator for Godot.

Attribution on core assets (community licence page):

> You do not need to pay anything, include any copyright notices nor give attribution.

3rd-party MH assets:

> If you use a third part asset… it is your own responsibility to make sure you abide by its specific license.

MPFB2 (mpfb2/LICENSE.md): code GPLv3; assets CC0 (base, targets, textures, MHCLO, rigs, poses, JSON mesh data). Output: same “no claim” list as MH (FBX/OBJ/DAE/MHX2…).

SMPL model (smpl.is.tue.mpg.de/modellicense.html):

> use the Software for the sole purpose of performing non-commercial scientific research, non-commercial education, or non-commercial artistic projects. Any other use, in particular any use for commercial purposes, is prohibited. This includes, without limitation, incorporation in a commercial product… The Software may not be reproduced, modified and/or made available in any form to any third party without Max-Planck’s prior written permission.

SMPL-Body (baked character, not the model): CC-BY 4.0.

Quaternius QAL §3a: may not “extract, repackage… redistribute the Assets… as a standalone asset, asset pack, stock file, template”. Incorporating into a finished Product is allowed.

Pre-2020 MH texts that called targets AGPL / banned reverse-engineering targets are obsolete. 2020 restated targets as CC0 “no matter how you got hold of them.” Use current LICENSE.md only.

## Q4 — What a live creator needs that a base mesh lacks

| Need | MakeHuman / MPFB2 core | Others |
|---|---|---|
| Shape targets (muscle, fat, width, face) | Have. Hundreds of vertex-offset targets; this is the product. | SMPL has them but licence blocks commercial live use. Blender Studio / Kenney / Quaternius: static meshes, no body-param set. |
| Your own slider formulas | Licence allows. Do not copy MH/MPFB code (AGPL/GPL). Reimplement weights in Godot. | — |
| Per-target normal maps | Not provided as a per-slider NM set. Bundled skins are base textures. You author extra NM/detail or live-recalc normals. | Same gap on CC0 sculpt bases. |
| Joint corrective shapes | Targets are rest-pose offsets. Helpers exist for clothes/hair fit. Pose correctives like SMPL pose-blendshapes are not the MH target library. MPFB supplies rigs (incl. a game-engine variant); correctives you add. | SMPL has pose blendshapes — unusable commercially without a paid licence. |
| Clothes that follow morphs | Have. MHCLO maps each cloth vert to base-mesh verts (exact or barycentric + offset). Refit when targets change. Helper geometry for fit. Community clothes may be CC-BY. | Kenney/Quaternius clothes are fixed meshes, not morph-following. |

Ship path that matches the licences: take bundled hm08 (or current) base + bundled targets + bundled CC0 skins/MHCLO → convert to Godot blend shapes + your sliders. Leave MH and MPFB binaries/source out of the build. Audit every extra asset pack for CC-BY. Do not use SMPL shape components.

Not legal advice; clauses above are from the current project licence files and MPI/SMPL pages.
