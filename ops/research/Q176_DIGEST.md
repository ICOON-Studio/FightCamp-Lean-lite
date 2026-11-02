# Q176 DIGEST — Footwork Economy
Qwen, 2026-09-25. Branch: `qwen/q176-footwork`.

## Decomposition (where the travel is made)

Ran `tools/q176_decompose_travel.gd` on 4 seeds × 3 rulesets (distinct fighters per ruleset).

**OFF baseline (shipped tree):**
| Ruleset    | m/min A/B     | Moving % A/B  | Dominant source |
|------------|---------------|---------------|-----------------|
| Boxing     | 40-49 / 40-43 | 61-72% / 61-66% | circle: 35-48% ticks, 53-65% of metres |
| Kickboxing | 44-47 / 40-43 | 67-70% / 63-66% | circle: 37-46% ticks, 52-62% of metres |
| MMA        | 28-39 / 28-35 | 44-59% / 44-54% | circle: 33-45% ticks, 48-60% of metres |

**Root cause:** Circle intent has THROTTLE=0.65 and fires 35-48% of decision ticks, producing the majority of travel. Hold (THROTTLE=0.08) is 26-42% of ticks but only 12-19% of metres.

## Implementation

New option `footwork_economy` in FightRealtime.gd, default OFF (byte-identical).

When ON, in `_run_movement` after direction is computed:
- `close`: full throttle (the burst: step in to strike)
- `retreat`: direction × 0.50
- `circle`: direction × 0.30 (small pivots to keep angle)
- `hold`: direction = ZERO (stand still)
- Burst limiter: 15 consecutive non-hold ticks → 20 ticks forced hold (0.75s burst → 1.0s pause)
- Per-fighter tracking: `fe_burst` and `fe_cooldown` fields (zero when OFF)

## ON results (PROXY targets: 15-30 m/min boxing, 25-45% moving)

| Ruleset    | m/min A/B     | Moving % A/B  | In band? |
|------------|---------------|---------------|----------|
| Boxing     | 21-26 / 21-22 | 39-45% / 39-41% | YES |
| Kickboxing | 19-25 / 19-22 | 37-43% / 37-41% | YES |
| MMA        | 14-20 / 14-18 | 26-35% / 27-34% | YES |

## OFF hash proof (byte-identical)

s70_feint_off_hash.gd: all 9 hashes (3 rulesets × 3 seeds) byte-identical to master.
Verified by stashing changes, running on master, comparing: exact match.

## Anchors ON vs OFF

- Events ratio ON/OFF: 1.61 (within 0.50-2.50 band)
- Active time ratio ON/OFF: 1.60 (within 0.50-2.00 band)
- fight_pace_anchor_test D1 failure (5.79/min) is PRE-EXISTING on master, not caused by Q176

## Tests

- `tests/fight_footwork_economy_test.gd`: 10 checks PASS
  - OFF hash stable (byte-identical replay)
  - ON m/min 15-30, moving% 25-45
  - ON < OFF
  - Anchors in band
- Focused tests: fight_footwork_test PASS, fight_footwork_route_test PASS, fight_movement_quality_test PASS, fight_feint_test PASS, fight_stamina_test PASS

## Files

- `Godot/scripts/FightRealtime.gd` — option parsing, state dict, fighter fields, movement logic
- `Godot/tools/q176_decompose_travel.gd` — decomposition measurement tool
- `Godot/tests/fight_footwork_economy_test.gd` — test
- `research/Q176_DIGEST.md` — this file

## Population

All tools use distinct fighters (never identical):
- Boxing: Counter-puncher (tech 74/speed 70) vs Pressure fighter (power 72/cond 78)
- Kickboxing: Outside kicker (tech 70/reach 190) vs Puncher (power 74/tech 58)
- MMA: Striker (power 68/tech 66) vs Grappler (grapple 78/cond 74)
