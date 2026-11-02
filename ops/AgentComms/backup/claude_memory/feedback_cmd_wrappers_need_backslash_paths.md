---
name: cmd-wrappers-need-backslash-paths
description: "The Tools/*_task.cmd launchers die silently on forward-slash prompt paths — cmd's `type` reads `/` as a switch; pass Windows backslash paths from Bash"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: df8f76d1-5782-4bc6-912e-acdfd98f65f9
  modified: 2026-09-22T02:01:01.579Z
---

`Tools/codex_task.cmd` and `Tools/qwen_task.cmd` feed the prompt with
`type "%~1" | agent`. Called from the Bash tool with a `C:/Users/...` path, the
`if not exist` guard PASSES (exist tolerates forward slashes) and then `type`
prints "The system cannot find the file specified" and the agent starts with an
empty stdin — Codex says "No prompt provided via stdin", Qwen says "No input
provided via stdin", both exit 0. It cost two launches on 2026-09-22 before the
cause was read off the out file.

**Why:** cmd treats `/x` as a command switch, so `type C:/Users/...` is a
malformed command, not a path. `cursor_task.cmd` uses a `<` redirect, which is a
file open and tolerates either slash — so Cursor launched fine from the same
call and looked like the odd one out.

**How to apply:** build the path in single quotes with backslashes
(`SPW='C:\Users\...\scratchpad'`) and pass `"$SPW\\prompt.txt"`; the workspace
arg the same way. Then READ THE OUT FILE, never the rc — both wrappers exit 0 on
an empty prompt. Related: [[verify-the-launch-not-the-guess]],
[[drive-qwen-and-grok-to-delivery]].
