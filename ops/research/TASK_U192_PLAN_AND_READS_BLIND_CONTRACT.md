# TASK U192 - CURSOR - A BLIND CONTRACT TEST FOR THE AI PLAN AND THE CORNER READS (S101)
Owner: cursor. Assigned 2026-09-27 (S101). Model: Cursor default (Auto). Branch `cursor/u192-plan-reads-contract` from
`origin/master`, own worktree. Claude merges. **Tier: a NEW test file only - parse gate plus that one test.**

## Why
Claude wrote the S101 AI-corner plan and the S100 corner reads and tested them itself. A test written by the author
only ever agrees with the code. Write the test from THIS CONTRACT, not from the code: read the two scripts only to
learn how to call them, never to decide what they should return.

## What would a human do?
A QA engineer on a management game writes the spec's promises as checks - "a better coach never plans worse on
average", "a read the corner fumbled does nothing" - and tries to break each one, including the edges (a coach at
25 and at 95, a boxer who cannot be told to take it down, a minute with too many jobs).

## Prefab check
None needed: the project's own SceneTree test pattern (any `Godot/tests/*_contract_test.gd`) is the harness; do not
add a test framework (GUT/GdUnit) for one file.

## The contract (exact names)
`res://scripts/FightPlanSetup.gd` (pure, static):
- `ai_sliders(ours: Dictionary, theirs: Dictionary, ruleset_id: String, tactical: float, key: String) -> Dictionary`
  returns the five keys `range`, `pace`, `target`, `grappling`, `risk`, each in -1..1, snapped to 0.01.
  Same arguments -> same result (deterministic by `key`). Under `boxing`, `kickboxing`, `muay_thai` grappling is -1.0.
- `ai_scatter(tactical: float) -> float` decreases as tactical rises (25..95); clamps outside that range.
- `ai_reads(tactical: float) -> Array`: [] below 75, ["tell"] from 75, ["tell", "exit"] from 88.
- `view(sliders, ours, theirs, ruleset_id, key, style_spar_weeks, film_depth)["overall"]` is an int 0..100.
  Promise: over 40 keys, the MEAN overall of a tactical-90 coach's `ai_sliders` exceeds a tactical-30 coach's.
`res://scripts/CornerPitStop.gd` (pure, static):
- `cards(fighter, problems(fighter))` offers `read_tell` / `read_exit` (lane "chief", `seconds` 20.0) exactly when
  `fighter["corner_reads"]` holds "tell" / "exit"; none when the key is absent.
- `fits(picks)` is false for survive + read_tell + read_exit together (chief lane over `USABLE_S` 45).
- `apply(fighter, picks, "normal", 50.0, rolls)`: a read whose roll is >= the mistake chance sets
  `fighter["read_next"]["contact"] > 0` (tell) or `["defence"] > 0` (exit); a roll of 0.0 (fumbled) sets nothing.
  `rolls_needed(picks)` counts one roll per read card.

## Do
Write `Godot/tests/plan_reads_contract_test.gd` (extends SceneTree, `load()` both scripts in `_initialize`, prints
`PLAN_READS_CONTRACT_TEST PASS` or `FAILS=n`). Never identical fighters in any fixture: give `ours`/`theirs` different
reach and stats. Then PROVE it: break each promise on purpose in a scratch copy (e.g. `ai_reads` threshold 60, scatter
increasing) and show the test goes red - list each mutant and its red check in the digest, then restore.

## Gate
Parse gate + that one test green. Nothing else. Owned: the test, `research/U192_DIGEST.md`.

## Deliver
Commit and push as you go; digest; `python Tools/agent_comms.py send --from cursor --to claude --topic U192 --body
"..."`. Do NOT edit HANDOFF.md. **Trap:** do not "fix" the scripts if a check fails - a red check against the contract
is the finding; report it.
