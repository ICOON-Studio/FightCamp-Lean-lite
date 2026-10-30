# Next session: S308 (written S307, 2026-10-30, after the intro + corner minute, update 8)

## Start
1. `cd /e/FightCamp/Game && git pull && python Tools/agent_comms.py start`, then work in `E:\FightCamp\Lean` (`git pull`).
2. Board: Q-S294-13 (his verdict on update 8: intro + corner minute) and his review comments on the S307 film. Quote each.
3. Then by his word. Standing answers: Q-S294-10 "Keep polishing the fight first" (gym floor waits).
   Corner polish candidates if he asks for more: a tired boxer breathing hard on the stool (no clip yet - ActionForge
   has none; a chest/shoulder procedural lift on CornerIK), the stool carried in/out (af_walk_carry exists), a towel,
   the second's hand on the ice pack, faces/lip sync (none in our bodies).

## Where it stands (Lean 374d986, 14ee92d)
- scripts/fight3d/CornerMinute.gd: the 58 s minute as data (SHOTS, CUES -> cue_<name>); CornerShots.gd frames each shot
  from where the bodies are; CornerOverlay.gd = letterbox, clock, card + three calls, captions, skip.
- CornerCrew.gd: staff bodies (coach, second, cutman in pro, blue coach + second), stools/buckets/bottle/ice, walk at
  the clip's ground speed (0.92 m/s x scale), turn, sit/stand with the body moved against the feet's travel (the AF sit is
  in place), props follow `skeleton_updated` (the shown pose).
- CornerIK.gd: arm two-bone IK (pole for a straight arm) + head turn; on every boxer and staff body.
- FightIntro.gd: the intro before round 1. FightCast.gd: bodies, crew, intro(view), corner(view). BoxerBuild.gd: a boxer.
- tools/corner_film.gd: stills + checks (seat, bottle, feet via pose_tap, ropes, flow); `pro` = with the cutman;
  `film` under --write-movie = a whole fight. tools/corner_probe.gd: clip numbers on any body.

## Traps
- Bone poses read from _process are BEFORE the modifiers (IK, FootPlant): measure via tools/pose_tap.gd, follow via
  skeleton_updated.
- Skinned meshes keep standing bounds: MHRig sets extra_cull_margin 0.6 (seated close-ups culled the hair).
- His FightCamp.exe is usually open: the .exe copy in tools/export.sh fails, the .pck lands.
- FightView.gd 487 lines, FightStage.gd 433: new fight-night code goes in FightCast / Corner* files.

## Wrap-up duties
CLAUDE.md "Wrap-up": tests + export, ops board roadmap, rewrite this file, memorize the session, ask before handing over.
