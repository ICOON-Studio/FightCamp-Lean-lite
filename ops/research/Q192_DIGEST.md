# Q192 Digest — Do the fight plans make different fighters? (And the MMA jab row)

## Instrument
`Godot/tools/q192_plan_separation.gd` — 3 fighters × 3 opponents × 2 seeds per cell,
per ruleset (boxing, kickboxing, MMA). Per-plan profile: output/min, jab_share,
leg_target_share, td_per_round. Plan-to-plan L1 distance matrix beside NOISE floor
(same plan, fresh seeds). A pair < 2× max noise is "not distinct".

Also: `Godot/tools/q192_mma_jab_census.gd` — 10 MMA bouts, every technique id counted.

## MMA Jab Row — CONFIRMED AND FIXED

**Census (10 bouts, 2343 throws side A):**
- Counted as jab (old: "jab" in id): 36 (1.5%)
- Top technique: empty string "" (1819) — the engine's fallback path
- Lead-hand punch NOT counted as jab: **muay_thai_mat_yaep** (count=9) — the Thai jab
- Also: muay_thai_fake_jab_knee (14) was counted as jab despite being a knee

**Fix in FightBroadcast.gd:**
- Added `is_jab_technique()` — builds a static set from the technique catalog
  (limb=lead_hand AND technique_class=punch), falls back to "jab" in id for
  synthetic test logs
- Both call sites (round_stats line ~139, unanswered_power line ~309) now use it
- Parse gate clean; jab/power/body split test passes

## Boxing Plan Separation — ROOT CAUSE FOUND, NOT FIXABLE FROM PLANS ALONE

**Before (original plans, 3×3×2):**
```
out_boxer:       out/min=5.33  jab=0.420
pressure:        out/min=6.76  jab=0.112
boxer_puncher:   out/min=6.03  jab=0.274
counter_puncher: out/min=5.60  jab=0.271
```
- DISTINCT pairs: 4/6 (threshold 0.994)
- NOT DISTINCT: boxer_puncher vs counter_puncher (d=0.354), out_boxer vs counter_puncher (d=0.815)

**After tuning plans more extreme (pace/target_bias):**
- Got WORSE: 3/6 distinct. Boxer-puncher became a "middle" plan close to everything.

**Root cause:** `FightMoves.gd:108` — `ROLE_PRIORITY_FROM_PLAN := false`.
The plan's role_priority (PRIMARY/SECONDARY/AVOID per role) is NOT used for
technique selection. Only two levers work:
1. `pace_curve` → affects output/min (via `_throw_context` → `Plans.pace_for_round`)
2. `target_bias` → affects region_weights (via `_region_bias`)

For boxing, leg_target_share and td_per_round are always 0, so only 2 columns
move: output/min and jab_share. But jab_share doesn't move with the plan — it's
determined by the arsenal composition, not the plan's role weights. With 4 plans
and effectively 1 moving dimension (output/min), not all 6 pairs can be distinct.

**Recommendation (engine change, not mine to make):**
Turn `ROLE_PRIORITY_FROM_PLAN` ON in FightMoves.gd. The comment at line 102-108
says it moves the D3 split, pace and knockdown anchors simultaneously and needs
measurement before flipping. Q192's measurement is the evidence: without it,
plans cannot produce distinct fighters in the columns that matter.

## Kickboxing Plan Separation
- DISTINCT pairs: 2/3 (threshold 0.914)
- NOT DISTINCT: dutch_pressure vs thai_kicker (d=0.713)
- Same root cause: ROLE_PRIORITY_FROM_PLAN OFF, only pace moves output

## MMA Plan Separation
- Jab shares now non-zero after fix: 0.060-0.142 (was 0.020-0.129)
- Output was cut off by timeout but sprawl_and_brawl vs submission_grappler
  showed d=1.433 (distinct)

## Blocker: GameState TitleHonours parse error
`GameState.gd:13330` references `TitleHonours` without a preload/const.
TitleHonours.gd has `class_name TitleHonours` but the engine can't resolve it
in headless mode. This blocks FightOpponentGenerator (calls GameState.get_ruleset)
and causes fight_plan_explainer_test to script-error. Not caused by Q192 changes;
present on master at commit 05f98de7. Fix: add `const TitleHonours = preload("res://scripts/TitleHonours.gd")` to GameState.gd.

## Tests
- Parse gate: FightBroadcast.gd PASS, q192_plan_separation.gd PASS
- fight_broadcast_test: jab/power/body split PASS; "plate shows round 1" FAIL
  (pre-existing: BroadcastCardPanel can't compile, fonts missing from .godot cache)
- fight_plans_test: 34/34 checks PASS (before GameState access at line 176)
- fight_plan_test, fight_plan_explainer_test: blocked by GameState TitleHonours error

## Owned files changed
- `Godot/scripts/FightBroadcast.gd` — jab classification fix
- `Godot/tools/q192_plan_separation.gd` — new instrument
- `Godot/tools/q192_mma_jab_census.gd` — new census tool
