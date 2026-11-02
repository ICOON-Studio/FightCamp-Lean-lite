# TASK Q17 — QWEN — CARDIO IS A HEART RATE, NOT A BAR

Model: your default, medium effort. Owner: Qwen. Base: `dd6a545`,
`SUITE total=202 fails=0`. **You have a shell and a checkout, so this task is
the module AND its test together** — that is the whole difference between you
and Grok.

---

## Why

R85R drove Undisputed first-hand and came back with two findings about how a
fight should be READ. This is the first of them:

> **cardio should be rendered as a HEART RATE rather than a stamina bar.**

We have the tank already. `FightStamina` empties a man over a bout and R86
wired it into what he can still do — a 3×5 finishes him at about 58–66 out of
100. What we have no way to say is **"he is blowing"**. A bar that is 60% full
is a number; 178 bpm in the twelfth is a fighter in trouble, and it is the
thing a broadcast actually shows.

This module is the translation. It is **pure arithmetic** — no engine state, no
nodes, no RNG, no preloads.

## The contract — exact names, because a screen and a test will both call it

`Godot/scripts/Cardio.gd`, `class_name Cardio`, `extends RefCounted`, statics
only.

```gdscript
## The standard age-predicted maximum, 220 - age, floored so a nonsense age
## can never produce a maximum below the resting rate.
static func max_bpm(age_years: float) -> float

## A fitter man's heart beats slower at rest. Conditioning 0..100.
static func resting_bpm(conditioning: float) -> float

## THE ONE THE SCREEN CALLS. `exertion` is 0.0 idle .. 1.0 flat out.
## bpm = resting + (max - resting) * <curve of exertion, eased by conditioning>
static func beats_per_minute(exertion: float, conditioning: float, age_years: float) -> float

## THE BRIDGE, and the reason this file exists. Maps FightStamina's 1..100 tank
## to a rate. A full tank is not zero exertion - a man who has been fighting
## for nine minutes and is still at 80 is working hard - so this is NOT simply
## `beats_per_minute(1.0 - stamina/100, ...)`, and the header must say what it
## is instead.
static func from_stamina(stamina: float, conditioning: float, age_years: float) -> float

## The broadcast word for a rate, as a fraction of this man's own maximum.
## Exactly these four, uppercase: "RECOVERY", "AEROBIC", "THRESHOLD", "RED LINE".
static func zone(bpm: float, age_years: float) -> String
```

**Do not add functions beyond these five plus private helpers.** A sixth public
static is a sixth thing a caller can get wrong.

## The rules the contract has to keep

1. **Monotonic in the obvious directions.** More exertion is never a lower
   rate. Better conditioning is never a higher rate at the same exertion.
   Older is never a higher maximum.
2. **Bounded at both ends, always.** `beats_per_minute` never returns below
   `resting_bpm(conditioning)` and never above `max_bpm(age_years)`, for any
   input at all — including inputs outside their stated ranges.
3. **NAN and INF resolve to the CALM end, never the alarming one.** A broken
   input must never tell a screen a man is red-lining. G31 made the same
   ruling for fatigue and it is the same reasoning: a defect must not
   masquerade as drama.
4. **Deterministic.** Same inputs, same output, every time. No RNG anywhere.
5. **`zone` is a pure function of the ratio `bpm / max_bpm(age)`** and its four
   words are ordered by that ratio. Author the cut points; say in the header
   that they are authored.

## Owned files

| File | Note |
| --- | --- |
| `Godot/scripts/Cardio.gd` | **Yours. New.** The module. |
| `Godot/tests/cardio_test.gd` | **Yours. New.** Its test. |

Read-only, and only these: `Godot/scripts/FightStamina.gd` (125 lines, small
enough to read whole — `MIN_STAMINA` is **1.0** and `MAX_STAMINA` 100.0, which
matters for `from_stamina`), and `Godot/scripts/FatigueCurve.gd` (72 lines,
read whole — it is the house style for exactly this kind of module, including
how it treats NAN and how it documents an authored curve).

**Do not read** `HANDOFF.md`, `CURRENT_STATUS.md`, `HANDOFF_ARCHIVE.md`, any
digest, or `GameState.gd` (12,900+ lines — never open it whole). Do not explore
to get oriented; this page is the brief.

**`Cardio.gd` must carry ZERO preloads.** It takes stamina and conditioning as
arguments; it never reaches for `FightStamina` itself.

## Gates — assert the RANGE, not just the arithmetic

Your test is the only thing standing between this module and the fifth piece of
correct, unreachable code this area has produced. So:

1. **Sweep the whole input space** — exertion 0..1, conditioning 0..100, age
   18..45 — and assert bound 2 holds at every point, not at three hand-picked
   ones.
2. **Assert all four zone words actually OCCUR** across that sweep. A word no
   input can produce is a dead branch, and this project has shipped four of
   those. Asserting the list is legal is not the same as asserting it is
   reachable.
3. **`from_stamina` at a full tank and at an empty one** must be plainly
   different numbers, and the empty one must be the higher.
4. NAN, INF and out-of-range inputs on every argument of every function.

## Parse gate BEFORE any test

```
python Godot/tools/check_scripts.py Godot/scripts/Cardio.gd Godot/tests/cardio_test.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/cardio_test.gd
python Godot/tools/run_tests.py
```

**Ceiling, not an exact count:** `fails=0`, `total` at least 203. If the total
differs, say so and push.

## GDScript traps that cost a fix cycle every time

`var x := <call>` fails when the call returns Variant — write the type,
`var n: int = ...`. `%` inside a format string must be `%%`. **Reusing a
variable name inside one function is a parse error, even across separate `if`
or `for` blocks** — and a sweeping test is exactly where that bites.

## The trap specific to this task

**Do not make `from_stamina` a rename of `beats_per_minute`.** If it just
inverts the tank and forwards, this file has four functions and a wrapper, and
the interesting question — what a man's heart is doing when his tank is still
80% full in round nine — went unanswered. R85R's whole point is that a heart
rate says something a bar cannot. Say it, and write down in the header what
you decided and why.

## When you are done

```
git add -- Godot/scripts/Cardio.gd Godot/tests/cardio_test.gd
git commit && git push origin master
python Tools/agent_comms.py send --from qwen --to claude --topic q17-done --body "<one line: the check count, the suite total, and what from_stamina does that is not just 1 - stamina>"
```

Do NOT edit `HANDOFF.md` — Claude writes your block. Digest at
`research/Q17_DIGEST.md`, short.
