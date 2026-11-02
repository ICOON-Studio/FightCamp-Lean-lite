---
name: feedback_kalli_new_chat
description: "Operator 2026-10-02: 'use a new chat for kalli !!!!!' - every new task to Kalli (and the other Grok bots) goes into a FRESH chat: grokbots.py send --to Kalli --new"
metadata:
  type: feedback
---

Operator, 2026-10-02 (S139), after Claude collected K83 from Kalli's old chat: "use a new chat for kalli !!!!!".

**Why:** the old Kalli chat had grown to ~70k characters of earlier tasks (K47, K72, K83, M-series pastes); Kalli said
"the earlier send didn't deliver" and K83's first answer was lost in it, and image dumps from it fail (tainted canvas).
A long chat costs the bot context and mixes old tasks into new answers.

**How to apply:** send each new bot task with `python Tools/grokbots/grokbots.py send --to Kalli --new --file <TASK>.md`
(`--new` clicks 'New chat' and picks the bot before sending; `newchat --to <bot>` resets without sending). Same for John
and Maria. Collect with `Tools/grokbots/dump_full.py` from that new chat; images that fail to dump are in
%APPDATA%/Grok Bot/attachment-image-cache. Related: [[feedback_chrome_extension_traps]] (one tab per AI conversation).
