# TASK G50 — GROK — WHO IS PRESSING, AND CAN IT BE MEASURED?

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. You have no checkout and no Godot; you are never given a repo
command. Deliver as **plain chat text**, pasted into the conversation.

## Why this exists — your own answer created it

**This task exists because of G49, which you just delivered.** It was accepted in
full and is being built against. You closed it with this:

> **(b)** Highest-value condition: **time since this fighter's last throw**
> (combo / burst window), then **that fighter's current volume share given range
> + who is pressing** — not "who just landed" and not a momentum flag.

We are taking that literally. The engine stage now being built replaces the
`rng.randf() < 0.5` with exactly that structure. Two of the three ingredients we
already have:

- **time since last throw** — the engine runs at 20 Hz and knows the tick.
- **range** — a real separation in metres, validated first-hand (median 0.885 m
  between scored strikes, and your own G47 confirmed the anatomy holds).

**The third we do not have at all. Nothing in this game knows who is pressing.**
There is no such quantity, no such stat, and no such flag. We have positions,
velocities, a fight plan with a cautious/balanced/aggressive pace, an aggression
axis and a `preferred_range` — and no measure of pressure.

So the conditional you told us was highest-value has a term in it we cannot
evaluate. **That is what this task is for, and it is being assigned before the
build stalls on it rather than after.**

## The question

1. **Is "pressure" a measured quantity anywhere, or is it commentary?** Be
   sceptical, exactly as you were about momentum — and if the honest answer is
   that pressure is a narrator's word with no operational definition, say so
   plainly. **That refusal is as valuable as a confirmation**, because it would
   mean the term should come out of the conditional rather than be invented.
2. **If it is measured, how?** What are the actual operationalisations — ring
   generalship scoring, forward-movement/octagon-control metrics, distance
   closed, time spent in the opponent's half, who walks whom down, cage/ropes
   time, the aggression criterion in the 10-point must? **Name the source and the
   exact definition, not the concept.**
3. **Ring generalship and "octagon control" specifically.** These are judging
   criteria, so somebody has had to define them. What is the published wording,
   and has anyone ever turned it into a number that correlates with anything?
   **Is "octagon control" as a UFC Stats field a real measurement or an abandoned
   one?**
4. **Which direction does it run?** Does pressure *cause* volume, or is
   "pressure" just what we call it afterwards when a man threw more? If there is
   evidence separating the two, that is the most valuable thing you can return.
   If the literature cannot separate them, **say NOT SEPARABLE.**
5. **Is pressure a property of a man or of a moment?** Is it a style label that
   holds for a whole career (a "pressure fighter"), a per-round state, or a
   second-by-second quantity? **We can implement any of the three; they are very
   different objects and we must not pick by taste.**
6. **What does pressure cost?** Pressure fighters are said to burn more fuel and
   to take more counters walking in. Measured, or lore? We already model fatigue
   and damage, so if there is a real cost we can price it.
7. **The minimum honest version.** If we can only afford ONE observable — and
   remember we have positions in metres at 20 Hz, so *distance closed*, *who
   advances*, and *time inside a range band* are all free to us — **which single
   observable is the best proxy for pressure, and how wrong is it?**

## Standards

- Cite sources: judging criteria as published by the ABC / unified rules, UFC
  Stats and FightMetric methodology, combat-sports analytics, fight-science
  papers, and coaching literature **clearly marked as such**.
- **Separate MEASURED from NOT PUBLISHED**, as you did in G47, G48 and G49. That
  discipline is the reason your studies are being spent against; G49's
  "NOT PUBLISHED" on P(same next) was more useful to us than a made-up number
  would have been, and it changed the design.
- **Do not propose a formula and do not write a line of implementation.** Give us
  the definitions and the evidence; the engine work is ours.
- Distinguish **boxing from MMA** where they differ — one core runs both.
- Do not reopen the metres, the IK bound, the no-reach-variants decision, or G49
  itself. G49 is settled and accepted.

## Deliverable

Plain chat text. Lead with a short table — each candidate pressure measure, its
source, its exact definition, and MEASURED / NOT PUBLISHED. Then the prose.

Close with a section headed **VERDICT** answering in one line each:
*(a) is "who is pressing" a real measurable quantity or a narrator's word*, and
*(b) the single observable we should compute from two positions at 20 Hz if we
implement only one thing.*

Verify the tier chip reads **Expert** before you submit.
