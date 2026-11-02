# Agent seats S217 - Goose, cloud Qwen, Grok bots (operator: "use goose and qwen too on cloud ... grokbots ... more tasks not only research")

## What I checked (primary sources)
- Goose (`.github/workflows/goose.yml`): runs 38246186457 and 38248039038 (10-12) FAILED. Log line: "Please check your account
  with your provider to add more credits" - the GEMINI_API_KEY (Google AI Studio) has no credits. Goose did no work.
- Cloud Qwen (`cloud-agent.yml`, label `qwen`, secret QWEN_API_KEY): WORKS - issues #137 #126 #124 #121 #119 ran green 10-11/10-12.
  I use it this session.
- Grok in GitHub (`cloud-agent.yml` label `grok`): needs secret XAI_API_KEY (console.x.ai, pay per token). NOT set -> cannot run.
- Grok bots (Kalli / John / Maria, Grok Bot app): John ran my probe on their box (10-13): persistent Linux VM, 8 cores, 15 GB RAM,
  113 GB free, git 2.47, Python 3.13, node, curl, internet, long background jobs OK, files persist. MISSING: a GitHub token.

## Recommendation (Claude)
1. GROK BOTS CODE: give their box a GitHub token. They then clone FightCamp, work on a `grok/<task>` branch, run tests and open a PR,
   exactly like Arena. This uses the Grok Bot plan you already have, with no per-token bill, so it is cheaper than the XAI_API_KEY
   route. I add a shared "FightCamp coding seat" skill (clone, branch, Godot headless on Linux, parse gate, push, PR) and a
   4th bot "Grok Dev" for code, so Kalli stays design, John research and Maria art.
   YOUR STEP (Claude may not touch credentials):
   a. github.com -> Settings -> Developer settings -> Fine-grained tokens -> Generate.
      Resource owner ICOON-Studio; Repository access: Only FightCamp; Permissions: Contents Read/Write, Pull requests Read/Write,
      Metadata Read. Expiry 90 days.
   b. In the Grok Bot app, open any bot chat, use the masked secret form, name it GH_TOKEN, paste it.
   c. Answer "Done" on the board. I test it with one small task.
2. GOOSE: Gemini credits are a money call. Options: add credits to the Google AI Studio key (Goose as before, gemini-flash), or
   I point Goose at the Qwen pay-as-you-go key that is already a secret (QWEN_PAYG_API_KEY, billed per token), or park Goose.
   Cloud Qwen and Arena already cover the pure-module work, so parking costs little.
