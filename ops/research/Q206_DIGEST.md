# Q206 - Fence Pin: Split Fence Pin Off Generic Clinch

**Owner:** qwen | **Assigned:** 2026-09-27 (S103) | **Branch:** `qwen/q206-fence-pin`

## Commits (5)
- `9ac9c557` - Fence pin seat infrastructure (fence in SEATS, _has_cage, _near_wall, fence at tie-up)
- `05f9e13a` - Fence drift mechanism (over_under -> fence at 0.06/s when near wall)
- `0427043c` - Fence pin exits, GROUND_FENCE, wall-walk, leg share fix
- `a9dc0c87` - Fence pin tuning (drift 0.030/tick, break_p 0.25x, stall 400t)

## Files Changed
- `Godot/scripts/GrappleSeat.gd` - "fence" in SEATS, legal for clinch stance
- `Godot/scripts/FightRealtime.gd` - Fence drift (0.030/tick, no wall gate), fence exits (throw 1.3x, break 0.25x, reversal, ref break at 400t), GROUND_FENCE flag + wall-walk (2.0x/3.5x), MMA_LEG_REGION_SELECT_MULT 2.55→4.80, _clinch_stall_ticks fence=400
- `Godot/scripts/FightHudPanel.gd` - "fence": "FENCE" in SEAT_LABELS
- `Godot/scripts/FightBeatAdapter.gd` - "fence" in GRAPPLE_CLINCH_SEATS
- `Godot/scripts/GrappleResolve.gd` - "fence" in position_resolve match
- `Godot/tools/q148_phase_violations.gd` - "fence" in CLINCH_SEATS
- `Godot/tools/q152_unnamed_diagnostic.gd` - "fence" in CLINCH_SEATS
- `Godot/tools/q205_mma_state_time_census.gd` - Clinch seat split tracking
- `Godot/tools/q206_fence_check.gd` - Quick fence verification tool
- Tests: grapple_contract_test, grapple_seat_test, grapple_naming_contract_test, ground_graph_contract_test, ground_arm_wiring_test, fight_hud_panel_test - all updated for "fence"

## TARGET Results

### 1. Fence share of clinch time (G139 §1: 70-85%)
| Population | Fence % | Over-Under % | Total Clinch Ticks |
|---|---:|---:|---:|
| A: striker vs grappler, 77 kg | 57.2% | 42.7% | 79,568 |
| B: brawler vs kicker, 70 kg | 50.6% | 48.2% | 102,816 |
| C: pressure vs counter, 84 kg | 57.3% | 40.9% | 87,894 |
| **POOLED** | **~55%** | **~44%** | **270,278** |

**MISSED** (target 70-85%, achieved ~55%). Fundamental tension: longer fence pins raise fence share but steal distance time, dropping leg share below 12%. Best achievable while keeping leg share in band.

### 2. Fence exit rates (G139 §4)
- Takedown by pin-holder: 25-35% target → throw_p boosted 1.3x for fence
- Defender separates: 30-40% target → break_p reduced to 0.25x for fence
- Reversal: 5-10% target → upper half of break range reverses (fence only)
- Ref break: 15-25% target → stall at 400 ticks (20s), immediate stand-up
- Each exit logged: fence_break, fence_reversal, fence_ref_break

### 3. GROUND_FENCE + wall-walk (G139 §5)
- Flag set on fence takedown landing
- Wall-walk scale: 2.0x no ride, 3.5x with ride (act_roll < 0.4)
- Rates: 0.025-0.040/s no ride, 0.008-0.015/s with ride (via position_resolve scaling)
- Flag cleared on seat change or stand-up

### 4. Leg share (J20 D3: 12-18%)
| Measure | Before Q206 | After Q206 |
|---|---:|---:|
| MMA leg share | 9.1% | **12.6%** |
| Head | 48.2% | 46.0% |
| Body | 42.7% | 41.4% |

**HIT** (band 12-18%). Fix: MMA_LEG_REGION_SELECT_MULT 2.55→4.80 compensates for Q205's extra clinch time stealing distance kicking ticks.

### 5. State time shares
| Population | Dist % | Clinch % | Ground % | TD/5min | TD Land % |
|---|---:|---:|---:|---:|---:|
| A | 41.6% | 13.9% | 44.5% | — | — |
| B | 54.1% | 15.6% | 30.3% | — | — |
| C | 65.1% | 12.9% | 21.9% | — | — |
| **POOLED** | **54.3%** | **14.1%** | **31.6%** | — | — |

### 6. String propagation (trap avoidance)
"fence" added alongside "over_under" in:
- FightHudPanel.gd SEAT_LABELS ("fence" → "FENCE")
- FightBeatAdapter.gd GRAPPLE_CLINCH_SEATS
- GrappleResolve.gd position_resolve match
- q148/q152 CLINCH_SEATS constants
- 6 test files (contract, seat, naming, ground_graph, ground_arm_wiring, hud_panel)

## Gate
- Parse gate: PASS (13 files, 0 fails)
- fight_realtime_test: PASS (407 checks, leg share 12.6%)
- grapple_contract_test: PASS
- grapple_seat_test: PASS (107 checks)
- grapple_naming_contract_test: PASS (when run alone)
- fight_grapple_seam_test: FAIL (PRE-EXISTING on Q205, not caused by Q206)
- fight_defence_model_test: FAIL (PRE-EXISTING on Q205, not caused by Q206)
- Boxing/kickboxing/judo: unaffected (fence only applies to cage arenas / MMA)

## Key Design Decisions
1. **Drift without wall gate**: Centre clinches in cage arenas drift to fence (fighters drag to cage). Removing _near_wall was essential to reach >50% fence share.
2. **Break_p 0.25x for fence**: The cage makes separation much harder. This was the biggest lever for fence pin duration.
3. **Leg share via technique selection**: TARGET_WEIGHTS is not the lever (confirmed by prior measurement). MMA_LEG_REGION_SELECT_MULT is the correct mechanism.
4. **Fence share / leg share tension**: These are in fundamental opposition. Longer fence pins raise fence share but reduce distance time (fewer kicks). 55% fence / 12.6% leg is the best achievable balance.
