---
name: project-session-s84-2026-09-26
description: S84 shipped the 3D training floor (tiers 1-2) on route training_floor; mitts are not a station; rigs need a 0.925 m lift; D28 % unit; G114 prop sources
metadata:
  node_type: memory
  type: project
  originSessionId: 136719ef-ac4c-436c-9d23-69a7d2f55555
  modified: 2026-09-26T09:35:38.236Z
---

S84 (2026-09-26) shipped training floor step 2: `TrainingFloorLayout.gd` (pure) + `TrainingFloor3D.gd` + `TrainingFloorPanel.gd`, route `training_floor`, HOME fighters pin "The floor". Commits fc750d37, 39ea65f5.

Facts learned that cost a pass:
- `focus_mitts_locker` is an "analysis" item with NO training focus (`set_week_program_day` -> UNKNOWN TRAINING FOCUS). Nobody can be planned on mitts; the coach holds pads for whoever works the RING.
- Fighter rigs + the baked idle / C212 station clips put the hips at the origin: lift the Body 0.925 m or they sink to the knees (C208's number). Station clips need NO extra lift beyond that.
- A direction vector from a raised fighter (ring, y 0.95) to a floor point must be flattened before normalising, or the coach is placed straight down under the canvas.
- In this Bash harness a python heredoc turns `\\n` into a real newline: use raw strings (r'''...''') when a patch contains `\n`.
- `agent_window.ps1` from PowerShell: pass `-ArgumentString "a|b|c"`, not `-Arguments @(...)` (the array does not bind through -File).
- A waiter comparing `%h` (8 chars here) to a 7-char literal fires at once; compare `rev-parse HEAD` to a captured start.

Rulings: a day's gain shows as % of a point ("POWER +5%", D28); catalogue footprints unchanged, `cramped` flag records G113's bigger real zones for the step-4 preset pass; G114: U179's CC0 links mostly do not exist, one $25 pack raised to the operator.
S85 = step 3 (mastery pips, breakthroughs, coach bond, floor events, % unit on HOME/planner). See [[project-session-S83-2026-09-26]].
