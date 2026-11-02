# TASK ECONBAL1 - Ludo's approved economy numbers as pure rules: undercard rate, income yield formulas, staff pay tier effects

Model: Arena (cloud, FightCamp-lite, pure modules). Discipline: BOXING (demo) - gym economy, GYMBUILD step 3.
Operator S281 board Q-S277-3: "Yes, build the verdict." The numbers + the verdict: research/LUDO_S281_ECONOMY_NUMBERS.md
(read it whole - the verdict section at the end says what is built NOW and what waits). Claude wires these into the career later.

## Spec
A) NEW Godot/scripts/rules/EconomyBalance.gd (extends RefCounted; no preload except rules/StartEconomyRules.gd; no file I/O):
1. Undercard constants with Ludo's names: UNDERCARD_SAVE_COOLDOWN_DAYS 28, UNDERCARD_SAVE_BASE_CHANCE_WEEKLY 0.15,
   UNDERCARD_SAVE_MAX_CHANCE_WEEKLY 0.40, UNDERCARD_SAVE_REP_WEIGHT 0.002, UNDERCARD_SAVE_ROSTER_WEIGHT 0.03.
   `static func undercard_weekly_chance(reputation: int, pro_boxers: int) -> float` = min(0.40, 0.15 + rep x 0.002 + pros x 0.03).
   `static func undercard_available(facts: Dictionary) -> bool`: true only when facts.free_fresh_pros >= 1 (a pro not booked within
   14 days with acute fatigue < 60 - the CALLER counts them) AND (facts.day - facts.last_undercard_accepted_day) >= 28 (missing = never).
2. Yield factors (each returns t in [0, 1], clamped; inputs 0-100 unless named):
   `pads_t(pad_skill, reputation)` = 0.60 x pad_skill/100 + 0.40 x reputation/100  (VERDICT: reputation stands in for Ludo's gym
   cleanliness - no cleanliness meter exists; keep a comment saying so);
   `circuit_t(bag_line_avg_condition, reputation)` = 0.50 x cond/100 + 0.50 x rep/100;
   `sparring_t(rounds_logged, win_rate01, guard, head_movement)` = 0.40 x min(1, rounds/50) + 0.30 x win_rate01 + 0.30 x (guard+head)/200;
   `undercard_t(reputation, boxer_ovr)` = 0.50 x rep/100 + 0.50 x clamp((ovr - 40)/30, 0, 1).
3. Pay tiers: `const WAGE_TIER_DATA` keyed by the StartEconomyRules tier ids ("underpaid","market","competitive","elite") with
   wage_mod, morale_drift_weekly, skill_growth_mult, coaching_gain_mult, poach_risk_weekly, quit_morale_threshold exactly as Ludo's table
   (market quits < 10, underpaid < 20, competitive/elite 0 = never). wage_mod must equal StartEconomyRules.pay_tiers() values (the test
   checks both modules agree).
   `static func morale_after_week(morale: float, tier_id: String) -> float`: underpaid -4.0; market moves 0.5 TOWARD 65 (never past
   it); competitive +2.5 capped at 85; elite +5.0 capped at 100; result clamped 0-100. Unknown tier = market.
   `static func coaching_gain_mult(tier_id: String, on_specialty: bool) -> float`: 0.90 / 1.00 / 1.08 / 1.15, specialty 1.15 x that
   - exact specialty values, a lookup table, no rounding code: underpaid 1.035, market 1.15, competitive 1.24, elite 1.32 (Ludo).
   `static func quits(morale: float, tier_id: String) -> bool`: morale < quit_morale_threshold (0 never quits).
   skill_growth_mult and poach_risk_weekly are DATA ONLY (verdict: the systems that would read them do not exist yet).
B) EDIT Godot/scripts/rules/IncomeOffers.gd (merged S281, 07054396): after month 1 the undercard offer rolls
   `EconomyBalance.undercard_weekly_chance(facts.reputation, facts.pro_boxers)` instead of UNDERCARD_CHANCE_AFTER_MONTH1 (remove that
   constant), gated by `undercard_available(facts)`; each channel's pay uses its own t from (A) when the facts carry the inputs
   (facts.pad_skill, facts.bag_line_condition, facts.rounds_logged, facts.win_rate01, facts.guard, facts.head_movement, facts.boxer_ovr),
   else falls back to facts.quality01 as today. Month 1 keeps "at most one" exactly as now. Banner stays a flat 800.

## Test - Godot/tests/economy_balance_test.gd (extends SceneTree, PASS/FAIL, last line `ECONOMY_BALANCE failures=<n>`, quit(1) on any)
Every constant against Ludo's table; undercard chance at (0,0)=0.15, (50,1)=0.28, (100,9)=0.40 cap; available false at cooldown day 27,
true at 28, false with 0 free pros; each t at its corners and one mid point (Ludo's examples: pad skill 30 + rep 10 -> pay near $120;
75-guard journeyman 40 rounds -> $540-$600 band); morale_after_week for each tier incl. market from 80 -> 79.5 and from 50 -> 50.5,
caps 85/100, floor 0; coaching mults incl. specialty; quits at 19 vs 20 underpaid, 9 vs 10 market, never for elite at 0;
WAGE_TIER_DATA.wage_mod == StartEconomyRules pay tiers. ALSO keep Godot/tests/income_offers_test.gd green, updating ONLY its
undercard-after-month-1 cases to the new rule (state which cases changed in the PR body).

## Contract
OWNS: Godot/scripts/rules/EconomyBalance.gd, Godot/scripts/rules/IncomeOffers.gd, Godot/tests/economy_balance_test.gd, Godot/tests/income_offers_test.gd
RED_TEST: Godot/tests/economy_balance_test.gd -> ECONOMY_BALANCE failures=0
REGRESSION: income_offers_test, start_economy_rules_test
VISUAL: no

PR body: `RESULT: tests/economy_balance_test.gd -> ECONOMY_BALANCE failures=0` + each regression's last line. Never delete or weaken a test
except the named undercard cases the new rule replaces.

## Prior research
LUDO_S281_ECONOMY_NUMBERS.md (approved Q-S277-3), TASK_INCOMEOFFERS1.md, TASK_STARTECON1.md, LUDO_S277_BLANKSTART_VERDICT.md, GDSCRIPT_TRAPS.md.

## What would a human do?
Copy Ludo's table into one constants block, test every row, then point IncomeOffers at it.

## Prefab check
None - approved numbers.

## The one trap
Pure modules only: no GameState.gd, no scene, no data file.
