---
name: project-session-s165-2026-10-05
description: "S165 - exe rebuilt with STORY3+NAME1, fought bout walked 59/0 in the exe, 3 HOME/inbox defects fixed; operator saw POPUPS twice during my windowed runs - cause unknown, no windowed run until proven silent"
metadata:
  node_type: memory
  type: project
  originSessionId: 5a251d1c-514d-42d1-9553-000dc81fac35
  modified: 2026-10-05T14:00:45.483Z
---

S165 (2026-10-05): EXE-S3 done. Arena NAME1 (PR #49) merged as a diff (9c9f4b36); NIGHTLY1C2 running on Arena chat 01a10c46.
`s165_fight_walk.plan` walks empty gym -> sign -> book -> camp -> fight -> result in the .exe: 59 steps, 0 failures.
Fixed on sight: HOME face de-dup per id, Front desk pin, inbox rail. Walker `until` takes several step labels.

**POPUPS (open)**: operator twice: "please no popups on my other monitor", "i keep seeing popups stop it", while
godot_hidden.ps1 walks (console Godot dev tree; FightCamp_console.exe then FightCamp.exe exe) and build_playable ran.
Two Photos.exe were alive. Not identified.
**How to apply:** next session ask the window title first; no windowed run until the launcher is proven silent
(hidden desktop, non-console exe, --log-file, then the operator confirms). See [[feedback_headless_godot_use_noconsole_exe]].
