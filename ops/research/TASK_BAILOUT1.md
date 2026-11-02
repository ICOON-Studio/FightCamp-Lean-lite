# TASK BAILOUT1 - the promoter bail-out becomes an option inside the EXISTING debt decision (SandboxParity.gd) + test

Model: Arena (cloud, repo ICOON-Studio/FightCamp-lite). Discipline: BOXING (demo) - gym economy, GYMBUILD step 3 (STARTECON1 wiring).
Decision (Claude S279_DIGEST "Decided"): the game already has a LIVE debt system (Godot/scripts/SandboxParity.gd, 342 lines:
`debt_options`, `choose_debt_option`, loans/emergency fight/austerity, predatory offer, receivership; switch `sandbox_parity` in
GAME_ON). The new-start promoter bail-out (Godot/scripts/rules/StartEconomyRules.gd lines 60-106: TRIGGER -5000, INFUSION 8000,
GARNISH 0.50 for 3 fights, 60 days, 2 wins) is NOT a second system - it is a FOURTH option in that same decision.

## Spec - Godot/scripts/SandboxParity.gd (edit; keep every existing function's behaviour byte-identical for the old options)
1. Add `const StartEconomy := preload("res://scripts/rules/StartEconomyRules.gd")` beside the two existing preloads (lines 3-4).
2. `debt_options(deficit, rolls)` (line 177): add key `"promoter_bailout"`:
   - when `StartEconomy.bailout_due(-int(roundi(deficit)), false)` (deficit >= 5000):
     `{"available": true, "infusion": StartEconomy.INFUSION, "garnish": StartEconomy.GARNISH, "fights": StartEconomy.GARNISH_FIGHTS,
       "days": StartEconomy.RECOVERY_DAYS, "wins_needed": StartEconomy.RECOVERY_WINS}`
   - otherwise `{"available": false, "why": "Only when you are 5,000 or more in the red"}`.
   - NEVER available while `parity["bailout"]` is running (see 3) - add an optional third param `parity: Dictionary = {}` and check
     `str(parity.get("bailout", {}).get("result", ""))  == "running"`.
3. `choose_debt_option(parity, kind, deficit, rolls)` (line 196): new `match` arm `"promoter_bailout"`:
   - if not available (rule 2) -> `{"ok": false, "parity": out}` exactly like the unknown-kind arm.
   - else: `out["bailout"] = StartEconomy.bailout_start(-int(roundi(deficit)), day)` minus its "cash" key (the parity never holds
     cash) where `day` = `int(parity.get("day", 0))`; `debt["kind"] = "bailout"`; cash move
     `{"label": "PROMOTER BAIL-OUT", "amount": StartEconomy.INFUSION}`.
4. `normalized(raw)` (line 9): carry `"bailout"` (Dictionary, default {}) through like `emergency_fight`.
5. New `static func bailout_bout_result(parity: Dictionary, won: bool, gym_share: int, day: int) -> Dictionary`
   -> `{"parity": .., "to_promoter": int, "to_gym": int, "result": "none"|"running"|"recovered"|"failed"}`:
   no running bail-out -> to_gym = gym_share, to_promoter 0, result "none", parity unchanged.
   Else `StartEconomy.bailout_purse` then `StartEconomy.bailout_after_bout`; on "recovered" or "failed" clear `debt` to
   `_blank_debt()` (keep `bailout` with its result so the screen can say it). "failed" has NO further consequence (not built).

## Test - Godot/tests/sandbox_bailout_test.gd (new; extends SceneTree, PASS/FAIL lines, last line `SANDBOX_BAILOUT failures=<n>`,
## quit(1) on any failure; pure - loads only SandboxParity.gd; no LFS, no scene)
- deficit 4,999 -> option unavailable with the why; 5,000 and 12,000 -> available with 8000 / 0.5 / 3 / 60 / 2.
- choose at deficit 6,000, day 10 -> ok, cash move +8000, debt kind "bailout", bailout deadline_day 70, garnish_left 3, no "cash" key.
- choosing it again while running -> ok false; debt_options(.., parity) shows it unavailable.
- 3 bouts of gym_share 1000 -> 500/500 each; the 4th pays 1000/0.
- 2 wins by day 70 -> "recovered" + debt cleared; 1 win then a bout on day 71 -> "failed" + debt cleared.
- the old three options: same `debt_options` keys/values and `choose_debt_option` results as before for loan/emergency/austerity
  (compare against literals you compute from DebtEvent.gd, so a changed old path goes red).
- MUTANTS (say in the PR which you tried and that each went red): TRIGGER -4000; garnish applied on the 4th fight; available while running.

## Contract
OWNS: Godot/scripts/SandboxParity.gd, Godot/tests/sandbox_bailout_test.gd
RED_TEST: Godot/tests/sandbox_bailout_test.gd -> SANDBOX_BAILOUT failures=0
REGRESSION: sandbox_parity_rules_test, sandbox_parity_wiring_test, start_economy_rules_test
VISUAL: no

Parse gate: `python Godot/tools/check_scripts.py Godot/scripts/SandboxParity.gd Godot/tests/sandbox_bailout_test.gd`.
One test: `godot --headless --path Godot --script tests/sandbox_bailout_test.gd` (tier: script edited -> parse + this + the 3 regressions).
Plain `--script` tests are the OFF control arm; nothing here reads a switch (pure rules), the switch is read by GameState later.
NOT yours: GameState.gd, DebtDecisionModal.gd (Claude wires the button and the purse hook after this lands).
THE TRAP: do not touch the loan/emergency/austerity arms or delete/rename any existing test - the old paths must stay identical.
PR body: `RESULT: tests/sandbox_bailout_test.gd -> SANDBOX_BAILOUT failures=0` and one RESULT line per regression test.

## Prior research
`python Tools/prior_research.py bailout debt promoter` -> research/topics/money_business.md; Ludo S277 new-start economy
(research/LUDO_S277_BLANKSTART_VERDICT.md, approved Q-S273-7 "build the rest"); StartEconomyRules.gd already on master (STARTECON1).

## What would a human do?
A broke gym owner gets one phone call: the promoter covers the hole and takes half his next three purses. It is a choice beside
the bank loan and the desperate fight, not a separate screen.

## Prefab check
None needed - extends our own module; no library models a boxing-gym bail-out.
