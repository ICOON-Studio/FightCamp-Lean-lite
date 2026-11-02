# TASK Q6T — QWEN — THE TEST FOR THE SEVEN ATTRIBUTES

Model: Qwen3.8-Max, effort **high**. One session. Runs alongside Q6 — you do
NOT need Q6's module to exist, and you must not wait for it.

**You have no repository and you do not need one.** This file is complete.

## ONE FILE. THE TEST. DO NOT SEND A MODULE.

1. `stat_words_test.gd` — and nothing else.

If you find yourself writing `StatWords.gd`, stop: that is someone else's task
and your copy would be discarded.

## Why this task exists separately

You are writing a test for a module **you have not seen and will not see.**
That is the point. A test written against an implementation only agrees with
it; a test written against the contract catches the case the implementation
forgot. On the previous pair this arrangement caught two real bugs within a
minute of the module arriving.

Everything the module must do is written below. Write the test that would catch
someone breaking it.

## The module under test

Loaded as `res://scripts/StatWords.gd`, `extends RefCounted`, every function
static. It is the one place an attribute id becomes a label, a one-line gloss,
and a band word for its value.

```gdscript
const STAT_IDS: Array          # the seven, in the order below
const STAT_LABELS: Dictionary  # id -> label
const STAT_GLOSSES: Dictionary # id -> the one-line meaning, upper case

## An id outside the seven returns "" from all three - never the raw id,
## never a title-cased guess.
static func label(stat_id: String) -> String
static func gloss(stat_id: String) -> String

## A 0-100 value as a word. Four bands, nothing between them:
##   0-39 POOR, 40-59 FAIR, 60-79 STRONG, 80-100 ELITE.
## A value outside 0-100 returns "".
static func band_word(value: int) -> String

## "POWER 82 · ELITE". An unknown id, or a value outside 0-100, returns "".
static func stat_line(stat_id: String, value: int) -> String

## The seven ids in display order, so a caller never hardcodes six.
static func ordered_ids() -> Array
```

The closed list — seven ids, this order, these exact strings:

| id | label | gloss |
|---|---|---|
| `power` | `POWER` | `DAMAGE ONCE A STRIKE LANDS` |
| `technique` | `TECHNIQUE` | `THE QUALITY OF THE ACTION` |
| `speed` | `SPEED` | `WHO ACTS FIRST` |
| `defense` | `DEFENSE` | `AVOIDING WHAT LANDS, AND RESISTING A SUBMISSION` |
| `conditioning` | `CONDITIONING` | `HOLDING THE PACE` |
| `fight_iq` | `FIGHT IQ` | `CHOOSING THE RIGHT THING` |
| `grapple` | `GRAPPLE` | `WHO TAKES THE FIGHT TO THE CLINCH OR THE MAT` |

Separator is ` · `, everything upper case.

## What your test must catch

One check per line, with a message that says what broke.

**All seven, exactly.** Each id returns its exact label and its exact gloss.
Compare full strings, not `contains` — a gloss that has been "improved",
lengthened or reworded must fail.

**Seven, not six.** `ordered_ids()` returns exactly seven ids, in the table's
order, and `grapple` is among them. Assert the size is 7 and assert the order
element by element — `grapple` was added to this game after six had been
hardcoded in a dozen places, and a module that appends it in the wrong position
still passes a naive "does it contain grapple" check.

**Every band boundary, on both sides.** 39 against 40, 59 against 60, 79
against 80. Off-by-one at a boundary is the single likeliest bug in this
module, and only a both-sides check finds it. Also assert 0 and 100 are
INSIDE the range (`POOR` and `ELITE`, not `""`), and that -1 and 101 return
`""`.

**`stat_line` composes and refuses.** `stat_line("power", 82)` is exactly
`POWER 82 · ELITE`. An unknown id returns `""`. A value of -1 or 101 returns
`""` even when the id is valid — assert that directly, because a module that
composes the line before validating the value will happily print
`POWER 101 · `.

**No unknown id ever leaks.** `label`, `gloss` and `stat_line` on ids like
`pressure`, `chin`, `strength`, `cardio` and `""` all return `""`. Assert the
returned value is empty, not merely "not the raw id".

**The rejected stats appear nowhere.** Run every id through every function and
assert that no returned string anywhere contains `PRESSURE`, `CHIN`,
`DURABILITY`, `FOOTWORK`, `STRENGTH` or `CARDIO`. Each was considered and
rejected by the research; a word for one of them here would put a name on a
stat that does not exist.

**No verdict on a fighter.** Assert no returned string contains `WEAK`,
`LIABILITY`, `WASHED`, `STAR`, `SPECIAL`, `NEEDS`, `TRAIN`, `FOCUS`. The
module describes a number and never advises.

## House pattern, exactly

```gdscript
extends SceneTree
## Q6T: StatWords, pure. Ids and numbers in, English out. No career, save or
## GameState. What this file really guards: seven attributes, four bands with
## exact boundaries, and a word that never judges the fighter.

var failures := 0


func _initialize() -> void:
	var Words = load("res://scripts/StatWords.gd")
	_test_the_seven_labels(Words)
	# ... your groups ...
	print("Q6T stat words: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Group the checks into `_test_*(Words)` functions — one flat function of eighty
checks is a file nobody can read a failure out of.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs.

- **`:=` fails on a Variant**, and every value returned by a `load()`ed script
  is a Variant — which is exactly how your test reaches the module. Write
  `var line: String = str(Words.stat_line("power", 82))`, never
  `var line := Words.stat_line("power", 82)`. For `ordered_ids()` write
  `var ids: Array = Words.ordered_ids()`.
- **A name may be declared once per function**, even across separate `if` and
  `for` blocks. Give each case its own name — `line_power`, `line_grapple`.
- **`%` in a format string must be `%%`.**
- No `preload`, no autoload, no `class_name`. `extends SceneTree`.

## The one trap

**The band is a word for a number, never a verdict on a fighter.** `POOR
GRAPPLE` on a boxer is not a flaw — a boxer is *supposed* to have a low grapple
number, because one stat set serves every discipline and grappling stats simply
sit low and never fire in a boxing bout. So do not write a test that expects
the module to soften, qualify or explain a low band, and do not expect it to
know what discipline anyone fights in. It has no discipline parameter and must
never appear to have one: assert that `band_word` depends on the value ALONE —
the same number returns the same word regardless of which stat it belongs to,
so check `band_word(30)` is `POOR` and that `stat_line("grapple", 30)` and
`stat_line("power", 30)` carry that same `POOR` unchanged.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/tests/stat_words_test.gd
Godot/scripts/StatWords.gd
```
