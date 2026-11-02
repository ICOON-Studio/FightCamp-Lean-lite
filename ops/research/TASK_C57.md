# TASK C57 — CODEX — THE SELECTION: HOW YOU GET INTO A CHAMPIONSHIP

Model: gpt-5.6-luna, effort **high**, Fast off. One session, after C56.

**Agent:** codex · **Opened:** 2026-09-08 · Research only, two markdown files,
no code.

## Why this exists

C52's build order names **step 3 "Entry pathways"** and leaves it unresearched.
R74 is landing step 2 right now: a Grand Prix in an event discipline will
produce an `EventResult` per seated athlete. That makes the next question
unavoidable — **who gets seated, and why?**

Verify before you build on it:

* `_announce_grand_prix` (`GameState.gd:8471`) invents an event, and the invite
  gate in `assets/data/tournaments.json` is a single rule, `invite_min_fame`.
  **Fame is the only thing standing between a fighter and a world-level
  bracket.** No ranking, no qualification, no national body, no selection.
* `EntityPathway.gd` already knows `national_selection` pays no purse
  (`:183`) and what an entry fee is (`entry_fee_cents:131`).
* `EventResult.make` has a `selection_effect` field that **nothing ever sets**
  — it defaults to `"none"`.

## What to answer

Six questions. Cite the governing body and the document for every claim, and
**label an authored invention as invention.**

1. **Who picks.** For each of the six event disciplines, who decides that a
   given athlete competes at a world championship — the national federation,
   a published ranking, a qualification event, or an open entry anyone may pay
   for? These are genuinely different mechanisms and at least one discipline
   uses each.
2. **The quota.** Is there a per-nation cap per division, and is it fixed or
   earned? A one-per-country rule and an open field are different games.
3. **The ladder below the world.** Does a real pathway run national → 
   continental → world, and is the lower rung a REQUIREMENT or merely a
   qualifier that can be bypassed?
4. **What a result buys.** Does placing at one event grant entry, seeding or a
   quota at the next? This is exactly what `EventResult.selection_effect`
   would carry, so answer it in terms a field could hold — or say UNKNOWN.
5. **The open-entry exception.** IBJJF-style events are paid open entry rather
   than selection. Which of the six work that way, what is actually published
   as a price, and does paying to enter interact with the amateur/professional
   one-way door (J2 D5, `_turn_pro` at `GameState.gd:5499`)?
6. **The gap against our model.** Where does selection collide with what the
   game does today — `invite_min_fame`, the gym's ledger (C54 ruled
   `national_selection` an evidence-gated pure cost), and the fact that the
   player manages a gym rather than a national team? Name the seams; do not
   design the fix.

## Rules

* **Two markdown files only.** No `.gd`, no `.json`, no scene, no test, no
  `HANDOFF.md` edit.
* **Do not reopen C54's money ruling.** `national_selection` is an
  evidence-gated pure cost and "no purse, ever" survives. Cite it; if your
  evidence contradicts it, say so plainly and leave the ruling standing for the
  operator.
* **UNKNOWN is a finding**, and a quota you cannot source is not a quota.
* Do not propose a schema, a field name or a migration. This record approves no
  code change.

## Owned files

* `research/C57_THE_SELECTION.md`
* `research/C57_DIGEST.md`

## Gates

Research only: no parse gate, no test run. The gate is that both files exist,
every claim carries its source, and every gap says UNKNOWN.

## Start prompt

```bash
git fetch origin && git rebase origin/master && cat research/TASK_C57.md
```

> You own C57. The task file is self-contained: read it and nothing else. Do
> NOT read `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md` or any other
> digest, and do not explore to "get oriented". This is research: **two
> markdown files, no code, no test, no `HANDOFF.md` edit.** Worth opening:
> `Godot/scripts/EventResult.gd` (264 lines, read whole) to see the
> `selection_effect` field nothing sets, `Godot/scripts/EntityPathway.gd`
> around `:131` and `:183`, and `assets/data/tournaments.json` for
> `invite_min_fame`. `GameState.gd` is 14,224 lines — only ever a `sed -n`
> window, never the whole file. Commit, push, and send one line with
> `python Tools/agent_comms.py send`. The trap: C54 already ruled that
> `national_selection` is a pure cost and pays no purse — do not quietly
> reopen it, and if your evidence disagrees, say so and leave the ruling for
> the operator.
