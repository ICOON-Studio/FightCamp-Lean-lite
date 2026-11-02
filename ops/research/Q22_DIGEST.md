# Q22 DIGEST — GrappleAdapter.gd

Owner: Qwen. 2026-09-10. Source: G37_THE_ADAPTER_FOLD.md.

## What was built

`Godot/scripts/GrappleAdapter.gd` — statics only, ZERO preloads. Seven public
static functions matching the G34 contract exactly:

- `rulesets()` → `["ijf","uww","ibjjf","abc"]`
- `scores_grappling(ruleset)` → true for ijf/uww/ibjjf, false for abc
- `hold_gates_seconds(ruleset)` → ijf `{yuko:5,waza_ari:10,ippon:20}`, ibjjf
  `{score:3}`, **uww and abc are EMPTY dictionaries** (NONE PUBLISHED)
- `award(ruleset, event)` → `{kind, points, counter}` per G37 §1.A–D tables
- `advantage(ruleset, situation)` → IBJJF only, 0 for all others
- `stall(ruleset)` → 45/30/20/-1 seconds per G37 §5
- `submission_meaning(ruleset)` → UWW is `"no_submissions"` (freestyle has none)

`Godot/tests/grapple_adapter_test.gd` — 93 witnesses, 0 fails.

## Key decisions

1. **points = -1 for not_scored, never 0.** Absence is a finding; zero is a
   claim. Every "not scored" cell in G37's tables is -1.
2. **step_out refused for ALL rulesets including UWW.** G37 §4 reasoning is in
   a module-level comment. A 1-D engine cannot produce an honest 2-D boundary
   fact. Same structural refuse as R85 (taekwondo).
3. **UWW +1 for 5s held exposure NOT implemented.** G37 found it is NOT in the
   Jan 2026 official bands. NONE PUBLISHED → do not award.
4. **IJF osaekomi from guard/half refused.** G37 REFUSE #8. Only side/mount/back
   with back_on_tatami starts the clock.
5. **ABC is evidence-only.** scores_grappling returns false. Events increment
   counters as counts, not points.
6. **IBJJF advantages are adapter-local.** Not tied to any of the five engine
   counters. Triggered by scoring seat < 60 ticks + sequence over, or
   submission attempt without finish.

## G37 ambiguities

- IJF throw display values (ippon=5, waza_ari=3, yuko=1) are adapter-chosen
  proxies; IJF publishes no numeric ladder.
- IBJJF sweep detection relies on an `is_sweep` flag in the event dict; the
  engine has no sweep event (G37 §1.C notes this).
- ABC submission finish returns kind="finish"; the 10-point must system does
  not convert it to points.

## Suite

Focused test: TOTAL=93 fails=0. Full suite: contention with another agent's
Godot (fight_realtime_test.gd, judge_panel_test.gd fail on repeated runs —
both are other agents' modules, not touched by Q22).
