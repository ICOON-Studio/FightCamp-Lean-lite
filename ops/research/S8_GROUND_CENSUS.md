# S8 — THE GROUND GAME, COUNTED, AND A RETRACTION

Instrument: `Godot/tools/measure_ground_census.gd`. 40 MMA bouts, 3 rounds,
seeds 770000+, population `tools/measure_ruleset_sweep.gd`'s vetted
wrestle-grappler v striker (R133's pair; this file adds no fighter numbers).

## THE RETRACTION FIRST

**Claimed on 2026-09-18: "74% of every grapple event is `control` — a ground
game with no positional progression, it takes a man down and then holds him."
THAT IS WITHDRAWN.** It tallied log rows without asking what emits them.

`control` is logged once per SCORING tick — `TickBudget.CADENCE` scoring = 20,
so once a second at 20 Hz — for as long as anyone holds a scoring position. A
pass or a mount needs `FightRealtime.GROUND_WORK_P` (0.05, on the DECISION
cadence, twice a second) to open **and** the resolve's own success roll. The
ratio was designed before any fighter rolled a die: a metronome counted against
an action. Fifth normalisation trap in six stages, and the first caught by
reading the emitter rather than by re-measuring.

The second one is inside this tool's own first draft, which called control
seconds "ground time". `GrappleSeat.control_units` returns **0 for guard** and 0
for a clinch nobody tops — so a control count cannot see a man working off his
back, which is the most common position in real grappling. Floor time here is
reconstructed from `seat` transitions instead.

## WHAT IS ACTUALLY TRUE

| | |
|---|---|
| fight time | 663 s a bout |
| **on the floor** | **1940 s total — 7.3% of fight time, 48.5 s a bout** |
| of that, in guard | 583 s (30.1% of floor time) |
| in the clinch | 618 s (2.3% of fight time) |
| bouts reaching the floor | 35 of 40 |

**The ladder runs.** Per bout: 1.38 takedowns, 0.82 throws, 1.65 passes, 1.68
mounts, 0.30 sweeps, 0.88 escapes, 0.55 stand-ups, 0.72 submission attempts,
0.38 submission finishes. Nothing is stuck; the positions advance.

Seats by scored control time: mount **44.3%**, side 27.4%, over-under 20.5%,
half 7.8%. (Guard cannot appear — it earns no control unit.)

The gate, as arithmetic rather than opinion: 1940 s of floor at 2 decisions a
second and `GROUND_WORK_P` 0.05 for both men is **387.9 expected openings**
against **121 observed seat changes — an implied 31.2% success rate.** The
engine does not log a gate that opened and failed, so the expectation is the
only way to separate "rarely tries" from "tries and fails". Both are fixable and
the fixes do not overlap.

## THE TWO QUESTIONS THIS RAISES, NEITHER ANSWERED HERE

1. **Is 7.3% floor time right?** It is set by `GRAPPLE_ATTEMPT_BASE` (0.0010 per
   decision tick) far upstream of the ladder, and that constant's own comment
   says it is "a rate to MEASURE against the few-per-fight takedown counts of a
   real card, not a sourced figure". **We do not own that card.** `TASK_K63`
   is exactly it — ring and cage position and control statistics that actually
   exist — and it is open and unlaunched. Tuning the constant before K63 lands
   would be authoring a number to satisfy an impression.
2. **Is mount at 44.3% of control time right?** Mount is the hardest position to
   hold and usually resolves fast, one way or the other. Real grappling spends
   most of its control time in side and half. This is an IMPRESSION, not a
   sourced claim, and it is the same K63 question.

**So the honest state: the ground game works and is under-used, and how much
under-used is not knowable from inside this repo.** What can be said without a
source is that 5 of 40 bouts never touched the floor at all in a fight billed as
a wrestle-grappler against a striker.

## RE-RUN IT

```
godot --headless --path Godot --script tools/measure_ground_census.gd -- bouts=40
```

Roughly four minutes for 40 bouts. Every rate names its denominator in its own
column header, which is the whole reason the file exists.
