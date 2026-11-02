---
name: project-session-s160-2026-10-04
description: "S160 - nightly reds were R16 (now switch cut_off_derived in DEMO_SWITCHES); NEAREST merged; READROUND built; operator: gloves abnormal, fix on MetaHumans first"
metadata:
  node_type: memory
  type: project
  originSessionId: 5bfe34df-c5b4-433a-b900-c885d797d5da
  modified: 2026-10-04T13:42:59.456Z
---

- 10-04 nightly: 8 new reds all from R16 (d62f1e7f, unswitched engine change). Fix: switch `cut_off_derived` in FightRealtime.DEMO_SWITCHES (game ON, headless OFF; OFF byte-identical to pre-R16 pins). Lesson: an unswitched engine change re-pinned one test and silently broke 8 others.
- PR #41 NEAREST merged (bb251a3c). READROUND shipped 94c5257f (stamina, punches, ticker, knockdown pips, skip to bell, dev readout hidden).
- Operator on the scorebug video: gloves "obviously abnormal" (bare hand beside a ball-like glove) + "fix the crouch too" + "i hope the fix is done on metahuman models". Glove origin == hand bone (0.0 cm) -> defect is orientation/size/hand cut. Next session: TASK_GLOVES2 on mh_boxer_01..04 first (-- metahuman_bodies=1), then TASK_CROUCH.
- KM3 PR #43 C223 A/B stopped at 85 C RED; rerun later. Arena: GLOVEFIT 01a1071a, NIGHTLY1B, NIGHTLY1C in flight.
See [[feedback_judge_the_whole_frame]], [[project_fighter_bodies_in_game]].
