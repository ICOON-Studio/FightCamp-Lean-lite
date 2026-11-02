# TASK R29 — THE BOOT (Claude)

Model: top tier, effort high, Fast off. One stage, one commit, push `master`.

## Why

The eighth replacement and the SECOND outside the career shell. `MainMenu.gd`
(691 lines) and `Splash.gd` (73) are the last two pre-kit scenes the game
actually opens on — the player's first frame is still a 2026-08 screen with
its own colour constants, its own overlays and its own settings form. Kalli's
K14 study (`research/K14_DIGEST.md`, `BOOT_K14.html`) ruled the shape; Codex
C12 (`a2677d4`) delivered the read this build needs.

## What K14 ruled (obeyed, not re-litigated)

- **TWO BOARDS — TITLE then SLOTS**, plus SETTINGS. One combined board and
  splash-as-title were both rejected.
- **BootChrome, the FOURTH chrome**: brand bar + body + foot. No rail, no
  step strip, no committed trail, no Continue strip. ShellChrome is
  career-only, CreationChrome's identity IS its steps (K13), K7 is fight gear.
- **Slot row carries**: gym name, city/country, career week, cash, roster
  count, discipline label, last played, newest mark. Alerts, payroll, injured
  counts, staff tallies, portraits, tier stats stay OFF — they are GYM/OFFICE
  after load.
- **Twin 780 ms seams**: fold 180 → shutter 220 → destination lock 240 →
  settle 140, for NEW (creation) and LOAD/CONTINUE (THE DAY) alike.
- **Empty slots are an invitation**, never an error; incompatible saves are
  their own state (C12's `incompatible` + `save_version`).
- **No form family** — settings compose from `pair` + track fill + `chip`.
  Gold ×1 per board.

## Deliver

NEW `Godot/scripts/BootChrome.gd` — build once, re-letter per board
(`SetpieceChrome.gd` is the pattern: `frame_for` / `build` / `apply` / `read`).

NEW `Godot/scenes/BootRoot.tscn` + `Godot/scripts/BootRoot.gd` — the host.
Chrome once above a body slot, the BODY swaps between three boards, so a
board move is the settle and never a load (`SetpieceRoot.gd` is the pattern).
It owns the twin seams and the intro film.

NEW bodies: `TitleBoardPanel.gd`, `SlotsBoardPanel.gd`, `SettingsBoardPanel.gd`.

NEW UIKit family **boot**: `boot_chrome`, `slot_row`, `confirm_sheet`,
`settings_row`, `boot_seam`, `continue_affordance` — with manifest entries in
`assets/data/ui_kit_manifest.json` (the book test fails on a factory with no
entry).

## Rules

- **Reads are C12's**: `get_save_slots()`, `get_latest_save_summary()`,
  `get_save_summary(slot)`. Writes are the three the boot has always owned:
  `load_career`, `begin_new_career`, `delete_save`. Nothing else.
- LOAD/CONTINUE lands on **`day_feed`** (K14's seam), not `office_menu`.
- The **intro film survives** as a cover inside BootRoot (skippable, fades to
  TITLE). The pre-kit `Splash.tscn` does not.
- **Ruleset stays read-only.** `begin_new_career()` resets
  `selected_ruleset_id` to boxing (`GameState.gd:2522`), so a picker would be
  a lie. Draw the state, not a dead control (K12's PHONE precedent).
- Settings draw what `UserSettings` actually stores — music volume/mute,
  display mode, resolution, vsync, FPS. Master/SFX buses do not exist; a dead
  slider is worse than no slider.
- Transitions behind a static flag every test and tool turns off (R27's rule:
  an awaited tween HANGS a headless run instead of failing it).

## Delete, with the sweep

`scripts/MainMenu.gd` (+`.uid`), `scenes/MainMenu.tscn`, `scripts/Splash.gd`
(+`.uid`), `scenes/Splash.tscn`. Repoint: `SceneRouter.gd` (boot tier,
`main_menu` kept as an alias id so `ManagementChrome.gd:422` and
`CountryMap.gd:43` keep working), `project.godot` `run/main_scene`,
`tests/smoke_test.gd`, `tests/scene_router_test.gd`,
`tests/menu_modernization_test.gd`, `tools/text_overflow_audit.gd`,
`tools/CaptureManagementPreviews.gd`, `tools/CaptureStage3CodexPreviews.gd`.
Every GameState assertion in a touched test is KEPT.

## Owned files

Everything above, plus NEW `tests/boot_root_test.gd` and
`tests/boot_panels_test.gd`. Codex owns `GameState.gd` (C13 is open in it) —
this stage does not touch it.

## Parse gate, before any test run

```
python Godot/tools/check_scripts.py Godot/scripts/BootChrome.gd Godot/scripts/BootRoot.gd Godot/scripts/TitleBoardPanel.gd Godot/scripts/SlotsBoardPanel.gd Godot/scripts/SettingsBoardPanel.gd Godot/scripts/UIKit.gd Godot/tests/boot_root_test.gd Godot/tests/boot_panels_test.gd
```

## Test

```
Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/boot_root_test.gd
```

Then `boot_panels_test.gd`, `ui_kit_book_test.gd`, `scene_router_test.gd`,
`smoke_test.gd`, then the full suite once before the commit.

## Finish

`git status -s` first, `git add -- <files>` only, one commit, push `master`,
convert the HANDOFF block to COMPLETE with the hash (max 8 lines), write
`research/R29_DIGEST.md`.
