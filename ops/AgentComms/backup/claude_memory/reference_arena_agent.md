---
name: reference_arena_agent
description: "Arena (arena.ai Agent Mode) is a free coding seat since 2026-10-03 - browser pane only, own arena/* branch + PR, Claude merges, new chat per task"
metadata:
  node_type: memory
  type: reference
  originSessionId: 06b576c7-f9f3-49b8-afae-d6991f4a9cdf
  modified: 2026-10-03T17:47:21.191Z
---

Arena = arena.ai Agent Mode, added 2026-10-03 (operator ruling, copied from Space Strategy E:\SpaceGame). No official
CLI - never install a third-party "arena" package; drive it in the built-in browser pane (operator signed in with
Google): New Chat -> Agent -> repo selector under the prompt box (Guru-Meditation/FightCamp, master) -> one
self-contained prompt; message box is a contenteditable div, send button "Send message" (first click renders late -
check the message count before clicking again).

Rules live in CLAUDE.md s8 + AgentComms/AGENT_TOOLS.md "Arena": own `arena/<chat-id>-<repo>` branch and PR, Claude
reviews/merges (never Arena's Merge PR), NEW chat per task/review round, everything sent is public, exact acceptance
test, CI (.github/workflows/ci.yml, no LFS) on arena/** + PRs; Arena can't read CI logs and deletes tests to go green -
`Tools/ci_arena.py guard`. `start` prints an ARENA line. See [[reference_agent_notes]].

S179 (2026-10-08): when Arena cannot push (its GitHub connection lost FightCamp at the ICOON-Studio move; board Q-S179-1), copy
its NEW files out of the diff view: side panel Checks->Diff->'View all changes' (renders only on screen), lines live in the
`diffs-container` shadow DOM (`code[data-code] [data-line]`), hand them to `Tools/arena_rx.py` by a top-level navigation (Arena's
CSP blocks fetch/forms). Exact, tabs kept. Full steps: AgentComms/AGENT_TOOLS.md "Arena".

S185 (2026-10-09): Arena pushed to ICOON-Studio/FightCamp again and opened PR #69 itself - try the normal push/PR path first; the S179 diff-copy is the fallback only.

S218 (2026-10-13): Arena in Brave (Claude-in-Chrome) stayed a grey loading skeleton / "lost in training" error; the BUILT-IN pane loads it signed in. Launch fast path: navigate https://arena.ai/agent (repo + master pre-selected), insert the prompt with document.execCommand('insertText') on [contenteditable=true], click the button whose aria-label matches /send/; the chat URL and the arena/<id>-fightcamp branch show seconds later. Short prompt pointing at the TASK file on master works (Arena clones the repo).
