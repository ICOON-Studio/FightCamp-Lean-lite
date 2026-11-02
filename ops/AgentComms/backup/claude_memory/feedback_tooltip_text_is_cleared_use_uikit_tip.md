---
name: feedback-tooltip-text-is-cleared-use-uikit-tip
description: plain Control.tooltip_text is wiped by UserSettings._suppress_tooltips / TipLayer; attach tips with UIKit.tip(node, text) (meta "tip")
metadata:
  type: feedback
---

S164: a story button's `tooltip_text` read empty a frame after mount because `UserSettings._clear_tooltips_recursive` clears native tooltips and `TipLayer` owns the one tooltip style. StoryCard had the same latent bug (tips never showed).

**Why:** the game has ONE tooltip layer (UIKit.tip -> meta "tip" + group "tipped").
**How to apply:** every new UI uses `UIKit.tip(control, "line")`; tests read `get_meta("tip")`, never `tooltip_text`.
