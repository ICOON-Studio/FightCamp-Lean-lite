# TASK U183 - CURSOR - BOXING FOOTWORK THAT NEVER LIFTS A KNEE (S88)
Owner: cursor. Assigned S88, 2026-09-26. Model: Composer, medium, `-p --force --trust`. Branch `cursor/u183-boxing-steps`.
Worktree: `C:/Users/user/AppData/Local/Temp/FightCamp-U171` (`git fetch origin && git checkout -B cursor/u183-boxing-steps
origin/master`).

## Why
Your U182 digest found it: in `docs/previews/s87/arena_spar.png` (~8 s) a boxer in a BOXING spar raises a knee. It is not a
knee strike - boxing footwork techniques bind to RamsterZ dodge clips (`FightClipBinding.gd:2450-2459`:
`boxing_angle_step`, `boxing_pivot_footwork`, `boxing_circle_lead/rear` -> `H2H_Dodge_Left/Right`, `boxing_feint` ->
`H2H_Dodge_Forward`, `boxing_switch_stance` -> `H2H_Dodge_Back`), and those dodges lift a leg. A viewer reads a raised knee
in a boxing ring as a foul. The operator watches these spars now (S87/S88), so it shows.

## What would a human do?
An animator on a boxing game checks the reference first: a boxer's step is a glide - the lead foot slides, the rear foot
follows, both stay within a few centimetres of the canvas; pivots turn on the ball of the lead foot; circling is a
push-step, never a lifted knee. He measures foot clearance on the candidate clips against that, rejects any clip where
a knee comes up, and only then binds - he does not bind by clip NAME ("Dodge" sounds like footwork).

## The work
1. An instrument, `Godot/tools/u183_foot_clearance.gd` (headless): for each clip in the boxing footwork rows above, and
   for every other in-place step/move clip on disk that could replace them (`Godot/assets/anim/audition/ramsterz_h2h/`
   H2H_Run*, H2H_Walk*, H2H_Idle*, and anything under `Godot/assets/anim/` whose name says step/shuffle/walk/strafe - list
   what you found), print per clip: max foot height above its own lowest foot height (m), max knee height rise (m) and
   the frame. Rigs are NOT in metres (memory: Tripo/RamsterZ export scale) - measure on the retargeted skeleton the
   game draws (`FightClipRetarget.gd` / the path `FightWorldLive` uses), or divide by the rig's own hip height and say
   which you did.
2. Rebind the boxing footwork rows to clips that keep BOTH feet low (gate: foot clearance <= 0.10 m and knee rise
   <= 0.12 m on the game skeleton - a glide). If NO clip on disk passes for a row, bind it to the idle/guard clip with the
   root travel the engine already applies (a sliding guard beats a lifted knee), and say which rows got that.
3. Test `Godot/tests/boxing_footwork_clearance_test.gd`: every `boxing_*` footwork row in the binding table resolves to
   a clip that passes the gate on the game skeleton; prove it with a mutant (rebind one row to `H2H_Dodge_Left` - the
   test must go red) and say so.
4. Re-render the U182 gym spar (`tools/u182_render_gym_spar.gd`) PNG and look at it; no AVI in the commit.

## Owned files
`Godot/scripts/FightClipBinding.gd` (2,904 lines - never open whole; the rows are at `:2450-2459`, read `sed -n '2400,2470p'`),
`Godot/tools/u183_foot_clearance.gd`, `Godot/tests/boxing_footwork_clearance_test.gd`, `research/U183_DIGEST.md`,
`previews/u183/*.png`.

## Tier
A script edited: parse gate (`python Godot/tools/check_scripts.py <files>`), your new test, then
`python Godot/tools/run_tests.py --jobs 1 --only clip_binding,spar_watch,fight_world_live,footwork`. Name the result in
the digest. No full suite (it runs nightly). Every windowed Godot run goes through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Research
All research is open: root `RESEARCH_INDEX.md`. Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest (the clearance table, what each row is bound to now, the
mutant), then `python Tools/agent_comms.py send --from cursor --to claude --topic U183 --body "<rows rebound, gate, mutant>"`.

## The trap
A clip that passes clearance but has no forward/lateral content makes the boxer slide like a chess piece. Note root
motion per clip too; prefer a low clip WITH travel, and say where you had to accept a slide.
