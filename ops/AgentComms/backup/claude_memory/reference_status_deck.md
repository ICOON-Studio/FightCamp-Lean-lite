---
name: reference-status-deck
description: The FightCamp status deck (today vs target graphics + all mechanics) at claude.ai/artifact/9FM5bLFacKfKCKNU8J4q1B - operator wants it updated whenever something major happens
metadata:
  type: reference
---

https://claude.ai/artifact/9FM5bLFacKfKCKNU8J4q1B - "FightCamp: Graphics Today vs Finished" (Slides type, made S97
2026-09-27, 17 slides). Today-vs-target per area (gym tiers 1-4, training day, lobby, fight, corner, fighters), rooms
status, graphics gap table, mechanics: built / behind a switch / designed / pending, next stages.

Operator 2026-09-27: *"keep updated this artifact when smth major happens"*. So after a stage that ships something
visible, or moves a mechanic between columns: `read` project/deck.json + the slide files, edit, publish only changed
files; new renders go up as assets (`asset:true`, file_paths). Builder script lived in the S97 scratchpad (deck/build.py),
not in the repo - edit the published slide files instead.

Older design page: "The Training Floor" (claude.ai/artifact/EvCjFQjxSKjyMiRuUaDd5P, 26 Sep) - its build order is
fully shipped; its concept art is reused in the deck. Open a deck in the operator's Chrome with
`%LOCALAPPDATA%\Google\Chrome\Application\chrome.exe <url>` (plain `Start-Process chrome` fails).
