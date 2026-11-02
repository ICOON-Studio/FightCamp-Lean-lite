---
name: benchmark-real-world-before-design
description: "Check real-world numbers first (gym sizes, equipment) and never give an AI our own current value as its baseline - Ludo anchored on our 20x18 m hall"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 451e99e7-42c9-4de0-8934-f6e12e2d93b8
  modified: 2026-10-10T18:08:04.284Z
---

Operator S195 (2026-10-10, verbatim): "there is established club with so small gym, gyms must be around 465 - 1,860 m2 and even bigger for fitness gym or multipurpose facility, how can ai be so off on that?" then "yes go with those tier sizes".

**Why:** I enlarged the hall 12 -> 18 m by feel, then wrote "current hall 20 x 18 m" into the brief for Ludo; Ludo labelled it "Tier 2 established club, CURRENT STATE" and built its tiers around it. Real facilities are 465-1,860 m2 (small boxing clubs ~150-400 m2). The AI repeated our number; it was not independent knowledge.

**How to apply:** before sizing or tuning any real-world-referenced quantity (hall area, equipment dimensions, fees, wear), state the real-world range first (source or "from general knowledge, unchecked") and give THAT to Ludo; mark our current values as a starting point to be challenged, never as the answer. Ask Ludo to benchmark itself before it designs. Decision D45 holds the tier table. See [[feedback_ludo_not_mobile_deep_manager_sim]], [[reference_ludo_ai]].
