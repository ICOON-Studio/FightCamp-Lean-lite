---
name: feedback-agy-file-tools-only
description: Antigravity (agy.exe) in headless -p mode auto-denies shell commands; brief it for file read/write tools only
metadata:
  node_type: memory
  type: feedback
  originSessionId: 33e2ef99-8d0e-4ba5-9d6d-8750f9867f2b
  modified: 2026-10-09T03:52:56.129Z
---

agy lives at %LOCALAPPDATA%\agy\bin\agy.exe (roster `antigravity`, free tier). Run `agy.exe -p "<one line pointing at the TASK file>" --mode accept-edits --sandbox --print-timeout 1800s` from an E: worktree
(`git worktree add E:/FightCamp/wt/<NAME> -b agy/<name>`). The first S184 run produced nothing: "a tool required the command permission that headless mode cannot prompt for".

**Why:** the allow-rule route edits agy's own settings, and `--dangerously-skip-permissions` was refused by the classifier (S159); read-only census work needs neither.

**How to apply:** put "use ONLY your file read and write tools, run NO shell commands, no grep" in the prompt. It then wrote a good 14 KB census (S184_TIPS_AUDIT.md). Verify its line numbers before applying;
it counts only buttons built through Button/UIKit.button/_button helpers.

**S213 ALLOW-RULE APPLIED (operator Q-S211-3 "Yes - file read/write only"):** the CLI reads `~/.gemini/antigravity-cli/settings.json`
(NOT ~/.gemini/config/config.json - that file's userSettings.permissions is ignored): `{"permissions":{"allow":["read_file(E:/FightCamp/wt)",
"write_file(E:/FightCamp/wt)"],"deny":[],"ask":[]}}`. Log line `CLI settings initialized: permissions=&{Allow:[...]}` proves it loaded.
No command() rule - shell stays denied. STRESSHDR1 r2 then delivered (missed the animated-meter addendum; Claude added it).
