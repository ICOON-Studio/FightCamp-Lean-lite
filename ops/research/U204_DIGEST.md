# U204 digest — menu and room effects

Operator 2026-10-01: effects on fights, menus, and rooms.

## Shipped
- `Godot/scripts/UiFx.gd` — `fade_slide_in`, `hover_scale`, `count_up` / `count_up_money`, `pop`; `set_effects` / `effects_on` (off when headless).
- `Godot/scripts/RoomFx.gd` — `dust_motes`, `light_shaft`, `apply`.
- `SceneRouter.gd` ~377–381: `pre_hosted_panel_push` before hosted `show_route`.
- `CareerRoot.gd` ~258–260: `UiFx.fade_slide_in` on every hosted mount.
- `UIKit.gd` ~1256–1257 button hover; ~421–424 stat row count-up; ~2901–2906 `money_display`.
- Room `_apply_room_fx` / `RoomFx.apply`: `TrainingFloor3D.gd` ~121–125; `Office3D.gd` ~81–84; `Lobby3D.gd` ~64–67; `LockerRoom3D.gd` ~71–74; `MatRoom3D.gd` ~62–65; `StaffRoom3D.gd` ~64–67; `PhysioRoom3D.gd` ~67–70.
- `Godot/tests/ui_fx_test.gd`; `smoke_test.gd` disables effects with transitions.
- Stills: `previews/u204/` (before/after × 3 screens + 3 rooms). Capture: `Godot/tools/CaptureU204Effects.gd`.

## Evidence
- Parse gate clean on 15 touched scripts; `ui_fx_test` 7/0; `run_tests.py --jobs 2 --only ui_fx,office_room,locker_room,lobby,mat_room,staff,physio,training_floor` → SUITE total=8 fails=0.
- Open stills under `previews/u204/` before merge.

## Next
- Wire `UIKit.money_display` into `ShellChrome` cash chip when cash delta is known.
- Fight set-piece burst hooks (separate from menu/room pass).
