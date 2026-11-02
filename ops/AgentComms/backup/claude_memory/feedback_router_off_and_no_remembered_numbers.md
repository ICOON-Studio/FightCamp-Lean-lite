---
name: feedback-router-off-and-no-remembered-numbers
description: "S216 operator - Jev router + model-router mod disabled, he picks model/effort; never present a remembered figure (Ludo credits) as a measurement"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3467303b-2aab-40d0-b07e-019d836560b4
  modified: 2026-10-13T00:39:51.535Z
---

**1. Model control is the operator's.** S216: he saw Haiku in use and said "disable jev router i told you so i have full control of the model and effort".
Done: scheduled task "FightCamp Jev Router" DISABLED (Disable-ScheduledTask, not deleted) and its node process stopped; `model-router` removed
from `CLAUDE_CODE_PLUGIN_DIRS` in ~/.claude/settings.json (usage-meter stays; backup settings.json.bak_disable_jev_s216). settings.json keeps model=opus, effortLevel=high.
Undo = restore that backup + Enable-ScheduledTask.

**Why:** the desktop session was routed per turn by the in-process `model-router` MOD (a Haiku side-call classifies each prompt), not only by the
127.0.0.1:4000 router, so killing the router alone would not have stopped it; a session that already started keeps the mod until `/router off` or a new session.

**How to apply:** if he asks about models again, check BOTH the router (port 4000, task state) and the mod's own log
(~/.claude/mods/model-router-live/<session>.jsonl, `tier`/`model` per turn). Supersedes the S216 OPUS DEFAULT section of [[reference_jev_router]].

**2. Never present a remembered number as a measurement.** S216: I told him "this round cost about 200 Ludo credits" from an old note (S197) without reading
any charge; he asked "how the hell did you come up with that on your own?". The Ludo header read 805 before and after rounds 48/49, so no cost was ever measured.
**How to apply:** a cost, count or score in a report must come from a tool result this session, or be labelled "from my S197 note, unmeasured", or be left out.
Ludo credits: read the header balance before and after a round and report the difference only if it changed.
