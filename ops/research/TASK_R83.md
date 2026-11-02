# TASK R83 — CLAUDE — R82 STAGE 2: THE CORE READS THE FIGHTER AND THE FIGHT HURTS

**Model:** Opus 5 · high effort · Fast off.

## Where stage 1 left it

`FightRealtime.gd` runs a deterministic fixed-step fight and **replays
byte-for-byte** — the gate C62 said the direction lives or dies on. It moves
two men around a real ring, respects the round clock, and emits U20 impact
records with a correct `span`.

It does **not** yet read the fighter, and nothing hurts. Two seams were left
open on purpose, each a single function, so this stage is a swap rather than
an untangling.

## The two wirings

### 1. `_decide()` becomes `FightIntent.decide()`

`FightRealtime.gd:229` is a five-line placeholder. Replace its body with the
real module (Q15, `FightIntent.gd`), which has a wider signature:

```
FightIntent.decide(stats, distance, preferred, stamina, place, roll) -> String
FightIntent.preferred_range(stats, reach_cm) -> float
FightIntent.tolerance(stats) -> float
```

`preferred_range` needs `stats` and `reach_cm`, both already on the fighter
state. **Settle `preferred` and `tolerance` ONCE at `begin()`**, not per tick —
they are properties of the man, not of the moment, and recomputing them 18,000
times is the kind of waste C62 told us to design out.

`FightIntent` returns `close` / `hold` / `retreat` / `circle`, which is exactly
what `_run_movement` already switches on. The movement code should need no
change; if it does, say so rather than quietly widening it.

### 2. The damage seam becomes `ImpactModel`

`_run_impact` (`:276`) hand-builds its record. Build it through
`ImpactModel.make_impact(t_s, region, force, contact)` instead, then apply both
channels:

```
ImpactModel.wear_from(impact) -> {region: float}      # subtract from body_condition
ImpactModel.shock_chance(impact, head_neck_remaining) -> float
ImpactModel.is_flash_knockdown(shock, head_neck_remaining) -> bool
```

Fighters need a `body_condition` dict in state — six regions at 100.0. Wear
subtracts; shock is a roll against `_rng_impact`.

## TWO REAL GAPS FOUND WHILE WRITING THIS — fix both, do not paper over them

1. **The contact vocabularies disagree.** `ImpactModel.CONTACTS` carries U20's
   full six — `clean`, `glancing`, **`absorbed`**, `blocked`, **`slipped`**,
   `missed`. `FightRealtime` emits only four; it never produces `absorbed` or
   `slipped`. So two of U20's contact classes are dead on arrival, and the
   defender's own defence has no way to express itself. Widen the core, and
   let `defense` decide the two new ones.
2. **`make_impact` refuses what the core cannot currently supply.** It clamps
   and validates, and returns `{}` on an unrecognised region or contact. Once
   the core builds through it, **a refused impact must be a test failure, not a
   silently dropped event.** Assert that no impact is ever refused during a
   full fight.

## The gate, unchanged and non-negotiable

**Seeded replay must still be byte-for-byte.** Every new draw comes from
`_rng_impact` or `_rng_decision`, never a new stream and never `randf()`.
`fight_realtime_test.gd` already asserts this across three seeds; it must keep
passing, and damage must appear in the replayed log identically.

Also still true: positions never leave the floor, nothing happens during the
rest, the fight terminates, `fight_seconds == tick/hz`.

## Owned files

- `Godot/scripts/FightRealtime.gd`
- `Godot/tests/fight_realtime_test.gd`
- `research/R83_DIGEST.md` — new.

**`FightSimulation.gd` is still NOT touched.** The rebaseline ruling stands:
the atomic engine ships until the replacement cards exist.

## What comes after, so it is not rediscovered

- **R84** — scoring, stoppage and result on the real-time core. All three
  consume damage, which is why they wait for this.
- **R85** — the rebaseline itself: pin ten new scorecards from the real-time
  engine and retire the old ones **in the same commit**. A commit that removes
  the old gate without adding the new one is forbidden.

## Before you run anything

`python Tools/agent_comms.py board` first. **Q16 (Qwen) fixes the concurrency
defect that makes the suite lie** — five failures that all pass in isolation,
caused by a shared `user://` Career save. If Q16 has not landed, check
`tasklist | grep -ci godot` before believing a red suite, and re-run any
failure alone before reporting it.

## Gate

`python Godot/tools/run_tests.py` → **`fails=0` or better.** It reads
`total=199 fails=0` right now.
