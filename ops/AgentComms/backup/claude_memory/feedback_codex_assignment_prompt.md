---
name: feedback-codex-assignment-prompt
description: "SUPERSEDED 2026-09-10 - Claude now launches Codex itself, so do NOT end an assignment with a paste-prompt for the operator. The task-file CONTENT checklist below is still the standard."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dbb0878c-04f8-4381-a15f-a1bdc24b682c
  modified: 2026-09-10T00:50:14.257Z
---

## SUPERSEDED — the paste-prompt half of this rule is dead

The 2026-09-07 rule said: end every Codex assignment with a ready-to-paste
prompt, because **the operator** pastes it into Codex's environment.

**That is no longer true.** Since 2026-09-10 Claude launches Codex itself via
`Tools/codex_task.cmd`, exactly as it launches Qwen, Grok and Cursor — see
[[project_qwen_and_grok_reachable_in_app]]. Handing the operator a paste
prompt now puts them **back in the relay seat**, which is the specific failure
the direct-reach ruling exists to prevent. **Do not do it for any agent.**

## What survives, and it is the valuable half

The checklist below is still exactly what a launch prompt must contain — the
difference is only that Claude feeds it to the CLI instead of the operator
feeding it to a chat window. Every prompt Claude writes for any agent should
carry:

- you own `<id>` and `<id>` only; the task file is self-contained — read it
  and the files it names, nothing else
- do **NOT** read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`,
  `TASKS.md` or any digest, and do not explore to "get oriented"
- **name the big owned file, its real line count and its anchors** — "never
  open it whole, read `sed -n 'A,Bp'` windows at `:x`, `:y`" — and say which
  owned files are small enough to read in full. `GameState.gd` alone is
  ~14.8k lines, an order of magnitude more than a whole task.
- name the files owned by OTHER agents that must not be touched
- parse gate before any test; focused tests first; full suite once before the
  commit, and **read the runner's own `SUITE` line — the exit code is not a
  pass**
- commit, push `master`, write the digest, send one line with
  `agent_comms.py send` — and **`git add` the mail file, because
  `agent_comms.py` writes it but does not stage it**
- do NOT edit `HANDOFF.md`; Claude writes their block
- stage explicit paths only; the checkout is shared and other agents are
  working in it concurrently

Then close with **the one trap specific to that task** — the thing that will
be wrong if they get it wrong, stated as a trap rather than a hope.

Related: [[feedback_advise_model_and_speed_at_clear]],
[[feedback_gloss_every_task_code]], [[project-shell-sandbox-split]].
