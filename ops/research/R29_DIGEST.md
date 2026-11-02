# R29 DIGEST — THE BOOT

The eighth replacement and the second outside the career shell. `MainMenu.gd`
(691) + `MainMenu.tscn` and `Splash.gd` (73) + `Splash.tscn` are DELETED; the
gate is now `BootRoot.tscn` — K14's chrome built ONCE above a body slot, with
the BODY swapping between three boards, so a board move is the settle and
never a load. `run/main_scene` is BootRoot.

## What shipped

- **`BootChrome.gd`** — the FOURTH chrome (brand + body + foot): no rail, no
  step strip, no committed trail, no Continue strip. `frame_for` / `build` /
  `apply` / `read`, the SetpieceChrome pattern.
- **`BootRoot.gd` + `BootRoot.tscn`** — three boards (`title`, `slots`,
  `settings`), the twin 780 ms seams (fold 180 + shutter 220 here; the
  destination's chrome owns lock 240 + settle 140), and the intro film.
- **`TitleBoardPanel.gd`** — brand, the newest life behind one GREEN
  CONTINUE, gold NEW CAREER, LOAD and SETTINGS. No save on disk means no
  green at all: there is nothing to continue.
- **`SlotsBoardPanel.gd`** — three rows in C12's three states, delete and
  overwrite each behind a confirm sheet, gold on the selected row's forward
  action and never on a delete.
- **`SettingsBoardPanel.gd`** — music level and mute, window mode,
  resolution, vsync, frame limit; the ruleset stated, not picked.
- Kit family **"boot"**: 6 factories / 15 variants (`boot_chrome`,
  `slot_row`, `continue_affordance`, `settings_row`, `confirm_sheet`,
  `boot_seam`), book **240 across 19**.

## Three calls beyond the study

1. **The film survives, the scene does not.** K14 discarded Splash as a
   *title*; the intro itself is content, and deleting it was not the study's
   call to make. It plays as a cover inside BootRoot on the first boot of the
   process, skippable by any input, over a title board that is already built.
2. **No APPLY on settings.** K14 drew a gold APPLY, which assumes a form that
   commits. `UserSettings` applies and writes `settings.cfg` on every setter,
   so the board says changes are already saved and spends no gold. Master and
   SFX are not drawn either: there is one audio bus in the game.
3. **The ruleset is read-only.** `begin_new_career()` resets
   `selected_ruleset_id` to boxing, so a picker would be overwritten by the
   next thing the player does (K12's PHONE precedent).

## Reads and writes

Reads are C12's (`a2677d4`): `get_save_slots`, `get_latest_save_summary`,
`get_save_summary`. Writes are the three the boot has always owned —
`load_career`, `begin_new_career`, `delete_save` — and `begin_new_career`
only ARMS a slot, so nothing is written until creation finishes. LOAD and
CONTINUE now land on **`day_feed`** (K14's seam), not `office_menu`.

## Sweep

`SceneRouter`: tier-0 is four ids on one scene (`boot`, `boot_slots`,
`boot_settings`, and `main_menu` kept as the title's alias because
`ManagementChrome.gd:422` and `CountryMap.gd:43` name it); `splash` retired
with its scene; `_ready()` starts on `boot`; a `board` key merges like `tab`
and `phase`, and a boot route swaps in place on the running root. Repointed:
`project.godot`, `smoke_test`, `scene_router_test`, `menu_modernization_test`
(its MainMenu dossier claim became the title board's; every GameState
assertion kept), `text_overflow_audit`, `CaptureManagementPreviews`,
`CaptureStage3CodexPreviews`, and four `UserSettings.gd` comments.

## Known seam

NEW CAREER hands off to `country_map`, the pre-kit creation chain, because
R28 has not shipped. The seam is K14's; only the destination moves when
CreationChrome lands.

## Evidence

Parser green on every touched script. `boot_root_test` 26/26,
`boot_panels_test` 44/44, `ui_kit_book_test` 0 failures (240 variants, 240
rendered), `scene_router_test` 202/202, `menu_modernization_test` 16/16,
smoke green, `text_overflow_audit` 0 overflows, full suite green.
Pictures: `DesignLibrary/screens/boot/` (8 boards, `tools/render_boot.gd`).
