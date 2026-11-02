---
name: feedback_offer_the_cloud_when_the_pc_limits
description: S158 operator - "why you didnt propose this all this time that we have heat issues": when a PC limit bites, propose moving the work off the PC first
metadata:
  type: feedback
---
Operator 2026-10-04, after learning Qwen/Cursor/Grok/Codex all have cloud routes: "set up all for cloud when it resets, i wonder why you didnt propose this all this time that we have heat issues".

**Why:** from 10-02 the PC ran into heat limits (84 C) and agents were throttled to 3 at idle priority, while Codex Cloud, Cursor cloud agents and GitHub-runner CLIs existed the whole time. Claude treated the limit as a gate to wait behind instead of a problem to remove.
**How to apply:** when a resource limit (heat, CPU, disk, quota) slows the work, the first proposal is the route that removes the constraint (cloud, another provider), with its cost - before throttling or waiting. Now built: `.github/workflows/cloud-agent.yml` (labels qwen/cursor/grok/codex; operator adds the keys). Related: [[feedback_cloud_first]], [[feedback_cloud_agents_watchable]].
