# TASK Q49 — QWEN — THE ONE FIX Q48 SAID TO BUY: FOOT PLANTING

Model: Qwen CLI, medium effort. Owner: qwen.
Study. **No GDScript, no engine work, no test command.**
Test tier: **RESEARCH, NO `.gd` TOUCHED — NO GATE AT ALL.** `git status -s`
before staging is the whole check.

## Owned files

- `research/Q49_FOOT_PLANTING.md` — **NEW. Yours alone.**

Nothing else. Do **not** edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
other task file, or any script. Do not read `HANDOFF.md`, `HANDOFF_ARCHIVE.md`,
`CURRENT_STATUS.md` or any digest, and do not explore the repository — this task
is self-contained and nothing in the codebase is needed to answer it.

**You may read your own previous deliverable,
`research/Q48_ONE_CLIP_TWELVE_BODIES.md`, and nothing else in the repo.**

## Why this exists

You just answered Q48, and your own headline was: **weight class already saves us
from most of the one-clip-many-bodies problem, and the single fix worth paying
for is foot planting.** This task takes that recommendation and asks the
implementation question behind it, BEFORE anyone tries to build it.

We have twelve rigged humanoid fighters and a growing library of bought clips
retargeted onto them. Leg lengths differ. A shared clip will slide or float the
feet, and you assessed that as **the most visible failure at our camera distance**
— the eye tracks the base of support.

## The questions

1. **What does Godot 4.7 actually offer today?** `SkeletonIK3D` is the name
   everyone remembers, but its status in Godot 4.x is the whole question —
   **check whether it is deprecated, removed, or superseded**, and by what.
   `SkeletonModifier3D` and its subclasses are the likely answer. Name the exact
   class and the version it arrived in. **If the documentation contradicts the
   blog posts and forum answers, say which you trust and why.**
2. **Two-bone IK specifically.** A leg is hip → knee → ankle: the classic
   two-bone analytic case with a pole/hint vector for the knee. Does the engine
   ship this, or is it a hand-written solver? What does a hand-written one cost
   to get right — particularly **knee direction**, which is the part that looks
   wrong when it is wrong.
3. **What drives it.** IK needs a target. For a planted foot the target is where
   the foot was when it made contact. So: **how is the contact phase detected** —
   authored curves, foot-height thresholds, foot-speed thresholds — and what do
   shipped games actually use? Our clips are bought and carry no authored contact
   curves, so a solution that requires them is a solution we cannot use. **Say so
   plainly if that is the case.**
4. **Cost.** Per-frame cost of two IK chains on two fighters. Is this something
   we run always, or only when the foot error exceeds a threshold?
5. **Does it interact with the retarget?** Our clips are retargeted from another
   rig, with a per-bone rest correction. Does foot IK run before or after that,
   and does the order matter? **NOT FOUND is an acceptable answer here** — say so
   rather than reasoning it out and presenting the reasoning as a finding.
6. **The honest sanity check.** Our camera is **9–11 m back, 3.8–4.2 m up, at a
   20° downward pitch**. You already judged foot-floor contact visible at that
   distance. **Is there a cheaper fix that gets most of the benefit** — scaling
   each fighter's root height to a small number of bands, or simply snapping the
   root so the lower foot touches the deck? If the cheap fix gets 80% of the way,
   that is the finding and it should be the headline.

## Standards

- **Use web search.** Engine version behaviour is a fact to be checked, not
  recalled. Anything you half-remember about `SkeletonIK3D` is exactly what needs
  verifying.
- Cite sources: Godot documentation with its version, GDC talks, engine and
  animation-programming references.
- **Separate DOCUMENTED from FOLKLORE from your own INFERENCE, and label each.**
  You did this well in Q48; do it again.
- **Mark what is not published as NOT FOUND.** Do not derive a per-frame cost and
  present it as a measured one.
- Do not write GDScript and do not propose an implementation in code.
- Rank by cost. We want the smallest change that makes the feet read correctly.

## Deliverable shape

A **DECISIONS** section at the very top — short typeable lines that can be acted
on without reading the body, including a one-line answer to question 1 (the exact
class to use in Godot 4.7) and to question 6 (whether a cheaper fix wins). Body
and citations below. **Be concise; a long study is not a better study.**

## Deliver

Stage **only your own file**:

```
git add -- research/Q49_FOOT_PLANTING.md
```

Never `git add -A`, and never stage `audio_exports/`. Check `git status -s`
first — another agent's work in progress may be pre-staged in this shared
checkout. **Never `git stash`, `reset --hard`, `checkout .` or `clean`** here.

Commit, push to `master`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --subject Q49-done --body "<sha> <the exact Godot 4.7 class> / <cheaper fix yes or no>"
```

Do **not** edit `HANDOFF.md` — Claude writes your block.
