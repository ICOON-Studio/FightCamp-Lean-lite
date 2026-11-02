---
name: feedback_cursor_reads_issue_body
description: "Cloud Cursor (cloud-agent.yml, label cursor) acts on the ISSUE BODY, not on comments - a comment-only rework round gets ignored (S225 GLOBE1 r3, FLOORHUD1 r2)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 30a4cc5e-b22d-4889-b9ce-4f20748dfe7f
  modified: 2026-10-15T14:29:01.005Z
---

S225: two rework rounds posted as issue comments + label re-add produced nothing useful: GLOBE1 r3 = a CI PNG-load tweak (no mapping
fix), FLOORHUD1 r2 = a HANDOFF block only.

**Why:** the cloud-agent workflow hands Cursor the issue body as the task; a comment is at best context it skims.

**How to apply:** for a round N brief, `gh issue edit <n> --body-file <brief.md>` (the brief whole, "this is THE task" on top, the
deliverable named), then `gh issue edit --remove-label cursor`, 3 s, `--add-label cursor`; a run appears in ~30 s. Cursor cannot see
pictures: every gate numeric or a tree probe. Related: [[feedback_cursor_cannot_see_images]], [[reference_how_to_reach_each_agent]].
