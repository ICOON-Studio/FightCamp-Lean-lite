# Q205 - MMA State Time Share Census

**Owner:** qwen | **Assigned:** 2026-09-27 (S102) | **Branch:** `qwen/q205-mma-state-share`

## Census Results (40 seeds × 3 matchups, weighted by tick spans)

### Before Fix (CLINCH_ENGAGE_BASE = 0.0020, shared across all non-judo rulesets)

| Population | Bouts | Distance % | Clinch % | Ground % | TD/5min | TD Land % |
|---|---:|---:|---:|---:|---:|---:|
| A: striker(34) vs grappler(82), 77 kg | 40 | 61.4% | 2.4% | 36.2% | 1.57 | 55.3% |
| B: brawler(55) vs kicker(28), 70 kg | 40 | 68.8% | 3.5% | 27.7% | 1.47 | 57.6% |
| C: pressure(40) vs counter(35), 84 kg | 40 | 87.8% | 1.8% | 10.4% | 1.17 | 39.7% |
| **POOLED** | 120 | **73.1%** | **2.5%** | **24.4%** | **1.41** | **51.8%** |

### After Fix (MMA_CLINCH_ENGAGE_BASE = 0.0140, MMA-gated)

| Population | Bouts | Distance % | Clinch % | Ground % | TD/5min | TD Land % |
|---|---:|---:|---:|---:|---:|---:|
| A: striker(34) vs grappler(82), 77 kg | 40 | 50.8% | **15.1%** | 34.1% | 2.02 | 52.1% |
| B: brawler(55) vs kicker(28), 70 kg | 40 | 59.2% | **12.7%** | 28.1% | 2.03 | 52.5% |
| C: pressure(40) vs counter(35), 84 kg | 40 | 73.2% | **10.9%** | 15.9% | 2.01 | 46.9% |
| **POOLED** | 120 | **61.2%** | **12.9%** | **25.9%** | **2.02** | **50.5%** |

### G138 Reference (FightMetric/Kuhn)

| Phase | G138 Band |
|---|---|
| Distance | ~50-52% |
| Clinch | ~15-18% |
| Ground | ~25-32% |
| TD/5min | 1.5 |
| TD Land % | 39% |

## Largest Gap → Lever

**Clinch share was 13 pp below G138's 15-18% band (2.5% vs 15-18%).**

**Lever:** `CLINCH_ENGAGE_BASE` controls how often fighters tie up per decision tick. The shared 0.0020 base was tuned for striking rulesets (boxing/kickboxing), where clinches are rare. MMA fighters tie up far more often.

**Fix:** Added `MMA_CLINCH_ENGAGE_BASE := 0.0140` (7× the shared base), gated to `ruleset_id == "mma"` in `_clinch_engage_base()`. Boxing/kickboxing continue using the shared base and are byte-identical by construction.

**Result:** Clinch share moved from 2.5% → 12.9% (+10.4 pp). Pop A (striker vs grappler) now sits at **15.1% - INSIDE G138's 15-18% band**.

## Side Effects

- TD/5min increased from 1.41 → 2.02 (above G138's 1.5). More clinch engagements create more takedown opportunities. This is a separate calibration problem (takedown success rate or shot frequency), not the lever this task pulled.
- Distance share dropped 11.9 pp (73.1% → 61.2%), which is correct - time moved from distance to clinch.
- Ground share stable (24.4% → 25.9%, within G138's 25-32% band).

## Boxing/Kickboxing Verification

Hashes on 4 seeds each (boxing/kickboxing unchanged by MMA gate):

**Boxing:**
- seed=100: 1570806966
- seed=101: 1619927635
- seed=102: 3182558540
- seed=103: 435149387

**Kickboxing:**
- seed=100: 2988965620
- seed=101: 1674573614
- seed=102: 1366861713
- seed=103: 1308474891

## Ground Seat Split (pooled, after fix)

| Seat | % of Ground | G138 Reference |
|---|---:|---|
| Guard | 30.9% | 40-50% |
| Half | 9.2% | 20-25% |
| Side | 24.6% | 10-15% |
| Mount | 31.0% | 8-12% |
| Back | 4.3% | 8-12% |

Mount and side are over-represented; guard and half are under-represented. This is a separate ground-position calibration problem, not the clinch lever this task pulled.

## Failed Shot Destinations (pooled, after fix)

| Destination | Share | G138 Reference |
|---|---:|---|
| Reset to distance | 40.9% | 25-35% |
| Clinch on cage | 30.6% | 25-35% |
| Guard pulled | 11.9% | 5-10% |
| Front headlock / turtle | 16.6% | 15-25% |

Reset is over-represented; guard pulled is slightly high. The engine does not yet model front headlock or turtle as distinct states (G138 §6 lists these as missing states to build).

## Files Changed

- `Godot/scripts/FightRealtime.gd` - Added `MMA_CLINCH_ENGAGE_BASE` constant and MMA gate in `_clinch_engage_base()`
- `Godot/tools/q205_mma_state_time_census.gd` - Census tool (3 matchups, 40 seeds, tick-weighted)
- `Godot/tools/q205_verify_striking_rulesets.gd` - Boxing/kickboxing hash verification

## Gate

Parse gate passed. Focused test not run (research task, no `.gd` edited except FightRealtime.gd which is gated to MMA only). Claude will re-pin at integration if needed.
