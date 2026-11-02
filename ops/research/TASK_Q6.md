# TASK Q6 — QWEN — THE WORDS FOR THE SEVEN ATTRIBUTES

Model: Qwen3.8-Max, effort **high**. One session. Runs after Q5. Its test is
TASK Q6T, a separate task — you are not asked for one.

**You have no repository and you do not need one.** This file is complete.
Build and test in a throwaway Godot 4.7 project holding only your two files.

## ONE FILE. THE MODULE. DO NOT SEND A TEST.

1. `StatWords.gd` — and nothing else.

The test is TASK Q6T, its own task with its own author, written from this
file's contract rather than from your code. So **the API below is a contract**:
exact names, exact argument order, exact strings. A test you never see will
call it.

## Why this exists

A fighter has six attributes today and is gaining a seventh, `grapple`. Every
screen that prints them — the profile, the scouting board, the comparison, the
development tab — currently spells its own labels, so a seventh attribute means
each of them inventing its own word for it, separately, and drifting.

You ship the one tested place an attribute id becomes a label, a short gloss,
and a band word for its value.

## The closed list

Seven ids, and nothing else is an attribute:

| id | label | what it means, in one line |
|---|---|---|
| `power` | `POWER` | `DAMAGE ONCE A STRIKE LANDS` |
| `technique` | `TECHNIQUE` | `THE QUALITY OF THE ACTION` |
| `speed` | `SPEED` | `WHO ACTS FIRST` |
| `defense` | `DEFENSE` | `AVOIDING WHAT LANDS, AND RESISTING A SUBMISSION` |
| `conditioning` | `CONDITIONING` | `HOLDING THE PACE` |
| `fight_iq` | `FIGHT IQ` | `CHOOSING THE RIGHT THING` |
| `grapple` | `GRAPPLE` | `WHO TAKES THE FIGHT TO THE CLINCH OR THE MAT` |

The glosses in that third column are the **exact** text `gloss()` returns,
character for character, backticks excluded. A test written from this same
table will compare them with `==`. They are settled by a research pass and are not yours to reword,
lengthen, or make more exciting. In particular `GRAPPLE` is *not* about being
good at wrestling — a separate per-discipline proficiency already answers that
— it is about where the fight goes.

## The API

```gdscript
extends RefCounted

const STAT_IDS: Array          # the seven, in the order above
const STAT_LABELS: Dictionary  # id -> label
const STAT_GLOSSES: Dictionary # id -> the one-line meaning, upper case

## An id outside the seven returns "" from all three - never the raw id,
## never a title-cased guess.
static func label(stat_id: String) -> String
static func gloss(stat_id: String) -> String

## A 0-100 value as a word. The four bands, and nothing between them:
##   0-39 POOR, 40-59 FAIR, 60-79 STRONG, 80-100 ELITE.
## A value outside 0-100 returns "".
static func band_word(value: int) -> String

## "POWER 82 · ELITE". A value below 0 or above 100, or an unknown id,
## returns "".
static func stat_line(stat_id: String, value: int) -> String

## The seven ids in display order, so a caller never hardcodes six.
static func ordered_ids() -> Array
```

## Refusals — each of these is a failed task

- **No eighth attribute.** Not `pressure`, not `chin`, not `durability`, not
  `footwork`, not `flexibility`, not `strength`, not `cardio`. Each was
  considered and rejected by the research; adding one here would put a word on
  a stat that does not exist.
- **No judgement of the fighter.** `POOR` describes a number, not a person.
  Never "weak link", "liability", "can't fight", "washed", "special", "star".
- **No age.** No parameter, no mention.
- **No advice.** Never "needs work", "train this", "focus here". A screen that
  wants to say that decides it itself.
- **No invented gloss.** Use the table's text exactly.
- **No number you were not handed.** No averaging, no overall rating, no
  totalling the seven — that already exists elsewhere and is not yours.
- **No sentence case.** Upper case, `·` as the separator.
- **No `preload`, no autoload, no `class_name`.**

## The test is NOT yours

`stat_words_test.gd` is TASK Q6T, a separate task with a separate author,
written from this same contract rather than from your code. That is deliberate
— a test written against the spec catches what the module SHOULD do; a test
written against the implementation only agrees with it. On Q5 this caught two
real bugs in the module within a minute of splicing.

What it means for you: **the API above is a contract, not a suggestion.** Exact
function names, exact argument order, exact strings, exact band boundaries,
exact ` · ` separator. A test you will never see is going to call it. Do not
rename anything, do not add a convenience argument, do not return a Dictionary
where a String is specified, and do not "improve" a gloss.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs.

- **`:=` fails on a Variant.** `var l := STAT_LABELS.get(id, "")` is a parse
  error; write `var l: String = ...`, and have a `-> String` function return
  `str(...)` where it reads a dictionary. This bites your test on the first
  line that reads a value back from a `load()`ed script.
- **A name may be declared once per function.** Your `_initialize()` will hold
  many cases — `line_power`, `line_grapple`, not `line` twice.
- **`%` in a format string must be `%%`.**

`extends RefCounted` on the module, `extends SceneTree` on the test.

## The one trap

**The band is the word for a number, not a verdict on a fighter.** `POOR
GRAPPLE` on a boxer is not a flaw — a boxer is *supposed* to have a low grapple
number, and the game says so deliberately: one stat set serves every
discipline, and grappling stats simply sit low and never fire in a boxing
bout. So the band words must stay strictly about the value: never a word that
implies the fighter is deficient for having it, and never any text that reads
differently depending on which discipline the fighter trains. This module does
not know what discipline anyone fights in, and must never appear to.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/StatWords.gd
```
