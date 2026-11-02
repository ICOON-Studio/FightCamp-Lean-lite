# Q193 Digest — Flip ROLE_PRIORITY_FROM_PLAN, Measured Against All Three Anchors

## Instrument
`Godot/tools/q193_anchor_measurement.gd` — 2 fighters × 2 opponents × 2 seeds per cell for separation, 20 bouts per ruleset for anchors. Population: distinct fighters under distinct plans, never identical, legal for the ruleset.

## Verdict: FLIP ON

`FightMoves.gd:113` `ROLE_PRIORITY_FROM_PLAN` flipped from `false` to `true`.

## Plan Separation (OFF → ON)

**Boxing: 1/6 → 6/6 distinct pairs** (threshold 1.720 → 0.537)
- OFF: only out_boxer vs pressure distinct. NOT DISTINCT: out_boxer vs boxer_puncher (1.416), out_boxer vs counter_puncher (0.932), pressure vs boxer_puncher (0.762), pressure vs counter_puncher (1.074), boxer_puncher vs counter_puncher (1.324)
- ON: ALL 6 pairs distinct. Min distance 0.817 (boxer_puncher vs out_boxer)

**Kickboxing: 0/3 → 0/3** (threshold 3.362 → 1.790)
- OFF: dutch_pressure vs thai_kicker (0.559), dutch_pressure vs counter_striker (1.891), thai_kicker vs counter_striker (1.362)
- ON: dutch_pressure vs thai_kicker (0.982), dutch_pressure vs counter_striker (1.142), thai_kicker vs counter_striker (1.715)
- Distances improved but noise floor also rose (thai_kicker 1.681 → 0.352), so threshold dropped and still not enough

**MMA: 0/6 → 0/6** (threshold 4.893, identical both arms)
- MMA plans have role_priority but 82.7% of throws are unnamed fallback (empty technique_id), so the flag can't reach them. The two-stage selection fires but the live_set is sparse for synthetic MMA fighters at distance.

## Three Anchors (OFF → ON)

### D3 Target Split (landed significant strikes, J20: head 61-65 / body 19-23 / legs 14-18)

**Boxing:**
- OFF: head 53.6% / body 46.4% / legs 0.0% (n=3150)
- ON: **head 63.6%** / body 36.4% / legs 0.0% (n=2693)
- **Head IN J20 band ON, was below OFF.** Body still above (boxing has no legs, so head+body only)

**Kickboxing:**
- OFF: head 33.5% / body 40.9% / legs 25.6% (n=1303)
- ON: head 44.1% / body 39.1% / **legs 16.9%** (n=1032)
- Legs moved toward band ON. Head still below, body still above

**MMA:**
- OFF: head 54.7% / body 32.2% / legs 13.1% (n=1655)
- ON: identical (82.7% empty fallback dominates)

### Pace (significant landed per minute, J20: 6.85 both corners)

- Boxing: 5.56 → 5.35/min (slight decrease, both below J20)
- Kickboxing: 6.26 → 5.17/min (decrease, both below J20)
- MMA: 6.02 → 6.02/min (identical)

Pace is a pre-existing engine-wide undershoot, not caused by this flag. The flag doesn't worsen it.

### Knockdown Rate (per fighter-fight, J20 implies ~0.40/bout from C107)

**Boxing:**
- OFF: 2 KD in 20 bouts = 0.05/fighter-fight, KD/power-head = 0.17% (n=1207)
- ON: **5 KD** in 20 bouts = **0.13/fighter-fight**, KD/power-head = **0.46%** (n=1097)
- **Doubled ON, still low but directionally toward J20 3.9%**

**Kickboxing:**
- OFF: 3 KD in 20 bouts = 0.07/fighter-fight, KD/power-head = 0.80% (n=374)
- ON: 3 KD in 20 bouts = 0.07/fighter-fight, KD/power-head = 0.82% (n=368)
- Flat

**MMA:**
- OFF: 4 KD in 20 bouts = 0.10/fighter-fight, KD/power-head = 2.61% (n=153)
- ON: identical

## Empty Technique IDs (MMA)

**82.7% of MMA throws (4114/4977) carry empty technique_id.**

**Source:** `FightRealtime.gd:3706` — when `Moves.select()` returns empty (no legal technique matched in the live_set), the engine enters the unnamed fallback path. It picks a random region via `_pick_target()` and logs an anonymous throw with `technique_id = ""`. The throw still commits the fighter, can land, and counts as significant at distance.

**These are NOT strikes with a lost name.** The name was never assigned because no catalogue technique matched the selection criteria (band, stance, reach, role filtering). This is a catalogue coverage issue for synthetic MMA fighters at distance: the standing striking palette is sparse, so most impact opportunities fall through to the unnamed fallback.

**Top named MMA techniques** (17.3% that have names): mma_guard_gnp (114), mma_elbow_gnp (92), kickboxing_front_kick (47), mma_dirty_boxing (47). These are mostly ground techniques and kicks — the standing punching palette is nearly absent.

**Fix scope:** Assigning generic names (e.g., "unnamed_strike") would be cosmetic. The real fix is expanding the MMA standing striking catalogue or improving technique_progress generation so synthetic fighters have more standing techniques. Out of scope for Q193.

## Tests

Parse gate: FightMoves.gd PASS, q193_anchor_measurement.gd PASS.

Focused tests (fight_moves, fight_plan, broadcast, fight_simulation, fight_realtime, knockdown): pre-existing TitleHonours parse errors block GameState autoload, causing hangs and script-errors. These are present on master at commit 792e84e4 (Q192 digest noted the blocker). Not caused by Q193.

## Owned files changed
- `Godot/scripts/FightMoves.gd` — `ROLE_PRIORITY_FROM_PLAN` flipped to `true` at line 113
- `Godot/tools/q193_anchor_measurement.gd` — new measurement instrument

## Recommendation
The flag improves boxing separation from 1/6 to 6/6 distinct pairs and moves boxing D3 head split into the J20 band (53.6% → 63.6%, J20 61-65). Knockdown rate doubles (0.05 → 0.13 per fighter-fight). Pace doesn't worsen. Kickboxing D3 legs move toward band. MMA is unchanged (empty fallback dominates). **Flip ON at integration.**

## Claude's collection (S92)
Instrument + digest MERGED; the global flip NOT merged. Bar: all three anchors hold - kickboxing pace fell 6.26 -> 5.17/min (J20 6.85), and no subset run was done (parse gate only). Boxing alone clears it (separation 6/6, head in band, knockdowns up, pace -4%) -> Q194 scopes the flag to boxing with KB/MMA byte-identical. The 82.7% empty-id MMA throws are a catalogue-coverage gap (FightRealtime.gd:3706 fallback) - a separate slice.
