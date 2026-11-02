---
name: project-session-s151-2026-10-03
description: "S151 - rooms stay 3D (D33), Back + Options restored on every career screen, room markers/hover/titles, floor drawer + live expand, SCENETREE2, Q213D refused, deadline removed"
metadata:
  node_type: memory
  type: project
  originSessionId: 2f2b915e-1078-482c-b214-2b6494c19832
  modified: 2026-10-03T00:42:13.024Z
---

S151 (2026-10-03, Opus). Digest: research/S151_DIGEST.md.

- Operator removed the demo deadline ("chill with the demo remove the deadline") - see [[project_demo_deadline_2026-10-04]].
- D33: the eight 3D gym rooms ARE the product (supersedes the S147 2.5D plan) - see [[project_rooms_25d_decision_2026-10-02]].
- Q213D refused: the clipping gate said 26/26 while an arm sat in a chest - the gate measures capsules, not skin. A
  shoulder-turn fix measured WORSE (contact stop re-solves the arm from the wrist after it) - fix belongs in the arm IK
  (elbow pole, Q213F). See [[feedback_a_gate_that_reads_its_subject_cannot_fail]], [[feedback_open_the_output_before_the_gate]].
- Codex launcher trap: Tools/codex_task.cmd takes the worktree from env CODEX_REPO and the model from CODEX_MODEL; an
  extra argument is silently taken as the OUT file and the run lands in the MAIN checkout on luna. See [[feedback_verify_the_launch_not_the_guess]].
- The permission classifier blocked relaunching an agent after a kill ("Interfere With Workloads") - ask the operator.
- CareerRoot builds the shell ONCE and swaps content; anything route-dependent in the shell must be refreshed after
  show_route (deferred - a push records history after it).
- The R17 ShellChrome silently dropped the old top bar's gear (options) - a rebuild can lose a feature with no test on it.
