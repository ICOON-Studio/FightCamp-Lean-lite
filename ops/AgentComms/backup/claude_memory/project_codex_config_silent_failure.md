---
name: project_codex_config_silent_failure
description: Codex dies at exit 0 on a bad ~/.codex/config.toml value; and Tools\codex_task.cmd needs its FULL path
metadata: 
  node_type: memory
  type: project
  originSessionId: 006a204a-0157-4736-a7cc-0f076dc769f5
  modified: 2026-09-11T00:54:41.137Z
---

Two ways to launch Codex and get **exit code 0 having done nothing**. Both bit on
2026-09-11 and neither prints anything a caller would notice.

**1. An invalid value in `C:\Users\user\.codex\config.toml` kills every run.**
The 2026-09-10 token trim set `web_search = "off"`. That is not a valid variant —
the accepted ones are `disabled` / `cached` / `indexed` / `live` — so every
invocation since printed `Error loading config.toml: unknown variant 'off'` and
**exited 0**. Fixed to `"disabled"`. Any config edit there must be followed by one
throwaway run to confirm Codex still starts.

**2. `& Tools\codex_task.cmd ...` from PowerShell is "not recognized".**
Use the full path: `& "C:\Users\user\OneDrive\Documents\ChatGPT\Game\Tools\codex_task.cmd"`.
This is separate from the known trap that it is `cmd.exe` and POSIX paths make it
print "No prompt provided via stdin" and exit 0.

**Why:** rc=0 is already known to be untrustworthy for Godot tests (R75); it is
untrustworthy for the Codex launcher too, for two different reasons. A
"successful" Codex launch that produced no commit and no mail did not run.

**How to apply:** after launching Codex, check the artifact — a commit, or its
`agent_comms.py` mail — never the exit code. See [[project_codex_capacity]] and
[[feedback_collect_before_you_assign]].
