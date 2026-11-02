---
name: feedback-no-placeholder-screens-ask-ludo
description: "S202 operator - a screen built from a text spec looked \"like games from the 80s\"; never ship programmer layouts, get Ludo's real visual design (mockup + pixel spec) first"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 87c8bc0e-efba-4d6e-b034-b2c6514ae590
  modified: 2026-10-11T14:35:47.527Z
---

Operator S202 (verbatim, on the fighter drawer built from Ludo r32's TEXT readout): "if this is the main player profile it
reminds some games from 80s . i hope this is just a place holder. do not use placeholders use the real designs , if you do
not have one ask ludo to deliver it".

**Why:** a Ludo text design (fields + layout words) built by Claude came out as a spreadsheet; the approved r32 design had a
portrait, tabs, body diagram, comparisons - Claude built only a fraction, so it read as a placeholder.

**How to apply:** before building any player-facing screen, have Ludo deliver the VISUAL design: one ask for the mockup
image (it returns image only), a second TEXT-ONLY ask for the pixel build spec (x/y/w/h, tokens, type styles, every meter).
Build the whole approved design, not a subset; data the game lacks is hidden, never faked. Round 37
(LUDO_ROUND37_VERDICT_S202.md) is the model. Saving long replies: built-in pane + navigate to 127.0.0.1:8799 receiver;
send with select-end + Enter (JS click failed). Related: [[feedback_ludo_is_lead_designer]], [[feedback_ludo_huge_questions]].
