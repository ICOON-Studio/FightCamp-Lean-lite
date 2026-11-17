# Console API credits as the fallback (S474, operator: "we mightneed it if you get low on credits,set it up")

What it is: $200 prepaid on platform.claude.com (Console), per-token billing, monthly cap $500, auto-reload OFF (it can
never charge the card by itself). Separate from the Ultra subscription and from the plan's "extra usage".

What the docs say (code.claude.com/docs/en/authentication.md, costs.md, read S474):
- The DESKTOP APP Code tab always bills the subscription (OAuth); it does not read ANTHROPIC_API_KEY or apiKeyHelper.
- The `claude` CLI can bill the Console: `/login` -> "Anthropic Console account" (no key file needed). An ANTHROPIC_API_KEY
  in the environment OVERRIDES the subscription in the CLI - never set it permanently/globally.
- There is no automatic fallback; switching is manual.

THE SWITCH (when the weekly subscription bar is near 100 % and work must go on):
1. Open a terminal tab in E:\FightCamp\Lean and run `claude`.
2. Type `/login`, pick the Anthropic Console account, sign in in the browser (the operator does this; Claude never handles
   the sign-in).
3. Work there as usual (same repo, same CLAUDE.md, same memory folder). The Console dashboard shows the spend.
4. When the subscription resets: in that CLI `/login` again with the claude.ai account (or just go back to the desktop app).

Cost care: before a long run on credits, Claude states the model and a rough cost from the current price page; Sonnet or
Haiku for routine work, the big model only for hard problems.

## S512 (2026-11-17): the $350 bonus - the next session runs on Console credits
Owner: "prepare next session to use the bonus 350$" -> "Console API credits". The subscription week was at 85 % (Fable 75 %)
with the reset on 2026-11-19 14:00 UTC (16:00 his time).

Prices (claude-api skill, cached 2026-11-03; per million tokens, input / output; cache reads):
Fable 5.2 $8 / $40 (reads $0.20) - Opus 5.5 $4 / $20 (reads $0.20) - Sonnet 5.5 $2 / $10 (reads $0.10) - Haiku 5.5 $0.10 / $0.50.
A Claude Code session is mostly cache reads of its own history; output and fresh context are the real cost.
MEASURED (S512, 2026-11-18, from Claude Code's own session logs priced at these rates; cache writes at 1.25x input; the
sub-agents' own logs not included): S512 itself (245 calls, 78M cached tokens read, 0.9M written, 0.16M output, ~470k
context) = $23 on Opus 5.5 / $31 on Fable 5.2 / $12 on Sonnet 5.5; a Fable animation session (75-85 calls) = $14-15.
Most of a session is re-reading its own history (half the bill on a long one): handing over earlier is cheaper.
So $350 is ~12-20 Fable sessions, ~15-30 Opus, ~30+ Sonnet. Check the Console's Usage page after the first one. Sub-agents (Agent tool) bill too: keep them to two, on cheaper
models where the job is reading or searching.

How to start it (the owner does steps 1-2; Claude never handles the sign-in):
1. Desktop app: open the Terminal panel (or Windows Terminal) in E:\FightCamp\Lean and run `claude`.
2. Type `/login`, pick "Anthropic Console account", sign in in the browser with the account that holds the credits.
3. `/model` -> claude-fable-5-2 for the animation rebuild (his "Keep Fable"), or Sonnet 5.5 for main-line collecting/wiring.
4. Paste the handover line: `git pull && python ops/Tools/agent_comms.py start` (the main line) - or for animation, the
   ANIMATION LOOP STATE section of NEXT_SESSION_PROMPT.md.
5. `/cost` in the CLI shows the session's spend; the Console Usage page shows the total. Stop at ~$300 used, or when the
   subscription resets (Thu 16:00 his time) - then back to the desktop app (`/login` with the claude.ai account in the CLI).
Never set ANTHROPIC_API_KEY globally: it would override the subscription everywhere.
