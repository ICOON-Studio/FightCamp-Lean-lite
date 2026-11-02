# TASK C221 - CODEX - CLIPS FOR THE 47 MOVES THAT PLAY NOTHING (S114)
Owner: codex. Model: gpt-6-astra, medium (3D animation: generation, retarget, binding). `CODEX_WEB=live` allowed.
Assigned 2026-09-27 (S114). Branch `codex/c221-none-clips` from `origin/master`, own worktree. Claude merges.

## Why
The operator asked "what is the status with the uncompleted stances in the moves". Re-measured S114 with
`tools/q133_clip_coverage.gd`: of 534 motion techniques, 158 have their own clip (EXACT 26 + NEAR 132), 315 borrow a
family clip, 14 are GAP and **47 are NONE - in a fight the fighter holds his stance through the move**. Those 47 are
the visible failure. Unchanged since S62.

## Prior research (checked S114)
`Q133_DIGEST.md` (the census and what was wired), `Q157_DIGEST.md` (grappling coverage by family),
`Q159_DIGEST.md` / `Q160_DIGEST.md` (the 66-technique striking gap ALREADY PRICED - reuse it, do not re-price),
`HIGGSFIELD_PROMPT_LOG.md` (every job so far, verbatim prompts - reuse what worked), `HIGGSFIELD_MMA_PIPELINE_STUDY.md`
and `G76_TWO_FAILURES_AND_WHAT_ELSE.md` / `G77_GENERATE_TWO_BODIES.md` (two bodies fail: single actor only),
`C207_DIGEST.md` (the Kimodo -> FightClipRetarget route).

## What would a human do?
A game animation lead with a mocap budget: list the missing moves, shoot (or generate) one clean solo take per move,
retarget to the house skeleton, check contact and timing on the real rig, and bind it. One take per move, judged on
the rig, never on the generator's preview.

## Prefab check
Owned first: RamsterZ Hand to Hand Set (124 FBX, already bound), CMU mocap (free, permissive; C219/C220 bake path),
Cascadeur (kept, Pro). Generated: Higgsfield Kimodo text-to-motion, 0.1 credit a job, one body per clip - the route
you used in C207 (`research/C207_DIGEST.md`). **Buying clips is OFF** (operator 2026-09-24 preview-quality
ruling). For each move, name which source it came from and why.

## Build
1. Add `-- --list none` (and `gap`) to `Godot/tools/q133_clip_coverage.gd` so it prints each NONE/GAP technique id,
   branch and discipline. Commit the list into your digest.
2. For each NONE move, in this order: an owned clip that fits (RamsterZ / CMU) -> bind it; else ONE Kimodo job with a
   precise prompt (stance, lead side, target height, recovery to guard). Grappling moves: a single actor performing
   the technique (operator 2026-09-22 ruling) - never try two bodies.
3. Retarget through `FightClipRetarget` exactly as C207 did; bind in `FightClipBinding.gd` so q133 reports it EXACT
   or NEAR. Loop/recovery must return to the guard pose the stance uses.
4. Measure on TWO DIFFERENT rigs: feet stay planted where the move plants them (no skate >0.05 m), no floor
   penetration, strike peak within the move's timing window if it has one. Print achieved beside wanted.
5. Render a short MP4 per 10 moves (`tools/record_room.gd` or your C189 control-arm viewer) into
   `previews/c221/` - the operator judges by eye.

## Budget
Up to **15 credits** of Higgsfield in this task (about 150 Kimodo jobs; expect ~47 plus retries). Log every job in
the ledger: `python -m Tools.higgsfield.budget` (the operator's standing 150-credit allowance governs the total).

## Gate (tier: script edited)
Check the PC first (`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\pc_watchdog.ps1 -Once`; exit 1 = stop).
Parse gate on touched `.gd`; then
`python Godot/tools/run_tests.py --jobs 1 --only clip,binding,retarget,technique,fight_stage`
no worse than master at branch point. Coverage: NONE must drop from 47; report the new EXACT+NEAR share. Renders
through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Owned files
`Godot/scripts/FightClipBinding.gd` (binding rows only), `Godot/tools/q133_clip_coverage.gd`, `Godot/tools/c221_*.gd`,
new clips under `Godot/assets/anim/` (raw sources to `D:/FightCamp_originals/c221_source`, never the repo),
`previews/c221/`, `research/C221_DIGEST.md`.

## Deliver
Commit and push AS YOU GO; digest (moves done, source, measurements, credits spent); one line with
`python Tools/agent_comms.py send --from codex --to claude --topic C221 --body "..."`. Do NOT edit HANDOFF.md.
**Trap:** q133's NEAR match is a name match - a clip bound under the right id but showing the wrong move still counts.
Open each render; a move is done when it LOOKS like the move, not when the census moves.

## S114 AMENDMENT - the five missing pieces (operator: "fix all this"), BINDING on this task
1. **Solver: SAM 3D Body / MHR first** (permissive; quote its licence line in the digest). SMPL/SMPL-X/BUDDI stay banned.
2. **Calibration take in EVERY clip:** the clip opens with the performer(s) in a T-pose, then a slow range of motion (arms up /
   out / forward, knees up, hips turn), standing on a mat printed with a 1 m grid, in the colour-graded cell suits, same locked
   cameras. Use it to fix bone lengths, scale, floor plane and camera before solving the move.
3. **Camera consistency:** in any split-screen clip, measure how far the two panels disagree (reprojection error of the solved
   joints into each view, and the time offset between panels) and print it; do not trust a joint above the threshold you state.
4. **Cleanup is a fixed row, not optional:** after the solve, lock planted feet (skate p95 <= 0.05 m), snap declared contacts,
   clamp to joint limits, remove floor penetration - in Blender via the MCP - then run the two-rig gates.
5. **Shot list:** shoot to `research/SHOT_LIST_GROUND.md` (START / READY / SUCCESS / DENY / CANCEL per ground-graph edge)
   so clips chain on shared seat poses.
