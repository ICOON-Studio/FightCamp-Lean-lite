# TASK OFFICEDEALS1 - the office's DEALS tab: loans, the staff pay tier, this week's side-income offers

Model: Cursor (cloud). Discipline: BOXING (demo) - GYMBUILD economy (the start's money).
Operator board Q-S277-3 (S282): "Yes, build the verdict." - Ludo S281 economy numbers (research/LUDO_S281_ECONOMY_NUMBERS.md).
The state side is LIVE on master since S282 (STARTECON2 73e2a6d5 + ECONBAL1 wiring): everything below already works in the save -
the player just cannot see or press any of it. This task is ONLY the screen.

## Route today (traced by Claude S282)
- OFFICE in the top bar -> CareerRoot route `office_menu` -> `Godot/scripts/OfficeHubPanel.gd` (1,865 lines - read in `sed -n`
  windows; never whole). Tabs: `TABS` L69 / `TAB_LABELS` L70, `_tabs()` L150, `rebuild()` L190, tab bodies `_build_desk()` L336 etc.
- GameState (never read whole; 21k+ lines) already exposes - call these, do not re-implement:
  - `loan_offers() -> Array` rows {id, ok, why, principal, weekly, weeks, ...}; `take_loan(id) -> {ok, why}`; `loans_view() -> Array`
    rows {id, owed_left, weeks_left | fights_left}.
  - `staff_pay_tier() -> String`, `set_staff_pay_tier(id) -> {ok, why}`; tier rows in `StartEconomyRules.pay_tiers()`
    (Godot/scripts/rules/StartEconomyRules.gd L108: id, label, value = wage change); what each tier DOES in
    `EconomyBalance.WAGE_TIER_DATA` (Godot/scripts/rules/EconomyBalance.gd ~L80: morale_drift_weekly, coaching_gain_mult,
    quit_morale_threshold).
  - `income_offers() -> Array` rows {id, label, pay, day, cost, fatigue, expires_day}; `accept_income_offer(index) -> {ok, why, pay}`;
    `decline_income_offer(index) -> {ok, why}`. A new week rolls fresh offers (`advance_week`).
  - Staff morale: `get_staff()` members carry a float `morale` (0-100) once a week has passed.
- All of it is empty / "market" / refused when `GameSwitches.on("start_economy")` is off or the career has no `club_rooms_built`.

## Do
1. RED TEST FIRST (below): on master the office has no "deals" tab -> fails.
2. NEW FILE `Godot/scripts/OfficeDealsTab.gd` (static `build(parent: Control, game_state: Node, rebuild: Callable) -> void`) - keep
   OfficeHubPanel from growing: OfficeHubPanel only adds `"deals"` / `"DEALS"` to TABS / TAB_LABELS (shown only while
   `game_state.loan_offers` exists and `GameSwitches.on("start_economy")`) and calls `OfficeDealsTab.build(...)` for that tab.
3. Three cards, same kit/style as THE DESK cards (copy their Panel/Label helpers' look; Label sizing per GDSCRIPT_TRAPS.md):
   - THIS WEEK'S OFFERS: one row per offer - label, day, cost line, "+$pay"; TAKE and PASS buttons -> accept/decline, then `rebuild`.
     Empty list = "No offers this week".
   - STAFF PAY: four buttons (Underpaid / Market / Competitive / Elite) with the wage change (-15% / 0 / +10% / +25%) and ONE short line
     from WAGE_TIER_DATA per tier: "Morale -4/wk, coaching x0.90, quits under 20" etc. - numbers read from the data, never typed. The
     current tier is highlighted; pressing one calls `set_staff_pay_tier`. Under it, each staff member: name + morale bar (animated tween,
     feedback "animated meters": every bar tweens).
   - LOANS: `loans_view()` rows (what is owed, weeks or fights left), then `loan_offers()` rows with TAKE (disabled with the `why` text
     when `ok` is false).
4. Icons + short labels only - no flavour text (operator S268 "weird panels everywhere": icons + modals, no flavour text). Nothing opens by
   itself.
5. New features ship ON (CLAUDE.md s10): no new switch is needed - the tab follows `start_economy`, already in GAME_ON.

## Test - Godot/tests/office_deals_tab_test.gd (extends SceneTree; last line `OFFICE_DEALS failures=<n>`)
Seed like Godot/tests/econ_balance_live_test.gd `_setup` (finalize a career, `club_rooms_built` with a reception desk, starter roster +
staff), run with `-- as_game`. Build OfficeHubPanel, `select_tab("deals")`. Checks: the tab exists; after one `advance_week` the offers
card shows >= 1 row with a TAKE button; pressing TAKE (emit `pressed`) raises gym cash by exactly that offer's pay and the row is gone;
pressing "Elite" makes `staff_pay_tier() == "elite"` and the Elite button reads as selected; the four tier lines contain "x0.90",
"x1.00", "x1.08", "x1.15"; the loan card lists "micro" with TAKE disabled when `ok` is false. CONTROL ARM: without `-- as_game` (switch
off) the tab is absent and THE DESK still builds.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md)
1. First on master: the office has no DEALS tab - paste that check's FAIL line.
2. A still of the DEALS tab only via `Godot/tools/clean_view.gd` `save_if_clean` after `CleanView.clear` with `ui=1` (the still is
   ABOUT this UI), 1920x1080, committed under previews/office_deals/.
3. Per still: no text clipped or overlapping, every number readable, buttons aligned, the selected tier obvious.
4. Do not call it accepted. Claude opens the still; Ludo reviews the screen; the operator closes it.

## Contract
OWNS: Godot/scripts/OfficeDealsTab.gd, Godot/scripts/OfficeHubPanel.gd, Godot/tests/office_deals_tab_test.gd
RED_TEST: Godot/tests/office_deals_tab_test.gd -> OFFICE_DEALS failures=0
REGRESSION: office_hub_panel_test, office_hub_api_test, start_economy_live_test, econ_balance_live_test
VISUAL: yes

PR body: `RESULT: tests/office_deals_tab_test.gd -> OFFICE_DEALS failures=0` + each regression's last line + the still path.

## Prior research
LUDO_S281_ECONOMY_NUMBERS.md (tiers, yields, undercard), S281_DIGEST.md (STARTECON2, INCOMEOFFERS1), S279_DIGEST.md (StartEconomyRules),
MGT2_STUDY_S277.md (the start's money), topics/money_business.md, GDSCRIPT_TRAPS.md (Label sizing, Variant :=).

## What would a human do?
Put the gym's deals where the money already lives - one more office tab, three plain cards, every button doing exactly one GameState call.

## Prefab check
Godot built-in Controls in the existing kit style - nothing to download.

## The one trap
Do not grow OfficeHubPanel.gd beyond the tab hook (it is already 1,865 lines): every card lives in OfficeDealsTab.gd.
