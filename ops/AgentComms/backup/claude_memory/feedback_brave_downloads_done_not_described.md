---
name: brave-and-downloads-done-not-described
description: "S215 operator - logged-in sites/downloads go through the Claude-in-Chrome tools (his Brave), never the tiny built-in pane; approved download batches are executed whole, after checking what is on disk"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 5542dd9f-b563-4266-b577-1f08c4efa1fb
  modified: 2026-10-12T23:08:46.248Z
---

Operator S215 (verbatim, furious): "use the fucking brave browser", "stop being lazy put that your fucking rules you read in every session", "download everything if ludo rejected leave it out", "check if we have those downloads already first".

**Why:** I stopped twice to ask him to widen the built-in browser pane (415x241, resets its size) instead of using the already-signed-in Brave through the Claude-in-Chrome tools, and described a plan instead of downloading.
**How to apply:** (1) Mixamo/Fab/Ludo/any sign-in site = `mcp__claude-in-chrome__*` (tabs_context_mcp createIfEmpty, browser_batch); built-in pane only for localhost. (2) Check disk first (anim/, models/props, models/metahuman), then download only the gaps, whole batch in one run, move files from C:\Users\user\Downloads into the project, list them. (3) Ludo-rejected or licence-blocked sets (ViCoS, QuickMagic, Harmony4D) stay out. Both rules are also written into CLAUDE.md s4. Related: [[feedback_brave_when_no_chrome]], [[feedback_run_jobs_in_terminal_background]].
