# U169 digest — weigh-in honesty and gym-mate booking (Cursor, 2026-09-24)

## Weight read / plans
- `get_weight_read()` now calls `_ensure_weight()` and projects each diet plan with the bout’s **family** (not hardcoded MMA allowance inside `WeightCut.projection`).
- `book_fight()` uses `_offer_weight_family(offer, athlete)` so contract reads match the ruleset/class on the offer, not a generic discipline default.

## Missed weight
- **Fine:** `miss.fine_fraction` = 0.2 (20% of show purse), sourced in `weight_classes.json` from **Q20_THE_SCALE_AND_THE_MAN.md** (UFC/MMA customary forfeit to opponent).
- **Allowance:** `catchweight_max_fraction` = 0.03 of limit — larger miss sets `bout_off` in `WeightCut.weigh_in()`; cancellation pushes a **news** headline via `_cancel_booking_for_weight()`.
- **Payee:** `_apply_fight_result()` credits `weight_fine` to the world opponent’s `cash` when `opponent_athlete_id` is set (R43 still deducts from the misser’s purse first).

## Gym-mates
- `get_organization_fighters()` skips the player roster.
- `book_fight()` / `_booking_offer_fits()` refuse roster IDs and `_athletes_share_gym()` pairings.
- Tier board name-collision redraw (S65) unchanged beside these filters.

## Tests
- New `tests/weigh_in_and_gym_mates_test.gd`: far-above-class `makes_it` false; Q20 fine + bout-off; 300 tier offers × 50 weeks + org pools; opponent wallet on settlement.
- **Mutants (reverted):** (1) `projection(..., "mma")` hardcode restored → flyweight boxing read wrong; (2) removed roster skip in `get_organization_fighters` → org listed gym-mate; (3) dropped opponent `cash` credit → fine vanished for rival.
- `weight_cut_test.gd`: still **2 fails** on master (small-miss catchweight + big-miss cancel fixtures) — not introduced here; unchanged count.

## Gates
- `run_tests.py --only weigh_in_and_gym_mates` → total=1 fails=0
- `--only weight` → total=5 fails=1 (`weight_cut_test` only)
- `--only offer` / `booking` / `career_loop` → fails=0
