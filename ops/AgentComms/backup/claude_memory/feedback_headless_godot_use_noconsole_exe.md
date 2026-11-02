---
name: headless-godot-use-noconsole-exe
description: "Headless Godot runs must use the NON-console exe directly; the _console.exe (even via godot_hidden.ps1) pops a Windows Terminal tab on the operator's other monitor"
metadata:
  node_type: memory
  type: feedback
  originSessionId: c8680409-62b0-495a-8631-8ca66a0536f8
  modified: 2026-10-04T22:43:24.901Z
---

Run headless tests/gates with `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --audio-driver Dummy --headless ...` redirected to a file (output is still captured), and set `GODOT_EXE` to it for `c223_parallel.py`.

**Why:** S162b 2026-10-05 the operator twice saw a "Godot Engine (Console)" Windows Terminal tab pop on his other monitor ("do not open godot on my other monitor"). Cause: the `_console.exe` build gets hosted by Windows Terminal on Win11; `c223_parallel.py` starts it directly and `godot_hidden.ps1` (windowed-window mover) does not hide it either.

**How to apply:** only windowed renders (stills) go through `godot_hidden.ps1`; every headless job uses the non-console exe. Related: [[feedback_pc_limits_80c]], CLAUDE.md s4 "NOTHING OPENS ON THE OPERATOR'S SCREENS".

S166: the tools now ENFORCE it (run_tests/check_scripts/c223_parallel/godot_hidden/godot_desktop map *_console.exe to the GUI sibling, CREATE_NO_WINDOW); S165's popups were godot_desktop's CREATE_NEW_CONSOLE + console exe. Prove any new launcher with Tools/popup_probe.ps1.
