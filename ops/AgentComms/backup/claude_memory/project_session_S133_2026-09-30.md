---
name: project-session-s133-2026-09-30
description: "S133 - 22 ft ring, room facing fixed (engine was right, drawn placement wrong), slip fade, chop root fixes, idle guard, Agents page, GF1 A-D merged, ST1 base merged; 4 agents in flight"
metadata:
  node_type: memory
  type: project
  originSessionId: 276c49a4-5fac-4caa-a07c-bac92ee1c6ce
  modified: 2026-09-30T11:30:26.238Z
---

S133 (2026-09-30, Claude). Digest `research/S133_DIGEST.md`; roadmap `now` = S134 (collect 4 agents -> exe build + walk).

- RING1 done: boxing -> boxing_ring_fl_max 6.7056 m (operator "make it 22ft"); engine half-width 2.443 -> 3.053.
- OR1: the ENGINE faced its foe (p90 2 deg); the ROOM's drawn placement was wrong (pair line p90 94 deg off). Five room
  switches (face_drawn_foe, hold_pair_geometry, reface_in_takes, warp_on_line, contact_push_on_line): facing p90 93 -> 25.
  Tool: `tools/s133_facing_split_probe.gd` (engine / track / placement split, contact-frame glove miss, `off=`).
- The shoulder-line "chest" instrument lies at a punch's contact (the punch rotates the shoulders 50-80 deg) - judge the root.
- The pair orbit (p90 76-88 deg/s) sits inside U123's real hip-yaw p90 114 - not an engine defect.
- Operator saw a fighter fold his head into the other's midsection: a slipped BODY shot played the duck slip -> FadeBack.
- "Choppy": `tools/s133_chop_probe.gd` (hitches/pops, `off=`); fixed the contact_stop ratchet and the take-end lurch
  (contact_push_carry, root_accel_cap): hitches 57 -> 35, pops 164 -> 103. Hands carry the rest -> U203 (Cursor).
- Sounds: operator "keep them for now i need to hear the sounds again"; a labelled board was sent; numbers flag a 0.05 s
  crowd murmur and fixed-length samples. Cascadeur paid (ends 10-27) and unused; Blender builds props only.
- Idle: operator furious agents and Claude sat idle -> `Tools/idle_guard.py` Stop hook + CLAUDE.md NEVER IDLE + memory
  [[feedback-agents-on-board-are-usable]]. Ops board live Agents page http://127.0.0.1:8787/agents (the VS Code
  workspace was useless to him).
- Five never-used connectors turned off (Magicweave, Figma, SurveyMonkey, Bannerbear, Mobbin); context load: MEMORY.md
  17.8 KB and the start printout 15.6 KB are the next trims.
- Merged: U201, Q219, G149, U202, G150 (GF1 A-D), C226 (ST1 base, `in_round_recovery`). NOT merged: Q220 (split_inlet,
  G73 A/B argued not measured).
- In flight at close: Codex C226b, Qwen Q220b, Cursor U203, Grok G151.
