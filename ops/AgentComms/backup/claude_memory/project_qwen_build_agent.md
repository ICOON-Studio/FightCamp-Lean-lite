---
name: project_qwen_build_agent
description: "Qwen is a FULL build citizen with a real shell (restored 2026-09-08); the old \"chat relay, paste the file\" handling is retired"
metadata: 
  node_type: memory
  type: project
  originSessionId: 61490de8-da16-47f6-ace6-ff041268c0ea
  modified: 2026-09-08T17:46:07.836Z
---

Qwen is a full build agent, identity `qwen`, on the same footing as Codex and
Cursor: real shell in the shared checkout, in `MAILBOX`, takes the Codex-shaped
copy-paste start prompt, and takes ordinary build tasks with module and test
together. Launch with `qwen --approval-mode default` from the repo root.
`QWEN.md` at the repo root is its context file (loaded automatically) and
points at `AGENTS.md` as the contract.

**Why:** it was demoted to a paste-only chat relay on 2026-09-08 because the
CLI answered 401, and restored the same day when that turned out to be three
stacked credential faults, none of them the repo's — a MASKED console key
containing literal asterisks, a Token Plan token in `OPENAI_API_KEY` (which no
plan provider reads; they bind to `BAILIAN_TOKEN_PLAN_API_KEY` via `envKey`),
and a repo model pinned to a Coding Plan the account does not hold. Shell, not
vendor, was always the line.

**How to apply:** do NOT hand Qwen a pasted task file via `SendUserFile`, do
NOT split its module and test into two tasks, and do not restrict it to pure
modules — all three were relay-era workarounds and are now rescoped in
`CLAUDE.md` to the genuinely shell-less agents ([[project_mailbox_scoped_to_readers]]).
Keep the two-task split for Grok/Kalli/Maria: the independence is worth it on
its own merits. If Qwen 401s again, check those three faults before touching
repo config. Still unproven as of 2026-09-08: a full task end to end under
approval, so keep its first assignments small — it shares the working tree with
Claude and Cursor, and the 2026-09-07 wipe is the risk
([[feedback_shared_index_git_add_gotcha]]).
