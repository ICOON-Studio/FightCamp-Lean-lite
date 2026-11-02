---
name: feedback-s217-visual-and-heat
description: S217 two mistakes - accepted a hook on arm shape alone (operator "wtf is that"); check_workflow branch on a non-pure branch ran a full editor import -> 88 C
metadata:
  type: feedback
---
1. I "accepted in the lab" ANIMSOURCE1D FIX1 after checking only the punching arm. The operator saw at once: both heads look
   away from each other, wrists twisted on both men, and at 0.233 s the two bodies are INSIDE each other ("wtf is that").
   **Why:** I read the agent's own "observation" text and looked for the one defect I had briefed.
   **How to apply:** on EVERY fight still, check before saying anything: (a) gap between the two bodies, (b) where each nose
   points, (c) each wrist/glove in line with the forearm, (d) feet/stance, then the briefed defect. Never write "accepted" on a
   motion still - say what each of the four shows; the operator closes visuals.
2. `check_workflow.py branch <b> <task> --no-tests` still builds a temp worktree and runs `godot --editor --quit` (full import)
   when the branch is "too broad" -> 88 C RED. Pure PRs: collect by diff + parse + the test (see
   [[feedback_pure_pr_collect_cheaply]]); run the branch gate only for multi-file branches, watchdog first, nothing beside it.
Also: launchers left Codex at Normal priority - check `PriorityClass` after each launch and set the tree to Idle.
