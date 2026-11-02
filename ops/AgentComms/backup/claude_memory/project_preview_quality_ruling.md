---
name: project-preview-quality-ruling
description: "Operator 2026-09-24: no clip purchases until our game matches the RamsterZ preview reels with clips we own; C189 proved the retarget is fine and the room's placement + walk splice is the cause"
metadata:
  node_type: memory
  type: project
  originSessionId: 4c435d8b-5e50-4730-9d41-e9dcfd87d015
  modified: 2026-09-24T07:48:24.617Z
---

Operator ruling 2026-09-24, verbatim: "We are not buying other clips unless I see the quality that I see on the YouTube preview videos. In our game, ask other agents why this is happening. Where, why is our pipeline doesn't handle it like in the preview videos? I want this fixed."

The reels are RamsterZ's Unity showcases (Hand to Hand Set - WE OWN IT, 124 FBX, bound ~295x; Martial Arts Master, EUR 45.99 - not bought). Codex C189's control arm (research/C189_DIGEST.md): our fighter playing a clip WHOLE matches the vendor mannequin (ankle 6.6 vs 6.6 m/s) - **the retarget is not the problem**. The live room: ankle 53-75 m/s; engine_positions off -> 5.6-6.7. So #1 = the simulation placing bodies + the walk layer spliced onto the legs; #2 = seeking into / cutting clips at 20 Hz beats; tempo had no effect. Grok G87 (G87_PREVIEW_QUALITY.md): shipped fight games let the CLIP own a committed strike's timing and warp where it lands, not when.

**Why:** the operator judges by eye against the vendor reel; more clips through the same pipeline would look equally bad.
**How to apply:** never propose a clip purchase as a quality fix; fix playback (Codex C190, Cursor U159, Qwen Q167). Measure with a control arm (whole clip on our fighter) before blaming the rig. Related: [[project-retarget-quality-is-the-bottleneck]] is now contradicted for strikes - the retarget measured fine.
