# TURNPRO1_V7 Design Review (Arena Critic)

SCORE depth=5 general=5

## 1. Verdict and Scores

### DEPTH: 5 / 10
`DESIGN_TURNPRO1_V7` moves the turning-pro design in the right direction on honesty and scope: it aligns two competing houses around a ticket forecast (`ProDebut` + `ProOfferWire`), uses real gym currencies (cash runway, member drift, loyalty cut, stipend savings, `WeekPhase` taper), keeps `ProLean` post-debut offer bias in view, and proposes calibrating opponent gaps (`-1.0` / `0.0` via `TURNGAP1`) and restoring the dead `"pro"` ambition path (`+5` / `-5` morale).

It stays below the 7+ bar because **four structural economic breaks leave the core decisions either dominated or disconnected**:

1. **`Costs from the purse` is not cash-flow relief with a `$100`/`$200` fee — it strictly dominates plain signing in gym cash in every reachable state.** `ProOfferWire.money` (`:120`) and `ProOfferWire.night` (`:134`) deduct `$1,245` signing costs plus the `$100`/`$200` fee from the **gross purse before the 25%/75% split**. Because the gym only keeps 25% of the purse (or 10% under 50 loyalty), subtracting `$1,345` from the gross purse shifts **75%–90% of the gym's licence/medical bill onto the boxer**:
   - Plain guarantee house (`$1,800` purse, `$1,245` costs, 25% share): gym pays `-$1,245`, gets `+$450` on debut night (**`-$795` net**); the boxer gets **`$1,350`**.
   - `Costs from the purse` (`$1,800 - $1,245 - $100 = $455` gross purse): gym pays `$0`, gets `25% × $455 = +$114` (**`+$114` net**); the boxer drops to **`$341`** (`-$1,009`), with **zero loyalty or morale penalty**.
   - V7 §6.3 claims *"A cash-rich gym takes the plain path for $100 back."* That arithmetic is wrong: a cash-rich gym taking plain loses **`$909`** on a first pro (or **`$884`** at the `$200` fee, and still **`$148`–`$123`** on a subsequent `$230` pro) compared to `Costs from the purse`. That is why `Costs` sweeps 74% of `TURNPROBE3B` forks (`no_ask` 0%) — it is free gym profit whenever that house calls.
2. **In the 46–74 band where both promoters call, one house strictly pays more across the entire overlap — and V7 miscomputed forecast 74.** V7 §3 asserts *"Bow Lane dominates at 74 ($1,850+ vs $1,800 flat)"*. Actually, at forecast 74, the guarantee house (`break_even 70`, `share 0.30`) is already 4 tickets past break-even (`4 × $50 × 0.30 = +$60`), so its plain gross is **`$1,860`** vs the ticket house's **`$1,850`** (`$1,500 + 14 × $50 × 0.50`). Across **every single integer from 46 to 74**, plain Harrow & Finch beats plain Bow Lane on gross purse + ticket share (`+$10` to `+$650`), carries zero shortfall risk, grants 2 extra prep weeks, offers an easier debut opponent (`1.5` vs `1.0`, or proposed `0.0` vs `-1.0`), AND unlocks the `+$909` `Costs` windfall. Only the ticket house's `Own price` ask (`$40` tickets, `+15` sales) lets Bow Lane beat plain H&F on gross (`$2,080` at 74), yet even then H&F + `Costs` beats Bow Lane net gym cash (`+$129` vs `-$725`).
3. **The promised post-debut contract differences (`+$500` vs `+$400` per win, `$3,000` top, and `0.9x` refusal compounding) do not exist after fight 1.** `Roster.turn_pro` stores `purse`, `purse_step`, `purse_top`; `BoutFinish` increments `f["purse"]` on wins; `ProWeekLines` promises *"each pro win adds $500 to the purse (top $3,000)"*. Yet `ProLadder.book()` (`ProLadder.gd:358`) and `ProFights` pay strictly from `Matchmaking.pay_of()` (`$1,500` unranked + rank bonuses + fan tickets), completely ignoring `f["purse"]`, `purse_step`, `purse_top`, and `0.9^n` decline factors. Only `ProLean`'s offer-mix bias survives the debut.
4. **The timing asks and wait mechanics break trade-off parity.**
   - `Later +2` (`-$150` purse) and `Later +4` (`-$300` purse) cannot earn back their purse cuts via member drift: at the `6 members/week` cap (`3 tickets/week`), 2 weeks yields at most `+6` tickets (`+$150` max at 50% share, `+$90` at 30%) and 4 weeks yields `+12` (`+$300` max at 50%, `+$180` at 30%) — zero upside at best, strictly negative on H&F or any cap-bound / stagnant club.
   - `Review later` (`0` loyalty cost, `0.9x` preserved only if prior declines exist, `+2` wins wait) strictly dominates `Stay amateur` (`-8` loyalty, `0.9^n` terms, `-5` morale if pro-ambitious, harder `9/11` or `#1` gate): a player can click `Review later`, immediately book an amateur fight before day 14, and let the offer lapse painlessly.

### GENERAL DESIGN: 5 / 10
V7's biggest strength is disciplined editorial honesty: separating `CODE` from `ESTIMATE` / `TO BUILD`, calling out prior unverified numbers, rejecting invented bloat (weather venues, extra milestone modals), and preserving the game's single-modal architecture.

It fails the 7+ General Design bar for five concrete reasons:

1. **V7's flagship `"Review later"` fix is dead on arrival against `Needs.gd:64`.** V7 §5.1 explicitly proposes closing the modal while keeping the offer live so the 14-day timer ticks down (`"no new screen, one flag"`). V7 missed that `Needs.needs()` (`Needs.gd:62–65`) tags `career.pro_offer` as `"red": true`, which puts it in `Needs.blockers()`, switches `CONTINUE` to `NEEDS YOU`, and makes `Main.on_go()` (`Main.gd:169–174`) refuse to advance a single day until the offer is answered. In the live game today, a human player **cannot advance time while an offer is open**, `Esc` (`Main.gd:237`) closes the modal into a deadlocked clock, and `Review later` would loop right back into the modal unless `Needs.gd:64` is changed.
2. **V7 inverts its own decline ladder in §5.5 and invents `"9+3 wins"` in §15.** `Roster.pro_ready` (`:186–195`) and `NextStep.gd` (`:88, :120–125`) track `pro_declines` (`0..3` used) while displaying `3 - pro_declines` (`3..0` left). V7 §5.5 reverses them (`0 left → full terms; 1 left → 9/11; 2 left → #1; 3 → closed`). Worse, §15 puts `"needs 9+3 wins and a top-3"` on the `Stay amateur` button — a formula that neither matches `7 + declines × 2` (`9` after 1st decline) nor the 2nd-decline rule (`rank == 1` with no win check).
3. **Financial lines in the offer modal misreport timing and contradict each other.** `ProOffer.gd:135` labels `mon["gym_at_signing"]` as `"The gym at signing"`, even though `ProCall.money:120` nets immediate `-costs` against future fight-night purse/ticket cuts received 4–8 weeks later (`BoutFinish.gd:106`). Meanwhile, the red footer line `THE GYM PAYS AT SIGNING: ... = -$1,245` (`ProOffer.gd:54–63`) ignores `costs_covered`, contradicting the card above it; `ProCall.pays_back_line` (`:143`) outputs `"1 weeks"` when `even_week == 1` and `"once your boxer is ranked"` for day-job boxers even when `gym_at_signing > 0`; and V7 §8 M5 hardcodes `"gym keeps $114, fee is $100"` instead of computing live from actual costs, loyalty, and runway.
4. **Pro-state leaks across existing UI files V7 lists as inspected (§18).** `FighterPage.gd:144` still reads `"Club stipend, $250 a week / Until: turning pro"` for pros; `MoneyPanels.gd:282–286` projects `+$450` amateur ticket cuts on booked pro bouts; `RosterTable.gd:44` renders amateur `w-l` plus `" pro"` instead of `pro_w-pro_l`; `NextStep.road` (`:46, :130–133`) marks Step 3 done after an offer lapses and prompts `"Sign the offer"` when no offer exists (`pro_wait_w` unread); and `ProCall.age_line(32+)` (`:322`) still claims *"First calls have stopped at 32"* on return calls where `make()` (`ProOfferWire.gd:26`) still lets them fire.
5. **Uncalibrated win-chance display and minor copy-rule slippage.** Showing `BoutRead.likely` (`45%` / `51%`) while `TURNGAP1` wins `67%` / `79%` leaves players staring at a ~25 pp contradiction until `BoutRead` is calibrated; and V7 §8 M4 places a house name inside card body copy rather than keeping organisation/person names strictly in headers.

### PLAY: 5 / 10
The build-up — tracking the 5-step Road, building ticket pull via members/wins/titles, weighing Nationals eligibility against an offer — gives genuine medium-term anticipation. Once the offer arrives, however, play collapses into a blocking pop-up where one promoter dominates the shared band, `Costs` silently taxes your boxer to pad gym cash, 4 of the 6 asks are clutter or negative-EV traps, and post-debut purse steps fail to materialize on the pro ladder. Day-job boxers (`3/180` in 104 weeks) barely participate in the loop at all. Fixing the cash-split, ladder purse wiring, blocking flag, and dual-house tension will make signing feel like a landmark managerial decision instead of an exploit or a pop-up chore.

---

## 2. Missing, Useless, and What Each Option Changes

### Missing Options (Player Needs, Not Present or Blocked)
1. **Working `"Review later"` (non-blocking pause/hold):** Currently blocked by `Needs.gd:64` (`"red": true`). Without turning this to non-blocking amber (blocking only on `days_left <= 0`), the player cannot finish a training week, check the Week/Prep/Fight tabs, book an amateur bout, or let the 14-day clock run down.
2. **Real post-debut purse differentiation on the Pro Ladder:** Choosing Bow Lane (`$1,500`, `+$500` step) vs Harrow & Finch (`$1,800`, `+$400` step) or taking `0.9x` decline terms needs to actually govern post-debut purses (`ProLadder.book()` / `offer_rows()`), otherwise contractual upside is fictional after night one.
3. **Live comparison of cash NOW (at signing) vs debut night vs weekly delta:** Separating what leaves the bank today (`-$1,245` / `$0`) from debut-night proceeds (`4–6 weeks out`), net boxer payout, and `"Next: +$500/win"` gives the player truthful cash-flow judgment.
4. **Honest cost-shifting consequence / repayment choice:** Either costs covered by the promoter are repaid from the *gym's* share (with real interest/runway pricing), or shifting costs onto the gross purse visibly costs boxer loyalty/morale (`-5` loyalty / `-5` morale) and states the exact `$` taken from the boxer.
5. **Day-job viability or explicit route expectation:** At `3/180` calls in 2 years, day-job routes need either an attainable gate (`6` wins any rank, or slower regional-rank access) or an explicit warning in `NextStep` / `Money` stipends so players do not chase an unreachable milestone.
6. **Live `"Own ticket price"` crossover delta + `"Later"` real upside:** Players need the actual dollar delta at current forecast (including the `+15` cap truncation above 85 and negative crossover above 92), and `Later +2`/`+4` need a genuine mechanical reason to exist (e.g., syncing the debut around an upcoming club show or avoiding an injury/fatigue rush, rather than futile ticket drift).
7. **Post-lapse clarity on `NextStep` and `ProCall.age_line`:** `NextStep` needs to read `pro_wait_w` (`"Next call after 2 more wins"`) instead of lighting `"Sign the offer"`, and `age_line` should not say *"First calls have stopped at 32"* when `declines >= 1`.

### Useless / Dominated Options Today & In V7
1. **`Softer opponent` ask (CUT in V7):** Useless (`0%` best in `TURNPROBE3B`); hides invisible `0.5` rating math while duplicating `ProLean`'s tune-up bias.
2. **`Better split` ask (CUT in V7):** Useless (`0%` best); dominated by `Own price` in the same `+5..+20` past-BE range, with an opaque `+0.5` opponent difficulty cost.
3. **Plain signing with Harrow & Finch when `Costs from the purse` is available:** Dominated for gym cash in **every** state (`-$795` vs `+$114` at `$1,245` costs; `+$220` vs `+$368` at `$230` costs) because the code deducts costs from the gross purse before the 25%/75% split.
4. **Plain Bow Lane vs plain Harrow & Finch in the 46–74 dual-offer band:** Dominated across the entire band (`$1,150..$1,850` vs `$1,800..$1,860`, worse debut opponent, 2 fewer prep weeks, no `Costs` option).
5. **`Later +4` (and `Later +2` on Harrow & Finch):** Negative or zero EV on ticket drift (`-$300` cut vs at most `+$180` H&F / `+$300` Bow Lane gross if drifting at max `6/wk` cap for 4 straight weeks). Useful only if it adds non-drift value (e.g. clearing fatigue/cutting weight or stacking a camp).
6. **`Stay amateur` once `Review later` works as specified in V7 §5:** Dominated (`-8` loyalty, `0.9^n` terms, harder `9/11` or `#1` gate, possible `-5` morale) vs letting the offer lapse in 14 days at `0` loyalty cost and `1.0x` terms.

### What Each Option Changes in Code & Gameplay

| Option | State / Numbers Changed Today | Should Change at 10/10 |
|---|---|---|
| **Sign (Ticket house — Bow Lane)** | `f["pro"] = true`; `weekly_salary = 0`; `-costs` cash now; `pro_house = "bow"`; debut in 4 wks (`Sat`), `opp_gap = 1.0` (V7 ESTIMATE `-1.0`); purse `$1,500` (`-$25`/under 60, floor `$500`) + `50%` >60; `gym_share` `25%` (`10%` if loyalty `<50`); `Loyalty +5`; `ProLean` adds extra step-up for 6 pro fights; `f["purse_step"] = 500` stored (unused by `ProLadder`). | Distinct **fast-track / high-upside** route: earlier debut (`4 wks`), stronger ticket share past lower BE (`50% >55` or `60`), higher post-debut win steps wired into `ProLadder` (`+$500/win`), harder debut (`~65–70%`) and step-up lean. |
| **Sign (Guarantee house — Harrow & Finch)** | Same pro switch, except `pro_house = "hf"`; debut in 6 wks (`Sat`), `opp_gap = 1.5` (V7 ESTIMATE `0.0`); purse `$1,800` guaranteed + `30%` >70 (`$1,860` at 74); `ProLean` adds extra tune-up for 6 pro fights; `f["purse_step"] = 400` stored (unused by `ProLadder`). | Distinct **safe-floor / steady-build** route: guaranteed purse `$1,600–$1,800`, higher BE (`75` so it stays flat inside 46–74 overlap), 6-wk prep (`+2` BUILD/PEAK wks), safer debut (`~75–82%`), slower post-debut step (`+$400/win` wired in `ProLadder`), tune-up lean. |
| **Ask: `Later +2` / `Later +4`** | Purse `-$150` / `-$300` (floor `$0`); `debut_weeks` `+2` / `+4` (moves `TAPER` week and `Membership` settle cycles before night). | Either tie to real prep value (no purse penalty on `+2` if boxer is injured/overweight, or allow a camp focus / cut without rush) OR cut `Later +4` and keep `+2` with live drift preview. |
| **Ask: `Own ticket price` (Bow Lane)** | `price = $40`, `extra_tickets = +15` (capped at 100); changes gross & split above `60`. | Same rule, plus recomputed live `$` delta on button (`+$` gain `<92`, `-$` warning `>=92`, exact truncated sales when `forecast > 85`). |
| **Ask: `Costs from the purse` (Harrow & Finch)** | Today: `$0` paid at signing; `costs + $100/$200` cut from **gross** purse before 25%/75% split (`+$909` gym profit, `-$1,009` boxer loss, `0` loyalty move). | Either deduct repayment from the **gym's share** across fights 1–3 (`$1,245 + $100/$200` fee) so plain costs less overall for cash-rich gyms, OR keep gross deduction with explicit `-8` loyalty / `-5` morale hit & live boxer-cost warning. |
| **Ask: `Softer` / `Split`** | `Softer`: `opp_gap +0.5`, `pro_tune_ups = 2`. `Split`: `+10%` share / `-0.5` gap or `+5%` share counter. | Keep hidden/cut from offer modal (`Softer` / `Split` removed from UI). |
| **`Stay amateur` (Refuse)** | `pro_declines +1`; `pro_last_house = offers[0]["key"]`; `pro_titles_at_decline = titles`; `Loyalty -8`; terms `0.9^declines`; raises gate (`9/11` at 1, `#1` at 2, closed at 3); clears `pro_offer`. | Same clear refusal cost (`Loyalty -8`, `0.9^n`, gate up) PLUS returns faster (`+1` win wait instead of `+2`, or preserves a clear advantage over lapse), AND records eligible houses sensibly. |
| **`Review later` / 14-day Lapse** | Currently unreachable in UI (`Needs.gd:64` blocks clock); in sim, clears `pro_offer`, sets `pro_wait_w = w + 2`, `0` decline/loyalty/morale, leaves `pro_last_house` unset. | Non-blocking amber need (`Needs.gd` red only when `days_left <= 0`), records calling house (`pro_last_house`) on lapse, costs `0.9x` OR longer cooldown (`+3` wins) so lapse does not strictly dominate `Stay amateur`. |

---

## 3. CODE CHECK (Required)

Every file named in V7 §18 plus supporting clock, UI, and matchmaking files was opened and verified directly against this checkout.

### A. Verified `CODE` Claims in `DESIGN_TURNPRO1_V7`
- `Roster.check_pro` (`Roster.gd:199–206`) lapses a pending offer first (`ProOfferWire.lapse_if_due`), checks `pro_ready`, `ProOfferWire.waited`, empty `f["bout"]`, and `not Champs.active(f)`. Called in `Sim.gd:414`, `BoutFinish.gd:213`, `Bouts.gd:456`.
- `Roster.pro_ready` (`Roster.gd:185–195`) blocks `pro` or `pro_declines >= 3` (`:186`), allows `nat_final` at 0 declines (`:188`), requires `rank == 1` at `pro_declines >= 2` (`:192–193`), otherwise `(w >= 7 + 2*d and rank in 1..3) or w >= 9 + 2*d` (`:191–195`).
- `ProCall.who_calls` (`ProCall.gd:63–69`) splits `<= 45` (`hf`), `46..74` (`bow` + `hf`), `>= 75` (`bow`) using `BAND := 15` (`ESTIMATE`, `:10`) around `ProDebut.BREAK_EVEN := 60`.
- `ProOfferWire.make` (`:24–39`) enforces `AGE_STOP := 32` only when `declines == 0` (`:26`), restricts to `[last]` when `declines > 0 and last != ""` (`:31–32`), and resets `0.9x` compounding when `titles > pro_titles_at_decline` (`:33`, `ProCall.terms` `:73–86`).
- `ProCall.expires` (`:336`, `WINDOW_DAYS := 14` `:15`) and `ProOfferWire.days_left` (`:61–62`).
- `Roster.debut_day` (`:320–321`) lands on the Saturday `weeks` out (`4` Bow Lane, `6` H&F); debut opponent uses `BoutRules.fight_power(f["stats"], {}, 0, "", true) - opp_gap` (`Roster.gd:302–306`; `ProCall.promoters` `:35–57` has `1.0` and `1.5`; `BoutRules.fight_power` `:294`).
- `ProDebut` (`:3–15, :18–49`): `$230` licence, `$875` medicals, `$140` corner licence (`$230/$370/$1,105/$1,245`), `100` seats at `$50`, `20 + floor(0.5*members) + 2*wins + 10*titles` (`ProOfferWire.forecast` `:19` adds `followers`), `MANAGER 0.15 + TRAINER 0.10 = 0.25`.
- `ProCall.money` (`:112–140`): computes `by_debut` (`:125`, never shown), `weekly_after = (stipend if stipend_paid else 0) - 75` (`LOST_CUT_A_WEEK := 75` `:13`), and `pays_back_line` (`:143–147`).
- `ProCall.asks` (`:151`), `ask_answers` (`:156–194`), `later2`/`later4` (`:197`), `softer` (`:204`), `split` (`:211`), `price` (`:242`, `$40`, `+15`, Bow Lane only, cap 100 in `ProOfferWire.money`/`night`), `costs` (`:263`, H&F counter, `$100` if runway `>= 8` else `$200`).
- `Loyalty.pro_share` (`Loyalty.gd:230`): `0.10` under `SETTLED_AT := 50`, enforced in `Roster.turn_pro` (`:287–290`) before applying `turn_pro` (`+5`); `decline_pro` (`-8`, `Loyalty.gd:61`). No loyalty key exists for `costs`.
- `Recruit.ambition` (`Recruit.gd:122–126`) never contains `"pro"`, leaving `ProCall.ambition_kind` (`:312`) `"pro"` branch unreachable; only `title` before nationals (`-5`) fires (`ProCall.morale` `:298`, `ProOfferWire.morale` `:154`).
- `DayJob.count_of` (`DayJob.gd:37–40`) returns `2`/`1`/`0` (`0` for pro); no day-job gate exists in `pro_ready` or `ProOfferWire`.
- `ProOffer.gd:54–63` (`PaysNow` red summary) does not update when `costs_covered` is taken; `ProOffer.gd` never uses `BoutRead`.
- `Needs.flags` (`Needs.gd:162–163`, rendered `Shell.gd:153`) is static red `"PRO OFFER"` with no countdown; `Needs.needs` (`:62–65`, `_pro_line` `:194`) carries the days-left line; `WeekReview.gd:152` → `ProWeekLines.rows` (`:62`) renders 4-week cut/stipend + debut ledger + `NEXT:`; `BoutHistory._milestone` (`:67–71`) renders `"TURNED PRO WITH <HOUSE>, <DATE>"`; `ProLean.extra` (`:12–33`) and `line` (`:41–47`) apply `LEAN_FIGHTS := 6` and consume `pro_tune_ups`.
- `Career.pro_offer` (`Career.gd:47`) and fighter dicts serialize through `SaveGame.to_dict`/`from_dict` (`SaveGame.gd:20–58`).

### B. Wrong, Contradicted, or Missed `CODE` Claims in `DESIGN_TURNPRO1_V7`

1. **V7 §1.5 & §5.1 miss that `Needs.gd:64` blocks the clock completely while `pro_offer` is open (and misstate modal closing):**
   - V7 §1.5 says *"There is no 'review later' close action and no selectable 'let it run out'; a player can only wait for the clock to stop"*.
   - In code, `Main.gd:237–240` ALREADY allows `Esc` to close `prooffer`, **AND `Needs.needs()` (`Needs.gd:62–65`) emits `"red": true` for `career.pro_offer`**. `Needs.blockers()` (`:135–136`) + `Main.on_go()` (`:169–174`) prevent `CONTINUE` from running any days whenever a red blocker exists. Thus a live player **cannot** wait out the 14-day window today, and V7 §5.1's *"Review later — no new screen, one flag, stays live as coded"* **breaks completely** unless `Needs.gd:64` is changed from `"red": true` to `"red": false` (except on expiry day).

2. **V7 §2, §6.4 & §10.1.4 treat post-debut purse steps (`+$500` / `+$400`, `$3,000` top, `0.9x`) as live career mechanics — they are dead code on `ProLadder`:**
   - `Roster.turn_pro` (`Roster.gd:296–298`), `BoutFinish.gd:113`, `ProOffer.gd:129`, and `ProWeekLines.gd:49` all store, increment, or display `f["purse"]`, `f["purse_step"]`, and `f["purse_top"]`.
   - Yet `ProLadder.offer_rows()` (`ProLadder.gd:281`), `ProLadder.book()` (`ProLadder.gd:358`), `ProLadder.offer_axes()` (`:227`), and `ProFights.gd` (`:131, :211`) **never read `f["purse"]`, `purse_step`, `purse_top`, or `terms`** — they compute purses solely from `Matchmaking.pay_of(e, opp)` (`Matchmaking.gd:215–225`).

3. **V7 §6.3 misreads its own code arithmetic on `Costs from the purse`:**
   - V7 §6.3 claims *"A cash-rich gym takes the plain path for $100 back."*
   - False by the code formulas (`ProOfferWire.money:120`, `ProCall.money:118–123`, `ProOfferWire.night:134`): subtracting `$1,245 + $100` from the gross purse before the 25%/75% cut leaves the gym with `+$114` total net vs `-$795` plain (**`+$909` profit to the gym**, paid out of the boxer's `$1,350 → $341` share!).

4. **V7 §3 miscomputes Harrow & Finch at forecast 74 (`"$1,800 flat"` vs true `$1,860`):**
   - V7 §3 asserts *"Bow Lane dominates at 74 ($1,850+ vs $1,800 flat)"*. Actually `ProCall.money` gives H&F `$1,800 + (74 - 70) × $50 × 0.30 = $1,860`, beating Bow Lane's `$1,850`. Plain Bow Lane never beats plain H&F inside the 46–74 dual-offer band.

5. **V7 §5.5 inverts `declines left` vs `pro_declines` used, and §15 writes an impossible `"9+3 wins"` rule:**
   - §5.5 maps `0 left → full terms; 1 left → 9/11 wins; 2 left → #1; 3 → closed`, flipping `3 - pro_declines` (`ProOffer.gd:41`, `NextStep.gd:88`) upside down.
   - §15 writes `"needs 9+3 wins and a top-3"`, which does not exist in `Roster.pro_ready` (`:191–193`: `7 + declines × 2` = `9` at 1 decline; `rank == 1` only at 2+ declines, with no win minimum).

6. **V7 §1.7 & §9.18 falsely claim `NextStep` has `"no decline-adjusted requirement text"`, while missing a real lapse bug in `NextStep`:**
   - `NextStep._need_for(3, ...)` (`NextStep.gd:120–125`) **already** renders decline-adjusted requirements (`PRO_WINS + pro_declines * PRO_RETURN_WINS`, `pro_declines >= 2` → `"Only a No. 1 ranking..."`, `>= 3` → `"No more offers..."`), fed by `FighterPage._road_input` (`:336`).
   - What `NextStep.road()` actually gets wrong is **failing to check `pro_wait_w` (`ProOfferWire.waited`)**: after an offer lapses (`pro_declines` stays `0`, `pro_wait_w = w + 2`), `Roster.pro_ready` stays `true`, so `NextStep.road()` marks Step 3 (`Pro offer`) **done** and tells the player `"Sign the offer"` on Step 4 even though no offer exists! (Also, if `w == 10` unranked with `1` decline, `_need_for` at `:127` prints `"0 more wins and a top-3 ranking, or 1 more wins"`.)

7. **V7 missed four bugs in the §18 files it listed as opened:**
   - `ProOffer.gd:135` labels `mon["gym_at_signing"]` as `"The gym at signing"`, conflating today's `-costs` outlay with fight-night purse/ticket cuts received 4–8 weeks later (`BoutFinish.gd:106`).
   - `ProCall.age_line(age)` (`ProCall.gd:322–324`) prints `"First calls have stopped at 32."` on `2nd`/`3rd` calls where `ProOfferWire.make` (`:26`) still permits calls.
   - `ProCall.pays_back_line` (`ProCall.gd:143–147`) prints `"1 weeks"` grammar error when `even_week == 1`, and `"once your boxer is ranked"` for day-job boxers even if `gym_at_signing >= 0`.
   - Pro leaks in existing UI: `FighterPage.gd:144` hardcodes `"Club stipend, $250 a week / Until: turning pro"` for pros; `MoneyPanels.gd:282–286` shows `+$450` club ticket cut on pro bouts; `RosterTable.gd:44` shows amateur `w-l` + `" pro"` instead of `pro_w-pro_l`.

8. **Minor line/detail inaccuracies in V7:**
   - §1.1 cites `ProOfferWire.lapse_if_due` as `:172–184` (actually `:172–183`; `waited` begins at `:186`) and omits that `Roster.check_pro` returns early at `:204` after a lapse without generating a new offer that tick.
   - §8 M3 cites `ProOffer.gd:22–47` for header block (`_tickets` call is at `:44`; `build` continues to `:79`).
   - §1.5 cites `"Purse floors at $0 only via the later-ask path"` — true for `terms()`, though `debut_purse` (`:109`) floors Bow Lane's shortfall purse at `$500` (`maxi(reduced, PURSE_FLOOR)`).

### C. Code Files Read
- Rules: `scripts/rules/ProCall.gd`, `scripts/rules/ProDebut.gd`, `scripts/rules/BoutRead.gd`, `scripts/rules/Recruit.gd`, `scripts/rules/Loyalty.gd`, `scripts/rules/DayJob.gd`, `scripts/rules/StarDeal.gd`, `scripts/rules/Membership.gd`, `scripts/rules/WeekPhase.gd`, `scripts/rules/GameMoney.gd`, `scripts/rules/GymBills.gd`, `scripts/rules/BoutRules.gd`, `scripts/rules/BoutBurn.gd`, `scripts/rules/NextStep.gd`, `scripts/rules/Matchmaking.gd`, `scripts/rules/SeasonPath.gd`, `scripts/rules/GymPeople.gd`.
- State: `scripts/state/ProOfferWire.gd`, `scripts/state/Roster.gd`, `scripts/state/Needs.gd`, `scripts/state/SaveGame.gd`, `scripts/state/Career.gd`, `scripts/state/Champs.gd`, `scripts/state/ProLean.gd`, `scripts/state/ProLadder.gd`, `scripts/state/Sim.gd`, `scripts/state/BoutFinish.gd`, `scripts/state/Bouts.gd`, `scripts/state/GymSpend.gd`, `scripts/state/Clock.gd`.
- World & UI: `scripts/world/WorldNews.gd`, `scripts/ui/Main.gd`, `scripts/ui/MainFlow.gd`, `scripts/ui/modals/ProOffer.gd`, `scripts/ui/modals/WeekReview.gd`, `scripts/ui/ProWeekLines.gd`, `scripts/ui/ProFights.gd`, `scripts/ui/TicketBar.gd`, `scripts/ui/BoutHistory.gd`, `scripts/ui/MoneyPanels.gd`, `scripts/ui/RosterActs.gd`, `scripts/ui/Shell.gd`, `scripts/ui/HomeNeeds.gd`, `scripts/ui/areas/FighterPage.gd`, `scripts/ui/RosterTable.gd`, `scripts/ui/areas/Fights.gd`, `scripts/ui/areas/World.gd`.
- Research & Probe Inputs: `ops/research/TASK_TURNCRITIC7A.md`, `ops/research/DESIGN_TURNPRO1_V7_CRITIC_BRIEF.md`, `ops/research/CRITIC_ACCESS.md`, `ops/research/TURNPROBE3_READ_S530.md`, `docs/TURNGAP1_RESULT.md`, `docs/TURNPROBE3_RESULT.md`, `tools/turn_pro_probe3_fork.gd`.

---

## 4. To reach 10/10 (Most Important First)

### 1. Fix `Costs from the purse` so it stops exploiting the boxer for free gym profit (`ProOfferWire.gd`, `ProCall.gd`, `Roster.gd`, `ProOffer.gd`)
- **Stop deducting the gym's signing costs from the gross purse.** Either:
  - **(a) Recommended — Recoup from the gym's purse cut across bouts 1–3:** Promoter fronts `costs` (`$0` paid at signing). At debut and subsequent pro bouts, `costs + fee` (`$100` runway `>= 8`, `$200` runway `< 8`) is repaid solely out of the **gym's share** (`25%` / `10%`), leaving the boxer's `75%`–`90%` purse untouched. Track `f["pro_debt"]` on `Roster.turn_pro` and settle in `BoutFinish.gd` before crediting `c.pay()`. Now a cash-rich gym genuinely prefers Plain (`+$100`/`+$200` saved), while a cash-poor gym borrows survival liquidity against future cuts.
  - **(b) Alternative — Keep gross-purse deduction with real boxer backlash:** Deducting from gross purse explicitly applies `Loyalty -8` (`"costs_on_boxer"`) and `morale -5`, and prints `"Boxer pays 75% of your bills (-$1,009 off their debut purse; loyalty -8)"` on the button.
- Fix `ProOffer.gd:54–63` (`PaysNow`) so taking `Costs` updates the bottom signing-cash line to `$0 due at signing`, and split `ProCall.money` / `ProOffer.gd:135` into **`Cash at signing`** (`-$1,245` or `$0`) vs **`Gym on debut night`** (`+$313..+$500`), eliminating the current time-travel lie.

### 2. Unblock `"Review later"` in `Needs.gd` and price Lapse vs `Stay amateur` honestly (`Needs.gd`, `ProOfferWire.gd`, `Roster.gd`, `NextStep.gd`)
- In `Needs.gd:62–65`, set `"red": ProOfferWire.days_left(career) <= 0` so a pending offer stays an amber sticky note and top-bar flag without locking `CONTINUE`. When `days_left` hits `0` (or at `end_week` on `c.day >= expires`), `lapse_if_due` runs cleanly in live play (`Main.on_go` / `Clock.step`).
- Add a **`Review later`** footer button (`Main.close_modal()`) that leaves `c.pro_offer` open and visible on Home/shell.
- Fix the **Review-later vs Stay-amateur parity**: today `Review later` (`0` loyalty cost, `1.0x` terms) strictly dominates `Stay amateur` (`-8` loyalty, `0.9x` compounding, harder rank/win gate). Make lapse/expiry cost real ground:
  - Record `pro_last_house` (`ProOfferWire.on_decline` logic) and require **`RETURN_WINS := 3`** (`+3` wins wait) on lapse, while reducing `Stay amateur` to **`RETURN_WINS := 1` or `2`** with explicit house lock and `-8` loyalty / `0.9x` terms — OR apply `-4` loyalty + `0.9x` terms on lapse too so expiry is not a free dodge.
- Fix `NextStep.gd:46` & `FighterPage._road_input` (`:336`) to pass and check `pro_wait_w`: when `!pro_offer.is_empty()` show `"Offer open (N days left)"`; when `pro_wait_w > w` keep Step 3 (`Pro offer`) lit with `"Promoter returns after N more wins"` (matching `pro_declines >= 2` `"No. 1 ranking"`). Fix the `3 - pro_declines` inversion in docs/copy so `pro_declines == 0 -> 3 left (full terms)`, `1 -> 2 left (9/11 wins, 0.9x)`, `2 -> 1 left (#1 only, 0.81x)`, `3 -> 0 left (closed)`.

### 3. Make Bow Lane vs Harrow & Finch a genuine career choice across the 46–74 overlap (`ProCall.gd`, `ProLadder.gd`, `BoutFinish.gd`, `ProLean.gd`)
- **Wire `f["purse"]`, `f["purse_step"]`, `f["purse_top"]`, and `0.9x` terms into `ProLadder.book()` & `ProLadder.offer_rows()` (`ProLadder.gd:281, :358`) and `ProFights.gd`:**
  Use `maxi(int(f["purse"]), MM.pay_of(e, opp)["purse"])` or a promoter-contract base (`f["purse"]` + rank/opponent draw bonus scaled by `terms`) so Bow Lane's `+$500/win` step vs H&F's `+$400/win` step (and `0.9^n` decline cuts) actually show up in post-debut paychecks and `ProWeekLines.next_line` stops lying.
- **Re-price H&F's debut break-even/purse so plain Bow Lane is actually competitive inside 46–74:**
  Raise H&F `break_even` from `70` to `75` (or lower H&F debut purse from `$1,800` to `$1,650`) while keeping Bow Lane at `$1,500` / `break_even 60` / `50%` share (or `55` BE). At H&F `$1,800` / `BE 75`, Bow Lane passes H&F in gross pay at forecast **`67`** (`$1,675` vs `$1,800` at `BE 75`; `$1,850` at `74`), splitting the `46–74` dual-offer band right down the middle: `46–66` favors H&F safety, `67–74` favors Bow Lane upside + earlier debut + faster `+$500` steps.
- **Install and probe the `opp_gap` targets (`ProCall.promoters`):**
  Change `bow.opp_gap` from `1.0` to **`-1.0`** and `hf.opp_gap` from `1.5` to **`0.0`**, then run `TURNGAP2` in the real `Roster.turn_pro` → `BoutFinish` path (`n >= 200` per house) to verify debut win rates hit `62–72%` vs `75–83%` and align `BoutRead.likely`/`band` within `10 pp` before displaying numeric win % on the offer card.

### 4. Fix the asks and the dead `"pro"` ambition (`ProCall.gd`, `ProOffer.gd`, `Recruit.gd`)
- **Hide `softer` and `split`** in `ProOffer.gd:_ask` (keep backend support only if needed by saves).
- **Rework `Later +2` / `Later +4`:**
  - Cut `Later +4` completely unless it buys a genuine mechanical edge; member drift (`6/wk` max) cannot repay `-$300`.
  - Keep **`Later +2`** at `$0` or `-$100` purse cut **only when it solves real pre-fight prep** (e.g., lets a boxer finish healing an injury, drop `>= 1 kg` over weight cleanly, or land a `Build + Peak` camp week instead of jumping straight into a short prep), and show on the button: `Debut Sat <date> · Est. <lo>–<hi> tickets (<cap note>)`.
- **On `Own ticket price` (Bow Lane):** Compute the exact live dollar impact at the current `forecast`: show `+$X gross (+$Y gym) at N sold` when `< 92`, warn `Cap-clipped: gains only +K seats` when `86..91`, and show `Loses -$X vs plain at N sold` when `>= 92`.
- **Wire boxer voice (`Recruit.gd:122`):** Update `ambition(f)` so non-title recruits (`pot < 78` with `bouts > 0`) return `"A career in the pros"` (matching `ProCall.ambition_kind` `"pro"`), turning `+5` sign / `-5` stay morale live, and fix `ProCall.age_line` (`:322`) to suppress *"First calls have stopped at 32"* when `pro_declines >= 1`.

### 5. Address the day-job dead end and clean up pro UI leaks (`Roster.gd`, `FighterPage.gd`, `MoneyPanels.gd`, `RosterTable.gd`, `ProWeekLines.gd`)
- **Day-job gate:** Either add a separate `pro_ready` allowance for day-job boxers (`w >= 6 and ranked` or `w >= 7` any rank, verified at w104/w156 in probe) OR explicitly tell the player on `NextStep` & `Money → Stipends` (`"Day-job boxers build slowly (~6 wins in 2 years; half or full sponsorship reaches 7+ wins)"`).
- **Clean up existing pro UI leaks:**
  - `FighterPage.gd:144`: replace hardcoded `"Club stipend, $250 a week / Until: turning pro"` with real status (`Pro: <share>% cut` / `Half stipend $125` / `Day job`).
  - `MoneyPanels.gd:282–286`: stop showing `+$450` amateur ticket cut for booked pro bouts (show expected gym cut of `b["purse"]`).
  - `RosterTable.gd:44`: display `pro_w-pro_l` (with amateur record in tooltip) once `pro == true`.
  - `ProWeekLines.gd:36–44`: add `forecast N → sold N` on the debut ledger line and fix `ProCall.pays_back_line` `"1 weeks"` singular grammar.

---

## 5. 1920×1080 Page Description (10/10 Proposal)

One warm-plaster gym-wall modal sitting over the existing shell (no new screen, no extra chrome; person and house names appear in headers only, body text says `"your boxer"`, `"the promoter"`, `"the opponent"`):

- **Top Header Strip (Full Modal Width):**
  - Left: small caps kicker (`A CALL FROM ...` listing the calling promoter(s)), bold display title **`TURN <FIRST> PRO?`**, and a tight 1-line summary: amateur record, regional rank, age warning only if `>= 29` on first call (`Age 29: first calls stop at 32`), and exact declines remaining (`Declines left: 3 of 3 — next refusal: 9 wins top-3 at 0.9x`).
  - Right: expiry pill **`Offer stands 14 more days`** (amber; turns red with **`Last day`** on day 0), plus a disposable text link **`Check week & weight`** that jumps to the existing Fighter Week/Prep tab without losing the offer.

- **Main Comparison Body (Two Equal Cream Paper Cards side by side when forecast 46–74; single centred card when `<= 45` or `>= 75`):**
  - **Card Header:** Organisation badge + house name in caps only here (`HARROW & FINCH BOXING` / `BOW LANE PROMOTIONS`), plus a one-tag contract style badge (`GUARANTEE · SAFE START` vs `TICKET SPLIT · FAST TRACK`).
  - **Shared Debut Ticket Strip (sitting immediately above or spanning the cards):** 100-seat segmented bar (`TicketBar`) showing guaranteed buyer blocks (`Family 20`, `Members`, `Amateur wins`, `Titles`, `Club show crowd`) against each house's break-even marker (`60` vs `75`), plus one line: **`Sold today: 64 · At debut (4–6 wks): est. 64–70 (cap 100)`**.
  - **Contract Terms Block (per card):**
    - **Debut Purse & Risk:** `$1,800 guaranteed` OR `$1,500 (-$25/ticket under 60, min $500)`.
    - **Ticket Share:** `30% past 75` OR `50% past 60` (`$N est. today`).
    - **Debut Date & Camp:** `Sat <Date> (6 wks — 2 Build, 1 Peak, 1 Taper)` vs `Sat <Date> (4 wks — faster turn)`.
    - **Opponent Read:** `Unscouted debutant — about 72–82% to win (ESTIMATE)` vs `about 62–72% to win (ESTIMATE)` (no raw gap floats).
    - **After the Debut (wired to `ProLadder`):** `+$400/win to $3,000 · tune-up bias for first 6 pro fights` vs `+$500/win to $3,000 · step-up bias for first 6 pro fights`.
  - **Money Split Block (Timing Separated Truthfully):**
    - `Cash at signing:` **`-$1,245`** (licence/medicals/corner) — updates live to **`$0`** if deferred.
    - `Gym on debut night:` **`+$450`** (25% share, or 10% if loyalty `<50` with inline reason).
    - `Boxer on debut night:` **`+$1,350`** (75% share; updates live if any debt/cost shifts).
    - `Weekly club change:` **`+$250/wk stipend saved, -$75/wk avg ticket cut lost (= +$175/wk)`** (or `-$75/wk` for day-job).
  - **One Ask Well (Inside Each Card — Actionable Only):**
    - Header: **`ONE ASK (pick one — opponent/house rules shown live)`**.
    - Clean 2-button or 3-button stack (`Softer` and `Split` hidden):
      - `Later +2 weeks` → live projection: `Debut <Date>, -$100 purse, est. +0 to +6 seats`.
      - On Ticket House: `Own ticket price ($40, +15 seats)` → live projection: `At 64 today: +$180 gross (+$45 gym)` (turns amber/red warning `At 95 today: loses -$75 gross vs plain` above crossover 92; disabled reason above 100 cap).
      - On Guarantee House: `Cover signing costs now` → live projection: `$0 paid today; $1,245 + $100 fee repaid from gym's 25% cut over ~3 bouts (boxer keeps full $1,350)` — or greyed with exact reason on the ticket house (`Ticket house won't front signing costs`).
    - Spent state replaces the grid with the promoter's answer and, if countered, **`Back to plain terms (ask stays spent)`**.
  - **Card-Local Action Button:** Solid primary **`Sign`** button (no house name inside button text; shows `(morale +5)` or `(morale -5, before nationals)` only when non-zero).

- **Narrow Boxer & Route Strip (Below the Cards):**
  - Left: **`Ambition:`** `Wants the pros (signing +5 morale / staying -5)` or `Chasing nationals title first (signing -5 morale until nationals finish)`.
  - Middle: **`Route:`** `Full stipend ($250/wk — ends on signing)` / `Half stipend ($125/wk, 5 of 6 mornings)` / `Day job (4 of 6 mornings)`.
  - Right: **`Why these calls:`** `Forecast 64 sits inside 46–74, so both promoters called` (or `Forecast 80 cleared 75 — only the ticket house called`).

- **Footer (Honest Refusal & Exit Parity):**
  - Left muted summary: **`What ends: club stipend, amateur bouts & rankings, $450 amateur ticket cuts.`**
  - Right action pair:
    - **`Review later`** (`BtnQuiet`) — subtitle: `Closes window; offer stays open 14 days; expires after 3 more wins if unanswered`.
    - **`Stay amateur`** (`BtnQuiet`) — subtitle: `Loyalty -8 · Next call at 0.9x · Needs 9 wins top-3 (or 11 any)` (updates dynamically for 1st/2nd/3rd refusal; shows morale `-5` if applicable).
  - **Explicit Non-Goals:** No extra signing-ceremony modal, no licence serial numbers, no weather/venue system, no dialogue trees, no uncalibrated point-estimate win odds, and no top-bar countdown duplicating the Home/modal expiry counter.
