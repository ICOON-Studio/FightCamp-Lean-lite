---
name: project-session-s180-2026-10-08
description: "S180 - the 3D club GymClub3D built + reviewed (25cf9f06, gym4_club OFF), ring + goals HUD merged, Grok 417 = parked pod fixed (Tools/gbot.py); stills sent, waiting his OK"
metadata:
  node_type: memory
  type: project
  originSessionId: acac3735-92b6-4d91-bd72-783ef06904cc
  modified: 2026-10-08T20:51:58.491Z
---

S180 (2026-10-08, Opus, ultracode most of the session; ~730k context - far past the 250k handover, the operator asked
about the spend: the review workflow alone was ~4.7M subagent tokens).

- GymClub3D (Godot/scripts/GymClub3D.gd) extends GymHall3D; GymHall3D reads layout through `_layout()`; a bare static
  call from parent instance code dispatches to the subclass's static (probed). Switch `gym4_club` (career key / user arg),
  panel = GymHallPanel. Stills tool: Godot/tools/gym_club_stills.gd -> docs/previews/gym4_club.
- Walls in the way are CUT to a 0.3 m stub, not ALPHA_HASH-faded (the dither read as snow over the frame).
- The ring/goal pause is `_hold`, never `running` (END DAY reads running to file the visit).
- Review workflow gym4e-review found 37 real defects in code that passed 132 checks - the adversarial pass paid.
- Grok bots: see [[reference-gbot-cli]] - the 417 was a parked pod; always `python Tools/gbot.py`.
- Codex (workspace-write sandbox) cannot launch Godot: give Codex no Godot-test work. Arena stalls compiling Godot.
- Next: the operator's word on the 3 stills -> 30 s video -> switches on -> exe walk. See S180_DIGEST.md.
