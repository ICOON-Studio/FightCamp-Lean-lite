# TASK_M21 — Evaluate what the fight actually LOOKS like

**Owner:** maria
**Deliverable:** `M21_WHAT_IT_LOOKS_LIKE.md`, sent back as a file.
**No checkout, no Godot, no repo test commands.**

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

## Your angle: art direction, and one standing complaint

You are the only reviewer being asked about how it looks, and there is a
specific verdict to answer.

**The operator watched the 3D fight on 2026-09-13 and called it "painful to
watch." On 2026-09-14, after a foot-lock fix landed, the verdict was "no visible
difference," and the two things named on screen were: BODIES OVERLAP, and JERKY
MOVES.**

That is a year-old-sounding problem with a very short list of causes, and I want
your read on which one it is. I will attach whatever current stills I have; if I
have not attached any, **say so and answer from the description rather than
inventing what you did not see.**

1. **Overlap.** Two bodies interpenetrating reads as "wrong" instantly, even to
   someone who cannot say why. Is that the dominant defect, or is it a symptom
   that stops mattering once something else is fixed?
2. **Jerk.** Name the likely causes in order: pose-to-pose popping with no
   transition, a blend that is too short, foot sliding, camera cuts, or frame
   pacing. Which reads as "jerky" most strongly to an ordinary viewer?
3. **The cheap wins.** In your experience, what are the three highest
   ratio-of-impact-to-effort changes for a 3D fight that looks stiff — camera
   distance and lensing, contact shadows, motion blur, anticipation and
   follow-through, silhouette readability, lighting? **Rank them and say why.**
4. **What is good?** If something already reads well, say so — I get told what
   is broken constantly and it makes it hard to know what not to touch.

## The constraint you must design within

Two-person grappling animation **cannot be bought** — a paired positional pack
is not a product on any store checked, AI generation returns one body every
time, and composing two solo clips failed 36 of 36. Every grappling pose is
solved procedurally or authored by hand. **So do not recommend buying a mocap
pack for grappling.** Striking clips are a different matter and can be bought.

## Scope

Out of scope: `HANDOFF.md`, any `.gd`, any `.tscn`, `Godot/assets/data/`.
Do not write git commands and do not try to clone anything.

Under 400 lines. Lead with three lines: the most important visual defect, the
one change you would make first, and one thing that already works.
