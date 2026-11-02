# TASK_J36 — JOHN — WHAT THE ENGINE ALREADY KNOWS THAT THE PLAYER NEVER SEES

**Owner:** John, research specialist
**No checkout, no shell, no Godot.** Reply in chat with the full text.

## Why this, and it is the question K70 left open

K70's finding is that our trust problem is a **reporting** problem: *"if the engine
already knows why a fight ended, honesty is a reporting problem."* All three of
its recommended fixes are surfacing and copy, with no retuning of the calibrated
MMA anchors.

**That claim has never been checked against our actual engine.** It is plausible
and it may be wrong in detail — there may be quantities the card needs that
nothing computes, or that are computed and discarded before anything could read
them.

**This is a research task about an engine you cannot run**, which is unusual for
you, so the brief below says exactly what you can work from.

## What you have to work with

You have no checkout, so you cannot read the code. **You are working from the
project's own research record**, which is substantial and which you have
contributed to. The relevant prior work, by name:

- **J20** — the anchor corpus. Section A carries per-round strike volumes; D5
  carries knockdowns per fight; the knockdown-rate denominator is quoted verbatim
  in the record.
- **J34** — your own clinch study, and the five NOT FOUNDs.
- **K64** — the doctor stoppage at 1.09% of bouts.
- **K70** — the honesty findings.
- **R84, R132/R133, Q114, Q126** — engine measurements with named quantities.

**Ask for anything else you need by name and Claude will paste it.** That is
cheaper than you guessing, and a guess here would be worse than a gap.

## The question, in three parts

1. **WHAT A CAUSATION CARD NEEDS.** K70 lists: landed strikes by target, knockdown
   and rock flags, grappling control time, damage bins. **Is that list complete for
   the twelve ending types a card has to cover?** Work through: one-punch KO,
   accumulation TKO, submission, close decision, wide decision, doctor stoppage,
   leg-damage finish, comeback, mutual fade, squash, draw, and a round-one fluke.
   For each, name the quantities a one-line explanation requires.
2. **WHICH OF THOSE THE RECORD SHOWS WE ALREADY COMPUTE.** Go through the research
   files and say, per quantity: **COMPUTED (named in a study, with which one),
   PROBABLY COMPUTED (implied but never printed), or NOT EVIDENCED.** That third
   category is the useful output — it is the list a build task has to close.
3. **WHAT A REAL BROADCAST SHOWS AFTER A FIGHT**, as a ceiling. FightMetric /
   UFC Stats publish a standard post-fight table; boxing broadcasts publish
   CompuBox. **Name the exact columns each publishes.** That tells us what players
   already expect to see, and it is a target we can be measured against.

## THE DISCIPLINE, AND IT IS WHY THIS IS YOURS

**If something is not evidenced, say NOT EVIDENCED.** Do not reason from "a fight
sim would obviously track X" — this project has been wrong about what it computes
four times, most recently finding balance built three times and wired zero, and a
`FightCommitment` module sitting in `scripts/` while a stage concluded the concept
needed authoring from scratch.

**Your J34 is the model**: five targets, five NOT FOUNDs, delivered cleanly, and
that WAS the answer. A confident list of things we "surely have" would be worse
than useless here, because a build task would be scoped against it.

## THE TRAP

**Do not answer "what would make fights more realistic".** That is a different
question with a different answer and we already have an anchor set for it. This is
about **what is already known and not shown**. If you find yourself recommending a
change to a probability or a constant, you have drifted.

**Second trap:** a quantity being in a RESEARCH FILE does not mean the engine
computes it — a study may have measured it with its own probe. **Distinguish "a
study measured this" from "the engine tracks this during a fight"**, because only
the second can appear on a card without new work.

## The one judgement I want

At the end: **the shortest list of retentions that unlocks the most bullet types.**
If keeping three quantities we currently discard would enable eight of the twelve
endings, that is the finding, and it is worth more than the full audit.

## Deliver

Reply in chat with the full text of `J36_WHAT_THE_ENGINE_KNOWS.md`. Claude lands
it and writes your HANDOFF block — you never edit `HANDOFF.md`.
