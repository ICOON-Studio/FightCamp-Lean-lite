---
name: project-session-s117-2026-09-28
description: "S117 - career walks end to end (as_game), generated fighters default + dressed, boxing 1/36 (jab), jab share 0->47%, feints refit, Codex run 6 = last paid run; S117_DIGEST.md"
metadata:
  node_type: memory
  type: project
  originSessionId: aa6701b5-93ab-4cad-9a55-98c57bebfca8
  modified: 2026-09-28T02:07:14.997Z
---

S117 (2026-09-28). Digest `research/S117_DIGEST.md` (primary source - read it, not this). Last commit 33f0ab3a.

- Walk: `research/s117_boxer_walk.plan` with `tools/s64_career_walk.gd -- as_game` = the game's own switches + bodies
  (a plain --script run keeps switches OFF and Tripo bodies - it is NOT the game). Reaches RESULT, next week, save.
- Generated fighters (D5) are the game default: FighterTrunks (vertex-colour kit, fighter_skin_kit.gdshader REPLACES
  skin), FighterFist, glove palm frame. I first switched them on from a roadmap note and they were NAKED in the ring -
  always render before flipping a visual default ([[feedback-primary-source-before-action]]).
- "Built, tested, never switched on" is a repeated pattern: C213 generator, U174 boxing_output. Check switch defaults.
- Operator rulings this session: Codex run 6 is the last paid astra run unless boxing clips land (1/36 landed - their
  call) [[feedback-codex-last-paid-run]]; test fights by weight class ("size does not look right"); "dont write anything
  on the roadmap" then "undo it" after I reverted, then at the end "write it on the roadmap for codex" - roadmap `now` = S118
  (a6b57c7e): Codex C223 RUN 7 (brief in TASK_C223 "RUN 7"), Claude ENGINE task. Last commit f3d831ee.
- Next: Codex run 7 = cross, lead/rear hook, lead/rear uppercut on generated legal pairs with the jab's recipe, in-place takes
  first (RamsterZ H2H, then in-place Mixamo; stepping takes slid 21-30 cm), then chains. Claude: feints must not spend a throw
  decision (boxing 32 punches/round vs CompuBox 45-56).
- Of the 36 boxing moves most are chains of ~8-10 base punches + defence parts - count clip work by base punches, not by 36.
