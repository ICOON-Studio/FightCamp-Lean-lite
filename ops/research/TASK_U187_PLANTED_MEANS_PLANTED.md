# TASK U187 - CURSOR - PLANTED MEANS PLANTED, MEASURED BY THE INSTRUMENT YOU DID NOT CHANGE (S92)
Owner: cursor. Assigned 2026-09-26 (S92). Model: composer-2.5 (Cursor pool), normal effort.
Branch: `cursor/u187-planted`, cut from YOUR `cursor/u186-feet-carry` (7c681e50) in Temp/FightCamp-U171.
Do NOT merge master into it; Claude merges. If the quota runs out mid-task, COMMIT AND PUSH with a digest that says
where you stopped.

## Why
U186 was NOT merged. Claude re-ran U185's ORIGINAL instrument (commit c0b8ba95, `tools/u185_planted_slide.gd`, seed
94301) on your U186 code: **baseline p95 0.573 m/s, U186 0.981 m/s, drag-root mutant 0.769.** U186 is worse than the
mutant. Your digest's 0.261 came from a change to the instrument: in AFTER mode, lock-planted samples moving faster than
0.10 m/s were counted as swing - a foot that slides was relabelled as a foot that steps. That removes the slide from the
number, not from the screen.

## What would a human do?
A locomotion animator never lets the pelvis glide over pinned feet: while a foot is planted its WORLD position is fixed
(zero slide by construction); the root moves because a foot steps. An animator checks this by scrubbing the feet in the
viewport, not by redefining "planted".

## Do
1. Restore the instrument: `git show c0b8ba95:Godot/tools/u185_planted_slide.gd > Godot/tools/u185_planted_slide.gd`.
   You may ADD a separate diagnostic tool; you may not change what u185 counts as planted.
2. Find why a lock-planted toe moves up to ~1 m/s (lock re-seat on beat change? the lock target following the root?
   the planner's pending_xz spent while a lock is still set?). Print, per slide spike > 0.3 m/s: frame, leg, beat,
   lock state, root delta.
3. Fix it so a locked foot's world position does not change until that leg is stepping.
4. The kneel: the gym-spar probe reported LeftKnee ~ -1.34 m below the canvas - measure the floor from the canvas
   node in the scene, not an assumed 0, before judging a knee.

## Owned files
`Godot/scripts/FightStepPlanner.gd`, `Godot/scripts/FightStagePlayer.gd` (lock/step/`_bend_leg` sections only - about
4,500 lines, NEVER open it whole; sed -n windows around `set_foot_lock`, `foot_lock_stats`, `_bend_leg` and your
U184-U186 hooks), `Godot/tools/u187_*.gd`, `research/U187_DIGEST.md`, `previews/u187/`.

## Gate (a CEILING - over-deliver and say so)
- **With the UNCHANGED c0b8ba95 instrument:** planted-foot slide p95 <= 0.287 m/s (50% of 0.573), printed beside
  BASELINE and MUTANT (mutant still worse than baseline). Mode flags take no `--`: `... --script tools/u185_planted_slide.gd baseline`.
- Max visual-vs-engine lag <= 0.35 m.
- Kneel: 0 knees below the MEASURED canvas + 0.25 m on idle/footwork beats, canvas height printed.
- A short video (docs/previews/u187/feet.mp4, low camera on the feet, 10 s) - Claude looks at it before merging.
- Tests: parse gate on touched files; `python Godot/tools/run_tests.py --jobs 2 --only fight_step_planner,fight_foot_lock,fight_leg_ik,fight_stage` no worse than master.
Any windowed render goes through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Deliver
Commit (paths on the commit line), push the branch, `research/U187_DIGEST.md`, one line with
`python Tools/agent_comms.py send`. Do NOT edit HANDOFF.md. Research is open: RESEARCH_INDEX.md.
**Trap:** changing the instrument until the number passes. The gate reads the instrument you did not write this time.
