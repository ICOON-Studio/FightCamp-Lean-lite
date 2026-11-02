# TASK J19 — JOHN — WHAT JOINS FOURTEEN CLIPS INTO A FIGHT?

Research only. No code, no repository access, no test command.
Owner: john. Deliverable: `research/J19_THE_JOINS.md`.

## Why this exists

Between J17, J18 and two art desks, **the shopping list is settled**: roughly
fourteen clips — one idle, four in-place locomotion cycles, three or four punch
types, two reactions, three knockdown states. That is a decision we can spend
against, and your two memos are half of why.

**What nobody has costed is the joining.** Fourteen clips are not a fight; they
are fourteen clips. The fight is what happens *between* them — how a circling
man becomes a man throwing a hook, how a hook becomes a man taking one back, how
a reaction returns to a stance. **If the joins are wrong, fourteen perfect clips
still read as a slideshow**, and no amount of extra buying fixes it.

## The constraints that make this our problem and not a generic one

- **The engine owns translation absolutely.** Clips are in-place, no root
  motion. The sim decides where both bodies are at 20 Hz; animation only decides
  what they look like. (G42, not reopenable.)
- **A beat is a 14-second window** and a punch clip is under a second. A
  measurement today put **~84% of presented fight-time with no strike clip to
  play** — the locomotion cycles fill it. So the common transition is not
  punch→punch; it is **cycle → punch → cycle**, thousands of times a fight.
- **Intent changes often.** The engine re-decides between `close`, `hold`,
  `retreat` and `circle` on a fast cadence, so cycle→cycle transitions are
  probably more frequent than anything else.
- **No motion matching.** It has been refused, and your J18 cited the reason —
  Epic's melee sample needs 65 locomotion files before anything else.

## The question

1. **What is the actual mechanism?** Crossfade, blend tree, additive layer,
   state machine with transition rules, animation notifies? Name what shipped
   fighting and melee titles use to get from a locomotion cycle into an attack,
   and back. **Is the attack a full-body clip that interrupts, or an upper-body
   layer over a continuing lower-body cycle?** That second option would let a man
   keep his feet moving while he punches, which is what boxers actually do — say
   whether it is standard practice or a trap.
2. **Blend durations.** What crossfade lengths do shipped titles use for
   cycle→attack, attack→cycle, and cycle→cycle? Give numbers in milliseconds or
   frames if published. This is the single most actionable number you could
   return.
3. **Can you interrupt an attack?** When a man is hit mid-punch, does the punch
   clip abort into the reaction, blend out, or play to completion? Our engine
   scores impacts continuously and will absolutely produce a hit during someone
   else's punch — **so what a title does here is a rule we will have to copy or
   deliberately refuse.**
4. **What must be authored INTO a clip for it to join well?** Do shipped
   locomotion cycles and attacks share a common start/end pose so they can be cut
   rather than blended? If there is a convention — everything begins and ends at
   a neutral stance — that is a purchase specification we should apply when
   buying, and we would rather know it before we spend than after.
5. **The cost of getting it wrong.** What does a badly joined fight look like,
   in the words of people who shipped one? Popping, sliding, a floaty
   double-step, a punch that starts from the wrong foot. Which of those is worst
   at a **fixed camera 9–11 m out**, which is where ours sits.
6. **Is any of this a PURCHASE?** Do transitions ever need their own clips — a
   plant, a step-out, a recovery — or are they always made from what you already
   own? **Answer this one plainly**, because it is the only part of this memo
   that changes the number of credits we spend.

## Standards

- Cite sources and grade them as you did in J15/J17/J18 (DIRECT / INHERITED /
  UNVERIFIED_SECONDARY / UNKNOWN). **Say NOT FOUND where it is not found** — a
  fabricated blend duration would be acted on directly.
- Do not price anything, do not name a vendor, do not write GDScript, and do not
  design an animation graph — describe what titles do, and let Claude decide.
- Do not reopen J17's or J18's decisions, the camera, or the no-root-motion rule.

## Deliverable shape

`J19_THE_JOINS.md`, with a **DECISIONS** section at the top — typeable lines,
including the blend durations, a yes/no on upper-body layering, the
interrupt rule, and the one-line answer to question 6. Body and citations below.

Land it the way you landed J15–J18 (deliverable plus `CLAUDE_LAND_NOTE_J19.md`).
**Do not edit `HANDOFF.md`** — Claude writes your block.
