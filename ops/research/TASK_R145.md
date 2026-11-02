# TASK_R145 — DOES THE ENGINE'S FOOTWORK ACTUALLY FEED DODGE, REPOSITIONING AND TRANSITION, AND IS IT GATED ON SPEED?

Owner: unassigned (Claude, or an agent with the checkout). Model: medium.
FORECAST RESEARCH, written 2026-09-18 the same hour the ruling landed, because
a question put to the operator later is a study that should have been assigned
now.

## WHY THIS EXISTS

The operator ruled on 2026-09-18 that footwork never needed to move anybody.
**The other half of that sentence is a positive claim about the design and
nobody has measured whether the engine honours it:**

> "Footwork is purely scoring and rhythm, and helps dodge, repositioning and in
> general is the catalyst in transitioning defined by speed."

That is three assertions. This task measures each against the code and a run.
**It is NOT a reopening of the ruling** and must never be reported as one.

## THE THREE QUESTIONS

1. **SCORING AND RHYTHM.** Does a `movement`-class beat actually reach the
   scoring path, and what does it contribute? Read the judge/scoring sites, then
   measure the delta a footwork beat makes to a round's score over a real
   population.
2. **DODGE AND REPOSITIONING.** Does a footwork decision raise the chance of a
   successful evasion or improve position on the next tick? `FightIntent`,
   `FightFootwork`, `FightDefence`. A correlation is not enough — name the code
   path that carries it, or report that none exists.
3. **THE CATALYST IN TRANSITIONING, DEFINED BY SPEED.** Does a footwork beat
   gate a transition (range change, clinch entry, exchange start), and is the
   `speed` attribute the quantity that gates it? **This is the one most likely
   to come back NOT FOUND, and NOT FOUND is a real answer here** — it would mean
   the design intent is not yet in the engine, which is a build finding.

## RULES THAT BIND THIS STUDY

- **NEVER TEST IDENTICAL FIGHTERS.** Two men differing in SPEED specifically,
  since speed is the gate under test, plus the usual differentiated stat block —
  and both legal for the ruleset they fight under. Name the population AND the
  catalogue in the output (R137).
- Read `research/S10_MOVEMENT_DEGRADES.md` first: it already measured the
  walk/beat correlation and its CONTROL ROW is the technique — tally the whole
  population beside the subset, or a property of the fight reads as a property
  of the subset.
- No `.gd` touched means NO gate at all: `git status -s` before staging is the
  whole check. If a measurement tool is written, it is parse-gated and gets its
  own focused run, never the suite.

## OUTPUT

`research/R145_FOOTWORK_FEEDS.md`, one section per question, each ending
in one of: **CARRIED** (code path named, measured), **PARTIAL**, or **NOT IN THE
ENGINE**. A verdict with no `file:line` behind it is not a verdict.
