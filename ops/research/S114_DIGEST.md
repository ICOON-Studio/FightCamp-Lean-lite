# S114 DIGEST - damage control; the demo deadline; the queue (2026-09-27)

## Operator rulings this session (verbatim)
- "you are the lead project developer ? you have 7 days to bring the game a playable demo" -> DEADLINE 2026-10-04, printed
  first by `start` with the day-by-day road (`roadmap.json` `deadline`), CLAUDE.md rule.
- "on the session end list me the queued tasks and what everything does and on the new session state those tasks at the start"
  -> `roadmap.json` `queue.tasks`, printed by `start`; stated at both ends of every session (CLAUDE.md rule).
- "do you understand the role of research ? it is not done just for 1 session" / "this is violation of the rules" -> 36
  canonical topic pages + PRIOR-RESEARCH gate. "fix all this and present me a damage control" -> report
  https://claude.ai/artifact/SjcPfWyVTgVaJBCCWZLBgP. "check all history for decisions we made and have been ignored" ->
  `DECISION_LEDGER.md` + `Tools/decision_ledger.py` (346 rulings). "we agreed on a procedure ... who dropped it and why" ->
  the colour-suit route was dropped by Claude in S75 with no decision; DROPPED-ROUTE gate + `AgentComms/route_decisions.json`.
- "do the lighting pass on all rooms next"; "permission to delete anything that is not needed".

## Shipped
- Merged C220 (Codex seated idle) as its diff; D62 applied (physio beside the patient, owner seated), D61 item 2 (one tag per
  spot), staff coaches on bare-hand rigs; LIGHTING PASS on all seven rooms (dark cutaway surround, warm key + cool fill,
  SSAO/SSIL/glow, practicals; interior luma equal or brighter). Rooms + floor subset 8/8.
- Research: `research/topics/` (36 pages, Settled/Open/Engine, citations verified), `Tools/topic_pages.py`,
  `Tools/prior_research.py`; G144 and D62 collected; G145 CANCELLED (duplicate of J20/J33/G141/G143/G138); Q209 rewritten
  to build ON GroundGraph (S57/S58).
- Branches: `Tools/branch_triage.py` classified 64; 60 tagged `retired/*` on the remote; operator ran
  `Tools/retire_branches.ps1` - 8 deleted, 52 remain (re-run owed).
- Retracted: the "554 wasted Higgsfield credits" claim - the Seedance clips are accepted ground references.
- Deleted the leftover YouTube downloads (operator's 09-14 ruling).

## Agents
- Qwen Q208 (back control) SENT BACK: log `back`/`back_end` contract events + census table; U193's blind test saw 0 visits.
- Codex C220 merged; C221 pass 2 (Kimodo) 47/0 accepted, 5.5 credits; pass 3 (suit route) BLOCKED - Blender Higgsfield MCP
  disconnected (operator: Connect). C222 (suit grappling) written, held.
- Cursor U194 landed (blind ground bands, merges with Q209); U195 switch census written.
- Grok G144 collected; G145 cancelled. Dola D62 collected, D63 sent.

## Measured
Clip coverage re-measured: 158/534 own clip (29.6%), 315 family, 14 gap, 47 none. Nightly 2026-09-27 at 40bec39e:
SUITE total=439 fails=24 (Q210). Q208 subset in its worktree: 19 tests, fails=3 (master's two + U193 blind bands).
Cascadeur report: head_to_head 8% (stale, measured 09-25 before later retarget changes); coverage as above.
