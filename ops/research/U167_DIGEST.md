# U167 digest — the schedule tells the truth (Cursor, 2026-09-24)

## Decision (U4 D2)
Amateurs still do not see `FIGHT_TIERS` ghosts; `get_fight_offers()` is unchanged. Both screens count **bookable amateur opponents** via `GameState.get_visible_offer_count()` (deduped `get_amateur_bouts` opponents). Pro tier rows stay in data; the smaller screen says **`N PRO HIDDEN WHILE AMATEUR`** on PROFILE eyebrow and SCHEDULE caption.

## Fixed
1. **One count** — `get_visible_offer_count()`; PROFILE NextBout + camp caption; SCHEDULE OFFERS header uses the first amateur roster member’s lens (Cyprus walk boxer matches profile).
2. **Gap list** — `ScheduleHubPanel._amateur_gap_words()`: no `NOT KNOWN` / `SEX`; `held_until_week` → `OPPONENT TBC`.
3. **Boxer source** — `_amateur_source_organizations()` + Cyprus **`amateur_open|…|boxing`** open circuit when no home federation runs boxing (not CMMAF MMA cards).
4. **Weight flag / CUT** — `get_fighter_flags()` only emits `weight` when `get_weight_status().booked`.

## Tests
- `schedule_truth_test.gd` — 0 failures; mutants: (a) revert `get_visible_offer_count` → profile/schedule mismatch; (b) restore `NOT KNOWN` row → test fails; (c) drop `booked` gate on weight flag → test fails.
- Focused: `schedule` 7/0, `profile` 3/0, `career_loop` 1/0, `weight` 5/1 (`weight_cut_test` two weigh-in lines — same red as S65, not introduced here).

## Walk
`research/_captures/u167_walk/03_cyprus.png` (creation, Cyprus picked), `04_deadend.png` (plan stopped before city — offer truth proven in test).

## Mail body (one line)
U167: one offer count via get_visible_offer_count + PRO HIDDEN line; amateur gaps player-worded; Cyprus boxer open-circuit boxing source; weight flag only when booked; schedule_truth_test 0 + tier schedule/profile/career_loop ok, weight 5/1 pre-existing.
