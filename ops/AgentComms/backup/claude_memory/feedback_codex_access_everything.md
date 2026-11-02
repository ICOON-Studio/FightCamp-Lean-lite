---
name: feedback_codex_access_everything
description: "S211 operator \"codex needs always to have access to everything\" - codex_task.cmd prepends the toolkit note, web search + E:\\FightCamp writable on every run"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 880327c3-804e-44a4-8808-e5414fa8547b
  modified: 2026-10-12T11:52:56.354Z
---

Operator S211: "make sure codex has access to all our tools needed to complete the animation correct and fast" then "codex needs always
to have access to everything". Also "dont we already have this research ? and videos ?" when I proposed new guard research for Dola.

Built: `AgentComms/CODEX_TOOLKIT.md` (Cascadeur/Blender/Godot absolute path/ffmpeg/gates/still framing; research K49-K54, G75, D64
guard numbers; REAL reference videos c209 shadowboxing takes with pose landmarks.json, refs/gym4 heavy bag, S116 mocap suits).
`Tools/codex_task.cmd` now always prepends `Tools/codex_header.txt`, sets web_search=live, and adds `--add-dir` main .git + E:\FightCamp.

**Why:** Codex re-derived things we already had and could not search the web (config had web_search disabled); the launcher's
LOCALAPPDATA override makes `%LOCALAPPDATA%\Programs\Godot` wrong inside Codex.

**How to apply:** when a new tool/reference/research appears, add it to CODEX_TOOLKIT.md the same session. Before briefing new research,
run prior_research.py AND look for existing footage (`previews/c209`, `E:/FightCamp/refs`, `_captures`). Related:
[[feedback_codex_launch_needs_codex_repo]], [[feedback_codex_use_sol_not_astra]].
