---
name: project-session-s187-2026-10-09
description: S187 playtest walk - 14 UI defects fixed; FLOORGAIN1 found (club floor gains never reach stats); Photos guard paused; Qwen key is pay-as-you-go
metadata:
  node_type: memory
  type: project
  originSessionId: a0a9eaad-8110-44ef-a0e2-5ec7ec4bf491
  modified: 2026-10-09T17:07:02.394Z
---

S187 (2026-10-09): operator "identify possible improvements on the UI (like a proffesional playtester)" + "fix issues as you find them".
List: research/S187_PLAYTEST_UI.md; digest S187_DIGEST.md.

- 14 defects fixed and camera-checked (cash after signing, guide stuck, goals, sparring vs own opponent, flags x14, punch table, week review, runway on hire/sign).
- **FLOORGAIN1 (next):** GameState.file_visit writes athlete.floor_gains and nothing reads it - club training never moves stats. Needs a calibration constant (DayLap ~+5/h raw). A WeekReviewPanel roster fallback was tried and reverted (S183 rule in week_review_test).
- Operator: "its not paint its the other program i use to see pictures" -> AgentComms/allow_viewers.flag pauses no_popups.ps1; never delete it.
- Qwen: his qwencloud.com key works on dashscope-intl (pay-as-you-go), 401 on Token Plan; board question asked. See [[feedback-codex-use-sol-not-astra]] (gpt-6.1-sol refused).
- Lesson: chain test && commit - a `;` committed a red week_review_test (fixed next commit).
