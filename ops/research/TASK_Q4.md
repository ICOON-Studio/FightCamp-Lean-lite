# TASK Q4 — QWEN — THE WORDS FOR WHERE A BODY STANDS

Model: Qwen3.8-Max, effort **high**. One session. **First of three** (Q4, then
Q5, then Q6) — do Q4 alone and deliver it before opening the next.

**You have no repository and you do not need one.** This file is complete.
Build and test in a throwaway Godot 4.7 project holding only your two files.

## DELIVER BOTH FILES. BOTH. NOT ONE.

1. `RecoveryWords.gd`
2. `recovery_words_test.gd`

On Q2 and again on Q3 you sent the module and no test, and Claude wrote the
test both times. **A single file is an incomplete delivery.** Send both, in one
message, each in its own clearly labelled code block.

## Why this exists

An injury on a body region carries two dates it never moves, and two shipped
modules already turn those dates into **ids**: `acute`, `rehab`, `cleared`,
`unknown` for where the injury stands this week, and `injury_pre_training` /
`injury_pre_competition` for why a region's condition has stopped climbing.

Ids are not words. A screen that prints `injury_pre_competition` at a player
has failed, and a screen that invents its own phrasing will phrase the same
state three different ways on three tabs. You ship the one tested place those
ids become English.

`InjuryWords.gd` (Q3, yours, landed) already owns the injury's **labels** —
type, region, severity, dates. This module owns **where it stands**. The two
never overlap and, because a pure module may not preload another, **this module
never reproduces a label Q3 owns**: where a line needs the region's name, the
caller passes the already-worded string in.

## The API

```gdscript
extends RefCounted

const PHASE_WORDS: Dictionary   # phase id -> plain words
const CEILING_WORDS: Dictionary # ceiling reason id -> plain words

## An id outside the closed list returns "" - never the raw id, never a
## prettified guess, never a cheerful default.
static func phase_word(phase_id: String) -> String
static func ceiling_word(reason_id: String) -> String

## "OUT OF TRAINING" plus the weeks, when the weeks are known.
## `weeks_known` false means the number is NOT printed at all - not "0 WEEKS",
## not "SOON", not "A FEW WEEKS".
static func phase_line(phase_id: String, weeks: int, weeks_known: bool) -> String

## The region's already-worded name is passed IN by the caller, because this
## module does not own region labels and must not carry a second copy of them.
## region_words == "" returns the line without a region rather than a blank gap.
static func region_line(region_words: String, phase_id: String, reason_id: String) -> String
```

The four phase ids, closed, and their words:

| id | words |
|---|---|
| `acute` | `OUT OF TRAINING` |
| `rehab` | `TRAINING ONLY` |
| `cleared` | `CLEARED` |
| `unknown` | `NOT KNOWN` |

The two ceiling reason ids, closed, and their words:

| id | words |
|---|---|
| `injury_pre_training` | `HELD BACK BY THE INJURY` |
| `injury_pre_competition` | `NOT CLEARED TO FIGHT` |

`phase_line` shape: the phase words, then ` · ` and the weeks, when known —
`OUT OF TRAINING · 4 WEEKS`, and `OUT OF TRAINING · 1 WEEK` for exactly one.
When `weeks_known` is false the line is the phase words alone.

`region_line` shape: the region words, ` · `, the phase words, and — only when
the reason id is one of the two above — ` · ` and the reason words. An empty
`region_words` drops that segment and its separator.

## Refusals — each of these is a failed task

- **No judgement of the fighter.** Never "fragile", "injury-prone", "made of
  glass", "declining", "finished", "getting old". This is a standing project
  rule and the fastest way to fail this task.
- **No age, ever.** No parameter, no mention.
- **No number you were not handed.** You never compute weeks, never add to
  them, never fill a missing one.
- **No medical prose, no advice, no anatomy** beyond the words in the tables.
- **No softening.** `NOT KNOWN` stays `NOT KNOWN`. Never "SOON", never
  "SHORTLY", never a promise the record cannot make. The blank is the honest
  answer.
- **No sentence case.** Upper case, `·` as the separator — this game's screens.
- **No `preload`, no autoload, no `class_name`.** It must run in an empty
  project holding only your two files.

## The test

House pattern exactly: `extends SceneTree`, `load()` the module by path,
`_check(condition, message)` printing `OK:` or `FAIL:`, a final line and
`quit()`.

```gdscript
extends SceneTree
## Q4: RecoveryWords, pure. Ids in, English out. No career, save or GameState.

var failures := 0


func _initialize() -> void:
	var Words = load("res://scripts/RecoveryWords.gd")
	_check(str(Words.phase_word("acute")) == "OUT OF TRAINING", "acute reads OUT OF TRAINING")
	# ... your cases ...
	print("Q4 recovery words: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: all four phase ids and both reason ids return their exact
words; an unknown id returns `""` from each; `phase_line` prints `1 WEEK`
singular and `4 WEEKS` plural; `weeks_known` false prints no number at all —
assert the returned string contains no digit; `region_line` with an empty
`region_words` has no leading separator; `region_line` with an unrecognised
reason id omits that segment rather than printing the id; **no returned string
anywhere contains a raw id** (`acute`, `injury_pre_training`, …) — assert that
directly over every function.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs. Two will bite this task:

- **`:=` fails on a Variant.** `var w := PHASE_WORDS.get(id, "")` is a parse
  error, and so is every `:=` on a value returned by a `load()`ed script —
  which is exactly how the test reaches your module. Write the type:
  `var w: String = ...`. A `-> String` function returning a `.get()` should
  return `str(...)`.
- **A name may be declared once per function.** Your `_initialize()` will hold
  many cases; give each its own name (`line_acute`, `line_rehab`) or the file
  will not parse.

`extends RefCounted` on the module, `extends SceneTree` on the test.

## The one trap

**`cleared` here does not mean the fighter can be booked.** It means one
injury's own date has passed. A different number entirely — the medical hold —
decides whether a fight can be signed, and a fighter can read `CLEARED` on one
region while still being held on another. So never write a word that sounds
like the booking answer: no `AVAILABLE`, no `FIT`, no `READY`, no `GOOD TO GO`.
`CLEARED` is exactly as far as this module is allowed to go.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/RecoveryWords.gd
Godot/tests/recovery_words_test.gd
Godot/scripts/InjuryWords.gd
```
