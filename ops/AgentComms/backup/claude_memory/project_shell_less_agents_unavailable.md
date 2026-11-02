---
name: project-shell-less-agents-unavailable
description: Kalli, John, Maria (Grok Bot app) - CURRENT S98 2026-09-27 05:44: OFF on the ops board, weekly limit REACHED (live read), resets ~10-02
metadata:
  type: project
---

**CURRENT (S98, 2026-09-27 05:44, read live in the Grok Bot app): weekly usage limit REACHED, "resets in 5 days"
(~2026-10-02). Kalli, John and Maria are OFF on the ops board - the operator's toggle.** S97 (commit 8d9bd400) had
flipped all three to in_rotation=true on an "operator said the limit reset" note; the first S98 send to John hit the
limit and the operator objected ("do you even check opsboard what is selected"). S98 restored the toggles to OFF.
Written and unsent: TASK_J57 (leg-kick reactions), TASK_K81 (coaches in management games), TASK_M37 (dressing the
generated fighter) in research/. K80/M36 = the S80 hub-display eval, decided in S81 - do NOT re-send.

Rule: the in_rotation toggle is the OPERATOR's. Never flip it from a note; read the board and the app. See
[[feedback-verify-live-state-not-notes]].

Driving them (only when the board has them ON): `Tools/grokbots/grokbots.py launch`, then
`send --to "John Research" --file <task> [--attach ...]` into the bot's EXISTING chat. The reply tail prints the usage
meter ("You're at 90% of your weekly usage limit") - read it before sending.
