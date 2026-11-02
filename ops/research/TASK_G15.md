# TASK G15 — GROK — THE REIGN: WHAT A BELT SAYS ABOUT ITSELF

Model: mid tier, effort **medium**, Fast off. One session.

A pure module and its test. **Zero preloads**, statics only, no node access, no
RNG, no file access. You have no repository checkout and you do not need one:
build and test this in a throwaway Godot project holding only your two files,
as G9 and G14 did. Claude splices it, runs the real suite and writes your
`HANDOFF.md` block.

Deliver exactly two files and nothing else:

- `Godot/scripts/BeltLineage.gd`
- `Godot/tests/belt_lineage_test.gd`

## Why this exists

The game's championship read hands a screen one row per belt. Every row carries
the raw week numbers and nothing derived from them, so every screen that wants
to say "champion for 40 weeks, three defences, has not defended in 18" would
have to do that arithmetic itself. One module beats one copy per screen.

Cursor's U5 is your first caller: the CHAMPIONS board.

## Your input — this is the exact shape, do not assume more

You receive rows produced by `ChampionshipRead.build_many()`. Every row has
every one of these keys, always:

```gdscript
{
    "key": "mma|Lightweight|male",      # discipline|weight_class|sex
    "discipline": "mma",
    "weight_class": "Lightweight",
    "sex": "male",
    "division_label": "MMA · LIGHTWEIGHT · MEN",
    "title_status": "",                  # "" | "held" | "interim" | "vacant"
    "holder": {},                        # {} when nobody holds it
    "interim_holder": {},                # {} unless title_status == "interim"
    "is_interim": false,
    "champion_unavailable_weeks": 0,
    "since_week": 0,                     # career week the belt was won; 0 = not recorded
    "last_defended_week": 0,             # 0 = never defended, or not recorded
    "defenses": 0,
    "vacated_by": "",
    "vacated_week": 0,
    "vacancy_reason": {"value": "", "source": "absent"},
    "unified_week": 0,
    "contenders": [],
}
```

A `holder` dictionary, when it is not empty, carries at least `id` and `name`.
Treat every other key inside it as optional and never require it.

**There is no title history anywhere in this game.** No array of past reigns,
no record of who took a belt from whom, no list of former champions. Do not ask
for one and never imply one exists.

## The contract

```gdscript
class_name BeltLineage
extends RefCounted

static func reign(row: Dictionary, current_week: int) -> Dictionary
static func board(rows: Array, current_week: int) -> Dictionary
```

`reign(row, current_week)` returns, with every key always present:

- `state`: `"held"`, `"interim"`, `"vacant"` or `"unknown"`.
- `holder_id`, `holder_name`: strings, `""` when there is no holder.
- `weeks_held`: int, `current_week - since_week`, floored at 0. **0 when
  `since_week` is 0** — and then `"since_week"` is in `unknown`.
- `defences`: int, straight from `defenses`.
- `weeks_since_defence`: int, from `last_defended_week`. When that is 0 the
  belt has never been defended OR the save did not record it — those are
  different sentences and you cannot tell them apart, so return 0 and put
  `"last_defended_week"` in `unknown`.
- `defence_cadence_weeks`: int — average weeks per defence, `weeks_held /
  defences`, 0 when either is 0.
- `unified`: bool, `unified_week > 0`.
- `unknown`: Array of the field names above that could not be derived. Never
  omit it; an empty array is the answer when everything was knowable.

`board(rows, current_week)` returns a summary over the rows given:

- `longest_reign`: `{"key": String, "weeks": int}` — the largest `weeks_held`
  among rows whose `since_week` is recorded. `{"key": "", "weeks": 0}` when
  none qualify.
- `most_defences`: same shape with `"defences"` instead of `"weeks"`.
- `newest_champion`: same shape with `"weeks"` — the SMALLEST recorded
  `weeks_held`.
- `held`, `interim`, `vacant`, `unknown_state`: int counts over the rows.
- `unknown`: Array of superlative names that could not be answered at all.

Ties break by `key` ascending, so the answer is deterministic. An empty `rows`
array returns the zeroed shape, never an error.

## Refusals

- No preloads, no `class_name` references to other project files, no
  `res://` paths, no `load()`. The module must run in a project containing only
  itself.
- Never invent a lineage: who won it from whom, how many former champions, what
  ended a previous reign. The data does not exist.
- No judgement words anywhere in what you return — no "dominant", "weak",
  "long-reigning", "past their best". You return numbers and ids. The screen
  writes the sentence.
- No projection: never estimate the next defence or how long a reign will last.
- No labels, no colours, no formatting, no money. This module has no
  presentation.

## GDScript, as this project's parser actually behaves

Godot **4.7**, tabs for indentation. These cost a fix cycle every stage here,
and the first one is close to certain on this task:

- **`:=` fails on a Variant.** Every row you receive is an untyped Dictionary,
  so `var week := row.get("since_week", 0)` is a **parse error** — `.get()`
  returns Variant. So does any static reached through a `load()`ed script,
  which is how your test will call your module. Write the type:
  `var week: int = int(row.get("since_week", 0))`,
  `var holder: Dictionary = row.get("holder", {})`.
- **A name may be declared once per function.** Reusing `var weeks` in two
  separate `if` or `for` blocks inside one function is a parse error, not a
  shadow. Your test will hold many cases in one `_initialize()` — give each its
  own name (`weeks_held`, `weeks_since_defence`) or the file will not parse.
- **`%` in a format string must be `%%`.** `"%d%% of the reign"`, never
  `"%d% of the reign"`.

A parse error does not fail loudly in this project: it **hangs** the headless
test until the timeout instead of erroring, so it reads as a stuck run rather
than a broken file. Getting these right is what makes the splice free.

## Your test

`Godot/tests/belt_lineage_test.gd` — a plain `SceneTree` script that exits 0 on
success and prints a failure count on any failure, matching the style of your
`career_epilogue_test.gd` and `amateur_matchmaking_test.gd`.

Cover at minimum: a normal held belt with defences; a belt with
`since_week == 0` (unknown, not zero weeks); a belt never defended; an interim
belt; a vacant belt; an empty `rows` array; a tie broken by key; and a row whose
`holder` is `{}` while `title_status` says `held` — the save contradicting
itself is a real case and `unknown` is the honest answer.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/BeltLineage.gd
Godot/tests/belt_lineage_test.gd
```
