# TASK STRESS1B_B - the week advance feeds each boxer's stress (wiring StressWeek into GameState)

Model: Arena Agent Mode (cloud). Repo ICOON-Studio/FightCamp, branch: your own arena/ branch, open a PR into master, never merge.

FightCamp is a Godot 4.7.2 GDScript boxing-manager game. Already on master (read both whole first):
- `Godot/scripts/rules/StressRules.gd` - the stress table (apply / weekly_decay / band / resolve / effects).
- `Godot/scripts/rules/StressWeek.gd` - `events_for(facts)` and `tick(state, facts, composure, roll_0_100)`; its header comment lists the
  WEEK FACTS keys (fight, training_days, deload, weight_cut_pct, weigh_in, injured_this_week, withdrew, opponent_pulled_out, promise,
  request_ignored, physio_sessions, office_talk). Every key is optional.
Nothing calls them yet. This task makes every roster boxer's stress move once per game week.

## New file 1: `Godot/scripts/rules/StressWeekFacts.gd`
`extends RefCounted`, no class_name, pure (no autoloads, no randomness, no preloads except rules/ modules).
`static func from_week(athlete: Dictionary, week: Dictionary) -> Dictionary` builds the facts for ONE athlete from:
- `athlete` - the roster record (a Dictionary as GameState keeps it), read only;
- `week` - what the week advance knew, passed by GameState: `{"fight_result": <the Dictionary _apply_fight_result returned, or {}>,
  "training_days": [<"rest"|"light"|"hard"|"extreme"> x up to 7], "injured_this_week": bool, "weigh_in": "" | "made" | "failed",
  "weight_cut_pct": float}`.
Map whatever exists; for a facts key that has no real source in the game yet, leave it out (StressWeek's default applies) and list it in
the PR body under "NOT WIRED YET". Never invent a value.
`static func roll(athlete_id: String, career_week: int) -> float` = a deterministic 0-100 number from `hash("stress|%s|%d" % [...])`
(the same week always gives the same roll - no random punishment).

## Edit: `Godot/scripts/GameState.gd` (19,400 lines - NEVER read whole; grep and read windows)
- `func advance_week()` at ~line 7489: the per-athlete loop (`for athlete in get_roster():`) already resolves the fight
  (`_apply_fight_result(athlete, booked_offer_id)` ~line 7557), the programmed week (`_apply_program_slices`, fatigue >= 95 injury roll)
  and the legacy focus branch. Collect per athlete what the week did (fight result dict; training day intensities if the program or the
  focus branch knows them - grep `_apply_program_slices`, `training_focus`, `fatigue`; injured this week = status changed to "injured"
  during this call; weigh-in from `athlete.get("weigh_in")` / `_weigh_in_now` ~line 2540 - grep `missed_weight`).
- After the loop, for each roster athlete: `facts = StressWeekFacts.from_week(athlete, week)`, composure = the athlete's composure stat
  (grep how `FighterReadout` or `Composure.gd` reads it; default 50.0 when absent), then
  `var out: Dictionary = StressWeek.tick(athlete.get("stress", {}), facts, composure, StressWeekFacts.roll(id, career_week))` and store
  `athlete["stress"] = out["state"]`. When `out["new_outcome"]` is not empty, append one line to the week's report the same way other
  weekly news is reported (grep `set_last_week_report` / the report dict built in advance_week) - plain words, e.g. "<name> broke under
  the stress: OVERCOOKED" / "<name> came through it STEELED".
- Preload the two modules by path as consts near the other rules preloads (S194 rule: class_name does not resolve in --script runs).
- Keep it additive: no other behaviour changes. An old save without "stress" starts at {}.

## New file 2: `Godot/tests/stress_week_wiring_test.gd`
extends SceneTree, PASS/FAIL lines, final `stress_week_wiring_test checks=<n> failures=<f>`, quit(0/1). Build a career the way an
existing GameState test does (copy the setup of `Godot/tests/technique_seed_world_test.gd`). Checks:
- two DIFFERENT roster boxers (different stats); after one `advance_week()` each has a `stress` Dictionary;
- a boxer with no training and no bout gets "inactive_week" in his stress log;
- a boxer given a pending KO-loss result (set it up the way existing fight-result tests do - grep `pending_fight_result` in tests/) ends
  the week with stress > 0 and "loss_ko" in his log;
- determinism: the same setup advanced twice from the same save gives the same stress numbers;
- StressWeekFacts.from_week on a hand-made athlete + week dict returns exactly the keys it should (unit checks, no GameState needed).

## Acceptance
- CI on your PR green (parse gate + changed tests). Do NOT compile or import the whole project locally; parse-check your files only.
- Do not delete or weaken any test; do not touch StressRules.gd or StressWeek.gd.

## The one trap
`advance_week()` has early `continue`s (the fight branch, the program branch): collect the week's facts BEFORE each `continue`, or
fought and programmed boxers never get stress.

## Prior research
Ludo round 42 part B (operator-approved): stress 0-100, CALM/STRAINED/ON EDGE/BREAKING, afflictions OVERCOOKED / GUN-SHY / STARVING /
FRAGILE, virtue STEELED, causes from the boxer's own weeks, no random punishment. TASK_STRESS1A and TASK_STRESS1B_A built the rules.
## What would a human do?
A gameplay programmer adds one call at the end of the weekly tick per athlete and a "facts" adapter so the rules never read game state directly.
## Prefab check
Game-specific; nothing to reuse.
