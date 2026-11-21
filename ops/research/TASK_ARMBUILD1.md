# TASK ARMBUILD1 - a boxer's arms and shoulders follow Strength in the 3D fight (owner Q-S294-290 "Follow Strength")

Model: claude-fable-5-2 (owner S512: Fable for animation work). Discipline: boxing (demo). Standing approval for animation
work (owner S510): build it, film it, send it.

## Why
Owner S534: "the fighter's arms are too skiny , do they change according to power attributes ?" - they do not: each fighter
has one fixed MetaHuman body (scripts/rules/Faces.gd), and FightCast.body_scales only scales the whole body by height
(0.88-1.12). His pick: arm thickness follows Strength.

## The rule
- Strength = Attrs.of(f)["strength"] (0-100; the fighter page's BODY > Strength).
- Thickness factor k = clamp(0.95 + (strength - 40) * 0.005, 0.92, 1.18): 40 -> 0.95, 60 -> 1.05, 80 -> 1.15.
- Applied to the upper arm, forearm and shoulder (clavicle) bones of BOTH arms, and a little to the upper chest/neck
  (k * 0.5 of the change), as bone scale on the two axes ACROSS the bone only - never along it: arm LENGTH, reach, the guard,
  punch targets and the arm finish must not change. Gloves stay their size (scale the glove/hand bone back to 1).
- The opponent's Strength drives the opponent's body the same way (the opponent dict carries stats/attrs; read what exists,
  fall back to 1.0 when none).

## Where
Fight player v2 only (scripts/fight3d/v2; METHOD S510 - no layer in the old scripts/fight3d). Player2.gd is at 499 lines:
put the rule in a NEW small module scripts/fight3d/v2/ArmBuild.gd (pure function k(strength) + apply(skel, k) that sets the
bone pose scale ONCE at setup, or a SkeletonModifier3D if the clips overwrite pose scale - check which by measuring) and
call it from Player2.setup in one line. Find the MetaHuman bone names in the skeleton (upperarm_l / lowerarm_l / clavicle_l
or the rig's own names) - print them first.

## Contract
OWNS: scripts/fight3d/v2/ArmBuild.gd, tests/arm_build_test.gd, scripts/fight3d/v2/Player2.gd (one call line only)
RED_TEST: tests/arm_build_test.gd (k at 40/60/80, bounds; a boxer at Strength 80 has wider upper arms than at 40 in a built
  scene while the shoulder-to-wrist LENGTH stays within 1 mm)
REGRESSION: tests/player2_test.gd tests/choreographer_test.gd
VISUAL: one still pair from the v2 film tool: the same boxer at Strength 40 and at 80, guard pose, game camera, opened by
  you; posted with `python ops/Tools/review_add.py --stage S534 --rating "your call" --title "Arms by Strength: 40 vs 80" <files>`

## Rules
- Godot only through `python ops/Tools/godot_slot.py run --who armbuild1 -- <command>`; windowed renders on the hidden desktop.
- Touch only the owned files. Other sessions have uncommitted edits (LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them.
- Commit to main, push, then map: `python ops/Tools/where_we_are.py done "Arms follow Strength (3D)"`; report in two lines, stop.

## What would a human do?
A character artist exposes a "build" morph per boxer driven by the stat sheet - here bone width is that morph.
