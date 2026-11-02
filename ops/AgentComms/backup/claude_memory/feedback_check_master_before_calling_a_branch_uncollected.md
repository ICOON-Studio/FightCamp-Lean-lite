---
name: feedback-check-master-before-calling-a-branch-uncollected
description: S199 - a roadmap row said RUNNING for ATTRITION1C but it was merged earlier; I told the operator it was uncollected. git merge-base --is-ancestor first
metadata:
  type: feedback
---
S199: found `codex/attrition1c` on the remote and the roadmap row "RUNNING"; I reported it as finished-but-uncollected and started gating it. It was already merged (13eae49a). Wasted a gate and misreported.

**Why:** roadmap rows go stale; a branch on the remote is not proof it is unmerged.
**How to apply:** `git merge-base --is-ancestor origin/<branch> master` and `git log --grep` for the task id BEFORE telling the operator anything about a branch; fix the stale row. `git apply` is all-or-nothing: check its exit code, not a trailing `echo`. Related: [[feedback_verify_live_state_not_notes]].
