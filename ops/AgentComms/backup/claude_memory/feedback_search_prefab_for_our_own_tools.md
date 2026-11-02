---
name: feedback-search-prefab-for-our-own-tools
description: "operator 2026-10-02 \"why you dont use the fckin plugin all this time?\" - a ready CLI for the Grok Bot app existed while we hand-drove the app window for 3 weeks"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 698f888a-d3b1-4e30-a098-36127d223971
  modified: 2026-10-02T20:04:49.239Z
---

Since 2026-09-10 (d860e5ba) Tools/grokbots/grokbots.py drove the Grok Bot desktop app through its debug port (9222). That relay was fragile and kept getting patched. A published CLI, grok-bot-cli (`gbot`, npm), already did send/thread/bots/skills with the app's own session. Nobody searched for it. The operator found it.

**Why:** the CLAUDE.md s10 prefab rule ("check for prefabs before building anything new") was applied to game assets but never to our own tooling.

**How to apply:** before building or patching a relay, scraper or launcher for any app (Grok Bot, Codex, Cursor, Higgsfield, QuickMagic...), search npm/PyPI/GitHub for "<app name> cli" and the vendor's own API. Talk to Kalli/John/Maria through `gbot` ([[reference-gbot-cli]]), not grokbots.py.
