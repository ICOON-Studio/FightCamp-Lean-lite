---
name: feedback_animated_meters
description: "S212 operator \"use animated meters\" - every bar/meter in the UI tweens to its new value (no jumps); band change gets a short pulse"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 16349a03-8b54-413e-8847-90d003be8921
  modified: 2026-10-12T18:12:13.095Z
---

Operator 2026-10-12 (S212), verbatim: "use animated meters" (said about the profile header STRESS mini-bar, applies to all meters).

**Why:** a meter that jumps reads as a static spreadsheet; a deep-sim player should SEE a value move when something changes it.

**How to apply:** every bar/meter (stress, wear, morale, composure, stamina, attribute bars, gym capacity) fills with a Tween from the
previous value to the new one (~0.4-0.6 s, ease out) on build/refresh; when the band changes (e.g. STRAINED -> TENSE) a short colour
pulse. Write it into every UI brief; no assets needed (Godot Tween / shader). He asked "do i need to search for free ui assets ?" -
answer was no; he hunts free 3D boxing kit (trunks, wraps, boots, headgear, robe) and boxing gym props instead. Related:
[[feedback_ludo_gate_visual_ui]].
