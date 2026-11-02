# TASK GYM4B - Click a thing, see what it can do: ThingActions.gd + thing_actions.json + its test

Model: any strong coder. Owner: Arena (cloud; own `arena/` branch, open a PR into master, NEVER merge).
Tier: new script + new data + new test -> parse gate on the new files + the new test. Headless, pure, no UI.

## What it is
In the new 3D boxing club (design `research/GYM4_REDESIGN_S178.md`, research `research/J64_CLICK_A_THING_ACTIONS_RAW.md`)
the player left-clicks a person or object and a ring of at most 6 actions opens. Unavailable actions are NEVER hidden: they show
greyed with a reason "<why> - <when it frees>". This task is ONLY the pure rule module that decides the list. No UI, no scene.

## Owned files (create; touch nothing else)
- `Godot/assets/data/thing_actions.json` - per kind, the ordered action rows {id, label, icon, tooltip} (labels are plain English,
  short, e.g. "Call a coach", "Train here"). Kinds and actions (max 6 each, in this order):
  - fighter: call_coach, train_at, rest, talk, day_plan, profile
  - coach: coach_fighter, drill_focus, send_to_station, week_hours, talk_contract, profile
  - station: train_here, coach_here, queue_next, what_it_trains, upgrade
  - office_window: week_review, hire, money, calendar_offers, upgrades, messages
  - walk_in: greet, interview, trial_session, come_back_later, send_away, profile
  Plus `low_stamina_line` (e.g. 20) and `contract_hours` [9*60, 17*60] (office hours in game minutes) as data.
- `Godot/scripts/ThingActions.gd` - `extends RefCounted`, static, pure (no GameState, no autoload, no RNG, no preload):
  - `static func actions(kind: String, ctx: Dictionary) -> Array` -> rows {id, label, icon, tooltip, enabled: bool, reason: String}
    in data order; unknown kind -> []. `reason` is "" when enabled.
  - `static func coach_rows(ctx: Dictionary) -> Array` -> the CALL A COACH card: one row per coach in ctx.coaches
    {id, name, specialty, week_minutes_left, busy_until (game minute or -1), day_off: bool, at: String}, each
    {id, name, specialty, week_minutes_left, at, available: bool, reason}. Order: available first, then by fit (specialty ==
    ctx.station_specialty first), then by week_minutes_left desc, then id. Greyed reasons: "Busy until HH:MM", "Day off today",
    "No hours left this week". No coaches -> one row {id "", available false, reason "No coach on staff - hire at the office window"}.
  - ctx keys (all optional, safe defaults): now_minute, fighter_stamina, fighter_resting, coaches (array above), station_id,
    station_specialty, station_occupied_until, money, upgrade_cost, visitor_known (bool), visitor_kind ("fighter_candidate",
    "coach_candidate", "member", "promoter", "reporter"), free_coach_minute (next minute any coach is free, -1 none).
  Enable rules (each disabled case carries its reason, time as HH:MM from game minutes):
  fighter.call_coach disabled when no coach is available now ("No free coach - next free HH:MM" or "No coach on staff - hire at
  the office window"); fighter.train_at disabled under low_stamina_line ("Stamina too low (N)"); fighter.rest disabled when
  fighter_resting ("Already resting"); station.train_here disabled when station_occupied_until > now ("Occupied until HH:MM") or
  stamina under the line; station.coach_here like call_coach; station.upgrade disabled when money < upgrade_cost ("Not enough
  money - need N"); coach.coach_fighter disabled when that coach is busy / off / out of hours (same three reasons);
  coach.talk_contract disabled outside contract_hours ("Contracts in office hours - HH:MM"); walk_in.interview and
  walk_in.trial_session only for fighter_candidate / coach_candidate (else disabled "Not looking for a place"); walk_in.trial_session
  disabled when no coach free ("No free coach until HH:MM"); walk_in.profile disabled until visitor_known ("Greet them first").
- `Godot/tests/thing_actions_test.gd` - `extends SceneTree`, ok/FAIL lines, final `THING ACTIONS PASS` or `THING ACTIONS FAILS=<n>`
  + exit 1.

## Acceptance (the test reads labels/limits from the data, never copied literals)
1. Every kind returns <= 6 rows, in data order, ids match the data; unknown kind -> [].
2. Each enable rule above: one enabled case and one disabled case with the exact reason text and HH:MM formatting (e.g. minute 840 -> "14:00").
3. A disabled row is still present (never hidden). An enabled row has reason "".
4. coach_rows ordering (available first, fit, hours, id) on a 4-coach fixture; the three greyed reasons; the no-coach row.
5. Purity: actions() twice with the same ctx gives equal results; the ctx passed in is not modified; editing a returned row does
   not change the next call.
MUTANTS (comment block at the bottom; run them if you can; each must turn the test red): hide disabled rows; drop the
station_occupied_until check; sort coaches by name only; format 840 as "14:0".

## Parse gate + test
`python Godot/tools/check_scripts.py Godot/scripts/ThingActions.gd Godot/tests/thing_actions_test.gd`
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/thing_actions_test.gd`
No Godot in your sandbox? Say so in the PR body; do NOT build Godot from source.

## Prior research
J64 (click-a-thing survey: RimWorld float menu, Sims pie menu, Two Point, Planet Zoo complaints about hidden actions), J61, GYM4.

## What would a human do?
Write the rules as a table in data, one function that reads it, and a test that walks every row enabled and disabled.

## Prefab check
UI later uses "Radial Menu Control" (Godot Asset Library #3469, MIT) - NOT in this task.

## The one trap
Type every Variant read (`var m: int = int(ctx.get("now_minute", 0))`); never reuse a variable name in one function.
