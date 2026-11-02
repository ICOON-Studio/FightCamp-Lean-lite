---
name: project_roster_2026-09-21
description: "SUPERSEDED 2026-09-22 - ops board is the roster authority, ALL NINE usable; its idle-agent reversal is itself re-reversed, every agent holds a task at handover"
metadata: 
  node_type: memory
  type: project
  originSessionId: 50b85198-25e9-4e6d-968f-a6a49b10cbf7
  modified: 2026-09-21T20:28:25.350Z
---

**SUPERSEDED 2026-09-22 — READ THIS FIRST.** The operator, twice in one
session: *"its green on opsboard what else you need?"* and **"you can use them
until i remove them from opsboard"**. So:

- **The OPS BOARD is the roster authority.** Not CLAUDE.md, and NOT
  `roster.json`'s `in_rotation` flag — that flag reads `false` for Qwen, Kalli,
  John and Maria and they are still usable. **A toggle is not a removal.**
- **ALL NINE are available**: Claude, Codex, Cursor, Dola, Grok, Qwen, Kalli,
  John, Maria.
- I burned two turns weighing a stale CLAUDE.md line against the board. That
  paragraph is now rewritten to say the board wins; do not re-litigate it.
- **What still binds is "manufactured work is the failure"** — a full board is
  not a quota. The operator's own answer to the gap: *"whoever doesnt have a
  task assign him to evaluate the project progress and give you suggestions or
  corrections"*. **That is the default assignment for an agent with no real
  technical slice**, and it produced the best output of the session (see
  [[project_engine_first_challenged]]). Point each reviewer at a DIFFERENT
  angle or four reviewers return one report.

---

Operator ruling 2026-09-21. **This supersedes the roster parts of
[[project_cursor_preferred_build_agent]], [[project_qwen_build_agent]],
[[project_mailbox_scoped_to_readers]], [[project_maria_art_director]] and
[[project_john_research_specialist]].** Recorded in `AgentComms/roster.json`
and `CLAUDE.md`.

**IN: Claude, Codex, Cursor, Dola, Grok. PARKED: Qwen, Kalli, John, Maria.**

**RE-REVERSED 2026-09-22 by [[feedback_handover_duties]]: EVERY AGENT MUST
HOLD A TASK AT HANDOVER.** The paragraph below stood for one day. Its quality
bar still applies - a real slice, not manufactured spec - but "leave it idle"
no longer does.

**THE 2026-09-09 "IDLE AGENTS ARE A STANDING FAILURE" RULE IS REVERSED** — it
turned a full roster into a quota to fill. On 2026-09-21 it produced Q126: 130
lines of task file to get back a 60-line digest that ran an existing tool nine
times and formatted the output. Judge a delegation on the spec-to-delivery ratio
and on whether an UNINFORMED second hand beats my own. It does for a BLIND
contract test (one I write against my own implementation only agrees with it)
and for open-ended investigation. It does not for a mechanical pass.

The tell that decided the cut: John's J32 and J33 landed at 08:10 and went
unread the whole session.

**CODEX PICKS A MODEL PER TASK** (operator correction after a session that ran
every Codex task on the default): `gpt-5.6-luna` for contract tests and text,
**`gpt-6-astra` via `CODEX_MODEL` for SPATIAL work** — procedural assembly,
component pairing, structural alignment, scale, relative placement of separate
parts. Ask which KIND of task it is first. C153 proved it: 13 capsules, every
radius traced to ANSUR II by column name, and it caught two things the task did
not ask for.

**GROK IS IN AND ITS BAR IS DIFFERENT.** Usage 0%, paid until 2026-09-30,
operator wants it at 100% before then. Its capacity expires unused, so marginal
cost is zero and the bar is "useful at all". **That reasoning applies to Grok
alone and must not leak.** No shell, no checkout: pure modules with zero
preloads, and blind contract tests from a pasted contract.

**DOLA IS DRIVEN DIRECTLY** by `Tools/cici/cici.py` on port 9333 — `launch`,
`status`, `chats`, `open --chat`, `send --file <md> --wait N`, `read --out`.
Proven 2026-09-21. **Never paste her output into chat and type answers back**;
that is the relay seat. See [[feedback_use_my_own_browser_panel]].
