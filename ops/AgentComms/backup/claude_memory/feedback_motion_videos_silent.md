---
name: feedback-motion-videos-silent
description: A motion-review video goes out SILENT unless audio is the subject - Claude cannot hear and must not ship unheard sound
metadata:
  node_type: memory
  type: feedback
  originSessionId: 276c49a4-5fac-4caa-a07c-bac92ee1c6ce
  modified: 2026-09-30T11:30:30.086Z
---

Operator 2026-09-30 (S133) on a fight recording Claude sent: "the sounds are so bad wtf ... did you approve those sounds
for a AAA title ?" The movie writer records the game's own mix, so the video carried the CC0 fight samples (U175) that
nobody had judged by ear.

**Why:** Claude cannot listen; sending audio implies it was reviewed.

**How to apply:** strip the audio (`ffmpeg -an`) from every motion/animation review video. When sound IS the subject,
send a labelled sound board (samples in order + a timestamp list) and ask for the operator's ear; state plainly that
Claude has not heard it. Related: [[feedback-show-animation-as-video]].
