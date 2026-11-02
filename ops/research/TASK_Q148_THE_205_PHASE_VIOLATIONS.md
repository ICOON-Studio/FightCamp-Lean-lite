# TASK_Q148 — THE 205 PHASE VIOLATIONS: WHICH ARE REAL, AND WHAT CAUSES EACH

**Model: `qwen3-coder`, medium, `--yolo`.** Worktree `FightCamp-Q114`, a FRESH branch `qwen/q148-phase-violations`
cut from **`origin/qwen/q147-named-and-legal`** (you need your own contract test). Assigned S59, 2026-09-23,
operator request. **DIAGNOSE, DO NOT FIX.**

## Owned files

- `Godot/tools/q148_phase_violations.gd` (new).
- `research/Q148_DIGEST.md` (new).

## THE FINDING

Your Q147 contract test, clause 4, found **205 events** where a technique whose catalogue node's `phases` are
ground-only (`ground`, `ground_top`, `ground_bottom`) names an event that happened while the men were STANDING or in
the CLINCH. Clause-4 mutant was caught, so the check can fail. Two explanations compete and nobody has told them apart:

- **(A) Engine defect, stale phase:** Q146's cause 2 - `_move_seat` asks `_grapple_technique_for` for a name BEFORE it
  updates `state["grapple"]`, so a transition is named under the phase it is LEAVING, or the one it is ENTERING,
  depending on direction. A takedown (standing -> ground) named after its landing position would read as a
  ground technique on a "standing" event.
- **(B) Test artefact:** clause 4 reads the event's phase from a field that means something else (e.g. the phase BEFORE
  a transition when the technique legitimately names the phase AFTER it; or `seat` vs `stance`).
- **(C) Catalogue:** a node's `phases` list is wrong (a technique that can legally start standing tagged ground-only).

## WHAT I WANT - ONE TABLE AND A VERDICT PER ROW

1. Reproduce the 205 on today's `origin/master` (it has S59 + U142; the count may differ - report the real one).
2. For every violation print: ruleset, event `kind`, `via`, the event's phase fields (every key you can find:
   `stance`, `to_stance`, `from_stance`, `seat`, `to_seat`, `phase`...), the phase in `state` at that tick BEFORE and
   AFTER the event, the technique id, and its catalogue `phases`.
3. **Group them** (kind x via x from-phase x to-phase) and give each GROUP a verdict A, B or C with its count.
   The groups' counts must sum to the total; anything you cannot classify is its own row, not folded into a story.
4. For verdict A groups: name the line in `FightRealtime.gd` (grep `_move_seat`, `_grapple_technique_for`) and say
   whether naming with the phase being moved INTO would make the event legal. For B: say exactly how clause 4 should
   read the phase. For C: list the node ids and what their `phases` should be, with the reason.

Population: the same per-ruleset pairs as Q145/Q147 (two different men, legal for the ruleset; print them). Ruleset as
a DICTIONARY.

## TEST TIER - a new tool only

Parse gate on your tool, then run it. No suite, no subset. No engine or test file is edited. `FightRealtime.gd` is
~4,900 lines - NEVER open it whole; grep and read `sed -n` windows. Other agents run Godot on this machine; slow is
contention. If `check_scripts.py` or `run_tests.py` print a STAGE GATE refusal, run them with
`FIGHTCAMP_STAGE_GATE=off` - that gate belongs to Claude's shipped session, not to your task.

## CONTEXT YOU MAY READ

`research/Q146_DIGEST.md`, your own Q145/Q147 tools and digests. **Not** `TASK_U143_NAME_THE_CONTROL.md` or the
`cursor/u143-name-the-control` branch - Cursor is fixing the namer in parallel and your verdicts must stay independent
of its fix.

## THE ONE TRAP

**A violation is only an engine defect if the event, read correctly, happened in a phase the technique cannot be in.**
If most of the 205 turn out to be transitions (takedowns, throws, stand-ups) named for the position they LAND in,
the real question is which phase a transition's name should belong to - say so plainly; do not count them as 205
bugs.

Commit, push `qwen/q148-phase-violations`, send one line with `agent_comms.py send --from qwen --to claude --topic
Q148` naming the branch and the A/B/C split. Do NOT edit HANDOFF.md.
