# TASK Q9 — QWEN — THE PRACTITIONER GRADE

Model: Qwen3-Max, effort **high**, Fast off. One file, no test.

**Agent:** qwen · **Model:** Qwen3-Max, effort **high**, Fast **off** ·
**Opened:** 2026-09-08

**ONE FILE. DO NOT SEND A TEST.** The test is a separate task (Q9T) written
from this same contract by someone who will not see your code. You have no
checkout and no shell: do not run any repo command, do not clone, do not run a
test. Write the file and post it back.

## Why this exists

C52 (landed research) separated two things the game had confused:

* A **standing championship belt** is a title object somebody carries and
  defends. Already modelled.
* A **practitioner grade belt** — a BJJ purple belt, a judo 1st dan, a muay
  thai khan — is an **awarded rank**. It is never won from an opponent, never
  defended, and never lost in a fight.

The game has no grade concept at all. You are writing the pure module.

## The file

`Godot/scripts/GradeLadder.gd`

```gdscript
extends RefCounted
```

**ZERO `preload` and ZERO `load` statements.** No `GameState`, no JSON file,
no autoload. All data is `const` inside this file; everything else is passed
in. It must run in an empty Godot project containing only this one file. All
functions `static`.

## The contract (exact names, argument order and strings)

```
static func has_ladder(discipline: String) -> bool
static func ladder_for(discipline: String) -> Array
static func grade_index(discipline: String, grade: String) -> int
static func minimum_weeks(discipline: String, from_grade: String, to_grade: String) -> int
static func minimum_age(discipline: String, grade: String) -> int
static func eligible(discipline: String, current_grade: String, target_grade: String, weeks_at_current: int, age: int) -> Dictionary
static func words(discipline: String, grade: String) -> String
```

Discipline strings are the game's own, lower case with underscores:
`brazilian_jiu_jitsu`, `judo`, `karate`, `taekwondo`, `muay_thai`,
`kickboxing`, `mma`, `wrestling`, `boxing`, `sanda`, `sambo`.

**The ladders** (adult; ordered lowest first, exactly these strings):

* `brazilian_jiu_jitsu`: `["white", "blue", "purple", "brown", "black"]`
* `judo`: `["6th_kyu", "5th_kyu", "4th_kyu", "3rd_kyu", "2nd_kyu", "1st_kyu",
  "1st_dan", "2nd_dan", "3rd_dan"]`
* `karate`: `["9th_kyu", "8th_kyu", "7th_kyu", "6th_kyu", "5th_kyu", "4th_kyu",
  "3rd_kyu", "2nd_kyu", "1st_kyu", "1st_dan", "2nd_dan", "3rd_dan"]`
* `taekwondo`: `["10th_geup", "9th_geup", "8th_geup", "7th_geup", "6th_geup",
  "5th_geup", "4th_geup", "3rd_geup", "2nd_geup", "1st_geup", "1st_dan",
  "2nd_dan", "3rd_dan"]`
* `muay_thai`: the IFMA Khan system, `["khan_1" … "khan_15"]` in that order
* `mma`: `["novice", "amateur", "professional"]` (IMMAF progression)
* `kickboxing`: `["white", "yellow", "orange", "green", "blue", "brown",
  "black"]` (WAKO grading exists but is OPTIONAL for members — see
  `has_ladder` below)
* `wrestling`, `boxing`, `sanda`: **NO LADDER.** C52 found no universal
  practitioner grade in the reviewed UWW, World Boxing or IWUF material.
  `ladder_for` returns `[]` and `has_ladder` returns `false`. Do not invent
  one.
* `sambo`: `[]` as well. FIAS launched a ten-level system in 2026 but C52 did
  not source the level names; an empty ladder is the honest answer.

**`grade_index`** — position in the ladder, `-1` for an unknown grade or a
discipline with no ladder. Case-insensitive on the grade string.

**`minimum_weeks(discipline, from_grade, to_grade)`** — the sourced minimum
time at `from_grade` before `to_grade` may be awarded. **Return `-1` for
UNKNOWN and never guess a number.** Only these are sourced:

| discipline | from → to | weeks |
| --- | --- | --- |
| `brazilian_jiu_jitsu` | `white` → `blue` | `-1` (IBJJF sets no adult minimum at white) |
| `brazilian_jiu_jitsu` | `blue` → `purple` | `104` (2 years) |
| `brazilian_jiu_jitsu` | `purple` → `brown` | `78` (1.5 years) |
| `brazilian_jiu_jitsu` | `brown` → `black` | `52` (1 year) |
| `judo` | `1st_kyu` → `1st_dan` | `52` |
| `judo` | `1st_dan` → `2nd_dan` | `52` |

Every other pair in every other discipline is `-1`. A non-adjacent pair
(white → black) is `-1`, not a sum.

**`minimum_age(discipline, grade)`** — sourced minimum age in years:
`judo` `1st_dan` = `15`, `judo` `2nd_dan` = `16`. Everything else `-1`.

**`eligible(...)`** returns exactly these three keys:

```
{"eligible": bool, "reason": String, "evidence": String}
```

* `evidence` is `"sourced"` when BOTH the week minimum and the age minimum for
  the target are known-or-not-applicable from the tables above, otherwise
  `"unknown"`.
* When `evidence` is `"unknown"`, `eligible` is `false` and `reason` is
  `"unknown"`. **An unknown rule never grants a promotion.**
* `reason` is one of: `"ok"`, `"unknown"`, `"no_ladder"`, `"not_next_grade"`,
  `"too_soon"`, `"too_young"`. First failure in that order wins.
* `target_grade` must be exactly one step above `current_grade` or the reason
  is `"not_next_grade"`.

**`words(discipline, grade)`** — the display label, upper case with
underscores turned into spaces: `"PURPLE BELT"` for BJJ colours, `"1ST DAN"`
for dan/kyu/geup grades, `"KHAN 7"` for muay thai, `"PROFESSIONAL"` for MMA.
An unknown grade or a discipline with no ladder returns `""`, never a dash and
never the raw input.

## Rules you must not break

1. **A grade is never derived from the seven stats** (C52 decision 5). No
   function takes a rating, a stat, a record or a win count.
2. **A grade is never won from an opponent and never lost.** No function
   mentions a bout, a title, a defence or a holder.
3. **Unknown is a value.** `-1` and `"unknown"` are correct answers and must
   reach the caller. Never substitute `0` for an unknown minimum — `0` means
   "no waiting period", which is a different claim.
4. Deterministic and stateless: no `randi`, no `Time`, no `static var` cache.
5. House gotchas: write the type when the right side is a Variant
   (`var n: int = dict.get(...)`); `%%` for a literal `%` in a format string;
   never reuse a variable name inside one function, even across separate
   `if`/`for` blocks.

## Owned files

* `Godot/scripts/GradeLadder.gd` - ONE file. The test is Q9T and is written
  from this same contract by someone who will not see this module.

## What to send back

**One file: the complete text of `Godot/scripts/GradeLadder.gd`**, in a single
code block. No test, no notes file, no `HANDOFF.md` edit.
