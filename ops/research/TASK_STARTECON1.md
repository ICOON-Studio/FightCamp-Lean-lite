# TASK STARTECON1 - the new-start money rules as one pure module + test (loans, bail-out, staff pay tiers, early income)

Model: Qwen (cloud, pure module). Discipline: BOXING (demo) - gym economy, GYMBUILD step 3.
Operator approved (board Q-S273-7, 2026-10-20: "build the rest") Ludo's S277 new-start economy
(research/LUDO_S277_BLANKSTART_VERDICT.md; Ludo's numbers verbatim in research/ludo_rx/LUDO_S277_BLANKSTART_raw.txt
lines 105-120, 205-245, 290-315). Write the RULES as a pure module; Claude wires them into GameState and the screens.

## Spec - Godot/scripts/rules/StartEconomyRules.gd (new, extends RefCounted; no preload, no autoload, no file I/O, no randomness
## unless a seed is passed in)
1. Loans - `static func loan_products() -> Array` returns exactly these rows:
   micro: principal 5000, weekly 275, weeks 20, needs {"open_gym": true, "members": 5}
   municipal: principal 15000, weekly 420, weeks 40, needs {"pro_boxers": 1}
   promoter_advance: principal 30000, weekly 0, fights 3, garnish 1.0 (100% of the gym's purse share until repaid)
   `static func loan_eligible(id: String, facts: Dictionary) -> Dictionary` -> {"ok": bool, "why": String (plain words)}
   facts keys (ints/bools, missing = 0/false): open_gym, members, pro_boxers, active_loans (Array of loan ids already taken - one
   of each at a time).
   `static func loan_week(loan: Dictionary) -> Dictionary` -> one weekly tick: {"pay": int, "weeks_left": int, "done": bool}.
   `static func advance_on_purse(loan: Dictionary, gym_share: int) -> Dictionary` -> {"to_promoter": int, "to_gym": int,
   "owed_left": int, "done": bool}; done after the owed amount is repaid OR after 3 fights, whichever first.
2. Soft bankruptcy (promoter bail-out) - constants TRIGGER -5000, INFUSION 8000, GARNISH 0.50, GARNISH_FIGHTS 3,
   RECOVERY_DAYS 60, RECOVERY_WINS 2.
   `static func bailout_due(cash: int, already_in_bailout: bool) -> bool` (cash <= -5000 and not already in one).
   `static func bailout_start(cash: int, day: int) -> Dictionary` -> {"cash": cash + 8000, "garnish_left": 3, "deadline_day":
   day + 60, "wins_needed": 2, "wins": 0}.
   `static func bailout_purse(state: Dictionary, gym_share: int) -> Dictionary` -> {"to_promoter": int, "to_gym": int, "state": ..}
   (50% while garnish_left > 0, then 0%).
   `static func bailout_after_bout(state: Dictionary, won: bool, day: int) -> Dictionary` -> state with wins, and "result":
   "running" / "recovered" (2 wins on or before the deadline) / "failed" (deadline passed with fewer). NOTE: the "failed"
   consequence (Ludo's basement move) is NOT built - only report "failed".
3. Staff pay tiers - `static func pay_tiers() -> Array`: underpaid -0.15, market 0.0, competitive 0.10, elite 0.25 (id, label,
   wage_mult = 1 + value). `static func wage(base: int, tier_id: String) -> int` (rounded half away from zero; unknown tier = market).
4. Early income channels - `static func income_channels() -> Array` with Ludo's rows: pad_session 120-220/day, max 3 a week,
   days Tue/Thu/Sat; bag_circuit 300-450/week, max 1 block; sparring_hire 350-600 per bout, 1 offer a week, the fighter takes 25
   acute fatigue; banner_sponsor 800 upfront for 4 weeks (shown as 200/week), once a month, needs wall space; short_notice_undercard
   1500-2800, max 1 in month 1, 3 days' prep. `static func channel_pay(id: String, quality01: float) -> int` = min + (max-min) *
   clamp(quality01, 0, 1), rounded.

## Test - Godot/tests/start_economy_rules_test.gd (extends SceneTree, PASS/FAIL lines, last line
## `START_ECONOMY_RULES failures=<n>`, quit(1) on any failure)
Every number above checked against the table (so a typo goes red); eligibility both sides of each requirement; a micro loan run to
the end (20 payments of 275, done on the 20th); the promoter advance ending on repayment AND on the 3rd fight; bail-out due exactly
at -5000 and not at -4999, garnish 3 fights then 0, recovered with 2 wins by day+60, failed on day+61 with 1 win; wage rounding;
channel_pay at 0, 1, 0.5 and clamped at -1 and 2. Mutant check: flip one `<=` to `<` in your head - a boundary case must catch it.

## Contract
OWNS: Godot/scripts/rules/StartEconomyRules.gd, Godot/tests/start_economy_rules_test.gd
RED_TEST: Godot/tests/start_economy_rules_test.gd -> START_ECONOMY_RULES failures=0
REGRESSION: item_palette_test
VISUAL: no

## Prior research
research/LUDO_S277_BLANKSTART_VERDICT.md (the approved table), ludo_rx/LUDO_S277_BLANKSTART_raw.txt (Ludo verbatim),
MGT2_STUDY_S277.md (loans in MGT2), research/GDSCRIPT_TRAPS.md (Variant `:=`, `%%`, integer division).

## What would a human do?
Copy the four tables into constants first, write one boundary test per row, then the functions.

## Prefab check
None - our own numbers, a ~200-line rules table.

## The one trap
Pure module only: do NOT touch GameState.gd, any scene or any data file. No preloads in the test except the module.

## Output
PR with `RESULT: tests/start_economy_rules_test.gd -> START_ECONOMY_RULES failures=0`.
Run: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/start_economy_rules_test.gd`.
