# TASK C5 — CODEX — the TRAINING hub read API

Model: medium. Fast mode off. Decided at assignment; do not self-escalate.
Self-contained. Read this file and nothing else except the two numbered
slices named below. Do not read `HANDOFF_ARCHIVE.md`; do not read
`GameState.gd` whole (10475 lines), use the anchors. START WHENEVER YOU
HAVE CREDITS — not gated on a date, and Kalli's K9 study does not block
you: the data is fixed below. One session: when it ships, end it.

## Why this exists

Every legacy screen is thrown away and rebuilt from the UI kit as a panel
hosted by CareerRoot (user decision 2026-09-05). The GYM hub shipped on
your C4 read API. TRAINING is next (Claude, R22) and it replaces
`TrainingScreen.gd`, which is 2176 lines and **will be deleted**.

That screen is the only place the game knows how to answer "what does this
day do to this fighter". If that logic is not moved into `GameState.gd`
first, it dies with the screen. Rescuing it is the point of this task.
Pure logic, headless-testable, no screen.

## What to build

Four functions appended to `Godot/scripts/GameState.gd` after
`get_fighter_flags` (line 10432, currently the last function). Read-only,
deterministic, no side effects, every value from the save.

    func get_training_hub() -> Dictionary
    func get_training_day(athlete_id: String, day: int) -> Dictionary
    func forecast_training_day(athlete_id: String, day: int, focus: String,
            station_id: String) -> Dictionary
    func forecast_training_week(athlete_id: String, program: Array = []) -> Dictionary

The six focus ids are `ring`, `bags`, `strength`, `cardio`, `recovery`,
`rest` — exactly the keys of `FATIGUE_DELTA` (line 128). `fight` is the
locked bout day, never a choice.

`get_training_hub()` returns:

    {"gym": {name, week, day, day_name, money, coach_rating},
     "fighters": [ one per roster athlete, roster order:
        {id, name, age, sex, discipline, discipline_label,
         weight_class_label, condition, morale, fatigue, readiness,
         regions: {region_id: int},        # BodyReadiness.get_regions
         clearance: {clear: bool, reasons: [{type, ...}]},
         week: [ 7 x {day, focus, focus_label, station_id, station_name,
                      locked_fight} ],     # get_week_program, dressed
         totals: {work, rest, recovery, by_focus: {focus: count}},
         forecast: {body_start, body_end, fatigue_start, fatigue_end,
                    body_series: [8], fatigue_series: [8]},
         event_night: {day, event_id} or {},
         next_bout: {bout_id, opponent_name, weeks_out, days_out} or {},
         camp: {active, opponent_name, weeks, weeks_done, weeks_left,
                film_depth, counter_id, injuries: int} or {},
         flags: get_fighter_flags(id)} ],
     "stations": [ {instance_id, name, category, quality_tier, condition,
                    capacity, day_used: [7], day_free: [7]} ],
     "counts": {fighters, planned, unplanned, in_camp, blocked, resting}}

A fighter is `unplanned` when every non-locked day is `rest`. `blocked`
means `clearance.clear` is false.

`get_training_day(athlete_id, day)` is the day editor's one read:

    {athlete_id, day, day_name, locked_fight: bool,
     current: {focus, focus_label, station_id, station_name},
     clearance: {clear, reasons},
     options: [ get_training_day_options(athlete_id, day) entries, verbatim ],
     impacts: [ {focus, focus_label, station_id, station_name,
                 body_before, body_after, body_delta,
                 fatigue_before, fatigue_after, fatigue_delta,
                 regions_before: {}, regions_after: {},
                 rested_instead: bool, rest_reason, note} ]}

One impact row per legal focus that has a free slot that day, in the order
`rest, recovery, bags, ring, strength, cardio`. An illegal option stays in
`options` with its `illegal_reason` and is absent from `impacts`.

`forecast_training_day` returns exactly the keys the screen's
`_forecast_day` returns: `body`, `fatigue`, `body_before`,
`fatigue_before`, `regions_before`, `regions_after`, `rested_instead`,
`rest_reason`, `resolved_focus`. `forecast_training_week` walks a program
(defaulting to the saved one) and returns the start/end pair plus the
eight-point series the week sparkline needs.

**The one way to get this wrong.** `BodyReadiness.apply_activity` MUTATES
the athlete dictionary it is given. Every forecast must run on
`athlete.duplicate(true)`, never on the live athlete. A forecast that
writes through corrupts the save on a mouse-over. Assert it in the test.

## Port these two slices, then they die with the screen

Read ONLY these line ranges of `Godot/scripts/TrainingScreen.gd`. Mirror
the arithmetic exactly; do not import, extend or edit the screen.

- `_forecast_day` 1032-1071 — the whole projection: clearance downgrade to
  rest, the activity context (`current_week`, `discipline`, `tick_from`,
  `tick_to`), the recovery-only `equipment_quality_tier` from quality x
  condition and `coach_support_rating`, then the fatigue tick.
- `_forecast_week` 1074-1105, `_forecast_week_series` 1107-1144,
  `_day_tick_slice` 1146, `_clearance_reason_text` 1175 — the week walk,
  the per-day slice of `FATIGUE_DELTA`, and the reason text.
- `_compare_focus_impacts` 837-864 for the impact row order and the
  `RESTS` note rule (station name upper-cased, truncated to 16).

## Reuse, never re-derive (GameState.gd anchors)

`get_week_program` 4195, `get_training_day_options` 4324,
`clear_week_program` 4311, `set_week_program_day` 4222 (do not call it),
`PROGRAM_WORK_FOCUSES` 4154, `FATIGUE_DELTA` 128, `DAYS_PER_WEEK` 2284,
`get_athlete_training_clearance` 3316, `get_coach_rating_average` 3538,
`get_active_training_count` 3548, `get_recovery_options` 3640,
`ensure_body_readiness` 2705, `get_roster` 3299, `get_athlete` 3307,
`get_gym` 2927, `get_floor` 2931, `get_equipment_instance` 2947,
`get_career_day` 2288, `get_career_day_name_for` 4360, `get_events_on_day`
2325, `get_booked_fight_due_day` 2468, `get_booked_fight_due_week` 2488,
`get_fight_camp` 1101, `get_fight_camp_report` 1118, and your own
`get_gym_hub` 10198 / `get_fighter_flags` 10432 — reuse the flags, do not
restate them.

Camp is a SUMMARY block only. K9 may recommend that the hub own fight
camp; if it does, a later task extends this. Do not build a camp editor.

A value with no source is `{}` or 0, never a guess; the digest lists every
such field.

## Rules

- No new save fields. Nothing is written. Built on demand, no caching.
- `%%` inside format strings; `var x: T = ...` for Variant returns; never
  reuse a variable name inside one function.
- Do not edit any screen, scene, UIKit, the router, `project.godot`, or a
  test other than your own.

## Files you own

`Godot/scripts/GameState.gd` (append only),
`Godot/tests/training_hub_api_test.gd` (new; briefed as
training_hub_test.gd, shipped under this name),
`research/C5_DIGEST.md` (new, short), your own block in `HANDOFF.md`.

## Test (the one command)

`training_hub_test.gd` seeds through the `DevJump` autoload
(`DevJump.seed({"slot": 9, "route": "training", "week": 6, "booked": true})`,
API at `Godot/scripts/DevJump.gd:35`; set `SceneRouter.navigation_enabled
= false` first) and asserts: every roster athlete appears once, in roster
order; every `week` array is 7 long and a booked fighter's fight day is
`locked_fight`; **the athlete dictionary is deep-equal before and after
`forecast_training_day` and `get_training_hub`** (the mutation trap);
two calls return equal dictionaries and the save is unchanged; `rest`
lowers fatigue and `ring` raises it, matching `FATIGUE_DELTA`; a fighter
who fails training clearance comes back `rested_instead` with a non-empty
`rest_reason`; an option illegal for the discipline is in `options` with
its reason and absent from `impacts`; `counts` agree with the arrays; a
station's `day_used` matches `get_training_day_options`. Then run
`gym_hub_test.gd` and `smoke_test.gd`.

    python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/training_hub_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/training_hub_test.gd

Full suite once before the commit (Git Bash, from `Godot/`, `GODOT` = the
console exe): `for f in tests/*.gd; do timeout 600 "$GODOT" --headless
--path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`.
Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` if you can (else Claude pushes), then convert your
`HANDOFF.md` block to COMPLETE with the hash (max 8 lines).
