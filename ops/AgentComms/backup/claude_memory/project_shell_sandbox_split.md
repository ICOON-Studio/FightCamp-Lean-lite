---
name: project-shell-sandbox-split
description: "Claude's SHELL writes outside the repo go to a sandbox overlay only Claude sees; the Write tool writes to the real disk. Test against the user's shell, never your own."
metadata: 
  node_type: memory
  type: project
  originSessionId: dbb0878c-04f8-4381-a15f-a1bdc24b682c
  modified: 2026-09-10T00:35:42.849Z
---

On this machine (BEAST, user `user`), Claude Code's **shell** runs in a
filesystem sandbox. Established 2026-09-10 by comparing `Test-Path` results
between Claude's shell and the operator's PowerShell — same machine, same
user, same absolute path, **opposite answers**.

**The split:**

| How the file was created | Real on disk? |
| --- | --- |
| **Write tool** | **YES** — the operator can see it |
| Shell (`npm install -g`, PowerShell installers, `curl`) **outside the repo** | **NO** — overlay, Claude-only |
| Anything inside the repo, reaching the remote via `git push` | YES — the remote is shared truth |

**Consequences that already bit:**

* `npm install -g @openai/codex` and the Cursor `?win32=true` installer both
  "succeeded" and are invisible to the operator. **Codex is still drivable** —
  it runs inside the sandbox and its repo edits and pushes are real — but the
  operator cannot log into, inspect, or repair either CLI.
* **Any tool needing an interactive login must be installed by the OPERATOR**,
  in their own shell. Claude installing it is wasted work: the browser flow
  can't happen inside a sandbox the operator can't see. This is what blocked
  Cursor.
* The Stop hook script and the memory files are **real**, because they were
  written with the Write tool. See [[project-session-log]].

**How to apply.** When Claude's environment and the operator's disagree, do
not theorise — **ask for one `Test-Path` from their shell.** Three wrong
diagnoses were produced before that was done: Unicode hyphens in a pasted
path, a missing WSL, and a `dangerouslyDisableSandbox` check that ran *inside*
the sandbox it was meant to detect and so confirmed Claude's own view twice.
A single boolean from the other side outranks all of it.

Related: [[project-agent-host-capabilities]],
[[project-qwen-and-grok-reachable-in-app]].
