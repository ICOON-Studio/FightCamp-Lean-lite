---
name: feedback_quote_rulings_verbatim
description: The record credited the operator with two rulings they never made (motion matching vs motion capture; a RamsterZ AI rule that came from a licence) - store rulings verbatim and name the licence behind any constraint
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 839eab8a-0776-4509-9c61-f7630dfbe338
  modified: 2026-09-13T22:14:14.862Z
---

On 2026-09-14 the operator corrected two entries in the roadmap's "already decided, do not re-ask" list.
- The list said "Motion matching RULED OUT at our scale". The operator, verbatim: "i ruled out motion capturing not
  motion matching".
- The list said "never pass a RamsterZ clip to any generator/AI". The operator: "you can do whatever you want with them
  i didnt put any rule". That constraint came from RamsterZ's DIRECT-sale EULA (R105 addendum 2), which does not even
  govern the Unity-store copy we bought. Only the Unity Asset Store EULA's AI-training clause binds.

**Why:** a paraphrased ruling drifts, and once it sits in a "do not re-ask" list nobody checks it again. Both errors
steered advice that session (motion matching dismissed; a local tool's AI features withheld) until the operator caught
them.

**How to apply:**
- Record every operator ruling as a quote with its date.
- When a constraint comes from a licence or a study, name the licence and its clause, and never attribute it to the
  operator.
- When the operator says a recorded rule is not theirs, fix `AgentComms/roadmap.json` and add a HANDOFF correction
  block in the same turn.
- Before citing a ruling to the operator, check that it is worded as their words.

Related: [[feedback_spell_out_decisions]], [[feedback_check_research_record_first]].
