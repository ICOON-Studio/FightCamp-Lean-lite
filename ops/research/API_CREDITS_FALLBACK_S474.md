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
