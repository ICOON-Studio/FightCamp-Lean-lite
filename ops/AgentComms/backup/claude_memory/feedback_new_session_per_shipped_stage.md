---
name: feedback-new-session-per-shipped-stage
description: "The moment a stage ships (commit pushed, digest written), end the session and have the user start a fresh one; never carry a shipped stage's history into the next stage or rely on compaction"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 23b1cd65-aaa6-4b73-bef0-bfaf393781cd
  modified: 2026-09-12T23:20:15.237Z
---

**RELAXED 2026-09-26 (operator): "from now you can move past 1 task each session if you think it's safe and efficient".** Each stage still ships whole (digest, roadmap `now`, memory, `agent_comms.py ship`); then re-run `agent_comms.py start` (mints a fresh id) to open the next stage. Continue only if the next `now` is decided, nothing half-collected, context lean. Never use FIGHTCAMP_STAGE_GATE=off to skip shipping.


Start a new session the moment a stage ships. Do not continue into the next stage in the same session, and do not treat compaction as a substitute (user decision 2026-09-04).

**Why:** Every turn re-sends the whole history as cached input. A fresh session carries about a 55k-token baseline (CLAUDE.md, memory, status sync). The 2026-09-04 session that ran several stages back to back reached 409k of history and produced 383M cached-read tokens. This is the sharpest lever in [[project-credit-budget-2026-09]].

**Confirmed 2026-09-13:** after S1e shipped, the operator asked (unsure whether it
belonged in that session) for 25 Unity Asset Store packages to be evaluated before
the next day's sale. Claude declined to do it there, wrote a self-contained brief
(`TASK_R142.md`), made it the roadmap's `now` ahead of S2, and handed over the one
git command; the operator accepted and moved to the next session. A late request in
a shipped session is queued as the next `now` with a full brief, not squeezed in.

**BROKEN 2026-09-21, AND IT IS NOT ONLY A TOKEN COST — THE SUCCESSOR IS ALREADY
RUNNING.** After S38 shipped I emitted the GO and the start block. The operator
cleared, the new session read my handover and did S39 (it solved the 22/23_17
validation — the fixture now reads 0.099 m). Then they sent more work to the OLD
session and I simply did it there: two Dola sends and a `cici.py` fix, pushed to
the **shared checkout while its successor was live**. Nothing collided and every
handover key survived, but that was luck. Worse, when `git log` showed the new
session's commits I wrote them up as "a concurrent session was pushing to this
repo" — an anomaly — when it was the direct, predictable result of my own GO.
The operator: *"you told me to clear you should have expected that."*

So the rule has a second half. **The GO block ENDS the session; after it, assume
a successor is already on this checkout.** Unfamiliar commits appearing after
your own handover are the handover WORKING, never a mystery to flag. And a late
request arriving after the GO is answered the same way the 2026-09-13 precedent
answers it: say plainly that it belongs to the new session and brief it there —
do not quietly keep building in a session that has already shipped and handed
over.

**How to apply:** The stage's final report is the last message of the session: commit hash, push confirmation, the headless test command, and one line saying the stage has shipped and the next stage needs a new session. Do not propose the next stage's options in the shipping session; the next session syncs from CURRENT_STATUS.md and HANDOFF.md and proposes them there, still under the go-ahead gate in [[feedback-claude-lead-developer-role]]. The rule is written in Game/CLAUDE.md under credit rules.
