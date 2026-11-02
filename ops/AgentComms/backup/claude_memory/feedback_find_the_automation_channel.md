---
name: feedback_find_the_automation_channel
description: "Operator 2026-09-14: 'no you can do it yourself' - before handing the operator a click-through in a desktop app, find the app's own automation channel (CLI flags in the binary, embedded Python, CDP)"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 839eab8a-0776-4509-9c61-f7630dfbe338
  modified: 2026-09-13T22:14:24.234Z
---

When I told the operator they would have to run my script from Cascadeur's Commands menu, they replied "no you can do
it yourself". Scanning `cascadeur.exe` for strings turned up `run-python-code` beside a single-instance
`QLocalSocket` manager. `cascadeur.exe --run-python-code "..."` executes inside the operator's already-open instance, so
the whole evaluation could be driven from the shell.

**Why:** the operator's job is to decide, not to be an input device (the same principle as
[[feedback_drive_qwen_and_grok_to_delivery]]). A GUI-only assumption turns a scriptable app into a relay chore.

**How to apply, in order:**
1. Look for a documented CLI or headless mode (for example Blender `--background --python`, Unreal
   `-run=pythonscript`).
2. Scan the executable for option strings with a small Python regex over the binary: `--x`, and bare `run-script` or
   `run-python-code` names, since Qt adds the dashes itself.
3. Look for an embedded Python console or API stubs in the install folder (Cascadeur's `resources/scripts/stubs`).
4. For Electron apps, a remote debugging port (the grokbots route).
5. Probe with a script that writes a file, and trust the file rather than the exit code.

**Still the operator's own, whatever the channel:** creating accounts and signing in, accepting licence prompts, and
approving each download (state the file, source and size). They signed in and started the Cascadeur Pro trial
themselves; I drove everything after.

Related: [[reference_pc_animation_tools]].
