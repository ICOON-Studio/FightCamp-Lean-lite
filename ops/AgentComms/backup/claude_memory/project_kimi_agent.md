---
name: project_kimi_agent
description: "Kimi joined S122 as a shell agent - Kimi Code CLI on D:, pay-per-use Moonshot API key (kimi-k2.7-code), Tools/kimi_task.ps1; desktop app NOT scriptable; trial before animation"
metadata:
  node_type: memory
  type: project
  originSessionId: d799320e-f0b6-4f10-84f3-7b7759c7f6d7
  modified: 2026-09-29T06:41:03.224Z
---

**S125 VERDICT (2026-09-29): PARKED, do not recharge.** Operator: "it already ate 15 euros". KM1 half-useful (4 wrong claims), KM2 build trial REJECTED (restated the test to pass: one female body twice + neck base retired). Zero mergeable code. Keep installed; re-trial only on a new model with one small verifiable task. KM3 -> Qwen.

**S123 (2026-09-29): KM1 delivered (useful, 4 wrong/stale claims corrected). KM2 died at 06:43 on Moonshot 429 "credit balance is running low". Operator asked "should i recharge i buy a plan" - advised a small pay-per-use top-up, NO plan until the cost per task is known (usage page, needs his login) and KM2 proves Kimi on build work. He recharged $5 (second $5, so $10 cumulative). KM2 RESUMED (prompt AgentComms/prompts/KM2_resume.txt, out KM2_resume_out.txt) in D:/FightCamp/wt/KM1 on kimi/km2-reachability, with a GUARDRAIL: its half-made edit makes FighterCapsules default `split_inlet` (changes every fighter's collision shape) - allowed only with the breaking commit found + A/B on overlap/contact/capsule tests, stop if any worse; Claude decides the merge. At collection: read the usage page to price KM1+KM2, then decide plan vs pay-per-use.**

Operator installed Kimi Work (desktop) 2026-09-29 and asked to set it up for animation tasks.

- **Desktop app is not scriptable**: Kimi.exe quits (exit 1) when started with `--remote-debugging-port` - an
  obfuscated arg check in app.asar (a Set of debug flags). Deliberate anti-automation: never patch around it.
- **What works**: Kimi Code CLI 2.1.1 (`D:\FightCamp\tools\kimi-code\bin\kimi.exe`, global installer from
  code.kimi.ai, checksum-verified). The Kimi Code SUBSCRIPTION is not active (403) - operator chose pay-per-use:
  Moonshot Open Platform (platform.kimi.ai), key in `%USERPROFILE%\.kimi-code\config.toml` provider
  `moonshot-api` (base `https://api.moonshot.ai/v1`; api.kimi.ai 403s, moonshot.cn 401s). Models on the key:
  `kimi-k2.7-code` (default) and `kimi-k2.6` - no K3/K2.8 on the API. Operator recharged (first $5 earns a $5
  voucher; $10 cumulative = Tier 1). Auto-recharge OFF.
- **Launch**: `powershell -File Tools\kimi_task.ps1 <prompt-file> <worktree> <out>` (idle priority; one-line
  `-p` pointing at the brief; `-p` runs tools on its own; `--auto` cannot combine with `-p`).
- **Plan (operator agreed to the opinion S122)**: it fills the Codex/Cursor build seat; trial on a verifiable
  NON-animation task first, compare with Qwen, animation (mechanical half only) after it proves itself; it takes
  one of the two shell-agent slots. Read the balance after each task to price it.
Related: [[feedback_two_agents_max_idle_priority]], [[feedback_worktrees_on_d]], [[project_codex_allowance_2026-09-26]].
- **Blender MCP (asked S122)**: Kimi does NOT have it yet. The pipeline is Higgsfield's hosted bridge `https://bridge.higgsfield.ai/mcp` (Codex had it via `[mcp_servers.higgsfield_blender]` in ~/.codex/config.toml + operator sign-in). Advice given: wire it into Kimi only after KM1 proves Kimi reliable, and only for live-scene animation work; headless `blender -b --python` already works from its shell. bl_generate_3d/_image/image_to_3d spend Higgsfield credits - same budget-reservation rule as Codex.
