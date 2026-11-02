# TASK G22 — WHAT THIS FIGHTER HAS WON (Grok)

Model: mid tier, effort **medium**, Fast off. One session.

**Two files, and nothing else. Zero preloads.** Built and tested in a throwaway
Godot project holding only your own two files, exactly as G17 and G18 were
(`research/SANDBOX_MODULE_TESTING.md`). You have no checkout of this
repository and need none — everything the module must know is in this file.
Claude splices your module and runs the real suite after you push. You never
edit `HANDOFF.md`; Claude writes your block.

Deliver:

- `Godot/scripts/TitleHonours.gd`
- `Godot/tests/title_honours_test.gd`

## Why this exists

A stage called R70 shipped on 2026-09-08 and **retired** a set of world titles
this game should never have created — judo, wrestling, taekwondo, Brazilian
jiu-jitsu, sanda and sambo, where a world championship is an EVENT won on a
date rather than a belt somebody carries and defends. A retired title is **not
a deleted title**: a save where a fighter held the judo world title for forty
weeks is a save where that happened, so those rows were moved out of the live
standings and into a separate record, keeping their holder, their reign and
their defences.

The problem is that **nothing reads that record.** A fighter who really did
hold one of those titles now has an invisible career. Your module is what turns
the two tables — what a fighter holds now, and what was retired out from under
them — into one ordered list a screen can print.

## The contract

Exact names, exact argument order, exact strings. **An unseen test will call
this**, written from this same contract and not from your code, so a helpful
rename or a nicer label breaks it.

```gdscript
extends RefCounted
class_name TitleHonours
```

Pure and stateless: statics only, no node access, no RNG, no file access, **no
`preload` and no `load` of any other script**.

### `rows(athlete_id, championships, retired, current_week) -> Array`

```gdscript
static func rows(athlete_id: String, championships: Dictionary, retired: Dictionary, current_week: int) -> Array
```

`championships` and `retired` are both keyed the same way:
`"<discipline>|<weight_class>|<sex>"`, for example `"mma|Lightweight|male"` or
`"judo|Welterweight|female"`. Each value is a belt dictionary that may carry:

| field | type | meaning |
|---|---|---|
| `holder_id` | String | the athlete holding it; `""` when vacant |
| `holder_name` | String | stored name of that holder |
| `interim_holder_id` | String | present only while an interim stands in |
| `since_week` | int | the week the reign began |
| `defenses` | int | successful defences |
| `title_status` | String | `"champion"`, `"interim"`, `"vacant"`, or `"retired"` in the retired table |
| `organization_id` | String | the sanctioning promotion, `""` when none |
| `retired_reason` | String | retired table only, e.g. `"event_discipline"` |

Return an **Array of Dictionaries**, one per title this athlete has a claim on,
each carrying **exactly these keys**:

| key | type | value |
|---|---|---|
| `key` | String | the division key, unchanged |
| `discipline` | String | key part 0 |
| `weight_class` | String | key part 1 |
| `sex` | String | key part 2 |
| `standing` | String | `"held"`, `"interim"` or `"retired"` — see below |
| `label` | String | the printable division line — see below |
| `since_week` | int | from the belt, 0 when absent |
| `defenses` | int | from the belt, 0 when absent |
| `weeks_held` | int | see below |
| `weeks_held_source` | String | `"counted"` or `"absent"` — see below |
| `organization_id` | String | from the belt, `""` when absent |
| `retired_reason` | String | from the belt, `""` when not retired |

**`standing`** is decided in this order, and a division produces AT MOST ONE row:

1. `"held"` — the key is in `championships`, `holder_id` equals `athlete_id`,
   and `title_status` is **not** `"retired"`.
2. `"interim"` — the key is in `championships`, `title_status` is `"interim"`
   and `interim_holder_id` equals `athlete_id`. (A fighter can be the interim
   holder of a division somebody else is champion of.)
3. `"retired"` — the key is in `retired` and `holder_id` equals `athlete_id`.

If a key somehow appears in both tables with this athlete as holder, the
`championships` entry wins and only one row is produced.

**`label`** — build it yourself; you may not call another script for it.

- `sex_word` is `"Women's"` when `sex == "female"`, otherwise `"Men's"`.
- `discipline_words` is `discipline.replace("_", " ").capitalize()`, so
  `"muay_thai"` becomes `"Muay Thai"` and `"mma"` becomes `"Mma"`. **Yes,
  `"Mma"` — do not special-case it.** The game's existing division label does
  exactly this and the two must agree.
- `label` is `"%s %s — %s" % [sex_word, weight_class, discipline_words]`, using
  an em dash with one space either side.
- `label` is `""` when `discipline` or `weight_class` is empty, or when `sex` is
  neither `"male"` nor `"female"`.

**`weeks_held` and `weeks_held_source`** — this is the honest bit and the test
will check it:

- For `"held"` and `"interim"`: `weeks_held` is
  `maxi(0, current_week - since_week)` and `weeks_held_source` is `"counted"`.
- For `"retired"`: `weeks_held` is **0** and `weeks_held_source` is
  `"absent"`. **Never compute a length for a retired title.** R70 deliberately
  stamped no week on the retirement — a catalogue correction is not something
  that happened in the world on a date — so the game does not know when that
  reign ended, and subtracting `since_week` from today would silently invent a
  reign that ran until now.

**Sort**, total and deterministic — the same inputs must always give the same
order:

1. `standing`: every `"held"` row, then every `"interim"`, then every
   `"retired"`.
2. within a standing, `since_week` **descending** (most recent first);
3. ties broken by `key` **ascending**.

**Empties.** `athlete_id == ""` returns `[]`. No match returns `[]`. A missing
or empty `championships` or `retired` is fine and is not an error.

**Never mutate the inputs.** Copy anything you keep.

### `summary(rows) -> Dictionary`

```gdscript
static func summary(rows: Array) -> Dictionary
```

Takes what `rows()` returned. Returns **exactly these keys**:

| key | type | value |
|---|---|---|
| `held` | int | count of `standing == "held"` |
| `interim` | int | count of `standing == "interim"` |
| `retired` | int | count of `standing == "retired"` |
| `chip` | String | the one short line a screen prints, below |

`chip` is decided in this order:

1. all three counts zero → `""`
2. `held == 1` → `"CHAMPION"`
3. `held > 1` → `"CHAMPION ×%d" % held` (a multiplication sign `×`, not the
   letter x)
4. `held == 0` and `interim >= 1` → `"INTERIM CHAMPION"`
5. otherwise (`held == 0`, `interim == 0`, `retired >= 1`) →
   `"RETIRED TITLE"` when `retired == 1`, else `"RETIRED TITLE ×%d" % retired`

## The trap

**"Retired" does not mean "lost", and it does not mean "former champion who was
beaten".** These titles were taken off the board by a rules correction, not by
anybody's defeat, and the fighter never stopped being the last person to hold
one. So:

- never write a word like BEATEN, LOST, STRIPPED or VACATED into any string
  this module produces;
- never present a retired row as something that is still defendable, still
  running, or still counted among what the fighter holds — `summary()` counts it
  in `retired` and never in `held`;
- and never compute `weeks_held` for it, for the reason in the contract above.

The second trap is smaller and it is about the word BELT. In this game a *belt*
is a championship somebody carries. A Brazilian jiu-jitsu blue belt is a
different thing entirely — a rank awarded by an instructor, never won off an
opponent — and it is **not** what this module handles. Nothing here is about
belt colours. If a string you write could be read either way, rewrite it.

## Your test

`Godot/tests/title_honours_test.gd`, in the shape your earlier tests took:
`extends SceneTree`, `_initialize()`, a `_check(condition, label)` counter, a
printed summary line, and `quit(0 if failures == 0 else 1)`. Build the two
dictionaries by hand — you need no world and no game.

Cover at least: a held title; two held titles giving `"CHAMPION ×2"`; an interim
where somebody else is champion; a retired row with its `weeks_held` at 0 and
`weeks_held_source` at `"absent"`; the full sort order across all three
standings; a label for a female division and one for `muay_thai`; an empty
`athlete_id`; and that the input dictionaries are unchanged after the call.
