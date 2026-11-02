# TASK C132 — CODEX — THE THREE JABS IN THE ENGINE: WHEN A FEINT, A RANGE-FINDER OR A JAB IS THROWN, WHAT EACH DOES, AND WHAT THE ROOM IS GIVEN TO SHOW

Model: `gpt-5.6-luna`, MEDIUM (pinned by `Tools/codex_task.cmd`). Owner: codex. MAIN checkout. Stage: S4a (THE THREE JAB
TYPES).

**Test tier: READING RESEARCH, NO CODE CHANGE.** No parse gate, no Godot, no test. `python research/C132_check.py`
is the whole gate and must print `C132_CHECK PASS`. If it does not, fix the digest until it does. Never edit
`C132_check.py` or any file under `Godot/scripts/`, `Godot/tests/`, `Godot/assets/`.

## Owned files

- `research/C132_JAB_TYPES_IN_ENGINE.md` - NEW, 110 lines at most.

## Why this exists

The operator, verbatim: "A sloppy jab can be thrown just to measure distant the animations need to portray fakes and
when a fighter commits to a jab opening". The catalogue already has three jab-like techniques: `boxing_jab` (setup:
accuracy 8, range_control 7, combo_open 6), `boxing_distance_read` "Finding the Range" (setup: distance_read 7,
range_control 5) and `boxing_feint` "Feint" (setup: entry_open 8, distance_read 6), all in
`Godot/assets/data/technique_catalog.json`. The 3D room shows both of the last two with the full `jab` clip
(`Godot/scripts/FightStagePlayer.gd:836-837`). Claude will animate each one differently. Before that, it needs to know
from the CODE exactly when the engine throws each, what each changes, whether anything models a committed jab leaving
the thrower open, and which fields reach the presenter. Read the code; do not guess and do not propose designs.

## Where to read (never open a file whole; use `rg -n` then read windows of 40-80 lines)

- `Godot/scripts/FightRealtime.gd` (2,681 lines) - the real-time bout: how an action is chosen and resolved.
- `Godot/scripts/FightSimulation.gd` (3,631 lines) - effects by role: `:109-113` (effect -> kinds), `:342` (role ->
  `feint_setup`), `:1623` (`combo_open`).
- `Godot/scripts/FightMoves.gd` (~1,000 lines) - `:87` `STRIKE_ROLES`, `:121` entry effects, `:944` `GUARD_EVADE_EFFECTS`
  and its use at `:967`.
- `Godot/scripts/FightStagePlayer.gd` (2,497 lines) - `:820-840` the technique -> clip table, `_thrower_clip` below it.
- `Godot/scripts/FightMoveScript.gd` (200 lines, read whole) and `Godot/scripts/FightLiveSchedule.gd` (225 lines, read
  whole) - how an authored pair is selected and scheduled.
- `Godot/scripts/FightWorldLiveScreen.gd` (1,299 lines) - where a beat becomes a presentation.

## The questions (answer each in `## ANSWERS`, starting the line with `Q1.` ... `Q6.`)

- **Q1.** When does the real-time engine choose `boxing_feint`, `boxing_distance_read` and `boxing_jab`: which function
  picks the technique, and which conditions and weights decide it (range band, role, plan, stats, the previous action)?
- **Q2.** What happens when each resolves: can it land or miss, does it deliver a blow, and what do its effects
  (`entry_open`, `distance_read`, `range_control`, `accuracy`, `combo_open`) change - for whom, and for how long?
- **Q3.** What does a feint or a range-finder make the OPPONENT do: does any code react to it (guard, evade, counter) or
  change the next action's chance or timing?
- **Q4.** Does the engine model COMMITMENT - is a man more open after he throws a jab (landed or missed)? Which state
  carries it, and when do the counters (`boxing_slip_counter`, `boxing_catch_counter`) fire? If nothing models it, say
  so plainly.
- **Q5.** What the 3D room shows for each of the three today: the clip or authored pair chosen, and whether any pair
  can be played for a feint or a distance read.
- **Q6.** Which fields a presenter receives for one action (the exact dictionary keys of a beat or event at the point
  `FightStagePlayer` / `FightWorldLiveScreen` reads it), so an animation could tell the three apart.

## Evidence rules (the check enforces them)

- Every claim in `## ANSWERS` points to at least one row in `## Evidence`.
- `## Evidence` is a list; each row is exactly: `` - `Godot/scripts/<File>.gd:<line>` "<quote>" - <what it shows> ``.
  The quote is copied from that file and must appear within 3 lines of the cited line number (whitespace may differ).
  At least 14 rows, from at least 5 different files, including `FightStagePlayer.gd` and `FightRealtime.gd`.
- `## What the room shows` - a table `| technique | chosen clip or pair | cited line |` with the three techniques.
- `## Open` - what the code does not settle (at most 8 lines).

## Deliver

Write only the owned digest. Run `python research/C132_check.py` until it prints `C132_CHECK PASS`. You cannot
commit (the sandbox cannot write `.git`): leave the file in place and end your last message with the PASS line. Claude
collects it.

## The trap

A name that looks like the mechanic is not the mechanic: `feint_setup` at `FightSimulation.gd:342` is a LABEL for a role.
Follow the value to the code that reads it before you write what it does - and when no code reads an effect, that is the
answer (a third of the catalogue's effects were read by nothing in 2026-09-11's audit).
