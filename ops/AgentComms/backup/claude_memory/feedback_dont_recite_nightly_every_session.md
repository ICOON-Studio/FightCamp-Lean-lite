---
name: dont-recite-nightly-every-session
description: Operator S159 annoyed at the nightly suite count being restated every session; report it only when it changed
metadata:
  type: feedback
---

Do not restate the nightly suite result (date, HEAD, "N tests, M fails") in the session report when it is unchanged from the last session or already tracked under NIGHTLY1.

**Why:** operator 2026-10-04: "why you keep repeating this every session, you have checked the nightly for the last 5 sessions, whats wrong with you?" CLAUDE.md section 3 says to cite it, but a recited number with no action is noise.

**How to apply:** still read `AgentComms/nightly/latest.txt` at start; compare with the prior session's failing set; mention it only if new reds appeared or a fix landed. See [[feedback_dont_ask_what_the_record_holds]].
