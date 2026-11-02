# TASK_ZIVAFOOT1 - smooth the Playbook player's footwork, pivots, slips and rolls (Ziva)

Model: Ziva Smart (effort max). Discipline: boxing (demo). Seat: Ziva, worktree E:\FightCamp\wt\ZIVA_LEAN.

## Why (operator, verbatim)
- "animations need work"
- "slip and roll are good, still need a lot of smoothing and better timing blending ... it's fun to do a" (S359, on the
  Playbook player - Lean scripts/fight3d/MovePlayer.gd:386 quotes it in full)
He likes the Playbook's Combos tab ("really fun to try and also learn from the book"); the Moves and Game plan tabs (rebuilt
S360, Lean 7749bec) play every move on the fighter's body through the same MovePlayer. What he sees there is the product.

## Start
```
cd E:\FightCamp\wt\ZIVA_LEAN
git fetch origin
git checkout -b ziva/footwork1 origin/main      # Lean main c37006f or later; leave ziva/smooth3-r4 as it is
```
Run Godot only headless or on the hidden desktop (`python tools/hidden_desktop.py run ...`), `--audio-driver Dummy`,
every probe at `--fixed-fps 30`. Nothing opens on the operator's monitors.

## The job
The moves below look stiff or snap when one clip hands over to the next in MovePlayer (the step's glide, the pivot's turn,
the slip/roll into the counter, the return to guard). Make every hand-over blend:
`step_in`, `step_out`, `step_back`, `pivot_out`, `roll_out`, `slip 2-3`, `slip 2-3@own_ropes`, `feint`, `push_off`, `cut_off`.

1. RED FIRST - write `tools/join_probe.gd` (headless, `--fixed-fps 30`): for each move above, MovePlayer.show_move(id) on the
   Playbook body (as tools/move_player_probe.gd does), sample every frame and print per move:
   `JOIN <id> max_jump_deg=<the largest single-frame rotation change of any of: pelvis, spine_03, neck_01, head, both
   upperarms, both thighs, both calves> at_t=<s> foot_lift_m=<max ankle height above the floor> travel_m=<pelvis travel>`
   and a last line `JOIN_SUMMARY worst=<deg> mean=<deg>`.
   Run it on origin/main untouched and paste the output into docs/ziva/ZIVAFOOT1_result.md as BEFORE.
2. Fix in MovePlayer.gd / Footwork.gd only: cross-fades at the clip joins (blend time per pair, not one constant), the guard
   return eased, the pivot's turn spread over its frames instead of landing in one, the slip/roll held at its deepest frame
   (MovePlayer.DEF_PEAK_S / defence_peak_probe.gd numbers) before the counter starts. No new clips; no clip files edited.
3. AFTER: the same probe on your branch.

## Acceptance (all of them, from the probe output - not from a description)
- `JOIN_SUMMARY worst` at least 40 % below BEFORE, and `mean` lower.
- No move's `travel_m` changes by more than 10 % (the step still arrives where the map says) and no `foot_lift_m` above 0.12 m
  (no feet flying).
- `tools/defence_peak_probe.gd` deepest-frame shares within 0.05 of BEFORE (the counter still starts at the deepest point).
- These tests stay green: `move_book_test game_plan_test combo_builder_test move_clips_test strike_browser_test`
  (`<godot.exe> --headless --audio-driver Dummy --path . --script res://tests/<name>.gd`, exit 0 and its PASS line).
- A film for the operator: `tools/playbook_film.gd` on the hidden desktop, the ten moves in a row, saved to
  docs/playtest/ZIVAFOOT1/footwork.mp4 (before and after side by side if you can; after alone is fine).
- Push `ziva/footwork1`; in docs/ziva/ZIVAFOOT1_result.md: BEFORE and AFTER probe lines, the test lines, the film path.

## The one trap
SMOOTH3 rounds 4-5: a result file re-quoted old numbers. Paste the probe's own output lines, copied from the run you just
made on that commit, with the commit hash beside them. A number without its run is not accepted.

## Contract
OWNS: Lean/scripts/fight3d/MovePlayer.gd, Lean/scripts/fight3d/Footwork.gd, Lean/tools/join_probe.gd, Lean/docs/ziva/ZIVAFOOT1_result.md
RED_TEST: Lean/tools/join_probe.gd (BEFORE on origin/main)
REGRESSION: move_book_test, game_plan_test, combo_builder_test, move_clips_test, strike_browser_test
VISUAL: Lean/docs/playtest/ZIVAFOOT1/footwork.mp4 (Claude opens it; the operator judges it)

## Prior research
SMOOTH3 r4-r6 (Game/research/S358_DIGEST.md, Lean docs/ziva/SMOOTH3_r6_diagnosis.md): the fight's kinks are mostly
the clips' own joins, not the reach layers - the same cause the Playbook player shows alone.

## What would a human do?
An animator scrubs each join and sets a blend per pair; a boxing coach wants the feet under the hips the whole time.

## Prefab check
Godot's AnimationPlayer cross-fade (play(name, custom_blend)) and AnimationTree transitions cover it; no new asset needed.
