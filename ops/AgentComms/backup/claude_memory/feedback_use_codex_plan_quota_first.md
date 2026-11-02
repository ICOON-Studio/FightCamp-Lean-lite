---
name: feedback-use-codex-plan-quota-first
description: "S201 - local Codex CLI runs on the operator's ChatGPT plan (weekly quota, wasted if idle); cloud-agent.yml `codex` label bills the OpenAI API key (auto-recharge $11.90)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 67e1eb96-44e3-4303-b656-a30f4fb77df4
  modified: 2026-10-11T13:00:39.051Z
---

S201 (2026-10-11) operator: "codex was at 90% left unused yesterday and today it reseted to 100% , it could have done so much more
work on the animations" - while the same day S197-S200 sent ~10 Codex jobs to GitHub Actions (`cloud-agent.yml`, issue label `codex`),
which bill the CODEX_API_KEY secret (OpenAI API, pay-per-token; auto-recharged $11.90 on 10-11). He asked "are we using this ?".

**Why:** the ChatGPT-plan Codex quota resets weekly and unused quota is lost; the API key is real money on top.

**How to apply:** Codex work goes to the LOCAL Codex CLI first (`Tools/codex_task.cmd`, `~/.codex/auth.json` auth_mode chatgpt;
sol for animation) - keep one local Codex run going all the time, animation (HUMAN2-6) first. Label an issue `codex` (API) only
when the operator agrees to pay for it. Related: [[feedback_codex_use_sol_not_astra]], [[feedback_codex_launch_needs_codex_repo]].
