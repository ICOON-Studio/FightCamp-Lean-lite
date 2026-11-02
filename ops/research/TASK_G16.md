# TASK G16 — GROK — THE INJURY LEDGER: WHAT A BODY HAS BEEN THROUGH

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access. You have no repository checkout and you do not need one:
build and test this in a throwaway Godot project holding only your two files,
as G9, G14 and G15 did. Claude splices it, runs the real suite and writes your
`HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `Godot/scripts/InjuryHistory.gd`
- `Godot/tests/injury_history_test.gd`

G15 landed clean — `BeltLineage.gd`, 132 lines, its test 205, parse gate and
suite both green. This is the same shape of job.

## Why this exists

The game tracks a fighter's body as six regions, each a 0-100 readiness number,
and a stage landing this cycle adds a **named injury** on a region when tissue
is actually hurt. When an injury runs its course it leaves the region and is
appended to a durable list on the fighter, newest first. Nothing else in the
save remembers that a fighter was ever hurt.

You ship the reading of that list: given the finished injuries and the current
week, what has this body been through, and where.

## Your boundary against G13 — read this twice

`RegionHistory.gd` is **G13, yours, already shipped**. It counts where a body
was **hit**: hotspot bouts, damage taken per region, the worst single bout, the
last week a region was named. It reads fight-log `body_damage` blocks.

`InjuryHistory.gd` counts what a body was **diagnosed with**. It reads injury
rows. The two never overlap:

- G13 answers "this arm absorbed a lot of punishment".
- G16 answers "this arm has been broken twice".

**Never re-derive one from the other.** You do not take damage numbers, you do
not take fight rows, and you never infer an injury from a hit. A region that
was battered every bout and never diagnosed has an empty ledger here, and that
is the correct answer.

## What you are handed

`summarize(rows, current_week)`. `rows` is an Array of Dictionaries, **newest
first**, each one a finished injury:

```gdscript
{
  "type_id": "fracture",      # one of the eight below
  "region": "left_arm",       # one of the six below
  "severity": 2,              # 1, 2 or 3
  "onset_week": 41,
  "train_week": 45,
  "compete_week": 49,
  "re_injury": false,
}
```

The eight `type_id`s, closed: `contusion`, `laceration`, `concussion_rhi`,
`fracture`, `muscle_strain`, `ligament_joint`, `dislocation`,
`ocular_orbital`.

The six `region`s, closed: `head_neck`, `torso_core`, `left_arm`, `right_arm`,
`left_leg`, `right_leg`.

**Rows arrive imperfect and you never fix them up.** A row missing a week, a
row naming a region or a type outside those lists, a row that is not a
dictionary at all: each is *counted as unusable* and named in the return, never
silently dropped and never defaulted into a number. That is how G13 handles a
missing body block (`unknown_bouts`), and this module does the same.

## The API

```gdscript
extends RefCounted

static func summarize(rows: Array, current_week: int) -> Dictionary
static func for_region(summary: Dictionary, region: String) -> Dictionary
```

`summarize` returns:

```gdscript
{
  "diagnoses": 4,             # usable rows
  "unusable_rows": 1,         # rows you refused to read
  "regions": {},              # region id -> the per-region block below
  "region_order": [],         # ids in the order first seen in rows
  "types": {},                # type_id -> count, usable rows only
  "weeks_lost": 12,           # summed, and only where both weeks are real
  "weeks_lost_known": true,   # false when any usable row could not say
  "last_onset_week": 41,      # 0 when nothing could say
  "weeks_since_last": 6,      # current_week - last_onset_week, floored at 0
  "repeat_sites": [],         # region ids with 2+ diagnoses, most first
  "unknown": [],              # field names that could not be answered
}
```

Each per-region block:

```gdscript
{
  "region": "left_arm",
  "diagnoses": 2,
  "types": {"fracture": 2},
  "worst_severity": 2,        # 0 when no usable row said
  "last_onset_week": 41,      # 0 when none said
  "weeks_lost": 8,
  "weeks_lost_known": true,
  "re_injuries": 1,           # rows whose re_injury flag was true
}
```

`for_region(summary, region)` returns that block, or a blank block of the same
shape for a region with nothing on it — never `{}`, so a caller can print a
clear region without a null check.

**Weeks lost** for one row is `compete_week - onset_week`, floored at 0, and
counted only when both weeks are present and real. A row that cannot say makes
`weeks_lost_known` false and contributes nothing; the number never absorbs a
guess.

`current_week` of 0 or less means the caller does not know the week:
`weeks_since_last` is then 0 and `"weeks_since_last"` joins `unknown`.

## Refusals — each of these is a failed task

- **No age.** No parameter, no multiplier, no age-scaled anything. Healing and
  history are age-blind in this project and that ruling is closed.
- **No judgement.** No "injury-prone", no "fragile", no durability score, no
  risk percentage, no grade, no band, no label. You return counts and weeks. A
  repeat site is a count of 2; it is never a verdict, and a screen decides what
  to make of it. This is a standing rule and the fastest way to fail this task.
- **No prediction.** Nothing about what will happen next, no odds of
  re-injury, no expected weeks. The research leaves those explicitly UNKNOWN.
- **No copy, no formatting.** No display strings, no upper-casing, no `·`
  separators, no labels. Another module owns the words.
- **No region list of your own.** The regions you report are the ones the rows
  actually name, in the order first seen — exactly as G13 does. Do not author
  the six and do not pad the result with regions nobody was hurt in.
- **No `preload`, no autoload, no `class_name`, no RNG, no file access.**

## The test

`injury_history_test.gd` follows the house pattern exactly — `extends
SceneTree`, a `load()` of the module by path, `_check(condition, message)`
printing `OK:` or `FAIL:`, and a final line plus `quit()`:

```gdscript
extends SceneTree
## G16: InjuryHistory, pure. Rows in, counts out. No career, save or GameState.

var failures := 0


func _initialize() -> void:
	var Hist = load("res://scripts/InjuryHistory.gd")
	var empty: Dictionary = Hist.summarize([], 40)
	_check(int(empty.get("diagnoses", -1)) == 0, "no rows is zero diagnoses")
	# ... your cases ...
	print("G16 injury history: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Cover at least: an empty array returns a full-shaped summary with zeros and no
crash; a row that is not a dictionary, a row with an unknown type and a row
with an unknown region each land in `unusable_rows`; `region_order` follows
first appearance, not alphabet; two diagnoses on one region make it a repeat
site and one does not; `worst_severity` takes the max, not the latest;
`weeks_lost` skips a row missing `compete_week` and sets `weeks_lost_known`
false; `current_week` of 0 puts `weeks_since_last` in `unknown`;
`for_region` returns a blank block for an untouched region.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs for indentation. These three cost a fix cycle every stage
here:

- **`:=` fails on a Variant.** `var n := row.get("severity", 0)` is a parse
  error, because `.get()` on an untyped value returns Variant — and so does
  every static you call through a `load()`ed script, which is exactly how the
  test reaches your module. Write the type: `var n: int = ...`,
  `var block: Dictionary = Hist.for_region(summary, "left_arm")`.
- **A name may be declared once per function.** Reusing `var block` in two
  separate `if` or `for` blocks inside one function is a parse error, not a
  shadow. Give each case its own name.
- **`%` in a format string must be `%%`.**

`extends RefCounted` at the top of the module, `extends SceneTree` in the test.
A `class_name` would collide on splice.

## The one trap

The list you are handed is **finished injuries only** — an injury still live on
a region is not in it. So a fighter who is hurt right now can have an empty
ledger, and the module must not treat that as "never injured": it is "nothing
has finished yet". Do not add a "currently injured" field, do not accept the
live injury as a row, and do not let `diagnoses: 0` imply a clean history. The
caller holds the live injury already; your job is only the record behind it.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/InjuryHistory.gd
Godot/tests/injury_history_test.gd
Godot/scripts/BeltLineage.gd
Godot/scripts/RegionHistory.gd
```
