---
name: feedback_enhance_proposals_aaa_presentation
description: "Never implement a proposal as literally stated - investigate it, compare it to shipping competitors, enhance it, think a step ahead, and hold every surface to a commercial visual bar"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f5109928-16c1-4a7d-810f-e7527c1d2142
  modified: 2026-09-03T21:19:59.892Z
---

User instruction, 2026-09-04: "i want you to always investigate and enhance
my propositions in creative way, compare ideas with what is out in the
market and try to think ahead of me, and make graphics/huds/interfaces/
special effects that will sell, not cheap designs. When i propose to add
something you should try to enhance and think in advance."

**Why:** the user is building FightCamp to compete with shipping products
(Pound for Pound, Elite MMA Manager, MMA Sim King, Cage Empire, WMMA3) and
has said outright "I expect your preview designs to surpass the quality of
those games". A proposal from them is a starting point, not a
specification. Implementing exactly what was asked, in a plain list-and-
button layout, delivers a mechanic but loses the product.

**How to apply:**
- Every proposal gets three passes before any code: what the competitors
  actually do (the teardowns are in `research/REFERENCE_SURVEY_
  2026-09-03.html`), how to make ours better than that, and what the
  player will want NEXT once this ships.
- Bring the enhanced version as the recommendation, with the literal
  version as the fallback option, and say which parts are the ones that
  differentiate. Do not silently widen scope: it still goes through the
  summary-plus-options gate in [[feedback_claude_lead_developer_role]].
- Presentation is part of "done", not a later pass. A new system needs a
  surface with real visual design: gauges, dials, glow and bloom, gauge
  cells, medallions, celebration moments - not a row list with two
  buttons. Copying another screen's colour constants is the floor, not
  the goal.
- Every mechanic should have at least one MOMENT worth a screenshot.
  Crownings, milestones, results reveals and the corner minute are where
  the competitors are weakest and where ours should be strongest.
