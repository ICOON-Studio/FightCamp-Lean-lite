---
name: feedback-advise-model-and-speed-at-clear
description: "At every /clear AND on any status / what-next question, name three separate settings — model, effort, Fast mode — for this session and for every agent holding an open task"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6eefd288-c541-4303-af71-ea79ddf70400
  modified: 2026-09-05T12:57:09.548Z
---

User rule 2026-09-05, sharpened twice the same day. At every `/clear`, before
starting the next task, recommend **three separate settings**, always all
three, never a subset:

1. **Model** — the actual name (Opus 5, Sonnet 5, Haiku 4.5), not a tier word.
2. **Effort** — low / medium / high.
3. **Fast mode** — ON or OFF.

Do the same for every task assigned to Codex, Grok or Kalli, so the
`Model:` line in their `TASK_<id>.md` carries all three deliberately.

**Also on request, not only at `/clear`:** when a session opens with
"status", "what's next", "where are we" or anything like it, first READ the
queue — the `## Active claims` slice of `HANDOFF.md` plus
`git log --oneline -5` — and report what is scheduled, who owns it and what
blocks what. Then repeat the three settings for EVERY agent that currently
holds an open task file, not just for this session. Never answer a status
question from memory of an earlier session; the other agents push while
Claude is away (Codex landed C8 mid-session on 2026-09-05 and the queue was
already stale).

**Why:** the user asked twice in one session because the answer mixed the
task-file tier vocabulary (`high`/`medium`/`low`) with model names and
dropped effort entirely. A tier word alone is ambiguous — it does not say
which model to select in the app. Worse, "medium + Fast mode on" names a
setting that cannot exist: Fast mode is an Opus-only toggle. All three are
fixed at assignment and no agent self-escalates, so a wrong or unreadable
pick is paid for over the whole task. The status trigger exists because the
user opens a fresh session per shipped stage and needs the queue plus the
settings in one answer to decide what to start.

**How to apply:** one compact line or table per agent — model, effort,
Fast, and the reason in a few words. They are independent axes: effort is
how hard it thinks, Fast is how quickly it emits, model is which brain.
Match them to the work, not its importance. Mechanical work (config, git
chores, renames, mirroring a known pattern) takes a cheaper model and
lower effort; new systems, UI architecture and anything touching
`GameState.gd` take Opus 5 at high effort. Fast mode suits long mechanical
passes. Watch for the mixed task: a stage that mirrors a known pattern but
ends in surgical deletions across many test files still wants high effort,
because a missed parse error costs a timeout per test — more than the
setting saved. Say plainly when the cheaper option is enough, since the
default pull is to overspend. Mirrored into `CLAUDE.md` so a fresh session
gets it without the memory. Same credit discipline as
[[project-credit-budget-2026-09]], at the boundary set by
[[feedback-new-session-per-shipped-stage]]; Claude picks per
[[feedback-claude-lead-developer-role]], and current agent capacity is
[[project-codex-capacity]].

S162 (2026-10-04) operator, verbatim: "always propose a model/effort with the prompt of new session" - EVERY handover block
is preceded by one line: model, effort, Fast on/off, and why (routine collection/visual review -> Sonnet medium; a hard
engine/geometry problem -> Fable extra-high, as he chose for GLOVES2). Now also CLAUDE.md s3 HANDOVER.
