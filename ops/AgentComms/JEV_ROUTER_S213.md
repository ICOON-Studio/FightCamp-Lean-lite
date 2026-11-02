# Jev model routing - what it is and what it needs (S213)

Operator ask (verbatim): "use the decision model called Jev to route the prompts i give to be handled by the appropriate model
(Haiku,sonnet,opus,fable) to avoid token waste."

## What Jev is (sources read S213)
- Jev = TypeSafe's small "decision model": it does not write text, it picks one answer from options with probabilities, ~150-200 ms,
  ~$0.00003 per decision ($0.042 per million input tokens, output free).
- The ready-made tool is `jev-router` (npm `@ediri/jev-router` 1.6.0, github.com/dirien/jev-router): a proxy on 127.0.0.1:4000.
  Claude Code sends each request through it; Jev looks at YOUR message and picks the tier: mechanical -> Haiku, routine -> Sonnet,
  complex -> Opus, deep -> Fable (optional `max` tier). Tool steps and subagents keep their message's tier; background calls go to Haiku.
- It passes Claude Code's own login to Anthropic - no Anthropic API key, your Pro plan still pays the Claude side.
- Prompt cache: within a session it only moves UP a tier (a model switch starts a cold cache); it re-decides after 10 min idle,
  compaction or /clear. Writers on this topic warn per-prompt switching can cost more than it saves; "route sessions, not prompts".

## What it needs from you
1. A Jev key: create one at console.typesafe.ai (or an OpenRouter key with credits). Money is tiny (cents per month at our volume),
   but it is a new paid account - your call, and Claude may not type API keys into anything (you paste it into the setup prompt).
2. Accept the risk: it officially runs as a service on Mac/Linux only. On Windows it runs per launch (`jev-router launch claude`)
   or we keep it alive with a Scheduled Task like the ops board. If `ANTHROPIC_BASE_URL` points at it and it is down, Claude Code
   cannot connect at all - including this desktop app.
3. It is a third-party proxy that sees all Claude Code traffic and your login token on this PC (open source, local only).

## Claude's recommendation
Try it on ONE terminal session first (`npx @ediri/jev-router launch claude`), not machine-wide, for a week, and compare with
`jev-router report` (requests, spend, savings). The desktop Code tab stays as it is until the numbers prove it. Meanwhile the new
usage meter under the prompt shows 5-hour / weekly / session cost so waste is visible.
