---
name: project-credit-budget-2026-09
description: "FightCamp: the user wants credit consumption minimised for EVERY agent, not just Claude; assignments are self-contained task files, HANDOFF.md is read as a slice, and no agent rewrites another's block"
metadata:
  type: project
---

On 2026-09-03 the user asked Claude to cut its own consumption
("proceed with whatever it takes"). On 2026-09-04 they widened it to the
other agents and asked whether a "ruthlessly compress HANDOFF.md to 40
lines every session" instruction would help.

**Why:** the coordination file had grown to 1,061 lines (~18k tokens per
read), but the measured cost driver is session length (409k of history →
383M cached reads), and a per-session rewrite of a shared file costs more
in output tokens than reading it costs in input — and lets one agent
delete another's live claim.

**How to apply:**
- Assignments are self-contained `research/TASK_<id>.md` files:
  spec, owned files, `file:line` anchors, parse gate, one test command.
  An agent reads its task file and only the files it names.
- `HANDOFF.md` is read as a slice
  (`sed -n '/^## Active claims/,/^## Direction notes/p'`), never whole;
  it was swept to 354 lines on 2026-09-04 (`16c1af3`) with every standing
  rule kept and the completed blocks moved to `HANDOFF_ARCHIVE.md`.
- Each agent writes ONLY its own block there, max 8 lines; Claude does
  the archiving sweep at each day's start.
- One task per session, ended the moment it ships. This is the biggest
  lever by far — see [[feedback-new-session-per-shipped-stage]].
- Never compress away standing rules or dead-end findings: an agent that
  does not know a rule spends far more rediscovering it. Keep dead ends
  as one-line tombstones.

Rules live in `Game/CLAUDE.md` (credit-rules section), `HANDOFF.md`
protocol item 8, and `CURRENT_STATUS.md` read rules. See
[[feedback-claude-lead-developer-role]] and
[[feedback-godot-verification-gate]].
