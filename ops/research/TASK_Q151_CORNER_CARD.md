# TASK_Q151 - the corner card says what each instruction means, and fits (Qwen)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S60, 2026-09-23.

## What the operator saw (screenshot, between rounds)
Six instructions, but "Stay long - stop chasing", "Get inside" and "Hold the centre" all read
`SAY: HOLD CENTRE - NO CHANGE OF GEAR`, and "Push forward" / "Go for the finish" share one line.
The last button hangs OUTSIDE the card.

## Cause (read, not guessed)
`Godot/scripts/CornerPanel.gd:152` `_copy_for(option)` looks the SAY line up by `option.pace`
only (3 paces, 6 options). The card is a fixed `CARD_SIZE := Vector2(760, 520)` (:12) and each
button is `custom_minimum_size = Vector2(712, 58)` (:135) - six of them plus header do not fit.

## Owned files
`Godot/scripts/CornerPanel.gd` (241 lines - read whole), `Godot/tests/corner_card_copy_test.gd` (NEW),
`research/Q151_DIGEST.md`.

## Spec
1. Each option gets its OWN corner line, keyed on its id/intent (read what keys the adapter's
   options carry - `FightBeatAdapter` corner options; grep "adapter_options"), written as a cornerman
   would say it, in the same caps style. Pace-only copy stays as the fallback for an unknown option.
2. The card fits its options: height derived from option count (header + n x button + spacing),
   or a ScrollContainer - no button may extend past the card's rect. Never assign `size` on an
   anchored Control (R31); set offsets/minimum size.
## Gate (tier: script edited)
- Parse gate. Test: for the adapter's real option list, every option's SAY line is DISTINCT, and
  every button's rect lies inside the card's rect after layout (read rects after a frame).
- `run_tests.py --only corner`, `--only ui`. Still: one render of the card with 6 options via
  `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`,
  into `previews/corner_card/` - OPEN it and say what each line reads.
- Branch `qwen/q151-corner-card`, digest, one agent_comms.py send. Do NOT edit HANDOFF.md.
