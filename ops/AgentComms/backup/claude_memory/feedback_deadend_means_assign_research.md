---
name: feedback_deadend_means_assign_research
description: "Every dead-end found mid-build becomes an assigned research task, and Claude forecasts the research a stage will need before the gap appears"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 860a3038-c75a-48b6-a7d5-718b7bd661ea
  modified: 2026-09-08T13:19:21.091Z
---

User rule, 2026-09-08: whenever a build turns up a dead-end — a hole a stage
opened, a question the code cannot answer, a system with no object behind it —
**assign a deep research task to resolve it**, do not merely note it. And act as
game director and designer: **predict the research the project will need before
the problem arises**, keeping a forward research queue rather than reacting.

**Why:** R70 removed the fake standing belts from six event disciplines and left
them with no championship object at all, and separately left boxing — the
starter discipline — permanently unsanctioned. Both were named in the report as
observations. The user wanted them assigned, and wanted the next ones seen
coming.

**How to apply:** on finishing any stage, list what the change made impossible
or empty, and write a `research/TASK_<id>.md` for each real one instead of
leaving it in a report. Keep a "predicted research queue" section in
`HANDOFF.md` under Direction notes with the gaps the roadmap implies, so the
next cycle picks from it. See [[feedback_claude_lead_developer_role]] and
[[feedback_gloss_every_task_code]].

Routing, same day: research went to Codex rather than John because **John is
low on credits**, not because his remit changed — he stays in rotation and
research is still all he does. See [[project_john_research_specialist]] and ask
the operator which of the two has capacity before assigning.

**CONFIRMED HARD, 2026-09-21 (U113).** S31's biggest risk was "will our retarget accept a
Cascadeur export?" — a question that would have surfaced three steps into the build and cost a
day. Assigned as a forecast task to Cursor the moment the stage was written, with the three GLB
files exported for it in advance so it had real inputs. **It came back inside ten minutes with a
NO-GO and the repair priced at four named steps**, which turned the stage's opening move from
"animate the pose" into "fix the retarget path first". The lesson is not just *assign* the
research — it is **hand the agent the artefact it needs** so the task is doable in one pass; the
two minutes spent exporting the files is what made the ten-minute answer possible.
