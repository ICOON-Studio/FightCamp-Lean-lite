# TASK U82 - CURSOR - THE TRIPTYCH GETS A FLOOR, ONE FACING AND A SIDE VIEW

Model: Composer (`composer-2.5`), **medium effort**. Owner: cursor. Launched `-p --force --trust`.
Stage: S4a (brief: `research/R141_WHY_THE_CLIPS_LOOK_BAD.md`). Follows your U81.

**Test tier: A TOOL YOU OWN IS EDITED. No shipped script.** Parse gate, run, gate script.

## Owned files

- `Godot/tools/capture_retarget_triptych.gd` - yours from U81 (merged, `d612a4b`).
- `previews/s4a/*.png` - the 18 front sheets re-rendered, plus 18 NEW side sheets.
- `research/U81_TRIPTYCH.md` - update it to describe the new framing.

Do NOT edit any other file, not the gate scripts, not `.import` files.

## Why this exists

Claude opened your redone sheets. The panels are isolated now and all three animate - and the
knockdown on f01 shows the retarget following the source's fall closely. But the sheets still
cannot answer the two questions S4a exists for:

1. **FLOOR CONTACT.** Each cell frames its own body's AABB, so a body floating 0.95 m above the
   canvas (C100 measured exactly that) is drawn centred and looks fine. There is no floor.
2. **REACH.** The source skeleton and our fighter do not face the same way on screen - the source
   reads as a side view and the fighter as a front view - so the f01 jab's extension at 0.33 s is
   visible in the SOURCE panel and foreshortened toward the camera in both retarget panels.

## The contract

1. **One camera per sheet column, fixed for all six rows.** Frame each panel ONCE from the union of
   that subject's bounds over all six sampled times (plus a margin), so height above the floor is
   comparable from row to row. A falling man's head must go DOWN the cell.
2. **A floor in every cell**: a thin horizontal line or grid at the subject's floor height - world
   Y = 0 for the fighter, and the T-pose's lowest foot height for the source skeleton.
3. **One facing.** Rotate each subject so its REST-pose forward (the hips' forward vector) points
   the same world direction, and use the same camera angle for all three panels.
4. **Two views per pair.** The existing front three-quarter sheet, and a SIDE sheet with the camera
   90 degrees from that forward (the jab's reach lies across the screen). Names:
   `previews/s4a/<clip stem>__<fighter>.png` (front) and
   `previews/s4a/<clip stem>__<fighter>__side.png` (side). 36 sheets, same 6 clips x 3
   fighters as U81, same 3 x 6 grid, each cell at least 320 px.

## Gate - in this order

1. `python Godot/tools/check_scripts.py Godot/tools/capture_retarget_triptych.gd`
2. Render the f01 jab and knockdown sheets first and OPEN them: in the side jab sheet the source's
   arm extends across the screen at 0.33 s; in the knockdown sheets the head drops down the cell
   and a floor line is visible in every cell. Then render all 36.
   `python C:\Users\user\AppData\Local\Temp\FightCamp-tools\godot_run.py . tools/capture_retarget_triptych.gd --windowed --timeout 2400`
3. `python research/U82_check.py` - must exit 0. It runs U81's checks on all 36 sheets, and
   checks the knockdown's head really drops within a fixed frame.

## The trap specific to this task

**Framing per cell is what made a floating body look grounded.** Do not "fix" a cropped stick
figure by shrinking the camera to fit each cell again - fit the union of all six rows once.

## When you are done

Commit the tool, `U81_TRIPTYCH.md` and the 36 PNGs by path (never a check script, never an
`.import`), `git show --stat HEAD`, push `master` is NOT yours - push your branch
`cursor/u82-triptych-floor`, send `python Tools/agent_comms.py send --from cursor --to claude --topic U82 --body '<one line>'`
and commit that mail file by path. Do NOT edit `HANDOFF.md`. Never stash, reset --hard,
checkout . or clean.
