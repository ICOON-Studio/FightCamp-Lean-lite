# Q200 Digest — Fix the four defects Q199B found

**Owner:** qwen
**Date:** 2026-09-27
**Branch:** qwen/q200-four-defects

## Summary

**3 of 4 fixed. 1 reported unfixable without losing U183's result.**

## Fixed

### fight_stage_presenter_contract (U183) ✅
**Root cause:** U183 bound all 9 boxing footwork IDs to "idle" via STRIKE_FAMILY_BINDINGS. Every unbound strike also resolves through NEAREST_CLIP or family pair to a bound clip. The seeded boxing bouts produce ZERO clipless beats.
**Fix:** Injected one synthetic clipless beat (`q200_synthetic_unknown`, `clip_missing=true`) into the test fixture after the seeded bouts. Proves the clipless code path still works — no production code changed.

### fight_stage_technique_fidelity (U183) ✅
**Same root cause.** Same fix pattern — synthetic beat injected into `_drive()` before the seeded loop.

### daily_progression (S89) ✅
**Root cause:** S89 added `_book_open_spar_night()` and the visiting-pro floor event roll to `advance_day()`, but not to `advance_week()`. The walk path (7× advance_day) rolled floor events daily and auto-resolved stale ones, producing headlines. The jump path (advance_week) did neither — different news count.
**Fix:** Added to advance_week's daily loop (for each pending_day):
1. Set `career_day = pending_day + 1` (matching advance_day's timing)
2. Auto-resolve any stale floor event with `default_choice`
3. `_roll_floor_event()`
4. `_book_open_spar_night()`
5. Restore `career_day`

Also added a stale floor event auto-resolve at the top of advance_week (before the daily loop) for events carried over from a previous week.

## Unfixable

### fight_world_live (U183) ❌
**Why:** The "carried" and "stanced" counters in FightWorldLiveScreen require `presented_thrower_footwork=true`, which needs a `technique_class: movement` beat with no clip. ALL movement techniques available in standing striking rulesets are shared `boxing_*` IDs bound to "idle" via STRIKE_FAMILY_BINDINGS (lines 2456-2464 of FightClipBinding.gd). Changing the ruleset doesn't help — kickboxing, muay_thai, and MMA all use the same footwork IDs. The live scene can never reach the "carried" or "stanced" path without reverting U183's binding.

**Per task instruction:** "If a test cannot be fixed without losing U183's result, say so and leave it red."

## Gates
- Parse: `check_scripts.py` on 3 touched files — 0 fails
- `fight_stage_presenter_contract_test` — PASS
- `fight_stage_technique_fidelity_test` — PASS
- `daily_progression_test` — PASS
- `boxing_footwork_clearance_test` (U183's own) — PASS (not regressed)
- `visiting_sparring_test` — PASS (not regressed)
- `fight_world_live_test` — FAIL (reported unfixable)

## Files touched
- `Godot/scripts/GameState.gd` — advance_week floor event parity
- `Godot/tests/fight_stage_presenter_contract_test.gd` — synthetic beat
- `Godot/tests/fight_stage_technique_fidelity_test.gd` — synthetic beat
