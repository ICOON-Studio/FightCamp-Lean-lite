---
name: roster-json-rule
description: "AgentComms/roster.json (U30, 2026-09-10) records each agent's in_rotation intent from the ops board; read it at session start and never assign or launch a paused agent"
metadata: 
  node_type: memory
  type: project
  originSessionId: 6bfe5dac-0993-4c52-8a25-9f9c8967fd1d
  modified: 2026-09-10T02:18:06.126Z
---

`AgentComms/roster.json` exists since U30 (`f91449b`, 2026-09-10). Five keys
(`claude`, `qwen`, `grok`, `codex`, `cursor`), each `{"in_rotation": bool,
"note": str, "changed": iso8601}`. The ops board
(`python Tools/opsboard/server.py`, port 8787, LAN URL printed at start)
writes it when the operator flips a switch; the switch records INTENT and
launches nothing.

**Why:** the operator asked for a way to take an agent out of rotation
without relaying anything; a web page cannot launch a CLI, so Claude honours
the file instead.

**How to apply:** `cat AgentComms/roster.json` right after the inbox/board
read at every session start. An agent with `in_rotation: false` gets no task
file, no launch and no start prompt; say so in the report. All five were
`true` when written. See [[project_qwen_and_grok_reachable_in_app]].
