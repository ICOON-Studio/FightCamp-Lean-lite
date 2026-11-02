---
name: project-codex-capacity
description: Codex can run Godot and has plenty of credits as of 2026-09-05; assign it real verified work
metadata: 
  node_type: memory
  type: project
  originSessionId: f4b5402b-d56c-4b9b-9400-7b6d70e61fa7
  modified: 2026-09-05T12:45:13.477Z
---

As of 2026-09-05 Codex **can run the Godot 4.7.2 headless tests** and has
plenty of credits. Earlier that same day it could do neither, so C8 (the
SCOUTING read API) shipped unverified — treat any Codex block written before
this date that says "tests are blocked" as history, not a standing state.

**Why:** the size of a Codex task should track its actual capacity. While it
was credit-starved and engineless, tasks were kept small and Claude re-ran
everything; that throttle is gone, so Codex can take larger APIs, run the
full suite itself, and land tasks back-to-back.

**How to apply:** keep asking for the parse gate, the focused test AND the
full suite in every Codex task file, and keep the one real gotcha C8 exposed:
a `--script` test cannot use a bare identifier for a plain script — 
`WorldPopulation` and friends need a `preload`. See
[[feedback-godot-verification-gate]] and [[project-credit-budget-2026-09]].
