# TASK G30 — GROK — THE FIGHTER WHO NEVER GETS TIRED

**Model:** Grok · one pure module · no repo, no Godot, no tests from you.

## The defect this fixes

In the real-time fight core, `stamina` is set once when the fight starts and
**never changes again**. It is read on every decision and written by nothing.

That matters more than it sounds. The decision model already reads stamina and
does the right thing with it — at low stamina it pulls weight off CLOSE, so a
gassed fighter stops walking people down. That code is correct, it is tested,
and in a real fight it **never fires**, because nothing on earth lowers the
number it reads. A fifteen-minute fight ends with both men as fresh as the
opening bell.

You are writing the missing piece: the module that says what a fight costs a
man's gas tank, and what he gets back between rounds.

## What you are delivering

**ONE FILE: `Godot/scripts/FightStamina.gd`.**

- `class_name FightStamina`
- **Statics only.** No `_init`, no member variables, no nodes.
- **ZERO `preload` and ZERO `load`.** Not of anything, not even other modules
  in this project. If you need a number another system owns, the **caller
  passes it in as an argument**.
- **No randomness.** No `randf()`, no `RandomNumberGenerator`. Where a roll is
  needed the caller passes it as a `roll: float` in 0.0..1.0. This is not
  style — the fight must replay byte-for-byte from a seed, and a module that
  draws its own randomness cannot be part of that.
- No `print`.

**Do NOT write a test.** A separate task written from this same contract does
that, deliberately: a test written against your delivered code only ever
agrees with it. Send the module and nothing else.

## The API — exact names, exact argument order

These are a contract. A test you will never see is being written against these
signatures at the same time as you write the module, so a renamed argument or
a reordered pair is a failure even if the maths is perfect.

```gdscript
const MIN_STAMINA := 1.0
const MAX_STAMINA := 100.0

# Cost of one tick of movement. `intent` is one of "close", "hold",
# "retreat", "circle". `seconds` is the tick's length (e.g. 0.05 at 20 Hz).
static func movement_drain(intent: String, conditioning: float, seconds: float) -> float

# Cost of throwing one strike, whatever it did on arrival.
# `force` is 0.0..1.0.
static func strike_drain(force: float, conditioning: float) -> float

# Cost of being hit. `wear` is the damage that impact actually did.
static func impact_drain(wear: float, conditioning: float) -> float

# Recovery across the whole minute between rounds.
static func rest_recovery(stamina: float, conditioning: float, rest_seconds: float) -> float

# Apply a drain or a recovery and clamp. Positive `delta` RESTORES,
# negative SPENDS. Always returns MIN_STAMINA..MAX_STAMINA.
static func apply(stamina: float, delta: float) -> float

# 0.0 fresh .. 1.0 empty, for UI and for anyone who wants a fraction.
static func fatigue_fraction(stamina: float) -> float
```

`conditioning` is a 0..100 attribute, default 50 when absent. Higher
conditioning means **less** drain and **more** recovery.

## The rules the numbers must satisfy

1. **Every drain function returns a POSITIVE number** — the amount to spend.
   `apply` is the only place a sign is interpreted. Returning a negative drain
   is the easiest way to get this wrong and it will read as free stamina.
2. **`close` costs the most, `hold` the least.** Walking a man down is work;
   standing at range is not. `retreat` and `circle` sit between them.
3. `apply` **clamps to `MIN_STAMINA`..`MAX_STAMINA`** and never returns
   outside it, for any input, including nonsense input.
4. **A man never rests back to 100.** `rest_recovery` gives back a fraction of
   what is missing, never all of it — a fighter who empties the tank in round
   one must not start round two fresh. This is the single most important rule
   here.
5. **Nothing returns NaN or INF**, including at `conditioning = 0`,
   `seconds = 0`, `force = 0`, or `stamina` already at the floor. Guard your
   divisions.
6. An unrecognised `intent` must return a real number, not zero and not a
   crash — treat it as `hold`.

## The magnitude that matters

Aim so that a fighter of conditioning 50, in a busy fifteen-minute fight
(three five-minute rounds, roughly 950 strike attempts across both men,
movement every tick at 20 Hz), ends up **meaningfully tired but still
standing** — somewhere around 40-60 stamina, not at 99 and not at the floor by
round two. Both failures are equally useless: one leaves the gassed-fighter
logic dead exactly as it is today, the other makes every fight a shambling
exhaustion contest by the second round.

Write your assumed arithmetic as a comment at the top of the file — ticks per
round, expected strikes, roughly what you expect the total drain to be. If the
tuning turns out wrong, that comment is what lets it be fixed in one line
instead of reverse-engineered.

## Style

Match the house style of a pure module: `class_name` at the top, a short `##`
block saying what the module is for and what it deliberately does not do, one
`##` line above each function, tabs for indentation, and typed parameters and
returns throughout. Keep it under about 100 lines. GDScript trap worth
knowing: `var x := <something returning Variant>` fails to infer — write the
type explicitly, `var x: float = ...`.

## What happens next, so you are not surprised

Claude runs the real test suite after this lands and splices it in; you never
need to run anything, and you cannot — you have no checkout. Wiring
`FightStamina` into the fight core is R84 and is Claude's, so **do not write
the wiring** or reference `FightRealtime` in any way. Your file must make
sense read entirely on its own.
