---
name: project_session_S158_2026-10-04
description: S158 - cloud seats (OpenHands/OpenCode/Goose) live but free Gemini quota killed both Goose runs; GitHub blocks Actions PRs until the repo setting is on; merged #31/#34/#35; D70 over-lunge
metadata:
  type: project
---
- Free Gemini key = too little quota for agent runs (both Goose runs died at once, exit "success"). Goose workflow now fails loudly on quota / no real change and never commits Godot .uid/.import byproducts.
- GitHub default: "GitHub Actions is not permitted to create or approve pull requests" - repo Settings -> Actions -> General must allow it (operator decision pending).
- Git Bash rewrites a leading `/oc` in gh comment bodies to `C:/Program Files/Git/oc`: use MSYS_NO_PATHCONV=1.
- OpenHands opens PRs as DRAFT - `gh pr ready` before merging. Arena sandboxes may lack Godot downloads; ask Arena to commit and hand PC-only runs back.
- D70: real body hook / uppercut hips ~0.10-0.15 m forward; ours 0.5-0.68 m -> Q213I (issue #36) = cap the lunge.
- Actions budget $5/month, stop usage on. Related: [[feedback_cloud_agents_watchable]], [[feedback_opsboard_is_the_roadmap]].
