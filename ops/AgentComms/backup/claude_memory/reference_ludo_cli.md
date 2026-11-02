---
name: reference_ludo_cli
description: Ludo CLI (@ludoai/cli) lets agents call Ludo's generators (3D rig + text-to-animation 0.2 cr) from a terminal; Ask Ludo chat is NOT in it
metadata:
  type: reference
---
S219 (2026-10-13): ludo CLI 0.1.8 + @playwright/mcp live in E:\FightCamp	ools
pm (NOT AppData: the Claude app is an MSIX package and redirects its npm -g installs to its private LocalCache, invisible to the operator's shell). CLI logged in (Pro, key in ~/.config/ludo). Included in the operator's Pro plan (API/MCP/CLI access).
Auth: the OPERATOR runs `ludo login` in his own terminal and clicks Authorize (never paste a key into chat); check with `ludo account`.
- 3D animation: `ludo model animate --model <rigged.glb> --prompt ... --mode rot_only` (0.2 cr/call, 4 candidate anim-only GLBs + mp4);
  `ludo model rig --rig-type humanoid_template_hands --joint-naming unreal` (1 cr); `animate-preset` (0.2 cr). Ludo's doc: "hit-or-miss".
- Budget guard: `max_credits` in .ludo.json / LUDO_MAX_CREDITS, exit 11 = stop. `ludo agent-help` = one-page agent guide.
- NOT in CLI/API/MCP: Ask Ludo (design chat) - that stays Claude via Brave ([[reference_ludo_ai]]).
- Operator S219: "can you ask from codex to communicate directly with ludo for the animation work" -> TASK_LUDOANIM1.md (Codex trial).
Related: [[feedback_ludo_for_animation]].

- CODEX WEB ACCESS (operator S219 "give web acess to codex"): Tools/codex_task.cmd gives every run a Playwright MCP `browser` - headless Brave, profile E:\FightCamp\codex_browser_profile, signed in to Ludo by the operator (probe: lands on Ask Ludo 'Gym Management Screen'). That profile must not be open in a window while Codex runs (close it gracefully: CloseMainWindow). Method in AgentComms/CODEX_TOOLKIT.md 'Ludo'. CODEX_BROWSER=off opts out.
- Saving a long Ask Ludo reply (S219, works): back up the clipboard (Get-Clipboard), click the reply's own 'Copy response' button (last one, real click), Get-Clipboard -> file, restore. JS text returns are truncated/blocked; Image/fetch to 127.0.0.1 is blocked by CSP.
