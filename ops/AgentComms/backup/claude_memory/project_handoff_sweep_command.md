---
name: project-handoff-sweep-command
description: "Run agent_comms.py sweep at each day's start; the HANDOFF slice silently grew to 38k tokens a session when the manual chore stopped"
metadata: 
  node_type: memory
  type: project
  originSessionId: 234fb1ee-ad4b-486c-9664-062c24ae74d2
  modified: 2026-09-07T10:26:11.385Z
---

Added 2026-09-07 (commit `b9cedc3`): **`python Tools/agent_comms.py sweep`**
(`--dry-run` first). It moves every finished `### ` block out of `HANDOFF.md`'s
`## Active claims` into `HANDOFF_ARCHIVE.md`. A block is finished when its header
says COMPLETE / LANDED / SUPERSEDED / CLOSED / RETIRED **or** a `*_DIGEST.md` for
its task id exists — that second clause catches headers that still say OPEN
months after shipping. It never touches the prose above the first `### `, so
token rulings, operator decisions and the cycle narrative stay.

**Why:** `CLAUDE.md` had always described this as a manual morning chore and
nothing enforced it, so it stopped on 2026-09-04. The `## Active claims` slice
every agent is told to read as the *cheap* read grew to 2,324 lines / 153 KB —
about 38k tokens per session, 84% of the whole file. First run took it to 442.

**How to apply:** run it when the day starts, before assigning anything. If the
slice is more than a few hundred lines, it has not been swept. Same chore fixed
`CURRENT_STATUS.md` (22 KB → 3.7 KB; its Assignments cell was a 7,201-character
changelog and now just points at `agent_comms.py tasks`).

Related: [[project-mailbox-scoped-to-readers]], [[project_credit_budget_2026-09]].

**The sweep only reaches HALF the problem (2026-09-08).** The prose protection
above is also a blind spot: the announcement paragraphs are never `### ` blocks,
so nothing can ever remove them. On 2026-09-08 the block sweep archived 19
blocks and the slice still stood at **916 lines / 62 KB (~15k tokens per agent
per session)** — only 52 of those lines were the three open claims. The other
864 were finished-cycle announcements whose blocks had been archived weeks
earlier.

- **Sweeping is two chores, not one.** Run the tool, then check the slice size.
  If `sed -n '/^## Active claims/,/^## Direction notes/p' HANDOFF.md | wc -l`
  is still in the hundreds, the prose is the cost and the tool cannot touch it.
- **Retire the narrative by MOVING it**, appending it verbatim to
  `HANDOFF_ARCHIVE.md` under a dated heading — never deleting. Then lift the
  durable items back into the live slice. On 2026-09-08 seven were buried in
  it (the ORGANIZATION vs PROMOTION ruling, the one-corner-rule user decision,
  the R47/R48 token rulings, the fight_state warning, the still-OPEN AAA
  profile-pack operator call, John's roster entry). Find them with
  `grep -in 'user decision\|RULED\|token ruling\|operator call\|JOINED\|not to
  be reopened'` — everything else is a landed-task announcement.
- **Keep what survives as PROSE, not a `### ` heading.** A `### ` becomes the
  first block, which drops everything above it out of the protected region and
  exposes the rulings to a future sweep. Verify after: the first `### ` in the
  file must still be a real open claim.
- **Also check for archived blocks still headed OPEN.** `status_of()` prefers
  an archived status over digest evidence, so a block archived on its digest
  while its header says OPEN reports OPEN forever and `TASKS.md` offers an
  agent a finished task. C51 and C52 both did this on 2026-09-08; the fix is to
  correct the header in the archive to `(COMPLETE <date>, `<sha>`)`.
