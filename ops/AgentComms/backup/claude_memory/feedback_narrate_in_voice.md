---
name: feedback-narrate-in-voice
description: "Operator asked for spoken narration (2026-09-25); use Tools/say.ps1 with the Mark voice at milestones while he is at the PC, silent when he sleeps"
metadata:
  node_type: memory
  type: feedback
  originSessionId: d7af0844-cefe-4b8a-9be8-df0e3519863a
  modified: 2026-09-25T22:22:02.336Z
---

The operator asked "can you narrate your output ?" then "i mean in voice", picked the voice **Mark** ("keep mark and continue").
Use `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\say.ps1 -Text "..."` for one short line at each milestone
(Windows OneCore engine, local only - nothing leaves the PC). Keep writing everything in chat too.

**Why:** he follows the work by ear while doing other things; a written-only update makes him come back and read.

**How to apply:** run it in the FOREGROUND shell or as the shell's own background task - a `Start-Process -WindowStyle Hidden`
child played to nobody (S81). `System.Speech` cannot reach Mark; say.ps1 uses Windows.Media.SpeechSynthesis. Turn it OFF
when he says he is going to sleep. Voice/rate preference is remembered in %LOCALAPPDATA%\FightCamp_say_prefs.txt.
Related: [[feedback-be-concise]].
