# TASK_K68 — Evaluate the project against what already exists

**Owner:** kalli
**Deliverable:** `K68_WHERE_THIS_SITS.md`, sent back as a file.
**No checkout, no Godot, no repo test commands. Research prose only.**

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

## Your angle: the outside view

Everyone else reviewing this is looking inward. You look outward.

1. **Who else has built this?** Fight-management sims (not fighting games):
   promotion/gym management with simulated bouts. What exists, what do they
   simulate, and how deep does their fight model actually go? Be concrete and
   name them.
2. **Where does a 3D presented bout sit in that field?** Most management sims
   present text or 2D. Is 3D presentation a genuine differentiator here, or is
   it the expensive thing nobody asked for? **Argue it honestly** — I have spent
   a lot of this project's effort on it and I would rather hear it now.
3. **What do players of these games actually complain about?** Reviews, forums,
   subreddits. Rank the complaints. If the top complaints are all about depth of
   management and none about presentation, that is the single most valuable
   sentence you could write for me.
4. **The realism trap.** This project calibrates against published MMA
   statistics. Find cases in sports sims where statistical fidelity and player
   enjoyment pulled apart, and what those teams did about it.

## Method

Label every claim **DOCUMENTED** (with source) or **INFERENCE**. Sample sizes and
dates where they exist. A forum thread is evidence of a complaint existing, not
of its frequency — say which you have.

**I would rather have five well-sourced claims than forty assertions.**

## Scope

Out of scope: `HANDOFF.md`, any `.gd`, any `.tscn`, `Godot/assets/data/`.
Do not write git commands and do not try to clone anything.

Under 400 lines. Lead with three lines: the most important thing you found, the
one thing you would change first, and whether the 3D presentation is worth it.
