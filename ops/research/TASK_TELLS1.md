# TASK_TELLS1 - her tells on her body: the right hand drops after the jab, the lunge behind the jab, the guard sinks when she tires (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo). Operator S343 on the tape
room (Q-S294-68): "the player watches the films and it unflods like in grappleflows , player has appropriate counters for
each clip to make his plan . put grappleflows in the game as core mechanic", then "wanna try also your idea ?" (SPOT: press
when she shows her habit, name it). S338: "keep all agents working on animations".

## Why
The tape room (scripts/ui/TapeRoom.gd, `FightCamp.exe -- jump=taperoom`) plays an opponent's past bout on our ring
(scripts/fight3d/TapeFilm.gd plays TapeClips' beats through BeatFire) and the player must SPOT her tell. Claude's risk test
on the first stills (docs/playtest/S343/taperoom/*_tell.png): the tells do NOT show on her body - after her jab her right
glove stays at her chin (drops_right), the "tired" take keeps both gloves at her chin (tiring), and the lunge reads as a
plain jab (lunges). A tell the player cannot see is not fair to SPOT. TapeClips now marks her tell beats with
`b["tell"]`: "hand_drop" (her jab, film drops_right), "lunge" (her jab, film lunges), "tired_guard" (her tired beat,
film tiring), "hands_low" (a "say" beat, film admires). Make the ring pose them.

## The red probe (write it first; it must read red on main)
NEW `tools/tell_probe.gd` (SceneTree, `-- show3d` for a windowed run): builds a FightStage the way TapeFilm does (two
MetaHuman bodies, red "a" and blue "b"), and for each film shape `drops_right`, `lunges`, `tiring`, `admires` fires
TapeClips.clips(...)'s beats for that shape in real time through BeatFire (copy TapeFilm.tick - do not edit TapeFilm), and
MEASURES ON HER SKELETON (bone global positions, never a value your module reports about itself - S340: probes that read
their own constants passed while the picture failed):
- hand_drop: her rear glove (hand bone) height below her head bone, at guard before the jab (g0) and the lowest within
  0.6 s after the jab's contact (g1): `TELL hand_drop drop=<g1-g0 m> back=<m above g1 at +1.2 s>`. PASS drop >= 0.18 and
  back >= 0.15 (her guard comes back up).
- lunge: her pelvis travel toward the other woman during the jab and her chest's forward lean from vertical at contact:
  `TELL lunge travel=<m> lean=<deg>`. PASS travel >= 0.22 and lean >= 12, and she is back within 0.15 m of her start
  range by +1.5 s (the RangeBreath gap, not a walk across the ring).
- tired_guard: both gloves' height below her head bone, held: `TELL tired_guard low=<m> held=<s>`. PASS both gloves
  >= 0.15 m lower than her guard for >= 1.0 s, then back up.
- hands_low: as tired_guard, held >= 0.8 s (she stands and admires after the combination).
Then `TELL OK <n>/4`. On main TellPose does not exist -> nothing moves -> red.

## Contract
OWNS: scripts/fight3d/TellPose.gd, tools/tell_probe.gd, tools/tell_still.gd, docs/playtest/tells/
RED_TEST: tools/tell_probe.gd (TELL OK 4/4)
REGRESSION: GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh (0 failures); tools/glove_height_check.gd (GLOVE HIGH 0)
VISUAL: docs/playtest/tells/*.png - Claude opens them and renders tools/taperoom_still.gd; the operator closes it

## Owned files (edit only these, plus the ONE line in BeatFire below)
- NEW `scripts/fight3d/TellPose.gd` (< 250 lines): `static func apply(stage: Node3D, who: int, kind: String, at_s: float)`
  - poses boxer `who` for her tell on top of the clip she is playing (a SkeletonModifier3D or a bone-pose overlay added
  once per boxer the way GuardTuck/TiredSag/HitSnap sit on the skeleton - read scripts/fight3d/GuardTuck.gd and
  TiredSag.gd first; ease in/out, never a snap): hand_drop - her REAR hand (BeatClips/FightStage.hand_of for her stance)
  sinks from the chin to the chest, 0.15 s after the jab's contact (at_s), held 0.5 s, back over 0.35 s; lunge - pelvis
  and chest carried 0.25-0.3 m forward through the jab (the front knee bends, the rear heel lifts), back over 0.5 s;
  tired_guard / hands_low - both gloves down to the chest, the shoulders round, held 1.2 s (hands_low 0.9 s), back up.
- The ONE line in `scripts/fight3d/BeatFire.gd` `fire()`: before the `match move:` -
  `if b.has("tell"): TellPose.apply(v.stage, who, str(b["tell"]), <the punch's contact time, or 0.0 for a non-punch>)`
  (+ the preload). Nothing else in BeatFire. The tell keys come only from TapeClips today; the real fight's HabitBeats
  can mark the same keys later (not in this task).
- NEW `tools/tell_still.gd`: one 1920x1080 still per tell at its lowest/most-forward moment on the tape's own camera
  (copy TapeFilm's hard camera: side-on, the other woman's side), both bodies head to feet, saved under
  `docs/playtest/tells/`; print `TELLSTILL bodies 2 in frame` per still (head and pelvis bones of both inside the
  viewport) or `TELLSTILL FAIL`.
DO NOT EDIT: TapeFilm.gd, TapeRoom.gd, TapeClips.gd (Claude), FightStage.gd, JoinSmoother.gd, GloveClear.gd, RingCamera.gd,
Referee.gd, CardStage.gd (Cursor's FIGHTCARD1 holds them), Clinch.gd (CLINCH2), anything under scripts/ui. Headless plain
`--script` runs stay words-only (no 3D without `show3d`).

## Guard rails (must stay green)
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` - 0 failures (tape_clips_test, tape_room_test included).
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/glove_height_check.gd` -> `GLOVE HIGH 0:`.

## Evidence
Your PR runs `.github/workflows/fight-stills.yml` (stills + probe numbers as a PR comment). Add tell_probe and tell_still
to the report; the how-to for a windowed run on the runner is `.github/CLOUD_AGENT.md` "Fight animation tasks" (xvfb,
`fastdraw`, `-- show3d`). GitHub Actions cannot open PRs here: push the branch `goose/tells1` and say so; Claude opens the PR.
Never commit import-generated `.uid` files.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, Lean version)
Claude renders tools/taperoom_still.gd (`opp=0,2,megan`: Maria fades, Erin drops her right, Megan lunges) on a real GPU
(Windows, hidden desktop) and opens every `_tell.png` before merging: at the tell's moment the tell is plain to a viewer
who knows the list - the rear glove at her chest, the guard at her chest, the body over the front knee; both bodies head to
feet, boots on, wrists straight, no glove through a head. It goes red on the shipped tree first (the S343 stills are the
red). Green probe numbers alone close nothing; the operator's OK in the tape room does.

## Prior research
searched: tell habit visible animation hand drop lunge -> J50_HOW_A_DEFENDER_DEFENDS.md (reading a tell: experts pick a
pattern after ~5 repetitions, Milazzo 2016 - the tape shows each tell 2-3 times), Game research TAPEROOM_S342.md (the
mechanic and its risk: "A tell is only fair if it READS on screen"). Existing body layers to copy the pattern from:
GuardTuck.gd (guard height), TiredSag.gd (tired posture), HitSnap.gd (a short overlay on a hit).

## What would a human do?
A coach filming an opponent marks the frame where she drops her right hand after the jab, lunges with her feet square, or
lets her gloves sink late in a round - the tell is a body position held long enough to see on tape (a quarter to half a
second). An animator exaggerates it a touch for readability (the 12-principles "staging": one clear silhouette change),
never a whole new clip.

## Prefab check
No ready "tell" overlay exists for Godot; the pieces are ours (MetaHuman skeletons, the GuardTuck/TiredSag overlay
pattern, BeatFire's beat switch). Mixamo/Rokoko have no "drop the rear hand after a jab" take; a bone overlay on the clip
is lighter than a new capture.

## The one trap
Pose HER (boxer 1, blue, "b") only, and only on a beat that carries `tell` - every other jab in every fight stays
exactly as it is (run_tests and GLOVE HIGH stay green). The rear hand is her right for an orthodox stance and her LEFT
for a southpaw (FightStage.hand_of).

## Report
`RESULT: tools/tell_probe.gd -> TELL OK 4/4`, each `TELL <kind>` line, `TELLSTILL bodies 2 in frame` per still, the still
paths, the run_tests.sh summary and `GLOVE HIGH 0:`.
