# LEDGER1 v6 — Design Map: What a Boxer's Books Actually Say

Design Loop S459 | Task LEDGERREV6 (S531) | Discipline: boxing
Priority Order: Amateur Week → Office → Coach Depth → This Map

This revision is written directly from the opened GDScript codebase. Every claim in **Section 1** marked `CODE` names the file, function, and line verified in this checkout. Every proposed change, unbuilt calculation, or display rule is explicitly tagged `TO BUILD`, `ESTIMATE`, or `CUT`. No personal names appear outside screen headers; body copy uses `the boxer`, `the teammate`, `the opponent`, `your coach`, and `they / their`.

---

## 1. What the Game Does Today (Verified From Opened Code)

### 1.1 Accounting Structure and Settlement Today

| Fact | Detail | Status / Source |
|---|---|---|
| Ledger entry shape | `Career.pay(amount, what)` writes `{d, t, amount}` to `career.ledger` and adds to `career.cash` and `career.week_money` (`in`/`out`/`items`). Stores **no boxer ID (`fid`)**, **no category (`kind`)**, and **no week index**. | `CODE` — `scripts/state/Career.gd` `pay()` lines 185–192, `ledger` line 43 |
| Weekly income settlement | `Sim.end_week()` runs `GameMoney.settle_week()`. Weekly income (`dues`, `sponsors`, evening classes `$350`, fitness `$420`, juniors `$115`, extra class nights `$117 × n`, no-gi dues) is added straight to `career.cash` and `week_money["in"]` with **no ledger entry written**. | `CODE` — `scripts/state/Sim.gd` `end_week()` lines 305–320, `weekly_income()` line 280; `scripts/rules/GameMoney.gd` `settle_week()` line 59 |
| 28-day combined bill | Weekly costs (coach salary, staff wages, extra coaches, fighter stipends `athlete_payroll()`, rent, governing-body fees, power, insurance, kit budget, upgrades upkeep, juniors' coach, loans, no-gi coach) accrue into `career.accrued`. Every 28 days (`GameMoney.is_bill_day(day)`), `Sim.end_week()` writes **one combined ledger row**: `"Month-end bill: wages and upkeep"` (`-int(money["billed"])`). Stipends are never separated in the ledger. | `CODE` — `scripts/state/Sim.gd` `weekly_costs()` line 241, `end_week()` lines 314–323; `scripts/rules/GameMoney.gd` `athlete_payroll()` line 24, `BILL_EVERY_DAYS` line 12 |
| Overdraft accounting | When `career.overdraft_on and career.cash < 0`, `Sim.end_week()` deducts `Overdraft.weekly_interest(cash)` (`max(1, ceil(-cash * 0.16 / 52))`) and pushes `{"d", "t": "Overdraft interest", "amount"}` directly without calling `pay()`. Available after 12 weeks traded; limit = `100%` of last 4 weeks' income floored to `$100`; arrangement fee `1%` of limit; pulled after 12 drawn weeks. **No UI toggle or screen exists in `scripts/ui/` today.** | `CODE` — `scripts/state/Sim.gd` lines 328–338; `scripts/rules/Overdraft.gd` lines 8–64; `scripts/state/Career.gd` lines 81–82 |
| `year_take` text matching | `GymDeals.year_take(c, f)` scans the last 364 days of `c.ledger` for positive rows whose text `t` begins with `"Purse share"` or `"Debut tickets"` AND `t.contains(f["first"])` — fragile string matching that can collide if two names share a first name or match an opponent's name. | `CODE` — `scripts/state/GymDeals.gd` `year_take()` lines 75–83 |
| Weekly stipends | Full stipend = `GameMoney.FIGHTER_STIPEND` (`$250/wk`). Home-grown junior (first 364 days via `HomeJuniors.on_sign`) = `roundi(250 * 0.5) = $125/wk` full (`$63/wk` half). Manual half stipend (`GymSpend.set_half`) sets `day_job = true, half_job = true, weekly_salary = roundi(full * 0.5)` (`$125` or `$63`). Day job = `$0/wk`. Pro = `$0/wk` (`Roster.turn_pro`). | `CODE` — `scripts/rules/GameMoney.gd` line 9; `scripts/state/GymSpend.gd` `set_stipend()` line 116, `set_half()` line 140; `scripts/state/HomeJuniors.gd` `on_sign()` line 100; `scripts/state/Roster.gd` line 300 |
| Day job vs half training | `GymSpend.gain()` multiplies stat gain by `(DayJob.WEEK_DAYS - DayJob.count_of(f)) / DayJob.WEEK_DAYS * ApproachWire.train_mult(c, f)`. Manual day job (`day_job = true, half_job = false`) loses `2` of `6` mornings -> **`4/6` (`~66.7%`)**. Manual half (`half_job = true`) loses `1` of `6` mornings -> **`5/6` (`~83.3%`)**. Only Approach `"half"` sets `train_mult = {"x": 0.925, "until": end}` with `day_job = false`. | `CODE` — `scripts/state/GymSpend.gd` `gain()` line 100; `scripts/rules/DayJob.gd` lines 21–40; `scripts/state/ApproachWire.gd` `answer()` line 176, `train_mult()` line 254 |
| Gym closure & money status | `GymBills.status(cash, net, weeks_below)` returns `"closed"` at `8` consecutive weeks below threshold (`CLOSE_AFTER_WEEKS = 8`), `"red"` when `cash < 0`, `"warn"` when `runway_weeks(cash, net) < 8` (`WARN_RUNWAY_WEEKS = 8`), else `"ok"`. `WeekRead.runway()` projects 52 weeks including 28-day bill dates. Money never blocks `Needs.blockers()`. | `CODE` — `scripts/rules/GymBills.gd` lines 16–87; `scripts/rules/WeekRead.gd` `runway()` line 196; `scripts/state/Needs.gd` `blockers()` line 135 |
| Win member & rep growth | An amateur or pro win adds `BoutRules.WIN_MEMBERS` (`+8`) to `c.members` and `BoutRules.WIN_REPUTATION` (`+5`, or `+10` on `short_notice`) to `c.reputation`. A loss removes `1` member / `2` rep (`2` / `4` if stopped). `Membership.settle_week()` computes `natural = roundi((48 + 0.6 * rep) * draw(band, rep) * draw_mult)`, clamps target to `GymSpend.member_cap(c)`, and walks `25%` of the gap per week (`min 1`, `max 6`). | `CODE` — `scripts/state/BoutFinish.gd` lines 96–108; `scripts/rules/BoutRules.gd` lines 114–123; `scripts/rules/Membership.gd` lines 15–102 |
| Forecast helper today | `CashForecast.project(c, weeks = 8)` deep-copies `c` via `_copy(c)` and projects weekly dues, bills, booked bout cuts/purses, and overdraft — extending past `weeks` until at least one 28-day bill lands (`_has_bill`). It has **no `change` parameter** for what-if scenarios. `bill_split(ahead)` explains the next bill. | `CODE` — `scripts/rules/CashForecast.gd` `project()` line 25, `bill_split()` line 106, `_copy()` line 187 |
| Forecast & UI omissions today | `MoneyPanels._earns(f)` only checks `b.has("champ")` and prints `+$450` even for pros, home bouts, and host-kept gates. `CashForecast.markers()` omits `pro` and `host_gate` checks. `OfficeDesk.money_ahead()` only checks `champ`. `FighterPage._tab(6)` hardcodes `"Club stipend, $250 a week"` and `"Until: turning pro"` regardless of half, day job, home-grown, or pro status; `Routes.INTO_OVERVIEW = [1, 2, 6]` folds Contract & Goals into `DarkOverview`, which renders no ledger or stipend controls. `RosterSummary.boxer()` also hardcodes `"$250 a week stipend"`. | `CODE` — `scripts/ui/MoneyPanels.gd` `_earns()` lines 282–288; `scripts/rules/CashForecast.gd` line 160; `scripts/ui/OfficeDesk.gd` line 214; `scripts/ui/areas/FighterPage.gd` lines 31, 142–151; `scripts/ui/Routes.gd` line 9; `scripts/ui/DarkOverview.gd` line 134; `scripts/ui/RosterSummary.gd` line 37 |

### 1.2 Audit of Every `.pay(` Call Site in the Codebase Today

All 28 `.pay(` calls across `scripts/` (14 boxer-specific, 1 no-gi athlete, 13 club-wide):

#### Boxer-Specific & Athlete-Specific `.pay(` Sites (15 calls — currently untagged by `fid` or `kind`)

| File & Line | Function | Cash Sign & Rule | Current Ledger Text Pattern |
|---|---|---|---|
| `scripts/state/BoutFinish.gd:114` | `run()` | `+int(tickets["gym"])` (debut share of purse + tickets past break-even, `ProOfferWire.night` or `ProDebut.night`; note line 115 logs `Roster.GYM_SHARE * 100` even if share was `10%`) | `"Debut tickets: %d sold, the gym's %d%% of the fighter's share - <first> vs <opp>"` |
| `scripts/state/BoutFinish.gd:120` | `run()` | `+Roster.gym_cut(purse, f)` (`round(purse * StarDeal.share(f))`, post-debut pro bouts; `purse` in `ProLadder.book` combines base purse + tickets) | `"Purse share (%d%%): <first> vs <opp>"` |
| `scripts/state/BoutFinish.gd:138` | `run()` | `+BoutRules.TICKET_CUT` (`+$450` amateur bout, skipped when `champ`, `HomeBout.is_home`, or `host_gate`) | `"Ticket cut: <first> vs <opp>"` |
| `scripts/state/Leaving.gd:93` | `_go()` | `+release_fee(c, f)` (`$0` amateur; `max($500, round(year_take * 0.4 / 100) * 100)` pro) | `"Release fee: <first>'s new manager"` |
| `scripts/state/Roster.gd:281` | `turn_pro()` | `-int(sheet["costs"])` (`$230` licence + `$875` medicals if first time + `$140` corner licence if coach unlicensed = up to `$1,245`; skipped when promoter covers costs from debut purse via `deal["costs_covered"]`) | `"BBBofC licence and brain scans: <first>"` |
| `scripts/state/GymDeals.gd:29` | `pro_camp()` | `-StarDeal.camp_bill(purse, strength)` (`6%` of purse, halved to `3%` with S&C coach; skipped on debut `b.get("tickets", false)`) | `"Pro camp for <first>: sparring partners and meals"` |
| `scripts/state/GymDeals.gd:33` | `pro_camp()` | `-StaffRoles.per_bout(c.staff_roles)` (`-$150` if Cutman on staff; charged every pro bout including debut) | `"Cutman for <first>'s night"` |
| `scripts/state/GymDeals.gd:64` | `answer_talks()` | `-int(t["bonus"])` (`$2,500` top-10, `$5,000` belt, `max($500, year_take * 0.4)` yearly) | `"Signing bonus: <first> stays on %d%%"` |
| `scripts/state/ProLadder.gd:307` | `scout()` | `-Matchmaking.SCOUT_COST` (`-$250` per pro opponent scouted) | `"Scouting <opp> for <first>"` |
| `scripts/state/Bouts.gd:322` | `start_camp()` | `-BoutRules.partner_fee()` (`-$160` = `$40 × 4` visits when outside camp partner chosen) | `"Sparring partner for <first>: <word>, %d visits"` |
| `scripts/state/FightWeekPlan.gd:301` | `lock()` | `-spend` (`-$160` per outside sparring night in fight week not covered by a host favour) | `"Sparring partners for <first>'s fight week"` |
| `scripts/state/Bouts.gd:385` | `weigh()` | `-BoutRules.MISSED_WEIGHT_COST` (`-$300` empty-slot fee when missing weight) | `"Empty slot: <first> missed weight"` |
| `scripts/state/Injuries.gd:123` | `pull_out()` | `-BoutRules.MISSED_WEIGHT_COST` (`-$300` empty-slot fee on pull-out, unless `champ`) | `"Empty slot: <first> injured"` |
| `scripts/state/Sim.gd:66` | `twist_monday()` | `int(once["cash"])` (Monday twist card one-off cash: `photoshoot` `+$400` on boxer `f`, or `heating` `-$600` gym repair on `WeekTwist`) | `"<twist.name>: <twist.label>"` |
| `scripts/state/Grapplers.gd:140` | `enter()` | `-int(o["fee"])` (no-gi open entry fee for grappler `f`) | `"Entry: <open_name> (<first>)"` |

#### Club-Wide `.pay(` Sites (13 calls — shared club column, `fid = ""`)

| File & Line | Function | Cash Sign & Rule | Current Ledger Text |
|---|---|---|---|
| `scripts/state/Bouts.gd:467` | `fight_done()` | `-ClubStart.BACKERS_CLAWBACK` (`-$5,000` on `backed` start if first show lost) | `"The backers took money back after the first show"` |
| `scripts/state/GymDeals.gd:105` | `grant_day()` | `+int(c.grant["amount"])` (`$1,500–$5,000` rounded to `$100` when grant bid succeeds) | `"Club grant: juniors' nights and kit"` |
| `scripts/state/GymSpend.gd:170` | `buy_slot()` | `-int(s["price"])` (floor equipment slot) | `"Equipment: <name>"` |
| `scripts/state/GymSpend.gd:235` | `buy()` | `-int(u["price"])` (`mats $2,400`, `strength $3,600`, `fitkit $1,500`, `youth $1,800`) | `"Upgrade: <name>"` |
| `scripts/state/GymSpend.gd:248` | `move()` | `-GymUpgrades.LOAN["down"]` (`-$3,000` fit-out deposit when moving on loan) | `"Fit-out loan deposit: <name>"` |
| `scripts/state/GymSpend.gd:253` | `move()` | `-int(next["move"])` (`-$12,000` bigger unit or `-$25,000` club building) | `"Moving premises: <name>"` |
| `scripts/state/GymSpend.gd:277` | `let_go()` | `-StaffRoles.notice(id)` (`1` week's wage on letting go a staff role) | `"A week's notice: <role>"` |
| `scripts/state/GymSpend.gd:326` | `evening_coach()` | `-StaffRoles.EVENING_WAGE` (`-$280` notice for letting go an extra evening coach; note `$280`, not `$350`) | `"A week's notice: an evening coach"` |
| `scripts/state/GymSpend.gd:346` | `book_show()` | `-ClubShow.COST` (`-$3,500` hall/officials) | `"Club show: hall, officials, doctor and ambulance, trophies"` |
| `scripts/state/GymSpend.gd:370` | `day_events()` | `+(tickets + raffle)` on show night (`ClubShow.night`) | `"Club show: %d tickets and the raffle"` |
| `scripts/state/GymSpend.gd:386` | `end_week()` | `-COACH_COURSE * coaches` (`-$400 × coaches` on week 26 annual safeguarding/renewal) | `"Coach education and safeguarding renewals..."` |
| `scripts/state/Sim.gd:477` | `hire_coach()` | `-GameMoney.COACH_SIGNING_FEE` (`-$1,000`) | `"Signing fee: <coach_name>"` |
| `scripts/ui/GymActs.gd:42` | `act("repair")` | `-int(f["repair"])` (one-time facility repair for `+2` rep) | `"Repair: <facility>"` |

### 1.3 Live Rule & UI Mismatches Verified in Opened Code

1. **Approach `Move` training mismatch (`CODE`)**: `Approach.TRAIN["holder_move"] = 0.85` (`scripts/rules/Approach.gd:36`) previews `0.85`, while `ApproachWire.answer("move")` (`scripts/state/ApproachWire.gd:184-187`) puts the holder on `day_job = true, weekly_salary = 0`, so `GymSpend.gain()` (`scripts/state/GymSpend.gd:100`) gives `4/6 ≈ 0.667` (`66.7%`).
2. **Approach `Promise` loyalty mismatch (`CODE`)**: `Approach.answers()` (`scripts/rules/Approach.gd:176`) previews `+8` (`+4 + 10 - 3 * 2`), whereas `ApproachWire.answer("promise")` (`scripts/state/ApproachWire.gd:204`) gives `+4` now and `HomeBout.boxed()` (`scripts/state/HomeBout.gd:68`) / `ApproachWire.show_night()` gives `+10` on keeping it (`+14` total, or `-12` + leaves on break). No `-3` promise ticks exist.
3. **Approach `Let Go` cash, rep, and date mismatch (`CODE`)**: `Approach.answers()` (`scripts/rules/Approach.gd:206`) previews `$0` cash, and `ApproachCard.let_go_button` confirm (`scripts/ui/ApproachCard.gd:216`) hardcodes `"Free in cash"`. In reality, `ApproachWire.answer("let_go")` sets `leaves_after = c.day` so `Leaving.monday()` (`scripts/state/Leaving.gd:117-125`) calls `Leaving.leave()` next Monday (which credits `release_fee` if pro, costs `-2/-5` rep, `-2` teammate loyalty under 50, and clears `bout["day"]`). Meanwhile, an unanswered 7-day lapse calls `Leaving.leave()` directly (`ApproachWire.gd:103`), which defers departure up to `FAREWELL_DAYS = 14` (`Leaving.gd:26`) if a bout is booked inside 14 days.
4. **Approach UI `ON_CARD` & pro/debut mismatch (`CODE`)**: `ApproachCard.gd:27` filters buttons via `ON_CARD := ["match", "half", "let_go"]`, hiding `move` and `promise` even though `Approach.answers()` builds all 5 and `ApproachWire.answer()` runs all 5. Also `Approach.due()` (`scripts/rules/Approach.gd:72`) includes pros (`is_pro`), and `Approach.OFFER_LINES` defines `"debut"` and `"manager"`, yet `ApproachWire.monday()` (`ApproachWire.gd:109-112`) turns `"keep"` into `"bout"` whenever `not day_job` (including pros!), and `ApproachWire.answer("match")` does not adjust or protect a pro's `gym_share`.
5. **Rival Offer `_free()` inversion & duplicate action (`CODE`)**: `RivalOfferWire._free(f)` (`scripts/state/RivalOfferWire.gd:99-100`) returns `(bout.is_empty() and injury.is_empty())` — i.e., `true` when the boxer is healthy and unbooked (which is when `-2` ladder penalty **is** charged in `RivalOffer.answer()`, `scripts/rules/RivalOffer.gd:66`!). And `RivalOfferCard.gd:24-28, 63` leaves `"Not this show"` enabled after `not_this_show_used` is true (acting as a duplicate Pass with the same `-2` cost).
6. **Low-loyalty 10% pro renegotiation defect (`CODE`)**: When loyalty `< 50` at pro signing (`Roster.gd:286-288`), `f["gym_share"]` becomes `0.10`. `StarDeal.terms()` (`scripts/rules/StarDeal.gd:41-47`) then produces: at `top10`, `keep: 0.10, bonus: $2,500, lower: minf(0.10, 0.20) = 0.10`; at `belt`, `keep: 0.10, bonus: $5,000, lower: 0.10`; and at `year`, `lower: maxf(0.12, 0.10 - 0.02) = 0.12` — meaning paying `$2,500/$5,000` changes nothing, and choosing `"Drop"` on yearly talks **raises** the share from `10%` to `12%`!

---

## 2. The Accounting Contract (Build Foundation)

Before any per-boxer contract screen or reconciliation rule can be trusted, the ledger itself must become a complete cash record (`TO BUILD`).

### 2.1 Extended Ledger Record and `Career.pay()`

- Update `Career.pay` (`scripts/state/Career.gd:185`) to:
  `func pay(amount: int, what: String, fid: String = "", kind: String = "club", source: String = "") -> void`
- Every entry in `career.ledger` stores:
  `{"d": day, "w": Clock.week_of(day), "t": what, "amount": amount, "fid": fid, "kind": kind, "source": source}`
- Allowed `kind` values:
  - Per-boxer (`fid = f["id"]`): `"bout"`, `"debut_tickets"`, `"purse"`, `"camp"`, `"scout"`, `"bonus"`, `"licence"`, `"empty_slot"`, `"twist"`, `"release"`, `"stipend"`.
  - No-gi (`fid = g["id"]`): `"nogi_entry"`.
  - Club (`fid = ""`): `"weekly_income"`, `"club_bill"`, `"overdraft"`, `"show"`, `"grant"`, `"upgrade"`, `"premises"`, `"staff_notice"`, `"course"`, `"repair"`, `"clawback"`, `"coach_sign"`.
- Update all **15 athlete `.pay(` calls** and **13 club `.pay(` calls** listed in Section 1.2 to pass `fid`, `kind`, and `source` (with `Sim.gd:66` passing `fid = ""` / `kind = "repair"` when `t["id"] == "heating"` and `fid = f["id"]` / `kind = "twist"` otherwise).
- **Replace text matching in `GymDeals.year_take()`** (`GymDeals.gd:75`): sum positive ledger entries in the last `364` days where `e.get("fid", "") == f["id"]` and `e.get("kind", "") in ["purse", "debut_tickets"]` (falling back to old `"Purse share"/"Debut tickets"` prefix check only for legacy saves where `fid` is absent).

### 2.2 Splitting Weekly Income and 28-Day Month-End Bills (`Sim.end_week`)

Because `Sim.end_week()` today adds `income["total"]` with no ledger entry and lumps stipends with rent into one `"Month-end bill: wages and upkeep"` entry, `TO BUILD` updates `Sim.end_week()` and `Career`:

1. **Weekly stipends accrued per boxer**: Track `f["accrued_stipend"]` (incremented each week by `int(f.get("weekly_salary", 0))`).
2. **On every `GameMoney.is_bill_day(day)` (`money["billed"] > 0`)**:
   - For each boxer with `accrued_stipend > 0`: push one ledger entry `{d, w, t: "Stipend (billed)", amount: -accrued_stipend, fid: f["id"], kind: "stipend", source: "Month-end bill"}` and reset `f["accrued_stipend"] = 0`.
   - Push the remainder (`-(money["billed"] - sum_boxer_stipends)`) as `{d, w, t: "Month-end bill: club rent, staff & upkeep", amount: -club_billed, fid: "", kind: "club_bill", source: "Month-end bill"}`.
3. **Weekly club income (`income["total"]`)**: Push one compact club entry per week `{d, w, t: "Weekly club income (dues, sponsors, classes)", amount: int(income["total"]), fid: "", kind: "weekly_income", source: "Weekly settlement"}`. (Optional drill-down stores `{dues, sponsors, classes, fitness, juniors, class_nights, bjj}` on hover).
4. **Overdraft interest (`Sim.gd:331`)**: Push `{d, w, t: "Overdraft interest", amount: -_oi, fid: "", kind: "overdraft", source: "Bank overdraft"}`.
5. **Promoter-covered pro start costs (`Roster.gd:278`)**: When `deal["costs_covered"] == true`, club cash outflow is `$0`. Do not call `pay()`. Display the `$1,245` + `$100/$200` purse deduction as a **note on the debut ledger row** (`ProOfferWire.night` already nets it from `d["purse"]`).

### 2.3 Cash Reconciliation & Estimate Rules

- **Cash Reconciliation Rule (`TO BUILD`)**:
  `career.start_cash_at_open + sum(all fid ledger amounts) + sum(all club ledger amounts) == career.cash` (**exact, ±$0** on new runs; historical saves prior to migration keep an explicit `"Opening / prior balance"` club offset).
- **Separate `ESTIMATE` / `PENDING` lines (NEVER added to cash or net totals)**:
  - **Accrued unpaid stipend**: `f["accrued_stipend"]` since last bill day -> shown as `"Pending stipend (bills <bill_date>): -$X [ESTIMATE — billed next bill]"`.
  - **Membership growth from wins**: computed via `Membership.settle_week()` replay (Section 4) -> shown as `"Club dues boost from wins: est. +$Y over 8w [ESTIMATE — shared club pool, not in boxer net]"`.
  - **Club shared bills** (rent, governing-body `$18/boxer/yr`, power, insurance, coach wages, staff wages, kit budget, upgrades, loans): stay strictly in the **CLUB** column and are never divided across boxers.
- **Exact Words (`Owner rule`)**: Always `"Cash in / Cash out / Net"`, never `"worth"`.

---

## 3. Core Choices, Trade-Offs, and Rules They Change

Every decision modifies numbers that the week simulation or fight engine already reads, with no dominant choice (`CODE` rules named; `TO BUILD` UI/guards marked).

| Decision | Options & Availability | Game Rules & Numbers Changed (`CODE`) | Trade-Off (Why Neither Dominates) |
|---|---|---|---|
| **Keep / Release** | **Amateur:** Always legal unless `bout` unboxed (`Leaving.let_go_price`). **Pro:** Always legal unless `bout` unboxed; pays `Leaving.release_fee` (`max($500, 40% of 364d qualifying take)`). Refusal if booked: `"a bout is booked"`. | Stops `f["weekly_salary"]` -> `GameMoney.athlete_payroll()` -> `Sim.weekly_costs()`. Credits `release_fee` to `career.cash` via `Career.pay()`. Changes `career.reputation` (`-1` amateur, `-3` top-5 or pro on `let_go`; `-2/-5` on `leave`) -> `Membership.natural_members()` -> `c.members` -> `Membership.weekly_dues()`. Changes `Loyalty.value()` (`-2` on teammates `< 50`). Opens `1` slot in `GymSpend.used(c)`. | **Keep** preserves reputation, teammate loyalty, and future purse/ticket income, at ongoing stipend/camp cost. **Release** stops bleed immediately (and brings `$500+` cash now for a pro) and frees a roster slot, at immediate rep/loyalty loss and forfeited future bouts. |
| **Stipend Tier (Amateurs only)** | **Full (`$250/wk`, `$125` home-grown yr 1)** / **Half (`$125/wk`, `$63` home-grown)** / **Day Job (`$0/wk`)**. Locked for `84` days (`stipend_lock`) after an Approach `Match`/`Half`/`Move`; blocked for pros (`"a pro lives on purses"`). | Sets `f["weekly_salary"]` -> `GameMoney.athlete_payroll()` & `accrued` -> `GymBills.status()`. Sets `f["day_job"]` & `f["half_job"]` -> `DayJob.count_of(f)` (`0 / 1 / 2` lost mornings) -> `GymSpend.gain()` stat multiplier (`1.0 / 5/6 ≈ 0.833 / 4/6 ≈ 0.667`) -> `Sim.daily_gain()` -> bout stats & fight edge. Sets `Loyalty.value()` (`+5` full resume, `-8` day job, `+3` half up, `-4` half down) -> `Loyalty.pro_share()` (`10%` if `< 50`) & departure trigger (`< 25` after `2` talks). | **Full** maximizes training & loyalty (`1.0`) but drains `$250/wk`. **Half** saves `$125/wk` (`$1,000/8w`) while keeping `83.3%` gain and milder `-4` loyalty hit. **Day job** eliminates wage bleed (`$0`) for `66.7%` training and `-8` loyalty hit (risking `< 35` rival approach). |
| **Renegotiate Pro Share** | Triggered at **Top-10** (`$2,500` or `20%`), **Belt** (`$5,000` or `17%`), and **Yearly** (`max($500, year_take * 0.4)` or `-2%` floor `12%`). Keep disabled with `"$X short"` if `c.cash < bonus`. Deadline: `14` days; lapse = lower share stands. **`TO BUILD` guard:** suppress or replace if `share(f) <= 0.12` (the `10%` outside-manager share). | **Keep** subtracts `bonus` from `career.cash` via `GymDeals.answer_talks()` -> `WeekRead.runway()`, keeping `f["gym_share"]` higher for all future `BoutFinish` `Roster.gym_cut(purse, f)` payouts (`StarDeal.share`). **Drop** preserves `career.cash` now and permanently reduces `f["gym_share"]` on future bouts. Belt talks also open `Meridian Bank` `$1,000/wk` sponsor (`GymUpgrades.TITLE_SPONSOR`). | **Keep** wins when the pro has enough high-purse fights ahead (`11+` at `$5,000` purse for top-10) AND cash runway survives the upfront bonus. **Drop** wins when club cash is tight or purse/bouts-remaining cannot repay the bonus (`34+` bouts needed at `$1,500` purse). |
| **Answer Club Approach** | `7`-day deadline (`Approach.ANSWER_DAYS`); lapse triggers `Leaving.leave()` (defers up to `14` days if bout booked). **Amateur card:** shows Q-253 primary 3 answers (`Match`, `Half`, `Let Go`) on Overview + full 5 (`+ Move`, `Promise`) on Contract Tab (`TO BUILD`), each with exact refusal reasons. **Pro / Debut (`TO BUILD`):** group-specific `Match Terms / Retain Share` vs `Let Go`. | **Match:** `$250/wk` + `84d` `stipend_lock`, `+12` loyalty. **Half:** splits `$250` (`$125` each) + `84d` lock + `train_mult = 0.925` (`GymSpend.gain`), `+6/+10` vs `-4` holder loyalty. **Move:** `$250` moves + `84d` lock + holder `day_job` (`4/6 ≈ 0.667` gain) + `-12` & `-3/28d` grievance ticks (<70 loyalty). **Promise:** spends `-$3,500` (`ClubShow.COST`), books `HomeBout`, `+4` now, `+10` kept (`HomeBout.boxed`) or `-12` + leaves (`show_night`). **Let Go:** `Leaving.leave` (`+release_fee` if pro, `-2/-5` rep, `-2` teammates `< 50`). | **Match** keeps both boxers happy if stipend budget holds; **Half** preserves cash & both prospects (`0.925`); **Move** protects the approached star (`1.0`) by sacrificing a teammate's training & loyalty; **Promise** buys loyalty with `$3,500` show outlay; **Let Go** exits when the cost outweighs keeping. |
| **Answer Bout Challenge** | `4`-day deadline; lapse = `Pass`. `Accept` / `Not This Show` (disabled after 1 seasonal use with refusal `"Already used this season — use Pass"` `TO BUILD`) / `Pass`. Free (`0` pts) while injured or already booked; `-2` ladder points if healthy & unbooked (`_charged()` `TO BUILD`). | **Accept** books `Bouts` (camp, weight cut, `$450` ticket cut on regional show, `+8` members / `+5` rep on win). **Not This Show** defers without `-2` ladder penalty once per rival per season (`RivalOffer`). **Pass** keeps schedule free at `-2` ladder points when healthy/unbooked (`0` when busy/hurt). | **Accept** brings `$450` + member growth + ladder points if fit & weight-makeable; **Not This Show** protects rank/schedule during a bad weight/fatigue window; **Pass** avoids a dangerous mismatch or missed-weight `-$300` fine at `-2` ladder points. |
| **Turn Pro vs Stay Amateur** | `14`-day window (`ProCall.WINDOW_DAYS`); lapse waits `2` more wins; `3` declines closes door; `age >= 32` no first call. One ask per promoter (`Bow Lane` ticket house / `Harrow & Finch` guarantee house). | **Turn Pro** pays `ProDebut.start_costs` (up to `$1,245` cash now, or purse-deducted `+$100/$200` if H&F covers costs), sets `weekly_salary = 0`, sets `gym_share` (`0.25` or `0.10` if loyalty `< 50`, modified by ask), books debut, changes morale (`ProCall.morale`). **Stay Amateur** retains stipend & `$450` amateur bouts + nationals path. | **Turn Pro** ends `$250/wk` stipend drain and opens pro purses + ticket share, but risks `$1,245` upfront and low debut draw if club members are low; **Stay Amateur** builds win count/titles (raising future debut ticket forecast by `+2/win`, `+10/title`) while costing stipend. |

---

## 4. Dues From a Win — Honest Replay (`Membership.settle_week`)

A win adds **both** `BoutRules.WIN_MEMBERS` (`+8` members) **and** `BoutRules.WIN_REPUTATION` (`+5` rep, or `+10` on `short_notice`) (`BoutFinish.gd:96-98`). Using a flat `"$65/wk"` figure is wrong because `Membership.settle_week()` (`Membership.gd:90-104`) pulls `c.members` toward `target = min(natural(rep + 5, band), member_cap)` at `25%` of the gap per week (`min 1, max 6`).

### Method (`TO BUILD` — `BoutFinish.win_dues_effect(c, f, weeks = 8)`)

1. Run `Membership.settle_week()` over `N` weeks (`8` default) from `(c.members + 8, c.reputation + 5)` (or `+10` if short notice) -> `dues_with_win`.
2. Run `Membership.settle_week()` over the same `N` weeks from `(c.members, c.reputation)` holding `member_cap`, `dues_band`, and `gym_plan` equal -> `dues_baseline`.
3. Report `delta = dues_with_win - dues_baseline` strictly as a **labelled club-level estimate**:
   `"Recent wins (+8 members, +5 rep per win): est. +$X total dues over 8w (shared club pool — never added to boxer net)"`.

### Verified Numeric Behaviour (`CODE` formulas)

- **Headroom open** (e.g., `members = 40`, `rep = 30`, `standard` `$35/mo`, `cap = 70`): `natural` before win = `48 + 0.6 * 30 = 66`; after win (`rep = 35`) `natural` = `69`. Baseline walks `40 -> 46 -> 51 -> ...`; with win starts at `48 -> 53 -> 57 -> ...`. Marginal difference is `+$140–$360` across 8 weeks while the headroom holds.
- **At capacity** (`members = 68`, `cap = 70`): win adds `+8` (`76`, or if clamped/drifted down toward `70`, decays `-1` to `-2` per week back to `70`). Most of the `+8` leaks away, so true 8-week marginal dues gain is **much smaller** than `$65/wk × 8` (`~$100–$180`, not `$520`).

---

## 5. Same-State Comparison (`CashForecast.project(c, weeks, change)`)

### 5.1 Required Function Extension (`TO BUILD`)

Extend `CashForecast.project(c: Career, weeks: int = WEEKS, change: Dictionary = {}) -> Array`:
- Copy career via `_copy(c)`.
- Apply `change` cleanly before running `_project(copy, horizon)`:
  - `stipend`: `"full"` / `"half"` / `"off"` -> calls `GymSpend.set_stipend` / `GymSpend.set_half` on `copy` (respecting `ApproachWire.stipend_locked`, preserving already-accrued costs in `copy.accrued`).
  - `release`: `true` -> if `Leaving.let_go_price(copy, fid)["why_not"] == ""`, calls `Leaving.let_go(copy, fid)` (adds pro `release_fee` to `copy.cash` at day 0, applies `reputation` drop so `Membership.settle_week` uses lower `natural_members`, removes boxer's `weekly_salary` and unboxed bout).
  - Club levers (`dues_band`, `kit_level`, `evening_coach_delta`, `overdraft_on`): applies the matching `GymSpend` / `Overdraft` rule on `copy`.
- **Horizon toggle**: `8 weeks` (default, extended to include next bill) or `12 weeks` (for pro schedules & 3-month planning).

### 5.2 Comparison Table From the Same Career State

Shown side-by-side on the Contract Tab for the selected boxer (Amateurs show **4 columns**; Pros show **Keep / Release** since pros have `$0` stipend):

| Row | Keep Current Deal | Half Stipend (`GymSpend.set_half`) | Day Job (`GymSpend.set_stipend(false)`) | Release Now (`Leaving.let_go`) |
|---|---|---|---|---|
| **Immediate cash today** | `$0` | `$0` | `$0` | **`+$X` release fee (pro)** / `$0` (amateur) — shown **on** this row & chart |
| **Next month-end bill** | Exact date & `$` from `CashForecast.bill_split()` | Same date; remaining unpaid weeks drop by `$125/wk` (`$63` home-grown) | Same date; remaining unpaid weeks drop by `$250/wk` (`$125` home-grown) | Same date; all future weeks stop (`accrued` to date still billed) |
| **Lowest club cash (`8w / 12w`)** | `$A` (baseline, booked bouts only) | `$B` (from `CashForecast` copy) | `$C` (from `CashForecast` copy) | `$D` (from `CashForecast` copy, including fee & rep-dues effect) |
| **Stipend over horizon** | `-$250/wk` (`-$2,000 / 8w`; `-$3,000 / 12w`) | `-$125/wk` (`-$1,000 / 8w`; `-$1,500 / 12w`) | `$0/wk` (saves `$2,000 / 8w`) | `$0/wk` (saves all future stipends + camp/scout) |
| **Booked bout** | Date & `$450` cut / pro share (or `None booked` dashed) | Same; cut/prep unaffected except morning gain | Same; weight/gain affected (`4/6` mornings) | **Withdrawn** (`None`; blocked if bout already booked!) |
| **Training pace** | `100%` (`6/6` mornings) | `83.3%` (`5/6` mornings; `Approach` split = `92.5%`) | `66.7%` (`4/6` mornings) | Boxer leaves |
| **Loyalty & club rep** | `Loyalty.forecast_line()` (note `-3/wk` after 4w idle) | `-4` once from full (`+3` from day job) | `-8` once (`-4` from half) -> risks `<35` approach | `-1` rep (`-3` top-5/pro); `-2` loyalty per teammate `<50` |
| **Roster slot** | Occupied | Occupied | Occupied | **Frees `1` slot** (`used / places`) |

**Strict separation rule:** Unbooked future bouts never move the baseline `"Lowest club cash"` number. If unbooked, a second dashed curve (`CONDITIONAL — if booked & won`) can be toggled on the chart, clearly labelled not to rely on it for bill survival.

---

## 6. Approach Card & Conditional Choices (Rules Unified)

### 6.1 Club Approach (`Approach.gd`, `ApproachWire.gd`, `ApproachCard.gd`)

Deadline: `7` days (`Approach.ANSWER_DAYS`). **Tell It Straight** (`Approach.talk`): optional once per approach (`free`, blocked `56` days after any talk), `0` loyalty if landed, `-4` if failed. Unanswered lapse after 7 days triggers `Leaving.leave()` (defers up to `14` days if booked).

#### Amateur Approach Answers (All 5 synced between `Approach.answers()` & `ApproachWire.answer()`)

Note on placement (`Q-253` / `CRITIC_PACK` s6): Overview `ApproachCard` displays the 3 primary answers (`Match`, `Half`, `Let Go`) plus a link/expand (`More answers: Move / Promise`) to the full 5-column comparison on the Contract Tab (so all 5 answers share identical previews and refusal reasons).

| Answer | Cash Impact (exact rule) | Boxer Loyalty | Teammate / Club Cost | Training | Availability & Refusal Reason |
|---|---|---|---|---|---|
| **Match** | On `keep` offer: **`$0` today; commits `$250/wk` (`$3,000` over `84d` `stipend_lock`)**. On `bout` / `debut` offer: `$0`. | `+12` | `$0` (or stipend locked `84d`) | `100%` | Always available |
| **Half** | `$0` incremental (`$250` split `$125 / $125` for `84d`) | `+6` (or `+10` if straight talk landed) | Holder `-4` loyalty; both locked `84d` | Both **`92.5%`** (`Approach.TRAIN["half"]`) | Needs `keep` group + eligible holder (`on stipend, not pro, not day job`) + talk not failed. Refusals: `"not a stipend offer"` / `"nobody holds the stipend"` / `"the talk failed"` |
| **Move** | `$0` incremental (`$250` moves to approached for `84d`) | `+12` | Holder `-12` now + **`-3` every `28d`** (`max 3` ticks if loyalty `< 70`); both locked `84d` | Approached `100%`; Holder **`66.7%` (`4/6` day job, FIXED from `0.85`)** | Needs `keep` group + eligible holder. Refusals: `"not a stipend offer"` / `"nobody holds the stipend"` |
| **Promise** | **`-$3,500` today** (`ClubShow.COST`, books home show) | **`+4` now, `+10` when boxed (`+14` total, FIXED from `+8`); `-12` + leaves if broken** | Club show cost `-$3,500` (tickets + raffle return on night) | `100%` | Needs `ClubShow.can_book` + `HomeBout.reason == ""` + `c.cash >= $3,500`. Refusals: `"no show can be booked now"` / `"$X short"` |
| **Let Go** | **`+$X` pro release fee** / `$0` amateur (`FIXED from $0`) | Boxer leaves next Monday (`or after bout inside 14d on lapse`) | **`-2` rep (`-5` if top-5/pro); `-2` loyalty on teammates `<50`** | — | Always available |

#### Pro / Debut Approach Handling (`TO BUILD` — fixes `ApproachWire.gd` & `Approach.gd`)

- **Pro (`group == "manager"` or any `is_pro` boxer under `< 35` loyalty)**: Do NOT switch to `"bout"` (`ApproachWire.gd:110`) and do NOT offer amateur stipend buttons. Show two valid pro answers:
  - **Retain & Recommit (`match_pro`)**: Pays retention bonus (`StarDeal.terms(f, "year", year_take)["bonus"]` — disabled if `c.cash < bonus`), `+12` loyalty, preserves `f["gym_share"]` for `84` days.
  - **Let Go (`let_go`)**: `Leaving.leave()` next Monday -> **credits `Leaving.release_fee(c, f)`** (`max($500, 40% of year_take)`), `-5` rep, `-2` on teammates `< 50`.
- **Amateur Pro-Ready (`group == "debut"`)**: Show **Promise Pro Debut** (`$0` cash today, `+12` loyalty, confirms pro goal) vs **Let Go** (`$0` cash, `-2/-5` rep).

### 6.2 Rival Bout Challenge (`RivalOfferWire.gd`, `RivalOffer.gd`, `RivalOfferCard.gd`)

- **Code fix (`TO BUILD`)**: Rename `RivalOfferWire._free(f)` -> `_charged(f)` (and state key `"charged"`), returning `true` only when `bout.is_empty() and injury.is_empty()`.
- **Choices (4-day deadline; lapse = Pass)**:
  - **Accept**: Available while rival still in club (`"That boxer is gone"` / `"Bout could not be booked"`). Books show bout.
  - **Not This Show**: Available once per rival per season (`not not_this_show_used`). **Disable button once used** with refusal text `"Already used this season — use Pass instead"` (eliminates duplicate no-op action).
  - **Pass**: `0` cost when injured or booked (`"Free — injured / already booked"`); otherwise **`-2` ladder points** (`RivalOffer.PASS_COST`).

### 6.3 Renegotiation Talks (`StarDeal.gd`, `GymDeals.gd`, `ClubSpend.gd`)

- **Milestones**: Top-10 (`$2,500` keep `25%` vs `20%`), Belt (`$5,000` keep vs `17%` + opens `$1,000/wk` `Meridian Bank` title sponsor), Yearly (`max($500, 40% of year_take)` vs `-2%`, floor `12%`). `14`-day deadline (`until = c.day + 14`); lapse = lower share stands.
- **Keep availability**: Requires `c.cash >= bonus` (`"$X short of the bonus"`).
- **Low-loyalty guard (`TO BUILD`)**: If `StarDeal.share(f) <= StarDeal.FLOOR` (`0.12`, e.g. `0.10` outside-manager trainer share from loyalty `< 50`), suppress share-drop talks (`StarDeal.due()` returns `""`) so `"Keep"` never charges `$2,500/$5,000` for zero difference and `"Drop"` never **raises** the share from `10%` to `12%`.

### 6.4 Pro Offer (`ProOfferWire.gd`, `ProCall.gd`, `ProOffer.gd`)

- `14`-day window; lapse waits `+2` more wins (`ProOfferWire.lapse_if_due`); 3rd decline closes door; age `>= 32` gets no first call.
- Shows Bow Lane (`$1,500` base, `60` break-even, `50%` over, `4w` out) and/or Harrow & Finch (`$1,800` base, `70` break-even, `30%` over, `6w` out), exact `pays_back_weeks` vs stipend saved, upfront vs purse-deducted `start_costs`, and morale deltas (`ProCall.morale`).

---

## 7. Alert Lifecycle & Club-Wide Crisis Levers

### 7.1 Warning Table (Grounded in `GymBills`, `WeekRead`, and `LoyaltyWire`)

No manual `"Set review date"` snooze button (`CUT` — the clock already pauses every Monday; alerts clear only when the underlying cash or booking condition resolves).

| Alert | Trigger (`TO BUILD` / `CODE`) | Clears When | Action & Destination |
|---|---|---|---|
| **🔴 Red — Closure Crisis** | Club cash `< $0` (or `-od_limit`) OR baseline `CashForecast.project(c, 8)` hits `GymBills.CLOSE_AFTER_WEEKS` (`8` consecutive weeks below threshold). **Not dismissible.** | Baseline 8w forecast clears closure threat (via booking settled, stipend change, release, or club lever). | **Club Levers** (Section 7.2) + **Release** (`Leaving.let_go` if unbooked) + **Find Bout** (`CONDITIONAL — does not clear Red until booked & settled`) |
| **🟠 Orange — Idle Paid Stipend** | Amateur with `weekly_salary > 0`, healthy, unbooked, past `10`-day compulsory rest (`Bouts.AFTER_FIGHT`), and not blocked by nationals entry window, for `4+` weeks (`LoyaltyWire.IDLE_WEEKS`, matching `-3/wk` idle drift) AND next bill pulls cash down. **Idle clock pauses automatically during rest/injury and displays `"Rest ends <date>"`.** | A bout is booked, stipend changes to Half / Day Job, or boxer is released. | **Find Bout** -> opens `Fights > Ask for a fight` pre-filtered to this boxer; **Half / Day Job Stipend** -> `GymSpend` |
| **🟡 Yellow — Bill / Runway Pressure** | `WeekRead.runway()` status is `"warn"` (runway `< 8` weeks or next 28-day bill dips `< $0`) while this boxer draws a stipend or has a pending signing bonus due within 14 days. | Club runway returns `>= 8` weeks, bill clears, or bonus talk resolves. | **Compare Stipend Options** -> Contract Tab comparison; **Open Talk** -> `Cashbook` / Contract Tab |

### 7.2 Club-Wide Levers Shown Under Red Alert (`CODE` rules, `CashForecast` delta `TO BUILD`)

Every Red alert displays the club-wide levers alongside per-boxer stipend/release actions because `GymBills.status` is club-level (`WeekRead.runway`):

| Club Lever | Immediate / 8-Week Cash Effect (`CODE`) | Real Trade-Off (`CODE`) | Source |
|---|---|---|---|
| **Switch Dues Band** (`cheap $25` / `standard $35` / `premium $45`) | Takes effect next calendar month (`GymSpend._dues_month`). `Cheap` draws `+15%` higher target (`-29%` fee/member); `Premium` draws `-15%` (`+29%` fee/member). | Higher short-term cash per existing member (`Premium`) vs higher steady-state member cap fill (`Cheap` / `Standard`). | `Membership.DUES`, `GymSpend.set_dues()` |
| **Cut Kit Budget** (`good $80` -> `standard $45` -> `low $0`) | Saves `$35/wk` (`$280/8w`) or `$80/wk` (`$640/8w`). | `Low` raises training injury risk to `×1.25`; dropping from `Good` loses `+2` member cap (`GymSpend.member_cap`). | `GymBills.KIT_BUDGET`, `GymSpend.set_kit()` |
| **Half Stipend** (per amateur) | Saves `$125/wk` (`$1,000/8w`, or `$63/wk` if home-grown). | Training drops to `5/6` (`83.3%`), loyalty `-4` (`sponsor_half_down`). | `GymSpend.set_half()`, `DayJob.HALF_LOST` |
| **Pause Stipend / Day Job** (per amateur) | Saves `$250/wk` (`$2,000/8w`, or `$125/wk` if home-grown). | Training drops to `4/6` (`66.7%`), loyalty `-8` (`sponsor_pulled`), risks rival approach under `35`. | `GymSpend.set_stipend()`, `DayJob.LOST` |
| **Release One Boxer** | Amateur: saves `$250/wk` (`$2,000/8w`), `$0` fee. Pro: **`+max($500, 40% of year_take)`** today + stops camp/scout bills. | `-1` rep amateur (`-3` top-5/pro), `-2` loyalty per teammate `<50`, loses boxer & roster investment. | `Leaving.let_go()`, `Leaving.release_fee()` |
| **Let Go Evening Coach** | Pays **`-$280` 1-week notice** today, then saves **`$280/wk`** (`+$1,960` net over 8w). **Note:** `$350/wk` evening classes (`CLASSES_WITH_COACH`) stay active as long as head assistant coach remains! | Drops `StaffRoles.coaching_cap` by `40` members (may shrink club cap) and blocks annual `Grants.blocked` bid (`requires second coach`). | `GymSpend.evening_coach()` line 326, `StaffRoles.EVENING_WAGE` line 56, `Grants.gd` line 21 |
| **Arrange Bank Overdraft** (`TO BUILD` UI toggle; rules `CODE`) | After week 12: limit = `100%` of 4w income (`-$1%` fee). Shifts closure floor from `$0` to `-limit`; costs `16%/yr` weekly interest (`max($1, ceil(-cash * 0.16 / 52))`) while `< $0`. | Buys breathing room past one bad month-end bill; bank pulls the facility after `12` consecutive drawn weeks (`Overdraft.PULL_AFTER_WEEKS`), and interest compounds weekly loss. | `Overdraft.gd` lines 8–64, `Sim.gd` lines 328–338 |

---

## 8. Milestones, Earned Context, and Conditional Bout Value

- **Deferred fake `"Self-funding ✅"` badge & `"Annualized $X/year"` line (`CUT`)**: Do not display a green `"Self-funding"` badge based on incomplete estimates or multiply per-bout net by an unbooked bouts/year guess.
- **Real Historical Financial Summary (`TO BUILD`)**: Once Section 2's ledger contract is active (all 28 `pay()` sites + split month-end stipends), show on the boxer's Contract Tab:
  - **Cumulative Cash In** (sum of positive `fid` rows)
  - **Cumulative Cash Out** (sum of negative `fid` rows, including billed stipends)
  - **Real Net to Date** (`Cash In + Cash Out`), plus **Pending Accrued Stipend (`ESTIMATE — bills <date>`)** and **Last 4-Week Net**
  - **Achieved Financial Milestones** (factual log only: e.g. `"Turned pro (<house>): start costs paid / purse-deducted"`, `"Debut night: gym net +$X"`, `"Top-10 talks: kept 25% for $2,500"` / `"dropped to 20%"`).
- **Conditional Per-Bout Value Line (`CONDITIONAL` only, never added to cash)**:
  - **Amateur**: `Booked next bout: +$450 ticket cut` (or `$0 — championship / home show / host keeps gate` per `BoutFinish.gd:127`). If unbooked, `"None booked — regional club bout pays $450 ticket cut (excl. host-kept asks/home shows)"`.
  - **Pro (`StarDeal.gym_net` & `ProLadder`)**: Calculated per bout at the boxer's **actual** `StarDeal.share(f)` and S&C/Cutman state (`purse * share - camp_bill(purse, strength) - cutman_per_bout`), clearly marked **`CONDITIONAL — per bout if booked & fought (excl. $250 scout)`**:
    - Current rank tier (`Matchmaking.PURSE_UNRANKED = $1,500`, `+$400` per rank above 21 + ticket draw)
    - At Top-3 rank (`purse` at rank 3 = `$8,700` base -> `gym_net` at current/20% share minus `$150` cutman if hired)
    - At Belt (`rank 1` purse = `$9,100` base -> `gym_net` at current/17% share minus `$150` cutman if hired)
    - At Pro Debut (before debut only): `ProOfferWire.night` / `ProDebut.night` forecast at current ticket count.
- **Release Confirmation Farewell Summary (`TO BUILD` inside existing `ApproachCard` / `Leaving` confirm dialog)**: Show 2 factual lines before confirming Release: `"Club ledger: in +$X / out -$Y / net $Z · Record W-L · Release fee: +$F"` (no extra pop-up or post-release transfer market).

---

## 9. Where It Appears — Menu Wire Map (`CODE TODAY` vs `TO BUILD`)

Every screen adheres to **Names only in headers** (header shows `[Boxer Name]` once; panels, rows, buttons, and tooltips use `this boxer`, `your boxer`, `the teammate`, `the opponent`).

| Screen | What Is Shown | What You Can Do | Wired To | CODE TODAY | TO BUILD |
|---|---|---|---|---|---|
| **Fighter Page > Contract Tab** (`FighterPage.gd`, `DarkOverview.gd`, `Routes.gd`) | Dated per-boxer ledger (`Wk · Source · In · Out · Net`), accrued stipend & win-dues estimates, achieved financial milestones, 4-way/2-way 8w/12w comparison, conditional per-bout line, alert banner | Toggle stipend (`Full / Half / Day Job`), Release (`with farewell/fee summary`), jump to Contract Talk / Approach / Find Bout, switch `8w / 12w` | `Roster` -> `Fighter Page > Contract` -> `Money` / `Fights` | `Routes.INTO_OVERVIEW = [1, 2, 6]` folds tab 6 into `DarkOverview`; `FighterPage._tab(6)` hardcodes `"Club stipend, $250 a week"` & `"Until: turning pro"` with no ledger, no stipend buttons, no release fee (`ApproachCard` button says `"Free in cash"`) | Give `Contract` its own clean panel/tab (or dedicated Contract view inside `DarkOverview` / tab 6 un-folded) showing true `fid` ledger, `CashForecast` 4-way comparison, `8w/12w` toggle, honest release fee, and live stipend buttons |
| **Club > Money > Books & Fighters** (`Money.gd`, `MoneyPanels.gd`) | Club cash KPIs, `CashChart` (past + 8w/12w forecast), `CLUB` column (shared overhead), `Fighters` table (`Cash In`, `Cash Out`, `Net`, `Last 4w`, `Stipend`, `Next Bout / Earns`, `Alert`, checkbox to compare) | Toggle amateur stipends, sort columns (`navigation only`), select 2–3 boxers for side-by-side comparison, open boxer's Contract view, open Overdraft / Crisis Levers | `Shell / Home / Office` -> `Club > Money` -> `Contract Tab` | `MoneyPanels.fighters` shows only `Stipend` (`Start/Stop/Half`), buggy `_earns` (`+$450` even for pros/home/host-gate), and `Next money`; no `Cash In / Out / Net`, no alert chip, no 2–3 boxer compare, no overdraft UI | Fix `_earns` for pro/home/host-gate; add `fid` totals (`In / Out / Net / Last 4w`), alert chip, 2–3 boxer Compare view, and `CashForecast` crisis preview + Overdraft switch (`Overdraft.gd`) |
| **Club > Money > Cashbook** (`ClubSpend.gd`) | Club one-offs & split month-end/weekly club items (grouped, tagged with `Wk · source`), Repairs, Upgrades, Premises, **Contract Answers (`Keep X% / Drop to Y%`)** | Buy upgrades/move, answer pro share talks (with bonus `$`, new `%`, `14d` deadline, and cash check), repair kit | `Money` <-> `Cashbook` -> `Fighter Contract` | `ClubSpend.cashbook` lists flat 8-week `Career.ledger` (`In` / `Out`) without `fid` or `Wk · source`; `_answers` lists `Keep X%` / `Drop to Y%` without showing `14d` deadline or bonus cost clearly in text | Tag every row with `Wk · source` + `fid` filter; add `14d` deadline + exact bonus `$` + `StarDeal` 10% guard to `_answers` |
| **Week Review (per boxer row)** (`WeekReview.gd`, `ProWeekLines.gd`) | Weekly training & bout review; per-boxer weekly stipend vs tagged cash moves that week; active alert chip; pro debut week ledger (`ProWeekLines`) | Open boxer's Contract Tab, toggle stipend (`if unlocked`), jump directly from 🟠 row to `Fights > Ask for a fight` | `Home (Needs)` -> `Week Review` -> `Contract Tab` / `Fights` | `WeekReview` renders `ProWeekLines` only for 28 days post-turn-pro / debut week; shows no weekly stipend cost, no non-debut ledger lines, and no alert status or `Find Bout` link | Add compact per-boxer cash & alert line (billed/accrued stipend + week's tagged moves + 🟠/🔴 action link -> `Contract Tab` or `Ask for a fight`); zero new pop-up |
| **Approach Card** (`ApproachCard.gd`, `ApproachWire.gd`, `Approach.gd`) | Rival offer (`keep / bout / debut / manager`), 7d deadline, Tell It Straight button; Q-253 primary 3 answers on Overview + all 5 on Contract Tab (group-aware for Pro/Debut) | Pick answer (`Match / Half / Move / Promise / Let Go`, or `Retain / Let Go` for pros), optional Tell It Straight first | `Home Needs` -> `Fighter Page` -> `ApproachCard` -> `Contract Tab` | `ON_CARD` hides `Move` & `Promise`; `Move` previews `0.85` instead of `4/6`; `Promise` previews `+8` instead of `+14`; `Let Go` previews `$0` and popup says `"Free in cash"`; pro approaches map to amateur `"bout"` | Fix `Move` (`4/6`), `Promise` (`+14`), `Let Go` (fee/rep/14d date); support `Pro/Debut` groups properly; expose `Move`/`Promise` refusal states cleanly |
| **Bout Challenge Card** (`RivalOfferCard.gd`, `RivalOfferWire.gd`, `RivalOffer.gd`) | Rival club & rank/rep vs ours, show date, 4d deadline, `Accept / Not This Show / Pass`, free exemption notice when hurt or booked | Accept, Not This Show (1/season), Pass (`0` or `-2` pts) | `Home Needs` -> `Fighter Page` -> `RivalOfferCard` | `_free(f)` is inverted (true = charged `-2`); `"Not this show"` stays clickable after seasonal use as duplicate Pass | Rename `_free` -> `_charged` (`"charged"` key), fix logic/tests, disable `"Not this show"` once `not_this_show_used == true` |
| **Pro Offer Modal** (`ProOffer.gd`, `ProOfferWire.gd`, `ProCall.gd`) | Bow Lane vs Harrow & Finch terms side-by-side, ticket bar, ask answers with availability, `pays_back_weeks` vs saved stipend, morale preview | Ask one lever, `Turn pro` / `Stay amateur` | `Home Needs / Top Bar` -> `Pro Offer` -> `Fighter Page` | Already built (`ProCall` v2); shows `gym_at_signing`, weekly saving vs stipend, `pays_back_weeks`, morale, and asks | Sync post-signing `debut` ledger text (`BoutFinish.gd:115`) to use actual `Roster.share_of(f)` (`10%` or `25%` + ask split) instead of hardcoded `GYM_SHARE * 100` |
| **Office > Desktop** (`Office.gd`, `OfficeDesk.gd`) | Needs (top 3), 28d calendar (`bills`, `dues`, `bouts`), 8w money ahead, club cash/members, fighter roster strip | Click through to `Club > Money`, specific boxer `Contract Tab`, or `Fights` | `Gym Office Pin` -> `OfficeDesk` -> `Money` / `Contract Tab` | `OfficeDesk.money_ahead` only checks `b.has("champ")` (misses pro/home/host-gate); shows club cash & bills with no per-boxer alert count or net summary | Fix `money_ahead` bout-cut check; show active 🔴/🟠/🟡 contract alert count chip linking to `Club > Money` |
| **Home & Shell Top Bar** (`Home.gd`, `HomeNeeds.gd`, `Main.gd`, `Needs.gd`) | Pinned red/amber needs, `BELOW $0` / `LOW CASH` / `CONTRACT TALKS` top-bar flags | One-click route to `Club > Money` or `Contract Tab` | `Top Bar` / `Home` -> `Money` / `Contract Tab` | Top bar shows `BELOW $0`, `LOW CASH` (`Needs.flags`), and `WEEK REVIEW`; no per-boxer contract-alert flag beyond `talks`/`approach` | Route contract-talk flag & new 🟠/🔴/🟡 contract alerts straight to `Fighter > Contract Tab` or `Money` without blocking `Needs.blockers()` |
| **Fighters > Roster** (`Fighters.gd`, `RosterSummary.gd`, `CoachCheck.gd`) | Roster cards & sortable table; `CoachCheck` already includes `Rival club` row when approach open | Click boxer -> `Fighter Page`; see stipend/pro status accurately | `Fighters` -> `Fighter Page` | `RosterSummary.boxer()` hardcodes `"$250 a week stipend"` for all amateurs (ignores half/day-job/home-grown) | Read `GymSpend.stipend_held` & actual `weekly_salary` (`$250 / $125 / $63 / Day job / Purse share`) |
| **Fights > Ask for a fight** (`Fights.gd`, `AskFlow.gd`, `ProLadder.gd`) | Landing target from 🟠 alert (`Find Bout`); shows regional sheet / pro offers & asks, bout ticket/purse terms, and scouting cost (`-$250`) | Ask for or accept a bout (`conditional until accepted & settled`) | `Contract Tab / Week Review` -> `Fights` -> `Fighter Page` | Exists for amateurs (`AskFlow`) and pros (`ProLadder`); no pre-filter query param from contract alerts | Accept optional `fid` filter on navigation from 🟠 alert rows and refresh alert status on booking |
| **Club > Money > Crisis Levers & Overdraft** (`Overdraft.gd`, `DuesBoards.gd`, `DuesWire.gd`) | Dues band (`cheap / standard / premium`), kit budget (`low / standard / good`), evening coach toggle, and Arranged Overdraft status/limit/interest | Preview 8w cash delta via `CashForecast.project()` and toggle overdraft after week 12 | `Red Alert` -> `Club > Money` -> `Contract Tab` | `DuesBoards` & `DuesWire` exist for dues band; `Overdraft.gd` & `Sim.gd` run overdraft rules, but **no overdraft UI toggle exists anywhere** | Add Overdraft toggle (`limit`, `1%` fee, `16%/yr` rate, `12w` pull rule) and live 8w lever deltas under Red alert |

---

## 10. 1920×1080 Screen Layout — Fighter Contract View (`Look B`)

Built in the warm gym whiteboard / dark overview style (`DarkOverview` dark slate bed with warm cream paper cards and marker headers; **boxer's name once in the header only**):

```text
┌─────────────────────────────────────────────────────────────────────────────────────────────────┐
│ [HEADER]  [Boxer Name] · Record: 5-1 · Welterweight · Pro (25% share) / Amateur ($250/wk)      │
│           Active Alert: 🟠 5w idle unbooked · Deadline: Top-10 talks end in 9d (Mon 14 Sep)    │
├─────────────────────────────────────────────────────────────┬───────────────────────────────────┤
│ LEFT TWO-THIRDS (~65%): LEDGER & MILESTONES                 │ RIGHT THIRD (~35%): CHOICES      │
│ ┌─────────────────────────────────────────────────────────┐ │ ┌───────────────────────────────┐ │
│ │ REAL CASH LEDGER (tagged to this boxer only)             │ │ │ ACTIVE ACTION (when open)     │ │
│ │ Wk │ Source                        │   In │  Out │  Net │ │ │ [Approach / Talk / Challenge] │ │
│ │ 18 │ Purse share (25%): vs Opp     │ +625 │      │ +625 │ │ │ Deadline, cash, loyalty, lock │ │
│ │ 17 │ Pro camp (6%, no S&C)         │      │ -150 │ -150 │ │ └───────────────────────────────┘ │
│ │ 17 │ Cutman (pro night)            │      │ -150 │ -150 │ │ ┌───────────────────────────────┐ │
│ │ 16 │ Scouting opponent             │      │ -250 │ -250 │ │ │ SAME-STATE FORECAST [8w|12w]  │ │
│ │ 12 │ Month-end bill (4w stipend)   │      │-1000 │-1000 │ │ │ Keep  │ Half │ DayJob │Rel.  │ │
│ │ ── │ ───────────────────────────── │ ──── │ ──── │ ──── │ │ │ Now $0 │ $0  │ $0    │+$1200│ │
│ │ REAL TOTALS (reconciled to cash):  │+$625 │-$1550│-$925 │ │ │ Bill   │-$X  │-$Y    │-$Z   │ │
│ │ Pending stipend (bills 28d): -$500 [ESTIMATE]           │ │ │ Low $  │     │       │      │ │
│ │ Win dues replay (+8 mem/+5 rep): +$195/8w [ESTIMATE]    │ │ │ Train  │83%  │67%    │Leaves│ │
│ └─────────────────────────────────────────────────────────┘ │ │ Loyal  │-4   │-8     │-3rep │ │
│ ┌─────────────────────────────────────────────────────────┐ │ │ [Btn]  │[Btn]│[Btn]  │[Btn] │ │
│ │ MILESTONES & CONDITIONAL NEXT BOUT                      │ │ │ (Disabled states show reason) │ │
│ │ • Turned pro (Bow Lane): start costs $1,245; debut +$X  │ │ └───────────────────────────────┘ │
│ │ • CONDITIONAL (unbooked): Top-10 bout ~$X net at 25%    │ │                                   │
│ └─────────────────────────────────────────────────────────┘ │                                   │
├─────────────────────────────────────────────────────────────┴───────────────────────────────────┤
│ BOTTOM STRIP (100%): CLUB CASH & CRISIS CONTEXT                                                 │
│ [8w/12w CashChart: solid past + baseline dashed + conditional toggle] · Next club bill: $X on D │
│ Club Overhead (shared, not in boxer): Rent/Power/Staff/Loans · Alert reason & action [→ Money]  │
└─────────────────────────────────────────────────────────────────────────────────────────────────┘
```

- Every button shows exact availability or why it is disabled (`"Held to <date> (approach lock)"`, `"Cannot release — bout booked"`, `"$X short"`).
- Hovering any number explains the exact rule and calculation.
- Bottom strip links back to `Club > Money` (All Boxers + 2–3 Boxer Compare + Overdraft / Crisis Levers).

---

## 11. Decision Probes to Prove It

Every probe runs from an identical seed and initial state, changing **one decision**, and checks `CashForecast`, `Sim.end_week`, `Leaving`, `ApproachWire`, and `StarDeal` rules (`TO BUILD` test fixtures):

| Fixture | Initial State | Decision Tested | Verified Outcomes (No Option Dominates Everywhere) |
|---|---|---|---|
| **1. Cash-rich amateur club** | `$40,000` cash, `3` amateurs (`$250/wk` each), `12w` | Keep all vs Release 1 weakest at Wk 6 | **Keep all:** lower cash by `6 × $250 = $1,500`, keeps `0` rep loss, `0` teammate hit, `3` boxers developing. **Release:** `+$1,500` cash + frees 1 slot, `-1` rep (`-3` ranked), `-2` loyalty on teammates `<50`. Keep wins on rep/depth; Release wins on cash/slot. |
| **2. Cash crisis (`$2,000` cash)** | `$2,000` cash, `4` amateurs (`$1,000/wk` stipends), unbooked | Keep all vs Half all (`set_half`) vs Day job 2 vs Release 2 | **Keep:** goes `< $0` at first month-end bill, risks `8w` closure. **Half all (`$500/wk` saved):** `83.3%` gain across 4, `-4` loyalty each, `0` rep loss. **Day job 2 (`$500/wk` saved):** `66.7%` on 2 / `100%` on 2, `-8` on 2, `0` rep loss. **Release 2 (`$500/wk` saved):** `100%` on 2, `-2/-6` rep, `-2` teammate loyalty, 2 boxers lost. Each trades cash, training, rep, and loyalty differently. |
| **3. Compulsory rest / no bout** | `1` amateur on 30-day stoppage suspension (`gain_mult = 0.25`) + 8-week matchmaking cooldown | Keep stipend (`$250/wk`) vs Half (`$125/wk`) vs Day job (`$0/wk`) for `8w` | **Keep:** `-$2,000` cash, `0` loyalty loss. **Half:** `-$1,000` cash, `-4` loyalty. **Day job:** `$0` cash, `-8` loyalty (can push `< 35` into rival approach). Keep wins on loyalty; Day job wins on cash. |
| **4. Shared-stipend approach (`Half` vs `Move`)** | `2` amateurs (`A` `< 35` approached, `B` on stipend loyalty `60`), `keep` offer | `ApproachWire.answer("half")` vs `("move")` | **Half:** `$0` extra wage, `A` `+6/+10`, `B` `-4` loyalty, both train at `0.925` (`sum 1.85`), locked `84d`. **Move:** `$0` extra wage, `A` `+12` & `1.0` training, `B` takes `day_job` (`4/6 ≈ 0.667` training, `sum 1.667`), `-12` loyalty now + `-3 × 3` grievance ticks (`-21` total). Half wins on team loyalty/sum gain; Move wins on `A`'s solo ceiling. |
| **5. Pro top-10 renegotiation (`Keep 25%` vs `Drop 20%`)** | Pro at `25%` share hits Top-10 (`StarDeal.terms("top10")`: `$2,500` bonus vs `20%`) | `Keep 25% (-$2,500)` vs `Drop 20% ($0)` | Delta = `5%` of purse (`camp_bill` cancels across both choices). At **`$5,000` purse** (`5% = $250/bout`): **`10` bouts = exact `$2,500` tie**; **`11+` bouts (`+$2,750`) wins for Keep**; `<10` bouts wins for Drop. At **`$1,500` purse** (`5% = $75/bout`): **`34` bouts** needed to break even (`33.33`), so Drop dominates financially. |
| **6. Pro release vs keep (`year_take = $3,000`)** | Pro at `25%` share, `$2,000` purse, no S&C coach, prior-year take `$3,000` | `Release now` vs `Keep for N bouts` | **Release:** `max($500, 3000 × 0.4) = +$1,200` immediate fee, `-3` rep (`-5` on leave), `-2` teammate loyalty `<50`. **Keep (`StarDeal.gym_net`):** `25% × $2,000 - 6% camp ($120) = $380/bout` (`$230/bout` with `$150` cutman). Over **`2` bouts** (`$460–$760`), Release wins on cash (`+$1,200`). Over **`6` bouts** (`$1,380–$2,280`), Keep wins on cash **and** preserves rep/loyalty. |
| **7. Win dues replay (`+8 members, +5 rep`)** | Gym A (`40/70` cap, `rep 30`, standard) vs Gym B (`68/70` cap, `rep 30`, standard) | Win (`+8 members, +5 rep`) vs No win | `Membership.settle_week()` over 8w gives real marginal dues (`Gym A >> Gym B` because Gym B hits `cap = 70` and decays excess). Never returns flat `"$65/wk"`. |
| **8. Guards, locks & cash reconciliation** | Any multi-boxer career over `52` weeks | Run full sim + random decisions | `sum(fid ledger) + sum(club ledger) + start_cash == career.cash` (**±$0**); `stipend_locked` blocks changes `84d`; `let_go` blocked when booked; `StarDeal` suppressed at `share <= 0.12`; `RivalOfferWire._charged` & `Not This Show` seasonal lock hold. |

---

## 12. Scope — What This Mechanic Does & Does NOT Do

### ✅ Does
- Records every cash movement in `Career.ledger` with `{d, w, t, amount, fid, kind, source}` across all 28 `.pay()` call sites plus split weekly income, split 28-day stipend/club bills, and overdraft interest (`TO BUILD`).
- Reconciles per-boxer rows + CLUB rows to `Career.cash` cleanly without mixing estimates into cash totals.
- Separates shared club overhead (rent, power, insurance, governing-body `$18/boxer/yr`, staff, kit, loans) into `CLUB`.
- Simulates `Keep / Half / Day Job / Release` (plus club-wide crisis levers) on the same state via `CashForecast.project(c, horizon, change)` with `8w / 12w` toggle, showing immediate release fees ON the projection.
- Computes win membership growth via `Membership.settle_week()` replay (`+8` members, `+5` rep) as a labelled club estimate.
- Unifies `Approach`, `RivalOffer`, `StarDeal`, and `ProCall` previews, refusal reasons, locks, and pro/low-loyalty edge cases with actual code rules.
- Wires alerts (`🔴 / 🟠 / 🟡`) directly to real fixes (`Club Levers`, `Fights > Ask for a fight`, `Stipends`, `Release`) with no duplicate/no-op controls.

### ❌ Does NOT Do
- No transfer market, buyout auctions, or post-release re-sign loops (`Region.left_tag` already tracks former fighters on rankings).
- No TV rights, merchandise, or unmodelled revenue streams.
- No exact break-even dates from unbooked future bouts (unbooked upside stays conditional/dashed).
- No fake `"Self-funding ✅"` badge on partial estimates or annualized `$X/year` projections from guessed bout rates.
- No manual `"Rest / Break"` status outside compulsory post-bout rest and injury (`Half` and `Day Job` already fill the middle steps).
- No `"Opportunity cost"` vs an invented average replacement boxer (real roster boxers are compared side-by-side instead).
- No manual `"Set review date"` snooze button on alerts (Monday already pauses time; alerts clear when solved).

---

## 13. Answers to Every Critic Review Item (V4 & V5 Lists)

| Critic Item (Priority Lists, Missing & Useless Options) | V6 Resolution |
|---|---|
| **Define complete accounting contract (`pay()` + `Sim.end_week` + split month bill + weekly income + overdraft)** | **Done (`Section 2`)**: Extended `Career.pay(amount, what, fid, kind, source)`, added weekly income ledger row, split 28-day month-end bills into per-boxer `stipend` rows + `club_bill`, tagged overdraft, exact reconciliation to `Career.cash`. |
| **Audit & tag all direct boxer `.pay()` sites (`Roster.turn_pro`, `Bouts` sparring & missed weight, `FightWeekPlan` sparring, `Injuries` pull-out, `Sim` twist, `Grapplers` entry, plus purse/tickets/camp/cutman/scout/bonus/release)** | **Done (`Section 1.2 & 2.1`)**: All 28 `.pay()` sites audited from opened code (15 athlete sites + 13 club sites, noting `Sim.gd:66` `heating` vs `photoshoot`). Promoter-covered pro costs (`costs_covered`) noted on debut without fake club cash debit; `GymDeals.year_take` switched from text substring to `fid + kind`. |
| **Make comparisons executable (`CashForecast.project(c, weeks, change)`) + Release fee ON projection + 8w/12w horizon** | **Done (`Section 5`)**: Added `change` dictionary on `_copy(c)` preserving 28d bill dates, rep-to-dues effects, overdraft, and immediate pro release fee on chart & comparison table; added `8w / 12w` toggle. |
| **Fix `Approach` mismatches (`Move` `0.85 -> 4/6`, `Promise` `+8 -> +14`, `Let Go` fee/rep/14d date, Pro/Debut groups) & `StarDeal` `10%` low-loyalty bug** | **Done (`Section 1.3 & 6`)**: Fixed all three preview mismatches against live `ApproachWire`/`GymSpend`/`Leaving` rules; separated `Pro` & `Debut` approach handling; suppressed invalid `< 12%` share talks in `StarDeal`. |
| **Fix `RivalOfferWire._free()` inversion & disable duplicate `Not This Show` after seasonal use** | **Done (`Section 1.3 & 6.2`)**: Renamed `_free` -> `_charged` with corrected boolean; disabled `"Not this show"` once `not_this_show_used` is true with `"use Pass instead"` reason. |
| **Fix Win dues replay (`+8 members` AND `+5 rep`)** | **Done (`Section 4 & Probe 7`)**: Replays `Membership.settle_week()` with both `+8` members and `+5` rep (`+10` short notice) against no-win baseline over 8 weeks. |
| **Fix Probe arithmetic (`$5,000` top-10 ties at 10 / wins at 11+; Release vs full `StarDeal.gym_net` over explicit bout count; Evening coach `$280` notice/wage not stopping `$350` classes)** | **Done (`Section 7.2 & 11`)**: All probe math verified directly against `StarDeal`, `StaffRoles.EVENING_WAGE ($280)`, `GameMoney.CLASSES_WITH_COACH ($350)`, and `Leaving.release_fee`. |
| **Remove useless/misleading controls (`Set review date` snooze, duplicate `Not This Show`, incomplete `Self-funding` badge, `Sort` counted as depth, ungrounded annual estimates)** | **Done (`Section 7.1, 8, 12`)**: Cut `Set review date` snooze, fake `Self-funding` badge, and annualized `$X/year`; kept column sorting as navigation only; kept conditional per-bout figures strictly labelled. |
| **Add `Wk + source` historical context, `Find Bout` from 🟠 row (`Ask for a fight`), achieved financial milestones, & release summary line on existing confirm dialog** | **Done (`Section 2.1, 7.1, 8, 9`)**: Added `w` + `source` on every ledger row, direct `Ask for a fight` jump from 🟠 alert, factual milestone log, and 2-line ledger summary in existing release confirm popup. |
| **1920×1080 Look B layout (name only in header, 2/3 dated ledger + estimates, 1/3 legal choices + deltas, bottom strip club/chart/alerts)** | **Done (`Section 10`)**: Specified exact 2/3 + 1/3 + bottom-strip layout with names strictly in header and explicit disabled/refusal reasons. |
| **Rejected critic items (1-line why not): Temporary `Rest/Break` status; `Opportunity cost` vs average replacement; Post-release re-sign loop** | **Cut (`Section 12`)**: `Half` (`5/6`) and `Day job` (`4/6`) already cover reduced-commitment states without inventing non-code rest mechanics; the game has no source for "average replacement" income; `Region.left_tag` already gives rival-club tracking without a transfer/re-sign market. |
