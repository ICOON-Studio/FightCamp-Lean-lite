---
name: feedback-read-the-verbatim-brief-in-the-transcript
description: "when a digest paraphrases an operator brief, grep the earlier session's jsonl for his verbatim words before building"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 7073475d-e3b0-4bc4-a980-a04b9885eaa1
  modified: 2026-10-08T15:37:01.450Z
---

Digests paraphrase operator briefs ("goals, art, strong/weak side, pay"); S177 built "favourite art" as a move until the
S176 test's `"muay_thai"` hinted otherwise. The verbatim brief was in the earlier session's transcript:
`grep -l "<phrase>" ~/.claude/projects/C--Users-user-OneDrive-Documents-ChatGPT-Game-Builds-Windows/*.jsonl`, then print
the text around it. It said "His favorite art can be stored. It does not put a non-boxing move on week one."

**Why:** a paraphrase drops the definitions; building on it wastes a fix cycle and can contradict a ruling.
**How to apply:** before building a feature a prior session's digest names, find the operator's own words in that
session's jsonl (search_session_transcripts finds the session; the jsonl holds the full text). Related:
[[feedback_check_research_record_first]].
