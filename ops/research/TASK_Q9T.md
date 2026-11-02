# TASK Q9T — QWEN — THE TEST FOR THE GRADE LADDER

Model: Qwen3-Max, effort **high**, Fast off. One file, the test only.

**Agent:** qwen · **Model:** Qwen3-Max, effort **high**, Fast **off** ·
**Opened:** 2026-09-08

**ONE FILE: a test.** This task is the twin of Q9 and **does not wait for it**.
You are writing the test from the CONTRACT below, not from any implementation.
If you have seen the module, ignore it: a test written against an
implementation only ever agrees with it.

You have no checkout and no shell. Do not run anything. Write the file and
post it back.

## The file

`Godot/tests/grade_ladder_test.gd`

It must follow the house test shape exactly — a `SceneTree` script, a
`failures` counter, `load()` inside `_initialize()` (never a top-level
`preload`), and a non-zero exit on any failure:

```gdscript
extends SceneTree
## Q9T: GradeLadder over passed-in values. No GameState, no save, no JSON.

var failures := 0


func _initialize() -> void:
	var Ladder = load("res://scripts/GradeLadder.gd")

	# ... your assertions ...

	print("grade_ladder_test: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

## The contract under test

```
static func has_ladder(discipline: String) -> bool
static func ladder_for(discipline: String) -> Array
static func grade_index(discipline: String, grade: String) -> int
static func minimum_weeks(discipline: String, from_grade: String, to_grade: String) -> int
static func minimum_age(discipline: String, grade: String) -> int
static func eligible(discipline: String, current_grade: String, target_grade: String, weeks_at_current: int, age: int) -> Dictionary
static func words(discipline: String, grade: String) -> String
```

Facts the module promises:

* `brazilian_jiu_jitsu` ladder is `["white", "blue", "purple", "brown",
  "black"]`. `judo` runs `6th_kyu` … `1st_kyu`, `1st_dan`, `2nd_dan`,
  `3rd_dan`. `mma` is `["novice", "amateur", "professional"]`.
* `wrestling`, `boxing`, `sanda` and `sambo` have **no ladder**:
  `has_ladder` is `false` and `ladder_for` is `[]`.
* `grade_index` is the position in the ladder, `-1` for unknown, and is
  case-insensitive.
* Sourced `minimum_weeks`: BJJ blue→purple `104`, purple→brown `78`,
  brown→black `52`; judo `1st_kyu`→`1st_dan` `52` and `1st_dan`→`2nd_dan`
  `52`. **Everything else is `-1`**, including BJJ white→blue, any
  non-adjacent pair, and every pair in a discipline with no ladder.
* Sourced `minimum_age`: judo `1st_dan` `15`, judo `2nd_dan` `16`. Everything
  else `-1`.
* `eligible` returns exactly `{"eligible": bool, "reason": String,
  "evidence": String}`. `evidence` is `"sourced"` or `"unknown"`; an
  `"unknown"` evidence always means `eligible == false` and
  `reason == "unknown"`. `reason` is one of `"ok"`, `"unknown"`,
  `"no_ladder"`, `"not_next_grade"`, `"too_soon"`, `"too_young"`, resolved in
  that order.
* `words` upper-cases and replaces underscores with spaces: BJJ `purple` is
  `"PURPLE BELT"`, judo `1st_dan` is `"1ST DAN"`, muay thai `khan_7` is
  `"KHAN 7"`, mma `professional` is `"PROFESSIONAL"`. An unknown grade or a
  ladderless discipline returns `""`.

## What the test must cover

Write at least these, each as its own `_check` with a readable message:

1. Every ladder is ordered and `grade_index` agrees with `ladder_for` position
   for the first and last entry of BJJ and judo.
2. `grade_index` is case-insensitive (`"PURPLE"` and `"purple"` match) and is
   `-1` for `"chartreuse"`.
3. All four ladderless disciplines: `has_ladder` false, `ladder_for` empty,
   `grade_index` `-1`, `words` `""`, and `eligible` reason `"no_ladder"`.
4. Each of the five sourced week minima returns its exact number.
5. **`minimum_weeks("brazilian_jiu_jitsu", "white", "blue")` is `-1`, not
   `0`.** Assert this explicitly — `0` would mean "promote immediately", which
   is a different and wrong claim.
6. A non-adjacent pair (`white` → `black`) is `-1` and never a sum.
7. Judo age gates: `1st_dan` 15, `2nd_dan` 16, and `minimum_age` for a BJJ
   grade is `-1`.
8. `eligible` happy path: BJJ blue → purple at 104 weeks is
   `{"eligible": true, "reason": "ok", "evidence": "sourced"}`.
9. `eligible` at 103 weeks is `false` with reason `"too_soon"`.
10. `eligible` for judo `1st_kyu` → `1st_dan` at age 14 with 52 weeks served
    is `false` with reason `"too_young"`.
11. `eligible` skipping a grade (BJJ `blue` → `black`) is `false` with reason
    `"not_next_grade"`, and that reason wins over `"too_soon"`.
12. An unsourced promotion (karate `9th_kyu` → `8th_kyu`) is `false`,
    `reason` `"unknown"`, `evidence` `"unknown"` — **an unknown rule never
    grants a promotion.**
13. `eligible` returns exactly three keys and no more.
14. Negative and zero inputs (`weeks_at_current = -5`, `age = 0`) never crash
    and never return `true`.
15. Calling any function twice with the same arguments returns the same
    answer (no hidden state).

## Rules

* Never call a function that is not in the contract above, and never assume a
  helper, a constant or a signature the contract does not name — a test that
  reaches past the contract fails for the wrong reason.
* No `GameState`, no autoload, no JSON, no scene, no `preload` at the top of
  the file.
* House gotchas: `var n: int = ...` when the right side is a Variant (a
  `.get()` or `.size()` on an untyped value, or a static called on a
  `load()`ed script — **which is every call in this file**, so type every
  result); `%%` for a literal `%` in a format string; never reuse a variable
  name inside one function, even across separate `if`/`for` blocks.

## Owned files

* `Godot/tests/grade_ladder_test.gd` - ONE file. The module is Q9 and this
  test never waits for it.

## What to send back

**One file: the complete text of `Godot/tests/grade_ladder_test.gd`**, in a
single code block. No module, no notes, no `HANDOFF.md` edit.
