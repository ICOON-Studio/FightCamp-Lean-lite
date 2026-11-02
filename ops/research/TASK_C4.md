# TASK C4 — CODEX — the GYM hub read API

Model: medium.
Self-contained. Read this file and nothing else. Do not read
`HANDOFF_ARCHIVE.md`; do not read `GameState.gd` whole (~10.4k lines),
use the anchors below. START WHENEVER YOU HAVE CREDITS — not gated on a
date, and Kalli's K8 study does not block you: the data is fixed below.
One session: when it ships, end it.

## Why this exists

User decision 2026-09-05: every legacy screen is thrown away and rebuilt
from the UI kit as a panel hosted by CareerRoot. The first is the GYM hub
(Claude, R21), replacing `RosterScreen` and `GymFloor`. As C2 fed the
event screens, this task gives the GYM panel ONE read-only projection so
the screen never assembles its data from a dozen getters. Pure logic,
headless-testable, no screen.

## What to build

Two functions appended to `Godot/scripts/GameState.gd` after
`get_fight_record_stats` (line ~10192). Read-only, deterministic, no side
effects, every value from the save.

    func get_gym_hub() -> Dictionary
    func get_fighter_flags(athlete_id: String) -> Array

`get_gym_hub()` returns:

    {"gym": {id, name, city, country, tier, fame, money, week, day},
     "fighters": [ one per roster athlete, roster order:
        {id, name, age, sex, discipline, discipline_label,
         weight_class, weight_class_label,
         record: {wins, losses, draws, ko, sub, dec},
         condition, morale,
         injury: {held: bool, reason, weeks_left},
         weight: {kg, limit_kg, over_pct, status},
         loyalty: {score, band}, contract: {weeks_left, wage},
         plan: {label, stations: [ids]},              # this week
         next_bout: {bout_id, event_id, opponent_name, org_name,
                     weeks_out, days_out, title: bool} or {},
         camp: {active, focus} or {},
         flags: get_fighter_flags(id),
         overall: int} ],
     "floor": {capacity, used, expansion_cost, can_expand, grid: {w, h},
        equipment: [{instance_id, def_id, name, category, x, y, w, h,
                     rotation, condition, repair_cost, needs_repair,
                     users: [athlete ids training on it this week]}]},
     "market": [{def_id, name, category, price, footprint: {w, h},
                 affordable, fits, reason}],
     "staff": [{id, name, role}],
     "counts": {fighters, injured, booked, asks_open, in_camp}}

`get_fighter_flags(id)` returns an Array of `{"id", "level", "text"}`
(`level` is "red" or "amber") in priority order, the seven kinds the
profile's action row already derives: `medical_hold`, `ask`, `weight`,
`contract`, `loyalty`, `empty_book`, `training_blocked`. The RULES are
the profile's: in `Godot/scripts/ProfileRevampPanel.gd` grep
`medical_hold_until_week` and read that one function (about 40 lines
around 195-230). Mirror its thresholds exactly; do not import or edit
the screen. Claude switches the profile onto your function in R21 so the
two never drift.

Reuse, never re-derive (GameState.gd line anchors): `get_roster` 3299,
`get_athlete` 3307, `get_staff` 3303, `get_gym` 2927, `get_floor` 2931,
`get_floor_capacity` 2935, `get_used_floor_space` 2940,
`get_equipment_instance` 2947, `get_repair_cost` 3010,
`get_floor_expansion_cost` 3041, `can_place_equipment` 3071,
`world_discipline_label` 2503, `get_fight_record_stats` 10192 for the
record, `get_weight_status` and `get_athlete_loyalty` (grep), the open
asks and the booked-bout lookup the profile uses
(`ProfileRevampPanel.gd:150-180`, the `_call("get_...")` names). The
equipment catalog and the store: grep `purchase_equipment` and the
catalog loader near `get_equipment_instance`. A value with no source is
`{}` or 0, never a guess; the digest lists every such field.

## Rules

- No new save fields. Nothing is written. Built on demand, no caching.
- `%%` inside format strings; `var x: T = ...` for Variant returns; never
  reuse a variable name inside one function.
- Do not edit any screen, scene, UIKit, the router, `project.godot`, or
  a test other than your own.

## Files you own

`Godot/scripts/GameState.gd` (append only), `Godot/tests/gym_hub_test.gd`
(new), `research/C4_DIGEST.md` (new, short), your own block in
`HANDOFF.md`.

## Test (the one command)

`gym_hub_test.gd` seeds through the `DevJump` autoload
(`DevJump.seed({"slot": 9, "route": "gym_floor", "week": 6, "booked": true})`,
API at `Godot/scripts/DevJump.gd:35`; set
`SceneRouter.navigation_enabled = false` first) and asserts: every roster
athlete appears once, in order; the booked fighter's `next_bout` is
filled and `days_out` matches the calendar; a fighter put on medical hold
in the test (set `medical_hold_until_week` on the loaded athlete's body
state, or use the real injury path) gets `medical_hold` red first;
`floor.used` equals `get_used_floor_space()` and is at most `capacity`;
every market item's `affordable` equals money >= price; `counts` agree
with the arrays; two calls return equal dictionaries and the save is
unchanged. Then run `profile_revamp_test.gd` and `smoke_test.gd`.

    python Godot/tools/check_scripts.py Godot/scripts/GameState.gd Godot/tests/gym_hub_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_hub_test.gd

Full suite once before the commit (Git Bash, from `Godot/`, `GODOT` = the
console exe): `for f in tests/*.gd; do timeout 600 "$GODOT" --headless
--path . --script "$f" >/dev/null 2>&1 || echo "FAIL rc=$? $f"; done`.
Check `git status -s` first, `git add -- <your files>` only, one commit,
push `master` if you can (else Claude pushes), then convert your
`HANDOFF.md` block to COMPLETE with the hash (max 8 lines).
