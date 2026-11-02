# TASK G29 — GROK — TickBudget.gd: WHAT RUNS ON WHICH TICK

**Model:** your default. **ONE FILE. DO NOT WRITE A TEST** — the test is a
separate task written from this same contract by someone who will not have seen
your code. A test written against an implementation only ever agrees with it.

## Why this exists

The fight is becoming real time (operator ruling 2026-09-09). C62 measured the
cost and attached a strategy to it:

> a full 3x5 is about 63 exchanges today versus 9,000 / 18,000 / 54,000 ticks
> at 10 / 20 / 60 Hz. Start by measuring 20 Hz; **keep decision, logging and
> scoring work off most ticks.**

You are building that policy. Without it the rule ends up as `if tick % 4 == 0`
scattered through a 3,000-line simulation, where nobody can see the cadence or
test it. Here it is one pure module.

## What you are building

`Godot/scripts/TickBudget.gd`, `class_name TickBudget`, **all static, ZERO
preloads.** No nodes, no `_process`, no signals, no engine state. Integer
arithmetic over a tick index.

## The contract — exact names, exact argument order, exact strings

```
const MOVEMENT := "movement"
const IMPACT   := "impact"
const DECISION := "decision"
const SCORING  := "scoring"
const LOGGING  := "logging"
const SUBSYSTEMS := ["movement", "impact", "decision", "scoring", "logging"]

## Every how many ticks each subsystem runs, at the reference rate of 20 Hz.
const CADENCE := {
    "movement": 1,    # every tick - position is the thing that must be smooth
    "impact":   2,    # 10 Hz - fast enough for a strike, half the work
    "decision": 10,   # 2 Hz - a fighter re-reads the situation twice a second
    "scoring":  20,   # 1 Hz - scoring is per round, sampled once a second
    "logging":  20,   # 1 Hz
}
const REFERENCE_HZ := 20
```

1. `static func runs_on(subsystem: String, tick: int) -> bool`
   True when `subsystem` runs on this tick. Tick `0` is the first tick and
   **every subsystem runs on it** — the fight must be fully initialised before
   anything reads it. After that, `tick % CADENCE[subsystem] == 0`.
   An unrecognised `subsystem` returns `false`; a negative `tick` returns
   `false`.
2. `static func due_on(tick: int) -> Array`
   Every subsystem due on this tick, **in `SUBSYSTEMS` order** so two callers
   can never disagree about sequence. Returns `[]` for a negative tick.
   Frame-independent order is one of C62's three conditions for replay, so
   this ordering is load-bearing, not cosmetic.
3. `static func cadence_for(subsystem: String, hz: int) -> int`
   The cadence rescaled from `REFERENCE_HZ` to `hz`, so changing rate does not
   change how often a subsystem runs **in fight time**. Round to nearest,
   floor of `1` — a subsystem never runs less often than every tick's worth.
   An unrecognised `subsystem` returns `0`; an `hz <= 0` returns `0`.
4. `static func ticks_for_seconds(seconds: float, hz: int) -> int`
   How many ticks a span of fight seconds is. `0` for `hz <= 0` or
   `seconds <= 0.0`. Round to nearest.
5. `static func seconds_for_ticks(ticks: int, hz: int) -> float`
   The inverse. `0.0` for `hz <= 0`; a negative `ticks` returns `0.0`.

## The rules that decide the edge cases

- **Tick 0 runs everything.** It is the only tick where cadence is ignored.
- **An unrecognised subsystem is refused, never defaulted** — `false` from
  `runs_on`, `0` from `cadence_for`. It is unmeasured, not "every tick".
- **Negative is not an error, it is nothing.** Negative ticks and non-positive
  rates answer with the empty value, never a fabricated one.

## Owned files

- `Godot/scripts/TickBudget.gd` — **the only file you write.**

Do not write a test. Do not touch `FightSimulation.gd`, `ImpactModel.gd`,
`Quantise.gd`, `RingSpace.gd` or `FightClock.gd` — four other agents own those
right now.

## The trap specific to this task

**`cadence_for` must preserve fight-time frequency, not tick frequency.** At
40 Hz, `decision` must run every 20 ticks, not every 10 — otherwise doubling
the rate doubles how often a fighter thinks, and the fight changes character
when you only meant to change resolution. That is the whole reason this
function exists rather than callers reading `CADENCE` directly.
