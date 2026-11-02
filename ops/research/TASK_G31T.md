# TASK G31T — QWEN — THE TEST FOR A FATIGUE CURVE YOU HAVE NOT SEEN

Model: Qwen. Owner: Qwen. Deliverable: ONE new file,
`Godot/tests/fatigue_curve_test.gd`, committed and pushed to `master`.

**Write this from the CONTRACT below, never from the module.** `FatigueCurve.gd`
is being written in parallel by Grok from this same contract. Do not read it
before writing your assertions — a test written against an implementation only
ever agrees with it, which is exactly how three defects shipped green on
2026-09-09. Write the test first, then run it.

You have a real shell and a real checkout, so unlike G30T you own the running
of it too.

---

## THE CONTRACT — this is what you assert against

`Godot/scripts/FatigueCurve.gd`, `class_name FatigueCurve`, statics only, zero
preloads. `fatigue` is **0.0 = fresh, 1.0 = empty**.

```gdscript
static func technique_multiplier(fatigue: float) -> float
static func power_multiplier(fatigue: float) -> float
static func defense_multiplier(fatigue: float) -> float
static func output_multiplier(fatigue: float) -> float
static func multipliers(fatigue: float) -> Dictionary
```

`multipliers()` returns exactly these four keys:
`{"technique": ..., "power": ..., "defense": ..., "output": ...}`

Formula, for every attribute:

```
multiplier = 1.0 - (1.0 - FLOOR) * pow(clampf(fatigue, 0.0, 1.0), EXPONENT)
```

Named constants on the class, which you may read directly:

| Attribute | FLOOR const | EXPONENT const |
| --- | --- | --- |
| technique | `TECHNIQUE_FLOOR` = 0.55 | `TECHNIQUE_EXPONENT` = 1.3 |
| power | `POWER_FLOOR` = 0.80 | `POWER_EXPONENT` = 2.0 |
| defense | `DEFENSE_FLOOR` = 0.50 | `DEFENSE_EXPONENT` = 1.2 |
| output | `OUTPUT_FLOOR` = 0.45 | `OUTPUT_EXPONENT` = 1.15 |

## What the contract guarantees — assert ALL of it

1. **Fresh is free.** At `fatigue = 0.0` all four return exactly 1.0.
2. **Empty is the floor.** At `fatigue = 1.0` each returns exactly its FLOOR.
3. **Monotonic.** Sweep fatigue 0.0 → 1.0 in small steps; no function ever
   increases. Assert this per attribute, not just on one.
4. **Bounded.** Every return is finite and lies in `FLOOR .. 1.0` inclusive,
   for every input you try.
5. **Clamped.** `-5.0`, `-0.0001`, `1.5`, `100.0` are all legal inputs and must
   behave as 0.0 or 1.0 respectively. Nothing throws, nothing returns rubbish.
6. **NAN and INF in, fresh out.** `NAN`, `INF` and `-INF` must all return the
   fresh value 1.0 — not the floor, not NAN. This is the one a careless
   implementation gets backwards.
7. **The ordering that is the whole point of the curve.** At any fatigue
   strictly between 0.0 and 1.0:
   `power_multiplier(f) > technique_multiplier(f) > defense_multiplier(f)`
   and `output_multiplier(f) < technique_multiplier(f)`.
   Power holds longest; defence and output go first. If this ordering does not
   hold the curve is modelling the wrong thing, however smooth it looks.
8. **`multipliers()` agrees with the four singles, exactly**, for a sweep of
   values — same number, not merely close. Check the dictionary has exactly
   four keys and no others.
9. **Deterministic.** Calling any function twice with the same input gives a
   bit-identical result.
10. **Hand-checked values.** At `fatigue = 0.5`: technique ≈ 0.817, power ≈
    0.950, defense ≈ 0.783, output ≈ 0.752 (tolerance 0.001). These are
    computed from the formula above, not from the module.

## Owned files

| File | Note |
| --- | --- |
| `Godot/tests/fatigue_curve_test.gd` | **Yours. New. The only file you create.** |
| `Godot/scripts/FatigueCurve.gd` | Grok's. Read ONLY after your assertions are written. Never edit it. |

Copy the harness style from `Godot/tests/fight_stamina_test.gd` (your own G30T
file, 239 lines, read it whole) — `_check(condition, message)`, a `checks` and
`failures` counter, and a final `print` of either
`FATIGUE_CURVE_TEST PASS (%d checks)` or `FATIGUE_CURVE_TEST FAILS=%d`, then
`quit(0 if failures == 0 else 1)`.

Load the module with `load("res://scripts/FatigueCurve.gd")` **inside
`_initialize()`**, never as a top-level `preload`.

## Parse gate BEFORE any test run

```
python Godot/tools/check_scripts.py Godot/tests/fatigue_curve_test.gd
```

A parse error HANGS a headless run until timeout instead of failing it, so
never skip this.

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/fatigue_curve_test.gd
```

Then the full suite ONCE, in the background, before the commit:

```
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** master is `total=201 fails=0` at `deb625a`.
Your file makes it 202. Land `fails=0` **or better**; if the total differs from
202, say so and push anyway.

## The trap specific to this task

**If the module has not landed yet, your test will not load and that is not a
failure of your test.** Write the whole file anyway, parse-gate it, and if
`FatigueCurve.gd` is genuinely absent from `Godot/scripts/`, commit and push
the test on its own and say so in your report — do NOT invent a stub
`FatigueCurve.gd` to make it green. A stub written by the test's author is
exactly the collusion this two-task split exists to prevent.

**And if the module IS there and your test goes red: do not edit the module and
do not soften the assertion.** Report the disagreement, exactly as you did on
G30T — that report is what made `MAX_REST_FRACTION` get found. State which
numbered guarantee above failed and what you got.

## When you are done

Commit, push to `master`, then send one line:

```
python Tools/agent_comms.py send --from qwen --to claude --topic g31t-done --body "<one line: checks, suite total/fails, and any contract disagreement>"
```

Do NOT edit `HANDOFF.md`. Do not read `HANDOFF.md`, `CURRENT_STATUS.md` or
`HANDOFF_ARCHIVE.md`.

## CONTRACT CORRECTION (2026-09-09, after G31T went red)

The contract above promised BOTH "at `fatigue = 1.0` every function returns
exactly its FLOOR" and "every return lies within `FLOOR..1.0` inclusive". The
stated formula cannot keep both: in IEEE754, `1.0 - (1.0 - 0.45)` is
`0.44999999999999996`, so `output_multiplier(1.0)` came back **fractionally
below its own floor**. Three of the four floors happen to be exact and only
`output` is not, which is precisely how a defect like this survives a reading.

**The fault was in this contract, not in the module or the test.** Grok
implemented the formula as written; Qwen asserted the guarantee as written;
the two disagreed and that is the disagreement working as designed. Resolved by
clamping the result to `floor_value..1.0` in the module, so both guarantees are
now true rather than one of them being softened.
