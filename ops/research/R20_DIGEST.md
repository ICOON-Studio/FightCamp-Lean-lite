# R20 DIGEST — the spine: router, career root, fight night

Stage A of the scene-tree plan (user greenlit 2026-09-04). Step 1 (the
router) shipped as `1fb4257`; steps 2 and 3 (`CareerRoot.tscn` with the
persistent shell, `FightNight.tscn`) ship in the commit that carries this
digest. The step-1 notes are kept below as written; the steps 2-3 notes
follow them.

## What shipped

`Godot/scripts/SceneRouter.gd`, autoload (registered in `project.godot`
after `FeedbackOverlay`). Navigation is now a route id and an args
dictionary. No screen names a `.tscn` any more.

    go(route_id, args)        # replace, clears the stack
    push(route_id, args)      # forward, remembering the way back
    pop()                     # real back, ANY depth
    back_or(route_id, args)   # pop if possible, else go — what BACK wants
    replace(route_id, args)   # swap route, keep the stack
    take_args() / peek_args() # the destination reads its arguments
    routes() / describe(id) / current() / current_nav() / depth() / peek()
    clear_career_stack()      # career-scoped, see below

All 34 `change_scene_to_file` call sites across 12 scripts are migrated,
plus a 35th that grep did not find: `ScheduleBoard._open_route` set
`return_scene` and then delegated to `ManagementChrome.navigate_to`, with
no `change_scene_to_file` of its own. Searching for the flag writes as
well as the scene changes is what surfaced it - worth doing again in R21.
The only remaining occurrence in `Godot/scripts/` is inside the router.
Each screen got one small `_route(route_id, args, mode)` helper —
`ManagementChrome`'s is `static` and takes the owner, because that chrome
is called from screens rather than mounted.

## The route table (the contract, shared with C3)

    boot:      splash, main_menu
    creation:  country_map, city, gym_pick
    career:    day_feed, gym_floor, roster, fighter_card, training,
               calendar, events, event_detail, scouting, rankings,
               office_menu, staff, contracts, finances, objectives,
               phone, weight_class, today, fight_test, live_fight
    set-piece: fight_week, weigh_in, fight_night, fight_result, crowning

CHANGED SINCE `TASK_C3.md` WAS WRITTEN: `today`, `fight_test` and
`live_fight` were added to the career tier — they are real OfficeHub
modules with real call sites, and leaving them out would have meant
migrating those sites twice. Purely additive; nothing Codex builds
against the original list breaks.

`fight_week` and `weigh_in` are in the table with `scene: ""`. They are
contract-only until their scenes exist, and `go()` REFUSES them with a
named warning rather than half-navigating. `describe()` reports
`built: false`. That is deliberate: a route that lies is worse than a
route that is missing.

## Two things found by building it

**1. Absolute autoload paths fail before the tree enters.** In a
`--script` SceneTree run the autoloads are already under `root`, but
`is_inside_tree()` is false and `/root/UserSettings` does not resolve
until the first idle frame. The router's legacy write-through was
silently doing nothing for any early navigation — the class of bug that
lands the player on the wrong module and takes an afternoon to trace. It
now resolves UserSettings through `get_parent()`, which works in both
contexts. Any autoload reaching another autoload should do the same.

**2. `change_scene_to_file()` is not inert in a headless test.** It frees
the current scene and detaches the autoloads mid-run, so a test that
exercised real navigation was testing Godot's teardown. The router grew
`navigation_enabled`: false does every piece of bookkeeping — route,
stack, args, legacy flags — and skips only the swap. `scene_router_test`
sets it false. **Codex: DevJump wants this too** — it seeds a career and
names a route without going anywhere.

## The legacy flag transition (read before R21)

Five one-shot `UserSettings` flags carried what `args` now carries:
`return_scene_path`, `pending_office_module`, `pending_event_id`,
`pending_schedule_progression`, `pending_schedule_focus_offer`.

They are NOT deleted yet. The router writes them through on every
navigation (`LEGACY_ARG_FLAGS`), so unmigrated screens keep reading
exactly what they always read. What changed is that no screen SETS them
any more — only the router does. That is what makes them safe to delete
in R21, and why this rewrite could be incremental instead of a big bang.

`return_scene_path` is the one that is genuinely gone: `back_or()`
replaces it with a real stack. The old handler could only ever land on
one hardcoded default, which is why backing out of two levels used to
dump you at the office instead of where you actually were.

## Tests

`Godot/tests/scene_router_test.gd` — 135 checks, 0 failures. Covers every
id in the contract resolving with the right tier, the unbuilt routes
reporting themselves unbuilt, two-deep push/pop (which the old one-slot
flag could not express), `pop()` at depth 0 as a safe false, a refused
push leaving no phantom entry, args consumed exactly once, module routes
supplying their own module arg, the legacy write-through, and
`clear_career_stack()`.

Three existing tests asserted the old one-slot flags directly and moved
onto the stack contract, each keeping its original intent and gaining a
second half:

- `world_management_ui_test` — scene-path assertion became a route
  assertion PLUS a router-mapping assertion.
- `contract_dossier_test` and `scouting_hotspot_fix_test` — both checked
  `return_scene_path == OfficeHub`; they now check that the router stack
  points back at `office_menu`, which is the thing they were really
  claiming. Both set `navigation_enabled = false` first.

## Steps 2 and 3 (the second commit)

### Step 2 — CareerRoot, the persistent shell

`Godot/scenes/CareerRoot.tscn` + `Godot/scripts/CareerRoot.gd`. The root
builds ShellChrome ONCE (`ShellChrome.build(self, game_state, nav_id,
on_continue)`) above a `ContentStack`; the router swaps the stack's child
and never the tree. The shell is rebuilt only when the lit rail item
changes or the day advances (Continue advances the day, rebuilds the
shell's numbers, then calls the content's `rebuild()`).

A hosted screen is the EXISTING screen script, told it is hosted: the root
sets `host_shell` (the shell handles, including `content_position`) and
`host_continue` on the node before it enters the tree, and calls
`apply_route_args(args)` if the script has it. `DayFeedScreen.gd` and
`AthleteProfileShellScreen.gd` grew those two properties and build only
their body when `host_shell` is non-empty; standalone they build their own
shell exactly as before (the roster's profile overlay is untouched). The
hosted node is full-canvas with `MOUSE_FILTER_IGNORE`, so the rail beneath
it still takes clicks; its own children still take theirs.

Router side: a route with a `"panel"` key is hosted. Its `scene` is
`CareerRoot.tscn`; `describe()` now reports `panel` and `hosted`. In
`_enter()`, when `tree.current_scene` has `show_route()` the swap is in
place (`show_route(route_id, args)`, pending args cleared), otherwise the
root is entered and reads the route back from `current()` in `_ready()`.
Only `day_feed` and `fighter_card` are hosted this stage.

DEVIATION FROM THE TASK FILE: it names "the office menu" as the third
ShellChrome screen. It never was - the three ShellChrome scripts were
`DayFeedScreen`, `DayFeedPanel` and `AthleteProfileShellScreen`;
`OfficeHub.tscn` is on the legacy `ManagementChrome` with the other
twelve and moves in R21. The profile's standalone BACK now uses the
router's real stack (`back_or("roster")`) instead of `navigate_to`.

### Step 3 — FightNight.tscn

`Godot/scenes/FightNight.tscn` + `Godot/scripts/FightNightScreen.gd`. One
entry, `setup(bout_id: String, mode: String) -> bool`:

    mode "live":  bout_id = FightNightScreen.live_bout_id(event_id, bout_index)   # "<event_id>#<index>"
    mode "test":  bout_id = FightNightScreen.lab_bout_id(a_id, b_id, ruleset_id)  # "lab|a|b|ruleset"

Arriving through the router, `_ready()` takes `{"mode", "bout_id"}` from
`take_args()`. A refused setup (unknown mode, missing fixture, not the
event's day) shows the reason and a BACK instead of a half-built ring.
The screen owns, once, what both hosts each had a copy of: the 1.4 s
tick timer, the coached-corner rule (lab = both corners; a player's own
bout = theirs; a spectator watch never pauses), the INTERRUPT / GIVE
ADVICE command bar at the authored 302,590 / 1316x300 footprint, the
finish (`show_result`), the live record
(`record_watched_world_bout` with the player's technique usage riding
along) and the player's FightResultScreen overlay. `RingNightView` is a
child with its API untouched. Leaving is `router.back_or(...)`: pop() to
the desk or the event that pushed it.

Both hosts route now: OfficeHub's `_on_run_test_fight_pressed` pushes
`fight_night` in "test" mode (the desk keeps the fighter/ruleset picker;
the scaled ring host card became a note card); EventDetailScreen's
`_watch_bout` pushes it in "live" mode after its own fight-day gate.
Deleted: 21 functions and 14 vars from OfficeHub (-497 lines: the whole
lab driver, decision panel and five test seams), 16 functions and 12
members from EventDetailScreen (-287 lines: the watch overlay, corner
panel, finish and result overlay). `fight_test` stays the desk's route;
`live_fight` (the older in-office live module, not a RingNightView host)
is untouched.

### Tests (steps 2-3)

`scene_router_test.gd` grew from 135 to 176 checks: hosted routes
describe themselves, CareerRoot opens on the router's route, mounts THE
DAY and the fighter card in turn with one child in the stack, keeps the
rail node across a same-nav jump and rebuilds it when the lit item moves,
refuses a non-panel route; FightNight takes mode and bout from the
router's args, runs the lab bout to a real result with no career result
overlay, pops back to the office on leave, refuses a missing live bout
and an unknown mode by name, and can be set up again.

Five tests moved from the deleted host seams onto the scene, keeping
every original assertion: `smoke_test` (RUN TEST FIGHT pushes the route;
the scene runs the corner-instruction loop and the 2X/4X timer scaling),
`ring_night_command_bar_test`, `combo_show_test`,
`event_detail_screen_test` (WATCH pushes `fight_night` live; the scene
watches the bout to its recorded result and pops back to the event) and
`booking_eligibility_visibility_test`. Every test that triggers a route
sets `SceneRouter.navigation_enabled = false` first. `CareerRoot.tscn`
and `FightNight.tscn` are in the smoke SCENES list; a cold CareerRoot
(no career) builds only its stack.

FOUND BY BUILDING IT: a test must `load()` `FightNight.tscn` inside its
function, never `preload` it at the top - the scene's script preloads
`FightSimulation.gd`, and compiled before the autoloads that script fails
and `begin_fight` is "nonexistent" at runtime. Same class as the
`smoke_test.gd` rule in CLAUDE.md, now proven for a scene too.

## What is left for R21

- The eleven legacy screens become panels hosted by CareerRoot; the five
  legacy `UserSettings` flags and `LEGACY_ARG_FLAGS` are deleted together.
- `SceneRouter.clear_career_stack()` is not yet called from GameState's
  career load / new career (GameState.gd is not R20's file).
- (Done in this commit: Codex's C3 landed as `1e61deb` while steps 2-3
  were being built, so `DevJump="*res://scripts/DevJump.gd"` is now in
  `project.godot`; `dev_jump_test` passes with it registered.)
- `fight_week` and `weigh_in` stay contract-only (`scene: ""`) until the
  K7 set-piece frame lands.

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/SceneRouter.gd Godot/scripts/CareerRoot.gd Godot/scripts/FightNightScreen.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/scene_router_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/event_detail_screen_test.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/smoke_test.gd
