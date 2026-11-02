# G128 - A CARD PORTRAIT THAT IS THE SAME MAN AS THE 3D FIGHTER
Grok (Expert), delivered 2026-09-26 in grok.com/c/13669344-a2e9-4808-9b39-903ad035f3f6, 70 sources. Collected by
Claude, S93. Citations render as site names only (ufc, docs.godotengine, emergentmind, aiofm, yakhyo.github, higgsfield,
github, forums.ea).

**Games treat the card as a second render of the same mesh, not a separate photo.** EA UFC: scans -> sculpt -> skin +
card hair; fighter select uses a heavier light rig than the bout (UFC 6: 12 lights vs 4, plus grade/rim/vignette).
Undisputed: scans so the man is the same at the tale of the tape and in the ring. FC Create-a-Player: the "miniface" is
a studio capture of the 3D head, cached as an image and regenerated after an edit. SOURCED

## 1. Godot 4.7 - what buys photoreal per hour (Forward+ only for SSS/SSIL; SSS is off on transparent viewports)
| Lever | Cost | Gain | Tag |
|---|---|---|---|
| Dedicated 3-point + rim, dark studio, ~85 mm FOV | 1-2 h | biggest | JUDGEMENT + PROXY (UFC 6 rig) |
| `subsurf_scatter_enabled` + `subsurf_scatter_skin_mode`, quality High, strength ~0.4-0.8 | 30 m | skin stops looking plastic | SOURCED |
| Specular ~0.5 SchlickGGX; roughness 0.35-0.55 dry, lower + anisotropy on wet patches | 30 m | sweat reads as oil, not chrome | SOURCED |
| SSAO (intensity ~2, radius ~1); skip SSIL for a bust | 10 m | cavities (nose, lids) | SOURCED |
| Tonemap AgX or ACES, slight glow, never Linear | 10 m | highlights do not clip | SOURCED |
| CameraAttributesPractical mild far DoF | 15 m | photo, not HUD | SOURCED |
| 2x SSAA or TAA + SMAA on the portrait viewport only | 20 m | pores, hair edges | SOURCED |
| Hair cards + wrap lighting + anisotropy (strands only if already in the pipeline) | hours | cards win per hour | SOURCED + JUDGEMENT |
No first-class film grain in Godot - a one-line shader last, or skip. SSS + skin mode + lights + AA beat SSIL/grain.

## 2. Image-to-image that keeps the man (keep structure, add sensor; condition hard, denoise low)
- **FLUX.1 Kontext:** identity (AuraFace) ~0.99 -> 0.93 over 1-2 edits, then drifts; best "photo finish". SOURCED
- **InstantID:** ID embedding + landmark ControlNet, ArcFace ~0.78; controlnet/ip-adapter scale ~0.7-0.9, img2img
  strength ~0.25-0.45. SOURCED
- PuLID / IP-Adapter FaceID: weaker lock (~0.62-0.72). **GPT-image edit: weak multi-turn identity (AuraFace ~0.42 in
  the Kontext paper) - not the identity lock.** SOURCED
- Prompt only light/grain/pores/sweat - never "change face / younger / handsome".
- **Measure:** same detector + embedder on the aligned render vs the card. ArcFace cosine >= 0.60 "same person" floor,
  >= 0.70 for a card (SOURCED); calibrate on ~20 MakeHuman pairs (PROXY). Reject on eye/nose/jaw drift even if skin
  looks better.

## 3. Legal
Higgsfield claims no inputs/outputs, commercial use on paid plans; keeps a service licence until delete; we stay
responsible for third-party likeness. An edit of our own render stays ours. Never feed a real person's face.

## 4. After the player edits the fighter
Portrait = capture of the same mesh under a portrait environment; re-render on confirm and cache the PNG (FC: generate
miniface -> image cache). Not a live 3D widget on the card. For us: seed -> MPFB -> body + portrait camera; any face/
hair/skin change invalidates the cache and re-captures.

## 5. JUDGEMENT
**Render + a tight edit pass, not raw, not a free generation.** Forward+ portrait scene (SSS skin, 3-point + rim, AgX,
SSAO, mild DoF, 2x AA, hair cards) -> PNG -> Kontext or InstantID at low strength, photo prompt only -> ArcFace/AuraFace
vs the raw render, fail < 0.60. **The trap:** the edit "wins" realism by moving landmarks (wider eyes, smaller nose, a
generic fighter jaw) and the card becomes another man. Light and SSS first; AI last; identity is the release gate.

## Claude's reading (S93)
Adopted. Note it contradicts S92's portrait pool: those 27 were gpt_image generations, fine as placeholders but NOT
the generator's cards. S93's portrait step = Godot studio render of the seeded fighter; the edit pass only if the raw
render fails the operator's eye, and then Kontext (check Higgsfield's model list) with the ArcFace gate.
