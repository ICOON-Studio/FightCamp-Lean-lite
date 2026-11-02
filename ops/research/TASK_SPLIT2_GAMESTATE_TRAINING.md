# TASK SPLIT2 - split GameState.gd, phase 2: TRAINING (stat gains, the day tick, the week program, the lived club day)

Model: Codex gpt-6-luna, medium. Worktree E:/FightCamp/wt/SPLIT2, branch codex/split2 (from master). Commit + push the branch; never master.
Operator 2026-10-09 (S187), on why: GameState.gd is 19,373 lines and nearly every task touches it, so two agents collide; split it
into modules (career, roster, money, training, booking) "so three or four agents can write code at the same time". PHASE 1 (money ->
scripts/state/GameMoney.gd, S188 merge 7ad54cd5) is DONE - read it as the house pattern. This is PHASE 2: TRAINING only. Roster,
booking and career are later tasks - do not start them.
NEVER open a window, image viewer or browser. Headless Godot only via the NON-console exe:
`"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --path Godot --script tests/<name>.gd`.

## The rule of the split (a pure move - behaviour byte-identical)
- New file `Godot/scripts/state/GameTraining.gd` (`extends RefCounted`, `class_name GameTraining`), holding the training LOGIC as
  static functions that take what they need as arguments (athlete Dictionary, station Dictionary, coach rating, day...). No
  autoload, no new state. Same pattern as GameMoney.gd.
- GameState keeps EVERY public method it has today with the same name, arguments and return - each becomes a 1-3 line delegate.
  No caller anywhere changes. Private helpers move and GameState's own callers call them through GameTraining.
- What moves (line numbers at master 7ad54cd5; confirm with `rg -n "^func " Godot/scripts/GameState.gd`): _week_tick_slice (~5596),
  _apply_focus_stat_gains (~5603), _training_crowd_factor (~5652), preview_training_gain (~5659), _mastered_gain (~5671),
  get_station_mastery_multiplier (~5685), _train_mastery (~5733), _ensure_stat_baseline (~6605), _record_stat_history (~6615),
  get_stat_changes (~6724), _program_entry_for_day (~6880), get_week_program (~6890), _apply_program_slices (~7085),
  _program_week_effort (~7136), _apply_daily_training_tick (~7158), file_visit's stat part (~19127: the floor_gains + the
  TrainingPreview.lived_gain block, S188) and _lived_day (~19175). If a function reaches deep into other systems (BodyReadiness,
  injuries, objectives, equipment lookups), move only the pure arithmetic and keep the call-outs in GameState - say which.
- Do NOT touch: the money module, the save format, any number or rule, TrainingPreview.gd, DayLap*.gd.
- GameState.gd is never read whole: use `sed -n 'A,Bp'` windows.

## Owned files
- Godot/scripts/GameState.gd
- Godot/scripts/state/GameTraining.gd (new)
- Godot/tests/game_training_split_test.gd (new)

## Tests
1. Parse gate on every touched .gd: `python Godot/tools/check_scripts.py <file>` (a parse error hangs a headless test).
2. New `game_training_split_test.gd`: start a career, sign two DIFFERENT fighters (different stats) and a coach, give one a week
   program on stations and file one lived club visit for the other (see tests/floor_gain_test.gd for file_visit), advance 3 weeks;
   assert every stat of both fighters (to 4 decimals), fatigue and get_stat_changes() after each week equal the values recorded
   BEFORE your change (record them first on the untouched branch, hard-code
   them in the test with the seed named). Prove it can fail: change one constant in GameTraining, test red, restore.
3. Then, one filter per run (the last --only wins): `python Godot/tools/run_tests.py --jobs 2 --only training`, `--only floor_gain`,
   `--only week_review`, `--only mastery`, `--only program`, `--only career_mornings`, `--only game_money_split`.
   Then `python Tools/check_workflow.py branch codex/split2 SPLIT2` (S188 gate) and paste its summary. All green, or name the red that was
   red before your change too.

## Prior research / What would a human do / Prefab check
A refactor by extraction behind an unchanged facade (Fowler, "Extract Class" + "Hide Delegate"). No prefab.

## The one trap
`var x := <call>` fails when the call returns Variant - type it (`var n: int = ...`). Static funcs cannot use the autoload's
instance members - pass them in.

## Done =
Pushed branch; GameState.gd shorter by the moved code; the before/after test green and proven red by the mutant; your last message
lists every moved function and every run's SUITE line.
