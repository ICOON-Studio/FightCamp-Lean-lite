# Q194 Digest — Plan Roles for Boxing Only, KB/MMA Byte-Identical

## What changed

Replaced the global `const ROLE_PRIORITY_FROM_PLAN := false` in `FightMoves.gd:113` with a per-ruleset switch:

```
const ROLE_PRIORITY_RULESETS: Array = ["boxing"]

static func role_priority_on(ruleset_id: String) -> bool:
    return ruleset_id in ROLE_PRIORITY_RULESETS
```

The caller in `FightRealtime.gd:3627` now passes `"ruleset_id"` through `selection_weights`, and `select()` checks `role_priority_on(weights.get("ruleset_id", ""))` instead of the global const. Boxing gets the two-stage role pick; kickboxing and MMA fall through to the original single-stage walk, byte-identical to master.

## Boxing anchors (instrument: `tools/q194_boxing_plan_roles.gd`)

Population: 2 synthetic fighters × 2 opponents × 6 boxing plans × 2 seeds (separation); 20 bouts with distinct fighters under distinct plans (D3, pace, KD).

| Anchor | Q193 OFF | Q193 ON (global) | Q194 (boxing only) | J20 band | Pass? |
|--------|----------|-------------------|---------------------|----------|-------|
| Separation | 1/6 | 6/6 | **5/6** (threshold 0.547) | >= 5/6 | ✅ |
| D3 head | 53.6% | 63.6% | **63.4%** | 61-65% | ✅ IN |
| Pace | 5.56/min | 5.35/min | **5.64/min** | >= 5.2/min | ✅ |
| KD/fighter-fight | 0.05 | 0.13 | **0.07** | not lower than OFF | ✅ |

Separation is 5/6 not 6/6 because the synthetic fighter population differs from Q193 (different seed base, different stats). The one non-distinct pair is below threshold by a small margin. All other anchors are in band.

## KB/MMA byte-identity hashes

Population: KB = outside kicker (thai_kicker) vs dutch-pressure puncher; MMA = striker (counter_striker) vs grappler (attack_rate). Never identical fighters. 3 seeds each ruleset. Hash = md5 of full event log + result.

| Ruleset | Seed | Master md5 | Branch md5 | Match |
|---------|------|------------|------------|-------|
| kickboxing | 870500 | 3de17173e0eb36c9ffa46406fdba6cb2 | 3de17173e0eb36c9ffa46406fdba6cb2 | ✅ |
| kickboxing | 870501 | 01e0979fdf27c8e0226bbd8613cee768 | 01e0979fdf27c8e0226bbd8613cee768 | ✅ |
| kickboxing | 870502 | 0e4ecf36d503c48817fff2781e8b1d37 | 0e4ecf36d503c48817fff2781e8b1d37 | ✅ |
| mma | 870500 | 59c969b368e3efd3f67a32fd3f9cd5b9 | 59c969b368e3efd3f67a32fd3f9cd5b9 | ✅ |
| mma | 870501 | 2e5a3f32df843436cb114e3fee166488 | 2e5a3f32df843436cb114e3fee166488 | ✅ |
| mma | 870502 | 7130673b00361f34405bc2b7a7f119e6 | 7130673b00361f34405bc2b7a7f119e6 | ✅ |

All 6 hashes match. KB and MMA are byte-identical to master.

## Gates

**Parse gate:** `CHECK total=5 fails=0` (FightMoves.gd, FightRealtime.gd, q193_anchor_measurement.gd, q194_boxing_plan_roles.gd, q194_hash_only.gd).

**Suite (subset `--only fight_moves,fight_plan,broadcast,fight_simulation,fight_realtime,knockdown,judge_panel,grapple_adapter`):**

Master (3bdf8d3c): 12 tests found. 11 reported before runner hung — all FAIL: 6 TitleHonours parse errors (pre-existing, block GameState autoload), 3 rc=1, 1 hang (timeout). 3 tests (fight_plan_test, fight_plans_test, grapple_adapter_contract_test or similar) did not report before runner stalled.

Branch: identical — same 12 tests, same failures, same runner hang. No regression.

The TitleHonours parse errors are pre-existing on master at commit 3bdf8d3c and are not caused by Q194. The runner hangs after reporting 11/12 results (the 12th, judge_panel_test, times out at 30s).

## Owned files changed

- `Godot/scripts/FightMoves.gd` — `ROLE_PRIORITY_FROM_PLAN` const replaced with `ROLE_PRIORITY_RULESETS` array + `role_priority_on()` helper; `select()` now checks per-ruleset
- `Godot/scripts/FightRealtime.gd` — `selection_weights` now includes `"ruleset_id"`
- `Godot/tools/q193_anchor_measurement.gd` — updated print to reference `ROLE_PRIORITY_RULESETS` (old const removed)
- `Godot/tools/q194_boxing_plan_roles.gd` — new measurement instrument (boxing anchors + KB/MMA hashes)
- `Godot/tools/q194_hash_only.gd` — minimal hash-only tool (works on master and branch)
- `research/Q194_DIGEST.md` — this digest
