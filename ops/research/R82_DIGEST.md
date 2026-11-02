# R82 digest — Stage 1: the real-time core, and the proof that it replays

**Agent:** claude · **Date:** 2026-09-09

## The finding that matters

**A seeded real-time fight replays byte-for-byte.** Three seeds, two
independent runs each, identical on every event and on the final tick.
C62 said the direction lives or dies on this; it lives.

## The shape, and why it is additive

`Godot/scripts/FightRealtime.gd` is a **new file**. `FightSimulation.gd` is not
touched, not one line. That was forced rather than chosen:

- The rebaseline ruling says the ten pinned scorecards may not be removed
  before their replacements exist. An additive core makes violating that
  impossible rather than merely forbidden.
- `FightSimulation.gd` is 2,977 lines and must never be opened whole; a new
  file is testable in isolation from its first line.
- The suite could not regress, because nothing that ships was touched.

C62's note that `advance_exchange()` and `run_to_completion()` can become
atomic wrappers over the new core is **stage 2**, not this.

## C62's three conditions, all structural

| Condition | How it is met |
| --- | --- |
| Integer tick time | `tick` is an `int`. `fight_seconds()` computes `TickBudget.seconds_for_ticks(tick, hz)` **every time it is asked** and never stores a running float. |
| Frame-independent order | `TickBudget.due_on(tick)` (G29) decides what runs and in what order. The tick loop iterates that list — it does not test subsystems with a chain of `if`s, so the order cannot drift with an edit. |
| Quantised state | Every position is a fixed-point `int` via `Quantise` (Q14). No float position survives a tick boundary. |

**The trap, named and avoided:** accumulating fight time as a float, `+= 1.0/hz`
per tick. It is the obvious implementation and it is exactly what C62 ruled
out — 18,000 additions of 0.05 do not land on the same value twice, and replay
dies quietly rather than loudly. The test asserts `fight_seconds` equals
`tick/hz` exactly across 400 ticks.

**Per-subsystem RNG streams** (the R38 judge-panel / R80 burst pattern):
movement, decision and impact each draw from their own generator. One shared
stream would mean adding a draw to movement silently rewrote every impact in
every seeded fight — C62's failure arriving through the back door.

## What five agents built, meeting here

`FightClock` (G28, Grok) for rounds and the bell — C17 Q2, the one gate the
real-time ruling did not overturn. `TickBudget` (G29, Grok) for cadence.
`RingSpace` (Q13, Qwen) for position, so `place_of` reports G27's three words
off a real position instead of a parallel ladder. `Quantise` (Q14, Qwen) for
fixed point. None of them had seen this file; none needed changing to fit it.

## What stage 1 deliberately does NOT do

- **No damage is applied.** `ImpactModel` is Codex's C63 and has not landed.
  Impacts are emitted in U20's record shape — `t_s`, region, force, contact —
  with the damage call left as one named seam. A second damage model written
  here would be one more thing to reconcile.
- **No scoring, no stoppage, no result.** All three consume damage.
- **The decision is a seam.** `_decide()` is five lines in one function,
  replaced wholesale by `FightIntent` when Q15 lands. Deliberately one
  function so the swap is a body, not an untangling.
- **Nothing in production calls this.** No screen, no save, no wrapper.

## Verify

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_realtime_test.gd
```
→ `FIGHT_REALTIME_TEST PASS (27 checks)`
