# J31 — AI Generators + Scripts + Blender: Will This Pipeline Work for Us?

**Author:** John Research  
**Date:** 2026-09-14  
**Scope:** Research only. No credits spent. No downloads. No engine.  
**Engine:** Answer for **Godot 4.7**; note Unreal differences where relevant.

**Claim labels:** **DOCUMENTED** (URL opened) / **INFERENCE** / **NOT FOUND**. Vendor marketing = DOCUMENTED only as “vendor says.”

---

## DECISIONS

1. **What Character Animation is:** Vendor says text prompt → “fitted, weighted rig plus keyframes… standard Blender bones and actions” — **DOCUMENTED** (higgsfield.ai/plugins/blender; blog). The motion **model is not named** on those pages — **NOT FOUND**. Catalogue lists **Meshy 5 for 3D**, not a named text-to-motion model for Character Animation — **DOCUMENTED**. Your Plus/API check (Meshy library, `Left_Jab_from_Guard`, Mixamo-style 24-bone @24 fps) matches **Meshy preset application**, not free-form generative combat — **INFERENCE** (facts + Meshy Animation Library docs). Arbitrary “double-leg takedown” from prose alone: **not evidenced** as true generation; library lacks real grappling (only stunt Jumping_Head_Scissor_Takedown per your check).

2. **Existing-rig / two-body:** Vendor copy describes a **new** fitted rig; nothing about driving **our Tripo/humanoid skeleton** or **two characters with contact** — **NOT FOUND** on plugin pages.

3. **Licence (Higgsfield paid/Plus):** §4.4 — no ownership claim on Outputs; commercial use not restricted; rights in exported Outputs **survive cancel**; may train on Inputs/Outputs unless Enterprise; §5.2(iv) **no training models on Outputs** — **DOCUMENTED** (terms-of-use-agreement; help article). Plugin FAQ: same rights as web, commercial on paid — **DOCUMENTED**.

4. **Licence (Meshy):** Paid: private ownership of generated assets (help center). Free: CC BY 4.0. **Service Assets** (animation library clips): Meshy grants licence “solely to the extent incorporated into… Customer Output” — **DOCUMENTED** (meshy.ai/terms-of-use §2.3, §3.1). Do not treat library clips as freely redistributable standalone packs without reading that limit. No competitive-AI training on assets — **DOCUMENTED**.

5. **Discipline table (operator workflow as sent → verdict):**

| Discipline | As-sent workflow | Works | Breaks | Recommended |
|------------|------------------|-------|--------|-------------|
| Boxing / KB / MT (strikes) | Prompt/library → Blender → Godot | Solo strike + block/dodge **library** clips as **INPUT** candidates | Two-body clock, contact, style vs RamsterZ; 24 fps; cock/hold artifacts (your jab test) | Keep **move script + Blender pair + MediaPipe footage**; use Meshy/Higgs **solo** clips only as optional source to retarget/correct |
| MMA striking | same | same | same + more kick variety | same |
| Wrestling / judo / BJJ / MMA grappling | “Generate double-leg…” | **Does not** deliver paired contact | No library grappling; no two-person tool in plugin; research InterGen = research/NC, not ship pipeline | **Paired footage + script + Blender/Cascadeur**; bought/hired two-man mocap or video-to-motion on **allowed** demos — not Higgs Character Animation |
| Trailer / hype | Script → blockout → Seedance | **Yes** as marketing video | Not gameplay bone data | Seedance / Cinema path for trailers only |
| Character mesh | Higgsfield concept → Meshy 5 → FBX/GLB | Possible **placeholder** meshes | Consistency with Tripo roster; retarget/rig mismatch | Keep **one humanoid**; Meshy only if quality/licence pass QA |

6. **Will it achieve the goal?** **No** as the sole playable pipeline. It does **not** replace the working **script + two-fighter Blender clock**. It can **supplement** striking inputs and **trailers**. Grappling: **fails**.

7. **1,000 credits — highest value (no spend by John):** (a) 2–3 Meshy striking presets on **our** mesh + export bone curves for retarget tests; (b) one Character Animation **double-leg** prompt — expect fail/stunt → confirms boundary; (c) Seedance trailer plate from Blender blockout — marketing only.

---

## SOURCES

| URL | Who | Year | What it says | Grade |
|-----|-----|------|--------------|-------|
| https://higgsfield.ai/plugins/blender | Higgsfield | 2026 | Character Animation = rig+keyframes; Meshy 5 for 3D; commercial = paid/ToS; Blender 5.1+ | A |
| https://higgsfield.ai/blog/higgsfield-blender-plugin | Higgsfield | 2026 | “Describe the move… keyframes on the timeline”; production uses = previs/pitch | A |
| https://higgsfield.ai/terms-of-use-agreement | Higgsfield | 2026-07-26 | §4.4 Outputs ownership/commercial/survive cancel; train licence; §5.2(iv) no train on Outputs | A |
| https://higgsfield.ai/creator-hub/help-center/account/who-owns-my-generations-and-can-i-use-them-commercially | Higgsfield | 2026 | Restates commercial rights; no attribution required | A |
| https://www.meshy.ai/terms-of-use | Meshy | 2026-09-19 | Service Assets licence; paid vs free ownership; no competitive AI train | A |
| https://help.meshy.ai/en/articles/16102098-can-i-use-meshy-assets-commercially | Meshy Help | 2026 | Paid private ownership; free CC BY 4.0 | A |
| https://docs.meshy.ai/en/api/animation-library | Meshy Docs | n.d. | Animation library via `action_id` API | A |
| https://www.meshy.ai/use-cases/3d-animation | Meshy | n.d. | Vendor: 600+ presets; export FBX/GLB incl. Godot | B |
| https://arxiv.org/abs/2304.05684 | InterGen | 2023/24 | Two-person text motion research | B |
| https://github.com/tr3e/intergen | InterGen | n.d. | InterHuman **CC BY-NC-SA**; redistribution prohibited | A |
| https://github.com/zhenzhiwang/intercontrol | InterControl | 2024 | Research code; not a commercial game API | B |
| https://www.youtube.com/watch?v=QkLKpUDDdgo | YouTube | n.d. | Operator link; page metadata **NOT retrieved** this pass (fetch blocked) | C |

Shipped AAA fighting/sports titles built on AI text-to-motion as primary combat anim: **NOT FOUND**. EA UFC / Undisputed-class grappling remains **two-man mocap / authored pairs** in public talks (see J30 Hayes) — **DOCUMENTED** earlier, not re-opened.

---

## HIGGSFIELD CHARACTER ANIMATION

- **Input (vendor):** text prompt in Character Animation tab — **DOCUMENTED**.  
- **Output (vendor):** fitted weighted rig + timeline keyframes; edit like mocap — **DOCUMENTED**.  
- **Backend:** **NOT NAMED**. Not listed beside Seedance/Meshy 5 as a motion model — **DOCUMENTED**.  
- **Empirical (your desk):** Meshy library clip names + Mixamo-like 24-bone @24 fps — treat as **library apply**, not Hunyuan/MotionGPT-class open generation — **INFERENCE**.  
- **Combat:** Strikes/blocks exist in Meshy library (your inventory). Grappling/takedown/clinch/ground: **absent** except stunt-like scissor — **DOCUMENTED** (your inventory).  
- **Existing Tripo rig / two fighters:** **NOT FOUND** in vendor docs.

---

## INDUSTRY PRACTICE (2025–2026)

| Tool | Typical role | Shipped combat? |
|------|--------------|-----------------|
| Meshy / Higgsfield 3D+anim | Concept, placeholder, solo preset motion | **NOT FOUND** as shipped fighter systems |
| Seedance / video gens | Trailers, previs film | Marketing, not bone gameplay |
| Cascadeur (+ physics/AI assists) | Clean / author contact; two characters in one scene | Indie/DCC; not “generate double-leg from text” |
| Move.ai / Rokoko Vision / DeepMotion | Video→motion (paid commercial plans) | Possible input to **scripted pairs** if licence OK |
| InterGen / InterControl / Duolando-class | Research multi-human | **Not** commercial game pipelines; InterHuman NC |

**Pattern:** AI fills **previs, meshes, solo clips**; **playable combat** still scripted/mocap/paired. Matches your working method (RamsterZ → script → Blender pair).

**Godot vs UE5:** Both consume skeletal FBX/GLB. UE has Contextual Anim / Motion Warping stock; Godot needs your room + scripts (J30). Difference is **runtime sync helpers**, not licence of Meshy clips.

---

## PAIRED MOTION

- **Commercial, game-ready, two-body contact generator** (wrestling/judo/BJJ quality): **NOT FOUND**.  
- InterGen: research; dataset **BY-NC-SA**, no redistribute — **DOCUMENTED**.  
- AAA grappling: two-performer capture / authored interactions (J30 / Hayes) — keep that path.

---

## LICENCES (short quotes)

**Higgsfield §4.4:** “Company does not claim ownership of any of your Inputs or Outputs, nor does it restrict your commercial use of Outputs. Your rights in Outputs you have generated and exported survive cancellation…” — **DOCUMENTED**.  
**Higgsfield §5.2(iv):** no using Outputs to train AI systems (with narrow exceptions) — **DOCUMENTED**.  
**Meshy §3.1:** Service Assets licensed “solely to the extent incorporated into and necessary for Customer to use and otherwise exploit the Customer Output” — **DOCUMENTED**.  
**Meshy Help:** paid private ownership of generated models; free CC BY 4.0 — **DOCUMENTED**.

---

## THE PIPELINE (optimized)

**Playable (all disciplines):**  
`Move script (J30) → Blender (both on one clock) → MediaPipe / two-man footage QA → Cascadeur optional contact clean → export bones → Godot`  
Source clips: **RamsterZ first**; Meshy/Higgs **solo** strike/block as **optional** inputs after retarget + script.

**Striking only add-on:** Meshy library jab/hook/kick/block → retarget to humanoid → **still** run through pair script (never solo into room).

**Grappling:** **Do not** use Character Animation prompts. Capture or buy **paired** motion / allowed video→motion → script → Blender/Cascadeur.

**Trailer:** Blender blockout → Higgsfield **Seedance** (photoreal video). Not gameplay.

**Meshes:** Prefer current Tripo humanoid. Meshy 5 / Higgs concept = optional variants with strict art-dir lock.

---

## WHAT TO TEST FIRST (Claude / operator; John spends $0)

1. **Double-leg prompt** in Blender Character Animation — if output is nonsense, missing partner, or scissor-stunt: **refutes** grappling-from-text.  
2. **Library** `Left_Jab_from_Guard` + matching Face_Punch_Reaction on **same** humanoid — measure contact frame; run through J30 script vs MediaPipe — **confirms** “input only” role.  
3. Export FBX → Godot: bone count, fps (24→30/60 resample), root motion — **confirms** engine path.  
4. Prompt “animate this existing armature” / attach to Tripo rig — if forced new Mixamo rig: **confirms** no existing-rig path.  
5. One Seedance trailer from blockout — **confirms** marketing lane only.

**Confirm:** paired scripted pipeline stays primary. **Refute:** if (1) yields usable two-body judo/wrestle with contact — then re-open (unexpected).
