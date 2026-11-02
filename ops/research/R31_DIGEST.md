# R31 — THE RING (Claude)

The tenth and last legacy replacement. `RingNightView.gd` (1,792 lines) is
deleted, not migrated; `RingStagePanel.gd` replaces it as the body of
`FightNight.tscn`, built on Kalli K16's HYBRID pick and Codex C15's read.

## What shipped

- **The seam K16 was asked to settle is closed.** The ring was a 1920×1080
  arcade canvas SCALED into the frame's 912-tall slot. It is now authored
  at the slot's own size: `SetpieceRoot._mount` mounts a scene body 1:1
  when it answers `adopt_body_size()` and keeps the old scaling holder for
  anything that does not. (A full-rect scene must NOT have `size` written
  on mount — that writes its offsets and doubles it.)
- **The stage stays a stage.** Venue plate, the ruleset's own floor, two
  silhouettes, impact bursts and the evade streak survive as
  `UIKit.ring_stage` plus two ported inner classes. Gone with the view:
  FIGHT! / ROUND N wordart, the damage-number rain, the six-region body
  map, the duplicate names, clock and log the K7 frame already prints.
- **Seven kit factories, one "ring" family, 14 book variants**:
  `ring_stage`, `condition_rail`, `move_strip`, `corner_dock`,
  `combo_alert_8s`, `verdict_stamp_ring`, `watch_mode_chip`.
- **ONE dock, four dresses, never a modal**: standing pace calls (live
  idle, applied without stopping the clock), the between-rounds menu with
  the coach's own call starred, the eight-second combo answer with LET THE
  CHAIN GO, and the dimmed AI CORNER a watch gets. It never moves — the
  test asserts identical position and size across dresses.
- **WATCH is a real mode now.** `setup(bout_id, "watch")`, and a booked
  bout with no fighter of ours resolves to it rather than to a dead dock.
- **Region damage lands on the condition rail** (head/body/legs/gas from
  C15's contract) and accumulates: a coarser live read never restores a
  region the exchanges already hurt.
- **The host keeps the fight.** Tick, corner instructions, finish and
  `setup()` are unchanged in behaviour; the corner bar it used to draw
  over the ring is now the panel's dock and the host only supplies the
  options and takes the presses.

## One fix outside the plan

`GameState.classify_ring_method()` (C15) mapped any string containing
"tko" to TECHNICAL — and the simulation's only finish string is
`"KO/TKO"`, so **every knockout stamped TECHNICAL SUPERIORITY**, which
K16 explicitly rules is not a knockout. The mapper now takes a `ko` TOKEN
or the word "knockout" as KO; a bare `"tko"` still reads TECHNICAL, so
C15's own `ring_api_test` assertion is untouched. Codex has been told.

## Evidence

Parse gate 8/8. `ring_stage_panel_test` 34/34 (new), `combo_show_test`,
`ring_night_command_bar_test`, `ring_api_test`, `fight_playback_test`,
`setpiece_root_test`, `setpiece_panels_test`, `scene_router_test` (204),
`ui_kit_book_test` (275 variants, 275 renders after
`tools/render_kit.gd` re-run windowed) all green, then the full suite.

## Next

THE DAY (R32) waits on Kalli K18 and Codex C16.
