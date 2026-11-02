# TASK U184 - CURSOR - BOXING FOOTWORK THAT STEPS INSTEAD OF SLIDING (S89)
Owner: cursor. Assigned S89, 2026-09-26. Model: Composer, medium, `-p --force --trust`. Branch `cursor/u184-steps`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-U171` (`git fetch origin && git checkout -B cursor/u184-steps
origin/master`). Lane: engine and motion (agents own it).

## Why
Your U183 is merged (S89): no owned clip passed the knee gate, so all nine `boxing_*` footwork rows now bind to
`H2H_Idle` while `FightRealtime` owns the travel. Your own digest named the trap: every footwork beat now shows **the
guard sliding across the canvas**. The knee is fixed; the feet skate. A boxer never slides - he steps: lead foot
first when he goes forward, rear foot first when he goes back, a few centimetres of clearance, the other foot dragged
after (the "step-drag" / push-step).

## What would a human do?
An animator does not look for a clip that happens to fit - he keys a short step-drag cycle, or (in a game) writes
PROCEDURAL STEPPING: while the body travels, a planted foot stays planted until it is too far from where the hips want
it, then it lifts a few cm on an arc and lands ahead, the other foot follows. Overgrowth, Rain World and UE's stride
warping all do some version of this. Read how one of them decides WHEN a foot steps and WHERE it lands before you pick.

## The work
1. A pure, zero-preload module `Godot/scripts/FightStepPlanner.gd`: given the hip/root travel this frame, the two
   planted foot positions, the stance (which foot leads), per-foot "want" positions under the hips, returns per foot:
   planted / stepping, the target, and a lift height on the arc. Step when the foot is farther than a threshold from
   its want position; the leading foot (by travel direction) steps first; the other waits until the first lands
   (never both feet in the air - a boxer is never airborne on footwork). Lift peak <= 0.06 m (boxing), step time from
   the travel speed. Name every constant and where it came from (a measured source, or JUDGEMENT).
2. Hook it into the foot lock in `FightStagePlayer.gd` (4,419 lines - NEVER open it whole). The lock is at `:3040-3110`
   (header, constants, `set_foot_lock`), `:2505` (where the lock runs per frame), `:3213` (`foot_lock_stats`),
   `:3942` (`_undo_foot_lock`). Today a released foot SPRINGS back (glides); for a body whose current take is a
   `boxing_*` footwork beat (the U183 idle binding - `FightClipBinding.boxing_footwork_technique_ids()`), replace the
   glide with the planner's step. Everything else keeps the current release rule (`LOCK_RELEASE`).
3. Measure it with the existing instruments: skate speed (the realism test's R3, `fight_foot_lock_test.gd`,
   `tools/u183_foot_clearance.gd`) on a boxing spar where both men travel - BEFORE (master) and AFTER, same seed.
   Print achieved beside wanted.

## Owned files
`Godot/scripts/FightStepPlanner.gd` (new), `Godot/tests/fight_step_planner_test.gd` (new),
`Godot/scripts/FightStagePlayer.gd` (the lock section only), a tool under `Godot/tools/u184_*.gd` if you need one,
`research/U184_DIGEST.md`, previews under `previews/u184/`.

## Gate (a CEILING - over-deliver and say so)
- `fight_step_planner_test`: 0 failures, incl. never both feet airborne, lead foot first by travel direction, lift
  <= 0.06 m, and at least two real mutants on the module shown red (e.g. both feet may step; no lift).
- Skate on footwork beats (both men, one boxing spar, same seed): AFTER lower than BEFORE, printed side by side.
- Foot clearance <= 0.10 m and knee rise <= 0.12 m on those beats (U183's gate) - still true.
- `boxing_footwork_clearance_test`, `fight_foot_lock_test`, `fight_leg_ik_test`, `spar_watch_test`: 0 failures.
- A re-render of the gym spar (`tools/u183_render_gym_spar.gd`) - and LOOK at it.

## Tier
Script edited: parse gate (`python Godot/tools/check_scripts.py <touched .gd>`), then the focused test, then
`python Godot/tools/run_tests.py --only step_planner,foot_lock,leg_ik,boxing_footwork,spar_watch,fight_stage --jobs 1`.
No full suite (it runs nightly). Every windowed Godot run goes through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Research
All research is open: root `RESEARCH_INDEX.md` (U92, U93, C116, U183). Do NOT read HANDOFF.md, CURRENT_STATUS.md or
HANDOFF_ARCHIVE.md, and do not explore to "get oriented".

## Done
Commit (explicit paths), push the branch, write the digest (the before/after table, the renders), then
`python Tools/agent_comms.py send --from cursor --to claude --topic U184 --body "<skate before->after, gates>"`.
Do NOT edit HANDOFF.md.

## The trap
The foot lock only sees a plant when the TAKE's own toe path plants (FightFootContacts, 0.60 m/s under 10 cm). The idle
clip's feet never move, so they are "planted" the whole beat - and the engine's travel is applied to the ROOT, not the
take. Your step must be driven by the root's travel relative to the planted foot, not by the take's toe path, or it
will never fire. Check it fires by counting steps per metre travelled - a count that reads 0 is a planner that never ran.
