# TASK_Q118 — QWEN — WHAT DOES THE GAME LOOP ACTUALLY DEMAND OF THE PLAYER, WEEK BY WEEK?

**Agent:** Qwen · **Model:** qwen3-coder · **Effort:** medium · **Fast:** off
**Launch:** from worktree `FightCamp-Q81`:
`Set-Location <wt>; Get-Content <this file> -Raw | qwen.cmd --yolo -m qwen3-coder`
(PowerShell reports exit 1 on its yolo warning — read the `.out` file, never the rc.)
**Read this file and only the files it names.** Do NOT read `HANDOFF.md`,
`CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any digest.

**Test tier — RESEARCH, no `.gd` edited: NO GATE AT ALL.** `git status -s` before staging is
the whole check. Your gate is your own check script.

---

## WHY THIS EXISTS

The operator wants the interface rebuilt so a player can **book, train and watch a fight**. An
interface is a shape poured into a game loop, so the loop has to be described in decisions
before any hub is drawn. **Nobody has written down what the loop actually asks of the player.**

Codex is mapping what surfaces EXIST and what is reachable, in parallel. You are answering the
other half: **what the engine demands, and when.** Do not look at his work and do not read any
`codex/` branch.

## THE QUESTION

### 1. THE WEEKLY PASS — what happens when a week advances?

Find the weekly advance (the `_advance_*` family — `grep -n '_advance_' Godot/scripts/*.gd`)
and walk it. `GameState.gd` is **~13,000 lines: NEVER open it whole.** `grep -n` to locate,
then `sed -n 'A,Bp'` windows.

Produce an **ordered list of what a week does**, each step with its `file:line`. For each step
say whether it is:

- **AUTOMATIC** — happens regardless, the player is told afterwards
- **PLAYER-DECIDED** — the engine reads a choice the player must have made
- **PLAYER-INTERRUPTIBLE** — automatic, but the player may override it

### 2. THE DECISION INVENTORY — this is the deliverable that matters

**Every decision the player is required or able to make, with its DEADLINE.** For each:

| field | meaning |
|---|---|
| decision | what is being chosen |
| where it is read | `file:line` in the engine |
| when it must exist | which week, relative to what event |
| what happens if it is never made | the engine's actual default — read it, do not assume |
| how often | every week / per fight / per camp / once a career |

**The "what happens if it is never made" column is the one that decides the interface.** A
decision with a sane default can live three clicks deep; a decision that silently ruins a
career must be in the player's face. **Read the default out of the code. Do not infer it.**

### 3. FREQUENCY — what is touched constantly and what is touched once

Rank the decisions by how many times a player makes them across a **simulated 5-year career**.
Measure it if you can drive the sim; if you cannot, derive it from the loop and SAY which it
is. A thing done 260 times and a thing done twice must not sit at the same depth, and this
ranking is the evidence for that.

### 4. THE THREE VERBS THE OPERATOR NAMED

**Book. Train. Watch.** For each, list every engine-side step it takes from start to finish,
with `file:line`. Where a step has no player-facing surface at all, say **NO SURFACE** — those
gaps are exactly what this survey is for.

## WHAT NOT TO DO

- **Do not design an interface, propose hubs, or recommend a layout.** That is the operator's
  call and Claude's to synthesise. You are describing the machine.
- **Do not edit any `.gd`.**
- **Do not guess a default.** If you cannot find what happens when a decision is skipped, write
  **UNKNOWN** and name the file you could not resolve it in. An invented default is worse than
  a gap, because the interface would then be built around it.

## OWNED FILES

- `research/Q118_WHAT_THE_LOOP_DEMANDS.md` (new, the digest)
- `research/Q118_loop.py` (new)
- `research/Q118_check.py` (new, the gate)
- `research/Q118_decisions.json` (new)

## THE GATE

`python research/Q118_check.py` must exit 0 and must RECOMPUTE from the source rather
than read `Q118_decisions.json` and agree with it. It must independently:

- assert every `file:line` in the decision inventory still resolves to a line that mentions the
  decision's key;
- assert the decision count against a **literal pinned in the check script**;
- assert every decision row has a non-empty "what happens if never made" field, with `UNKNOWN`
  allowed and counted separately — and print that UNKNOWN count;
- assert a degenerate case: an empty decision list reports "no decisions" rather than dividing
  by zero.

## THE ONE TRAP

**A decision the engine reads is not the same as a decision the player can currently make.**
Some will be read from a field that only a test or a debug path ever writes. **For every
decision, name the WRITER as well as the reader**, and mark it `NO PLAYER WRITER` where the
only writer is a test, a default, or the generator. That column is the difference between "the
interface is missing a screen" and "the game does not have this feature yet", and conflating
the two would send the whole stage the wrong way.

## WHEN YOU ARE DONE

Commit with explicit paths (`git add -- <files>`), push, then one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic q118-ready --body "<one line>"
```

Do NOT edit `HANDOFF.md`. Unstage `AgentComms/messages` before any commit that is not the mail.
