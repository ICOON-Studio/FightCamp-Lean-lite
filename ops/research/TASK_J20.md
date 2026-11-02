# TASK J20 — JOHN — THE REAL NUMBERS WE MUST MATCH

Research only. No code, no repository access, no test command.
Owner: john. Deliverable: `research/J20_THE_VALIDATION_CORPUS.md`.

## Why this exists — the bar just moved

The operator's standard for this simulator, in their words: **the UFC should be
able to use it to see how fights can go.**

That is a fidelity standard, and it has one hard consequence. A simulator is
"real" when its **outputs match the outputs of real fights** — not when its
internals feel plausible. Today we checked two of our numbers against the real
world for the first time and found we move at **2.26× a real fighter's pace**.
Everything else in the engine is unvalidated.

**This memo builds the scoreboard.** Your job is not to judge our engine — it is
to assemble the published real-world numbers we must be held against, with
citations, so that every future change can be scored rather than argued about.

## What to collect

For **UFC / MMA** primarily, and boxing where it is cheap to add:

1. **Striking volume and accuracy.**
   - Significant strikes landed per minute (SLpM) and absorbed per minute
     (SApM), with typical ranges and the divisional spread.
   - Significant striking **accuracy %** and **defence %**.
   - Total strikes versus significant strikes — say clearly how the statistic is
     defined, because we will be compared against the definition, not the word.
2. **Target distribution.** Significant strikes by target: **head / body / leg**,
   as published percentages. This is a direct check on a number we already
   measure (we currently emit head 65.3% / torso 28.2% / leg 3.2%).
3. **Position distribution.** Share of fight time at **distance / in the clinch /
   on the ground**, and control time. We model all three and have never checked
   the split.
4. **Takedowns.** Attempts per 15 minutes, **takedown accuracy %**, takedown
   defence %, and submission attempts per 15 minutes.
5. **Outcomes.** Finish rate overall; the split between **KO/TKO, submission and
   decision**; **the distribution by round**; and the share of decisions that are
   split or majority. We can check every one of these.
6. **Knockdowns.** Knockdown rate per fight or per 15 minutes. **We currently
   produce a knockdown in 41.5% of bouts and that looks high** — this is the
   citation that will settle it.
7. **Boxing equivalents** where they exist cheaply: punches thrown and landed per
   round (CompuBox), connect percentages by punch type (jab versus power), and
   knockdown/stoppage rates.

## Standards — and these matter more than usual here

- **Grade every number** the way you did in J15/J17/J18: DIRECT / INHERITED /
  UNVERIFIED_SECONDARY / UNKNOWN. **Say NOT FOUND rather than inventing.** A
  fabricated benchmark is worse than no benchmark, because we would tune a real
  engine to match a number that does not exist.
- **State the DEFINITION and the DENOMINATOR of every statistic** — per minute,
  per 15 minutes, per fight, per round; significant or total; landed or thrown.
  This project lost real time today to a percentage divided by the wrong thing,
  twice. A benchmark without its denominator is not a benchmark.
- **Name the population.** UFC-wide, a single division, a date range, men or
  women. Our twelve fighters span boxing and MMA, male and female, so a
  benchmark that silently describes only male lightweights will mislead us.
- Give the **spread**, not only the average. We need to know whether a value is a
  tight distribution or a wide one, because matching a mean while producing no
  variance is its own failure.
- Do not price anything, do not name a vendor, do not write GDScript, and do not
  propose engine changes. **Collect and cite.**

## Deliverable shape

`J20_THE_VALIDATION_CORPUS.md`, and the most useful form is **one big table**:
metric, value, spread, population, definition, denominator, source, grade. That
table becomes the scoreboard we run our engine against for the rest of the
project, so its structure matters as much as its contents.

Put a **DECISIONS** section at the top listing the handful of metrics you judge
**most diagnostic** — the five or six that, if we matched them, would most
justify calling the simulation realistic. Claude will build the harness against
those first.

Land it the way you landed J15–J19 (deliverable plus `CLAUDE_LAND_NOTE_J20.md`).
**Do not edit `HANDOFF.md`** — Claude writes your block.
