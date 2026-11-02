---
name: feedback_guard_and_read_in_different_dirs
description: a launcher that validates a path in one directory and reads it in another fails silently with exit 0
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 309a1b59-f45a-4452-b85f-1037c99a022e
  modified: 2026-09-22T17:08:07.013Z
---

`Tools/qwen_task.cmd` checked `if not exist "%~1"` in the **repo root** — where
the relative prompt path resolves and the guard passes — then ran `cd /d "%~2"`
to the worktree and `type "%~1"` there, where it does not. The agent started on
**empty stdin and exited 0**, which reads exactly like a clean three-minute run.
Q137's first launch was lost to it and nothing in the output said why beyond one
line: "The system cannot find the file specified."

**Why:** a guard only proves the path resolved *at the moment and place the
guard ran*. Any `cd` between the check and the use invalidates it, and the
failure surfaces as success because `type`'s error does not set the script's
exit code.

**How to apply:** resolve every path argument to absolute (`%~f1`, `%%~fO`)
**before** any directory change, and check that a wrapper's guard and its
consumer run in the same working directory. When an agent returns suspiciously
fast with exit 0, **read its transcript for an empty prompt** before believing
the run happened. `codex_task.cmd` avoids this with `-C <repo>` instead of `cd`;
`cursor_task.cmd` has no `type`.

Related: [[feedback_verify_the_launch_not_the_guess]],
[[feedback_cmd_wrappers_need_backslash_paths]],
[[project_agent_comms_truncation]].
