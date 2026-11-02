# TASK_G61 — Evaluate the project's DIRECTION, and argue with me

**Owner:** grok
**Mode:** Expert. **NEVER Build mode.**
**No checkout, no Godot, no repo test commands. Pure reasoning and research.**

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

## Your angle: is the ENGINE-FIRST bet right?

Every other reviewer is being pointed somewhere else, so stay on this one.

On 2026-09-14 the operator chose **engine before clips**: rather than buy or
generate more animation, fix ring position, stances, real dodges, feints, and
the states between exchanges. Since then the engine has gained a balance model
(centre of gravity over a shifting base of support, wired to force delivery,
impact absorption and takedown defence), a weak-line direction model, and a
two-body contact solver.

The bet is that **a fight looks real because the DECISIONS are real**, not
because the clips are pretty.

**Argue the other side.** Specifically:

1. Is there a point where engine fidelity stops buying watchability? The
   operator's complaint was "bodies overlap, jerky moves" — how much of that is
   a decision problem at all?
2. The project measures itself against published MMA statistics (strike rates,
   knockdown incidence ~3.9%, takedown accuracy, leg-strike share 14–18%).
   **Is matching aggregate statistics the same as looking real?** Name a case
   where a simulation matched its anchors and still looked wrong.
3. What do commercial fight games actually do here — UFC, Fight Night, WWE 2K,
   and the grappling-heavy ones? Where do they spend, engine or animation? Be
   concrete about what is publicly known and label what is inference.
4. If you think engine-first is right, what is the strongest argument AGAINST it
   that we should have an answer to?

## Constraint that binds every recommendation

Two-person grappling animation **cannot be bought** — a paired BJJ positional
pack is not a product on any store we have checked, generation produces one body
(8 of 8 attempts), and composing two solo clips scored 0 of 36. So "just buy
better animation" is not available for grappling. It IS partly available for
striking. Factor that asymmetry in.

## Deliverable

Reply in chat with the full text — you have no checkout, so **do not attach a
file and do not write git commands**. Under 400 lines. Lead with three lines:
the most important thing you found, the one thing you would change first, and
whether engine-first is right.
