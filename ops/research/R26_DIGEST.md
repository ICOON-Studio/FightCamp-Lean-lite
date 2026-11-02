# R26 DIGEST — OFFICE + STAFF (Claude)

The sixth and largest legacy replacement, on Kalli's K12 study. `OfficeHub.gd`
(5764 lines) and `OfficeHub.tscn` are DELETED, not migrated.

## What shipped

**`OfficeHubPanel.gd`** — ONE rail item OFFICE, tabs THE DESK / THE BOOKS.
- **THE DESK** is money and only money: cash, both payrolls, upkeep, the
  one-week run rate, the purse on the books, and **THE BILL**. Its one gold
  is OPEN THE BOOKS.
- **THE BOOKS** is what is committed: a row per contract (athlete and staff,
  four filters, five sortable columns, the expiring flag), then the weekly
  objectives with **gold spent once** — the first claimable row carries it,
  later ones wear the gym colour.
- **The placement call** — WEIGHT CLASS as an action off a fighter (K12),
  drawn in the side of that fighter's own term, never a destination, with
  GameState's refusal printed in its own words.

**`StaffHubPanel.gd`** — STAFF keeps its OWN rail item (K12 pick 1: people-work
is not paperwork). Coach list with capacity, wages, teach/tactics/youth,
**rapport visible for the first time in the game** (fighter × coach, C9's
score and CoachRapport's own band), and **click-arm-click** assignment through
C10's `assign_coach` / `clear_coach` — the same control gives and takes back,
and the capacity refusal is C10's own sentence.

**`MatchSimulatorPanel.gd`** — the one module worth keeping, as a DEV route:
no rail item, no kit family owed, and it still serves
`FightNightScreen.gd:599`'s `back_or("fight_test")`.

Reads are C9's four projections (`83be40e`); writes are C10's (`a690b3c`) plus
`claim_objective`, `start_weight_move`, `cancel_weight_move`. Nothing invented.

## Two judgement calls the task file did not cover

1. **The bill is monthly, not weekly.** C9's `cash_next_week` is the weekly
   accrual, but `_settle_billing` only charges the account when the calendar
   month turns. A ledger printing "cash after the next settle" would have been
   a comfortable lie, so THE DESK names **THE BILL**, when it is due, and
   whether the gym can cover it. C9's `billing` block carries the real figures.
2. **Sponsorship came across with the money.** Its only surface was the retired
   `finances` module. Rather than let a shipped feature lose its screen, THE
   DESK carries THE PARTNER: who pays, the condition status, and the standing
   offer with an ACCEPT in the gym colour (the desk's gold is already spent).

## The eight routes, as ruled

`contracts` / `objectives` / `weight_class` → THE BOOKS. `finances` → THE DESK.
`today` → THE DAY. `fight_test` → the dev panel. **`phone` and `live_fight` are
deleted from the router**, with `LEGACY_ARG_FLAGS["module"]` and DevJump's
`live_fight` need removed with them.

## Kit

Family **"office"**: 6 factories (`desk_ledger`, `contract_term_row`,
`objective_claim`, `rapport_pair`, `assign_arm`, `weight_move_action`),
19 variants. Reused `filter_strip`, `sort_header`, `capacity_meter`,
`alert_strip`, `pair`, `chip`, `gauge_bar`, `illegal_refusal`,
`affordability_reason`, `scout_grade`. **No drag primitive.** Book: 200
variants across 17 families.

## The sweep

**Deleted with the screen** — 7 tests whose whole subject was the desk
(`contract_dossier`, `scouting_hotspot_fix`, `ia_v2_navigation`,
`ia_v2_polish`, `shared_header_rollout`, and the two OfficeHub live-fight
presentation tests) and 5 capture tools that existed only to shoot retired
modules.

**Moved, keeping every GameState assertion** — `objectives_board`,
`weight_move`, `sponsorship`, `live_refresh` onto the OFFICE panel;
`news_morale_sanctioning` onto THE DAY; `header_real_date` and
`header_continue_sequence` onto CareerRoot's real ShellChrome;
`office_nav_and_profile_overlay` keeps its z-index test and drops the two desk
tests; `booking_eligibility_visibility` drops the desk's fame banner (the same
claim is already made against the live cards board in the same file);
`scene_router` now asserts the `tab` contract and that the retired flag is no
longer written; `world_management_ui` resolves the office route to CareerRoot.
5 capture tools repointed at the panels or the ring.

**A real gain:** `RingNightView.presentation()` is new. The Stage 4A/4B counts
(sprites, three vitals per fighter, six body regions per side, the clock, the
three speed controls) were published by the retired desk even though every one
of them is a property of the ring. They are the ring's own contract now, and
smoke reads them from there.

**A real loss, stated plainly:** the two deleted presentation tests also
asserted things only OfficeHub's older live-fight module had — arsenal cards,
boxing broadcast headlines, "BOXING READ" corner advice. R20 had already
superseded that module with `FightNight.tscn`; building equivalents in
RingNightView would be inventing UI with no study behind it, so those claims
are gone rather than faked. `ring_night_view_test` and
`ring_night_command_bar_test` cover the live ring.

## Evidence

Parse gate clean on every touched `.gd`. `office_hub_panel_test` 61/61,
`staff_hub_panel_test` 29/29, `scene_router_test` 174/174, smoke green,
full suite green. Pictures: `DesignLibrary/screens/office_hub/`.
