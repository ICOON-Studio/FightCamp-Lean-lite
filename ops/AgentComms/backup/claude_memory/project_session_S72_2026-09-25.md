---
name: project-session-s72-2026-09-25
description: "S72 retiree->coach shipped; lanes re-split (Codex/Cursor on standing motion); ground camera decided; Codex 150-credit grant; suit route's unbuilt 3D solve (C199)"
metadata:
  node_type: memory
  type: project
  originSessionId: 0aecafce-54cc-4dc8-94e4-3d1b7a25653f
  modified: 2026-09-24T23:17:54.622Z
---

S72 (2026-09-25): retiree -> coach `679f7e74` (RetireeCoach.gd pure; J48 odds, G91 sheet from knowledge, fame_pull,
wage or 10%/5% capped cut). Collected U170 (reverted its production weigh-in hack - the weight_cut fixture now books a
legal boxing open slot), C197 52/0, G92 (Q168's tool printed per-BOUT attempts as per fighter-fight: 1.65 = 0.83, in
band). Suite 402/9, S71's ten minus weight_cut. Handover to S73 gym heat + a gate that reads hype.

Operator rulings this session (verbatim where it matters):
- LANES are standing: agents = engine + motion, Claude = management + GUI ("i thought we agreed on spliting the agents
  by keeping some on constand 3d animation work ? why you use codex for research ?"). Codex C198 standing motion,
  Cursor U171 standing holds, Codex C199 suit clips -> 3D. See [[project-watch-loop-2026-09-24]].
- CODEX CREDITS: "i want codex to be able to spend credits , limit codex to 150 credits without asking" - enforced in
  Tools/higgsfield/budget.py (GRANT S72-codex-150). Only the operator raises it.
- GROUND CAMERA: stay full 3D; one fixed high broadcast angle (~60-70 deg) on the ground (U171 pass 2, `ground_camera`).
- No deadline: never say "more time than we have".
- The suit route's multi-view 3D solve was never shown to the operator as unbuilt before spend - see
  [[feedback_show_the_full_chain_before_spend]].

Non-obvious facts:
- Codex web search: ~/.codex/config.toml has `web_search = "disabled"`; `CODEX_WEB=live` in Tools/codex_task.cmd turns
  it on per run ("live"/"cached" valid). Qwen has URL fetch but no search provider. Cursor and the grok bots search.
- Codex reaches Higgsfield through Blender 5.2.1 background Python + the add-on's wheels (C182's method), not plain Python.
- `codex queue --thread <uuid> --message` reached both running exec sessions; the larger rollout file per task is the main thread.
- Bash printf turns `\u171` in a Windows path into a unicode escape - write .cmd launchers with PowerShell/Write.
- Python rewrites of HANDOFF.md: the repo blob is LF; writing the CRLF working copy back committed 7k lines of churn - write LF.
- LIVE BLENDER CONNECTED (late S72): Codex MCP `higgsfield_blender` = https://bridge.higgsfield.ai/mcp (OAuth, operator
  signed in); needs Blender 5.2.1 open with the Higgsfield plugin ENABLED (it was installed but off) and its MCP tab
  started (bridge on 127.0.0.1:9876). Verified: Codex created FC_BRIDGE_TEST at (0,0,2). 18 bl_* tools. Its
  bl_generate_3d / bl_generate_image / bl_image_to_3d bypass Tools/higgsfield/budget.py - task files require a
  task_reserve before each call. Claude itself needs a Claude-app custom connector to the same URL (not done).
- The Claude app is MSIX-sandboxed: MY %APPDATA% (npm\codex.cmd) is virtualized and the operator's PowerShell cannot
  see it. Operator-facing codex = `& (Get-ChildItem "$env:LOCALAPPDATA\OpenAI\Codex\bin" -Recurse -Filter codex.exe | Select-Object -First 1).FullName` - that one WORKED for them.
