# TASK STARTECON2 - loans the gym can take from the office + the staff pay-tier policy, live in the career (state only, no UI)

Model: Qwen (cloud, label qwen). Discipline: BOXING (demo) - gym economy, GYMBUILD step 3.
Operator approved Ludo's S277 new-start economy (board Q-S273-7 "build the rest"; research/LUDO_S277_BLANKSTART_VERDICT.md
L26-L27). The rules are on master: Godot/scripts/rules/StartEconomyRules.gd (`loan_products`, `loan_eligible`, `loan_week`,
`advance_on_purse`, `pay_tiers`, `wage`) with tests/start_economy_rules_test.gd. The bail-out part is already live (SandboxParity,
S280 BAILOUT1). THIS task wires loans + the pay tier into the save. The office PC tab and the staff-screen picker are a LATER Cursor
task that will call your public functions - so name and return them exactly as below.

## Where the code goes (keep GameState edits tiny - Arena ROOMWORK2 is editing other parts of GameState.gd right now)
- NEW `Godot/scripts/state/StartEconomyLive.gd` (extends RefCounted, static funcs on the `career: Dictionary` passed in; preload
  only rules/StartEconomyRules.gd). All logic lives here.
- `Godot/scripts/GameState.gd` (21,395 lines - sed -n windows only): ADD four thin public funcs next to `sandbox_parity_bailout_bout`
  (~L4787) that call StartEconomyLive, plus TWO one-line hooks:
  - weekly: in `advance_week()` (~L8567) right after `var debt_gate: Dictionary = _sandbox_parity_week_gate()` (~L8603).
  - purse: in `_apply_fight_result` (~L16827) on the line after `sandbox_parity_bailout_bout(result, int(payee.get("manager_share", 0)))`
    (~L16875). Change nothing else in GameState.
- `Godot/scripts/state/GameMoney.gd` `staff_payroll(desk_pay, staff)` (L34): wages through the tier (below).
- Gate everything on `GameSwitches.on("start_economy")` (ADD the key to GAME_ON in Godot/scripts/GameSwitches.gd - operator S221 new
  features ship ON) AND `career.has("club_rooms_built")` (an empty-shell career). Gate off = byte-identical to today.

## Public API (GameState)
1. `func loan_offers() -> Array` - one row per StartEconomy.loan_products() id: {"id","label","principal","weekly","weeks" or
   "fights","ok": bool,"why": String} from `loan_eligible(id, facts)`. facts: open_gym = the drawn reception holds the desk
   (`GymClubLayout.room_items("reception").has("reception_desk")` - the same reader GameState uses at ~L8334), members = `get_front_door().members`, pro_boxers = roster
   count with a pro record (find the existing pro-status reader; name it in the PR body), active_loans = ids in `career["loans"]`.
2. `func take_loan(id: String) -> Dictionary` - {"ok","why"}; on ok: cash += principal (`get_gym()["cash"]`), append to
   `career["loans"]` {"id","principal","weekly","weeks_left" | "fights_left","owed_left","taken_day"}, one news line "Loan taken:
   <label> +$<principal>". Refused when not eligible or one of that id is already active. Save through the same path take-actions use.
3. `func loans_view() -> Array` - the active loans for the screen: {"id","label","weekly","weeks_left"/"fights_left","owed_left"}.
4. `func set_staff_pay_tier(tier_id: String) -> Dictionary` - `career["staff_pay_tier"]` = an id from pay_tiers(); unknown -> ok false.
   `func staff_pay_tier() -> String` (default "market").
- Weekly hook: every active micro/municipal loan pays `loan_week(loan)` from cash (a negative cash is allowed - the existing debt
  decision handles it), news "Loan payment -$<pay>" once per week total, done loans leave `career["loans"]`.
- Purse hook: an active promoter_advance takes `advance_on_purse(loan, gym_share)` of the gym's share (manager_share), cash -=
  to_promoter, news "Promoter advance: -$<n> of the purse", done -> removed.
- Pay tier: `GameMoney.staff_payroll` sums `StartEconomy.wage(salary, tier)` per member when the gate is on; the desk wage stays as is.
  It must take the tier as an argument (GameMoney is static) - add an optional `tier_id: String = "market"` and pass it from the
  callers that read staff (grep `staff_payroll(`). Ludo also says the tier moves staff morale / skill / coaching; he gave NO numbers -
  do NOT invent them (operator rule: no defaults without direction). Wage only; say so in the PR body.

## Test - Godot/tests/start_economy_live_test.gd (extends SceneTree, no LFS, last line `START_ECONOMY_LIVE failures=<n>`)
Seed exactly like Godot/tests/member_cap_chip_test.gd (begin_new_career + finalize_new_career + `career["club_rooms_built"] = {}`).
- micro refused with 0 members / no desk, ok with a reception room holding a reception_desk item + 5 members; take_loan cash +5000; a second micro refused.
- 20 weekly ticks pay 275 each (cash -5500 total vs no loan), the loan is gone after the 20th; municipal 420 x 40 likewise (check 3
  ticks + weeks_left, not all 40).
- promoter advance: 30000 owed, 3 purses with gym_share 4000 -> to_promoter 4000 each, removed after the 3rd fight.
- pay tier: payroll with one 1000 salary = 850 / 1000 / 1100 / 1250 for the four tiers; unknown tier refused.
- CONTROL ARM: `career.erase("club_rooms_built")` -> loan_offers all ok false (why "Not available"), payroll unchanged by a tier,
  advance_week cash identical to a run with no loan code.
RED on master first (the functions do not exist) - paste the red line in the PR body.

## Contract
OWNS: Godot/scripts/state/StartEconomyLive.gd, Godot/scripts/GameState.gd, Godot/scripts/state/GameMoney.gd, Godot/scripts/GameSwitches.gd, Godot/tests/start_economy_live_test.gd
RED_TEST: Godot/tests/start_economy_live_test.gd -> START_ECONOMY_LIVE failures=0
REGRESSION: start_economy_rules_test, member_cap_chip_test, room_work_wire_test
VISUAL: no

PR body: `RESULT: tests/start_economy_live_test.gd -> START_ECONOMY_LIVE failures=0` plus each regression's last line. Never delete or
weaken a test to go green. Run: `godot --headless --path Godot --script tests/<name>.gd`.

## Prior research
LUDO_S277_BLANKSTART_VERDICT.md (L26-L27 the approved table), ludo_rx/LUDO_S277_BLANKSTART_raw.txt L205 (tier = one global policy),
TASK_STARTECON1.md (the rules), S279_DIGEST.md "STARTECON1 wiring" (loans = OFFICE actions, tiers on the staff screen - this task is
their state half), SandboxParity.gd (the live debt decision - do not build a second debt system), GDSCRIPT_TRAPS.md.

## What would a human do?
Put the state in one small file, test it with/without the gate, and touch the giant GameState file in two lines plus four wrappers.

## Prefab check
None - our own approved numbers; no assets.

## The one trap
Arena's ROOMWORK2 edits `_apply_fight_result` near the purse line too: add only your ONE hook line after the bail-out call, and merge
origin/master before you push.
