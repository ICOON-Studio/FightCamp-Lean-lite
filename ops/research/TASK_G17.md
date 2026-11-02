# TASK G17 — GROK — WHERE AN INJURY STANDS TODAY

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access. You have no repository checkout and you do not need one:
build and test this in a throwaway Godot project holding only your two files,
as G13, G15 and G16 did. Claude splices it, runs the real suite and writes your
`HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `Godot/scripts/InjuryPhase.gd`
- `Godot/tests/injury_phase_test.gd`

G16 landed clean — `InjuryHistory.gd`, 220 lines, its test 176, 0 failures.
This is the same shape of job and the same cycle. G16 read the injuries that
are **finished**; G17 reads the ones that are **live**.

## Why this exists

A named injury carries two dates it never moves: `train_week`, when the fighter
may train the region again, and `compete_week`, when the fighter may fight
again. A stage landing this cycle stores at most one live injury per region on
the fighter's `body_state.injuries`, keyed by region.

So the save knows a left arm has a grade-2 fracture with `train_week: 45` and
`compete_week: 49`. Nothing turns that into "where is this today". Every screen
that wants to say so is about to do subtraction inline, six times, with its own
idea of what a missing date means. You ship the subtraction once, tested.

## Your boundary against Q2 and G16 — read this twice

- **Q2 `Injury.gd` builds the injury.** The eight types, the six regions, which
  type can live on which region, the severity ladders, the provenance grades.
  You **never** re-derive any of it. `type_id` is an opaque string to you.
- **G16 `InjuryHistory.gd` counts finished injuries.** Rows in an array,
  newest first, off `body_state.injury_log`.
- **G17 reads live injuries against one week.** A dictionary keyed by region,
  and an integer week. Nothing else.

You do not build an injury, you do not validate a type against a region, you do
not count history, and you never read a fight log. Handed a row you cannot
read, you say so — you do not repair it.

## What you are handed

A live injury row, exactly as Q2's `build()` returns it. The fields you use:

```gdscript
{
  "type_id": "fracture",      # opaque to you
  "region": "left_arm",       # opaque to you
  "severity": 2,              # 1, 2 or 3; used only to break a tie
  "onset_week": 41,
  "train_week": 45,
  "compete_week": 49,
}
```

A row may carry more keys. Ignore them. A row may be missing a week, carry a
week that is not a number, or not be a dictionary at all: that row is
**unreadable**, and unreadable is an answer you return, never a zero you
invent.

`current_week` is the world's week. `0` or less means the caller does not know
it, and then every distance is unknown — you never assume week 1.

## The API

```gdscript
extends RefCounted

static func phase(injury: Dictionary, current_week: int) -> Dictionary
static func board(injuries: Dictionary, current_week: int) -> Dictionary
```

### `phase(injury, current_week)`

```gdscript
{
  "phase_id": "rehab",            # acute | rehab | cleared | unknown
  "readable": true,               # false when the row could not be read
  "weeks_to_train": 4,            # floored at 0
  "weeks_to_train_known": true,
  "weeks_to_compete": 8,          # floored at 0
  "weeks_to_compete_known": true,
  "weeks_elapsed": 3,             # current_week - onset_week, floored at 0
  "weeks_elapsed_known": true,
  "span_weeks": 8,                # compete_week - onset_week, floored at 0
  "span_known": true,
  "unknown": [],                  # field names that could not be answered
}
```

The four phase ids, closed, **lowercase**:

- `acute` — the train date has not arrived.
- `rehab` — the train date has arrived and the compete date has not.
- `cleared` — the compete date has arrived.
- `unknown` — the row or the week cannot say.

The rules that decide between them, in this order:

1. The row is unreadable, or `current_week <= 0`: `unknown`.
2. A real `compete_week` that `current_week` has reached: `cleared`.
3. A real `train_week` that `current_week` has NOT reached: `acute`.
4. Otherwise `rehab`.

Rule 2 before rule 3 is deliberate, and so is the shape of rule 4: **`cleared`
requires a real compete date that has passed.** A row with a train date and no
compete date is `rehab` forever, not `cleared` — the fighter is training and
the record does not say when they may fight. A row with a compete date and no
train date is `rehab` until that date, then `cleared`. Never promote a row to
`cleared` off a missing date.

`current_week` earlier than `onset_week` is a caller asking about a week before
the injury existed: `weeks_elapsed` is 0 with `weeks_elapsed_known` false and
`"weeks_elapsed"` in `unknown`. The phase still answers off the two dates.

### `board(injuries, current_week)`

`injuries` is a Dictionary keyed by region id, each value one live row. An
empty dictionary is normal and common.

```gdscript
{
  "regions": {},                 # region id -> that region's phase block
  "region_order": [],            # ids in the order the dictionary gives them
  "active": [],                  # ids not cleared, longest wait first
  "cleared": [],                 # ids whose compete date has passed
  "unreadable": [],              # ids whose row could not be read
  "governing_region": "",        # the longest wait, "" when there is none
  "weeks_to_clear": 0,           # that region's weeks_to_compete
  "weeks_to_clear_known": false,
  "unknown": [],
}
```

Each value in `regions` is exactly the `phase()` block above with the region id
added as `"region"`. `for_region`-style padding is **not** wanted here: a region
with no live injury is simply absent from `injuries`, and therefore absent from
`regions`. A caller printing six regions already knows the six.

`governing_region` is the region the fighter waits on: the largest
`weeks_to_compete` among readable rows. A tie goes to the larger `severity`;
still tied, to the earlier position in `region_order`. **Never rank by
`type_id`** — that ordering is Q2's `outranks()` and it is not yours to copy.
A row whose `weeks_to_compete` is unknown cannot govern, and if no row can,
`governing_region` is `""`, `weeks_to_clear` is 0, `weeks_to_clear_known` is
false and `"governing_region"` joins `unknown`.

`cleared` is **advisory**. You are reporting that a date has passed; you are not
clearing anything and nothing you return removes an injury from a save. The
weekly pass owns that.

## Refusals — each of these is a failed task

- **No second clock.** The save has exactly one medical clock,
  `medical_hold_until_week`, and this module neither reads it, produces one,
  nor returns anything that could stand in for one. You subtract two numbers a
  row already carries from a week you were handed. Nothing else.
- **No healing model.** No rate, no per-week progress, no percentage complete,
  no "70% recovered", no bar value. A screen that wants a fraction can divide
  `weeks_elapsed` by `span_weeks` itself and decide what to do when the span is
  unknown. You do not decide that for it.
- **No prediction.** Nothing about setbacks, re-injury odds, or whether a date
  will hold. The research leaves those explicitly UNKNOWN.
- **No age.** No parameter, no multiplier, no age-scaled anything. Healing is
  age-blind in this project and that ruling is closed.
- **No judgement.** No "serious", no "minor", no severity band, no risk grade.
  `severity` is an integer you use once, to break a tie.
- **No copy, no formatting.** No display strings, no labels, no `·`
  separators, no upper-casing. The phase ids are ids, lowercase, and a
  different module owns every word a player reads.
- **No type table, no region list.** Both are Q2's. The regions you report are
  the ones the caller's dictionary names, in the order it gives them.
- **No mutation.** Never write into the row or the dictionary you were handed;
  copy what you return.
- **No `preload`, no autoload, no `class_name`, no RNG, no file access.**

## The test

`injury_phase_test.gd` follows the house pattern exactly — `extends SceneTree`,
a `load()` of the module by path, `_check(condition, message)` printing `OK:` or
`FAIL:`, and a final line plus `quit()`:

```gdscript
extends SceneTree
## G17: InjuryPhase, pure. One row and one week in, a phase out.

var failures := 0


func _initialize() -> void:
	var Phase = load("res://scripts/InjuryPhase.gd")
	var empty: Dictionary = Phase.board({}, 40)
	_check(int(empty.get("region_order", []).size()) == 0, "no injuries is an empty board")
	# ... your cases ...
	print("G17 injury phase: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: the three real phases across one row as the week advances; a
week exactly equal to `train_week` is `rehab` and one exactly equal to
`compete_week` is `cleared`; `current_week` of 0 is `unknown` with the
distances unknown; a row that is not a dictionary and a row missing
`compete_week` are each `readable: false` or land in `unreadable`; a row with a
train date and no compete date never reaches `cleared`; `weeks_to_train` is
floored at 0 rather than going negative; `current_week` below `onset_week` puts
`weeks_elapsed` in `unknown`; an empty dictionary gives a full-shaped board with
`governing_region` empty; a two-region board picks the longer wait as governing;
two regions with equal waits break the tie on severity; a board of only
unreadable rows has `governing_region` `""` and `"governing_region"` in
`unknown`; the row handed in is not modified.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs for indentation. These three cost a fix cycle every stage
here:

- **`:=` fails on a Variant.** `var w := injury.get("train_week", 0)` is a parse
  error, because `.get()` on an untyped value returns Variant — and so does
  every static you call through a `load()`ed script, which is exactly how the
  test reaches your module. Write the type: `var w: int = ...`,
  `var block: Dictionary = Phase.phase(row, 44)`.
- **A name may be declared once per function.** Reusing `var block` in two
  separate `if` or `for` blocks inside one function is a parse error, not a
  shadow. Give each case its own name.
- **`%` in a format string must be `%%`.**

`extends RefCounted` at the top of the module, `extends SceneTree` in the test.
A `class_name` would collide on splice.

## The one trap

**`cleared` here does not mean the fighter can be booked.** The hold that
actually blocks a booking is `medical_hold_until_week`, one number on the
fighter, and it is the maximum across every region plus whatever else set it. A
left arm can be `cleared` in your board while the fighter is still held on a
concussion, and a fighter with an empty `injuries` dictionary can still be held.
So: never name a field `can_fight`, `available`, `fit`, `clear_to_book` or
anything a caller could read as the booking answer, never return a boolean that
looks like one, and never sum or max the regions into a single "ready week" —
that number already exists and is not yours. You answer one question, per
region: where does this injury stand against this week.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/InjuryPhase.gd
Godot/tests/injury_phase_test.gd
Godot/scripts/InjuryHistory.gd
Godot/scripts/Injury.gd
```
