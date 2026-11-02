---
name: project-session-s97
description: S97 2026-09-27 - pit-stop corner behind limb_damage; CornerPanel had applied every instruction to a copy; KB lands ~2 leg kicks a bout so no leg reaches HURT; Q197 judo attempts 24-65x low
metadata:
  node_type: memory
  type: project
  originSessionId: fd62c2ce-02fe-4df4-87c3-dd734d7bc0d2
  modified: 2026-09-27T01:51:15.102Z
---

S97 (2026-09-27) shipped 83d14a63 + Q197 merge 38fa5d17. Digest: research/S97_DIGEST.md.

- Corner minute = Motorsport Manager pit stop: `CornerPitStop.gd` (pure), engine switch `limb_damage` (default OFF,
  own SEED_CORNER stream), `CornerPitStopPanel.gd` on the LIVE fight. Try: `FightCamp.exe -- limb_damage`.
- **The default `CornerPanel` applied every corner instruction to a deep copy - no instruction ever reached a live
  bout.** Its test only checked the returned outcome. Fixed; test now checks the fight. Lesson same as
  [[feedback-assert-the-quantity-the-user-sees]].
- Kickboxing lands ~2 leg strikes per fighter per bout (KB never got U178B's selection) - no leg reaches HURT, so live
  limb damage is inert until U189 (Cursor, running). Face marks rarely pass 1 pip -> cutman acts from pip 1.
- `react_leg` = H2H_StaggerLarge04_LowHit (2.7 s, nearly to the floor) on EVERY landed leg kick - too big; motion lane.
- Render seed 97101 is a round-1 KO (no break); use 97102. Payoff must compare ALL problems, not the 3 shown.
- fight_world_live_test red on master (4 footwork-readout lines, pre-existing since the 09-26 nightly; chip spawned).
- Q197: judo throw attempts 0.17-0.45/bout vs real 11-12 (24-65x low) - next engine slice.
- In flight at end: Cursor U189 (KB leg share), Qwen Q198 (audit kneel/slide instruments: U188 kneel probe flagged
  922/922 knee samples). Sent: Grok G134 (chat eaf86efc), Dola D45 (Cici chat "S97 Corner UI Review").
- S98 = collect those, prove the red leg unstaged, flip limb_damage ON if the census holds. S99 = fight plan as MM setup.

AFTER THE SHIP (same session):
- Operator caught me reporting Codex "paused" and Kalli/John/Maria "blocked" from stale notes - both were available.
  Stale text lived in roster.json AND roadmap.json handover.agents/settings (a second copy `start` prints). Rewritten;
  rules saved: [[feedback-verify-live-state-not-notes]], [[feedback_handover_duties]] (ASK before handover, TWO checks).
- U189 landed (not merged): KB leg share 8.9->15.4% / 11.1->20.0%, but its census reads 0 KO/TKO in 200 bouts vs 37/100
  on s97_limb_census - fixture suspect; re-measure before merge.
- C214 written (Codex: lighter leg-kick reaction), held until the nightly suite ends (operator: don't overload).
- Status deck built: [[reference-status-deck]]. Operator asked why fighters are naked: MPFB generator pilot is an
  unclothed base mesh - dressing them is owed (Codex after C214).
- Operator wants TRAINERS THAT MATTER: trainer-exclusive signature techniques (e.g. off-balancing). G135 sent to Grok
  (chat 11f98dec); roadmap S100.

