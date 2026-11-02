---
name: feedback_two_agents_max_idle_priority
description: operator 2026-09-25 - PC at 87% CPU; max TWO shell agents at once, everything at IDLE priority, no new PC
metadata:
  type: feedback
---

Operator 2026-09-25: "the pc is always at 87% cpu capacity ... i want to be able other things too", "do not use too many agents at the same time", "i cant buy new pc".

**Why:** the operator uses the same PC; stacked Godot runs (agents + my tests + Defender scanning) starve it. Related: [[project_pc_thermal_limit]].

**How to apply:** at most TWO of Codex/Cursor/Qwen running at once; queue the rest (holding a task != running it). Browser agents (Grok, Dola, grokbots) don't count. No test run of mine alongside two live agents. run_tests.py and Tools/agent_window.ps1 launch at IDLE priority - keep it. If load is high, set live Godot/agent processes to Idle with PowerShell PriorityClass.
