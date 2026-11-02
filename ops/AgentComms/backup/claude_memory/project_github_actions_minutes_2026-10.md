---
name: project-github-actions-minutes-2026-10
description: FightCamp moved to ICOON-Studio S178 (own minutes). GitHub Actions free minutes (2,000/month, shared by all repos on the account) ran out 2026-10-05; caps applied, space-strategy moved to org ICOON-Studio
metadata:
  type: project
---

2026-10-05 the Guru-Meditation account hit 100% of 2,000 included Actions minutes (resets 11-01). $5 Actions budget with stop-usage = hard stop at the cap. Run records: FightCamp ~1,280 min vs space-strategy ~115 (the billing report credited space-strategy - trust run records).

**Why:** FightCamp CI ran push+PR per Arena commit, two hung runs burned 60 min each, and three agent workflows allowed 330-340 min jobs.
**How to apply:** FightCamp ci.yml pushes on master only (arena/* via PR), timeouts 25/60/60/60/50 min. Do NOT launch Arena/cloud seats before 2026-11-01 beyond the $5 cap - run heavy work locally. space-strategy was transferred (API `repos/.../transfer`) to the free organization `ICOON-Studio` (own 2,000 min); a second PERSONAL account breaks GitHub terms - use orgs. The operator's own session for that project got the re-pointing prompt. See [[feedback-cloud-first]].

S178 (2026-10-08): FightCamp TRANSFERRED to ICOON-Studio too (operator: 'do it move it to the icoon studio org') - own 2,000 minutes; October account usage had reached 3,913 min / net $6.21. Secrets, variables, both self-hosted runners and open PRs moved; origin = https://github.com/ICOON-Studio/FightCamp.git.

S194 (2026-10-10 08:04 UTC): ICOON-Studio's own 2,000 Actions minutes ran out too (October usage 2,000 min, $12.12 gross all discounted). Jobs refused with "recent account payments have failed or your spending limit needs to be increased". The operator's new $15 budget was set on **Codespaces**, not Actions; the Actions budget is $0 with stop-at-limit. Check with `gh api organizations/ICOON-Studio/settings/billing/budgets` (no leading slash in Git Bash).
