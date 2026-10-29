# Next session: S307 (written S306, 2026-10-29, after side steps + planted feet + update 7)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board answers: Q-S294-9 (update 7 verdict), Q-S294-10 (gym floor next?), Q-S294-12 (corner minute v2 - his idea:
   "make the whole corner come in through the ropes holding the stool and having real time to act ... as close to real
   movie clip"). Quote each; act on his review comments (S306 reels/film, the corner clip sheet).
3. If Q-S294-12 is yes: build docs/FIGHT_NIGHT_SCRIPT.md in its order (roadmap now.next_action has the steps):
   corner bodies (old repo mh_staff_coach / cutman_1 / trainer + textures + json), props from basic shapes on hand
   attachments, free walking (a scene mode in which _compose stops the face-each-other rule), the corner scene director
   (60 s clock, shot list as data, letterbox, depth of field, the corner card on the 0:08 face-to-face shot, default call
   at 0:50), then the intro. FightStage is at 495 lines: give the actors/scene their own scripts.
   Clips are ready: af_walk, af_walk_carry, af_sit_enter/idle/exit, af_sit_talk, af_crouch_idle, af_talk, af_interact,
   af_pickup, af_drink, af_nod_yes, af_idle_foldarms, af_push, af_idle (tools/corner_still.gd shows them).
   More clips: add the role to the old repo's Godot/tools/af_lean_bake.gd ROLES (AFMotion.CLIPS names) and rerun it.

## Where it stands (Lean bd20641)
- scripts/fight3d/SideStep.gd: a Pro dodge is cut where both feet first stand planted after its step (measured per
  boxer at setup), her place takes the step (0.18-0.19 m), JoinSmoother.carry keeps the hips where seen; a weave back in
  guard takes its side's dodge step. FightStage FACE_S eases the turn to face.
- scripts/fight3d/FootPlant.gd: last modifier; a foot holds its spot and takes a 0.15 s step (5 cm arc) when the
  animation carries it > 0.10 m away; two-bone leg IK; never below her standing ankle height; knockout/win/countdown/fall
  play free. `nofeet` on the command line = the control arm.
- tools/sidestep_probe.gd: live old/new per dodge/weave + footwork controls (hips sideways, planted-foot slide, `trace`
  = per-frame target vs shown foot); `feet` = the clip feet table. Run with --fixed-fps 60.
- tools/fight3d_gallery.gd `only=slip,weave` films a subset of the move reel.
- FightStage.gd is at 495 lines: the next addition there moves something out first (500-line rule).

## Traps
- His FightCamp.exe is usually open: the .exe copy in tools/export.sh fails, the .pck lands (he restarts the game).
- Lean has no check_scripts.py: parse-check with `<godot> --headless --path . --check-only --script res://<file>`.
- PowerShell swallows Godot's output in loops; run Godot tests from the Bash tool.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.
