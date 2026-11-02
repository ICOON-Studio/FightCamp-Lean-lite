# U170 digest — the market on screen

## Shipped
- **Gym FLOOR tab:** member load band (crowd ratio + team training yield), EVENING WITH MEMBERS / DAYTIME APART buttons via `GameState.set_team_slot` (only on press; unset slot stays unset on paint), one-coach why line when unset.
- **`get_gym_hub()` floor:** crowding reads + `team_slot_set` without persisting a default slot.
- **`GymLedgerRead`:** membership dues `why` names kit types on the floor and TITLE WEEK spike while `title_spike` > 0 (invented labels kept).
- **Weigh-in:** event bookings with a nominal card class now weigh at the fighter's registered division and limit **family** (boxer on an MMA-labelled world bout was scaling at MMA Welter 77.1 kg → spurious make/miss). Fixture pins Welterweight and recomputes limit before cut weights.

## weight_cut root cause
World bout contract carried default **Lightweight** + **mma** discipline while the roster fighter stayed **Welterweight** **boxing**. `_class_limit_for` flipped between 66.7 kg and 70.3/77.1 kg as walk weight changed; the 13% miss case was weighed at the wrong limit/family (e.g. 13.5 kg miss = bout limit 61.2 kg vs weight left at welter-scaled mass). Fix: `_weight_class_for` returns own class when bout class differs; `_weight_family_for` uses the fighter's discipline in that case (and when the contract read is empty).

## Tests
- `market_on_screen_test.gd`: 0 failures
- `weight_cut_test.gd`: 0 failures (was 2)
- Subset `gym_,membership,office,ledger,weight,weigh`: **SUITE total=19 fails=0**

## Walk
- Plan: `research/u170_walk.plan`
- Shots: `research/_captures/previews/u170_walk/09_u170_floor_market_band.png`, `11_u170_team_slot_evening.png`
