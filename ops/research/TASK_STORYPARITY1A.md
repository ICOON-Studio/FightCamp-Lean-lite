# TASK STORYPARITY1A (S219) - sandbox predatory promoter offers + the debt event (pure modules + blind tests)

Model: Arena (cloud, free). Repo ICOON-Studio/FightCamp, base `master`. Work on your own `arena/...` branch, open a PR, NEVER merge.
No LFS-loading code or tests. Do not delete or shorten any existing test. Touch no other file.
LAUNCH ONLY AFTER the operator approves board Q-S212-16 (Ludo round 53 verdict). If he picks "going broke never ends the career",
drop rule D7 (insolvency) and its tests; everything else stands.

## Why
In the sandbox starts (no story) the game must still offer the pressures the story teaches: a predatory promoter dangling quick
money, and a hard decision when the gym's cash stays below zero (Ludo round 52 "sandbox parity", numbers from Ludo round 53,
Claude's verdict `research/LUDO_ROUND53_VERDICT_S219.md` section C). This task is ONLY the rules, as two pure modules.
Cloud Cursor wires them into the week loop, the inbox and a modal later (STORYPARITY1B).

## Prior research
LUDO_ROUND52_VERDICT_S217.md (sandbox parity), LUDO_ROUND53_REPLY2_S219.txt Part C (the numbers), promoter_trap.json (the story's
scripted trap - untouched), short_notice.json (premium x1.35, goodwill) - read for context only.

## What would a human do?
A designer writes the rule table once, as data plus small pure functions with a dice argument, so every number can be tested and
tuned without running the game.

## Prefab check
None - ~250 lines of our own rules.

## Do - new file `Godot/scripts/PredatoryOffers.gd`
`extends RefCounted`; all `static`; NO preloads, autoloads, nodes, RNG objects or file reads. Randomness comes in as `roll` floats
in [0,1) passed by the caller.
```gdscript
const P_BASE := 0.04
const P_CAP := 0.40
const MIN_CAREER_WEEK := 4
const COOLDOWN_DECLINE_WEEKS := 6     # after a decline or an expiry
const COOLDOWN_CONTRACT_WEEKS := 16   # after a finished predatory contract
## distress by cash: <= 0 -> 0.25; <= 2500 -> 0.15; <= 5000 -> 0.08; else 0.0
static func distress_mod(cash: float) -> float
## streak: win_streak >= 2 -> 0.15; won_last -> 0.05; else 0.0
static func streak_mod(win_streak: int, won_last: bool) -> float
## state keys: career_week:int, cash:float, cooldown_weeks:int, pending_offers:int, active_contracts:int,
## win_streak:int, won_last:bool. Returns 0.0 when not eligible (week < 4, cooldown > 0, pending >= 1, active >= 1).
static func offer_chance(state: Dictionary) -> float
## true when roll < offer_chance(state)
static func offer_fires(state: Dictionary, roll: float) -> bool
## Tier 1 terms from rolls r[0..4] (each in [0,1)): advance = 3500 + r0*4000 rounded to 100; bouts 3; promoter_cut 0.45;
## sanctioned = r1 >= 0.70; opponent_gap = 8 + floor(r2*9) (8..16); clause = "" if r3 >= 0.50 else one of
## ["weight_trap","date_forward","rematch_lock","medical_indemnity"][floor(r4*4)]; expires_weeks 3.
## Returns {advance, bouts, promoter_cut, sanctioned, opponent_gap, clause, expires_weeks}.
static func tier1_terms(r: Array) -> Dictionary
## Tells always shown: ["split"] always; "stat_gap" when opponent_gap >= 8; "unsanctioned" when not sanctioned.
## The clause is shown only when legal_review is true.
static func visible_tells(terms: Dictionary, legal_review: bool) -> Array
const LEGAL_REVIEW_COST := 350.0
## outcome: "win" | "loss_decision" | "loss_stoppage" | "decline" | "expire". Returns the deltas:
## {cash, prestige, morale, chin_loss_min, chin_loss_max, suspension_days, cooldown_weeks, goodwill}
## win: cash = purse*(1-promoter_cut), prestige +220; loss_decision: morale -15, prestige -40; loss_stoppage: cash -1200,
## prestige -90, chin loss 2..6, suspension 60; decline: prestige +10, goodwill -1, cooldown 6; expire: cooldown 6.
static func outcome(terms: Dictionary, result: String, purse: float) -> Dictionary
```

## Do - new file `Godot/scripts/DebtEvent.gd`
Same purity rules.
```gdscript
const LOAN_MIN := 7500.0
const LOAN_MAX := 20000.0
const LOAN_BUFFER := 5000.0
const LOAN_WEEKS := 16
const LOAN_RATE := 0.06
const IMMUNITY_WEEKS := 3
const RECEIVERSHIP_AFTER_WEEKS := 4
const INSOLVENT_AFTER_WEEKS := 6
## D1 trigger: true when cash < 0 at this tick AND at the previous tick, and immunity_weeks == 0.
static func should_fire(neg_weeks_in_a_row: int, immunity_weeks: int) -> bool
## D2 loan: principal = clamp(abs(deficit) + 5000, 7500, 20000)
static func loan_principal(deficit: float) -> float
## D3 weekly payment on the remaining principal: principal/16 + remaining*0.06 (round to cents)
static func loan_payment(principal: float, remaining: float) -> float
## D4 missed payments: 1 -> "notice" (prestige -50), 2 -> "repossess" (most valuable equipment), 3 -> "foreclosure"
static func missed_payment_step(missed_in_a_row: int) -> String
## D5 emergency fight: purse = 3500 + 0.5*abs(deficit); paid_now = 0.8*purse; opponent power +6..+12 and technique +4..+10 from
## rolls; stamina_penalty 0.25; injury_chance 0.35. Returns {purse, paid_now, power_gap, technique_gap, stamina_penalty, injury_chance}
static func emergency_fight(deficit: float, r_power: float, r_tech: float) -> Dictionary
## D6 austerity: {upkeep_mult 0.5, weeks 8, recovery_mult 0.6, equipment_wear_mult 2.5, member_income_mult 0.65, composure -20}
static func austerity() -> Dictionary
## D7 after a choice: weeks_since_choice, still_negative -> "ok" | "receivership" (week >= 4 after the choice and cash < 0) |
## "insolvent" (6 more weeks negative after receivership). Inputs: weeks_since_choice:int, cash:float, neg_weeks_in_receivership:int
static func after_choice_state(weeks_since_choice: int, cash: float, neg_weeks_in_receivership: int) -> String
```

## Test - new `Godot/tests/sandbox_parity_rules_test.gd`
`extends SceneTree`; prints `SANDBOX_PARITY_RULES_TEST PASS (<n> checks)` or `FAIL ...` lines; `quit(0)`/`quit(1)`. Load with
`load("res://scripts/PredatoryOffers.gd")` / `DebtEvent.gd`. Blind, from THIS contract only. Checks (Ludo's 7 cases, corrected):
1. Healthy: week 8, cash 14200, no streak -> offer_chance 0.04; should_fire(0,0) false.
2. Week-1 deficit: cash -450 -> distress 0.25; offer_chance 0.29 (no streak); should_fire(1,0) false.
3. Week-2 deficit: should_fire(2,0) true; deficit 1650 -> loan_principal 7500 (minimum), emergency purse 4325, austerity upkeep_mult 0.5.
4. Loan: principal 7500, remaining 7500 -> payment 918.75; remaining 3750 -> 693.75; a 30000 deficit gives loan_principal 20000 (maximum).
5. Decline: outcome(..., "decline") -> prestige +10, goodwill -1, cooldown 6, cash 0.
6. Stoppage: outcome(..., "loss_stoppage") -> cash -1200, chin loss range 2..6, suspension 60.
7. Insolvency: after_choice_state(4, -3400, 0) == "receivership"; after_choice_state(10, -3400, 6) == "insolvent";
   after_choice_state(4, 100, 0) == "ok".
8. Edges: cash exactly 0 -> distress 0.25; exactly 2500 -> 0.15; exactly 5000 -> 0.08; 5000.01 -> 0.0; cap: cash -1, streak 3
   -> 0.40 not 0.44; week 3 -> 0.0; cooldown 1 -> 0.0; immunity 1 -> should_fire false.
9. tier1_terms: rolls [0,0,0,0,0] -> advance 3500, unsanctioned, gap 8, clause "weight_trap"; [0.999,0.7,0.999,0.5,0] -> advance
   7500, sanctioned, gap 16, clause ""; visible_tells hides the clause until legal_review.
10. Three mutants inside the test, each proving an assertion goes red: (a) cap removed; (b) `<` instead of `<=` on the 2500
   distress edge; (c) loan minimum not applied.

## Gate (CI runs it)
Parse gate on the 3 new files, then `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/sandbox_parity_rules_test.gd`
prints the PASS line.

## VISUAL GATE
Not a visual task: pure rules modules, no body, animation, camera or look change.

## The one trap
No `RandomNumberGenerator` and no `randf()` inside the modules - every roll is an argument, or the tests cannot pin the numbers.
GDScript: explicit casts on Dictionary reads, no `:=` on Variant reads, `floori`/`clampf` for the formulas.
