---
name: project-session-s224-2026-10-14
description: S224 - real-time corner approved + engine merged; 5-agent animation audit -> offline-bake direction approved; Grok bots via xAI API; weekly limit 99%
metadata:
  node_type: memory
  type: project
  originSessionId: 38843fd0-0b48-4c09-a2fe-8dc8e3813f16
  modified: 2026-10-14T14:21:40.940Z
---

S224 (2026-10-14), digest research/S224_DIGEST.md.
- Approved on the board: Q-S221-5 real-time corner (CORNERCLOCK1 merged, CORNERLIVE2 cloud Cursor #192), Q-S221-6 kits (KITS1 Qwen #190),
  Q-S221-7 animation direction = offline retarget+bake onto one MH skeleton (route ANIM_OFFLINE_BAKE; order ANIMFIX1..3 -> OFFBAKE1 -> ANIMSTACK1;
  Cascadeur work before 2026-10-27).
- Animation audit: MH models fine; real bugs in our code (blind mirror, Euler pose layers, foot bone-line, double fold, native clips never wired).
  See [[feedback_audit_before_more_fix_rounds]].
- Grok bots now via xAI API (xai-research.yml); Dola needs a restart with CDP when auto-started. See [[reference_how_to_reach_each_agent]].
- In flight at handover: ANIMFIX1 r2 (Codex, exclusive Godot), LUDOCTX1 (Arena), FLOORHUD1 #188, STREET1 #189, KITS1 #190, CORNERLIVE2 #192, GLOBE1 r2.
- Plan limit: weekly all-models 99% at handover (resets 2026-10-15 ~17:00 local); Fable weekly 0% - suggested next session on Fable.
