# G125 - REGENERATING THE FIGHTERS ON TRIPO PRO, AND HOW PROMOTIONS SHOOT ROSTER PORTRAITS
Grok (Expert, research), delivered 2026-09-26 in grok.com/c/3f7c2477-afdd-451c-a65f-674beb453435, 113 sources.
Collected verbatim in substance by Claude, S92. Grok's inline citations render as site names only (developers.tripo3d,
researchgate, pmc.ncbi.nlm.nih, mocaponline, hollylist, behindtheshutter); URLs not exposed by the page.

**Claude's note on the premise (S92):** the task said the twelve were made on Tripo's FREE plan. The record says
otherwise - they were generated through Higgsfield's MCP `tripo_3d` model (paid Higgsfield Plus, 5 credits each) and
rigged on Ludo Rig & Animate (HANDOFF_ARCHIVE "THE PROOF FIGHTER", R77, Q63). See S92_DIGEST.md.

Roster rebuild on Tripo Pro. Same input grammar, same settings, same portrait rig. Action poses and mixed lighting are
the failure mode.

## 1. Image-to-3D
- **Input.** High-res, even light, plain white/grey bg, subject fills frame, no motion blur. Tripo: JPEG/PNG/WebP,
  <= 20 MB, subject >= 256 px; practice target >= 2048. SOURCED (developers.tripo3d)
- **Pose / views.** Neutral T-pose or A-pose only; crossed arms / action pose welds the mesh. Front + side + back
  (+ right) beats single view; 2-4 consistent views, same scale and light. Mixed scale twists the mesh. SOURCED
- **What breaks.** Hands/feet: fused digits, wrong count, thumb in palm. PROXY (Meshy/Hunyuan): gloves weld to fists,
  shorts weld to thighs, hair welds to shoulders if the silhouette is busy.
- **Tripo Pro knobs.** Latest gen (v3.1 / P2.0), multi-view, geometry_quality=detailed (Ultra), quad=true for
  rig/subdiv, texture_quality=detailed (4K) or extreme (8K on P2), pbr=true, enable_image_autofix on weak stills. Face/
  hand detail = Ultra + clean close-up refs, not a separate public toggle. SOURCED (developers.tripo3d)

## 2. Auto-rig
- Tripo: humanoid auto-rig + preset preview, FBX/GLB. Mixamo: free humanoid. AccuRIG: desktop, finger joints. SOURCED
- **A-pose vs T-pose.** T-pose: axis-aligned bones, Mixamo-friendly, worse shoulder pinch when arms drop. A-pose
  (~45 deg): closer to guard; cleaner shoulders/armpits for punch + clinch; the industry default for new game rigs.
  SOURCED (mocaponline)
- **Skinning failures.** Shoulders/armpits collapse; hips twist on wide stance; fingers do not separate; gloves inherit
  body weights. Weight-paint elbows, knees, shoulders after auto-rig.
- JUDGEMENT (Grok): generate and bind in A-pose; one Mixamo/AccuRIG pass as a retarget check, not the hero rig.

## 3. Proportions (prompt numbers) - SOURCED (UFC top-16 by class; women's A:S bout study; century HW boxing sample)
| Class | Height | Wingspan / reach | Notes |
|---|---|---|---|
| UFC M fly | 168.4 +/- 3.6 cm | 173.1 +/- 4.4 cm | BMI 20.1 |
| UFC M HW | 191.5 +/- 4.3 cm | 198.9 +/- 7.6 cm | BMI 31.5 |
| UFC W fly | ~166.8 cm | ~168.8 cm | ape index ~1.01 |
| UFC W straw | ~161.8 cm | ~162.2 cm | shortest roster |
| Boxing HW (elite, historical) | 187.3 +/- 6.5 cm | 195.2 +/- 9.4 cm | 97.5 +/- 11.5 kg |
- Body fat: MMA men ~8-15%; UFC PI mid-camp targets men 7-14%, women 14-24%. SOURCED (pmc). Do not prompt a flyweight
  woman as a scaled-down heavyweight.
- Biacromial rises with class (ISAK boxing, heavy ~42 cm class mean). Relative span 1.02-1.04 men, ~1.00-1.01 women
  fly/straw. PROXY where unmeasured: men span = height + 4-8 cm; women fly = height + 0-3 cm.

## 4. Promotion portraits + game cards
- UFC: a dedicated photo session, same station every event, vertical, look-to-camera, 3/4 or head-and-shoulders;
  posing stations on a uniform backdrop and green screen. SOURCED (hollylist)
- Boxing promo stills: one locked kit for the roster - 70-200 mm, beauty-dish key, two rim/kicker lights, white OR
  black seamless, never mixed; crop and WB identical. SOURCED (YouTube)
- PROXY: three-point sports grammar - key high ~45 deg down, dual rim, black drop, grid off the backdrop.
- Games (EA UFC, Undisputed): select cards are 3D renders of the same mesh, not photos; head-and-shoulders, slight 3/4,
  hard key + rim, dark ground, identical framing. JUDGEMENT: cards are a studio render of the Pro mesh, not a second
  generation.

## 5. JUDGEMENT - do this
**Reference prompt (per fighter):** "Full-body production turnaround, one athlete, neutral A-pose, feet shoulder-width,
fists lightly closed not touching hips, [sex] [sport] [class], height [cm], wingspan [cm], BF [range], biacromial
appropriate to class, separate [gloves/wraps] from hands, separate shorts from thighs, bare shins/feet visible, closed
mouth, eyes forward, even studio light, plain grey background, photoreal, no stylize, no action pose." Then matching
front / left / back / right at the same scale.
**Tripo Pro lock:** multi-view, v3.1 or P2.0, Ultra/detailed geometry, quad on, PBR on, texture detailed (4K); one
lighting/material look for all twelve.
**Rig pose:** A-pose bind, humanoid auto-rig, FBX.
**3-check sign-off per fighter:** (1) ortho spin - 5 fingers, 5 toes, gloves and shorts not welded, face not collapsed;
(2) pose test - jab peak, rear hook, overhook clinch, double-leg level change: shoulders and hips hold volume;
(3) roster card - same camera as the other eleven.
**Portrait recipe:** 85-135 mm equivalent, eye level, 3/4, crop mid-sternum to above the hair; key 45 deg camera-left,
two thin rims, fill just off black; charcoal #0B0C0A backdrop; closed mouth, fight-week calm; identical resolution and
head size.
**The ONE mistake:** generating from fight poses or single 3/4 beauty shots with different crops/lighting.

## Claude's reading (S92)
- The A-pose recommendation CONFLICTS with our pipeline: every clip retargets onto a T-pose Ludo "Godot (humanoid
  profile)" skeleton with per-fighter corrections (R111). U114 proved the Cascy path reads the bind hierarchy and does
  not need a T-pose, but the RamsterZ corrections are per fighter. Kept T-pose + the Ludo naming for the regeneration;
  A-pose is a separate, measured change, never folded into a mesh swap.
- The portrait recipe is adopted as written: render the card from the 3D mesh, one camera and light for all twelve.
