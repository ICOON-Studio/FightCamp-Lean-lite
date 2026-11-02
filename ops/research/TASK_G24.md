# TASK G24 — GROK — THE AGE CLOCK: WHICH BIRTHDAY COUNTS

Model: Grok 4 Heavy, effort **high**, Fast off. One pass, no shell.

**Agent:** grok · **Model:** Grok 4 Heavy, effort **high**, Fast **off** ·
**Opened:** 2026-09-08

You have no checkout and no shell. **Do not run any repo command, do not try
to clone, do not run a test.** Write ONE new file and post it back. Claude
runs the suite after splicing it.

## Why this exists — verified, not assumed

C56 landed today (`07fceea`) after reading the six governing bodies, and its
finding is that **they do not share one age clock**:

| Body | Published trigger |
| --- | --- |
| IJF / EJU (judo) | calendar year |
| IBA (boxing) | year of birth |
| UWW (wrestling) | birth-date windows for the competition year |
| WT (taekwondo) | "age is based on the year, not the date" |
| WKF (karate) | age on the **first day of the event** |
| IMMAF (MMA) | **MIXED** — youth by year-born from 2026, junior/senior on the first day of competition |

**No reviewed body uses registration date.** C56's own conclusion is that
picking one global trigger would be an authored invention, not a fact.

Meanwhile `EventResult.make` (G23, yours) carries an `age_division` field, and
R74 landed today writing real event results in production with that field left
**empty**, because nothing in the game can answer "how old is this fighter, by
whose clock?" This module is that answer.

## The file

`Godot/scripts/CompetitionAge.gd`

```gdscript
extends RefCounted
```

**ZERO `preload` and ZERO `load` statements.** No `GameState`, no
`WorldPopulation`, no JSON file, no autoload, and **no `Time`** — the event
date is always passed in, never read from the machine. Every value the module
needs is passed in by the caller. It must be testable in an empty Godot
project that contains only this one file. All functions `static`.

## The contract (exact names — an unseen test will call these)

```
static func clock_for(body: String) -> String
static func is_known_clock(clock: String) -> bool
static func competition_age(birth: Dictionary, event: Dictionary, clock: String) -> int
static func meets_minimum(birth: Dictionary, event: Dictionary, clock: String, minimum_age: int) -> bool
static func clock_words(clock: String) -> String
static func bodies() -> Array
```

### The four clock values

Exactly these strings, and no others:

`"calendar_year"`, `"first_event_day"`, `"mixed"`, `"unknown"`.

### `clock_for(body)`

Case-insensitive, edges stripped. **This list is CLOSED** — a body not named
here returns `"unknown"`, exactly as the game's belt-authority table does. A
new body bears no clock until someone authors the evidence for one.

| body | returns |
| --- | --- |
| `ijf` | `calendar_year` |
| `eju` | `calendar_year` |
| `iba` | `calendar_year` |
| `uww` | `calendar_year` |
| `wt` | `calendar_year` |
| `wkf` | `first_event_day` |
| `immaf` | `mixed` |

`bodies()` returns those seven ids, lower case, in that order. A new Array
each call; the caller may not mutate yours.

`is_known_clock` is true for `calendar_year`, `first_event_day` and `mixed`,
and false for `unknown` and for anything else.

### `competition_age(birth, event, clock)`

`birth` may carry `year`, `month`, `day`. `event` may carry `year`, `month`,
`day`. Missing keys are missing, not zero.

* `clock == "calendar_year"` → `event.year - birth.year`. Month and day are
  **not consulted**, even when present. If either year is missing, return
  `-1`.
* `clock == "first_event_day"` → the fighter's full age on the event date:
  `event.year - birth.year`, minus one if the event's month/day falls before
  the birth month/day. **If any of the four month/day values is missing,
  return `-1`** — never fall back to the calendar-year answer, and never
  assume January 1st.
* `clock == "mixed"` → `-1`. IMMAF's rule depends on which band the athlete is
  in, and this module is not told. The caller must pass the resolved clock.
* anything else, including `"unknown"` → `-1`.
* A negative result from the arithmetic itself (an event before the birth
  year) is also `-1`.

**`-1` IS THE UNKNOWN AGE. Never return `0` for unknown** — `0` is a real age
a person can be, and the whole point of this module is that a clock you cannot
apply produces no number at all.

### `meets_minimum(birth, event, clock, minimum_age)`

`true` only when `competition_age(...)` is `0` or greater AND is at least
`minimum_age`. **An unknown age is never eligible**: `-1` returns `false`,
whatever the minimum. You cannot certify an eligibility you cannot compute.

### `clock_words(clock)`

One upper-case display line, and `""` for `unknown` and for anything
unrecognised — never `"none"`, never a dash.

| clock | words |
| --- | --- |
| `calendar_year` | `AGE BY CALENDAR YEAR` |
| `first_event_day` | `AGE ON THE FIRST DAY OF THE EVENT` |
| `mixed` | `MIXED: YOUTH BY BIRTH YEAR, JUNIOR AND SENIOR ON THE FIRST DAY` |
| `unknown` | `""` |

## Rules you must not break

1. **NO AGE BANDS.** This module answers the CLOCK, never the division. Do not
   write a u15/u18/u21/senior table, do not name a band, and do not return a
   division string from any function. C56 proved the bands differ per body and
   per year; inventing one global ladder here is exactly the mistake this task
   exists to avoid. `age_division` is somebody else's task, later, with
   sourced numbers.
2. **No minimum ages baked in.** `meets_minimum` takes the minimum as an
   argument. Do not hardcode 10, 15, 16 or 18 anywhere.
3. Deterministic and stateless: no `randi`, no `Time`, no `static var` cache.
4. Never mutate a Dictionary or Array the caller passed in.
5. Follow the house gotchas: `var n: int = ...` where the right side is a
   Variant (`.get()`, `.size()` on an untyped value); `%%` for a literal `%`
   in a format string; never reuse a variable name inside one function, even
   across separate `if`/`for` blocks.

## Owned files

* `Godot/scripts/CompetitionAge.gd` — Grok delivers this ONE file and no test.
* `Godot/tests/competition_age_test.gd` — Claude writes this from the SAME
  contract after splicing, so the test never agrees with the code by
  construction.

## What to send back

The complete text of `Godot/scripts/CompetitionAge.gd`, in one code block, and
nothing else. **Do not send a test.** Do not edit `HANDOFF.md`.
