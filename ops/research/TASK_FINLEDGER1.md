# TASK FINLEDGER1 - the office PC's FINANCES tab data: one pure ledger module (S240)

Seat: Qwen (cloud, label `qwen`). Branch + PR from the cloud-agent workflow; Claude merges by diff. Model: Qwen default.
Discipline: BOXING (the demo) - money of a small boxing gym.

## Why
Operator S240: the office desk PC shows FINANCES (board Q-S239-1 + PM Paul's two-tab cut). Cursor builds the screen (TASK_PCHUB1:
`OfficePcScreen.show_finances(ledger)`); this task builds the `ledger` it shows, from the game's own state.

## Do - new `Godot/scripts/rules/FinanceLedger.gd`
`extends RefCounted`, static funcs only, NO preload/autoload/Node (pure: it takes dictionaries, returns a dictionary).
`static func ledger(career: Dictionary) -> Dictionary` returns EXACTLY:
`{"cash": int, "weekly_costs": [{"label": String, "amount": int}], "recent_income": [{"label": String, "amount": int}], "net_weekly": int}`
- cash = career["gym"]["cash"].
- weekly_costs = what the game ALREADY charges each week. FIRST trace it: read `Godot/scripts/GameState.gd` (huge - grep, then read
  windows with sed -n, never whole): the weekly pass that lowers `gym["cash"]` (grep `gym["cash"] =`, `weekly`, `salary`, `wage`,
  `rent`, `upkeep`, `cash_log` ~line 1737) and list every recurring cost it applies (staff salaries per staff row, rent/upkeep, fighter
  stipends, whatever exists). One row per cost type, amounts as the game computes them (positive numbers = money out). Name the source
  function + line for each in a comment. Do NOT invent a cost the game does not charge.
- recent_income = the last few incoming amounts the state already records (purses, fees, ticket splits, signing money - whatever the
  career keeps; if a history list exists use its last 5 incoming rows, newest first). If none is recorded, [].
- net_weekly = -(sum of weekly_costs) + the game's own weekly income if it has one (say what you used in a comment), else -(sum).
- Empty/missing keys never crash: a fresh career returns cash, [] lists and net 0.

## Tests (red on master first - the file does not exist)
New `Godot/tests/finance_ledger_test.gd` (extends SceneTree, `_initialize`, prints `FINANCE_LEDGER failures=N checks=M`, quit(1) on fail).
Three DIFFERENT career fixtures (never identical): a fresh gym (cash 25000, no staff), a gym with one coach on a 900/week salary and two
boxers, a gym with two staff and a purse history. Check exact numbers against what GameState's weekly pass would charge (call the real
GameState weekly function in ONE check if it can run headless on a fixture; otherwise hand-compute from the code you traced and say so).
Command: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/finance_ledger_test.gd`.
Parse gate first: `python Godot/tools/check_scripts.py Godot/scripts/rules/FinanceLedger.gd Godot/tests/finance_ledger_test.gd`.

## Rules
research/GDSCRIPT_TRAPS.md (no `:=` from a Variant; `%%` for a literal percent). Edit ONLY the two new files.
THE ONE TRAP: never invent money rows the game does not have - trace first, cite the line.

## Prior research
TASK_PCHUB1.md (the ledger shape), research/ludo_rx/LUDO_R106_raw.txt (Tab 2 FINANCES: weekly expenses vs revenue history),
GameState.gd cash_log (~1737) and the weekly pass.

## What would a human do?
Open the books: what leaves every week, what came in lately, what is left.

## Prefab check
None - a read of our own state.
