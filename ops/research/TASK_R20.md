# TASK R20 — CLAUDE — the spine: router, career root, fight night

Stage A of the scene-tree plan (user greenlit 2026-09-04). Scope is
steps 1-3 only. The panel migration of the eleven screens is R21; the F9
dev-jump lander is Codex C3. Do not start either here.

## The problem being fixed

1. Navigation is 34 hardcoded `change_scene_to_file` calls across 11
   scripts. No back stack — the only memory is a one-slot string,
   `UserSettings.return_scene_path`, plus a second one-slot
   `pending_office_module`.
2. `ShellChrome` (R17) is rebuilt inside each scene instead of living
   above them, so the rail flickers on every jump and three scripts use
   it against thirteen still on the legacy `ManagementChrome` header.
3. Fight night has no scene. `RingNightView.gd` (1,764 lines) is
   `.new()`d as a child in TWO hosts — `OfficeHub.gd:3451` (match
   simulator) and `EventDetailScreen.gd:590` (watch view) — so the
   biggest moment in the game is a widget with two maintainers.

## Step 1 — SceneRouter, behaviour unchanged

New `Godot/scripts/SceneRouter.gd`, autoload. Route ids are the CONTRACT
shared with C3 — the career ids are the existing module ids verbatim, so
the rewrite is mechanical and nothing is renamed:

    boot:      splash, main_menu
    creation:  country_map, city, gym_pick
    career:    day_feed, gym_floor, roster, fighter_card, training,
               calendar, events, event_detail, scouting, rankings,
               office_menu, staff, contracts, finances, objectives,
               phone, weight_class
    set-piece: fight_week, weigh_in, fight_night, fight_result, crowning

    func go(route_id: String, args := {}) -> bool   # replace
    func push(route_id: String, args := {}) -> bool # onto the stack
    func pop() -> bool                              # real back, any depth
    func depth() -> int
    func current() -> Dictionary                    # {"route", "args"}

Rewrite all 34 call sites to route by id. Nothing looks different yet;
the graph stops being hardcoded and BACK stops being one level deep.
Retire `UserSettings.return_scene_path` and `pending_office_module` —
`args` carries what they carried. Leave the deprecated setters in place
returning early, so nothing external breaks mid-stage.

## Step 2 — CareerRoot and the persistent shell

New `Godot/scenes/CareerRoot.tscn` + `Godot/scripts/CareerRoot.gd`.
Mounts ShellChrome ONCE with a ContentStack beneath it; the router swaps
the stack's child, never the whole tree. The panel contract already
exists and is proven twice — copy it exactly:

    DayFeedScreen.gd:26  rebuild(): remove_child + queue_free every child,
      load(SHELL_PATH).call("build", self, game_state, nav_id, on_continue)
      -> shell dict; panel.position = shell["content_position"];
      panel.setup(game_state, self, on_continue)

Route the three scripts already on ShellChrome into it — `day_feed`
(`DayFeedScreen.gd`), `fighter_card` (`AthleteProfileShellScreen.gd`,
note its `z_index = 20` and `closed` signal), and the office menu. Every
other career route keeps loading its own scene through the router this
stage; R21 converts them.

Scene scripts compile BEFORE the autoloads: fetch the router with
`get_node_or_null("/root/SceneRouter")` plus `has_method`, never the bare
identifier. Same rule that governs `GameState` in these files.

## Step 3 — Fight night gets its scene

New `Godot/scenes/FightNight.tscn` + `Godot/scripts/FightNightScreen.gd`.
One entry contract: `setup(bout_id: String, mode: String)` where mode is
`"live"` (a booked player bout) or `"test"` (the match simulator).
`RingNightView` becomes its child and keeps its own API untouched — this
is an extraction, not a rewrite of 1,764 lines.

Then both hosts route to it instead of constructing it:
- `OfficeHub.gd:3451` — the `fight_test` module routes to
  `fight_night` with `mode: "test"`; delete `_test_ring_night`.
- `EventDetailScreen.gd:590` — the watch view routes with `mode: "live"`;
  delete `_watch_view`.
Both currently return to their host on finish; the router's `pop()` does
that now, which is why step 1 lands first.

## Rules

- Parse gate BEFORE any test: `python Godot/tools/check_scripts.py <files>`.
  A parse error hangs a headless test until the timeout instead of failing.
- New `Godot/tests/scene_router_test.gd`: every route id resolves; push
  then pop returns to the prior route with its args; pop at depth 0 is a
  safe false; an unknown id is a safe false, never a crash; `fight_night`
  in both modes; the three ShellChrome routes mount inside CareerRoot.
- Add `res://scenes/CareerRoot.tscn` and `res://scenes/FightNight.tscn`
  to `smoke_test.gd`'s SCENES list. Do NOT add a top-level preload of
  either script to smoke_test — `load()` inside `_initialize()`.
- Full suite ONCE before the commit, in the background, summary only.
- Owned files: new `SceneRouter.gd`, `CareerRoot.gd`, `CareerRoot.tscn`,
  `FightNightScreen.gd`, `FightNight.tscn`, `scene_router_test.gd`;
  edits to `project.godot` (autoload lines for SceneRouter AND Codex's
  DevJump), `UserSettings.gd`, `smoke_test.gd`, and the 11 scripts
  holding call sites. `R20_DIGEST.md` and my own HANDOFF block.
  NOT `DevJump.gd` (C3), NOT `GameState.gd`.
- `var x := <call>` fails when the call returns Variant — write the type.
- Commit, push `master`, write the digest, END the session.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
research/R20_DIGEST.md
```
