# TASK Q42 — QWEN — GRADE OUR ROUND AGAINST THE ONE PUBLISHED TEMPORAL CHECK

Model: Qwen, `--yolo`, **medium** effort.
Owner: qwen. Deliverable: `research/Q42_THE_ROUND_SHAPE.md` plus the
harness extension that produced it.

Tier: **YOUR OWN TOOL AND A DELIVERABLE, NO SCRIPT EDITED.** Parse gate on what
you touch, then run your own harness. **Do NOT run the full suite.**
`Godot/scripts/` is off-limits — R101 owns the fix.

## Why this exists — a study landed after your harness was specified

Q40 (`86373c0`) and Q41 (`0de86f0`) are both accepted in full. Between them they
give R101 its before-picture on three of four axes.

**The fourth arrived late.** Grok's G52 (`G52_THE_SHAPE_OF_A_ROUND.md`) was
assigned and delivered *after* Q40 was written, and it answers the question Q40's
burst section could not: **what should a round's temporal shape actually look
like?**

Its verdict (a) is that within-round timelines are **NOT PUBLISHED** — no minute
splits, no last-10-s rate, no metres-in-range. **A sim can match SLpM and still
be a drizzle.** But its verdict (b) names the one check that does exist:

> Grade a simulated **MMA 5-minute standing-heavy round** against the **UFC
> Performance Institute block: high-intensity 6–36 s, then low/moderate 2–3x
> that duration, repeating.** Expect on the order of **6–10 HI blocks per 5 min**
> at the middle of the band (≈15 s HI / 30–45 s LO).

Your Q40 burst section used an **AUTHORED 40-tick (2.0 s) threshold** and
reported 22,456 bursts with a median of 4 impacts and a mean of 7.0. **That is a
different object from a UFC PI high-intensity block** — yours separates
in-combination cadence from between-exchange resets at the *impact* grain; the PI
block is an *activity* grain lasting tens of seconds. **Do not rename one into
the other.** G52 is explicit that the combination window (~1 s) and the burst
(6–36 s) are two different timescales and must not be conflated.

## What to do

**Report our engine's round shape at the PI grain, per round, for MMA.**

1. **Segment each round into high-intensity blocks and low/moderate stretches**,
   at a threshold you choose and **label AUTHORED**, justified in one line. It
   will not be 40 ticks — that is the combination grain.
2. **Report, per 5-minute round:** number of HI blocks, HI block duration
   (median and range in seconds), LO stretch duration, and the **HI:LO ratio**.
3. **Grade against G52's target** and say plainly whether we pass:
   - HI blocks per round: **expect 6–10**
   - HI block duration: **expect 6–36 s**
   - LO stretch: **expect 2–3x the HI duration**
   - G52's other measured comparator: MMA HI:(LO+pause) runs **1:2 to 1:4** of
     in-round time.
4. **Report it as a CEILING/FLOOR judgement, never as pass/fail on an exact
   number.** If we sit outside a band, that is a finding for R101 to move, not a
   defect to tune away — and you are forbidden from tuning it.

## The three things G52 explicitly forbids, and they are the trap

1. **DO NOT grade against time-in-range.** Our engine measures 35% of ticks
   inside the 1.1 m gate. Pro boxing notational work reports direct contact at
   **35.6% of scheduled fight time**. **These are NOT the same quantity** —
   contact-time is not a metre gate — and the near-match is a coincidence.
   Citing one against the other would repeat the 2026-09-10 error of comparing
   hand travel with centre-to-centre separation. **Say so in the deliverable so
   the next reader is warned.**
2. **DO NOT grade against last-10-seconds output.** NOT PUBLISHED; the flurry is
   broadcast lore.
3. **DO NOT carry boxing's 18:1 activity ratio to MMA.** Different denominators,
   different constructs. We are grading MMA.

## The rules that got Q40 and Q41 accepted — keep every one

- **Name the denominator in the same sentence as every percentage.**
- **Label every choice AUTHORED**, as you did the 40-tick threshold.
- **Report `measured-at=<sha>`.**
- **Extend `Godot/tools/measure_exchange.gd`** — one instrument, do not fork.
- Stay on **MMA** (C85 is changing boxing's weights).
- **Report NOT DERIVABLE honestly** where the stream cannot answer. Q40's
  refusal on skill-versus-output was its most useful output and it earned Q41.

## Anchors

- `research/G52_THE_SHAPE_OF_A_ROUND.md` — **read this whole; it is the
  brief.** Its table and verdict are what you are grading against.
- `Godot/tools/measure_exchange.gd` — your own harness.
- `research/Q40_THE_EXCHANGE_WE_HAVE.md` — your burst section, section 5.
- `Godot/scripts/FightRealtime.gd` is 2,177 lines. **Never open it whole.**

## Deliverable shape

`Q42_THE_ROUND_SHAPE.md`, **NUMBERS** first: HI blocks per round, HI and LO
durations, HI:LO ratio, and a PASS/OUTSIDE-BAND line against each of G52's
targets with the band named. Then prose, then **NOT DERIVABLE**.

Commit, push **master** (`git rev-parse --abbrev-ref HEAD` first), digest, one
line via `python Tools/agent_comms.py send`. **Do not edit `HANDOFF.md`.**
