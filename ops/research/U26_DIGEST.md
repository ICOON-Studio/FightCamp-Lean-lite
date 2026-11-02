# U26 digest — GrappleResolve.gd

Branch: `cursor/u26-grapple-resolve-fb05`

## Delivered

- `Godot/scripts/GrappleResolve.gd` — pure statics: `takedown_resolve`,
  `position_resolve`, `submission_advance`, `position_points`. One preload
  (`FatigueCurve.gd`). Caller passes `roll`; missing stats default to 50.
- `Godot/tests/grapple_resolve_test.gd` — contract checks plus finish-rate sweep.

## Finish-rate sweep (measured)

At progress 100, dominant (80s) vs weak (40s), 1000 rolls 0..1:

**finish_rate_per_attempt = 0.1430 (143/1000)** — ~1 in 7, inside the 1-in-6
to 1-in-8 attempt band. `FINISH_P = 1/7`; rarity lives in `finish_p`, not a
hidden auto-finish at 100 progress.

C67 blind contract: all GrappleResolve assertions **PASS**; sole suite failure
is missing `GrappleSeat.gd` (Q19, not U26).

## Suite

`SUITE total=211 fails=1` — expected until Qwen lands GrappleSeat.
