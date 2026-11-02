# TASK Q5T — QWEN — THE TEST FOR A BODY'S RECORD

Model: Qwen3.8-Max, effort **high**. One session. Runs alongside Q5 — you do
NOT need Q5's module to exist, and you must not wait for it.

**You have no repository and you do not need one.** This file is complete.

## ONE FILE. THE TEST. DO NOT SEND A MODULE.

1. `ledger_words_test.gd` — and nothing else.

If you find yourself writing `LedgerWords.gd`, stop: that is someone else's
task and your copy would be discarded.

## Why this task exists separately

You are writing a test for a module **you have not seen and will not see.**
That is the point. A test written against an implementation only agrees with
it; a test written against the contract catches the case the implementation
forgot. Everything the module is required to do is written below, and the
module's author has been told the API is a contract, not a suggestion.

Write the test that would catch them breaking it.

## The module under test

Loaded as `res://scripts/LedgerWords.gd`, `extends RefCounted`, every function
static. It turns a career injury ledger's **numbers** into lines a screen can
print. It never judges the fighter.

```gdscript
## "4 DIAGNOSES" / "1 DIAGNOSIS" / "" for a clean record.
static func diagnoses_line(summary: Dictionary) -> String

## "12 WEEKS LOST", "" when weeks_lost_known is false.
static func weeks_lost_line(summary: Dictionary) -> String

## "LAST INJURY 6 WEEKS AGO", "" when the record cannot say.
static func since_last_line(summary: Dictionary) -> String

## "LEFT ARM · 2 DIAGNOSES · 8 WEEKS LOST" — the region's already-worded name
## is passed IN, and any segment the block cannot say is dropped.
static func region_line(region_words: String, block: Dictionary) -> String

## "1 BOUT THE RECORD CANNOT READ" / "" when there are none.
static func unusable_line(summary: Dictionary) -> String

## {"diagnoses": String, "weeks_lost": String, "since_last": String,
##  "unusable": String} — all four keys ALWAYS, empty strings included.
static func lines(summary: Dictionary) -> Dictionary
```

The summary it is handed:

```gdscript
{
  "diagnoses": 4,             # usable rows
  "unusable_rows": 1,         # rows that could not be read
  "weeks_lost": 12,
  "weeks_lost_known": true,   # false when a row could not say
  "last_onset_week": 41,
  "weeks_since_last": 6,
  "repeat_sites": ["left_arm"],
  "unknown": ["weeks_since_last"],
}
```

A per-region block:

```gdscript
{
  "region": "left_arm", "diagnoses": 2, "types": {"fracture": 2},
  "worst_severity": 2, "last_onset_week": 41,
  "weeks_lost": 8, "weeks_lost_known": true, "re_injuries": 1,
}
```

**A field named in `unknown`, or a `*_known` flag that is false, is not
printable.** Not zero, not "none", not "0 WEEKS". The record cannot say it.

Separator is ` · `, everything upper case.

## What your test must catch

Each of these is a case the module could plausibly get wrong. Write one check
per line, with a message that says what broke.

**Singular and plural, on every line that carries a number.** `1 DIAGNOSIS`
against `2 DIAGNOSES`, `1 WEEK LOST` against `8 WEEKS LOST`, `1 BOUT` against
`3 BOUTS`, `1 WEEK AGO` against `6 WEEKS AGO`. A module that pluralises with a
bare `+ "S"` passes the plural case and fails the singular — check both.

**The clean record is silent.** `diagnoses: 0` returns `""` from
`diagnoses_line`. Assert directly that it is not `NONE`, not `CLEAN`, not
`NO INJURIES`, not `0 DIAGNOSES` — and assert the returned string is empty
rather than merely "not one of those words".

**An unsayable number prints no number.** With `weeks_lost_known: false`,
`weeks_lost_line` returns `""` — and assert the string contains **no digit at
all**, character by character, rather than only comparing it to `""`. Same for
a field listed in `unknown`: put `weeks_since_last` in the `unknown` array with
a real value still sitting in the dictionary beside it, and assert
`since_last_line` prints nothing. That is the trap — a module that reads the
value and ignores the `unknown` list passes every other check in this file.

**`region_line` assembles honestly.** With `region_words` empty the line has no
leading separator and does not begin with a space or a `·`. With
`weeks_lost_known: false` in the block the weeks segment is gone and no double
separator is left behind. Assert the line never contains `· ·` and never ends
with a separator.

**`unusable_line` at zero returns `""`,** and at 1 and 3 gives singular and
plural.

**`lines()` always returns all four keys** — `diagnoses`, `weeks_lost`,
`since_last`, `unusable` — even for a completely empty summary where every
value is `""`. Assert `has()` on each key, not just the values.

**No verdict ever reaches a player.** Run a sample of summaries through every
function — a clean one, a light one, a heavy one with several repeat sites, one
where everything is unknown — and assert that no returned string anywhere
contains any of `PRONE`, `FRAGILE`, `DURABLE`, `RISK`, `CLEAN`, `HEALTHY`,
`GLASS`, `WORRYING`, `GOOD`, `BAD`. Check every string the module can produce,
including the four values inside `lines()`.

**No raw id leaks.** A region id like `left_arm` must never appear in output —
the region's words are passed in, so assert that a call passing `LEFT ARM` as
`region_words` returns a line containing no underscore.

## House pattern, exactly

```gdscript
extends SceneTree
## Q5T: LedgerWords, pure. Numbers in, English out. No career, save or
## GameState. What this file really guards: a count is a fact, a verdict is not.

var failures := 0


func _initialize() -> void:
	var Words = load("res://scripts/LedgerWords.gd")
	_test_singular_and_plural(Words)
	# ... your groups ...
	print("Q5T ledger words: %d failure(s)" % failures)
	quit(1 if failures > 0 else 0)


func _check(condition: bool, message: String) -> void:
	if condition:
		print("OK: ", message)
	else:
		print("FAIL: ", message)
		failures += 1
```

Group the checks into `_test_*(Words)` functions the way `_initialize` above
does — one flat function of sixty checks is a file nobody can read a failure
out of.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs.

- **`:=` fails on a Variant**, and every value returned by a `load()`ed script
  is a Variant — which is exactly how your test reaches the module. Write
  `var line: String = str(Words.diagnoses_line(summary))`, never
  `var line := Words.diagnoses_line(summary)`.
- **A name may be declared once per function**, even across separate `if` and
  `for` blocks. Your test will hold many cases; give each its own name
  (`line_one`, `line_many`) or the file will not parse.
- **`%` in a format string must be `%%`.**
- No `preload`, no autoload, no `class_name`. `extends SceneTree`.

## The one trap

**Do not write the test the module would pass.** You are not checking that
someone implemented six functions; you are checking the refusals. If a case
feels obvious and boring to assert — that `""` really is empty, that no digit
survives, that `unknown` is honoured even when the value is right there — that
is the case worth writing. The interesting-looking assertions are the ones that
would have passed anyway.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/tests/ledger_words_test.gd
Godot/scripts/LedgerWords.gd
```
