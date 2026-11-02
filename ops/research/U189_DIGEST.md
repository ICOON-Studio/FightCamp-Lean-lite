# U189 Digest — Kickboxing leg kicks that land

## Mechanism
`FightRealtime` passes `kb_leg_region_mult` (`KB_LEG_REGION_SELECT_MULT` = **2.92**) and `band` for kickboxing. `FightMoves._mma_region_selection_mult` applies it to **left_leg/right_leg** at **LONG/MID** only (standing kicks). MMA U178B two-stage path unchanged.

Kickboxing uses the **single-stage** joint walk (not U178B routing): technique-then-region desynced Q184 corner-stoppage seed 42001 even at mult 1.0; kickboxing has no ground tick divisor, so joint-walk leg reweight is acceptable (bout m/min checked below).

## Population (`tools/u189_kb_leg_census.gd`)
Footwork economy ON, 100 bouts/pair, seeds 20000+i×991, landed = clean+glancing, full KB tier 1–2 palette (empty `technique_progress`).

| Pair | Matchup |
|------|---------|
| 1 | `kickboxing_thai_kicker` vs `kickboxing_counter_striker` |
| 2 | `kickboxing_dutch_pressure` vs `kickboxing_counter_striker` |

## Leg share (landed strikes)

| Pair | Before | After |
|------|--------|-------|
| 1 thai vs counter | **8.9%** (398/4490) | **15.4%** (706/4597) |
| 2 dutch vs counter | **11.1%** (607/5455) | **20.0%** (1116/5583) |
| pooled | **10.1%** (1005/9945) | **17.9%** (1822/10180) |

Style: thai kicker leg share **20.2%** > counter striker **9.8%** (pooled). Counter striker **head > torso** on landed regions both pairs.

## Bout m/min (strikes / active minute)

| Pair | Before | After |
|------|--------|-------|
| 1 | 5.66 | 5.60 |
| 2 | 7.33 | 7.36 |
| pooled | 6.47 | 6.45 |

No m/min collapse (U178 trap).

## KO+TKO (same seeds)

| Arm | Before | After |
|-----|--------|-------|
| pooled 200 bouts | 0/200 (0.0%) `[0.000, 0.019]` | 0/200 (0.0%) `[0.000, 0.019]` |

## Tests
- Parse gate: `FightMoves.gd`, `FightRealtime.gd`, `u189_kb_leg_census.gd` — pass.
- `fight_kb_corner_stoppage_test.gd`: **4/4** (direct run).
- Subset `run_tests.py --jobs 2 --only fight_realtime,fight_kb,fight_footwork,judge_panel`: **6 fails** on this checkout (missing `unbreakable_noise_menu.mp3` import + pre-existing env); control on master engine files same **6 fails**; `fight_kb_corner_stoppage` passes on U189 engine when run directly.

## Command
`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tools/u189_kb_leg_census.gd`
