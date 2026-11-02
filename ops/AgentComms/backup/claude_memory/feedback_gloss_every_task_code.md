---
name: feedback-gloss-every-task-code
description: "Always gloss task codes (R22, C5, K9, G8...) with a tiny what-and-where on first mention"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 03227b4a-a6df-4a8b-a72a-d70f6f59778a
  modified: 2026-09-05T08:50:07.398Z
---

User rule 2026-09-05: whenever I name a task code — `R22`, `C5`, `K9`, `G8`,
`C4`, `K7` and the like — I must add a very small description of what it is
and where it lands, on first mention in a response. One clause is enough:
"C5 (Codex's read-only TRAINING APIs in `GameState.gd`)".

**Why:** the codes are opaque outside the task files; the user tracks work by
what it touches, not by its id, and re-deriving that costs them a question.

**How to apply:** gloss on first mention per response, not every mention.
Name the agent who owns it and the file or screen it affects. Letters:
`R` = Claude's own build stages, `C` = Codex, `K` = Kalli, `G` = Grok.
Related: [[feedback-be-concise]], [[project-credit-budget-2026-09]].
