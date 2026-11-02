# G153 digest — the fight gate

Operator 2026-10-01: the engine has to gate everything that needs to be gated to fight. The rules already existed. They lived in different functions and did not give the same answer at offer, booking, fight week, the scale, and fight night.

`FightGate.check(athlete, opponent, offer, stage, ctx)` is that checklist. It returns `{"ok": bool, "reasons": [{"rule": id, "text": UPPERCASE}]}`. It is a static `RefCounted` script: no `class_name`, no autoload identifier. GameState builds `ctx` from the checks that already existed (`_sanctioning_eligibility`, `get_athlete_competition_clearance`, `Sanctioning.medical_hold_refuses_booking`, `get_ruleset`, `CompetitionData.get_researched_ruleset`) and passes them in. FightGate does not call `migrate_athlete`.

A row that does not bind at the stage is silent. Eligibility status `unknown` and `invalid_ruleset` do not refuse. That is `evaluate_athlete_eligibility`'s own contract.

## Call sites edited

All of these are in `Godot/scripts/GameState.gd`. No screen file changed. The refusal strings `book_fight`, `open_fight_contract`, and `enforce_pre_fight_medicals` already show are still those functions' own returns.

| Site | Lines | What the call does |
| --- | --- | --- |
| `const FightGate` preload | 19 | Next to `FightPlans`. |
| `get_world_bout_contract` open slot | 946–967 | Fight-night room entry (`FightNightScreen._open_live` reads this). The gate runs on the booked fighter before `enforce_pre_fight_medicals`. The player snapshot is withheld only when the gate fails and the bout is due (`due_week < week`, or same week and `due_day <= today`). Weeks out, camp still gets the opponent. A world-vs-world bout is unchanged. |
| `_weigh_in_now` | 2223–2238 | One call after the scale record is written. The bout is cancelled only when `bout_off` or the gate names `missed_weight`, and the reason string is the one the scale already used (`"%s - %s"`). A catchweight (`made` false, `bout_off` false, `catchweight` true) is not that row. The record itself does not gain a `fight_gate` key. |
| `book_fight` | 13403–13416 | After open-slot class repair, before the entry fee. Early returns above this line are untouched, so a screen that already quoted them still quotes them. A refusal here does not charge the fee and does not set `booked_fight`. |
| `_consult_fight_gate` | 16457–16527 | Builds `ctx` and calls the checklist. Offer grading passes the board's week so a strike line does not drift. Sanctioning runs on an offer only when the athlete has `age` (a booking-board row has none; age 0 against a professional minimum of 18 would lock every unaged grade). Clearance runs at book, weigh-in, and fight night only. |
| `_booking_blocked_reason` | 16530–16541 | Thin wrapper. Returns the first reason text, or `""`. |
| `get_fight_week_card` | 17463–17468 | One call on the career duplicate, before `career = live`. The card gains `fight_gate` and is not blanked. |

## Census — rule × stage

`offer` and `book` are the only stages for the seven strings the booking board already showed. `book_fight` keeps its own wording for the same facts (a hyphen in the weight-move line, "ALREADY BOOKED THIS WEEK", "NOT ENOUGH FAME FOR THIS TIER…", "MEDICAL HOLD BINDS THIS CARD…", "SANCTIONING — %s (%s)"). The checklist's text is the board's text. The first matching board row is still the one the screen shows.

| Rule id | Where it was checked | Where it binds now | What a failure does |
| --- | --- | --- | --- |
| `already_booked` | `_booking_blocked_reason` (board). `book_fight` 13276, different string. | offer, book | Board: "ALREADY HAS A BOUT BOOKED". Booking still returns the old string before the gate. Silent in fight week: a booked fighter is supposed to be booked. |
| `weight_move` | Board. `book_fight` just after 13276, hyphen string with the destination class. | offer, book | Board string unchanged. |
| `strike` | Board, via `_is_striking` (8916 area: `strike_until_week > career_week`). `book_fight` 13341, em-dash string. | offer, book | Board string unchanged. |
| `offer_taken` | Board only ("OFFER ALREADY TAKEN BY %s"). `book_fight` says "OFFER ALREADY TAKEN THIS WEEK" and returns before the gate. | offer, book | Own id so the wrapper stays one call. |
| `contract` | Board: walked-away, then exclusive promo. `book_fight` 13346 exclusive string differs and stays. `open_fight_contract` 13513 has its own walked-away sentence and was not made a call site. | offer, book | Walked-away is now also a booking refusal if the early returns did not already stop it. Exclusive text on the board is unchanged. |
| `fame` | Board, tier fallback `get_fight_tier_fame_requirement`. `book_fight` 13389 uses `offer.fame_required` default 0 and a different sentence. | offer, book | Offer uses the tier fallback. Book uses the offer's own number, matching `book_fight`. |
| `same_sex` | `book_fight` 13375 when the opponent record exists. `open_fight_contract` 13527. Calendar scan 16917 writes the same sentence for a card that does not fit the roster; that scan is not a call site. | all five | Opponent sex comes from the opponent record, else `offer.opponent_sex`. Empty on both sides does not invent a sex. |
| `weight_class` | `get_booking_class_check` inside `book_fight`. Superfight and a cross-sex event slot step aside (the sex row speaks). | all five | Empty class on either side passes. After an open-slot repair the gate re-reads the refreshed opponent. |
| `injured` | Clearance text at 4979: "INJURED — CANNOT BE BOOKED" when competition clearance sees `status == "injured"`. Not a booking-board row. | all five | Status `injured` only. Region damage and fatigue are the licence row. |
| `medical_suspension` | `book_fight` 13314, only when `Sanctioning.medical_hold_refuses_booking` (sourced ABC-to-ABC, both sides known — R72). Fight night: `enforce_pre_fight_medicals` 14380 voids the deal with its own sentence. | book, weigh-in, fight night | Book only when that sourced refusal is already true; the screen string stays the early return. Weigh-in and fight night refuse when clearance says `hold_applies`, or when clearance was not passed and `medical_hold_until_week` is still ahead. An unknown hold still signs contingent and still binds on the night. |
| `licence` | `enforce_pre_fight_medicals` via `get_athlete_competition_clearance` / `BodyReadiness.evaluate_competition_clearance`. The cancellation sentence stays there. | weigh-in, fight night | A clearance that is not clear for a reason other than `athlete_injured`, `medical_hold_active`, or `athlete_not_found`. Not a signature block. |
| `age` | `_sanctioning_eligibility` 7293 → `CompetitionData.evaluate_athlete_eligibility` on `{"age": n}` and the discipline's professional researched ruleset. `book_fight` 13382 folds every ineligible criterion into one "SANCTIONING — …" sentence. | all five | Own id when the age criterion is `ineligible`. The booking screen sentence is still the early return. |
| `sanction` | Same function. Any other `ineligible` criterion (a competition weight class the ruleset does not list). Rank stays `unknown` in the catalog and does not refuse. | all five | "SANCTIONING — %s". Status `unknown` does not refuse. |
| `missed_weight` | `_weigh_in_now` cancelled on `bout_off`. Chip 17725 is display only ("MISSED WEIGHT") and still is, including a catchweight. | weigh-in, fight night | "MISSED WEIGHT — BOUT OFF" when the miss is not the contracted catchweight. Catchweight does not cancel. |
| `ruleset_legal` | Not a gate. `selected_ruleset_id` defaulted to `boxing`. | all five | Illegal when the id is in neither `combat_rulesets` nor the researched catalog, or a researched row names a different discipline. An empty id is legal (the caller fills the gym's selected ruleset first). A playable id is enough; a boxing gym on an MMA card does not false-fail. |

Not folded in, on purpose: `book_spar` / `check_spar` (5703 / 5677) is a gym-day spar, not a bout. National-team selection and "turned pro" stay early returns in `book_fight`. Teammates, same gym, entry fee, and the fight-plan id stay there too. The fight-week card is not blanked when the gate fails, so a camp screen can still explain the bout.

## Tests

`Godot/tests/fight_gate_test.gd`. One refusal per rule id above, naming that id. One legal pair passes all five stages. A catchweight does not raise `missed_weight`. The booking wrapper's seven screen strings are asserted byte for byte, including the em dash. The real `book_fight` path sets `selected_ruleset_id` to a ghost id on an otherwise legal tier offer and asserts the booking is not ok, `booked_fight` stays empty, and `fight_gate` names `ruleset_legal`. The two fighters in a fixture differ in name, stats, height, reach, and weight.

Parse: `python Godot/tools/check_scripts.py` on `FightGate.gd`, `GameState.gd`, and the test — fails=0. The test itself reported `failures=0`.

## Prior research actually read

`python Tools/prior_research.py eligibility suspension medical licence weigh-in sanction age ruleset` (15 files). Opened:

- `research/topics/rules_orgs.md` — settled list. Rulesets live in `COMPETITION_RULESET_RESEARCH.md` and `J1`. The page does not itself state a weigh-in or licence procedure.
- `research/topics/body_damage.md` — title and section markers only. No suspension table on the page.
- `research/topics/tooling_process.md` and `knockdowns_stoppage.md` were named by the tool as canonical pages. They were not opened past that index; stoppage policy is not this gate.
- `J1_ORGANIZATION_RULES_AND_JUDGES.md` — UNKNOWN policy; `competition_rulesets_v2.json` was marked PROPOSAL and not runtime-wired when J1 was written. `CompetitionData.gd` loads that file now (`_init` → `_load_and_validate`). J1 does not publish a booking checklist.
- `COMPETITION_RULESET_RESEARCH.md` — professional boxing medical block is DIRECT: TKO-by-head-blows minimum 30 days, KO minimum 60 days, 7-day rest after every bout, and a negative pregnancy test within 14 days for women.
- `J7_THE_SCALE_AND_THE_BELT.md` — `catchweight_max_fraction` 0.03 and the 0.2 purse fine are invented. Nevada's published miss is 25% of the purse inside 1 lb, with an hour to make weight (`NAC 467.522`). Day-before is the house default (J3 D10); amateur club shows weigh in on fight day (G96).
- `G96_AMATEUR_BOOKING.md` — licence and a pre-bout medical are named as how a club bout is made. They are not a machine checklist.
- `C51_DIGEST.md` — the only sourced reciprocity pair in the game is ABC-member commission to ABC-member commission. C51 says it does not invent suspension lengths. R72 (`Sanctioning.gd` 92–114) later narrowed the signature: an unknown hold does not refuse booking, and it still binds on fight night.
- `CompetitionAge.gd` — calendar-year / first-event-day / mixed clocks for IJF, EJU, IBA, UWW, WT, WKF, IMMAF. The sanctioning call does not use them. It passes `athlete.age` into the professional researched ruleset.
- `J53_HANDBOOK_REAL_TERMS.md` §1.12 — a commission regulates the match; a sanctioning organization sanctions it. The prior-research hit flagged the handbook glossary for fusing those. The section that was opened here keeps them apart. Not re-litigated.

`J3`, `U4`, `J2`, `C55`, `C52`, `J4`, `J11`, `J52`, `K77`, and `J5` were ranked by the tool and not opened beyond the ranked lines.

## Rules for D67 to source

These are the rows the checklist had to take from the save or from a user ruling, because no primary packet in the files above states the number the game uses.

1. Suspension length. The catalog records ABC boxing's 30-day TKO and 60-day KO minimums and a 7-day rest (`COMPETITION_RULESET_RESEARCH.md`, professional boxing). The save stores `medical_hold_until_week`. C51 explicitly does not invent lengths. Nothing converts those day tables into the week counter the gate reads.
2. Reciprocity beyond ABC-member commission to ABC-member commission. C51. `house_plus_officials` and `national_sport_authority` do not reciprocate. Whether any other real pair does is unsourced.
3. Licence documents. Pregnancy test ≤14 days (female professional boxing), Federal ID (Ali Act, on `boxing_abc_professional_male`), and the blood-certificate lines on amateur MMA rulesets are prose. The licence row is region readiness plus fatigue above `competition_fatigue_max` (85 in `BodyReadiness`). Those thresholds are game numbers.
4. Catchweight versus bout-off. `weight_classes.json` `catchweight_max_fraction` 0.03 is invented (J7 P11). ONE's published figure is 105% of the opponent's hydrated weight; World Athletics-style 5% is a different sport's page in that same note. Nevada's miss fine is 25%, not the game's 0.2. Do not retune the 3% here.
5. Weigh-in day. House default is the day before (J7 P12, J3 D10). G96: England Boxing and USA Boxing club shows weigh in on fight day, with a small published allowance (300/500/700 g), not a 3% catchweight. The gate does not pick the day. `_weigh_in_slot` does.
6. Age clock. `CompetitionAge.gd` has per-body birthday rules and returns -1 for an unknown clock. `_sanctioning_eligibility` ignores that and uses the fighter's stored age against one professional ruleset (sex suffix when the catalog has one). Amateur and youth minimums in the researched file (World Boxing `age_min` 13 with class notes) are never the ruleset that call selects.
7. Rank. `evaluate_athlete_eligibility` returns `unknown` for rank ordering, not `ineligible`. No machine-readable order was found to source.
8. Same-sex divisions, exclusive promotional contract, strike until a week, fame tiers, and "offer already taken" are user rulings (2026-09-01 and 2026-09-03), not commission regulations. They stay game rules until a packet says otherwise.
9. Amateur debut gates named in G96 (bout-count bands, experience mismatch, annual medical before a club show) are not rows. `book_spar` is a separate gym-day check and was not pulled into this list.
