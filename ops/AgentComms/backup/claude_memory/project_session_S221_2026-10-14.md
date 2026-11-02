---
name: project-session-s221-2026-10-14
description: "S221 2026-10-13/14 - all built features ON, locker room props via Ludo (no Meshy), FLYFOOT1 rejected, lessons on Ludo picture flow and gates that measure the wrong thing"
metadata:
  node_type: memory
  type: project
  originSessionId: d5ec3f22-b925-47e7-a854-7c754c928847
  modified: 2026-10-13T22:21:51.840Z
---

S221 (digest research/S221_DIGEST.md). Merged: STORYPARITY1A, STATIONWEAR1E (+HUD-strip fix), GYMLOOK3A r6b, all built
features ON ([[feedback_new_features_ship_on]]). Locker room: Ludo r58 props approved, 9 Ludo 3D models (36 credits),
TASK_LOCKER1B queued. FLYFOOT1 rejected by the operator -> FLYFOOT2. Boots: F21 MetaHuman Hightops (his Fab yes; Epic sign-in
click left to him - never confirm a sign-in for him).

Lessons:
- Ask Ludo makes ONE picture per message; a 10-picture ask stops after one. Style-test ONE prop first, show the operator, then
  send one message per prop (window.__put helper + click send at ~(1134,670); Return does not always send). `ludo image create
  --image-type 3d` (0.5 cr) works when the chat stalls; `ludo model create --model prop --target-num-faces 5000 --texture-size 1024`
  (4 cr) turns approved pictures into GLBs with snapshot PNGs to check. No Meshy: operator "not sure why we need messhy3d".
- Upload to Ask Ludo one file per click of the picture icon (two at once -> "Too many files").
- Twice this session an agent's gate passed what the operator rejected at once (FLYFOOT1 feet measured position not orientation;
  PROFILE2E face direction from a bone axis whose sign was chosen toward the camera). Brief every visual gate on the quantity
  the operator SEES, and demand red on the shipped tree first.
- Low punch output (8/min) exists on master too - compare against master before blaming the branch.
- A git index.lock with no git process running is stale; check processes, then remove.
Related: [[feedback_ludo_upload_pictures]], [[feedback_s217_visual_and_heat]].
