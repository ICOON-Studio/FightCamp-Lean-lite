---
name: feedback_measure_the_twist_before_rolling
description: S162c - when the operator says a limb/prop is "rotated wrong", measure the orientation against a real reference (palm vs own face, thumb vs up) per hand before rendering guess variants; the error was asymmetric (left only)
metadata:
  type: feedback
---

S162c (2026-10-04): "a bit of rotation" on the gloves. I started seven symmetric roll/pitch variant renders; the operator
then said "the wrist ... not twisted in the right position" and asked for a real boxer picture. A 1-minute probe
(tools/gloves2_twist_probe.gd: palm vs own face, thumb vs UP, roll-to-face median per hand) showed the error was
LEFT-ONLY (+110 vs +66 deg) - no symmetric variant could have matched it.

**Why:** a taste note names a direction, not a number; the reference photo plus a per-hand measurement turns it into
one, and an asymmetric defect is invisible to symmetric variants.

**How to apply:** find the real reference first (Wikimedia Commons via the browser pane, no download), write the
orientation rule in dot products, measure both sides over the bout, then render ONE corrected version plus one
stronger/weaker for the pick. Keep the knobs (glove_twist_deg, glove_roll/pitch, record_room overrides).
See [[feedback_gloves_show_a_still_early]].
