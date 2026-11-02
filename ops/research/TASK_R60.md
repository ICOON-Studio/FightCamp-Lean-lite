# TASK R60 — CLAUDE — THE BODY HEALS AT SIX SPEEDS

Model: Opus, effort **high**, Fast off. One session, one stage.

**Consumes R59** (landed 2026-09-08, `99518cf`). `body_state` is version 2 and
a region can already carry a named injury that owns its own dates. This stage
makes the region's NUMBER obey that injury.

**Ordering: nothing blocks this.** U9 (Cursor) reads `get_body_read()` and only
adds keys to a panel; G17 (Grok) is a pure module. Neither touches
`BodyReadiness.gd` or the `GameState.gd` ranges below.

## Why this exists

The operator ruled on 2026-09-07 that realistic per-region recovery gets its
own stage. That stage is this one — but **it is not six invented heal rates**,
and reading the research before writing a line is not optional here:

- **J12 D1** — `research/J12_RECOVERY_AND_THE_YEARS.md`: *"Do not invent
  a per-region heal rate and call it sourced."* The literature does not carry
  one. Anything you author is `AUTHORED`, and most of it should not exist.
- **J12 D2** — training-load recovery and injury healing are **two objects**.
  `_apply_recovery`'s camp-heal is not weeks-to-return after a tear, and one
  slope must never be applied to both.
- **J12 D4 / D9, J13** — age does not scale healing. Closed, not reopened here.

So the six speeds do not come from a table. **They come from the injuries the
six regions are already carrying**, which R59 stores and which each carry
graded dates. A region with a torn ligament and a region with a bruise now heal
differently because their injuries say different things — no new number is
invented, and the difference is exactly as sourced as Q2's ladders are.

## The bug this actually fixes

`BodyReadiness._apply_recovery` (`:418`) adds the same amount to **every**
region, and knows nothing about injuries. Today:

1. A fighter with a grade-3 fracture rests four weeks, every region climbs to
   100, `evaluate_training_clearance()` says clear, and the BODY LAB shows six
   green bars — while `medical_hold_until_week` still blocks the booking with
   no visible reason anywhere on the body.
2. `forecast_weeks_to_training` (`:387`) projects a return that ignores the
   injury entirely, so the gym's own estimate contradicts the medical hold.
3. `GameState.gd:5158` flips `status` from `injured` back to `available` the
   moment fatigue ≤ 30 and minimum readiness ≥ 80 — **while a named injury is
   still live on a region.**

Three places where the save says "healthy" and "held" at the same time.

## Owned files

- `Godot/scripts/BodyReadiness.gd` — 655 lines, read whole. Anchors:
  `apply_activity:221`, `forecast_weeks_to_training:387`,
  `_apply_recovery:418`, and R59's API at `get_injuries:453`, `get_injury:459`,
  `store_injury:494`, `resolve_due_injuries:599`.
- `Godot/scripts/GameState.gd` — **13,800+ lines, NEVER open it whole.** Read
  only `sed -n '5140,5175p'` (the status auto-clear) and `sed -n '7660,7725p'`
  (`_body_read`, to add the ceiling to the row). Do not touch anything else.
- `Godot/assets/data/body_readiness_rules.json` — the `recovery` block
  (`rest_base` 10, `recovery_base` 17, `targeted_region_bonus` 7). Any constant
  you add goes HERE, not in code.
- `Godot/tests/body_readiness_test.gd`, `Godot/tests/body_read_test.gd`,
  `Godot/tests/body_readiness_integration_test.gd`.

## The work

**1. A live injury puts a CEILING on its region.** Not a rate — a ceiling, so
no heal-speed number is invented:

- before the injury's `train_week`: the region cannot climb past the amber
  threshold (`amber_threshold()`, 60) — visibly hurt, and the training gate
  refuses it on its own existing rule;
- from `train_week` to `compete_week`: it cannot pass that region's
  `competition_threshold()` — it can train, it cannot be cleared to fight;
- from `compete_week`: no ceiling, and R59's `resolve_due_injuries` removes
  the injury on the weekly pass anyway.

A region with no injury is **untouched** — the existing recovery is the
existing recovery, and every current test of it must still pass byte-for-byte.
A type that sets no hold (`contusion`, `muscle_strain`) still gets its ceiling
while it is live: it is a real diagnosis, it is just not a booking gate.

**2. One helper, one place.** Put the ceiling in
`BodyReadiness.region_ceiling(athlete, region, current_week) -> int` returning
100 when nothing caps it, and apply it in `_apply_recovery` **after** the
existing amount is added, by clamping. `apply_activity`'s LOAD path is not
touched: training damage is not healing, and a ceiling must never push a
number UP.

`_apply_recovery` has no `current_week` today — it reads `context`. The week
is already in `context` at every caller (`_body_activity_context`). Take it
from there and treat a missing week as "no ceiling", never as week 0.

**3. The forecast stops lying.** `forecast_weeks_to_training` simulates weeks
forward; it must carry the ceiling through the simulation, and its
`week_context["current_week"]` already advances per week, so the ceiling lifts
on the right week for free. A body that cannot reach green until an injury
clears must return that week, not an earlier one.

**4. The status flag stops contradicting the body.** At `GameState.gd:5158`,
`status` may only return to `available` when no live injury remains on any
region. The fatigue and readiness conditions stay exactly as they are — this
adds one condition, it does not redesign the flag.

**5. The read says why.** `_body_read()`'s region rows already carry `injury`
(R59). Add `ceiling` and `ceiling_reason` — `""`, `"injury_pre_training"` or
`"injury_pre_competition"` — as **ids, not words**. `InjuryWords.gd` (Q3) owns
every string a player sees and this stage writes none.

**6. Tests.** A region under a live injury stops at the amber ceiling however
long it rests; the same region passes the ceiling once `train_week` arrives and
stops at the competition threshold; a region with no injury recovers exactly as
it does today (assert an existing value, so a regression is loud); the forecast
returns the injury's week rather than an earlier one; `status` stays `injured`
while an injury is live and clears the week after it resolves; `get_body_read`
carries `ceiling` and the reason id.

## Refusals

- **No per-region heal rate, no heal multiplier, no `recovery_scale()`.** J12
  D1. If you are writing a number per region, stop.
- **No age.** J12 D4/D9 and J13 are closed.
- **No second clock.** `medical_hold_until_week` stays the one medical clock;
  the ceiling is derived from the injury's stored dates every time it is asked
  and is never stored.
- **No words.** Ids only; Q3 owns the strings.
- **No new injury naming.** R59 owns that; this stage only reads what is there.
- **No screen work.** U9 owns `ProfileRevampPanel.gd`.
- **No change to the untouched-region path.** If a current recovery test's
  numbers move, you have broken the stage's core promise.

## Gate

```
python Godot/tools/check_scripts.py Godot/scripts/BodyReadiness.gd Godot/scripts/GameState.gd
```

Then, from `Godot/`:

```
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_readiness_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/body_readiness_integration_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path . --script tests/smoke_test.gd
```

then the full suite once in the background before the commit.

## The one trap

**A ceiling is not a floor.** `_apply_recovery` runs for every athlete every
week, and the obvious implementation — `regions[r] = mini(regions[r], ceiling)`
applied unconditionally — will *drag a region DOWN* the moment an injury is
named on an already-healthy region, wiping condition the fighter earned before
the bout. Clamp only the amount being ADDED this tick: a region already above
its ceiling stays where it is and simply stops climbing. The test for this is
a region at 95 that gets injured and must still read 95, not 60.
