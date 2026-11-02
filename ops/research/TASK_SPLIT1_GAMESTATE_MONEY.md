# TASK SPLIT1 - split GameState.gd, phase 1: the money (billing, wages, upkeep) moves to its own script

Model: Codex gpt-6-luna, medium. Worktree E:/FightCamp/wt/SPLIT1, branch codex/split1 (from master). Commit + push the branch; never master.
Operator 2026-10-09 (S187), on why: GameState.gd is 19,373 lines and nearly every task touches it, so two agents collide; split it
into modules (career, roster, money, training, booking) "so three or four agents can write code at the same time". This is PHASE 1
of that split: MONEY only. Later phases (roster, booking, career, training) are separate tasks - do not start them.
NEVER open a window, image viewer or browser. Headless Godot only via the NON-console exe:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`.

## The rule of the split (a pure move - behaviour byte-identical)
- New file `Godot/scripts/state/GameMoney.gd` (`extends RefCounted`, `class_name GameMoney`), holding the money LOGIC as static
  functions that take what they need as arguments (the career Dictionary, the roster Array...). No autoload, no new state.
- GameState keeps EVERY public method it has today with the same name, arguments and return - each becomes a 1-3 line delegate to
  GameMoney. No caller anywhere changes. Private helpers (`_billing_month_key`, `_settle_billing`, ...) move and GameState's own
  callers call them through GameMoney.
- What moves (start list - find the rest with `rg -n "billing|_bill|desk_wage|upkeep|payroll|manager_income|camp_spend" Godot/scripts/GameState.gd`):
  get_desk_wage (~4240), get_camp_spend_for_week (~6750), get_manager_income_for_week (~6763), _billing_month_key (~7242),
  get_billing_summary (~7264), _settle_billing (~7435), _scouting_weekly_payroll (~18565).
- Do NOT touch: file_visit / floor_gains / training (another task is changing them), the save format, any number or rule.
- GameState.gd is never read whole: use `sed -n 'A,Bp'` windows.

## Owned files
- Godot/scripts/GameState.gd
- Godot/scripts/state/GameMoney.gd (new)
- Godot/tests/game_money_split_test.gd (new)

## Tests
1. Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <file>` (a parse error hangs a headless test).
2. New `game_money_split_test.gd`: start a career, sign a fighter and a coach, advance 5 weeks; assert get_billing_summary() and
   the cash after each week equal the values recorded BEFORE your change (record them first on the untouched branch, hard-code
   them in the test with the seed named). Prove it can fail: change one constant in GameMoney, test red, restore.
3. Then, one filter per run (the last --only wins): `python Godot/tools/run_tests.py --jobs 2 --only billing`, `--only week_review`,
   `--only money`, `--only economy`, `--only save`, `--only career_mornings`, `--only sign`. All green, or name the red that was
   red before your change too.

## Prior research / What would a human do / Prefab check
A refactor by extraction behind an unchanged facade (Fowler, "Extract Class" + "Hide Delegate"). No prefab.

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). Static funcs cannot use the autoload's
instance members - pass them in.

## Done =
Pushed branch; GameState.gd shorter by the moved code; the before/after test green and proven red by the mutant; your last message
lists every moved function and every run's SUITE line.
