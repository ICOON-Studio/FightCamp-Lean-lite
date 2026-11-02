# R96 — WHAT THE REAL-TIME ENGINE COSTS, AND WHERE THE SEAM ACTUALLY IS

Claude, 2026-09-10. Commissioned as the measurement that decides whether wiring
`FightRealtime` into the game is a slice or a redesign.

## The answer: a slice. Comfortably.

`Godot/tools/bench_engines.gd`, 5 reps each, headless:

| bout | mean | min | max | ticks |
|---|---|---|---|---|
| boxing 3×5 | **282.9 ms** | 279.0 | 288.2 | 20,400 |
| boxing 12×3 championship | **643.6 ms** | 330.2 | 755.7 | 56,400 |
| mma 3×5, grapple on | **288.5 ms** | 282.2 | 292.4 | 20,400 |

**~13.9 µs per tick.** A whole three-round fight resolves in **under three tenths
of a second**, and a twelve-round championship in under seven. Grappling costs
about **2%**, which is worth recording because it was the part nobody had
costed.

## And the fear behind option 2 was misplaced

"18,000 ticks times every fight in the world" was the worry. **It was never the
risk.** Every bout the player does not attend is resolved by
`WorldPopulation._resolve_world_event` (`WorldPopulation.gd:1820`) — a rating
comparison, a seeded roll, a fatigue bump, a method coin-flip. About twenty
lines. It touches **neither** engine, and the only mention of `FightSimulation`
in that whole file is a comment.

So the engine runs for exactly one bout: the one the player is watching. At
283 ms, that is not a budget question.

## The seam is NOT the shape I assumed, and this is the useful half

I had this wrong when I first reported it, and the correction changes the task.

`FightSimulation` publishes a one-call `run_to_completion(a, b, ruleset_id,
options)` at `:865` — but **the production caller does not use it.** Its own
comment says so: *"Mainly useful for tests and any call site that wants the old
single-call behaviour."*

What `FightNightScreen.gd` actually does is **step the fight**, because it
renders each beat as it happens (`:405-415`):

```
_fight_state = FightSimulation.begin_fight(a, b, ruleset_id, options)   # :186, :246
...
if FightSimulation.is_fight_over(_fight_state): ...                     # :405
var event: Dictionary = FightSimulation.advance_exchange(_fight_state)  # :409
_view.present_event(event)
```

`FightRealtime` already has the same three verbs under different names and a
different beat:

```
FightRealtime.begin(a, b, options)      -> state        # :325
FightRealtime.advance_tick(state)       -> Array        # :550
FightRealtime.result(state)             -> Dictionary   # :648
```

**So the wiring job is a beat adapter, not an engine swap.** One
`advance_exchange` was a 14-fight-second lump; one `advance_tick` is 50 ms of
fight. The screen cannot present 20,400 beats, so something has to gather ticks
into a displayable event — and G42 already ruled what that something may do:
show an exchange, never a different exchange.

`RingStagePanel.gd` is the second caller and a **different** shape again — it
uses `react_to_combo(_fight_state, side, "instinct")` at `:1200`, a
player-intervention verb the real-time core has no equivalent for. That is the
harder half of the seam and it should be scoped separately rather than
discovered mid-build.

## What this makes the next stage

1. A beat adapter over `advance_tick` that yields presentable events, sized by
   G42's rule rather than by the clip length.
2. `FightNightScreen` switched to it, boxing/MMA/kickboxing/muay thai only —
   `FightSimulation.gd` **stays**, because R85 left judo, taekwondo and
   freestyle wrestling on it by ruling, not by accident.
3. `RingStagePanel`'s intervention verb scoped on its own.

Six modules stop being inert the moment step 2 lands: `RealtimeRoundStats`,
`GrappleAdapter`, `JudoBoard`, `ContestLength`, `BroadcastRead`'s grapple
counters and `FightHudPanel`'s seat chip.

## One thing the bench found and did not chase

`FightSimulation`'s side of the bench never ran: calling `run_to_completion`
through a `preload()` returned *"Nonexistent function ... in base 'GDScript'"*,
with a `gdscript_resource_format.cpp:46` load error above it. That is the
known autoload-compile-order family, in a 3,268-line file. **It is reported, not
fixed** — the comparison was nice to have and the number that mattered did not
depend on it. Anyone wiring the seam should expect to meet it.

## Reproduce

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/bench_engines.gd
```
