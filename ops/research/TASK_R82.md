# TASK R82 — CLAUDE — THE REAL-TIME CORE, STAGE 1: THE TICK THAT REPLAYS

**Model:** Opus 5 · high effort · Fast off.

## The shape of this, decided before a line was written

**R82 is ADDITIVE.** A new `Godot/scripts/FightRealtime.gd` beside the atomic
`FightSimulation.gd`, which is **not touched at all**. Three reasons, and the
first is binding:

1. **The rebaseline ruling forbids the alternative.** The operator ruled that
   the ten pinned scorecards are rebaselined against the real-time engine — and
   that the atomic engine stays until the replacement cards are pinned, because
   a commit that removes the old gate before the new one exists is the R75
   failure exactly. Additive makes that impossible to get wrong.
2. `FightSimulation.gd` is 2,977 lines and must never be opened whole. A new
   file is testable in isolation from its first line.
3. The suite stays green throughout. Nothing that ships today changes.

C62 said `advance_exchange()` and `run_to_completion()` can survive as atomic
wrappers over the new core. **That wiring is a LATER stage.** Stage 1 builds
the core and proves it replays; nothing calls it in production yet.

## What stage 1 delivers

A deterministic fixed-step fight core that produces a real event stream.

- **Integer tick time.** `tick` is an int; fight-seconds are derived, never
  accumulated. C62's first condition.
- **Quantised authoritative state.** Every position is a fixed-point int
  through `Quantise.gd` (Qwen, Q14). C62's third condition.
- **Frame-independent order.** `TickBudget.due_on(tick)` (Grok, G29) decides
  what runs and in what order. C62's second condition.
- **One clock, the simulation's.** Rounds, rest and the final bell come from
  `FightClock.gd` (Grok, G28) — C17 Q2, the gate the real-time ruling did not
  overturn.
- **Real positions.** Movement through `RingSpace.gd` (Qwen, Q13), so
  `place_of` gives G27's three words off an actual position.
- **Per-subsystem RNG streams.** Movement, decision and impact each draw from
  their OWN seeded generator, the R38/R80 pattern. Adding a draw to one
  subsystem must never shift another's sequence — without this, every tuning
  change silently rewrites every seeded fight.

## What stage 1 does NOT do, deliberately

- **No damage is applied.** `ImpactModel.gd` is Codex's C63 and has not landed.
  Impact events are emitted in U20's record shape and the damage call is left
  as one named seam. Building a second damage model here would guarantee two
  that disagree.
- **No scoring, no stoppage, no result.** Those consume damage.
- **Nothing in production calls this.** No screen, no save, no wrapper.

## Owned files

- `Godot/scripts/FightRealtime.gd` — new.
- `Godot/tests/fight_realtime_test.gd` — new.
- `research/R82_DIGEST.md` — new.

**`FightSimulation.gd` is NOT TOUCHED.** Codex owns `ImpactModel.gd` (C63),
Cursor owns `BroadcastRead.gd` (U21), Qwen owns `Quantise.gd` (Q14).

## The gates

- **Determinism is the whole point**: the same seed must produce a
  byte-identical tick stream, event for event. If this fails, the direction
  fails, and C62 said so.
- Positions never leave the floor.
- The fight terminates — `run_to_completion` is bounded and cannot spin.
- Suite `fails=0` or better; it must not move, because nothing existing is
  touched.

## The trap

**Deriving fight-seconds by accumulating a float per tick.** It is the obvious
way and it is precisely what C62 ruled out: 18,000 additions of `1.0/20.0`
do not land on the same value twice across platforms. Fight time is
`TickBudget.seconds_for_ticks(tick, hz)` computed from the integer tick, every
time, and never stored as a running float.
