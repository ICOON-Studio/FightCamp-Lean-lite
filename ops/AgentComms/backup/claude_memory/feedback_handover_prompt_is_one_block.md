---
name: feedback-handover-prompt-is-one-block
description: The next-session handover prompt must be ONE copy/paste fenced block with nothing required outside it
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 51b0bfec-ff7c-438e-8b41-6004c99d9f3d
  modified: 2026-09-11T19:07:58.618Z
---

**BLOCK ONLY, 2026-09-26 (operator, asked why S80-S89 added prose): "1, block only".** The handover message is the one-line `git pull && python Tools/agent_comms.py start` block and NOTHING else - no `#` comments inside, no report before/after. In-flight runs go in roster.json notes + roadmap `now`; the report goes in the digest.

**NARROWED 2026-09-13 (operator): "only give me the git command or i can get it from opsboard".** The handover is now JUST the one-line command block; the full handover must therefore live in `AgentComms/roadmap.json` (`now`, `handover`), which `agent_comms.py start` prints and the ops board renders. Do not send a prompt file.

**The session handover prompt is delivered ONE of exactly two ways: a single
copy/paste fenced block, or a file sent with `SendUserFile`. Nothing required
goes outside whichever one is chosen.** (Operator, 2026-09-11: *"it either a
copy/paste block or a download file"*.) Doing both is fine; doing neither is not.

The operator takes it in ONE action and pastes it into a fresh session. A prompt
that is a `bash` fence followed by prose paragraphs cannot be taken in one
action, so half of it gets lost.

**Why:** The operator has asked for this at least ten times across sessions and
it kept not happening, because it was never written into a durable file - it
lived only in chat and died at every `/clear`. Worse, the ONE codified
paste-prompt rule in `CLAUDE.md` (the Codex/Cursor assignment START PROMPT) says
"**Two blocks:** a `bash` fence ... then a blockquote", so in the absence of a
handover rule the wrong template gets generalised and reproduces the defect
exactly. Diagnosed 2026-09-11 after it happened again.

**How to apply:**
- Emit exactly ONE fenced block, and/or write the same text to a file and send it
  with `SendUserFile`. First line is the sync command
  (`git pull && cat NEXT_SESSION_PROMPT.md && ...`); the rest is the session's
  own directives - order of work, settings, the standing drive-every-agent rule,
  anything already decided that must not be re-asked.
- **Self-check before sending: if the operator took ONLY the block (or only the
  file), would the next session have everything?** If no, it is not done.
- Commentary ("two things I found while writing it") is welcome but goes AFTER
  the block, clearly separated, and must never be load-bearing.
- The agent START PROMPT for Codex/Cursor/Qwen is a DIFFERENT artifact and keeps
  its own two-part shape per `CLAUDE.md`. Do not let these two contaminate each
  other. See [[feedback-codex-assignment-prompt]].
- The deep detail lives in `NEXT_SESSION_PROMPT.md`, which the block's first line
  cats. The block carries the directives, not the whole briefing.
