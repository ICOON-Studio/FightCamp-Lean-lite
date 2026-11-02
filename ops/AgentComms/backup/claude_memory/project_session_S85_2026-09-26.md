---
name: project-session-s85-2026-09-26
description: "S85 shipped training floor step 3 (drill mastery pips, breakthroughs, coach bond, bag-chain event, % unit); S86 = gym sparring days"
metadata:
  node_type: memory
  type: project
  originSessionId: 9c177461-ba16-469b-815c-08f9ef5d9235
  modified: 2026-09-26T10:45:53.987Z
---

S85 (2026-09-26) shipped training floor step 3: `DrillMastery.gd` + `FloorEvents.gd` (pure), `GameState._mastered_gain`
as the one gain rule for preview and tick, ring days building the head-coach bond, pips/gold breakthrough/BOND/event card
on the floor, HOME/planner/Monday in % of a point. Q186 (KB finish 28.9%) and Q187 (blind contract 84/0) merged.

**Why:** operator ruled "training floor first, in slices" (S83-S86...). The conversion I chose - one planned
station-day = one focused hour - is a design decision other sessions must keep consistent with G115.

**How to apply:** S86 = gym sparring days (G117 rules, Q188's engine spar option, same-sex default with a
`mixed-sex-sparring` operator ruling raised). Open visual defect: tag crowding round one bag on the tier-1 floor (D30).
Pips are not yet on the profile. U180 edits TrainingFloor3D.gd too - merge by hand. Related: [[project_session_S84_2026-09-26]],
[[feedback_prove_contract_tests_with_mutants]], [[feedback_blind_tests_can_collide]].
