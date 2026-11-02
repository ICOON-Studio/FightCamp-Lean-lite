---
name: research-is-the-projects-memory
description: "Operator 2026-09-27: research is cumulative, never per-session; run Tools/prior_research.py before ANY brief or build task; start gates it (PRIOR-RESEARCH DEFECT)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 248418a0-216f-4847-bc58-ebe4dee2b716
  modified: 2026-09-27T18:18:32.221Z
---

Operator 2026-09-27 (S114), verbatim: "do you understand the role of research ? it is not done just for 1 session and forget everything about it. i was counting on you and you let me down , you have wasted so many tokens on all agents including yourself." Also: "i am sure this research has been done at least 3 times already" / "this is violation of the rules".

What happened: I sent G145 (takedown skill gaps) to Grok with no search - J20, J33, G141, G143, G138 already held it. Q209 (ground seats) was written to build a new per-seat machine while GroundGraph.gd (S57/S58, behind `ground_arm`) already existed; G143/G144 were commissioned in S113 the same way.

**Why:** every study is paid for once and must be read every time the topic comes back; re-commissioning burns agent tokens and the operator's trust.
**How to apply:** before writing ANY task file, brief or build plan, run `python Tools/prior_research.py <terms>` (several phrasings), read the top hits, and write `## Prior research` naming them; ask agents only for the residue. When a topic has an existing ENGINE module (grep scripts/ too), the task builds on it. `agent_comms.py start` prints PRIOR-RESEARCH DEFECT for S114+ briefs without real citations. Related: [[check-research-record-before-claiming-unread]], [[feedback_check_prefabs_first]].
