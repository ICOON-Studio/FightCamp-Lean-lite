---
name: reference_actions_budget
description: S212 - how to read the ICOON-Studio GitHub Actions minutes + $40 budget (hard stop); Oct 2026 numbers; check before any cloud-agent launch
metadata:
  node_type: memory
  type: reference
  originSessionId: 16349a03-8b54-413e-8847-90d003be8921
  modified: 2026-10-12T17:36:45.933Z
---

Operator S212: "you also need to check the github actions and my budget pool". Check it before routing work to the cloud
(cloud-agent.yml cursor/qwen/grok, goose, opencode, CI) and in the stage report.

- Usage this month: `gh api "organizations/ICOON-Studio/settings/billing/usage?year=YYYY&month=M" --jq '[.usageItems[] | select(.product=="actions")]'`
  (group by `.date[0:10]` or `.repositoryName`). Budgets: `gh api organizations/ICOON-Studio/settings/billing/budgets`.
  In Git Bash omit the leading slash (it is rewritten into a C:/Program Files/Git path).
- Pool: 2,000 free Linux min/month, then ~$0.006/min. Actions budget $40/month with prevent_further_usage=true (a hard stop:
  CI and every cloud agent stop when it is hit). Codespaces/packages/LFS budgets $0. The pool is shared with
  `space-strategy` (the operator's other project).
- 2026-10-12 (S212): 4,559 min used (FightCamp 3,948, space-strategy 611), $15.35 net of $40. Peak days 10-10 1,686 min and
  10-11 1,382; S208's CI cut (PR #129) brought 10-12 to ~200 min by evening. CI is ~85% of FightCamp minutes.

Related: [[feedback_cloud_first]], [[project_session_S208_2026-10-12]].
