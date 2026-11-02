# TASK R21 — CLAUDE — the GYM hub, the first replacement panel

Model: high (this stage sets the pattern every later hub copies; the
later hubs run medium).
Starts when: the user has approved Kalli's K8 boards AND Codex's C4 has
landed on `origin/master`. Not date-gated. One session; end it on ship.

## Why

User decision 2026-09-05 (HANDOFF, Direction notes): legacy scenes are
discarded, not migrated. The GYM hub replaces `RosterScreen` and
`GymFloor`, is hosted by CareerRoot, is built only from the kit, on the
approved K8 boards, and reads Codex's `get_gym_hub()`.

## Build, in this order

1. **Kit gap.** Every instrument `K8_DIGEST.md` names that the book
   lacks goes into `UIKit.gd` as manifest family "gym" with variants and
   the parity test, as R18 did with family "profile".
2. **`Godot/scripts/GymHubPanel.gd`** (no `.tscn`: CareerRoot mounts a
   panel by script path). Tabs ROSTER / FLOOR plus the STORE drawer; one
   `get_gym_hub()` read per rebuild; `host_shell`, `host_continue` and
   `apply_route_args(args)` exactly as `AthleteProfileShellScreen.gd`
   does them; a row click pushes `fighter_card`. The floor picture reuses
   `GymFloorGrid.gd` only if it meets the visual bar, else it is redrawn
   with the kit.
3. **Router.** `roster` and `gym_floor` become panel routes to the hub
   with `args.tab` (`SceneRouter.gd:48-49`). The rail follows K8's answer
   (one GYM item, or both entries landing on the two tabs).
   `ManagementChrome.NAV_ITEMS` (line 38) still feeds ShellChrome until
   the last legacy screen dies.
4. **Profile.** `ProfileRevampPanel.gd`'s action row reads
   `get_fighter_flags()` (C4) instead of its own derivation;
   `profile_revamp_test` stays green.
5. **Pictures.** `Godot/tools/render_gym_hub.gd`, modelled on
   `render_profile_revamp.gd` (windowed, not headless), renders every
   board to `DesignLibrary/screens/gym_hub/`. The user judges them
   before step 6.
6. **Delete the legacy pair.** `RosterScreen.tscn/.gd`, `GymFloor.tscn/.gd`
   (and `GymFloorGrid.gd` if unused). Drop them from `smoke_test.gd`
   SCENES (lines 15-16) and its two load sites (521, 548). Retire or port
   the tests that exist only for them, keeping every assertion that is
   about GameState: `equipment_market_filter_test`,
   `equipment_tile_label_test`, `gym_floor_layout_test`,
   `office_nav_and_profile_overlay_test`, `menu_modernization_test`,
   `shared_header_rollout_test`, `ia_v2_polish_test`,
   `live_refresh_test`. The `Godot/tools/Capture*Previews.gd` tools that
   load the pair: delete a tool that exists only for them, else drop the
   entry. `AthleteDevelopment`, `EventsBoard`, `ManagementOverview`,
   `OfficeHub`, `AthleteProfileScreen` reference the names: verify by
   grep that no scene path remains.
7. **Legacy flags: not this stage.** `EventsBoard`, `OfficeHub` and
   `ScheduleBoard` still read them; the digest records the count left.

## Gate

    python Godot/tools/check_scripts.py Godot/scripts/GymHubPanel.gd Godot/scripts/UIKit.gd Godot/scripts/SceneRouter.gd Godot/scripts/ProfileRevampPanel.gd
    Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/gym_hub_panel_test.gd

Then `scene_router_test`, `profile_revamp_test`, the kit parity test,
`smoke_test`; the full suite once before the commit. Digest
`research/R21_DIGEST.md`; cite the hash in the next digest.

## Owned files

<!-- Backfilled 2026-09-08. This file predates the owned-files gate, so `done --task` found nothing to check and passed vacuously. Every path below comes from this task file's own parse-gate command, test command, build sections and shipped deliverables - none was invented. -->

```
Godot/scripts/GymHubPanel.gd
Godot/scripts/UIKit.gd
Godot/scripts/SceneRouter.gd
Godot/scripts/ProfileRevampPanel.gd
Godot/tests/gym_hub_panel_test.gd
research/R21_DIGEST.md
```
