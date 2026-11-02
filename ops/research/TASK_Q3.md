# TASK Q3 — QWEN — THE WORDS FOR AN INJURY (PURE MODULE)

Model: Qwen3.8-Max, effort **high**. One session.

**You have no repository and you do not need one.** This file is complete:
every list, every rule and every string you need is written below. Do not ask
for a file, do not guess at one, and do not reference any path except the two
you write. Build and test in a throwaway Godot 4.7 project holding only your
two files. Claude splices them into the real repo, runs the real suite and
writes your `HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `InjuryWords.gd`
- `injury_words_test.gd`

**READ THE NAME CORRECTLY. This module is about WORDS, not about copying.**
It does not clone an injury, it does not duplicate a dictionary, it has no
`copy()`, no `_init()`, no instance variables and no state of any kind. A first
attempt at this task returned a thirteen-line object with a `copy()` method
that duplicated an injury; that is the opposite of the task. Every function
here is `static` and every one of them returns **display text**.

**This is the companion to Q2, not a rewrite of it.** Q2's `Injury.gd` decides
what an injury IS — the type, the weeks, the hold, the grade. Q3 decides what a
SCREEN SAYS about it. Q3 computes nothing, stores nothing and never returns a
number it made up. If you are writing arithmetic, you are in the wrong module.

## Why this exists

FightCamp's fighter profile has a BODY LAB tab: six regions, each a 0-100
readiness number, plus one medical hold. A research pass (J13) ruled that a
region also carries a **named injury** when tissue is actually hurt, and Q2
builds that injury. A screen task (U9, Cursor) will print it.

Left alone, that screen invents its own words — and it will get the one thing
that matters wrong. Every number an injury carries is **graded**, because
almost none of them are sourced:

- `"DIRECT"` — a real published rule. Three of these exist in the whole game.
- `"AUTHORED"` — the game invented a plausible number. Most of them.
- `"UNKNOWN"` — no defensible number exists; `weeks` is 0.

A screen that prints an `AUTHORED` week the same way it prints a `DIRECT` one
tells the player a made-up date is a medical fact. **That is the bug this
module exists to prevent**, and it is the reason the phrasing lives in one
tested module instead of in a panel's string concatenation.

## The closed lists

Restated here so this file stands alone. Do not add to them, and do not invent
a type, a region or a flag that is not here.

**The eight types** (`type_id`):

| `type_id` | plain label |
|---|---|
| `contusion` | BRUISING |
| `laceration` | CUT |
| `concussion_rhi` | HEAD KNOCK |
| `fracture` | BREAK |
| `muscle_strain` | MUSCLE STRAIN |
| `ligament_joint` | JOINT / LIGAMENT |
| `dislocation` | DISLOCATION |
| `ocular_orbital` | EYE INJURY |

**The six regions** (`region`):

| `region` | plain label |
|---|---|
| `head_neck` | HEAD / NECK |
| `torso_core` | TORSO / CORE |
| `left_arm` | LEFT ARM |
| `right_arm` | RIGHT ARM |
| `left_leg` | LEFT LEG |
| `right_leg` | RIGHT LEG |

Those region labels are the ones the game already prints. They are not yours to
restyle.

**Severity** is `1`, `2` or `3`: `MINOR`, `MODERATE`, `SERIOUS`. Nothing
stronger than SERIOUS, and no adjective outside those three.

**Treatment paths**: `conservative` → `MANAGED`, `surgical` → `SURGERY`,
`""` → `""` (say nothing).

**Clearance flags**: `physician` → `TEAM DOCTOR`, `specialist` → `SPECIALIST`,
`ophthalmologist` → `EYE SPECIALIST`. Any other flag returns `""`.

## The injury dictionary you are handed

U9 passes you what Q2's `build()` returned. You may read these keys and no
others:

```gdscript
{
  "type_id": "fracture", "region": "left_arm", "severity": 2,
  "onset_week": 41, "train_week": 45, "compete_week": 49,
  "hold_until_week": 49, "sets_hold": true,
  "treatment_path": "conservative",
  "clearance_flags": ["physician", "specialist"],
  "re_injury": false,
  "grades": {"train": "AUTHORED", "compete": "DIRECT", "hold": "DIRECT"},
}
```

An empty dictionary means **no injury**, and every function must survive it:
the region is merely sore, and a sore region says nothing at all. Returning
`"NONE"` or `"NO INJURY"` is wrong — the screen prints your string verbatim,
and a clear body must stay clear.

## The phrasing contract — the heart of this task

For a week number, the words are chosen by that number's grade:

| grade | shape | example |
|---|---|---|
| `DIRECT` | flat statement | `CLEARED TO FIGHT WEEK 49` |
| `AUTHORED` | attributed estimate | `THE GYM ESTIMATES WEEK 49` |
| `UNKNOWN` | refusal | `NO DATE SET` |

**The grade word itself never appears in a returned string.** `AUTHORED`,
`DIRECT` and `UNKNOWN` are internal vocabulary; a player reads "THE GYM
ESTIMATES", never "AUTHORED". A returned string containing any of those three
words is a failed task.

A week of `0` is `NO DATE SET` regardless of grade — there is no week zero.

## The API

Statics only. No `class_name`. No `preload`. No node access, no RNG, no file
access, no `GameState`, no `Injury`, no `BodyReadiness`. Strings only, plus the
small dictionaries described below.

```gdscript
extends RefCounted

const TYPE_LABELS: Dictionary   # type_id -> plain label
const REGION_LABELS: Dictionary # region -> plain label
const SEVERITY_WORDS: Array     # ["", "MINOR", "MODERATE", "SERIOUS"]

## Plain labels. An id that is not in the list returns "" — never the raw id,
## never a prettified guess.
static func type_label(type_id: String) -> String
static func region_label(region: String) -> String
static func severity_word(severity: int) -> String
static func treatment_word(path: String) -> String
static func clearance_word(flag: String) -> String

## "SERIOUS BREAK · LEFT ARM". Severity first, then the type, then the region.
## Returns "" for an empty or unrecognised injury.
static func headline(injury: Dictionary) -> String

## The graded week line for one date. `which` is "train", "compete" or "hold";
## anything else returns "". Reads the matching key and its grade.
static func date_line(injury: Dictionary, which: String) -> String

## Both dates as one array of lines, training first, skipping a line that is
## empty. Never merges the two dates into one: they are different dates.
static func date_lines(injury: Dictionary) -> Array

## The clearances this injury waits on, as labels, in the order given.
## Unknown flags are dropped, not passed through.
static func clearance_words(injury: Dictionary) -> Array

## Everything a screen needs, in one call, so a panel never assembles strings:
## {"headline": String, "dates": Array, "clearances": Array,
##  "treatment": String, "re_injury": String}
## `re_injury` is "SAME INJURY AGAIN" when the flag is true, otherwise "".
static func lines(injury: Dictionary) -> Dictionary
```

## Refusals — each of these is a failed task

- **No medical prose.** No anatomy beyond the type label, no ICD-10 codes, no
  mechanism, no treatment description, no advice. A player is a gym owner, not
  a physician.
- **No judgement of the fighter.** Never "fragile", "injury-prone", "made of
  glass", "declining", "finished". A count is a fact; a verdict is not yours.
  This is a standing project rule (K24) and it is not negotiable.
- **No age.** Nothing you return may mention age, and no function takes it.
- **No number you made up.** You print the weeks you are handed. You never
  compute a week, add to one, or fill a missing one.
- **No grade words in output.** See the phrasing contract.
- **No sentence case, no punctuation flourishes.** This game's screens are
  upper case with `·` as the separator. `SERIOUS BREAK · LEFT ARM`, not
  `Serious break (left arm).`
- **No `preload`, no autoload, no `class_name`.** The module must load and run
  in an empty project containing only your two files.

## The test

`injury_words_test.gd` follows the house pattern exactly — `extends SceneTree`,
a `load()` of the module by path, `_check(condition, message)` printing `OK:`
or `FAIL:`, and a final line plus `quit()`:

```gdscript
extends SceneTree
## Q3: InjuryWords, pure. Strings only - no career, save, GameState or Injury.

var failures := 0


func _initialize() -> void:
	var Words = load("res://scripts/InjuryWords.gd")
	_check(Words.type_label("fracture") == "BREAK", "fracture reads BREAK")
	# ... your cases ...
	print("Q3 injury words: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: every one of the eight types and six regions has a label; an
unknown id returns `""`; an empty dictionary returns `""` from `headline` and
empty collections from the rest; a `DIRECT` week states the week and an
`AUTHORED` week attributes it; an `UNKNOWN` grade and a week of `0` both give
`NO DATE SET`; **no returned string anywhere contains `AUTHORED`, `DIRECT` or
`UNKNOWN`** — assert that directly, over every string `lines()` returns for a
sample of each type; `date_lines` keeps training and competition separate; an
unrecognised clearance flag is dropped; `re_injury` false returns `""`.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs for indentation. Two of these will bite this task
specifically:

- **`:=` fails on a Variant.** `var g := injury.get("grades", {})` is a parse
  error, because `.get()` on an untyped value returns Variant — and so does
  every static you call through a `load()`ed script, which is exactly how the
  test reaches your module. Write the type: `var grades: Dictionary = ...`,
  `var line: String = Words.date_line(...)`. This will hit your test on the
  first line that reads a returned value.
- **A name may be declared once per function.** Reusing `var line` in two
  separate `if` or `for` blocks inside the same function is a parse error, not
  a shadow. Your `_initialize()` will hold many cases in one function — give
  each its own name (`line_train`, `line_hold`) or the file will not parse.
- **`%` in a format string must be `%%`.** `"%d%% clear"`, never `"%d% clear"`.

`extends RefCounted` at the top of the module, `extends SceneTree` in the test.
A `class_name` would collide on splice.

## The one trap

The temptation is to make the words *kind* — to soften a `SERIOUS` into
something gentler, to fill `NO DATE SET` with "SOON", to turn an estimate into
a promise because the blank looks unfinished on screen. Every one of those is
the same mistake in a different coat: the screen would state as fact a thing
nobody knows. The blank is the honest answer, and the test should assert it
stays blank.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/InjuryWords.gd
Godot/tests/injury_words_test.gd
Godot/scripts/Injury.gd
```
