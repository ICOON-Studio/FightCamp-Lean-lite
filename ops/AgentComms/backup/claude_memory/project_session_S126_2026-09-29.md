---
name: project_session_S126_2026-09-29
description: S126 - jab lunge root cause (warp called 2/3 extension contact), fist band measured the recovery, arm push box; boxing 9 -> 14/36; operator working brief (D27, demo 10-06)
metadata:
  type: project
---

S126 (2026-09-29), commits 555a6e1e, 3b6ce1d3, a37bb161.
- **Jab lunge root cause:** the jab's strike_warp span ended at source 0.25 s and that end IS the contact time; the RamsterZ glove
  reaches full extension at ~0.335 s. The room pinned the glove at the head from 0.22 s and the last third of the jab played AFTER
  impact. Fix = span to full extension (+ pre x0.6) + Spine z 5.75 deg lean-back solved by target. On the RamsterZ-retargeted
  skeleton trunk PITCH is local **z** (x ~ twist) - S120's axis probe was on another base.
- **The fist band read the whole-clip peak** - the jab "passed" on its recovery (5.5-6.4 m/s at 0.45 s; strike 4.1-4.6). Now the
  strike up to impact. Only the jab family was affected.
- **Push box:** FightContactSolve.PUSH_SKIN_M 6 cm (arm-vs-arm only) + HEAD_CLEAR_M 3 mm. A per-frame engage RAMP was tried and
  rejected (starved the head pass: 28.9 mm). fight_body_overlap control table in S126_DIGEST.
- Boxing 14/36 under G147. Q217 part 2 read (stills): sent back Q217c; U198 sent back U198c. Both relaunched on a37bb161.
- Operator brief (see [[feedback_working_brief_2026-09-29]]): demo by 10-06, palette = certified moves (D27), rules to one page.
- Operator questions: UE AnimGen (S126_ANIMGEN_EVALUATION.md: not for the demo), Space Bunny (S126_SPACE_BUNNY_NOTE.md: not now).
- The old S125 session was still alive and committed 75fcbba1 during S126 - check `git log` before assuming the tree is yours.
