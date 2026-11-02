# TASK_U127 — CURSOR — THE STAT ROW, ONCE, IN UIKit

**Owner:** cursor
**Model:** `composer-2.5`, MEDIUM. `-p --force --trust --workspace <wt>`
**Test tier:** parse gate on every touched `.gd`, then `run_tests.py --only ui`
and SEPARATELY `--only screen`. **`--only` DOES NOT STACK** — one per invocation,
and read `total=` to confirm how many ran. **No full suite.**

## Why this is the first UI job and not a judgement call

Two independent sources agreed on it without seeing each other. **M22** (art
direction) says the stat row is **30 px tall, three columns, label | bar |
number**. **G63** (competitor teardown, 113 sources) says **28–32 px pitch, bar at
55–65% of the cell, tabular number right-aligned**. 30 px sits inside that band and
the column contract is identical.

G63's own words on why it must be one component: *"UIKit owns this as one
component. FM already solved it; Believr almost did (numbers, no bars); do not
invent a third pattern."*

And U126 counted the cost of not having it: **3,427 hard-coded layout literals**
across 26 live screens, with font sizes spanning 0–92 px and button heights
disagreeing across eleven distinct values.

## What to build

### 1. `UIKit.stat_row(...)` — one helper, one contract

```
static func stat_row(label: String, value: Variant, max_value: float = 100.0,
        opts: Dictionary = {}) -> Control
```

Non-negotiables, all from the two sources above:

- **Row height 30 px.** One constant, named, in `UIKit` or `UITokens`.
- **Three columns: label left, bar centre, number right.** The bar is **55% of the
  row's width**.
- **The number is TABULAR and right-aligned**, so digits line up down a column.
  G63: *"Tabular numbers always... Ratings are integers or one decimal, never
  `72.0`."*
- **Integers render as integers.** No trailing `.0`.
- `opts` may carry `bar_colour`, `show_bar` (a number-only variant — Believr's
  pattern), and `grade` (a letter ladder instead of a number). **Do not add
  options nobody asked for.**

### 2. `UITokens.gd` — M22's values, named

M22's colour table with its hex values, the type scale, and the spacing rhythm.
Read `research/M22_VISUAL_LANGUAGE.md` for the values; do not invent any.

**THE ONE CONFLICT YOU MUST NOT SILENTLY RESOLVE:** M22 says the spacing base is
**4 px**; G63, measuring competitor screenshots, says **8 px** with card padding
16 and section gap 16–24. **They are not reconcilable.** Take **8 px as the base
with 4 px available as a half-step** — that satisfies both (every G63 value is a
multiple of 8; every M22 value stays a multiple of 4) — and **write a comment
naming both sources and saying that is what you did.** Do not pick one and leave
the other unmentioned.

### 3. Apply it to ONE screen — `ProfileRevampPanel`

U126 ranks it worst: **918 hard-coded literals, font sizes 0–80 px.** Convert its
stat rows to the new helper and its colours/sizes to the tokens.

**ONLY ITS STAT ROWS AND TOKENS. Do not restructure the screen**, do not adopt
G63's master-detail split (that is its own later task), do not touch other
screens. A diff that touches twelve files is the wrong diff.

## Owned files

- `Godot/scripts/UIKit.gd` — ADD the helper. It is large; find the existing
  component helpers with `grep -n 'static func' ` and add beside them. **Do not
  reformat anything you did not write.**
- `Godot/scripts/UITokens.gd` — CREATE or EXTEND (U126 says it exists; check).
- `Godot/scripts/ProfileRevampPanel.gd` — EDIT, stat rows and tokens only.
- `Godot/tests/ui_stat_row_test.gd` — CREATE.
- `research/U127_DIGEST.md` — CREATE.

`GameState.gd` is ~13,000 lines and you need none of it. Do NOT edit `HANDOFF.md`.

## Gate

```
python Godot/tools/check_scripts.py <every .gd you touched>
python Godot/tools/run_tests.py --only ui
python Godot/tools/run_tests.py --only screen
python Godot/tools/u126_screen_census.py
```

Ceiling: `--only ui` and `--only screen` at **fails=0**, and **U126's literal
count for `ProfileRevampPanel` must FALL from 918.** Report the new number. That
census is the gate with teeth here — it measures the thing the task is for.

**The census is deterministic as of 2026-09-22**, so a diff in its output is a
real change. Run it twice and confirm the two runs agree before quoting a number.

## THE TRAP

**A wrapper that every screen bypasses is worse than no wrapper**, because it adds
a second pattern instead of replacing the first. So the gate is the LITERAL COUNT
falling, not the helper existing. If you add `stat_row` and the count does not
move, you have shipped a third pattern — which is exactly what G63 says not to do.

**Second trap:** a `Label` outside a Container does not autowrap reliably in
Godot. G63 says long names get **one line, ellipsis after ~18–22 characters,
never three lines** — so use ellipsis, not wrapping, and do not rely on
`autowrap_mode`.

## Deliver

Commit on a branch, push, write the digest, and send one line with
`python Tools/agent_comms.py send --from cursor --to claude --subject u127-ready`.
**Unstage `AgentComms/messages` before you commit** — another agent's mail may be
pre-staged in this shared index.
