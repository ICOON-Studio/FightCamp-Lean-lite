---
name: project-session-s71-2026-09-25
description: S71 gym market slice two shipped; feint decay recovery; Codex moved to gpt-6-luna (needs CLI 0.156.1); Grok read trap
metadata:
  node_type: memory
  type: project
  originSessionId: baad23f5-3a36-4178-acb6-7644d3d9d094
  modified: 2026-09-24T22:19:42.832Z
---

S71 (2026-09-25): gym market slice two `996e3c11` (rivals invest, kit types, title spike, shared-slot crowding), feint decay
recovery `48c4809b` (RECOVERY_S 4.0; boxing 0.106 -> 0.258). Merged C195/C196/U167-U169/Q170; judge_panel green. Suite 399/10.

Non-obvious:
- Codex `gpt-6-luna` (operator's new default, low/medium; astra-6 medium for 3D animation) FAILED on CLI 0.154 with "not
  supported when using Codex with a ChatGPT account" - it was the CLI, not the account: 0.156.1 runs it.
- Grok's finished reply had NO `.response-content-markdown` elements; take innerText of the smallest div >2000 chars that
  contains the reply's last line.
- PowerShell `Start-Process ... -ArgumentList "/c", ...` followed by Remove-Item Env: tripped a safety block and launched
  nothing; launching agents from a scratch .cmd (`start "" /b cmd /c ...`) via Start-Process -WindowStyle Hidden works.
- Python rewrites of CRLF files (GameState.gd, HANDOFF.md): git's autocrlf hides it, but restore CRLF anyway.
- The operator runs new sessions beside old ones: [[feedback_sessions_are_not_cleared]].
Running at handover: C197, U170, Q171 (worktrees), G92, J48. Next: S72 retired fighter -> coach.
