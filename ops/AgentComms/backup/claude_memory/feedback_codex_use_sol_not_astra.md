---
name: feedback-codex-use-sol-not-astra
description: "Codex model rule - S222 SUPERSEDES: gpt-6-astra for Codex hard/animation work (operator S222); older sol rule kept below as history"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 33e2ef99-8d0e-4ba5-9d6d-8750f9867f2b
  modified: 2026-10-09T18:05:53.177Z
---

**S222 (2026-10-14) SUPERSEDES the rest:** operator "use astra 6.1 for codex"; `gpt-6.1-astra` is refused on his ChatGPT account (400 "not supported when using Codex with a ChatGPT account"), he picked **gpt-6-astra** (works). Launch: `$env:CODEX_MODEL='gpt-6-astra'`. codex_task.cmd REM updated.

History - Operator 2026-10-09 (S184), verbatim: "do not use astra model fro codex use sol6.1 instead". The exact id is `gpt-6.1-sol` (seen in ~/.codex cache).

**Why:** his call on model quality/cost; it replaces the 2026-09-25 "astra6 on medium for 3D animation" rule.

**S187 (2026-10-09):** operator re-ruled: "for codex use 6.1 sol for animations or luna for other tasks". A launch with sol first died silently ("not supported when using Codex with a ChatGPT account", 400) because the npm CLI was 0.156.1; `npm install -g @openai/codex@0.162.0` fixed it (sol answers). If a model 400s, update the CLI first (`npm view @openai/codex version`), then ping: `echo "Reply OK" | codex exec -m <model> -s read-only -C <wt> -o out -`.

**How to apply:** animation tasks: `CODEX_MODEL='gpt-6.1-sol'` (Tools/codex_task.cmd reads it); every other task: the default gpt-6-luna (low/medium). Old digests and roster history still say astra - ignore them. Roster and AGENT_TOOLS.md carry the rule.

**S206 (2026-10-11) operator, verbatim:** "how much progress codex is doing so far with the animation i hope it is working non stop until its credits run out (sol 6.1  for animations and astra for super hard animation tasks that sol fails)". So: astra is allowed again, but only to re-run an animation task sol has failed; and Codex must ALWAYS hold an animation task (S206 found it idle - nothing had been queued for it behind Arena's ANIMBUS1). Re-task the seat the moment a run lands.
