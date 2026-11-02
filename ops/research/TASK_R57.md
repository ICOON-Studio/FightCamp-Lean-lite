# TASK R57 — CLAUDE — THE BODY GETS ITS SCREEN

**Status: IN PROGRESS (assigned 2026-09-07).** Spends R55's `get_body_read()`
on the surface U3 ruled. Depends on nothing that is not already on master.

Model: Opus, effort high, Fast off. One session.

## Why this exists

**Seven read APIs in `GameState.gd` have zero callers outside `Godot/tests/`**
— `get_body_read`, `get_aging_read`, `get_scorecards_read`, `get_bout_read`,
`get_belt_scale_read`, `get_championships_read`, `get_gym_ledger_week_read`.
This is the same debt the R45-R50 cycle existed to clear, grown back.
`HANDOFF.md` currently says `get_corner_rules_read()` is "the one left": that
is wrong twice — it is spent at `ScheduleHubPanel.gd:174`, and seven others are
not. **Correct that claim in this task.**

`get_body_read` is the one to spend first, because both halves of the work are
already on master and only the wiring is missing:

- **R55 landed the read** (`GameState.gd:7647`, commit `56522f0`). It returns
  six `regions` rows with `value`, `band`, `competition_threshold` and
  `clears`; G13's per-region history (`hotspot_bouts`, `damage_taken`,
  `worst_single_bout`, `last_hit_week`); `weakest` — the region furthest
  **under its own** cage threshold, which is not the lowest number; the hold;
  `history_known`, `history_unknown_bouts` and `history_worst_region`.
- **U3 landed the ruling** (`research/U3_THE_BODY_BY_REGION.md`, commit
  `f03c13f`) with five answered questions, a token map, twelve refusals and
  five engine boards in `DesignLibrary/screens/body_by_region/`.
- **The screen reads neither.** `_fill_regions()`
  (`ProfileRevampPanel.gd:1891`) goes straight to the raw
  `athlete.body_state.regions` dictionary. It draws six gauges, a cage tick and
  a SOUND/SORE/HURT chip, and it knows nothing about which region is binding,
  nothing about the career, and nothing about what the record cannot say.

## What ships

**1. The read is the source.** `_read()` gains `d["body"] = get_body_read(id)`.
This is the SECOND exception to R23's one-read invariant, after the
pound-for-pound board: `get_fighter_card` carries `clearance` — one verdict —
and has never carried the six regions. `_fill_regions` keeps its raw
`body_state` fallback so an older save or a missing method still draws.

**2. The binding region (U3 Q2).** The cell the read names in `weakest` is
emphasised when it is actually the competition blocker — the refusal tone on
its caption plus a `BINDING` mark. Never a per-region badge (U3 refusal 3), and
the hold banner still wins when a hold is live.

**3. NOW and EVER on the same cell (U3 Q4).** Under each gauge, M11's wear
grammar: a `TRACK` recess with a `LINE_SOFT` edge and up to five `DIM`
micro-ticks counting `hotspot_bouts`. Never scar-red (refusal 4), never HELD
(refusal 5). Drawn only when `history_known` — a save that cannot count reads
as silence, not as "never hurt".

**4. What the record cannot say.** `history_unknown_bouts` gets a line beside
the badge, because "nothing ever happened" and "the record does not go back
that far" are different sentences. `history_worst_region` rides with it — the
region hit most often across a career is a different question from the region
binding today.

**5. `LOWEST · NN` on the glance surface (U3 Q2, D).** The overview strip
carries the badge plus the floor number, labelled `LOWEST` and not
"readiness" — it is the floor, not the story.

## Refusals held (U3, all twelve)

No anatomy silhouette or body map. No six stacked identical rows. No
per-region clearance badges. No scar-red EVER overlay. Wear never becomes
HELD and injury never becomes wear. No `GO` for cleared. No age on hold copy
or region chrome. No region column on `squad_row` or the training board.
**No new token and no new UIKit factory.** No healing rate anywhere — the
per-region recovery clocks are UNKNOWN (J12 D1) and have their own future
stage.

## Owned files

- `Godot/scripts/ProfileRevampPanel.gd`
- `Godot/tests/body_region_screen_test.gd` (new)
- `HANDOFF.md` — the stale `get_corner_rules_read` claim only, plus my block
- `research/R57_DIGEST.md` (new)

Not `GameState.gd` (C39 is in it), not `ScheduleHubPanel.gd`, not
`BodyReadiness.gd`, not `UIKit.gd`, not `UITokens.gd`.

## Gate

```bash
python Godot/tools/check_scripts.py Godot/scripts/ProfileRevampPanel.gd Godot/tests/body_region_screen_test.gd
```

Then `body_region_screen_test.gd`, `body_read_test.gd`, the profile tests, and
the full suite once in the background before the commit.

## The one trap

**`_fill_regions()` declares `held` partway down its own body.** Reusing a
variable name inside one function is a parse error in GDScript even across
separate blocks, and a parse error HANGS a headless test until the timeout
instead of failing it. The binding-region emphasis needs `held` at the top of
the loop, so the existing declaration moves up rather than a second one
appearing.
