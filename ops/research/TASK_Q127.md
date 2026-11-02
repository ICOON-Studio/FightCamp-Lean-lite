# TASK_Q127 — Evaluate the CODEBASE and tell me what is rotting

**Owner:** qwen
**Launch:** `qwen --yolo` from the repo root. (Never `auto` — auto leaves it with
no shell tool at all.)
**Test tier:** **NONE.** This is a read-only census producing one markdown file.
No parse gate, no tests, no suite. `git status -s` before staging is the whole
check.

## What "evaluate the project" means here

The operator asked for this directly (2026-09-22): *"whoever doesnt have a task
assign him to evaluate the project progress and give you suggestions or
corrections etc"*. So this is not busywork and it is not a status report — I can
read the status myself. **What I cannot do is see my own blind spots.** You are
being asked to disagree with me.

**Be specific or be silent.** "Consider improving test coverage" is worthless.
"`X` is gated by `Y`, which cannot fail because it learns its allowed values
from the thing it is grading — here is the line" is worth the whole task.

**Rank your findings.** Put the one you would bet money on first, and say what
would prove you wrong. If you think the project's direction is right, say that
plainly and name the strongest evidence for it — a review that finds nothing is
a legitimate result, and much better than an invented list.

**You will be wrong about some of it and that is fine.** I will check every
claim. What costs me is a confident claim with no file:line behind it.

## What the project is, in six lines

FightCamp is a Godot 4.7.2 GDScript fight-management game: you run a gym, sign
and develop fighters, and bouts are simulated by an engine and presented in 3D.
The simulation layer is mature — 323 tests, a real damage/balance/grapple model
calibrated against published MMA statistics. **The 3D PRESENTATION is the weak
half**, and the operator's own verdict (2026-09-13) was that the 3D fight is
"painful to watch". The current stage, S43, is about making two fighters
actually touch each other: a contact solver that takes a two-body pose from
interpenetration to clean contact.

## Your angle: the code, not the design

You have a shell and a checkout, so you are the only reviewer who can actually
read the tree. Stay on the code.

Hunt for these five, in this order:

1. **Wired to nothing.** Modules that exist, are tested, and are called by no
   production path. I know of at least one — `FightPoseSolver.gd` is deliberately
   not wired yet, so that one does not count. Find the others. `grep` for each
   `class_name`/script name across `Godot/` and report the ones with zero
   non-test callers.
2. **Gates that cannot fail.** A check whose allowed values are learned from the
   thing it is checking, or whose bound is derived from the data it is judging.
   This project has shipped at least two. Give me `file:line` and the input that
   would slip through.
3. **Duplicated constants that have drifted.** The same physical number written
   in two places with two values — reach, stance width, round length, weight
   limits, any threshold in metres or seconds. These are silent and they are the
   most expensive thing on this list.
4. **Dead or stale test files** — tests that pass because they assert nothing, or
   that have been red so long they are treated as furniture. Six suite failures
   are currently expected and named; check whether that list is still honest.
5. **`GameState.gd`** — it is ~13,000 lines. **NEVER OPEN IT WHOLE.** Use
   `grep -n` and `sed -n 'A,Bp'` windows. Tell me what the three largest
   responsibility clusters in it are and which one could leave first, with a
   line-range estimate.

## What I do not want

Not a style review. Not naming conventions, not formatting, not "consider adding
type hints". Not a list of TODOs — I can grep those. **Only things that are
wrong or that will bite.**

## Owned files

- `research/Q127_CODEBASE_CENSUS.md` — CREATE, yours alone.
- Everything else is **READ-ONLY.** Do not fix anything. A fix bundled with a
  census hides how bad it was, and I want the number first.

## Deliverable and gate

Write `research/Q127_CODEBASE_CENSUS.md` and nothing else. **This is a research task: no `.gd` file is
touched, so there is NO gate at all** — not the parse gate, not a test. Do not
run the suite; it costs twenty minutes and proves nothing about a markdown file.
`git status -s` before you stage is the whole check.

Commit and push `master`, then send one line:

```bash
python Tools/agent_comms.py send --from qwen --to claude --subject q127-ready --body "<one line>"
```

**Do NOT edit `HANDOFF.md`.** Stage explicit paths only (`git add -- <files>`);
never `audio_exports/`. Check `git status -s` first — another agent's
work-in-progress may be pre-staged, and a path-limited add can still sweep it in.

Keep it under 400 lines. Lead with a three-line summary: the single most
important thing you found, the single thing you would change first, and whether
you think the direction is right.
