# TASK R31 — CLAUDE — THE RING

Model: Opus, high effort, Fast off (the last legacy replacement, a new
stage canvas, and the tick loop it hangs off).

## Spec

The tenth and final legacy replacement, and the centrepiece. Kalli K16
(`TASK_K16.md`, `K16_DIGEST.md`) picks **HYBRID**: rebuild the ring as a
kit-native body that fills the K7 set-piece slot, keep a dedicated **ring
stage canvas** for the fight picture, and build the instrument layer —
condition rail, move strips, corner dock, combo alert — as kit overlays.
Rejected in the study: keep-and-scale (the 1920×1080 arcade canvas shrunk
into the slot, which is what ships today) and a pure re-dress.

Codex C15 (`b433ced`, `C15_DIGEST.md`) closed every read K16 named:
`get_ring_read_contract(bout, fight_state, observation_mode)` and
`classify_ring_method(method)` at `GameState.gd:11916-11929`. The contract
returns `mode` / `is_watch` / `show_stakes`, per-side
`condition_rail {head, body, legs, gas}`, `chips` (MISSED WEIGHT, CAME IN
HURT), `plan {pace, emphasis, contingencies[] with one starred}`,
`incoming_combo {active, seconds, chain_name, links_landed, links_total}`
and `method_stamp` (IPPON / TECHNICAL / DOCTOR / DECISION / KO). No further
GameState work: this is a straight build.

Four boards, one panel differently dressed (K16 §B–E):

- **ROUND** — live coaching. Priority order is fighters + condition, then
  action on the stage, then move strips, then region detail on the rail.
  Gold ×1 on the pace call.
- **CORNER** — between rounds. The same dock morphs in place into the
  contingency menu with the plan's own call STARRED. Gold ×1 there.
- **COMBO** — the dock becomes the 8-second wall-clock bar plus **LET THE
  CHAIN GO**. Never a modal over the ring during live action.
- **MOMENT** — the verdict stamp set. Doctor / stoppage is semantic **BAD**
  red, never gold. **IPPON and TECHNICAL superiority are not knockouts** and
  get their own stamps. Green stays CONTINUE only, on the result way-out.

Modes: **LIVE** (full dock, stakes in the K7 head), **TEST** (LAB chip in
the foot, `show_stakes` false — the frame's stake line must not show a
career purse), **WATCH** (dock dimmed, AI CORNER chip, no player pace
calls). Watch is new to the screen: `setup(bout_id, mode)` accepts it, and
a live bout with no coached side (`FightNightScreen.gd:438`) resolves to it
rather than to a dead dock.

Dropped with the old view: FIGHT! and ROUND N wordart (K7's clock and phase
cell own those), duplicate fighter names (the K7 head owns them), damage
number rain as the primary read.

## Owned files

- New: `Godot/scripts/RingStagePanel.gd`,
  `Godot/tests/ring_stage_panel_test.gd`
- Edited: `Godot/scripts/FightNightScreen.gd` (mounts the panel where it
  `.new()`d the view at `:286`, keeps the tick loop / finish / `setup`,
  gains "watch", hands its corner bar to the dock and drops `BAR_RECT`,
  `CORNER_X`, `CORNER_BOX`), `Godot/scripts/UIKit.gd` (the seven K16
  instruments: `ring_stage`, `condition_rail`, `move_strip`, `corner_dock`,
  `combo_alert_8s`, `verdict_stamp_ring`, `watch_mode_chip`),
  `Godot/assets/data/ui_kit_manifest.json` (new "ring" family),
  `Godot/scripts/TaleOfTheTape.gd` (`:284` expects the view to own
  `show_tape`; the panel takes that seam, the tape itself is kept),
  `Godot/tools/CaptureFightSceneFx.gd`,
  `Godot/tools/CaptureTaleOfTheTapePreview.gd`,
  `Godot/tools/CaptureRingNightCommandBarPreview.gd`,
  `Godot/tests/combo_show_test.gd` (`:25`, `:35`),
  `Godot/tests/ring_night_command_bar_test.gd`,
  `Godot/tests/smoke_test.gd` (`:803` reads `RingNightView.presentation`).
- Deleted: `Godot/scripts/RingNightView.gd` (1792 lines),
  `Godot/tests/ring_night_view_test.gd`.

Keep, do not rewrite: the fight tick, the corner listen rate, combo
resolution, body-region damage feeding back into the sim. R31 replaces the
picture and the instruments, not the fight.

## Parse gate

`python Godot/tools/check_scripts.py Godot/scripts/RingStagePanel.gd Godot/scripts/FightNightScreen.gd Godot/scripts/UIKit.gd Godot/scripts/TaleOfTheTape.gd Godot/tests/ring_stage_panel_test.gd Godot/tests/ring_night_command_bar_test.gd Godot/tests/combo_show_test.gd`

## Test command

`Godot_v4.7.2-stable_win64_console.exe --headless --path Godot --script tests/ring_stage_panel_test.gd`

Then `tests/combo_show_test.gd`, `tests/ring_night_command_bar_test.gd`,
`tests/ring_api_test.gd` and `tests/fight_playback_test.gd`, then the full
suite once — including `tests/ui_kit_book_test.gd`, which needs
`tools/render_kit.gd` re-run windowed for the seven new factories.
