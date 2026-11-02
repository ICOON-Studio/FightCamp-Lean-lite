# TASK_C197 - a BLIND contract test for THE GYM MARKET slice two (Codex, test only)

Model: gpt-6-luna, medium (contract test, not motion). Owner: codex. Assigned S71, 2026-09-25.

## Why
S71 shipped slice two of the gym market (G74 4.3, J47, G88): rivals that invest, kit TYPES as a draw, a title spike, and
crowding only on a shared slot. Claude wrote `gym_market_slice_two_test.gd` against Claude's own code, so it only ever agrees
with it. Your C194 did the same job for slice one and found real fixture/contract gaps. **DO NOT OPEN
`Godot/tests/gym_market_slice_two_test.gd`, `Godot/tests/gym_market_test.gd`, `research/S71_DIGEST.md` or the S71
commit diffs, and do not read the BODIES of the functions below.** You may read `Godot/assets/data/membership.json` whole (the
data IS the contract), `Godot/scripts/Membership.gd` function SIGNATURES only (`grep -n "^static func" Godot/scripts/Membership.gd`),
and your own `Godot/tests/gym_market_blind_test.gd` for how to boot a real career.

## The definition (test THIS; a failure against the shipped code is a candidate defect - say so, do not bend the test)
`Membership` (pure static, `preload("res://scripts/Membership.gd")`), every magnitude read from `membership.json`:
1. `kit_types_from_items(item_ids: Array) -> Array` - the sorted, de-duplicated kit TYPES whose `kit_type_items` list holds any
   id. Bags, cardio etc. are no type. Two rings are one "ring".
2. `kit_type_score(types: Array) -> float` - sum of `kit_type_points` over DISTINCT types, clamped 0-100.
3. `attractiveness(scores)` - as slice one (coach 3.0, facility 2.0, kit 1.0, reputation 0.4, each x a 0-100 clamped score)
   PLUS `kit_type` x `attractiveness_weights.kit_type`, and the whole sum multiplied by (1 + max(0, scores.title_spike)).
   CONTRACT: one coach (`coach_score_per_coach` points) pulls MORE A than every kit type together.
4. `title_spike(weeks_since: int, defence := false) -> float` - 0 for weeks_since < 1 or > `title_spike_weeks`; else
   `title_spike_peak` x 0.5^(weeks_since - 1); a defence multiplies the peak by `title_spike_defence_scale`.
5. `rival_invest_interval(rival) -> int` - round(`rival_invest_base_weeks` x `rival_invest_ambition_scale`[ambition]), the
   `default` scale for an unknown ambition, never below 1.
6. `rival_invest(rival: Dictionary, week: int) -> Dictionary` (mutates `rival`; returns `invested`, `kind` "kit"/"quality",
   `kit`, `quality_before`, `quality_after`): nothing when `financial_strength` < `rival_invest_min_strength`, or when fewer than
   the interval's weeks have passed since `last_invest_week`. When due: first the discipline's kit (`discipline_kit`: boxing /
   kickboxing / muay_thai -> ring, mma -> cage, else mat) if `kit_types` lacks it, then "strength", then facility_quality +
   `rival_quality_step` capped at `rival_quality_cap`; nothing left to buy -> no investment. Sets `last_invest_week` when it
   invests. A rival with no `last_invest_week` has a clock staggered by its id (two such rivals need not invest the same week).
7. `shares_member_slot(coach_count: int, team_slot := "") -> bool` - "evening" true, "day" false, else coach_count <
   `apart_session_min_coaches`.
8. `crowd_ratio(fighters, members, capacity, shared_slot := true)` - (fighters + [members x `crowd_peak_fraction` only when
   shared]) / max(capacity, 1).

GAMESTATE (autoload, a real career via `begin_new_career` / `finalize_new_career`):
9. `get_membership_market()` carries `kit_types`, `title_spike`, `team_shares_member_slot`, `crowd_ratio`, `crowd_yield`;
   `get_floor()["team_slot"]` = "day" makes `crowd_yield` 1.0 however many members.
10. `_advance_rival_investment(week, {"force_rival_ids": [id]})` makes that city rival's clock due this week and returns the
   news lines (each names the rival). A refit of a city rival lowers the player's `target`.
11. **THE ONE CLAUDE DID NOT DRIVE - DRIVE IT:** a home fighter WINNING A TITLE FIGHT through the real result path
   (`GameState._apply_fight_result(athlete, offer_id)`, the path `Godot/tests/belt_scale_test.gd` exercises at the
   WorldPopulation level - read it for how a belt and a title bout are set up) sets `career.membership.title_week` to that
   career week with `title_defence` false for a new belt and true for a defence; a LOSS or a non-title win sets neither. The
   next week's `get_membership_market().title_spike` is > 0.

## Fixtures
Real careers in two DIFFERENT cities (sizes differ). Title bout: two DIFFERENT fighters legal for the ruleset (different
stats, frames, style), named in the test's output. Never two identical men.

## Owned files
A NEW `Godot/tests/gym_market_slice_two_blind_test.gd` and `research/C197_DIGEST.md`. Nothing else.

## Gate (tier: a new test file only)
`python Godot/tools/check_scripts.py Godot/tests/gym_market_slice_two_blind_test.gd`, then ONE run:
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_market_slice_two_blind_test.gd` (exe in
`%LOCALAPPDATA%\Programs\Godot\`). Print `GYM_MARKET_TWO_BLIND checks=N failures=M`. Prove it with at least 5 throwaway mutants
of the shipped code (in `Membership.gd`, or the title lines in `GameState._apply_fight_result` found by
`grep -n "_note_membership_title_win" Godot/scripts/GameState.gd`) - edit blind at the site, revert every one; report each
mutant's FAIL count. `GameState.gd` is ~15,200 lines - NEVER open it whole; `grep -n` and read `sed -n 'A,Bp'` windows only.
No full suite. Branch `codex/c197-blind-market-two` off `origin/master`. Commit with explicit paths, push,
`python Tools/agent_comms.py send --from codex --to claude --topic C197 --body "<checks, failures, each mutant and its FAIL count, any contract disagreement>"`.
Do NOT edit or read HANDOFF.md, CURRENT_STATUS.md or any digest.

## The one trap
Item 11 is the reason this task exists. A title bout that is not REALLY a title bout (no belt in the division, the flag not
booked, the winner missing weight) sets nothing - and a test that passes because nothing was set is measuring its fixture.
Assert the belt MOVED to your fighter (`get_athlete_titles`) before you assert the spike.
