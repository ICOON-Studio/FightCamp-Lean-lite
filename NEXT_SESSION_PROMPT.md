# Next session: S307 (written S306, 2026-10-29, after side steps + planted feet + update 7)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. His verdict on update 7 and his comments on 8787/review (S306 slip/weave reel, S306 film, S305 film + reel v2):
   quote each, open the file it is on, act on it.
3. Then his scope call: is the gym floor the next thing to build (roadmap plan GYMFLOOR)?

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
