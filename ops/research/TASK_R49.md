# TASK R49 — THE DECISION THAT SURVIVES THE RING, AND THE GRUDGE SHELF (Claude)

**Status: ASSIGNED 2026-09-07.** Consolidation. Closes the two gaps R45 left on
the record and the one part of K17 that is still unbuilt. Two small
`GameState.gd` regions, one read module, one panel.

Model: Opus, effort high, Fast off. One session.

## Checked first: two thirds of K17 is already done

K17's locked verdict was **DISSOLVE PHONE**, and PHONE is already gone —
`OfficeHubPanel.gd:18` and `SceneRouter.gd:94` both say so. K17 **D**
("who is unhappy and why", one place, no new screen) is also live: THE DAY
reads C16's `get_day_relationship_attention()` at `DayFeedPanel.gd:118-121` and
draws `UIKit.day_attention_strip` at `:221`. **Neither is re-opened here.**
What is left of K17 is section **C**: the rivalries shelf.

## Part 1 — a decision that reads the same outside the ring

`FightSimulation` types every decision: `decision_type` at `:2732` (unanimous /
majority / split and the three draws, from `JudgePanel.decision`) and
`scoring_style` at `:2781`. The freeze at **`GameState.gd:10280`** keeps
`method`, `scorecards`, `final_health`, `final_body_condition`, `ruleset_id`
and `duration_seconds` — and **drops both of them**. `decision_type` does not
appear anywhere in `GameState.gd`.

So a three-judge split, opened from anywhere but the live ring, types as a flat
**"DECISION"**. R45 found it and left it; C30's `BoutRead.gd:44` and `:58`
already read `decision_type` off the filed result and get an empty string.

1. **Freeze both** into `pending_fight_result` at `GameState.gd:10280` —
   `"decision_type"` and `"scoring_style"`, straight off `sim_result`, exactly
   as `ruleset_id` and `duration_seconds` are frozen beside them. No rolling,
   no estimating, no defaulting to a type the sim did not emit.
2. **`ScorecardRead.build` ignores its own panel.** It computes
   `JudgePanel.decision(normalized)` at `ScorecardRead.gd:14` — which returns a
   `decision_type` — then derives the type only from `result.decision_type`,
   falling back to the flat `"decision"` (`:9-11`). When the result carries
   none, **take the panel's**; keep the flat fallback for the one-card legacy
   shape that has no panel.
3. Carry it through settlement so a **re-read** (C30) types the same as the
   ring did.

**Out of scope:** no scoring change, no `FightSimulation.gd` edit, no
`JudgePanel.gd` edit, no backfill or migration of saves filed before this.
A bout filed without a type stays untyped — it is not guessed after the fact.

## Part 2 — K17 C: the RIVALRIES shelf

`Rivalries.gd` and `career["rivalries"]` have been live since R2 and **no
screen reads them**. K17 C puts the heat list on the fighter profile's
**FIGHT RECORD** tab as a shelf — *not* a new tab, *not* STAFF (coach work is
not a grudge), *not* the `get_rival_gyms` world list.

- The panel is card-only by R23's invariant, and `profile_revamp_test`'s
  `CardSpy` (`:428-443`) declares **only** the four methods it may call — so a
  direct `get_athlete_rivalries()` from the panel fails the test by design.
  Add **`"rivalries": get_athlete_rivalries(athlete_id)`** to the card in
  `get_fighter_card` (`GameState.gd:11421`, the return block near `:11550`,
  beside `titles` / `awards`), and the panel spends the card.
- `get_athlete_rivalries()` (`GameState.gd:6739`) already returns hottest-first
  with `rival_name`, `heat`, `band`, wins/losses/draws, `grudge_match`,
  `weeks_since_contact`, `source`.
- Bands from `rivalries.json`: COLD 0 · SIMMERING 1-29 · HEATED 30-59 ·
  BAD BLOOD 60-84 · BLOOD FEUD 85-100. Grudge minimum heat 30.
- Build it in `_build_record` (`ProfileRevampPanel.gd:900`), from tokens.
  **No new UIKit factory**, no new tab, no booking button — a grudge is booked
  through the existing offer flow (K17 C), and the shelf never implies a phone.
- **Honest empty:** no rivalry is a `DIM` line, never an alarm.

## Token rule

`BAD` / `AMBER` / `GOOD` stay M6's medical family (R48) and `SODIUM` / `ICE`
stay the belt's (R47). Rivalry heat is **not** a medical or a title state:
band it with the existing heat ramp and `LINK`, and add **no** token.

## Parse gate

```
python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/scripts/ScorecardRead.gd Godot/scripts/ProfileRevampPanel.gd
```

## Tests

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scorecard_read_test.gd
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/profile_revamp_test.gd
```

Then `bout_read_test.gd`, `post_fight_read_test.gd`, `setpiece_panels_test.gd`
and `rivalries_test.gd`, then the full suite ONCE before the commit.

## Done

Commit and push `master`, write `research/R49_DIGEST.md` (short), write
the Claude block in `HANDOFF.md`, and regenerate `TASKS.md`.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/GameState.gd
Godot/scripts/ScorecardRead.gd
Godot/scripts/ProfileRevampPanel.gd
Godot/tests/scorecard_read_test.gd
Godot/tests/profile_revamp_test.gd
research/R49_DIGEST.md
```
