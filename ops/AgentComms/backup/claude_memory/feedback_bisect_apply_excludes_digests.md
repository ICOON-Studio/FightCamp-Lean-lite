---
name: feedback-bisect-apply-excludes-digests
description: applying an agent branch diff for a bisect fails silently when its digest is already on master - exclude research/*_DIGEST.md and check the staged file list
metadata:
  node_type: memory
  type: feedback
  originSessionId: 9b3d2f85-758f-4af3-9b48-b756fa89fc89
  modified: 2026-09-27T12:21:57.176Z
---

When bisecting agent branches by `git diff A B | git apply --index`, exclude `':!research/*_DIGEST.md'` (handovers
commit the digests to master first). In S102 the apply failed on the digest, the script carried on, and all three arms
ran as the unmodified base - a whole bisect wasted. Also pin every arm to ONE commit hash, not `master`, since master
moves mid-run.

**Why:** a failed apply looks like a clean arm; the results were identical and meaningless.
**How to apply:** print `git diff --cached --name-only` per arm and stop on APPLY_FAIL. See [[feedback_never_take_whole_files_from_a_branch]].
