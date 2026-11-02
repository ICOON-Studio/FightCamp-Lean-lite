# TASK G51 — GROK — WHAT IS A MISS, AND DOES A SIMULATOR NEED ONE?

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. You have no checkout and no Godot; you are never given a repo
command. Deliver as **plain chat text**, pasted into the conversation.

## Why this exists — two of our own measurements disagree with the world

**Our engine has no miss.** A strike either happens and lands, or it is never
built. There is no attempt that fails, and that was a deliberate ruling (U23:
"no miss roll") made when the engine was much simpler.

Two measurements have now walked into the consequences:

1. **Q39** measured our engine in UFC units and reported **accuracy 57.1%** in
   both boxing and MMA. **J20** — the validation corpus — says real significant
   strike accuracy is **~40–49%**. Ours is high, and it is high in a suspicious
   way: **identical across two rulesets**, which is what a number that is not
   really being modelled looks like.
2. **Q39 could not derive "significant strikes" at all** — no filter exists —
   and could not derive strike types. Those are the two units the real
   statistics are actually counted in.

The operator's bar for this simulator is that **the UFC should be able to use it
to see how fights can go.** Every published rate we would be judged against —
SLpM, accuracy, significant strikes — is a ratio whose **denominator is attempts,
including the ones that missed.** We currently have no denominator.

**Before we build a miss, we want to know what one is.** The engine stage now
being written (R101) makes the engine name an actual technique for the first
time, which is the moment a miss becomes expressible. This question is being
asked now, before that stage forces an answer by accident.

## The question

1. **What exactly is counted as a "landed" strike, and by whom?** Give the
   operational definitions, not the concept: CompuBox's connect/miss for jab and
   power; UFC Stats / FightMetric's *significant* vs *total* strikes. **What
   makes a strike "significant"?** — this is the single most useful definition
   you can return, because we must match it to be scored against their numbers.
2. **How is a miss actually coded?** Is a blocked strike a miss? A partially
   blocked one? A strike that is slipped? One thrown at nobody, into the air, to
   maintain distance? **Do the counters distinguish blocked from evaded from
   never-close, or is it all one bucket?** If they do not distinguish, that is
   very good news for us and you should say so plainly.
3. **The real numbers, boxing and MMA separately.** Attempted and landed rates,
   accuracy by strike type (jab vs power vs kick), and by target and position if
   published. **We need the DENOMINATOR named in every rate you give us** — this
   has already cost this project real time once, when a share was computed
   against the wrong denominator and was an order of magnitude out.
4. **Is accuracy a property of the thrower, the receiver, or the exchange?**
   Does the literature attribute a miss to the man who threw it (bad technique,
   wrong range, fatigue) or to the man who avoided it (defence, head movement,
   guard)? **We model both sides and can price it either way, so the evidence
   here directly decides where the number goes.**
5. **Does the intended target change accuracy?** Head versus body versus leg —
   and does a strike thrown in a combination land more often than the same strike
   thrown alone? G49 already found one data point on this (a jab is 48.8%
   accurate inside a combination against 45.4% alone). **Is that a general
   finding or a single study?**
6. **Do serious fight models simulate misses explicitly, or fold them in?** A
   simulator can either roll an attempt and then roll whether it lands, or emit
   only landed strikes at a lower rate and reconstruct attempts afterwards.
   **Both produce the same landed count. What do models that people take
   seriously actually do, and what does each choice cost or buy?** Be concrete
   about what is LOST by never emitting a miss — because that is exactly our
   current position and we want it argued, not assumed.
7. **What can a viewer see?** A miss that nobody watches is only a statistic. Is
   the visible miss — the slip, the block, the punch that sails past — a large
   part of what makes a fight look like a fight?

## Standards

- Cite sources: CompuBox and UFC Stats / FightMetric methodology, fight-science
  and notational-analysis papers, combat-sports analytics, and coaching
  literature **clearly marked as such**.
- **Separate MEASURED from NOT PUBLISHED**, as you did in G47, G48, G49 and G50.
  Two of those four came back as refusals and both were acted on immediately —
  a negative answer is a real deliverable here and is not a failure.
- **Name the denominator beside every rate.**
- Do not propose a formula and do not write implementation. The engine work is
  ours.
- Distinguish **boxing from MMA** throughout — one core runs both.
- Do not reopen the metres, the IK bound, the no-reach-variants decision, G49 or
  G50. All are settled.

## Deliverable

Plain chat text. Lead with a short table: each counted quantity, its source, its
exact definition, its real-world value with the denominator named, and MEASURED /
NOT PUBLISHED. Then the prose.

Close with a section headed **VERDICT** answering in one line each: *(a) what
precisely makes a strike "significant"*, *(b) should a fight simulator emit
misses explicitly or fold them into a lower landed rate*, and *(c) if a miss is
attributed to one man rather than the exchange, which man does the evidence
favour.*

Verify the tier chip reads **Expert** before you submit.
