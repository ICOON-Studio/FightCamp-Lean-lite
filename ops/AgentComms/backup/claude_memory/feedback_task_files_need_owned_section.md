---
name: feedback_task_files_need_owned_section
description: "Every TASK_<id>.md must carry an \"## Owned files\" section; the vacuous done-gate was closed 2026-09-08"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 80efeacc-04c5-4a64-9a46-584286d7841e
  modified: 2026-09-08T11:32:06.078Z
---

Every `research/TASK_<id>.md` must carry an `## Owned files` section.
Discovered 2026-09-08: 89 of 166 task files had none, so
`agent_comms.py done --task <id>` printed "nothing to gate" and returned
SUCCESS on more than half the corpus.

**Why:** `done` treated "no owned files" as nothing to check rather than as a
broken task file, and `owned_files()` matched only "``- `path` ``" bullets, so
even a file that DID declare ownership in prose parsed to zero paths.

**How to apply:** still add the section to every new task file - duplication
with the prose is correct, because the gate reads only that section. Verify
with `python Tools/agent_comms.py done --task <id>`: a correct task file whose
files do not exist yet reports GATE FAIL naming them, never "nothing to gate".

**Fixed in R67 (2026-09-08), so do not re-diagnose this:** `done` now REFUSES a
file with no ownership section; `owned_files()` pairs backticks first and reads
prose bullets and sentences, excluding any chunk that names a file to say the
task does NOT own it (deleted / removed / do not touch / never written);
`resolve_owned()` understands a project-relative `tests/foo.gd`. All 166 files
were backfilled from their own parse-gate command, test command, build sections
or shipped deliverables. U1 and J9 carry an operator ruling in the file because
neither was ever built. See [[project_agent_comms_truncation]] for the sibling
failure mode where rc=0 hides a problem.
