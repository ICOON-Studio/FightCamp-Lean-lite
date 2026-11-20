# LEDGER1 v6 — Critic Review (Arena)

SCORE depth=9 general=9

## Scores & Reasons

- **DEPTH: 9/10**
  Every decision on the contract and ledger screen changes real simulation numbers with no dominant pick. Keeping an amateur on full stipend (`$250/wk`), dropping to half (`$125/wk`, `5/6` mornings, `-4` loyalty), moving to a day job (`$0/wk`, `4/6` mornings, `-8` loyalty), or releasing (`+$0` amateur / `+$500+` pro release fee, `-1/-3` rep, `-2` teammate loyalty) each win in different career states. Same-state `CashForecast.project(c, weeks, change)` with an `8w / 12w` toggle lets the player see the exact cash and runway consequence of each choice before committing. Pro renegotiation (`Top-10`, `Belt`, `Yearly`) and release-fee math create real break-even calculations, and Red alerts surface club-wide levers (dues band, kit budget, evening coach, arranged overdraft) alongside per-boxer actions.

- **GENERAL DESIGN: 9/10**
  The v6 map builds a complete, honest accounting foundation before any UI: extending `Career.pay()` with `fid`, `kind`, and `source` across all 28 `.pay()` sites, splitting weekly club income and 28-day month-end stipends from shared club bills, and enforcing exact `±$0` reconciliation to `career.cash`. Estimates (`accrued_stipend`, `Membership.settle_week()` win-dues replay) and conditional upside (unbooked bouts) are strictly separated from real cash. It also catches and fixes six live code/UI mismatches (`Approach` `Move`/`Promise`/`Let Go` previews, `RivalOfferWire._free()` inversion, `StarDeal` 10% low-loyalty bug, `MoneyPanels._earns`, `FighterPage` hardcoded stipend) and cuts useless controls (`Set review date` snooze, fake `Self-funding` badge, duplicate `Not This Show`).

- **PLAY: 8/10**
  Week-to-week play is grounded in clear stakes: `🔴/🟠/🟡` alerts route directly to real fixes (`Fights > Ask for a fight`, `Club > Money` crisis levers, stipend toggles) without blocking `Needs.blockers()`, and the 1920×1080 Look B layout keeps the boxer's name in the header only while putting the dated ledger, estimates, and side-by-side comparison in one view.

## Missing or Useless Options (and What Each Changes)

- **Useless / Misleading Options (already cut or fixed in v6):**
  - `Set review date` snooze on alerts: useless because the clock already stops every Monday; cutting it keeps alerts tied to real cash/booking resolution.
  - `Not This Show` remaining clickable after seasonal use: useless duplicate of `Pass` with the same `-2` ladder cost; disabling it with `"Already used this season — use Pass instead"` removes a trap.
  - `Self-funding ✅` badge and annualized `$X/year` projection: misleading when built on partial estimates or unbooked bout guesses; cutting them keeps the books honest.
- **Missing Options / Edge Cases:**
  - **Bulk / multi-boxer stipend action on `Club > Money`:** under a Red alert with 3–4 amateurs, the player can compare 2–3 boxers side-by-side, but there is no one-click `"Half all amateurs"` or `"Preview combined change"` in `CashForecast.project(c, weeks, change)` (which currently takes a single `change` dictionary).
  - **Filter toggle on the per-boxer ledger (`All / Bouts / Stipends`):** useful once a pro has 15+ fights so camp/scout/purse rows aren't buried under monthly stipend rows.

## CODE CHECK (Required)

Code files read:
- `scripts/state/Career.gd`
- `scripts/state/Sim.gd`
- `scripts/rules/GameMoney.gd`
- `scripts/rules/Overdraft.gd`
- `scripts/state/GymDeals.gd`
- `scripts/rules/StarDeal.gd`
- `scripts/state/RivalOfferWire.gd`
- `scripts/ui/MoneyPanels.gd`
- `scripts/ui/areas/FighterPage.gd`

Verification results:
- `Career.gd`: `pay(amount, what)` (lines 185–192) writes `{d, t, amount}` with no `fid`, `kind`, or `w`; `ledger` at line 43; `overdraft_on` / `overdraft_drawn_weeks` at lines 81–82. **Verified.**
- `Sim.gd`: `end_week()` (lines 305–338) adds `income["total"]` to `cash` and `week_money["in"]` with no ledger entry, writes one combined `"Month-end bill: wages and upkeep"` row on bill days, and pushes `"Overdraft interest"` directly without calling `pay()`. **Verified.**
- `GameMoney.gd`: `FIGHTER_STIPEND := 250`, `CLASSES_WITH_COACH := 350`, `COACH_SIGNING_FEE := 1000`, `BILL_EVERY_DAYS := 28` (lines 9–12); `athlete_payroll()` at line 24. **Verified.**
- `Overdraft.gd`: `INTEREST_RATE := 0.16`, `WEEKS_PER_YEAR := 52`, `PULL_AFTER_WEEKS := 12`, `limit()` requires `weeks_traded >= 12` and floors to `$100`, `fee()` is `1%`, `weekly_interest()` is `max(1, ceil(-cash * 0.16 / 52))` (lines 8–64). **Verified.**
- `GymDeals.gd`: `year_take()` (lines 75–83) scans `c.ledger` over `StarDeal.YEAR_DAYS` for `"Purse share"` or `"Debut tickets"` and `t.contains(who)`. **Verified.**
- `StarDeal.gd`: `terms()` (lines 41–47) uses `minf(share(f), s["share"])` for `top10`/`belt` and `maxf(FLOOR, share(f) - YEAR_STEP)` for `year`, which produces `0.10 -> 0.12` when `share(f) == 0.10`. **Verified.**
- `RivalOfferWire.gd`: `_free(f)` (lines 99–100) returns `bout.is_empty() and injury.is_empty()` (inverted). **Verified.**
- `MoneyPanels.gd`: `_earns(f)` (lines 282–288) only checks `b.has("champ")` and returns `+$450` otherwise. **Verified.**
- `FighterPage.gd`: `_tab(6)` (lines 142–151) hardcodes `"Club stipend, $250 a week"` and `"Until: turning pro"`. **Verified.**

Wrong CODE claims found: **None** in the checked files.

## To reach 10/10

1. **Support combined multi-boxer changes in `CashForecast.project(c, weeks, changes)`**: Allow `changes` to accept an array of per-boxer and club-lever deltas (e.g. `[{fid: "a", stipend: "half"}, {fid: "b", stipend: "half"}, {kit_level: "low"}]`) so under a Red alert the player can preview a combined survival package on one chart before applying it.
2. **Add a compact ledger category filter (`All / Bouts / Stipends`) on the Contract Tab**: Keep the default on `All`, with two filter chips above the left-hand ledger table so a long-career pro's purse, camp, and scouting history stays scannable without scrolling past 20+ monthly stipend rows.
3. **Expose the Overdraft toggle directly in the Red-alert Crisis Levers strip**: Ensure `Overdraft.gd` (`limit`, `1%` arrangement fee, `16%/yr` weekly interest, `12w` pull rule) is one click from any Red alert on `Club > Money` with its live `CashForecast` runway effect shown before enabling.
