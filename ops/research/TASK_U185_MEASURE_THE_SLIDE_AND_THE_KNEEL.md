# TASK U185 - CURSOR - MEASURE THE SLIDE THAT U184 WAS MEANT TO REMOVE, AND FIND THE KNEELING BOXER (S90)
Owner: cursor. Assigned S90, 2026-09-26. Model: composer-2.5 (Cursor pool), normal effort.
Branch: `cursor/u185-planted-slide`, cut from `cursor/u184-steps` (5ff06498) in Temp/FightCamp-U171 - your U184
step planner is the starting point. Do NOT merge master into it; Claude merges.

## Why (read this first)
U184 is NOT merged. Its gate was met to the letter - toe skate 2.0387 -> 2.0152 m/s - and that is the problem: a 1%
change, while the two men travel only ~0.75 m/s (10.67 m over 427 frames). **A skate reading larger than the travel
itself is not measuring the slide** - it is the idle clip's own foot motion. The gate was written badly (Claude's, not
yours): "AFTER lower than BEFORE" can be passed by noise. So we do not yet know whether U184 works.
Second: the gym-spar render (`docs/previews/u183/arena_spar_gym.png` on master AND your u184 one) shows the
black-shorts boxer in a DEEP LUNGE with his rear knee almost on the canvas, at R1 2:52 of a technical spar. That is
pre-existing, not yours, and it is the first thing a viewer sees.

## What would a human do?
An animator checking foot sliding scrubs the clip frame by frame with the foot's world position pinned on screen: while
the foot is PLANTED (weight on it, heel down) its world position must not move; it may only move while it is in the
air. He measures slide as planted-foot world speed, not toe speed over the whole clip. And a boxing coach seeing a
fighter drop his rear knee to the canvas in a technical spar would stop the round - it is not a stance, it is a fall.

## Do
1. **The right instrument.** In your `tools/u184_boxing_skate.gd` (or a new `tools/u185_planted_slide.gd`): per foot,
   per frame, classify PLANTED (the foot lock's own plant flag, or foot height <= 0.03 m AND foot speed below the
   lock's release threshold - name which) vs SWING. Report on footwork beats, both men, seed 94301: planted-foot world
   speed p50 / p95 (m/s), the share of planted frames sliding faster than 0.10 m/s, and swing frames per metre
   travelled. BEFORE (planner off) beside AFTER. Print achieved beside wanted.
2. **Prove the instrument can read worse** before you trust it: a mutant that drags the planted foot with the root
   (no plant at all) must read clearly worse than BEFORE.
3. If AFTER does not cut planted slide, fix the planner until it does, or say plainly why not.
4. **The kneel.** Find which take / frame puts the rear knee near the canvas at R1 ~2:52 in
   `tools/u184_render_gym_spar.gd`'s spar (print the clip id, the technique id, knee height m). Then either fix it (a
   clip that should not bind here, an IK solve, a lunge depth) or report it with the evidence and a proposed fix.
   Add a check: no knee below 0.25 m on idle/footwork beats across the spar.

## Owned files
`Godot/scripts/FightStepPlanner.gd`, `Godot/tests/fight_step_planner_test.gd`, `Godot/scripts/FightStagePlayer.gd`
(the lock/step section only - 4,500 lines, NEVER open it whole; sed -n windows around `busy_technique`, `set_foot_lock`
`:3040-3110`, `foot_lock_stats` `:3213`, and your U184 hook), `Godot/tools/u184_*.gd` / `u185_*.gd`,
`research/U185_DIGEST.md`, `previews/u185/`. If the kneel lives in `FightClipBinding.gd`, you may edit
the one binding row and say so.

## Gate (a CEILING - over-deliver and say so)
- Planted-foot slide on footwork beats: AFTER p95 <= 50% of BEFORE p95, printed side by side, and the drag-with-root
  mutant reads worse than BEFORE (proves the instrument moves).
- The kneel: found (clip + technique + height) and fixed, or reported with evidence; no knee < 0.25 m on idle/footwork
  beats if fixed.
- U183's gate still true: foot <= 0.10 m, knee rise <= 0.12 m on the nine boxing footwork rows.
- `fight_step_planner_test`, `fight_foot_lock_test`, `fight_leg_ik_test`, `boxing_footwork_clearance_test`,
  `spar_watch_test`: 0 failures, plus the planner's two mutants red.
- Re-render the gym spar (hidden) and LOOK at it; put it in `docs/previews/u185/`.

## Tier
Script edited: parse gate (`python Godot/tools/check_scripts.py <touched .gd>`), the focused test, then
`python Godot/tools/run_tests.py --only step_planner,foot_lock,leg_ik,boxing_footwork,spar_watch,fight_stage --jobs 1`.
If the runner flakes on a missing audio import in this worktree, run those tests one by one and say so. No full suite.
Every windowed Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Research
All research is open: root `RESEARCH_INDEX.md` (U92, U93, C116, U183, U184). Do NOT read HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md, and do not explore to "get oriented".

## Done
Commit (explicit paths), push the branch, write `research/U185_DIGEST.md` (the before/after/mutant table, the
kneel finding, the render), then
`python Tools/agent_comms.py send --from cursor --to claude --topic U185 --body "<planted slide p95 before->after, mutant, kneel>"`.

## The trap
A number that moves 1% is not a result. If your planted-slide AFTER sits within a few percent of BEFORE, the planner is
not acting on the planted foot - look at which foot the hook moves and when, before tuning any constant.
