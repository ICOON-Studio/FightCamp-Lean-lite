# TASK_C193 - a BLIND contract test for the body map (Codex, test only)

Model: gpt-5.6-luna, medium (UI/contract test, not motion). Owner: codex. Assigned S68, 2026-09-24.

## Why
S68 shipped THE BODY MAP (operator request): the profile's BODY LAB tab draws a six-region mannequin; pointing at a
region highlights it and a tooltip gives its condition. Claude wrote its test against Claude's own implementation, so it
only ever agrees with it. A test written from the DEFINITION alone, by a second hand that has not seen the code, finds
defects in the contract (C142, C152, C192). **DO NOT OPEN `Godot/scripts/BodyMapFigure.gd`,
`Godot/tests/profile_body_map_test.gd`, `research/S68_DIGEST.md`, or the S68 commits' diffs.** You may read
`Godot/scripts/BodyReadiness.gd` EXCEPT the function `forecast_region_weeks` (grep it and skip its body),
`Godot/scripts/InjuryWords.gd`, `Godot/scripts/RecoveryWords.gd`, `Godot/scripts/Injury.gd`, and
`Godot/tests/profile_revamp_test.gd` lines 1-45 (how to boot a career and mount the profile panel).

## The definition (test THIS - it is the contract; a failure against the shipped code is a candidate defect)
The operator, verbatim: "a full body ... where it shows where if there are any injuries on a part of the body, and ... I
want to move the cursor on the hand, I want it to get highlighted. And then maybe a tooltip pop up and says the
condition of that limb."

1. `BodyReadiness.forecast_region_weeks(athlete: Dictionary, context: Dictionary = {}, max_weeks: int = 26) -> Dictionary`
   - keyed by EVERY id in `BodyReadiness.region_ids()`; each value `{"gym": int, "cage": int}`.
   - `gym` = weeks of plain REST (the same weekly step `forecast_weeks_to_training` uses, `activity = "rest"`) until that
     region is at or above `BodyReadiness.training_threshold()`; `cage` = the same for `competition_threshold(region)`.
   - 0 when the region is already there; -1 when it is not there within `max_weeks`. Never mutates `athlete`.
   - Must AGREE with `forecast_weeks_to_training(athlete, "rest", context, max_weeks)`: the largest `gym` across regions
     equals its `weeks` (and both are -1 together).
   - An injury's ceiling (`region_ceiling`) must be respected when `context.current_week` is given.
2. The panel: mount `ProfileRevampPanel`, `select_tab("body")`; the node named `BodyFigure` under `TabBody` is the map.
   Its public surface (exact names): `shapes() -> Dictionary` (region id -> Array of PackedVector2Array, local coords),
   `region_at(point: Vector2) -> String` ("" on no body part), `region_centroid(region: String) -> Vector2`,
   `set_hovered(region: String, point := Vector2(-1, -1))`, `tooltip_text() -> String` ("" when closed),
   `region_color(region: String) -> Color`, and meta `"hovered"`. It takes the mouse (`MOUSE_FILTER_STOP`) and a real
   `InputEventMouseMotion` through `_gui_input` must hover exactly as `region_at` says.
3. The anatomy: head above torso above legs; the LEFT arm/leg on the reader's LEFT (the same side the lab sheet's cells
   `Region1` LEFT ARM / `Region4` LEFT LEG sit); the six regions do not overlap at each other's centroids.
4. The tooltip, one fact per line, in this order: the region's name (InjuryWords `region_label`), its value as
   `"<v> / 100"` and its state word (SOUND >= training line, SORE in the amber band, HURT below it - BodyReadiness
   bands); the injury (`InjuryWords.headline`, or exactly `NO INJURY` when the region carries none - never invented);
   when injured, the RecoveryWords phase line; `GYM <training_threshold>` with `CLEAR` or `SHORT BY <n>`;
   `CAGE <competition_threshold(region)>` the same; when the region is short of either line, a `RESTING:` line built from
   (1) (`NOW`, `IN <n> WEEK(S)`, or `NOT IN 26 WEEKS`); the RecoveryWords ceiling words when a ceiling applies.
5. Colour: a sound, uninjured region is plain grey; SORE and HURT are different colours from grey and from each other;
   HURT is `UITokens.BAD`; a named injury is never plain grey even if its value is back over the line; the hovered
   region is drawn differently from its unhovered self. Leaving the figure (hover "") closes the tooltip.

## Owned files
A NEW `Godot/tests/body_map_blind_test.gd` and `research/C193_DIGEST.md`. Nothing else.

## Gate (tier: a new test file only)
`python Godot/tools/check_scripts.py Godot/tests/body_map_blind_test.gd`, then ONE run:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/body_map_blind_test.gd` (exe in
`%LOCALAPPDATA%\Programs\Godot\`). Prove it with at least 5 throwaway mutants of the shipped code (you may EDIT
`BodyMapFigure.gd`/`BodyReadiness.gd` blind - e.g. flip a sign, drop a line - WITHOUT reading them beyond the edit site,
and revert every one); report each mutant's FAIL count - "caught" means the test printed FAILs, not zero. No full suite.
Branch `codex/c193-blind-body-map-test` off `origin/master`. Commit with explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C193 --body "<checks, failures, each mutant and its FAIL count, any contract disagreement>"`.
Do NOT edit HANDOFF.md.

## The one trap
A failure against the shipped code is a RESULT, not something to fix by bending the test: if the shipped map disagrees
with this definition, keep the assertion, say so in the digest and the mail, and let Claude judge which is wrong.
