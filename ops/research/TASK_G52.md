# TASK G52 — GROK — WHAT DOES A ROUND LOOK LIKE, MINUTE BY MINUTE?

Tier: **Expert**. Research only — no code, no module, no test.
Owner: grok. No checkout, no Godot, no repo command. Deliver as **plain chat
text**.

## Why this exists — we are about to build a shape we cannot check

Your G49 is being built into the engine right now: the coin flip that decides who
throws next is being replaced with a **burst / combination window**, conditioned
on time since that fighter's last throw. G50 removed the pressure term and G51
settled what a miss is. The design is set.

**The problem is validation.** Our validation corpus is built from published
per-fight and per-round aggregates — SLpM, accuracy, target shares, outcome
rates. **Every one of them is a total.** A total cannot tell us whether the
output arrived in bursts or in a smooth drizzle, and *the burst structure is
precisely what this stage adds.*

Worse, the corpus explicitly records **"fight-time distance/clinch/ground % =
NOT FOUND"**, so we already know the within-fight timeline is the thin part of
what is published.

So we are about to produce a temporal shape and grade it against numbers that
are blind to temporal shape. **That is how a change gets called a success
because the totals still match.** This task is being assigned before that
happens.

## The question

1. **The work-to-pause ratio inside a round.** Your G49 already cited fight
   sequences and pauses (~5 s) in Olympic boxing and 6–36 s high-intensity
   efforts from the UFC Performance Institute. **Push on that.** How much of a
   round is actual exchange and how much is circling, resetting, feinting and
   breathing? Give it as a share **with the denominator named**, boxing and MMA
   separately.
2. **How many exchanges are there in a round?** Not strikes — **exchanges**. If
   time-motion work counts activity blocks or sequences, how many per round, and
   how long is one?
3. **Does output rise or fall within a single round?** Not across rounds — we
   have that — but inside one. Is there a fast start, a lull, a final flurry as
   the ten-second clapper goes? **The last-ten-seconds flurry is a strong piece of
   coaching and broadcast lore; is it measured anywhere?**
4. **How much of the round are the two men even in range?** Our engine refuses
   any strike beyond 1.1 m and measures 35% of ticks inside that gate. Is there a
   published figure for time spent within striking distance in boxing or MMA? If
   it is NOT PUBLISHED, say so — we would rather know the number does not exist
   than have it approximated.
5. **What ends an exchange?** G49 said P(same thrower next) falls toward baseline
   "once the exchange has closed". **What closes it** — a clean counter, one man
   stepping out, a clinch, the referee, exhaustion? Is there any measured
   distribution of exchange-ending events, or is this coaching lore only?
6. **Round length and the shape it forces.** Boxing's 3 minutes versus MMA's 5.
   Does the longer round change the burst structure or just add more of the same?
7. **The one check.** If we can compare our simulated round against ONE published
   temporal quantity, which is it — and what value should we expect?

## Standards

- Cite sources: time-motion analysis, notational analysis, UFC Performance
  Institute, CompuBox round-level work, and coaching/broadcast literature
  **clearly marked as such**.
- **Separate MEASURED from NOT PUBLISHED.** Two of your five studies came back as
  refusals and both were acted on within the hour; a negative here is a real
  result and stops us grading against something invented.
- **Name the denominator beside every share.** A share against the wrong
  denominator has already cost this project real time once — an 8.8% figure whose
  true value was 83.9%.
- Do not propose a formula, do not write implementation.
- Distinguish boxing from MMA. Do not reopen the metres, the IK bound, G49, G50
  or G51 — all settled.

## Deliverable

Plain chat text. Lead with a table — each temporal quantity, source, exact
definition, value with denominator, MEASURED / NOT PUBLISHED. Then prose.

Close with **VERDICT**: *(a) is the within-round temporal shape of a fight
published anywhere in usable form*, and *(b) the single temporal quantity we
should grade our simulated round against, and the value to expect.*

Verify the tier chip reads **Expert** before submitting.
