---
name: feedback-engine-first-nonstop-split
description: Operator 2026-09-27 - non-stop work at low PC load; finish the ENGINE asap; Codex = animation, Claude = UI; all research always available to every agent
metadata:
  type: feedback
---
Operator 2026-09-27: "i want non stop work without too much load on the pc, i need the engine to be finished asap then
codex keep working on animation and you on ui". Also: "make sure all research done so far is always available to all
agents".

**Why:** the engine is the bottleneck for everything shown; the PC is shared and cannot take stacked load
([[feedback-two-agents-max-idle-priority]], [[feedback-check-pc-before-heavy-jobs]]).
**How to apply:** Qwen + Cursor hold ENGINE tasks back-to-back (queue the next before one lands); Codex holds
ANIMATION tasks only; Claude builds UI and merges/reviews. Max two shell agents, idle priority, subsets only.
Research: `python Tools/research_sync.py --check` (start prints it, ship refuses) - docs on unmerged branches get pulled
onto master and indexed; never leave a digest on a branch.
