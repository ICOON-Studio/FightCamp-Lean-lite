# TASK GYM4H - the club's greyed ring rows open the screens that already exist

Model: Cursor (Godot UI/gameplay scripts). Worktree E:/FightCamp/wt/GYM4G (has the Godot import cache; branch cursor/gym4h-ring-rows from origin/master).
Tier: two scripts edited + a new test -> parse gate + the new test + `--only gym_club` and `--only gym_hall` neighbours (`--jobs 2`).

## Prior research
`python Tools/prior_research.py ring action club office` -> J64_CLICK_A_THING_ACTIONS (RimWorld float menu: unavailable rows stay,
greyed, WITH a reason - never hidden, never dead), GYM4_REDESIGN_S178.md (the office window = the club's management menus; interviews
AT THE RECEPTION DESK), TASK_GYM4F_ACTION_RING.md. S180 built the ring (ClubActionRing) and GymClub3D carries out only
`WIRED` = station train_here/coach_here, fighter call_coach/rest, coach coach_fighter. Every other row is greyed "Not in this build yet".
`GymClub3D` emits `action_requested(kind, id, action_id)` for rows it does not carry out - and NOTHING listens to it (GymHallPanel never
connects it). Gap: the office window's rows, the fighter/coach profile, the walk-in interview.

## What would a human do?
Point each row at the screen the game already has for it (Two Point's office menu opens the existing hire/finance screens), keep the rest
greyed with an honest reason, and make the interview row open the interview panel the hall already shows at the desk.

## Prefab check
None needed: SceneRouter routes and InterviewPanel exist; this is wiring.

## Owned files
- `Godot/scripts/GymClub3D.gd` (1381 lines; read `sed -n 20,35p`, `sed -n 1270,1340p`). `WIRED` const line 27; `ring_ctx()` ~1276
  builds `ctx["blocked"]` (rows not in WIRED -> LATER_REASON); `_on_ring_action()` ~1310 emits `action_requested` for the rest.
- `Godot/scripts/GymHallPanel.gd` (324 lines, read whole). `rebuild()` builds the hall and connects `expansion_requested` (~line 72);
  `_on_expansion(route)` ~293 pushes a SceneRouter route; `show_today()` ~104 shows `show_interview` / `show_coach_hire` for the
  scouting board's candidate.
- New test `Godot/tests/gym_club_ring_routes_test.gd`.
- Read only: `Godot/assets/data/thing_actions.json` (the rows), `Godot/scripts/SceneRouter.gd` `ROUTES` (lines 40-170).

## Build - the decided table (do not invent other routes)
Add to GymHallPanel a `const RING_ROUTES := {...}` and `static func ring_route(kind: String, action_id: String) -> String` ("" = none):
| kind | action_id | route |
|---|---|---|
| office_window | hire | `scouting` |
| office_window | money | `finances` |
| office_window | calendar_offers | `calendar` |
| office_window | messages | `story_inbox` |
| office_window | week_review | `week_review` (ONLY when `GameState.get_last_week_report()` is non-empty; otherwise the row stays blocked with "No week finished yet") |
| fighter | profile | `fighter_card` with `{"athlete_id": <the club's fighter id>}` (as GymHubPanel.gd:388 pushes it) |
| fighter | day_plan | `training` |
| coach | profile | `staff` |
Everything else (upgrades, talk, train_at, drill_focus, send_to_station, week_hours, talk_contract, queue_next, what_it_trains, upgrade,
greet, trial_session, come_back_later, send_away, walk_in profile) STAYS greyed with LATER_REASON - unchanged.
1. GymClub3D: a row with a host route is no longer blocked. Do it with a settable `var routed: Dictionary = {}` ({kind: [action_id...]})
   that `ring_ctx` treats like WIRED, and `blocked_reasons: Dictionary = {}` ({"kind/action": reason}) for host-supplied reasons
   (the week_review one). Default both empty, so the scene alone behaves exactly as today.
2. GymHallPanel.rebuild(): when the hall has `action_requested`, set `hall.routed` from RING_ROUTES (minus week_review when there is no
   report, which goes into `blocked_reasons` instead) and connect `action_requested` -> `_on_ring_action(kind, id, action_id)` which pushes
   `ring_route(...)` through the same router path `_on_expansion` uses (fighter_card with the athlete_id arg).
3. Walk-in INTERVIEW: route `walk_in/interview` for `fighter_candidate` and `coach_candidate` visitors (GymClub3D knows the visitor kind in
   `_plans[id]["kind"]`): the host calls the SAME `show_interview` / `show_coach_hire` that `show_today()` uses, with the scouting board's
   next candidate of that kind (fighters / staff). Other visitor kinds keep interview greyed with "Only a fighter or coach comes to interview".

## Acceptance (the one test)
`Godot_v4.7.2-stable_win64.exe --headless --path Godot --script tests/gym_club_ring_routes_test.gd` -> `GYM CLUB RING ROUTES PASS`, rc 0:
- `ring_route` returns exactly the table above for each row and "" for every other row in thing_actions.json (iterate the json, so a new
  row reads "").
- every route `ring_route` returns is a key of `SceneRouter.ROUTES` (derive, never copy the list).
- a GymClub3D built with `load_models = false` and `routed` set: `ring_ctx("office_window", "office")["blocked"]` no longer has hire /
  money / messages / calendar_offers and still has upgrades with LATER_REASON; with `routed` empty (the scene alone) all six office rows
  are blocked (CONTROL - the scene's default is unchanged).
- week_review blocked with "No week finished yet" when the host passes that reason.
- `_on_ring_action` on a routed row emits `action_requested` once (connect a lambda counter).
- MUTANT: make `ring_route` return "" for `money`; at least one check must go red - say in the commit that you ran it.
Neighbours: `python Godot/tools/run_tests.py --only gym_club --jobs 2` and `--only gym_hall --jobs 2` stay green (gym_club_3d_test 154/0).
Parse gate first: `python Godot/tools/check_scripts.py scripts/GymClub3D.gd scripts/GymHallPanel.gd tests/gym_club_ring_routes_test.gd`.

## The one trap
`GymClub3D` is also built by tests with no host: the routed/blocked tables MUST default empty, or gym_club_3d_test's "every other row stays
greyed" checks change meaning. And headless tests do not run `godot` with `_console.exe` (it opens a terminal on the operator's screen) -
use `Godot_v4.7.2-stable_win64.exe --headless`.

No images, videos or windows opened: never `start`, Invoke-Item or a browser; view files with your file tool only. Commit to your branch
with `git add -- <paths>`, push it, and stop; Claude reviews and merges.
