# TASK DAYPLANWIRE1 - the Morning Day Plan runs the floor day (S236)

Seat: Grok Dev (coding seat, own Linux box, Godot 4.7.2, no LFS) - you own the gym floor again (your FLOORWIRE1 is merged on master).
Branch `grok/dayplanwire1`, PR to master; Claude reviews and merges by diff. Discipline: BOXING (the demo's gym floor).
Model: Grok Dev. New features ship ON: switch `day_plan` in `GameSwitches.GAME_ON`; plain `--script` tests are the OFF control arm.

## What is on master already (read these files - do not rewrite them)
- `scripts/rules/DayPlan.gd` (Dola, fixed by Claude S236): TEMPLATES (5 days of blocks {station_kind, minutes, cue, coached}),
  suggest(ctx {days_to_fight, fatigue, niggles, weekday}), cost(plan, stamina, strain), validate(plan), audible(plan, block_index, change,
  elapsed_minutes) - elapsed_minutes counts from the floor day's minute 0, coach_mods(coached) -> {gain_mult, wear_mult},
  COACH_CAPACITY_MINUTES = 240. Tests tests/day_plan_test.gd, tests/day_plan_board_test.gd green.
- `scripts/rules/DayPlanBoard.gd`: rows(plan, ctx), headline(template, days_to_fight).
- `scripts/ui/DayPlanPanel.gd` (Ludo r101): PanelContainer; setup(plan, ctx, rules, board); signal day_started(plan). It calls the rules
  through the objects you pass (pass the two scripts: `preload("res://scripts/rules/DayPlan.gd")`, `...DayPlanBoard.gd`).
- `scripts/GymHall3D.gd` (~3,200 lines; never read whole - grep): the floor day. start_day(stamina, ctx) ~670, send_to(place_id) ~732,
  advance_minutes ~781 (holds while `_coach_day_drawer` is open and, since FLOORWIRE1, while a decision card is open - `_card_holds_clock()`),
  station_queue (~129; "after a station block he walks to the queued station by himself"), set_cue(cue_id) ~2193 (cue ids are
  DayLapSplice.CUES: power_through, crisp_form, pace_yourself; "" = normal), `_tick()` computes gain_k / wear_k (multiply coach_mods in
  there the way FLOORWIRE1 multiplies `_cr_gain` / `_cr_wear`). Station ids: DayLap.stations() and GymClubLayout.places_for_station(id).
- `scripts/GymClub3D.gd`: start_day override ~1038 (calls super), HUD, `_unhandled_input`.

## Do
1. MORNING (switch `day_plan`): when the floor day starts, open DayPlanPanel over the floor (the clock holds while it is open, like the
   decision card). ctx: days_to_fight (from the boxer's booked fight, -1 if none), fatigue (100 - stamina or the floor's strain - pick the
   one the floor already shows and say which in the PR), niggles, weekday, stamina, strain. The suggested template is pre-selected.
2. START DAY -> the floor follows the plan: block 1 starts at minute 0 at a place running that station (map DayPlan station_kind -> the
   floor's station id; a kind the club has no station for -> say which in the PR and map it to the nearest real one, never invent a
   station); each block's cue goes through set_cue; at each block's end the next block's place goes through the existing station_queue walk.
   A "coached" block applies DayPlan.coach_mods(true) to gain_k / wear_k for its minutes; the coach is shown at that station (if the floor
   already moves the coach, use that; otherwise a label is enough this round).
3. AUDIBLE: one HUD button "PLAN" (and key `D`) reopens the panel mid-day; changes go through DayPlan.audible(plan, i, change, _minute) so
   past/running blocks cannot change; the clock holds while it is open.
4. With `day_plan` OFF the floor starts exactly as today (control arm).

## Tests (red on master first - paste the red lines in the PR body)
- New `tests/day_plan_floor_test.gd` modelled on your tests/floor_wire_test.gd (GymClub3D room, models off, `career[...]` switches):
  OFF -> no panel, floor as before; ON -> panel opens at start_day and minute does not advance while it is open; day_started(plan) with
  TEMPLATES["technique_day"] -> after block 1's minutes the boxer is at block 2's station; block 2's cue is the current cue; a coached block's
  form_gain is higher than the same block uncoached (control: identical block, coached false); an audible on a past block is refused and on
  an upcoming block is applied.
- Must stay green: floor_wire_test, breakthrough_floor_test, floor_events_floor_test, niggle_floor_test, form_breakdown_floor_test,
  floor_cuts_test, floor_queue_next_test, block_stop_floor_test, floor_actions_test, day_plan_test, day_plan_board_test.
- `gym_club_3d_test` needs LFS models: if your box cannot load them, say so in the PR; Claude runs it.
- Parse gate: `python Godot/tools/check_scripts.py <every touched .gd>`.

## Rules
GDSCRIPT_TRAPS.md (typed reads, no `:=` on a Variant, no `%%`). GameState.gd is ~29,000 lines - grep and read windows only. Do not edit
rules/DayPlan.gd, rules/DayPlanBoard.gd or ui/DayPlanPanel.gd - a bug there goes in the PR body. Comment "DAYPLANWIRE1 DONE" with the test lines.

## Prior research
research/DOLA_DAYPLAN1_REPLY.md (the modules + Claude's fixes), LUDO_R101 (the panel, Ask Ludo chat "Gym Floor Playtest Ratings"),
GYMFLOOR_MECHANICS_IDEAS_S234.md (C7 Morning Day Plan, L3 Coach Bandwidth), K87_DECISION_PACING_REPLY.md (the plan will later show the day's
card budget as pips - NOT this round), J62_TRAINING_DAY_REPLY.md (real camp days).

## What would a human do?
A head coach writes the day on the whiteboard at 7am - rounds on the bag, pads at 10, he takes the pads himself - then changes one block when
the fighter walks in heavy-legged. The fighter follows the board without being walked to each station.

## Prefab check
None - Dola wrote the rules, Ludo wrote the panel.

## The one trap
Two clocks: DayPlan blocks are minutes from the floor day's minute 0, the floor counts `_minute` the same way; DayPlanBoard shows them from
06:00. Never feed a wall-clock minute (360+) into audible().
