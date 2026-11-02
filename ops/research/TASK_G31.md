# TASK G31 — GROK — WHAT A TIRED MAN CAN NO LONGER DO

Model: Grok (in-app browser). Owner: Grok. Deliverable: ONE new file,
`Godot/scripts/FatigueCurve.gd`. **Do not write a test** — the test is TASK
G31T and is being written from this same contract by someone who will not see
your code. That is deliberate: a test written against an implementation only
ever agrees with it.

You have no checkout, no Godot and no repo access. **This module must have ZERO
preloads and reference nothing else in the game.** It is pure static maths over
floats. Everything you need is on this page.

---

## Why this exists

The fight engine drains stamina correctly and then ignores it. A man at 5
stamina currently punches exactly as hard, lands exactly as cleanly and defends
exactly as well as a man at 100 — only his *choice* of what to do changes.
`FatigueCurve` is the missing piece: it converts how empty a man is into how
much worse he has become at each thing he does.

---

## THE CONTRACT — exact names, exact argument order

```gdscript
class_name FatigueCurve
extends RefCounted
```

`fatigue` is **0.0 = completely fresh, 1.0 = completely empty**. Every function
takes it as its only argument and returns a MULTIPLIER to be applied to an
attribute.

```gdscript
static func technique_multiplier(fatigue: float) -> float
static func power_multiplier(fatigue: float) -> float
static func defense_multiplier(fatigue: float) -> float
static func output_multiplier(fatigue: float) -> float
static func multipliers(fatigue: float) -> Dictionary
```

`multipliers()` returns all four in ONE dictionary with **exactly these four
keys, spelled exactly like this**:

```gdscript
{"technique": ..., "power": ..., "defense": ..., "output": ...}
```

Each value must equal what the matching single function returns for the same
`fatigue`, to the last bit. The test will check that.

### The formula — use exactly this

```
multiplier = 1.0 - (1.0 - FLOOR) * pow(clampf(fatigue, 0.0, 1.0), EXPONENT)
```

with these constants, which must be declared as named `const`s with these
exact names so the test can read them:

| Attribute | `..._FLOOR` | `..._EXPONENT` |
| --- | --- | --- |
| technique | `TECHNIQUE_FLOOR := 0.55` | `TECHNIQUE_EXPONENT := 1.3` |
| power | `POWER_FLOOR := 0.80` | `POWER_EXPONENT := 2.0` |
| defense | `DEFENSE_FLOOR := 0.50` | `DEFENSE_EXPONENT := 1.2` |
| output | `OUTPUT_FLOOR := 0.45` | `OUTPUT_EXPONENT := 1.15` |

### Why the numbers are shaped like that — do not "improve" them

* **Technique and defence go first and go furthest.** The first thing to leave
  a tired fighter is his hands staying up and his feet moving.
* **Power holds longest** (floor 0.80, exponent 2.0, so it barely moves until
  he is genuinely empty). This is why late knockouts happen: an exhausted man
  can still land one right hand.
* **Output collapses hardest** (floor 0.45). A gassed fighter throws roughly
  half as much.
* **The exponent is above 1.0 for everyone**, so the first quarter of the tank
  costs almost nothing and the last quarter costs a lot. A linear curve would
  make round one meaningfully worse than a fresh man, which is wrong.

Sanity values you can check by hand at `fatigue = 0.5`: technique ≈ 0.817,
power ≈ 0.950, defense ≈ 0.783, output ≈ 0.752.

### Robustness — the module is never allowed to return rubbish

* `fatigue` is clamped to 0.0..1.0 before use.
* `NAN` or `INF` in, treat as **0.0** (a fresh man), never as empty. Guard with
  `is_nan()` / `is_inf()`.
* Every return value is finite and lies within `FLOOR .. 1.0` inclusive.
* At `fatigue = 0.0` every function returns **exactly 1.0**.
* At `fatigue = 1.0` every function returns **exactly its FLOOR**.
* Monotonic: for any `a < b`, `f(a) >= f(b)`. Never increases with fatigue.
* Pure and deterministic: no RNG, no engine state, no nodes, same input always
  gives the same output.

---

## Style rules for this repo

* Tabs, not spaces, for indentation.
* `##` doc comments above each function saying what it is for in one line.
* `var x := <call>` FAILS to compile when the call returns Variant. Write the
  type explicitly: `var n: float = ...`.
* Do not add a `_ready`, `_process` or any node code. Statics only.
* No `preload`, no `load`, no `class_name` references to other game files.

## The trap specific to this task

**`multipliers()` must not re-implement the arithmetic.** Have it call the four
functions. If it computes the numbers a second time inline, the two copies will
disagree the first time anybody tunes a constant, and the test that compares
them is the only thing that would ever notice.

## How to deliver

Paste the complete contents of `Godot/scripts/FatigueCurve.gd` back in chat as
one GDScript code block. Nothing else — no test, no explanation of the maths,
no README.

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
