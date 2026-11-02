# TASK Q185 - QWEN - BLIND CONTRACT TEST FOR THE TRAINING GAIN PREVIEW (queued; launch after Q184 is collected)
Owner: qwen. Assigned 2026-09-26 (post-S82). Model: qwen3-coder, medium, `--yolo`. Branch `qwen/q185-training-preview-test`.

## Why
S83 (training floor, step 1) shows the player the expected stat gain BEFORE he commits a fighter to a station, and a
progress bar to the next point. Claude writes the pure module `Godot/scripts/TrainingPreview.gd` in S83. You write its
contract test BLIND, from this contract only - never read the module (a test written against the implementation only
agrees with it).

## What would a human do?
A coach asked "what will a week on the heavy bag do for him?" answers from how much room the fighter has left to grow,
how good the bag and the coach are, and how crowded the floor is - and he would be embarrassed if his forecast and the
real result disagreed. The test's job is to prove the preview is exactly the rule below.

## The contract (exact names)
`TrainingPreview.preview_gain(stats: Dictionary, potential: int, station: Dictionary, coach_rating: float,
crowd_factor: float, fraction: float) -> Dictionary` returns `{stat_key: gain_float}` for every stat the station trains.
Per stat: `headroom = clamp((potential - current) / 20.0, 0.15, 1.0)`;
`gain = 0.6 * (0.7 + 0.3 * quality_tier) * (condition / 100.0) * (0.5 + coach_rating / 100.0 * 0.7) * headroom * fraction * crowd_factor`.
The station's `training_modifiers` map to stats through `AthleteStatModel.stats_for_modifier()`; a stat counts once even
if two tags map to it; a stat the fighter does not have is skipped. Empty station or fraction <= 0 returns `{}`.
`TrainingPreview.progress_to_next(value: float) -> float` is the fractional part, in [0, 1).

## The work
Write `Godot/tests/training_preview_contract_test.gd`: hand-computed expectations for at least 8 rows (headroom floor and
ceiling, quality 1 vs 3, condition 50, coach 0 vs 100, crowd 0.7, duplicate tags, missing stat, fraction 0, empty
station) and `progress_to_next` at 0.0, 0.25, 41.999 and 42.0. If the module is absent, print SKIP and exit 0 (as
`capsule_coverage_contract_test` did). Prove the test with two mutants applied to a scratch reference implementation of
your own (drop the headroom clamp; apply duplicate tags twice) - both must fail.

## Owned files
`Godot/tests/training_preview_contract_test.gd`, `research/Q185_DIGEST.md`.

## Tier
Parse gate on the test, then run it once (it SKIPs until the module exists). No suite.

## Research
All research is open: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit, push your branch,
`python Tools/agent_comms.py send --from qwen --to claude --topic Q185 --body "<rows, mutants caught>"`.

## The trap
Do not open `GameState.gd` to "check" the formula - the contract above is the spec. If you think a row of the contract is
wrong, say so in the digest; never silently change it.
