# TASK U210 - foot locking, the UNTRIED path (planner-only, no new IK lock) - Cursor

Model: your default. Owner: Cursor (free seat S141 - U208 delivered, U209 waits on the operator's pick).
Worktree: new, E:/FightCamp/wt/U210, branch cursor/u210-footlock-planner (from master).

## Why (operator + measured, no new guessing)
Operator 2026-10-02: "i see a lot of sliding in the video why the 3d fight is getting worse ?" S139 measured it
(not worse than before, but large and old - see S139_DIGEST.md s6): `tools/s139_slide_probe.gd`, planted-foot
horizontal travel, BEFORE 5773 cm/fighter-min p95 2.70 m/s, AFTER 5351 cm p95 2.64 m/s.

**Four prior attempts (U185, U186, U187, U188 - read all four digests before writing a line) all took the same
approach - lock a planted foot's world position, two-bone leg IK to hold it, release on lift - and all four
measured WORSE than planner-off baseline.** U188's own stop line names the pattern: the leg IK cannot reach the
frozen world lock under deep knee poses (residual spikes at high lock_err, 0.35-0.47 m), occasional 31 m/s
reset frames when a take/lock resets, and kneel violations (922 frames below the floor) persisted through four
rounds of tuning the SAME mechanism. **Do not submit a fifth tuning pass of IK-lock.** U188's stop line names
the untried alternative: *"a planner-only path that matches baseline hip_delta=0 while both feet stay planted,
without relabelling swing feet."* That is this task - fix where the step planner DECIDES a foot is swinging
when it should still be planted, not where the room enforces a position after the decision is already wrong.

## Build
1. Read `tools/s139_slide_probe.gd` (the gate) and `tools/u188_slide_spike.gd` (how a slide event is classified)
   first - know what you are measuring before you touch the planner.
2. Find the step planner (`FightStepPlanner.gd` or equivalent - `grep -rn "step_planner\|FightStepPlanner"
   Godot/scripts/*.gd | head`) and trace WHY a foot that should read `state.planted` gets relabelled swinging
   (or moves while still marked planted) during ordinary footwork/guard frames. U188 already instrumented this:
   reuse `u188_slide_spike.gd`'s spike classification rather than re-deriving it.
3. Fix the DECISION (when a foot counts as planted vs swinging, and what moves the root while a foot IS
   planted), not the correction (IK re-pinning after the fact). No new foot-lock/IK mechanism.
4. If after real investigation the planner-only path turns out to be a dead end too, SAY SO with evidence (the
   same way U185-U188 did) rather than forcing a result - a fifth honest "still worse, here is exactly why" is
   worth more than a sixth IK-tuning pass dressed up as something new.

## Acceptance (same gate every prior attempt used - do not loosen it)
`tools/s139_slide_probe.gd`, same 3 seeds x 30s as_game, BEFORE (current master, no change) vs AFTER (your
change): p95 planted speed down by at least half from today's baseline (2.64 m/s -> <= 1.32 m/s). Report the
baseline freshly on today's master - do not reuse U185-U188's numbers, the engine has moved since.
`tools/u188_kneel_probe.gd` violations_below_floor must not regress from whatever it reads on today's master.

## Owned files
Whatever file actually holds the step-planner's plant/swing decision (name it exactly, with line numbers, in
your digest - do not guess the filename here). NOT `FightStagePlayer.gd`'s IK (U185-U188's owned file - leave
their lock/IK code alone unless you are removing it because the planner fix makes it unnecessary, and say so).

## Prior research
Read, in full, before writing code: `research/U185_DIGEST.md`, `U186_DIGEST.md`, `U187_DIGEST.md`,
`U188_DIGEST.md`, `research/S139_DIGEST.md` s6. `python Tools/prior_research.py foot lock plant slide`.

## What would a human do?
A biomechanics/animation engineer debugging a slide bug would ask "why does the game MOVE the planted foot" not
"how do I snap it back after it moved" - four attempts at the second question all made it worse.

## Prefab check
None needed - this is a decision-logic fix in our own step planner, not a new asset or mechanism.

## Test (tier: engine-only, one file likely edited)
Parse gate first. Focused: the two probes above. Affected:
`python Godot/tools/run_tests.py --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage,fight_discipline_population --jobs 2`
(same subset U188 tried to run - if it still hits the missing-.godot/imported/*.mp3 engine-load error U188 saw,
that is a worktree-setup problem, not your bug - run `godot --headless --import` first, as this session's S141
digest did for a similar asset-cache miss).

## The one trap
The slide probe and the kneel probe can trade against each other (U188: fixing one regressed the other slightly
less than before, but both stayed red). Report both numbers together, every time, never just the one that improved.
