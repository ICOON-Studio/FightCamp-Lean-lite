---
name: project_pc_thermal_limit
description: "The operator's PC overheats when heavy CPU loads stack - on 2026-09-13 a game's shader build after a --jobs 4 full suite read 86-87 C on a 7800X3D (limit 89 C); the operator stopped it"
metadata: 
  node_type: memory
  type: project
  originSessionId: f1e1e7cb-927d-4ab0-8e18-a7cf09b90221
  modified: 2026-09-13T18:06:37.924Z
---

**2026-09-13.** The operator reported "cpu temp is critical" while NBA 2K26's first-launch shader build
ran on 12 threads (~15 min a stage), minutes after a full test suite at `--jobs 4`. The game's own overlay
read 86-87 C; the Ryzen 7 7800X3D's limit is 89 C. The game was killed at once and load fell to 5%.

**Why:** the PC is also the operator's desktop and the only machine that runs Godot, the agents and the
games; its cooling does not tolerate two long all-core loads back to back.

**How to apply:**
- Run the full suite at `--jobs 2` whenever anything else is busy; `--jobs 4` only on an idle machine.
- Never start a game, a shader build or a second Godot-heavy job while a suite or an agent's suite runs.
- A game's first launch compiles shaders: press its "Decrease CPU Threads" option (NBA 2K26 offers it) and
  ask the operator before relaunching anything that heated the machine.
- Temperature is not readable here through WMI (no ACPI zone); a game overlay or the operator is the source.

Related: [[project-agent-host-capabilities]], [[feedback_tier_the_test_gate]].
