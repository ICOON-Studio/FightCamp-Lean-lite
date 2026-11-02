# TASK J21 — JOHN — WHAT IS A "MOVE", AND WHAT DOES A FIGHTER CHOOSE BETWEEN?

Research only. No code, no repository access, no test command.
Owner: john. Deliverable: `research/J21_THE_MOVE_PALETTE.md`.

## Why this exists — a gap that blocks two separate goals at once

The operator wants two things:

1. **The simulator should be good enough that the UFC could use it** to see how
   fights can go.
2. **Fighters should make their own decisions by selecting from a palette of
   moves.**

A measurement (Q39) has just shown these are the same problem. Asked to report
our engine's output in UFC units, it returned a list of things it **could not
derive**, and the first two were:

> **significant strikes** — no filter exists
> **strike types** — no punch / kick / knee / elbow distinction

**Our engine has no concept of a technique at all.** It picks a *body region* and
a *force*, and that is the whole vocabulary. "A strike landed on the leg" does not
mean a leg kick — it means force arrived at a leg, and nothing in the engine
knows or cares what threw it.

That single absence blocks:
- **UFC-grade validation**, because the real statistics are counted by technique
  and by significance, and we can express neither;
- **the animation purchase**, because we are buying `jab`, `cross`, `hook`,
  `uppercut` — clips for techniques the engine cannot name;
- **the operator's palette**, which is precisely the missing primitive.

So the move palette is not a feature request. It is the thing under both goals.
**Before we design it, we need to know what a "move" actually is in a fight
simulation that people take seriously.**

## The question

1. **What is the unit?** In fight simulators, combat sports games and academic
   fight models, what is the atomic thing a fighter chooses — a named technique
   (`jab`, `low kick`, `double leg`), a category (`straight`, `hook`, `kick`), or
   a set of properties (range, commitment, target, risk) with no name at all?
   **Which representation do the ones regarded as realistic use?**
2. **How big is the palette?** How many distinct choices does a fighter actually
   have at a given moment in the models you find — five, twenty, a hundred? And
   is the palette **fixed**, or does it change with range, stance, position and
   fatigue?
3. **What properties does a move carry?** For each technique, what does a serious
   model attach — reach, speed/startup, recovery, damage, accuracy, stamina cost,
   the target it can reach, what it beats and loses to? **Name the minimum set
   that makes a simulation behave differently from one that just rolls dice.**
4. **How is a move CHOSEN?** Weighted random by situation, utility scoring,
   behaviour tree, learned policy? What do fight-analytics models and the more
   simulation-minded games actually do — and, importantly, **what makes a choice
   look like a fighter's style rather than a dice roll?** We already model
   attributes, fatigue, damage and range; the question is how those become a
   preference over techniques.
5. **"Significant strike" — the definition.** UFC Stats counts significant
   strikes and this is the benchmark we will be scored against. **What exactly
   qualifies?** Is it a technique class, a power threshold, a position rule, or a
   scorer's judgement? We must know before we can claim to produce the statistic.
6. **The grappling half.** A takedown, a sweep, a submission attempt and a
   positional advance are moves too, and we already model those seats. Does the
   literature treat striking and grappling as one palette or two, and does a
   fighter choose between them the same way?
7. **What is NOT worth modelling.** The most valuable answer in this memo may be
   the refusals. Which distinctions do serious models deliberately collapse
   because they change nothing — and where does a bigger palette stop buying
   realism and start buying maintenance?

## Standards

- Cite and grade as in J15/J17/J18/J20 (DIRECT / INHERITED /
  UNVERIFIED_SECONDARY / UNKNOWN). **Say NOT FOUND rather than inventing.**
- Where you cite a game, say whether the source is a developer talk, a datamine,
  or journalism — and do not treat a marketing "over 60 punches" line as a model.
- Do not write GDScript, do not design our implementation, do not propose an
  enum. **Describe what exists and let Claude design.**
- Do not reopen J17/J18's purchase decisions or the camera work.

## Deliverable shape

`J21_THE_MOVE_PALETTE.md`, with a **DECISIONS** section at the top: typeable
lines — the recommended representation, the palette size, the minimum property
set per move, the selection mechanism, the significant-strike definition, and the
one-line answer to question 7. Body and citations below.

Land it the way you landed J15–J20 (deliverable plus `CLAUDE_LAND_NOTE_J21.md`).
**Do not edit `HANDOFF.md`** — Claude writes your block.
