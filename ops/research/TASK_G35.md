# TASK G35 — GROK — THE REFEREE, AND THE FIFTH METHOD

Model: Grok, deep research. Owner: Grok. Research only — **no code, no repo, no
test command.** Deliverable is one markdown file.

---

## Why this exists

Your own G34 contract is being built right now: Qwen has `GrappleSeat.gd`,
Cursor has `GrappleResolve.gd`, Codex is writing the blind contract test. G34
is good enough that all three could start from it directly.

It leaves two things the build will hit within a day, and neither is in it —
by design, because G34 was scoped to the grappling contract itself.

**The standing rule here is that research is assigned BEFORE the question
arises.** A question put to the operator is a research task somebody failed to
assign in time. These two are that forecast.

## Question one — HOW DOES A GRAPPLING CONTEST END?

The real-time engine currently knows exactly four ways a fight ends, and they
are the atomic engine's own words:

```
METHOD_KO       := "KO"
METHOD_TKO      := "TKO"
METHOD_DOCTOR   := "DOCTOR STOPPAGE"
METHOD_DECISION := "DECISION"
```

There is no submission. G34 §5 establishes the RATE (about one MMA fight in
five, 19.3% over 8,591 UFC bouts) and the attempt/finish split, but not the
vocabulary or who owns it.

Answer, with sources:

1. **What is the minimum set of additional end-methods** across the rulesets
   this game already carries — MMA (Unified/ABC), judo (IJF), freestyle
   wrestling (UWW), BJJ (IBJJF)? Submission is obvious. Is ippon a method or a
   score that reaches a threshold? Is a points decision in a grappling match the
   same `DECISION` we already have, or a different thing? Where do technical
   superiority, injury default, disqualification and no-contest sit?
2. **Which of those are ENGINE and which are ADAPTER?** G34's own governing
   inference is that the engine emits one neutral fact and the ruleset adapter
   converts it — one stability gate in the engine, ruleset-specific conversion
   outside. Apply that same test to each method and say which side it falls on.
   A method the engine must name is expensive; one an adapter derives is cheap.
3. **Does a submission finish need anything the impact log cannot already
   carry?** Be specific about the record shape.

## Question two — WHO INTERVENES WHEN NOTHING IS HAPPENING?

This is the one that will bite first, and it is entirely absent from G34.

A seat model with a stability gate and no referee produces a fighter who takes
guard in round one and is still there at the final bell, because nothing in the
system has any reason to make him move. Every real ruleset has an answer to
this and they are all different.

Answer, with sources:

1. **MMA (Unified/ABC):** the stand-up. When may a referee stand two men up,
   what is the actual standard, and how often does it happen in practice? A
   real per-round figure is worth more than the rule text.
2. **UWW freestyle:** passivity, the shot clock, the 30-second activity period
   and the point that follows a failed one. This is a TIMED mechanism, which
   makes it the closest to something the tick engine can hold directly.
3. **IBJJF:** stalling penalties, advantages, and what a referee does about a
   closed guard that goes nowhere.
4. **Judo (IJF):** shido for non-combativity, the matte/osaekomi cycle, and how
   ne-waza is broken off when it stops progressing.
5. **The cross-cutting answer:** is there ONE neutral engine-side mechanism —
   something like "N scoring ticks with no position change and no submission
   attempt" — that all four adapters can convert into their own intervention?
   That is the shape G34 found for the stability gate, and if the same shape
   works here it is worth far more than four separate rules. **If it does not
   work, say so plainly** — a forced unification that fits none of them is
   worse than four honest cases.

## What good looks like

G34 is the bar and it is the one to copy: sourced, specific, willing to state
an inference AS an inference, and ending in a contract a build task can be
typed from. Its "Refuse" section was as valuable as the rest — **say what we
should NOT model**, and why.

Close with:

* **A proposed method vocabulary** as exact strings, in the style of
  `METHOD_KO` above, with the engine/adapter split marked per entry.
* **A proposed intervention mechanism** with its threshold in TICKS at 20 Hz
  (never a float clock — the engine stores integer tick time and derives
  seconds, never the reverse).
* **At most two open questions for the operator, each with a default
  recommendation**, exactly as G34 §9 did. If you can decide it, decide it.
  Everything else on the page should be a decision, not a question.

## Deliverable

**ONE file: `research/G35_REFEREE_AND_METHODS.md`.**

Nothing else. **You have no checkout and no Godot** — do not write GDScript, do
not propose a preload, and do not expect to run anything. If a module shape
falls out of the research, name it and describe it the way G34 §8 did; someone
with a checkout will build it.

## The trap specific to this task

**Do not re-open grappling scoring.** G34 settled the seats, the events, the
counters, the position-point table and the submission rate, and three agents
are building against it as you read this. Changing any of it now would strand
their work. If you find something in G34 that you now believe is wrong, **say
so in a clearly-marked section at the end** rather than quietly re-specifying
it — a contract that moves under a build in flight is worse than a contract
with a known flaw.
