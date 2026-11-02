# TASK G30T — QWEN — THE TEST FOR A STAMINA MODULE YOU HAVE NOT SEEN

**Model:** Qwen · medium effort. **Take this only after Q16 has landed.**

## Read this first

You are writing the test for `Godot/scripts/FightStamina.gd`, which Grok is
writing **right now, in parallel**. You will not see its code before you write
this, and that is deliberate, not an accident of scheduling: a test written
against a delivered implementation only ever agrees with it. Write from the
contract below and from nothing else.

**Do not wait for the module to exist.** Write the test, then run it. If the
file has not landed yet, the test failing to load IS the expected state — say
so and hold. If it has landed and your test goes red, that is a real result:
report the disagreement, do **not** edit the module to match your test, and do
**not** soften the test to match the module. Claude reconciles the two.

## The contract — identical to the one Grok was given

`Godot/scripts/FightStamina.gd`, `class_name FightStamina`, statics only, zero
preloads, no randomness of its own, no `print`.

```gdscript
const MIN_STAMINA := 1.0
const MAX_STAMINA := 100.0

static func movement_drain(intent: String, conditioning: float, seconds: float) -> float
static func strike_drain(force: float, conditioning: float) -> float
static func impact_drain(wear: float, conditioning: float) -> float
static func rest_recovery(stamina: float, conditioning: float, rest_seconds: float) -> float
static func apply(stamina: float, delta: float) -> float
static func fatigue_fraction(stamina: float) -> float
```

`intent` is one of `"close"`, `"hold"`, `"retreat"`, `"circle"`.
`conditioning` is 0..100, higher means less drain and more recovery.
`force` and `wear` are the impact's own figures. In `apply`, a **positive**
`delta` restores and a **negative** one spends.

## What to assert

The rules the module was told to satisfy — test these, not an implementation:

1. **Every drain function returns a POSITIVE number.** They return an amount to
   spend; `apply` is the only place a sign is interpreted. A negative drain
   would read as free stamina, and it is the easiest thing to get wrong.
2. **`close` drains more than `hold`**, with `retreat` and `circle` between.
   Assert the ordering, never the constants.
3. **Higher conditioning drains less and recovers more.** Compare two
   conditioning values through each function; assert the direction only.
4. **`apply` clamps to `MIN_STAMINA`..`MAX_STAMINA` for every input**,
   including absurd ones: a huge positive delta, a huge negative one, a
   stamina already at either bound, and a zero delta.
5. **A man never rests back to full.** `rest_recovery` on a badly depleted
   fighter must leave him below `MAX_STAMINA` after `apply`. This is the most
   important assertion in the file — a fighter who empties the tank in round
   one must not start round two fresh.
6. **Nothing returns NaN or INF.** Sweep `conditioning = 0`, `seconds = 0`,
   `force = 0`, `wear = 0`, `stamina = MIN_STAMINA`, and negative inputs
   through every function; assert `is_finite()` on every result. Use
   `is_finite`, not `!= NAN` — `NAN != NAN` is true and that comparison never
   catches anything.
7. **An unrecognised `intent`** (`""`, `"sprint"`, `"CLOSE"` in the wrong case)
   returns a real finite number and does not crash. The contract says treat it
   as `hold`.
8. **`fatigue_fraction`** is 0.0 at `MAX_STAMINA`, near 1.0 at `MIN_STAMINA`,
   monotonic between, and stays in 0.0..1.0 for out-of-range stamina.
9. **Determinism**: call each function twice with identical arguments and
   assert identical results. The fight replays byte-for-byte from a seed, and
   a module with hidden state would break that silently.
10. **The magnitude check, and the reason this module exists.** Simulate a
    plausible fight arithmetically — conditioning 50, ~475 strikes thrown,
    movement every tick at 20 Hz across three five-minute rounds, two rests —
    and assert the man ends **meaningfully tired but standing**, in a band of
    roughly 25..75 stamina. Assert a *band*, not a value. Both ways out are
    real failures: ending near 100 leaves the gassed-fighter logic dead
    exactly as it is today, and hitting the floor in round two makes every
    fight an exhaustion contest.

## Style and shape

Follow the existing pure-module tests — `Godot/tests/fight_intent_test.gd` is
the closest shape. `extends SceneTree`, a `_check(condition, message)` helper,
a `failures` counter, `_initialize()` running each check, a final
`STAMINA_TEST PASS (N checks)` or `STAMINA_TEST FAILS=N`, and
`quit(0 if failures == 0 else 1)`.

`load("res://scripts/FightStamina.gd")` **inside** `_initialize`, never a
top-level `preload` — a preload of a missing file is a parse error, and a
parse error hangs the headless run until the timeout instead of failing it.
Handle the null: if the load returns null, print the failure line and quit 1.

## Owned files

- `Godot/tests/fight_stamina_test.gd` — new.

Nothing else. You do **not** own `FightStamina.gd` — if it lands and disagrees
with this contract, report it, do not fix it.

## Parse gate, then the test

```
python Godot/tools/check_scripts.py Godot/tests/fight_stamina_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fight_stamina_test.gd
```

## Gate

`python Godot/tools/run_tests.py` → **`fails=0` or better**, once the module
exists. If the module has not landed, say so plainly and do not push a test
that cannot load.
