---
name: project-session-S201
description: S201 2026-10-11 - start-cost cut, real drawer stills, three real gym floors on the game camera, Codex onto the plan quota; overran context on full-size stills
metadata:
  type: project
---
S201: operator asked why every session starts at ~96k. Measured: first request ~91.6k (app tools 37k, MCP 25k, CLAUDE.md+MEMORY 16k,
skills 7k, prompt 7k); projects do not mix. Cut MEMORY.md to 5.5k chars (older lines -> MEMORY_ARCHIVE.md), `start` to 20k chars,
repaired .claude/settings.json (invalid JSON). Handover moved to 330k (operator). The session still overran (474k): every full-size
1920x1080 still opened costs ~1.5-2k tokens - open stills at scale/zoom, fewer re-reads.

Built: REAL drawer stills (Q-S200-1; the S200 tool died on an empty roster, SubViewport camera, HIRE A COACH modal) and three gym
floors in the real game (Q-S200-2: A Claude 0 rule breaks, B Ludo r36 3, C Cursor 5) via `club_layout=<name>`. A floor item's x/z
is its CORNER; the game draws a heavy bag 3 x 3 m around it. OpenAI API auto-recharge off; see [[feedback-use-codex-plan-quota-first]].
Digest: research/S201_DIGEST.md.
