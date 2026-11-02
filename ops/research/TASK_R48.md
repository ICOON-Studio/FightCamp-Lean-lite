# TASK R48 — THE HOLD: A BODY THAT CANNOT BE BOOKED (Claude)

**Status: COMPLETE 2026-09-07.** Builds Maria **M6** (`M6_THE_HOLD.md`, drawn
2026-09-06) — the last unbuilt art pack. Spends the clearance block that
`get_fighter_card()` already returns. Screen work only.

Model: Opus, effort high, Fast off. One session.

## Why this exists

`BodyReadiness` runs **two clearances that disagree on purpose** — training is
all-or-nothing at 80, competition is per region (`head_neck` 90, `torso_core`
85, limbs 80) plus a fatigue ceiling and a hold that region recovery cannot
waive. It emits **five typed refusals**, each with its own numbers.

BODY LAB prints almost none of it:

1. **The hold is collapsed into `injured`** (`ProfileRevampPanel.gd:1394`,
   `:614`, `:379`) — `on_hold = hold_week > week or status == "injured"`. A
   fighter with no hold reads as HELD, and a real hold reads the same as a
   sprain. M6 calls the badge family the thing that separates them.
2. **The region chips use thresholds the engine does not have** (`:1389`) —
   HURT < 30, SORE < 60, else SOUND. The engine bands at **80 / 60**. A region
   at 62 is chipped SOUND and is blocking training.
3. **The competition thresholds are never drawn.** M6's design case —
   `head_neck` 84, green to train, under the cage's 90 — is invisible.
4. **The refusal rows print zeros** (`:1417`) — one format string with
   `region`, `value`, `required` is applied to every reason, so
   `medical_hold_active`, `fatigue_above_competition_limit` and
   `athlete_injured` render as `·  0, NEEDS 0`.
5. **The countdown is AMBER** (`:1466`). M6: hold chrome is **BAD** until the
   last week, and the lift is cool, not amber.
6. **A blank `medical_hold_reason` prints an empty tail** (`:1399`).

## What to build — `Godot/scripts/ProfileRevampPanel.gd`

**The badge family (primary deliverable).** One pill, three severities, drawn
from tokens: **HELD** solid `BAD`, **NOT CLEARED** outline `AMBER`, **CLEARED**
outline `GOOD`. It is the fighter's booking answer and it appears twice — in
the hero beside the FIT / INJURED status chip, and at the head of BODY LAB.
`INJURED` stays its **own quiet chip** and is never collapsed into HELD.

**The regions.** Band by `BodyReadiness.readiness_band()` — green ≥ 80, amber
≥ 60, red below — and put the region's **competition threshold as a tick on
the bar**, so 84 under a 90 tick reads at a glance.

**The refusal stack, in M6's order:** hold → competition regions → fatigue →
training regions → injured. Each row prints its **own** numbers: the hold its
`until_week` / `weeks_remaining`, fatigue its `value` / `required_max`,
injured no numbers at all.

**The countdown.** `BAD` while it counts, `LINK` in the last week and at zero.
No AMBER, no gold, and **`GO` is never borrowed for cleared** — `GO` is
CONTINUE (M5).

**Honest empties.** Blank `medical_hold_reason` → a `DIM` em-dash, never an
invented diagnosis. Full green with no bouts → CLEARED plus a `DIM` line, never
BAD for absence.

## What to build — `Godot/scripts/BodyReadiness.gd`

Three pure static accessors, additive, no behaviour change, so the panel neither
re-parses the rules JSON nor hardcodes 90 / 85 / 80:

- `competition_threshold(region: String) -> int`
- `training_threshold() -> int`
- `competition_fatigue_max() -> int`

## Token ruling, settled here

M6 names a **CONDITION** token (`#3DB8D4`) that does not exist. M6 itself
offers `LINK` as its alternative and **`LINK` is what this task uses**;
`UITokens.gd` is **not edited** — R47's precedent (two constants, then refuse).
`GOOD` / `AMBER` / `BAD` stay the medical family and are never mapped onto
CHAMPION / INTERIM / VACANT (R47).

## Out of scope

- **The roster glance (board `m6_04`)** is a different surface
  (`ManagementOverview`), not this panel. Left out deliberately.
- No `GameState.gd`, no `UIKit.gd`, no `.tscn`, no `assets/data/` edit.
- No competition forecast (`forecast_weeks_to_training()` only — M6).
- No diagnoses, injury names, anatomy chart, doctor or clinic.
- No board PNG imported as a runtime bitmap; everything is code-drawn.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/scripts/BodyReadiness.gd Godot/tests/profile_revamp_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

Then `body_readiness_test.gd`, then the full suite ONCE before the commit.

## Done

Commit and push `master`, write `research/R48_DIGEST.md` (short), write
the Claude **and** Maria blocks in `HANDOFF.md`, mark M6 and R48 complete, and
regenerate `TASKS.md`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/ProfileRevampPanel.gd
Godot/scripts/BodyReadiness.gd
Godot/tests/profile_revamp_test.gd
research/R48_DIGEST.md
```
