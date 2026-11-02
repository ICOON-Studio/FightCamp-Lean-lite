# TASK U8 — CURSOR — THE CAREER AS YEARS, NOT ONLY BOUTS

Model: top tier, effort **high**, Fast off. One session, one branch.

Written for Qwen, reassigned 2026-09-08: that account never authenticated and
the work is not worth stalling. **RUN THIS AFTER U5 and U6** - it touches
neither `RankingsHubPanel.gd` nor `ScheduleHubPanel.gd`, but it is the lower
priority of the three.

## Why this exists

`Godot/scripts/CareerArc.gd` is **G10**, a pure module: 161 lines, statics
only, no autoload, no preload, already tested by
`Godot/tests/career_arc_test.gd`. It lays a career out **year by year** so a
screen can draw it without doing the arithmetic itself.

**It has zero callers. Not one, anywhere in `Godot/scripts/`.** It was built,
tested and never spent — the same gap R50, R57 and R58 closed for other reads.

`CareerArc.build(rows, birth_age, debut_week, career_week, window)` returns:

- `years[]` — one row per calendar year: `year`, `age`, `fights`, `wins`,
  `losses`, `draws`, `in_window` (was that year inside the peak window).
- `first_year`, `last_year`, `years_active`
- `busiest_year`, `best_year` (each a `years[]` row, or `{}`)
- `longest_gap_weeks`, `gap_after_year` — the longest idle stretch and the
  year it followed.
- `window` — the peak ages echoed back, `{}` when none was passed.

The profile's FIGHT RECORD tab already draws a CAREER ARC frame
(`ProfileRevampPanel._build_record:1273`), but it is a **per-bout** timeline:
`UIKit.timeline(_timeline_events(), ...)`. One dot per fight, belt and hold.
Nothing on that tab says how many fights a year the fighter took, which year
was their best, or how long they once sat idle. A career is read in years and
this screen only speaks in bouts.

## Owned files

Nobody else touches these this cycle.

- `Godot/scripts/GameState.gd` — **12,938 lines, NEVER open it whole.** Read
  only `sed -n '12300,12340p'` and `sed -n '12410,12430p'`. Anchors:
  `get_fighter_card:12269`, its `log` at `:12307`, the R53 aging composition at
  `:12317-12326`, the returned card dictionary at `:12415-12426`.
- `Godot/scripts/ProfileRevampPanel.gd` — **2,781 lines, NEVER open it whole.**
  Anchors: the card unpack at `:190-198`, `_build_record:1273`, the arc frame
  it builds at `:1277-1290`, `_timeline_events:1302`.
- `Godot/tests/profile_revamp_test.gd` — the FIGHT RECORD section is around
  `:160-210`.

Read whole (small, and you need their exact shapes):
`Godot/scripts/CareerArc.gd` (161) and `Godot/tests/career_arc_test.gd`.

## The work

**1. Compose the arc onto the card.** R23's invariant: the profile is
**card-only** — it reads `get_fighter_card()` and never calls a second
GameState read beside it. R53 set the precedent for exactly this at
`:12317-12326`, where the aging read is composed into the card rather than
fetched again by the screen. Do the same for the arc, in the same place, where
`log`, `card_week` and `aging_read` are already in hand:

- `rows` is `log`.
- `career_week` is `card_week`.
- `window` is `{"from": aging_read.peak_from, "to": aging_read.peak_to}` —
  pass `{}` when the aging read is not `ok`, never a guessed window.
- `debut_week` is the OLDEST row's week. `log` is newest-first, so that is the
  last row. No fights means no arc: put `{}` on the card and stop.
- `birth_age` is the age at debut, and the module's own docstring says it is
  **passed in, never derived** by the module — so derive it here, once:
  `age - (card_week - debut_week) / 52`, floored at 0.

Add it to the returned card as `career_arc`. One new key, nothing else moves.

**2. Draw the year spine.** In `_build_record`, under the existing timeline in
the CAREER ARC frame, add one row of year cells off `_data["career_arc"]` —
year, fight count, and the year's W-L-D. Mark the years where `in_window` is
true; that is the fighter's peak window, and R53 already established the
vocabulary for it. Then one summary line: the busiest year, the best year, and
the longest idle gap **only when `longest_gap_weeks` is a real number**.

A fighter with no fights keeps the frame exactly as it is today and adds
nothing. A career with one year draws one cell, not a stretched bar.

**3. The amateur line stays.** `AmateurRecord` at `:1281-1290` sits under the
timeline already. Your strip goes below it, not over it. If the frame runs out
of height, the year strip is what shrinks — the timeline is the older, more
important reading.

## Refusals

- **No new UIKit factory, no new token.** Build the cells from what the kit
  already has (`UIKit.caps`, `UIKit.display`, `UIKit.block`, `UIKit.chip`).
- **No second GameState call from the panel.** If you find yourself wanting
  `get_aging_read()` or `get_fight_log()` in `ProfileRevampPanel.gd`, you have
  broken R23 — the number belongs on the card instead.
- **No arithmetic in the panel.** Every count, every best-year and every gap
  comes from `CareerArc`. The panel positions and prints; it does not add up.
- **Do not edit `CareerArc.gd`.** It is Grok's module and it is already tested.
  If it genuinely cannot answer something, say so in your report and stop.
- **K24:** no screen prints a verdict on a fighter's age. A year inside the
  peak window may be marked; a year outside it is simply unmarked. Never
  "declining", never "past peak", never a grade.

## Gate

Parse gate BEFORE any test — a parse error HANGS a headless test until the
timeout instead of failing it:

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ProfileRevampPanel.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/profile_revamp_test.gd
```

plus `tests/career_arc_test.gd` and `tests/smoke_test.gd`, then the full suite
once in the background before the commit. Every file in `Godot/tests/` must
exit 0; `smoke_test.gd` is the real gate.

## The one trap

`get_fighter_card()` runs against a **disposable copy** of the career: it does
`career = live_career.duplicate(true)` on entry and restores `career =
live_career` before returning. Compose the arc INSIDE that window, above the
`return card.duplicate(true)` at `:12426`. Anything you compute after the
restore is reading a different object, and the bug will not show up in the
focused test — it shows up as a stale arc three screens later.
