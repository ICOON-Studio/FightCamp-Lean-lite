---
name: project-session-s103
description: "S103 2026-09-27 - door corridor fix, THE PLANS left, Q205 lever held (leg share), Q206 fence pin + U191 rework running"
metadata:
  node_type: memory
  type: project
  originSessionId: fccb07dc-1af2-41b9-970a-b507c5ca6add
  modified: 2026-09-27T12:59:27.611Z
---

S103 (2026-09-27) shipped: operator's door bug (tier-2 ring in front of wing doors) fixed by a 1.5 m corridor along the
left door wall (`TrainingFloorLayout.DOOR_AISLE_M`, `floor_x0`), not by re-seating stations - small rooms have no seat
for a 4x4 ring off the door wall. Control with corridor 0 reproduced the bug on all 4 tiers. D50 applied: THE PLANS in the
left column when a 3-round card leaves room. Q205's MMA clinch lever NOT merged: it dropped MMA leg share to 9.0% (J20
band 12-18%); carried into Q206 (fence pin, Qwen, running). C217 ragdoll held (live-motion gate fails) -> C218 queued.

**Why:** the next session owns Q206 (Temp/FightCamp-U171) and U191 rework (Temp/FightCamp-U158) in flight.
**How to apply:** collect both on their bars; then Q207 one down / one up from G140. Two traps learned: a control that
shares the constant under test cannot fail (walkway depth was tied to the corridor - split into DOOR_WALKWAY_M), and
`qwen_task.cmd`/`cursor_task.cmd` launch at NORMAL priority - set Idle after launch. Render tools that call RT.begin
directly must pass `limb_damage: true` like the game does, or no corner minute (and no reads) runs.
Related: [[project-session-s102]], [[feedback-control-arm-must-not-share-the-bug]], [[two-agents-max-idle-priority]].
