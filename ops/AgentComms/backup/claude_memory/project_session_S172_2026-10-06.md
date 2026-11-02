---
name: project-session-s172-2026-10-06
description: "S172 - operator redesigned the core loop (D38): one big 3D gym main screen, the day lap (stamina), coach pool, pit-stop rests, move cards; next sessions run in the cloud"
metadata:
  node_type: memory
  type: project
  originSessionId: d569a702-cd14-459f-be9e-3711a3c8cc1e
  modified: 2026-10-06T16:25:42.119Z
---

S172 (2026-10-06): TRAIN2 merged then superseded; STORY5b fixed (story baseline per fighter); demo design review; watched MMA Manager 2 live with the operator.
The operator then designed the core loop himself - DECISION_LEDGER D38, research/DAYLAP1_DESIGN.md (his words verbatim):
one big 3D gym is the main screen; the day is a LAP, stamina is the managed resource; click a station, fighter walks + prepares + trains;
NO fast-forward while training; coach buffs his station and has a weekly pool; rest = pit stop; moves are cards with a usable threshold.

**Why:** the review showed the camp paid nothing visible and HOME was a painting; he wants the gym itself to be the game.

**How to apply:** judge every training/UI task against D38; GYM3D1 (one-gym layout + build) is first. Next sessions run from the CLOUD -
no windowed stills/videos, no PC watchdog, maybe no browser pane; say so instead of faking it. See [[feedback-reference-game-is-one-mechanism]].
