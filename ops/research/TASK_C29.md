# TASK C29 — THE BLOCKED BELT READ (Codex)

**Status: ASSIGNED 2026-09-07.** Depends on R42 (`a534dad`), C26
(`ChampionshipRead.gd`), C28 (`aa36e27`) and Maria's M9 (`e3f5f02`). The
eleventh read in the C4 / C7 / C19–C28 pattern.

Model: Sonnet, effort medium, Fast off. One session.

## Why this exists

R42 shipped a rule with no surface: a contestant who misses the contracted
limit **cannot win or retain the belt**, so a champion can miss, win, and lose
the division anyway. The settlement records it as
`title_blocked_by_weight` ∈ `{"", "winner_missed", "both_missed"}`
(`GameState.gd:10610`, world path `WorldPopulation.gd:887` and `:1469`), and
C28 already passes the field through per bout.

Maria's **M9** (landed `e3f5f02`, spec
`research/M9_THE_SCALE_ON_THE_BELT.md`, boards
`DesignLibrary/screens/belt_scale/m9_*`) drew what the player is supposed to
see: four marks on one schedule row — TITLE BOUT, PENDING, **BELT NOT ON THE
LINE** — plus **VACANT ON THE SCALE** on the division row, and a drill-in that
says *why* in one line rather than a paragraph.

**Nothing feeds those marks.** `ChampionshipRead.bout_stakes()` (`:78`) knows
a bout's stakes at booking time and nothing about the scale. This read is the
seam between R42's rule and M9's art.

## What to build

Extend **`ChampionshipRead.gd`** (yours, from C26) plus one thin wrapper on
GameState.

- **`ChampionshipRead.belt_scale_read(...)` / `get_belt_scale_read(...)`** —
  per completed bout: `is_title_bout` as stamped at booking, whether the bout
  was resolved, `title_blocked_by_weight` verbatim, and a **mark** field the
  UI can switch on directly, one of
  `title_bout` / `pending` / `belt_not_on_the_line` / `none`.
  M9's rule, not yours to reinterpret: `stamped == false` reads **pending**,
  never "no".
- **The why line** — for a blocked bout, who missed (`winner_missed` vs
  `both_missed`), the division it happened in, and the week. One line of
  facts, no prose, no invented tribunal or stripping language.
- **Division vacancy** — extend the existing championship read so a vacant
  belt reports **why**, using the same `source ∈ {evidenced, invented,
  absent}` discipline C27 and C28 already use.

## The honest finding you must NOT paper over

Both vacancy paths write **the same fields**: `_vacate_on_the_scale`
(`WorldPopulation.gd:1107`) sets `vacated_by` / `vacated_week` /
`title_status = vacant`, and R7's move-up `vacate_title` (`:1233`, tail at
`:1267`) sets **exactly those same three**. There is **no reason field in the
save**, so a vacancy read cannot today tell "champion missed the limit" from
"champion moved up".

Do **not** infer one — not from `vacated_week` proximity to a blocked bout,
not from the fight log, not from anything. Return `vacancy_reason` as
**`absent`** and say so in the digest. The one-field write that fixes it lives
in `_vacate_on_the_scale`, which is **Claude's R42 region — do not touch it.**
Naming the gap precisely is the deliverable; M9's VACANT ON THE SCALE mark
cannot be drawn until it is closed, and that is a follow-up task, not yours.

## Out of scope

- No `.tscn`, no UI, no drawing M9's marks. This is a read.
- No new belt rail, dual-champion state, weigh-in surface, stripping ceremony
  or commission hearing — R42 shipped a state change, not a press cycle.
- No writes anywhere. No edits to `WorldPopulation.gd`, to the settlement
  region of `GameState.gd`, or to `WeightCut.gd`.
- No change to `assets/data/championship_rules.json` or `weight_classes.json`.
- Repeated reads must leave Career byte-identical (the C27 lesson: a read
  that mutates shared state is a bug, even when the numbers look right).

## Files

- `Godot/scripts/ChampionshipRead.gd` — yours from C26, extend it.
- `Godot/scripts/GameState.gd` — **the read-API region only**, one wrapper
  beside `get_championship_read()` (`:9586`). Nothing else in this file.
  Claude is in the settlement / projection region for R44 at the same time;
  do not cross into it.
- `Godot/tests/belt_scale_read_test.gd` (new).

## Parse gate (before any test run)

```
python Godot/tools/check_scripts.py Godot/scripts/ChampionshipRead.gd Godot/scripts/GameState.gd Godot/tests/belt_scale_read_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/belt_scale_read_test.gd
```

Then `belt_scale_test.gd` (R42's own) and `championship_read_test.gd`, and the
full suite once before the commit.

## Done

Digest `research/C29_DIGEST.md`, your own HANDOFF block (append only —
never rewrite another agent's), push `master`, and message Claude. If the push
is blocked by another agent's unstaged work, stage your own paths explicitly
and say so in the message, as you did on C28.
