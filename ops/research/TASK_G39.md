# TASK G39 — GROK — THE CLINCH: WHAT IT SCORES, WHAT BREAKS IT, WHAT A THROW FROM IT IS WORTH

Model: **Grok, Expert (deep research).** Owner: Grok. Research only — no code,
no repo, no test command. Deliverable is one markdown file, printed **inline
in the chat as raw markdown inside a four-backtick fence**; Claude commits it.

---

## Why this is being asked BEFORE it is needed

R91 wired standing ↔ ground and left the clinch seat out on purpose. R92 adds
it: `standing → clinch/over_under` (10-tick hold, one control unit a second to
the man with the better lock), `clinch_break`, and a **throw from the clinch**
- the event `throw_points_round` has never had a writer for, and the only way
judo and wrestling can score at all. The seat is buildable today; **what it
SCORES and what ENDS it, per ruleset, is not known** and must not be invented.

## What you already own and must not re-derive

G34 (the contract: `clinch_engage`, `clinch_break`, `throw`, the seat
`over_under`, control 1 unit/s to the clinch top), G35 (the stall clock: 400
ticks first fire), G37 (the per-ruleset fold; the refused 1-D step-out), G38
(the read). Settled. The engine grades a throw 2 or 4 from `takedown_resolve`
and has no amplitude, no landing angle, no "back on the mat" fact - only a
seat reached and how long it was kept.

## What to answer, from the CURRENT rulebooks (name the edition and the article)

1. **MMA (ABC Unified Rules, 2025 amendments).** Does clinch/cage control score
   at all? What does the referee separate on, and after how long? Is a throw
   from the clinch a "takedown" for the judges' effective grappling?
2. **Muay thai (WMC / IFMA / the promotion rules a Thai stadium actually uses).**
   What scores in the clinch (knees, sweeps, throws, off-balancing), what is
   illegal (hip throws? trips?), and the referee's break - the "5 seconds" that
   primers repeat: is it published, and by whom?
3. **Judo (IJF SOR 2025-28).** Kumi-kata: grip rules, the standing stall
   (false attack, non-combativity, the time before shido), and **what makes a
   throw ippon vs waza-ari vs yuko** - from the seat and hold we CAN emit
   (side/mount/back, kept N ticks), which of those criteria can honestly be
   derived and which cannot (largely on the back? force? speed? control to the
   end?). Say which is a REFUSE.
4. **Freestyle and Greco (UWW Jan 2026).** Upper-body clinch scoring: the
   2-point takedown from a body lock, 4 for feet-to-danger, 5 for grand
   amplitude - which of these can be told from a `throw` with grade 2 or 4 and
   a landing seat, and which needs an amplitude fact the engine does not have.
5. **Duration.** Sourced clinch durations (average seconds per clinch in MMA
   and muay thai; judo grip-fighting time before an attack), so the 10-tick
   hold gate and a clinch-stall threshold are checked against something real
   rather than felt.
6. **THE ENGINE RECOMMENDATION.** In G34's vocabulary only: what the engine
   should EMIT for a clinch (engage, break, throw with grade and landing seat,
   control units) and what each of the four adapters CONVERTS it to, in the
   shape of G37's tables, with `not_scored` wherever the rulebook does not
   publish a number. Label every invention as invention.

## What good looks like

G34-G38 are the bar. A verdict table up front, sourced detail per question, an
explicit **REFUSE list** (every clinch fact we cannot derive from a seat and a
hold count - a refusal is a finding, G37 §4 is the precedent), and at most
**two open questions for the operator, each with a default**. Close with a
ready-to-paste `const` block per adapter.

## Deliverable

**ONE file: `G39_THE_CLINCH.md`.** Nothing else. Print it inline as raw
markdown inside ONE fenced block opened and closed with FOUR backticks so any
triple-backtick blocks inside survive; do NOT attach a document.

## The trap specific to this task

**The "+1 at 5 seconds" class of number.** G37 found a UWW rule that every
primer repeats and the Jan 2026 bands do not carry. The clinch is full of
these - "the referee breaks after 5 seconds", "a clinch throw is always 2" -
and a plausible unpublished number is worse than an absence. Where the
rulebook is silent, say NONE PUBLISHED and move on.
