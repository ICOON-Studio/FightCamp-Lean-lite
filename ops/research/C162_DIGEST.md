# C162 — CORNER UI

Implemented one adapter-driven `CornerPanel` control, exposed a standalone
mount helper, and mounted the same control over the live 3D room through a
`CanvasLayer`.  The card reads the
current fighter state, uses the K72 instruction sentences, wraps its SAY copy,
applies a selected instruction through `FightBeatAdapter`, and has an explicit
no-op skip.  Its `_gui_input` consumes mouse events before the room's free
camera `_unhandled_input` can orbit or zoom.

## Gates

- Parse: `CHECK total=3 fails=0` (the existing `FightAudio` preload warning on
  `FightWorldLiveScreen.gd` remains).
- `python Godot/tools/run_tests.py --only corner`: `SUITE total=5 fails=1`.
  The new `corner_panel_test.gd` passes; the one failure is the pre-existing
  `corner_instruction_contract_test.gd` compile/engine error: `Identifier not
  found: FightAudio`.
- `python Godot/tools/run_tests.py --only ui`: `SUITE total=17 fails=0`.

## Mutation witness

| Mutant | Result |
|---|---|
| Hardcode the option list | RED |
| Ignore the chosen instruction | RED |
| Return the pre-change state | RED |

`MUTANTS total=3 red=3 missed=0`.

## Still wrong

The unrelated corner contract test still cannot compile because its loaded
room path references `FightAudio`; resolving that belongs outside this UI task.
The live-room overlay currently gives the player's `a` corner the between-round
choice; a future bout host can pass an explicit player side if that room stops
assuming `a` is ours.
