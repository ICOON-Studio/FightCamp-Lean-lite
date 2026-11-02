# TASK G34 — GROK — GRAPPLING IN A REAL-TIME TICK ENGINE: THE CONTRACT STUDY

Model: Grok, high effort. Owner: Grok. Deliverable: **ONE new file**,
`research/G34_GRAPPLING_CONTRACT.md`. A study, not code.

**Reassigned from Kalli to Grok, 2026-09-09** (operator decision). Nothing about
the work changes: Grok has no checkout either, so the same no-git, no-test-command
constraints hold, and this is reasoning and writing rather than code.

---

## Why this is being asked BEFORE anybody builds grappling

Grappling is now the single largest block in the fight, and **there is no study
behind it at all** — checked 2026-09-09. It blocks three separate things:

1. **`FightSimulation.gd` cannot be retired.** R85 re-pinned the judge scorecards
   against the real-time engine and could only do seven of ten bouts. The other
   three stay on the old atomic engine, so the game carries two fight engines.
2. **Three rulesets cannot be scored at all.** judo, taekwondo and freestyle
   wrestling weight `damage` at 0.0 and score from `positions`, `throws`,
   `submissions` and foot zones — every one of which the real-time log emits as
   zero. Taekwondo is the sharp case: run through the real-time engine it
   produces `16-9/13-6/7-11`, which LOOKS like a taekwondo score and is entirely
   body *punches*, because head kicks (3) and body kicks (2) are unproducible.
3. **MMA is half-scored.** Its profile weights `control` 0.9, `takedowns` 3.0,
   `positions` 1.0 and `submissions` 1.5, and the engine emits none of them.

The rule here is that a question put to the operator is research that was not
assigned in time. This is that research, assigned before the build needs it.

## What the engine looks like today (so the study fits it)

The real-time core runs a **fixed 20 Hz tick**, is **fully deterministic from a
seed**, and stores positions in **fixed point** — a float carried across 18,000
ticks was explicitly ruled out. Each subsystem draws from **its own named RNG
stream** so that adding one cannot perturb another, and an impact takes exactly
seven draws. Two fighters hold a position on a 1-D line plus a `body_condition`
of six continuous regions. Damage is emitted as an impact record with a target
region and a contact word.

Every number the fight produces reaches the judges through **one adapter** that
folds the impact log into per-round counters. Those counters already have named
slots sitting at zero for `control_score`, `takedowns_round`,
`position_points_round`, `submission_attempts_round` and `throw_points_round`.
**The slots exist; nothing fills them.**

## What the study must answer

1. **What is the minimum vocabulary of grappling EVENTS** a tick engine must emit
   to fill those five counters honestly? Name each event, what triggers it, and
   which counter it feeds. Fewer, well-chosen events beat a taxonomy.
2. **What is the state?** Standing/clinch/ground is the obvious answer; say
   whether it is enough, what positions are worth distinguishing, and what a
   position transition costs. Be concrete about how a position is *held* over
   time, because `control_score` is a duration, not an event.
3. **How does a takedown attempt resolve** from attributes we already have
   (`grapple`, `power`, `technique`, `speed`, `defense`, `fight_iq`,
   `conditioning`) plus one roll? The house pattern is that the CALLER owns the
   randomness and a module takes the roll.
4. **What does grappling cost in stamina, and what does it do to attrition?**
   A round of being held down is not a round of being punched, but it is not free
   either.
5. **Submissions: how does an attempt differ from a finish**, and what makes a
   finish rare enough to be real? Give a target rate and say where you got it.
6. **The three federation rulesets**: what does each actually need to be scorable
   — judo's ippon and waza-ari, wrestling's exposure and step-outs, and BJJ's
   passes and sweeps? Map each to the vocabulary from question 1.
7. **What should we REFUSE to model?** This matters as much as the rest. A
   previous teardown was valuable precisely because it named what real fighting
   games decline to simulate. Say what is out of scope and why.

## How to answer it

Ground it in real sources: the actual scoring rules of the sports (IJF, UWW,
IBJJF, WKF, unified MMA rules) and how fight games and fight sims have modelled
grappling — what they represent, what they abstract, what they refuse. Compare at
least two different approaches and say which suits a deterministic 20 Hz tick
engine, with reasons.

**Give a recommendation, not a survey.** The deliverable's job is to let the next
build task be written from it without further questions, so end with a concrete
proposed contract: named events, named states, named counters, and the one or two
open questions genuinely left for the operator.

Where you are inferring rather than citing, say so in that sentence.

## What you do NOT do

- **No code.** This is a study. No `.gd` files.
- **No git, no test command, no `agent_comms.py`.** You have no checkout.
- **Do not edit `HANDOFF.md`** — Claude writes your block.
- Deliver `research/G34_GRAPPLING_CONTRACT.md` as the file itself.
