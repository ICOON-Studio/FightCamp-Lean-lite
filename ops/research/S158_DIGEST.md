# S158 digest - 2026-10-04 (second stage of the S157 session)

## What now works
- **Cloud seats live.** OpenHands Cloud (browser, signed in, sees ALL the operator's repos), OpenCode (`/oc` comment on
  an issue, `.github/workflows/opencode.yml`) and Goose (label `goose`, `.github/workflows/goose.yml`, long tasks with
  RESUME from `goose/issue-<n>`); rules for them in `.github/CLOUD_AGENT.md`. Gemini key = secret GEMINI_API_KEY (his);
  model repo vars OPENCODE_MODEL=google/gemini-2.5-flash, GOOSE_MODEL=gemini-2.5-flash. Actions budget $5/month, stop
  usage ON (operator "do it").
- **Ops board /agents** checks cloud runs live on GitHub (`/api/cloud`: branch vs master, last commit, PR + CI, Actions
  run) and splits cloud from PC agents. One pane tab per running cloud agent (CLAUDE.md s8 rule).
- **Merged:** #31 Q213H (Arena: a combination's travel = its deepest punch's own lunge; no between-part step), #35 TUT1C
  (OpenHands: HANDBOOK button, tutorial_handbook_test 9/0, still checked), #34 Q213G A/B diff tool (Arena; Windows
  print fixed). CI fix: a PR with no changed .gd no longer fails the parse gate.
- **D70 (Dola)**: real body hook / rear uppercut hip travel ~0.10-0.15 m (mocap 109 mm) vs our 0.61-0.68 / 0.48-0.53 m
  lunges -> the combo clipping fix = cap the lunge (Q213I brief on issue #36).

## What failed (and is fixed)
- Both Goose runs (#33 NIGHTLY1C, #36 Q213I) did NO work: the free Gemini quota ran out at once ("Rate limit exceeded");
  the workflow then committed 1,146 Godot import byproducts (.uid/.import) as "leftover changes" and GitHub refused the
  PR ("GitHub Actions is not permitted to create or approve pull requests" - repo setting off). Workflow fixed: never
  commits .uid/.import, fails loudly on no real change / quota. The two junk branches goose/issue-33 and goose/issue-36
  still exist (only byproducts) - delete before re-running (operator OK asked), else resume starts from junk.
- OpenCode run 1: Gemini 503 high demand -> retried on gemini-2.5-flash (running at handover).
- TRAP: Git Bash turns a leading `/oc` in `gh issue comment --body` into `C:/Program Files/Git/oc` - prefix
  `MSYS_NO_PATHCONV=1`.

## In flight at handover
Arena: NIGHTLY1B (01a10320), RESET1 (01a10329), OVERLAP1 (01a1032a), R16 cut-off lead (01a1039f), NEAREST fidelity
(01a103ba). OpenCode: SCHED1 gate badge (#32, run 37155601130). PC: C223 A/B arms (`Tools/c223_parallel.py production
... report=q213g_c223_base.json` then `glove_hand ... q213g_c223_glove.json`, then `Tools/c223_ab_diff.py ... --output
research/Q213G_AB_DIFF.md`) - started 00:39 as a background job of this session; if the session closed it, rerun.

## Open decisions for the operator
1. Turn on Settings -> Actions -> General -> "Allow GitHub Actions to create and approve pull requests" (else Goose /
   OpenCode cannot open PRs; Claude can open them by hand meanwhile).
2. The free Gemini key cannot carry long agent runs (quota). Options: a paid Gemini key (Flash is cheap per token), or
   a free OpenRouter model via his existing OpenRouter key as a second secret.
3. OK to delete the two junk branches goose/issue-33 and goose/issue-36.

## Late S158 (after the first ship)
- Junk branches goose/issue-33/-36 deleted (operator "you do that"); leftover commit now `git add -u` (tracked only).
- GitHub repo setting ON: Actions may create/approve PRs (operator "do it"); default token stays read-only.
- `.github/workflows/cloud-agent.yml`: Qwen / Cursor / Grok / Codex on GitHub runners by issue label; keys are the
  operator's secrets (QWEN_API_KEY, CURSOR_API_KEY, XAI_API_KEY, OPENAI_API_KEY) - none added yet. Codex = out (S154);
  Codex Cloud (chatgpt.com/codex) is the plan-quota route if he brings it back.
- CI skips pushes/PRs touching only AgentComms, *.md, research, docs, the ops board (Oct 1-3 burned 726 of 2,000 min).
- Ops board /agents: USAGE & LIMITS per agent with next reset (`AgentComms/agent_limits.json` + live readers in
  server.py: GitHub billing API, Codex session log rate_limits, OpenRouter key endpoint, OpenHands count). Read today:
  Claude Max 5h 24% / weekly 48% (resets 10-08 14:00 UTC); Codex 90% weekly (10-09); Grok weekly limit reached
  (10-05 13:42 local); Qwen out (10-08); Cursor Pro included 100% but $12 credits left (resets 10-07); OpenRouter free
  tier 50/day.
- Rule: cloud work goes FIRST to seats with their own machines (Arena, OpenHands, Codex Cloud, Cursor cloud agents);
  GitHub-runner seats (Goose, OpenCode, cloud-agent.yml) only when nothing else fits.
- Still open for the operator: Gemini quota for Goose/OpenCode (recommended: one-time $10 OpenRouter top-up + secret
  OPENROUTER_API_KEY); the agent keys as GitHub secrets.
