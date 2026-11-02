---
name: feedback_cloud_first
description: Operator 2026-10-03 "Can you make the agents work on their cloud" - headless agent work goes to cloud (remote Claude subagents, Arena); PC only for windowed renders
metadata:
  type: feedback
---
Operator 2026-10-03: "Can you make the agents work on their cloud". Headless work - code, tests, C223 gates, probes -
goes to cloud workers: ARENA (browser pane) for code/tests/gates, DOLA for research. NOT Agent `isolation: "remote"`:
S156 it silently fell back to local worktrees under .claude/worktrees on C: (8.9 GB, Godot imports and tests on the
PC, the opposite of the request) - I told the operator they were in the cloud without checking the worktree path. The PC keeps only windowed/GPU work (stills, videos) and merging.

**Why:** the PC runs hot (84 C limit) and the operator uses it; local agents and gates compete with him and each other
(the S156 C223 A/B took > 1 h beside two gate runs).

**How to apply:** before launching any agent or heavy headless job, ask "does it need a window?" - no -> cloud. First
cloud run S156: NIGHTLY1B (flip-hang tests). See [[reference_arena_agent]], [[feedback_pc_limits_80c]].
Operator same day: "Check our existing research first , use dola also for cloud work" - Dola (Cici app, `python
Tools/cici/cici.py send --new --file <brief>`) counts as a cloud worker for RESEARCH; run `python Tools/prior_research.py`
first and send Dola only a real gap. Cline (free model) was rate-limited the whole evening of 10-03.
Operator same evening: "use john for research task if you need , and use arena.ai nonstop" - John (Grok bot, `gbot send
--to John --new`, see [[reference_gbot_cli]]) for research too; Arena runs nonstop: when a PR lands, review/merge and
launch the next queued headless task in a NEW chat. S156 had 5 Arena chats live (Q213H, NIGHTLY1B, Q213G-AB, RESET1,
OVERLAP1); prompts in AgentComms/prompts/ARENA_*.md.
