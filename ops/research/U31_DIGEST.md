# U31 DIGEST — THE SEAT CHIP

Cursor · 2026-09-10 · FightHudPanel only. G38 §5 as written.

## What landed

- Seat chip from the fold's `grapple` block: visible only when `grappling` and
  `stance != standing`, labels from G38's table, `{CORNER} · {LABEL}` when
  `top` is a side (RED/BLUE), bare label when `top` is empty. GUARD stays up
  with a top. Missing `grapple` key draws nothing.
- Attempt pips: five discrete steps while `submission_open`, bands
  0–19 / 20–39 / 40–59 / 60–79 / 80–100, label `SUB {SEAT}`, on the top side
  (orphan under the chip when `top` is empty). Hidden otherwise.
- Stall colour on the chip: amber at `stall_ticks >= 300`, red at `>= 400`.
  No countdown number.

## Refused (asserted)

No control clock, no control-unit counter, no points, no input prompt, no chip
on the feet. No meter.

## Gate

- parse: `CHECK total=2 fails=0`
- `fight_hud_panel_test`: 150 checks, 0 failures
- full suite: see commit mail
