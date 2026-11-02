---
name: reference-gbot-cli
description: "Grok bots (Kalli, John Research, Maria Art Director) - ALWAYS via `python Tools/gbot.py` (wakes the parked pod); bare gbot gives 417"
metadata:
  node_type: memory
  type: reference
  originSessionId: 698f888a-d3b1-4e30-a098-36127d223971
  modified: 2026-10-08T19:52:18.879Z
---

grok-bot-cli (`gbot`, npm, 0.12.4 since S180) reads the signed-in Grok Bot desktop app's gateway (DPAPI). Bots: Kalli,
John Research, Maria Art Director.

**Use `python Tools/gbot.py`, never bare gbot** (S180, operator: "fix it once and for all"):
- `python Tools/gbot.py send --to john --file research/TASK_J66.md` / `thread --to john --full --out f.txt` / `wake`.
- Why: the "417 Expectation Failed" of S179-S180 was `x-anyrun-failure-reason: pod_hibernated` (read the RESPONSE HEADERS,
  not the status text). The app parks its cloud pod when its window is unfocused (server gates sand_desktop_away_park /
  present_park). gbot has no wake; its EnsureSandBox fallback sends client version 0.20.0, which the backend refuses.
- `Tools/gbot_wake.mjs` = EnsureSandBox {wake, supportsAsleepBox} with the PC's Cursor CLI login (%APPDATA%\Cursor\auth.json,
  same account, ~31-day token renewed whenever cursor-agent runs) + the app's version from %APPDATA%\Grok Bot\desktop-status.json.
  If it says "too old": the operator updates the Grok Bot app. If "login refused": `cursor-agent login` once.
- `agent_comms.py start` wakes the pod; cloud sessions use pc.yml job=agent args="gbot send --to john --file <TASK>".
- gbot has no new-chat flag: a send lands in the bot's existing thread (grokbots.py `--new` is the UI fallback).
Related: [[feedback_kalli_new_chat]], [[feedback_search_prefab_for_our_own_tools]].

**S217 (2026-10-13): gbot BROKEN by the Grok Bot app 0.70.2 update** - every command returns `render-failed: Unsupported Grok
Bot gateway descriptor version 3` (gbot 0.12.4 = newest on npm only decrypts descriptor v1/v2). Do NOT patch the decryptor
(it is the app's credential store). Until npm ships a newer grok-bot-cli (`npm view grok-bot-cli version`): read/send through
the Grok Bot app with computer-use (request_access "Grok Bot"; chat list left, message box bottom). Bots can WRITE files to the
PC only while the app is open and online on Beast - Maria's M_ICONS54 sat undelivered because the app was offline.
