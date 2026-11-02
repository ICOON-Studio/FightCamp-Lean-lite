---
name: project-two-body-motion-workflow
description: "THE operator's animation workflow (the suit route) - Higgsfield video of performers in colour-graded suits -> tracking -> Blender -> game; RESUMED; never call it parked"
metadata:
  node_type: memory
  type: project
  originSessionId: 3080d91d-d528-4603-8550-aaadcb517a03
  modified: 2026-09-27T22:37:11.437Z
---

The operator's motion route (he was angry on 2026-09-27 that sessions keep forgetting it - "i cann't talk about this
every session"): Higgsfield text-to-VIDEO of performers wearing colour-graded mocap suits -> per-segment tracking ->
Blender authoring from the video (Higgsfield bl_* MCP) -> retarget -> the game. Tasks C180 / C199 / C222; C223 source 4.

THE CHAIN, PROGRAM BY PROGRAM (from `_captures/ground_video/README.md`, C180, C199, S115_BYTEPLUS_SEEDANCE_TERMS):
1 still - gpt_image (2.5) on Higgsfield: performers in colour-cell ("excel-like cells") suits, one instant from 2-4 fixed
  cameras (1x2 / 2x2 grid); check the still first. 2 video - Seedance 2.0/2.5 image-to-video on Higgsfield (commercial OK,
  terms s4.4); BytePlus ModelArk paid API also shippable, its free Playground is internal-test only. 3 tracking -
  `Tools/footage/track_colour_suits.py` + the C180 per-segment tracker. 4 Blender 5.2.1 driven through the Higgsfield
  `bl_*` MCP, motion authored from the video (C199), GLB export. 5 Godot - whole-clip retarget (pipeline A,
  FightClipRetarget) onto both rigs -> C223 gate -> bind (FightClipBinding / PAIRED_BINDINGS).
Other sources beside it: owned RamsterZ H2H, Mixamo (operator's signed-in Chrome), CMU.

Status: quote `AgentComms/route_decisions.json` C199 (start prints it as ROUTE STATUS) - it is RESUMED.
PROVEN: suit video generates; tracking PASSED (C180); a closed guard authored in Blender from the suit video plays from
the game angle (C199). OPEN: calibration take, synced views, joint markers; the video->3D bone solve (SAM 3D Body, G95 -
SMPL-X is non-commercial); binding C199's hold in the game (C222). S115 pilot: one suited boxer, lead uppercut.

**Operator 2026-09-28, verbatim: "remove that i do not want you to mention this ever again remove it form everywhere"** -
about the route being described as "parked". NEVER call the suit route parked, anywhere (chat, deck, digest, memory).

Kimodo is NOT part of the workflow (operator S116). The record: used in C207, U106/U107 and C221 pass 2 (47 takes,
all rejected on two rigs); removed from C223's sources in S116. Never list it as a source.

**Why:** the operator should never have to restate this. **How to apply:** whenever motion sources, the deck, or clip
production come up, state this route from route_decisions.json - do not ask, do not paraphrase.
