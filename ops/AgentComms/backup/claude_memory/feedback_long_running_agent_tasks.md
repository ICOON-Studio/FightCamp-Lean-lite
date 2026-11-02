---
name: feedback_long_running_agent_tasks
description: "agents hold standing long-running work, checked and re-cut every session - not one-shot tasks"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 4135e025-2bca-43d4-b861-d8a27104d6cc
  modified: 2026-09-22T14:46:22.172Z
---

Operator 2026-09-22, verbatim: *"agents need to work 24/7 when they are green on
opsboard give long term tasks and keep checking on them on every new session how
the progress and improve the product or whaever tasks you assign them."*

**Why:** every task had been a one-shot with a gate, delivered once and closed.
That left ~90 board entries reading OPEN that were finished, and every agent idle
between sessions while the operator looked at placeholder art.

**How to apply:** a long-running brief names a STANDING objective with a
priority order, says outright it does not finish in one pass, ends every pass
with an ARTEFACT THE OPERATOR CAN JUDGE (for anything visual a RENDERED FRAME
committed beside the change, never a description of how it looks), and requires
the agent to state WHAT IS STILL WRONG. Claude's session-start duty grows by one
step: after `agent_comms.py start`, LOOK at what each standing agent produced,
re-cut its brief from what actually landed, and relaunch - never restart from the
original wording.

Renders must carry `--position -3000,-3000`; `--write-movie` needs a real
rendering context and otherwise pops a Godot window on the operator's desktop
every pass ([[feedback_render_offscreen]]).

Related: [[feedback_write_it_yourself_when_spec_exceeds_code]],
[[feedback_handover_duties]], [[project_roster_2026-09-21]].
