# TASK MORNING1T - port the rule-by-rule CareerMorning test onto master's module

Model: any strong coding model. Seat: Arena (own branch `arena/<chat-id>-<repo>`, open the PR yourself, NEVER merge).
DO NOT BUILD OR DOWNLOAD GODOT in your sandbox. Write the test, push, open the PR - CI and Claude run it.

## Goal
PR #60 (branch `arena/fd7fb0f8-fightcamp`) holds `Godot/tests/career_morning_test.gd`: a rule-by-rule test of the
career-morning rules (204 checks, 39 mutants caught). It was written against its own module, and master has merged a
different implementation: `Godot/scripts/CareerMorning.gd` (201 lines) + `Godot/assets/data/career_morning.json`
(23 lines). Bring that test onto master: SAME rules, master's function names and JSON key names. Do NOT edit
CareerMorning.gd or career_morning.json - the test adapts to them.

## What changes in the test
- Key names: the branch spells `week_days` / `spent_line` / `hype.pushed_gain` etc.; master spells
  `camp_week_days`, `risk_line`, `strain_high`, `word_spent_below`, `word_working_below`, `strain_per_hour`,
  `meal_restore`, `skipped_restore`, `heavy_cardio_minutes`, `coach_tags`, `hype.{feud,gym_rivalry,title,push,cool,
  push_cost,push_kinds}`, `go_watch.{coach_minutes,alone_minutes,usable_minutes,max_layers,film_coach_layers,drain_mult}`,
  `week_minutes_target`. Read master's JSON and every `static func` in master's CareerMorning.gd first.
- Expected numbers are READ from master's JSON in the test (never copied as literals), so a data change cannot leave
  the test green by accident.
- The two readings where the PR body says the implementations differ (the fight morning's stops; where the hype
  floor applies): master's behaviour is the rule. Write those checks to master's behaviour.
- Checks that need a function master does not have (`camp_week`): drop them, and list each dropped check in a
  comment block at the top of the test.

## Owned files
- NEW `Godot/tests/career_morning_rules_test.gd` (copy from `career_morning_test.gd` on `arena/fd7fb0f8-fightcamp`,
  then adapt). Nothing else.

## Acceptance
- Parse: `python Godot/tools/check_scripts.py Godot/tests/career_morning_rules_test.gd`.
- Test: `Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/career_morning_rules_test.gd` passes
  against master's module UNCHANGED (CI runs it). Last line prints `CAREER_MORNING_RULES_TEST passed=<n> failed=0`.
- A comment block lists at least 5 mutants of master's CareerMorning.gd (one line each: what to change, which check
  goes red). Claude runs them.
- `tests/career_mornings_path_test.gd` untouched and still green.

## Prior research
`python Tools/prior_research.py CareerMorning career morning rules` -> S176_DIGEST.md and
TASK_MORNING1_CAREER_MORNING_RULES.md (the spec both implementations were written from); PR #60's body (the
measured 158/39 split, all 39 traced to key names or the two readings).

## What would a human do?
Keep the merged, wired-in module and port the stronger test onto it, so every rule has its own red check.

## Prefab check
Nothing to buy: a test port inside our repo.

## The one trap
Do not "fix" CareerMorning.gd to match the old test - master's module is wired into GameState and the gym hall.
CI has no Git LFS: load no model or texture.
