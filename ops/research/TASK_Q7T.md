# TASK Q7T — QWEN — THE TEST FOR THE SHAPE OF A STAT SET

Model: Qwen3.8-Max, effort **high**. One session.
**Runs in parallel with Q7. Do not wait for it, and do not ask to see it.**

**You have no repository and you do not need one.** This file is complete.

## ONE FILE. THE TEST. DO NOT SEND THE MODULE.

1. `Godot/tests/spread_words_test.gd` — and nothing else.

## Why you are not shown the implementation

A test written against an implementation only ever agrees with it. This test is
written from the **same contract** the module's author was given, reproduced
below in full, so that where the two disagree the disagreement is real and
worth having. Q5T and Q6T are the same shape of job.

## The subject

`Godot/scripts/SpreadWords.gd`, `extends RefCounted`, statics only, no
preloads. It turns the shape of a fighter's seven attributes into the words a
player reads: which attribute is highest, which is lowest, how far apart the
ends are, where one attribute stands against the fighter's own average, and how
many attributes the record could not read.

The module never names an attribute itself — labels arrive already resolved and
are used verbatim. House separator is a space, a middle dot, a space: `" · "`.

## The contract you test against

### `list_phrase(labels: Array) -> String`
Entries that are not Strings, or are empty Strings, are dropped first. Then:
nothing left → `` ; one → `POWER` ; two → `POWER AND SPEED` ; three →
`POWER, SPEED AND DEFENSE` ; four or more → `A, B, C AND D`. The caller's order
is kept; the module never sorts.

### `highest_line(labels: Array) -> String`
`` when `list_phrase` is empty, else `"HIGHEST · " + list_phrase(labels)`.

### `lowest_line(labels: Array) -> String`
`` when `list_phrase` is empty, else `"LOWEST · " + list_phrase(labels)`.

### `spread_line(spread: int) -> String`
below 0 or above 100 → `` ; `0` → `EVERY ATTRIBUTE LEVEL` ; `1` →
`SPREAD 1 POINT` ; 2 and above → `SPREAD 7 POINTS` for 7.

### `standing_word(sign: int) -> String`
`1` → `ABOVE THIS FIGHTER'S OWN AVERAGE` ; `0` → `AT THIS FIGHTER'S OWN
AVERAGE` ; `-1` → `BELOW THIS FIGHTER'S OWN AVERAGE` ; anything else → ``.

### `stat_standing_line(label: String, standing: String) -> String`
`` when either argument is empty, else `label + " · " + standing`.

### `unknown_line(count: int) -> String`
`0` or below → `` ; `1` → `1 ATTRIBUTE NOT RECORDED` ; 2 and above →
`4 ATTRIBUTES NOT RECORDED` for 4.

Every function returns the empty String rather than a placeholder. There is no
`NONE`, no `—`, no `N/A`.

## The shape every test in this project has

```gdscript
extends SceneTree

func _initialize() -> void:
    var W = load("res://scripts/SpreadWords.gd")
    var fails := 0
    # ... checks, each printing a line on failure ...
    print("spread_words_test: %d failures" % fails)
    quit(0 if fails == 0 else 1)
```

`load()` inside `_initialize()`, never a top-level `preload`. One integer
failure counter, one summary line, exit 0 on pass and non-zero on failure. No
autoload, no `GameState`, no scene, no node.

## What must be covered

Compare every expected string with `==`, never with `begins_with` or a
substring search — the separators and the singular/plural are the whole point.

1. `list_phrase` at zero, one, two, three and four labels.
2. `list_phrase` dropping junk: `[]`, `[""]`, `["", "SPEED"]`,
   `[7, "SPEED"]`, `[null]`. Confirm `["", "SPEED"]` reads exactly `SPEED`,
   with no leading comma and no stray ` AND `.
3. `list_phrase` keeps the caller's order: `["SPEED", "POWER"]` is
   `SPEED AND POWER`, not `POWER AND SPEED`.
4. `highest_line` and `lowest_line` with one label and with two, and both
   returning `` for `[]` and for `[""]`.
5. `spread_line` at `-1`, `0`, `1`, `2`, `7`, `100` and `101`. The singular
   at 1 and the plural at 2 each get their own check.
6. `standing_word` at `1`, `0`, `-1`, `2`, `-2` and `99`.
7. `stat_standing_line` with both arguments filled, with an empty label, with
   an empty standing, and with both empty.
8. `unknown_line` at `-3`, `0`, `1`, `2` and `7`.
9. One composed check: `stat_standing_line("GRAPPLE", standing_word(1))` is
   exactly `GRAPPLE · ABOVE THIS FIGHTER'S OWN AVERAGE`.
10. No function returns `NONE`, `UNKNOWN`, `N/A` or `-` anywhere in the cases
    above.

Around 30 checks. Do not stop at the first failure — count them all and print
the total, so one bad string does not hide six others.

## GDScript traps

- `%` inside a format string must be `%%`.
- Reusing one variable name twice inside a single function is a parse error,
  even in two separate `if` blocks.
- `var n := arr.size()` on an untyped value infers Variant; write
  `var n: int = ...`.
- A missing static on the module raises at call time; that is a real failure to
  report, not something to work around with `has_method` guards.

## Done means

**One file, `spread_words_test.gd`, sent as a file.** No module, no repository
command, no `HANDOFF.md`. Claude runs it against the delivered module and
reports which side was wrong.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/tests/spread_words_test.gd
```
