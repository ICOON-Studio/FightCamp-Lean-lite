---
name: feedback_check_the_worktree_when_an_agent_dies
description: "An agent can die with all its work uncommitted - check its worktree before anything else, parse-gate what it left, commit it as WIP"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a3475d8c-1635-429c-ad7f-025c0811adb7
  modified: 2026-09-20T13:20:19.660Z
---

When an agent stops unexpectedly — a usage limit, a crash, a killed window — **the first action is
to look in its worktree for uncommitted work**, not to relaunch it and not to write it off.

C134 (2026-09-20): Codex hit its 5-hour usage limit mid-edit having committed **nothing** in 189,061
tokens. On disk were the `grappling_mat` arena fix, three new tools, a test, edits to
`FightClipBinding.gd` and `FightWorldLiveScreen.gd`, and a complete written digest. All of it would
have been lost by relaunching into a fresh run.

**How to salvage:**
1. `git status --porcelain` in the worktree, filtered for non-churn (this project's worktrees carry
   ~1,000 `.import` files and ~700 extracted textures that are never anyone's work).
2. **Parse-gate what it left** — it may have died mid-file. `python Godot/tools/check_scripts.py`
   on every touched `.gd`, and re-parse any JSON it edited.
3. Commit to **its own branch** as explicit WIP, with a message that says what is preserved versus
   accepted. Preserving is not endorsing.

**Why:** an agent that is told to commit at the end will, by construction, have committed nothing
when it is cut off in the middle — and long tasks are exactly the ones that get cut off.

**How to apply:** put *"commit after each step; an honest partial beats an uncommitted whole"* in
every long task file, and scope long agent work into stages that each end in a commit. Related:
[[project_c134_bjj_presentation]], [[feedback_collect_before_you_assign]],
[[feedback_cursor_one_task_per_launch]].
