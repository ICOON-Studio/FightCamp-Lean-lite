# ROUND 2 (S343, Claude collected round 1 into main 6bc1a32 - read this first, it overrides the round 1 text below)

Round 1's MovePlayer.gd is on main with Claude's fixes (clips advance on their own length, the ghost reacts at contact,
the probe's numbers are measured on the bodies). Its probe now reads `MOVEPLAYER OK 5/5` on a real GPU, but the VISUAL
GATE FAILED on its own stills (docs/playtest/moveplayer/1-2-3_contact.png, pivot_out_mid.png):
1. BARE HANDS: neither body wears gloves (and the kit is not the fight's). The fight dresses a boxer in
   `scripts/fight3d/BoxerBuild.gd` (`build(stage, spec, index)`: body, kit, GLOVES, boots, the clip library, the modifier
   stack). Decided: rebuild the player's two bodies on a `FightStage` (`Stage.new()`, `setup(a, b)` - exactly as
   `scripts/fight3d/TapeFilm.gd` does) inside the SubViewport, with the ring hidden (RingSet / ropes / crowd nodes
   `visible = false`; the plain backdrop and floor disc stay), so every move looks exactly as it does in the fight.
   The ghost = boxer 1 with every surface (gloves included) overridden by the translucent material.
2. FEET OUT OF FRAME: `bodies_in_frame()` checked only Hips and Head. Check Head AND both foot bones (`LeftFoot`,
   `RightFoot`; MHRig names) of both bodies inside the viewport with a 4 % margin; frame the camera from those points.
   Boots on in every still.
3. THE PUNCHES NEVER ARRIVE: at long range's middle (1.2 m) the 1-2-3 stops in front of her own face. A punch move plays
   at the fight's contact gap (`FightStage` sets `gap_m` from the jab's reach, `_jab_gap()`; play the punch with
   `stage.play(0, clip)` and land it with `stage.land(...)` the way `BeatFire._punch` does - read it, do not edit it).
   New probe line per punch: `MOVEPLAYER <id> reach=<m>` = her glove to the ghost's head bone (body bone for a body shot)
   at the clip's contact time; PASS <= 0.12.
4. THE PIVOT STANDS INSIDE THE GHOST: a rope card (own_ropes / opp_ropes / corner) has no range; use 0.9 m, and never let
   the pelvis gap fall under 0.45 m outside the clinch. New probe field `min_gap=<m>` over the whole move.
5. Still missing from round 1: the rope line behind the trapped boxer on a rope card, and a "forced" move played the
   other way round (the ghost does it, she reacts).
PASS: `MOVEPLAYER OK 5/5` with the reach and min_gap checks added, `MOVESTILL bodies 2 head to feet` per still. Claude
renders the stills on Windows and opens them (gloves on, boots on, glove on the ghost's face at contact, no overlap).
OWNS stays the same (+ you may read TapeFilm.gd / BeatFire.gd / FightStage.gd, never edit them).
# TASK_MOVEPLAYER1 - the move map's player: pick a move, see it played, the opponent as a ghost (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo). Operator S342 on the trimmed
plan board: "you have room to put a player so that it displays the animation sequence with ghost opponent or something";
S338 "keep all agents working on animations".

## Why
The boxing move map (scripts/ui/StrikeBrowser.gd, `FightCamp.exe -- jump=strikemap`) lists 30 moves by name ("One-two-
hook-cross", "Pivot off the ropes"). A player reads a name, not a picture. A small 3D player in the map's empty corner
plays the picked move on her body, with the opponent shown as a see-through ghost at the card's range, so the coach SEES
what the arrow asks her to do. StrikeMap move ids -> clips are in `scripts/fight3d/MoveClips.gd` (MoveClips.clips(id)).

## The red probe (write it first; it must read red on main)
NEW `tools/moveplayer_probe.gd` (SceneTree, `-- show3d` for a windowed run): builds MovePlayer, and for each of the move
ids `1-1`, `1-2-3`, `step_back`, `tie_up`, `pivot_out` calls `show_move(id)`, lets it play once, and prints
`MOVEPLAYER <id> clips=<n> played=<n> gap=<m> ghost_alpha=<a> her_alpha=<a>` - clips = MoveClips.clips(id).size(), played
= the clips the AnimationPlayer actually started (in order), gap = the pelvis gap at the first frame, ghost_alpha = the
opponent's material alpha, her_alpha = hers. Then `MOVEPLAYER OK <n>/5` counting moves where played == clips (> 0),
|gap - the from-card's range middle| <= 0.12 m (StrikeMap.card(from)["range_m"]; "outside" = 1.6 m), ghost_alpha
<= 0.45 and her_alpha == 1.0. On main it cannot load MovePlayer -> red. PASS: `MOVEPLAYER OK 5/5`.

## Contract
OWNS: scripts/fight3d/MovePlayer.gd, tools/moveplayer_probe.gd, tools/moveplayer_still.gd, docs/playtest/moveplayer/
RED_TEST: tools/moveplayer_probe.gd (MOVEPLAYER OK 5/5)
REGRESSION: GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh (0 failures); tools/glove_height_check.gd (GLOVE HIGH 0)
VISUAL: docs/playtest/moveplayer/*.png - Claude opens them; the operator closes it

## Owned files (edit only these)
- NEW `scripts/fight3d/MovePlayer.gd` (a Control, < 300 lines): a SubViewportContainer (stretch) holding a SubViewport
  with its own World3D, a plain dark-blue backdrop (UI.BG darkened, no gym, no crowd), a soft key light, a floor disc.
  API: `show_move(move_id: String)`, `stop()`, signal `looped`. It places two boxers at the move's FROM card's range
  (StrikeMap.card(StrikeMap.move(id)["from"])), side-on, facing each other; her (red kit) plays MoveClips.clips(id) in
  order the way the fight plays clips (FightClips + JoinSmoother back to guard - read FightStage for how it starts a
  clip, do not edit it), holds guard 0.8 s, and loops. The opponent is the GHOST: the same MetaHuman body in guard,
  every surface material overridden with one unshaded translucent material (light blue, alpha 0.30, depth-draw opaque
  pre-pass off so it never hides her); when her move is a punch, the ghost plays a light hit reaction at the clip's
  contact time (assets/data/clip_contact.json, as BeatClips reads it). A move of kind "forced" (done TO her: StrikeMap
  move "kind") is played the other way round: the ghost does it, she reacts. A rope card (on the ropes / she has her on
  the ropes / corner trap) shows one rope line behind the trapped boxer (a thin cylinder is enough).
  Camera: side-on at chest height, both bodies head to feet in frame (print `MOVESTILL bodies 2 in frame` when both
  pelvis and head bones project inside the viewport, `MOVESTILL FAIL` otherwise), fixed during the move.
- NEW `tools/moveplayer_probe.gd` (above), NEW `tools/moveplayer_still.gd`: stills of `1-2-3` at each punch's contact and
  of `pivot_out` mid-move, 840x600 (the player's size on the map), saved under `docs/playtest/moveplayer/`.
DO NOT EDIT: anything under scripts/ui (Claude puts the player on the map and wires the clicks after merge), FightStage.gd,
JoinSmoother.gd, GloveClear.gd, PunchReach.gd, BeatClips.gd, RingPlace.gd, ExchangeBeats.gd, RingCamera.gd, CardStage.gd,
Clinch.gd (other seats hold them). Headless plain `--script` runs stay words-only (no 3D without `show3d`).

## Guard rails (must stay green)
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` - 0 failures.
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/glove_height_check.gd` -> `GLOVE HIGH 0:`.

## Evidence
Your PR runs `.github/workflows/fight-stills.yml` (stills + probe numbers as a PR comment). Add your moveplayer_probe and
moveplayer_still runs to the report; the how-to for a windowed run on the runner is `.github/CLOUD_AGENT.md` "Fight
animation tasks" (xvfb, `fastdraw`, `-- show3d`). GitHub Actions cannot open PRs on this repo right now: push the branch
`goose/moveplayer1` and say so; Claude opens the PR.

## VISUAL GATE (.claude/skills/visual-gate/SKILL.md, Lean version)
Claude renders tools/moveplayer_still.gd on a real GPU (Windows, hidden desktop) and opens every still before merging:
both bodies head to feet in frame (boots on - bare feet = FAIL), her gloves at contact on the ghost's target (no glove
through the ghost's head), the ghost clearly see-through and never in front of her face, the wrists straight. Green
probe numbers alone close nothing; the operator's OK on the map does.

## Prior research
searched: move preview player ghost (nothing on a move player). Related: STRIKEMAP_S335.md (the move map, its 30 moves),
S335 GrappleBrowser (scripts/grapple/GrappleBrowser.gd builds a SubViewport with two women and plays moves - read how it
sets up the viewport, camera and bodies; do not edit it), PADWORK1 round 2 (Goose: an EMPTY still from a camera that
missed the bodies - frame first, print MOVESTILL before saving).

## What would a human do?
A coach explaining a move on a whiteboard draws it, then shows it on the pads or on a partner standing still: he throws
it slowly at a partner in guard who barely moves, so the student sees where each punch goes and where the feet end.
Fight games' move lists do the same (a looping demo of the move against a static or faded dummy, side-on).

## Prefab check
No ready move-demo widget for Godot; the pieces are ours: MetaHuman bodies + gloves (FightStage/Boxer loaders), MoveClips,
clip_contact.json, the GrappleBrowser viewport pattern. A translucent unshaded StandardMaterial3D is the ghost.

## The one trap
The ghost must not take her clips or her material: build two separate body instances (the fight's loader twice), and
override ONLY the ghost's surfaces. And do not move her punch to the ghost - the ghost stands where the range puts it.

## Report
`RESULT: tools/moveplayer_probe.gd -> MOVEPLAYER OK 5/5`, each `MOVEPLAYER <id>` line, `MOVESTILL bodies 2 in frame` per
still, the still paths, the run_tests.sh summary and `GLOVE HIGH 0:`.
