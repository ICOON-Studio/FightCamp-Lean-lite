# TASK C56 — CODEX — THE YOUTH DIVISION: AGE AS A COMPETITION AXIS

Model: gpt-5.6-luna, effort **high**, Fast off. One session, after C55.

**Agent:** codex · **Opened:** 2026-09-08 · Research only, two markdown files,
no code.

## Why this exists

Predicted-queue item 4, and C52 area C surfaced the first half of it: grades
carry minimum AGES (`GradeLadder.gd` now holds judo `1st_dan` 15 and
`2nd_dan` 16, the only two sourced). The game has **no youth or junior
competition concept at all**.

Verify before you build on it, do not take it from this file:

* `EventResult.make` (`Godot/scripts/EventResult.gd`, landed today) already has
  an `age_division` field — `""` by default, and **nothing in the game ever
  sets it**. Grep it.
* C52 area B found the amateur ladder is age-divided in the real sport.
* An athlete is created with an age and ages every year (R51/R52), so the axis
  exists on the fighter and nowhere else.

## What to answer

Six questions. Cite the governing body and the document for every number, and
**label an authored invention as invention.**

1. **The age bands.** What age divisions do the six event disciplines actually
   publish — cadet, junior, u21, senior, veteran/masters? Give the real band
   edges per discipline where they are published, and mark UNKNOWN where they
   are not. They are not the same across bodies and you must not flatten them.
2. **The floor.** What is the youngest age at which a person may compete at all
   in each discipline, and is it different for contact and non-contact formats?
3. **The one-way door, or not.** Is moving up an age band automatic on a
   birthday, on a calendar year, or on a registration date? A calendar-year
   rule and a birthday rule produce different fighters and the game must pick
   one knowingly.
4. **Masters and veterans.** Do the six disciplines run senior competition with
   an upper bound, and is there a veterans category that is a real competitive
   pathway rather than a social one? This decides whether R51's aging curve
   ends a career or moves it.
5. **What a youth result IS.** Does a junior medal count toward a senior
   ranking, a senior selection, or nothing? This is the question that decides
   whether `EventResult.age_division` is decoration or load-bearing.
6. **The gap against our model.** Where does an age-divided competition axis
   collide with what the game already does — weight classes, the amateur
   circuit (R56), `_turn_pro` (`GameState.gd:5499`), medical holds, and the
   Grand Prix announcement in `assets/data/tournaments.json`? Name the seams;
   do not design the fix.

## Rules

* **Two markdown files only.** No `.gd`, no `.json`, no scene, no test, no
  `HANDOFF.md` edit.
* **UNKNOWN is a finding.** C54 came back thin on purpose and was the better
  for it. Do not fill a gap with a plausible number, and do not generalise one
  body's band edges to the other five.
* **Do not re-derive C52's grade ground.** How a grade is earned is settled and
  `GradeLadder.gd` is built from it. Cite C52; never restate it.
* Age minima for GRADES are C52's; age bands for COMPETITION are yours. If they
  disagree in a discipline, say so explicitly — that disagreement is a finding.
* Do not propose a schema, a field name or a migration. This record approves no
  code change.

## Owned files

* `research/C56_THE_YOUTH_DIVISION.md`
* `research/C56_DIGEST.md`

## Gates

Research only: no parse gate, no test run. The gate is that both files exist,
every number carries its source, and every gap says UNKNOWN.

## Start prompt

```bash
git fetch origin && git rebase origin/master && cat research/TASK_C56.md
```

> You own C56. The task file is self-contained: read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any other
> digest, and do not explore to "get oriented". This is research: **two
> markdown files, no code, no test, no `HANDOFF.md` edit.** The only repo files
> worth opening are `Godot/scripts/EventResult.gd` (264 lines, read whole) to
> confirm `age_division` is never set, and a `sed -n` window around
> `GameState.gd:5499` — that file is 14,224 lines, never open it whole. Commit,
> push, and send one line with `python Tools/agent_comms.py send`. The trap:
> UNKNOWN is the answer wherever a body does not publish, and one body's age
> bands are never evidence for another's — C54 was right to come back thin.
