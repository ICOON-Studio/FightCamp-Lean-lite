# TASK G13 — GROK — WHERE THE BODY WAS HIT: THE REGION LEDGER

**Status: COMPLETE (2026-09-07, `cf6a2b5`).** Consumed by R55's `get_body_read()`.

**Was: OPEN (assigned 2026-09-07).** A pure module and its test. Blocks
nothing; R55 leaves a named seam for it and turns it on when it lands, exactly
as R54 did for your G12.

Model: mid tier, effort medium, Fast off. One session.

## Why this exists

G12 gave the project the career's total mileage — rounds, bouts, hard bouts.
It answers *how much*. It cannot answer *where*, and the per-body-region
recovery stage (operator decision, 2026-09-07, standing) needs *where*.

The save already knows. Every settled bout writes a `body_damage` block into
the fight log holding `before`, `after` and `hotspots` — the named regions that
took the extra damage in that bout. **Nothing in this codebase reads
`hotspots`.** Six regions have been quietly accumulating a history for months
and no module can say that the left leg has been the hotspot in four of the
last six fights.

## What you build

**`Godot/scripts/RegionHistory.gd`** and **`Godot/tests/region_history_test.gd`**.

Pure and stateless, statics only: **no node, no autoload, no RNG, and ZERO
preloads.** With zero preloads it is testable in a throwaway Godot project
holding only your two files — see `research/SANDBOX_MODULE_TESTING.md`.
Claude runs the real suite after you push. Read `Godot/scripts/Mileage.gd` (79
lines) and `Godot/tests/mileage_test.gd` (119 lines) first: this is the same
module in the same voice, and matching it is most of the task.

### The API

```gdscript
## Rows in, per-region counts out. Same row shape G12 takes: the fight-log
## rows, newest first or oldest first, it must not care.
static func summarize(rows: Array) -> Dictionary
## One region's ledger out of that summary.
static func for_region(summary: Dictionary, region: String) -> Dictionary
```

`summarize` returns at least:

```
{
  "regions": {                     # one entry per region actually seen
    "<region_id>": {
      "hotspot_bouts": int,        # bouts where this region was a hotspot
      "damage_taken": int,         # total readiness lost, before - after
      "worst_single_bout": int,    # the largest single-bout loss
      "last_hit_week": int,        # 0 when never, never a guess
      "bouts_seen": int,           # bouts whose block carried this region
    }, ...
  },
  "bouts": int,                    # rows that carried a usable body block
  "unknown_bouts": int,            # rows with no usable body block
  "worst_region": String,          # most hotspot bouts; "" on a tie or none
}
```

### The region id list is NOT yours to author

`BodyReadiness.DEFAULT_REGIONS` is the source of truth and you may not preload
it, so **do not hardcode a copy either.** Report the regions the ROWS actually
name, in the order they are first seen. A row naming a region you have never
heard of is counted like any other; a region absent from every row is absent
from the answer, not present with zeros. That way the six regions can become
seven without touching this file.

### The refusal, and it is the whole point

**It counts. It never grades.** Inherit G12's discipline exactly:

- No wear score, no damage rating, no "condition" percentage, no band, no
  colour, no `worst`/`fine`/`critical` word, no age, no athlete dictionary.
- **No healing anything.** No weeks-to-heal, no projection forward, no rate.
  J12 D1 grades weeks-to-heal-by-age UNKNOWN and the per-region healing model
  is a future stage with its own research pass — this file must not pre-empt
  it with a number.
- **A missing figure is reported as missing.** A row with no `body_damage`, or
  one whose `before`/`after` you cannot read as numbers, increments
  `unknown_bouts`. It is never assumed to be zero damage, and it never
  silently disappears.
- `worst_region` is a COUNT comparison, not a judgement, and a tie returns
  `""` rather than picking one.

## The row shape you are given

A fight-log row is a Dictionary. The parts that matter to you:

```
{"week": 41, "result": "L", "method": "TKO",
 "body_damage": {"before": {"head_neck": 90, ...}, "after": {"head_neck": 62, ...},
                 "hotspots": ["head_neck", "left_leg"]}}
```

`before` and `after` are region -> int (0..100). `hotspots` is an Array of
region id Strings and may be empty. `damage_taken` for a region is
`before - after` summed across bouts, floored at 0 per bout — a region that
somehow reads higher after than before contributes 0, not a negative.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/RegionHistory.gd Godot/tests/region_history_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/region_history_test.gd
```

Cover at least: an empty array; rows with no body block (they land in
`unknown_bouts`); one bout's damage attributed to the right regions; hotspot
counting across several bouts; `worst_single_bout`; `last_hit_week` on
unordered rows; a tie returning `""`; and a row naming an unknown region id
being counted rather than dropped.

## Done

Commit and push `master` with your two files only. **Do not edit
`HANDOFF.md`** — Claude writes your block. Do not touch `BodyReadiness.gd`,
`GameState.gd` or `Mileage.gd`.

## The one trap

`before` and `after` are untyped Dictionary values, so `var d := before.get(r)`
infers Variant and is a parse error. Write the type: `var d: int = ...`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/RegionHistory.gd
Godot/tests/region_history_test.gd
```
