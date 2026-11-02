# G154 — The offer desk

Every career offer the graded board never listed is now a card on the OFFERS tab of `ScheduleHubPanel`. Deciding is one click. The status line says what changed. No offer rule moved.

`GameState.gd` is untouched. Retention stays on this desk: the desk can host a renewal and a poach beside the fight rows, so nothing was added to the fighter card. `UIKit.gd` is untouched. `OfficeHubPanel` still accepts a sponsorship; the same accept is now also a desk button. No decline was invented where the engine has none (signing, contender invite, sponsorship).

## Census

| Kind | Getter / action | Was reachable? | Now |
| --- | --- | --- | --- |
| Short notice | `get_short_notice_offers`, `accept_short_notice`, `pass_short_notice` | No shipped script called them | OFFERS desk, section SHORT NOTICE. Buttons PASS and ACCEPT. PASS sets `passed` and the desk hides that row; the offer stays in the getter. ACCEPT calls `book_fight` through the existing action. |
| Promotion bout | `get_promotion_bouts`, `accept_promotion_bout`, `decline_promotion_bout` | No | Section PROMOTION BOUTS. Buttons DECLINE and ACCEPT. Decline uses the existing standing cost (test: 70 → 55). |
| Signing | `get_signing_offers().offers`, `accept_signing_offer` | No | Section SIGNING. Button ACCEPT only. |
| Contender invite | `get_signing_offers().invites`, `accept_contender_series_invite` | No | Section CONTENDER SERIES. Button ACCEPT only. Accept books `dwcs\|…`. The card stays while the getter still returns the invite, which it does until the bout is judged. The desk does not hide a booked invite. |
| Retention, renewal | `get_retention_offers`, `accept_renewal`, `decline_retention_offer` | No | Section RETENTION, on the desk, not on the fighter card. Buttons ACCEPT and DECLINE. |
| Retention, poach | `get_retention_offers`, `match_poach_offer`, `decline_retention_offer` | No | Same RETENTION section. Buttons MATCH and DECLINE. |
| Sponsorship | `get_sponsorship_offers`, `accept_sponsorship_offer` | Accept already lived on `OfficeHubPanel` (~1555). The offer was not a desk decision. | Section SPONSORSHIP. Button ACCEPT only. The office hub still accepts. |
| Fight-card win % | `estimate_win_chance` | Never called | A target icon and a percent on every fight card: amateur rows, pro booking rows, short notice, promotion bouts, and the contender invite. 0 from the getter draws "—". A real chance floors at 8%. |

## What a card shows

Text carries the name, the record (`W-L-D`), the section kind, the deal condition, and the goal. Purse, fame, ranking gap, win %, deadline, risk, and stance are an icon plus a value, each with a framed tooltip (`UIKit.icon_plate` / `UIKit.tip`):

| Meaning | Icon |
| --- | --- |
| Purse | `dollar-sign` (omitted when purse and win bonus are both 0, so an amateur row never shows $0) |
| Fame | `star` |
| Ranking gap | `podium` (`—` when either fighter is unranked; a signed gap otherwise) |
| Win % | `target` |
| Deadline | `clock` (glow when a short-notice slot is a week out or closer) |
| Risk | `triangle-alert` |
| Stance | `swords`, reading OPEN or CLOSED from `FightStance.matchup` |

Short notice uses a red border. Signing and contender use a gold border. A poach uses a red border. The amateur grade chip is unchanged and still does not invent a win %. The header still contains `N OFFERS ON THE DESK` (the visible fight-offer count). When decisions are waiting it also appends `N TO ANSWER`. `EmptyOffers` still mounts when the fight rows are empty.

Godot 4.7 renames a second sibling that reuses a name to `@Panel@N`. `_keep_card_name` (1244–1250) wraps each decision card and each section header in its own host so the inner node keeps `ShortNoticeCard`, `SigningCard`, `ContenderCard`, `PromoBoutCard`, `RetentionCard`, `SponsorCard`, and `OfferSection`. The host keeps the default mouse filter so a click and an icon tooltip reach the children.

## Edited ranges in `Godot/scripts/ScheduleHubPanel.gd`

| Lines | What |
| --- | --- |
| 45–47 | Preload `FightStance` and `WorldPopulation`. |
| 124–133 | Desk arrays, `_rank_cache`, `_win_cache`, `status_good`. |
| 181 | `select_tab` clears `status_good` with the status line. |
| 210–217 | `rebuild` clears the six arrays and both caches. `_win_cache` is declared at 132 and cleared at 217. |
| 232–233 | Offers tab calls `_load_offer_desk`. |
| 291 | Status colour is `T.GOOD` when `status_good`, else `T.BAD`. `rebuild` does not clear `status_good`. |
| 391–393 | Header appends `%d TO ANSWER` after the existing offer-count caption. |
| 1100–1140 | `_build_offers`: empty state on the root only when fight rows and decisions are all empty; decision sections first; `EmptyOffers` inside the column when the fight rows are empty; each amateur row and each pro `booking_offer_row` wrapped with the matchup strip. |
| 1145–1173 | `_load_offer_desk`. Passed short-notice rows are skipped. Invites are not filtered by an existing booking. |
| 1175–1189 | `_pending_decisions`, `_set_status`, `_career_week`. |
| 1191–1250 | `_build_decision_sections`, `_offer_section`, `_keep_card_name`. |
| 1253–1314 | `_offer_shell`, `_offer_button`, `_place_metric`. |
| 1316–1505 | Records, matchup line, stance, fame, `_win_read` (cached), division board, rank gap, `_place_fight_metrics`. |
| 1507–1703 | `_wrap_fight_card`, then one builder per kind: short notice 1541, signing 1594, contender 1610, promo 1638, retention 1655, sponsor 1688. |
| 1705–1851 | Handlers. Each calls the existing GameState action and rebuilds. |
| 2007, 2013 | Amateur enter refusals set `status_good` false. |
| 2114 | Open-agreement with no fighter sets `status_good` false. |
| 2941, 2946 | Grand Prix seat taken is good; a refusal is not. |
| 3102, 3113 | Book with no fighter, and a missing agreement scene, set `status_good` false. |

`_amateur_row` resumes at 1858 and was not rewritten. `offer_count_for_test` (3295) and `_offers_header_caption_text` (3288) were not edited; the offer-count substring they already produced is still the header contract.

## Proof

Parse gate on the three touched scripts: `CHECK total=3 fails=0`.

`offer_desk_test.gd` (headless): `failures=0`. The three starters differ by id, name, and discipline. Amateur cards show a win % and a matchup line, keep the grade chip, and draw no purse icon. The header read `4 OFFERS ON THE DESK · 6 EVEN MATCHES · WEEK 1 · 1 TO ANSWER`. The amateur bar says ENTER and does not open an agreement. PASS removes the urgent short-notice card and leaves the offer in the getter; ACCEPT booked `event|event_cyprus_002` (`BOOKED SAMI STERLING ON SHORT NOTICE`). Sponsorship `sponsor|cyprus_mmaf|0` signs and leaves the desk. Signing recorded `SIGNED SAMI BIANCHI TO TEST REGIONAL`. One promo decline moved standing 70 → 55; ACCEPT booked `promo|test_reg|athlete_001|ath_philippines_manila_02_04|1`. The contender accept booked `dwcs|test_ufc|athlete_002|1` and the card stayed because the invite was still returned. Both retention cards (`athlete_001`, `athlete_002`) were found; MATCH and ACCEPT closed the right offers; declining a later renewal sent that fighter out. No label or button contained `NOT KNOWN` or `SEX`.

Watchdog `2026-10-01 20:42:50` GREEN, then `run_tests.py --jobs 2 --only offer,schedule_hub,booking,short_notice,promotion,signing,contender,retention,gf1`: `SUITE total=18 fails=0`.

Windowed stills (`Tools/godot_hidden.ps1`, script `tools/g154_offer_desk_stills.gd`), opened after capture:

| File | In frame |
| --- | --- |
| `previews/g154/short_notice.png` | SHORT NOTICE, red card, win %, PASS and ACCEPT |
| `previews/g154/contender.png` | CONTENDER SERIES, records, goal, gold ACCEPT |
| `previews/g154/signing.png` | SIGNING, tier and contract line, gold ACCEPT |
| `previews/g154/promo_bout.png` | PROMOTION BOUTS, three cards, DECLINE and ACCEPT |
| `previews/g154/retention.png` | RETENTION renewal (ACCEPT, DECLINE) and poach (MATCH, DECLINE) |
| `previews/g154/sponsor.png` | SPONSORSHIP, condition, weekly cash, deadline, ACCEPT only |
| `previews/g154/fight_matchup.png` | Amateur rows with records, win %, gap, fame, weeks, stance; no purse icon |

This is a Godot desktop panel. It was verified by the scene-tree test, the 18-test suite, and those stills. It was not verified in a browser.

## S138 (Claude) - merged as a diff
Stills opened on master. Two defects fixed before merge: retention put ACCEPT/MATCH on the LEFT (every other desk card
has the yes on the right) - swapped; the fight cards' matchup line was a fixed 400 px and cut mid-word ("CLOSED STANCI")
- the metrics now sit at the strip's right and the sentence takes the rest. Suite offer,schedule_hub,booking,
short_notice,promotion,signing,contender,retention 15/0 on master.
