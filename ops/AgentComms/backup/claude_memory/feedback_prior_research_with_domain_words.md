---
name: feedback_prior_research_with_domain_words
description: "S146 operator \"check existing research first\" - run prior_research.py with the brief's OWN domain words before briefing a bot"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 39afe774-4712-4744-8e8b-48a073909db1
  modified: 2026-10-02T16:56:04.453Z
---

Before sending any research brief, run `python Tools/prior_research.py` with the words of the QUESTION itself
(e.g. "membership dues posted rate"), not just the neighbouring topic. S146: I searched "salary wage stipend", read J5,
then briefed Dola D70 (posted UK gym rates) - G74 and J8 already held UK posted examples and Gymdesk benchmarks, and
J5 G24 / J8 N1 forbid using them as a sport default anyway. Operator stopped it: "check existing research first".

**Why:** duplicate research burns a bot seat and the operator's attention; the record is large and indexed.
**How to apply:** two searches minimum (topic words + the deliverable's words), open the top 3 hits' decision tables,
and write in `## Prior research` what is already settled and the exact gap the brief fills. No gap -> no brief.
Related: [[feedback_check_research_record_first]], [[feedback_dont_ask_what_the_record_holds]].
