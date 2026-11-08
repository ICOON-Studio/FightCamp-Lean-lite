# TASK MONEYOD2 - QWEN (qwen3-coder) - the overdraft on the Money page: arrange it, see it, the close line knows it

Status: OPEN (S400, Claude main). Discipline: gym money (all disciplines). MONEYOD1 (0d964051) put the overdraft RULES on main
(scripts/rules/Overdraft.gd, Sim.end_week, Career.overdraft_on / overdraft_drawn_weeks / income_history) but nothing in the
game switches it on: `overdraft_on` is always false. This task is the one button and the words around it.
Start every Godot run through `python ops/Tools/godot_slot.py run --who qwen -- <godot cmd>`.

## Contract
OWNS: scripts/rules/Overdraft.gd, scripts/ui/areas/ClubSpend.gd:104-125, scripts/ui/areas/ClubSpend.gd (one new static func
_overdraft + its one call in add()), scripts/ui/GymActs.gd:47-49, scripts/ui/GymActs.gd (one new branch in _spend),
tests/overdraft_ui_test.gd
RED_TEST: tests/overdraft_ui_test.gd -> OVERDRAFT_UI failures=0
REGRESSION: overdraft_test, money_close_test, game_money_test, plain_words_test, golden_path_test
VISUAL: no

## Prior research
ops/research/MONEY_BITES_S397.md s10 (critic B: "a lever before the close"); TASK_MONEYOD1.md (the numbers: limit = last 4
weeks' income rounded down to $100 after 12 weeks of trading, 1% arrangement fee, 16% a year weekly on the drawn balance, the
bank pulls it after 12 weeks drawn). Real UK small-business overdrafts: arranged limit, arrangement fee, interest on what is used.

## What would a human do?
A gym owner whose cash runs thin rings the bank, arranges a small overdraft for a fee, and watches how much of it is used.

## Prefab check
None needed: one card built from UI.card / UI.kv / UI.button like ClubSpend's other cards.

## Do
1. tests/overdraft_ui_test.gd FIRST (headless, a career built like tests/money_layout_test.gd builds one). It must FAIL on main:
   a. week 5 (day 35): an OVERDRAFT card exists in SPEND (node name "OVERDRAFT"), its one button is disabled with a visible
      Label under it saying it opens after 12 weeks of trading (UI.button's visible-reason path - see ClubSpend._premises).
   b. week 20, income history [2000, 2000, 2000, 2000]: the button reads "Arrange, fee $80" (limit $8,000), BtnSolid, enabled.
   c. pressing it through main.act("overdraft", "on") (GymActs): overdraft_on true, cash -$80, a ledger line "Overdraft fee".
   d. with it on and cash -$1,200: the card shows "Limit $8,000", "Used $1,200", and a BtnDanger "Pay off and close" that is
      disabled with a visible reason while cash < 0, enabled when cash >= 0 (act "overdraft", "off" -> overdraft_on false).
   e. the close line (ClubSpend._add_close_clock, the DECIDE card when the gym is in the red): with the overdraft on it says
      the gym closes after 8 weeks below minus the limit ("8 weeks in a row below -$8,000 closes the gym"), off it keeps today's
      "$0" sentence. Use GymBills.CLOSE_AFTER_WEEKS, never a typed 8.
   f. when the gym is in the red and the overdraft is NOT on but can be arranged, the DECIDE card also carries the Arrange button.
2. Overdraft.gd: add `static func can_arrange(weeks_traded: int, income_4w: int) -> String` ("" = yes, else the one-line reason)
   and keep every existing function's behaviour (overdraft_test must stay at 0 failures).
3. ClubSpend: one `_overdraft(parent, main, c)` card in SPEND after the stipends; the close-line change in `_add_close_clock`.
   GymActs: "overdraft" in the list at line 48 and its branch in `_spend` (on: fee paid via c.pay(-fee, "Overdraft fee");
   off: only at cash >= 0). Words: plain, no jargon beyond "overdraft", "limit", "fee", "used".
4. Keep ClubSpend.gd under 500 lines (it is 383). Do not touch Sim.gd, Money.gd, Career.gd, GymBills.gd.

Model: qwen3-coder. Discipline: gym money. The trap: UI.button's visible-reason Label is a SIBLING placed by the parent
container you pass in - pass the card body, or the reason never shows (money_layout_test checks every disabled button has one).

## Result lines (PR body)
RESULT: tests/overdraft_ui_test.gd -> OVERDRAFT_UI failures=0 (main: <n> failures)
RESULT: regression <pass/fail per test>
