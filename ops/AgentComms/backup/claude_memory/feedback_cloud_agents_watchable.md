---
name: feedback_cloud_agents_watchable
description: S157 operator - keep a browser-pane tab open per running cloud agent; 8787/agents checks cloud runs live on GitHub
metadata:
  type: feedback
---
Operator 2026-10-03: "always open cloud agents on your sidebar so i can watch who is working" and "update the opsboard/agents make it to check on the agents, distinct who are working on cloud currently".

Cloud seats now: Arena (browser), OpenHands Cloud (browser, signed in, sees ALL his repos), OpenCode (`/oc` comment on an issue, GitHub Actions) and Goose (label `goose`, GitHub Actions, long tasks); models = repo vars OPENCODE_MODEL/GOOSE_MODEL = gemini-flash-latest, key secret GEMINI_API_KEY (his).

**Why:** he wants to see who works on what without asking.
**How to apply:** at every cloud launch open its chat/run in a pane tab, and write `branch` / `gh_run` / `issue` into live_runs.json - /api/cloud (server.py cloud_live) reads GitHub (branch vs master, last commit, PR + CI, Actions run) and gives one verdict per run. Arena sandboxes cannot download Godot or LFS models: give Arena no task that needs a Godot run on real models. Related: [[feedback_opsboard_is_the_roadmap]], [[reference_arena_agent]].
