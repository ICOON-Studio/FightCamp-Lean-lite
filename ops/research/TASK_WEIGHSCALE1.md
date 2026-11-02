# TASK WEIGHSCALE1 - the weigh-in shows the boxer standing on the scale (boxing)

Model: Cursor (cloud). Discipline: BOXING (demo). LAUNCH ONLY AFTER PREVIEWLOOK1 (#260) IS ON MASTER - it owns ProfileStage.gd.

## Why
Operator board answer Q-S249-6 (S255): "All three" (weigh-in on the scale, a visible cut + cutman, a mitt pop sound). Ludo r119
(research/ludo_rx/LUDO_R119_raw.txt:64): "Players must see the scale on Friday of Fight Week. Weight management is fundamental to
the sport; removing it reduces FightCamp to a generic RPG level-up system." Today the weigh-in set-piece (`Godot/scripts/WeighInPanel.gd`,
opened by `SetpieceRoot.gd:41` "weigh_in") shows only a brass number plate (`_build_scale`, :133) and `_build_figure` (:200) returns
nothing - no body, no scale.

## The route the game runs (traced)
SetpieceRoot "weigh_in" -> WeighInPanel.rebuild() (:76) -> _build_faceoff/_build_scale/_build_side/_build_figure/_build_step/
_build_cut_actions. The reading comes from GameState.get_weigh_in_card(athlete) (`limit`, `current_weight`, `resolved.weight`); the scale
is RESOLVED on the day advance, never in this panel - keep that rule (header of WeighInPanel.gd).

## Files you own
1. EDIT `Godot/scripts/WeighInPanel.gd` - `_build_figure()` only (+ a small helper if needed): a TextureRect on the hero card showing
   `ProfileStage.build(athlete, Vector2i(...))` (the SubViewport the Techniques preview uses) with the boxer standing ON
   `res://assets/models/club/locker/locker_scale.glb`: add the scale as a child of the viewport's stage at the boxer's floor point and
   lift the boxer by the scale platform's top height (read the scale mesh AABB, never a hard-coded number). The boxer stands in the
   game's rest guard/idle the preview already plays (no new animation - operator S246: MetaHuman motion = ActionForge clips one-to-one).
   Full body head to feet in frame, scale visible under both feet, the existing brass reading plate stays where it is.
   Respects GameSwitches: a new behaviour key `weigh_scale_3d` added to `GameSwitches.GAME_ON` (operator S221: new features ship ON);
   plain `--script` tests are the OFF arm.
2. EDIT `Godot/scripts/GameSwitches.gd` - the one key in GAME_ON, nothing else.
3. NEW `Godot/tests/weigh_scale_test.gd` (extends SceneTree; OK/FAIL lines; ends `print("WEIGH_SCALE failures=%d" % failures)`):
   with a booked bout and the switch on, the panel holds a SubViewport whose stage has the scale node; the boxer's lowest foot bone y is
   within 2 cm of the scale's top surface; both foot bones lie inside the scale's top AABB in x/z; with the switch off, no SubViewport.
   Red on master first (no viewport today).

## Acceptance
- `tests/weigh_scale_test.gd`, `tests/weigh_in_cut_test.gd`, `tests/weigh_in_and_gym_mates_test.gd` pass. PR body: their RESULT lines.
- Claude then takes the still (game camera of the set-piece, head to feet, scale visible) - you cannot see images; report the numbers.

## Prior research
J7_THE_SCALE_AND_THE_BELT.md, J53 (weigh-in terms), TASK_U169_WEIGH_IN_AND_GYM_MATES.md; WeighInPanel R27/S81 history in its header.

## What would a human do?
Every fight-week broadcast shows the same shot: the fighter steps on the scale in trunks, the official reads it out, the number lands.

## Prefab check
`locker_scale.glb` is already in the repo (club locker room). The boxer = the existing MetaHuman preview stage. Nothing to download.

## The one trap
Do not resolve the weigh-in here and do not touch ProfileStage.gd (PREVIEWLOOK1 owns it) - build the scale into the viewport from outside.

## Contract
OWNS: Godot/scripts/WeighInPanel.gd, Godot/scripts/GameSwitches.gd, Godot/tests/weigh_scale_test.gd
RED_TEST: Godot/tests/weigh_scale_test.gd -> WEIGH_SCALE failures=0
REGRESSION: weigh_scale_test, weigh_in_cut_test, weigh_in_and_gym_mates_test
VISUAL: yes
