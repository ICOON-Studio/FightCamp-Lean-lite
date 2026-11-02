---
name: feedback-gbot-32k-arg-limit
description: Tools/gbot.py send --file passes the text on the command line - Windows caps it ~32k chars (WinError 206); keep briefs under ~24k
metadata:
  type: feedback
---

S207: sending a 36.7k TASK_M_ICONS brief to Maria failed with `FileNotFoundError: [WinError 206] The filename or extension is too long`.
**Why:** gbot.py hands the file's text to the gbot CLI as an argument; Windows' CreateProcess limit is 32,767 chars.
**How to apply:** keep a gbot brief under ~24k chars (cut long verbatim specs to the part the task needs and say it is cut).
Related: [[reference_gbot_cli]].
