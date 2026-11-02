---
name: project-session-s119-2026-09-28
description: S119 - boxing 5/36 (C223 run 8 merged); Q211 merged (KO+TKO 45%); jab probe divided by 3 rounds on stopped fights; G146 draw anchor is only PROXY; run 9 (strike-phase warp) + Q212 (booked-bout census) in flight
metadata:
  node_type: memory
  type: project
  originSessionId: f0f5f7b8-9749-4af0-9fa1-f2c31dc54fa9
  modified: 2026-09-28T11:38:08.203Z
---

S119 (2026-09-28), digest `research/S119_DIGEST.md`, HEAD a92b5896.

- C223 run 8 merged as a diff (8812a447): boxing 2/36 -> 5/36 (jab_body, one_two, double_jab as SEQUENCE entries).
- Q211 merged (22d71d18): CONTACT_LADDER 0.74->0.60; the census reproduced to the decimal on the merged tree.
- Trap found: `tools/s117_jab_share_probe.gd` divided throws by 3 full rounds. Once stoppages rose, that read 34.4/round
  when the true figure is 50.1 per FOUGHT round. Divide by rounds actually fought whenever fights can end early.
- Boxing draws 11.7% of census bouts. They are NOT 10-10 rounds: boxing scores 10-10 only on an exact float tie. They are
  4-4 splits between EVEN census pairs. G146 (Grok): no sourced pro draw rate exists, PROXY 2-3%. So Q212 measures the
  BOOKED population (get_fight_offers -> book_fight) before anyone touches the judges.
- Run 9 brief: the remaining hooks' V (slow) and T (late) failures are ONE defect, a slow source. The fix is a strike-phase
  time warp (onset->impact only). A whole-clip-warp mutant must still be rejected. See [[feedback-codex-last-paid-run]].
- The nightly on 09-28 at 6d2a4201 had 23 reds (smoke_test included). They weren't re-run because two agents were
  running (no own tests alongside two agents). They are S120's step 0.
- `handover.agents` in roadmap.json was stale since S98; it's now current. It's the second copy [[feedback_handover_duties]] names.

Second half (operator kept the session going, 2026-09-28):
- Operator asked to SEE clips: made tools/s119_showreel.gd (certified moves via play_role) and tools/s119_live_record.gd
  (live room as_game, caption flags uncertified clips, `measure_only` prints pair spacing). Each first cut had a defect
  the operator caught: gloves frozen (CCFighterSkin instance discarded -> no sync), no receiver reaction, camera too
  tight. Lesson: before sending a video, check hands, BOTH fighters and framing - the operator watches everything.
- Operator verdicts: prefers the RamsterZ animation look; fighters too close / clipping; guards all identical; wants
  joint limits, per-part weight, momentum; research must carry across sessions (-> [[project-research-findings-S119]]).
- Slip: a `git apply --index` merge sat staged and rode into an unrelated commit (21878ca9). Run
  `git diff --cached --name-only` before EVERY commit ([[feedback-shared-index-git-add-gotcha]]).
- Ops board: running badge keys on "RUNNING"/"IN PROGRESS" in handover.agents (not "IN FLIGHT"); snapshot cache 60 s;
  lead each agent line with its task id. Stage B real % 58 with a written formula.
- Used Dola (operator: "why dont you use dola?") - idle researchers cost the PC nothing; use them.
