# TASK Q57 — QWEN — MAKING A HUNDRED CLIPS LOOK LIKE FIVE HUNDRED

Model: your default, medium effort. Owner: qwen.
Test tier: **RESEARCH — NO `.gd` TOUCHED, SO NO GATE AT ALL.** No parse gate, no
test, no suite. `git status -s` before staging is the whole check.
**Do NOT launch Godot** — a full test suite is about to run in this checkout and
only one Godot may run at a time. This task needs none.

## Owned files

- `research/Q57_VARIETY_WITHOUT_BUYING.md` — **NEW. Yours alone.**

Nothing else. Do not edit `HANDOFF.md`, `CURRENT_STATUS.md`, `TASKS.md`, any
`.gd` file, or any other research doc.

## Why this exists

The operator's direction today: **"I want to see as many animations as possible,
make the fighters intelligent with many skills available to them."**

Your own Q56 found the ceiling: **160 clips owned, 19 in use, 102 that could play
once the vocabulary is widened.** Widening the vocabulary is being done. This task
asks the question that comes AFTER it, and it is worth more than the next
purchase:

**How much variety can 102 clips be made to carry?**

We already do two of the cheap multipliers and they worked:
- **U40** sliced one 2.47 s combo file into three separate punches on measured
  retractions — one file became three techniques.
- **U41** mirrored those three sagittally — three became six, for nothing.

`FightStagePlayer` already supports **several takes per role** and cycles them
round-robin (`_variants`, `:29`) — deliberately NOT at random, because a seeded
fight must replay byte-identically. `react_body` has 7 takes, `react_head` 4,
`react_leg` **1**, and `block` **1**.

## THE QUESTION, IN FOUR PARTS

### Q1 — `AnimationTree` and blending (DOCUMENTED, Godot 4.x)

What does Godot 4.x actually give us, and what does each cost?
`AnimationNodeBlend2`, `AnimationNodeBlendSpace1D` / `2D`, `AnimationNodeAdd2`,
`AnimationNodeOneShot`, `AnimationNodeTransition`, `AnimationNodeStateMachine`.

**Name the node and the property, not the idea.** For each, say: what it does,
what it costs at runtime, and **whether it is deterministic** — that last one is
load-bearing, because a seeded fight has to present identically twice and
anything that reads wall-clock or RNG is disqualified outright.

Say explicitly whether an `AnimationTree` can be driven **without a scene tree
frame** — several of our tests run headless with no frame, and R103 already found
that `global_position` stays at the origin in that situation.

### Q2 — Additive layers (DOCUMENTED)

`AnimationNodeAdd2` on top of a base clip is how a lot of games get "the same
punch, but tired" or "the same guard, but hurt". Does Godot 4.x support additive
blending against a **reference pose**, and what exactly is the reference —
the rest pose, or a named clip? This matters to us because we have a `T_pose.fbx`
in the pack and a documented rest-pose correction already shipping.

**If additive works, one fatigue layer multiplies every striking clip we own by
the number of fatigue states the engine models.** Say whether that is real or
whether it needs authored additive clips we do not have.

### Q3 — Timing and speed variance (DOCUMENTED + INFERENCE)

`AnimationPlayer.speed_scale` and `Animation.loop_mode` are free. **How much can
a strike's playback rate move before it reads as wrong?** Find what is published
on this — animation programming references, GDC material, fighting-game
post-mortems — and say what the honest range is. If nothing is published, say
**NOT FOUND** and give your own reasoning marked as INFERENCE.

The engine already knows each fighter's `speed` stat and their current fatigue.
**If ±15%% is safe, every clip we own becomes a family.** If it is ±3%%, it is
not worth the wiring. That number is the deliverable of this section.

### Q4 — What do fighting games actually do? (DOCUMENTED where possible)

Not "what is possible" — what shipped titles do to avoid the same film twice.
UFC, EA Sports MMA, Tekken, Street Fighter, For Honor. Look for: per-hit variant
sets, blend-out-early-on-interrupt, procedural hit reactions, ragdoll blending,
IK-driven contact correction.

**Rank what you find by cost-to-us, cheapest first**, given that we are one
developer's worth of budget with 102 clips and no animator.

## HOW TO ANSWER

Label every claim **DOCUMENTED** (with the source), **INFERENCE** (marked as
yours) or **NOT FOUND**. Your Q50/Q51/Q54/Q55/Q56 labelling was exactly right and
it is why those studies were usable.

Finish with **a ranked list: the top five things we could do to multiply apparent
variety, cheapest first, each with what it costs and what it buys.** That list is
the deliverable; everything above it is support.

Keep it under ~180 lines.

## Definition of done

- `research/Q57_VARIETY_WITHOUT_BUYING.md` exists and answers Q1-Q4.
- `git add -- research/Q57_VARIETY_WITHOUT_BUYING.md`, commit, push to master.
- Send one line:
  `python Tools/agent_comms.py send --from qwen --to claude --subject Q57-done --body "<sha> <the cheapest multiplier and what it buys, one line>"`

## The traps specific to Q57

1. **Do not run Godot.** A suite is running. You need none.
2. **Do not read `HANDOFF.md`, `CURRENT_STATUS.md` or any digest.** This file is
   self-contained. `Godot/scripts/FightStagePlayer.gd` (489 lines) is safe to read
   whole if you want the variant machinery; nothing else is needed.
3. **DETERMINISM IS A HARD GATE, NOT A PREFERENCE.** A seeded fight must present
   byte-identically on two runs — R82 spent an entire stage proving it does.
   `FightStagePlayer` cycles its takes round-robin rather than randomly for
   exactly this reason. **Any technique you recommend that needs RNG, wall-clock
   time or frame-rate-dependent state is disqualified, and you must say so
   beside it rather than recommending it with a caveat.**
4. **We have no animator and no authoring budget.** A recommendation that starts
   "author a set of additive clips" is not free and must be priced as such. Say
   plainly which of your five need new ART and which are pure code.
