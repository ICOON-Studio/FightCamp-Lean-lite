---
name: feedback-one-clock-move-script
description: "Operator 2026-09-14 - per-part fixes destroyed cohesion; a pair AUTHORED on one clock got \"Right is clearly better\" ALONE, but inside the live fight \"About the same\" - judge an exchange inside its combination"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 6a875469-5a9c-4035-bff0-32947f507903
  modified: 2026-09-14T14:06:10.234Z
---

After seven per-part fixes (per-bone joins, foot lock, contact push, strike aim, strike warp, retime, head shove) each
measured better alone, the operator saw no gain from four in a row, then said: "it looks like each part of body have
each own sped", "There is no cohesion between animations and reactions", "Have you written a proper script o. How to
execute the moves?", and of the current build v every per-part system off: "They both so bad"; "Their distance is off
their action looks like robot made in 90s".

**Why:** a move was whatever a bought clip did, stitched to other packs' clips and corrected part by part on separate
timers; the thrower's clip and the receiver's reaction were never made together. Metrics per part cannot see cohesion.

**What worked (same day, afternoon):** BOX_JAB_HEAD_LAND authored as ONE Blender scene for both fighters on one 60 fps
clock (`Tools/blender_moves/author_pair.py`), our Godot retarget in and out through a pose bridge, distance and travel
set from TWO-MAN footage (hip gap 2.23 -> 2.06 T, jab hips p50 0.04 T), the bought jab's step scaled down with IK-held
feet, the glove's IK target keyed hand -> face -> stance guard, the reaction at jab strength from the contact frame.
Shown beside the live room at the visible contact, the operator answered "Right is clearly better" and chose
"Put this jab in the live fight". Before that, every per-part fix got "About the same".

**How to apply:** before adding any animation correction, write/consult the MOVE SCRIPT
(`research/MOVE_SCRIPT_BOXING.md`): per exchange one timeline for BOTH fighters, numbers from footage
([[feedback-learn-moves-from-video-not-studies]]), authored as a pair and measured with `Tools/measure_pair.py`
against the footage p10-p90. Show the operator before/after cut at the visible contact and ask
([[project-watchability-verdict-2026-09-13]]). Blender traps: [[reference_pc_animation_tools]].

**THEN, SAME EVENING, IN THE LIVE FIGHT:** the pair went into the room (both directions, one schedule entry, one clock,
room reproduces the authored glove within 5 mm; pair jabs reach the head 9/9 v clips 45/166). Shown before/after at 0:14
and 1:31 of seed 810039 the operator answered "About the same", chose "Smooth the jab in combos", and added "the body of
right is folding unnaturally". Only 18 of 44 landed head jabs played it; the 0:14 jab followed a hook by 0.13 s, entered
0.60 s into its timeline and was cut by the next punch right after contact. The fold was authored: the bought jab's two
~10 cm hip dips survived a step scaled x0.2, with a 14 deg forward tip (0.17 T of sink - above batch 2's drills
(p90 0.08 T) but INSIDE the pooled bouts' 0.00/0.08/0.29 T, n=104: judge dip count, pitch and timing, not depth alone). So an exchange that wins in isolation must
also be judged inside the combination the engine puts it in, and every component of a scaled step (vertical too) must
be scaled or measured ([[feedback-open-the-output-before-the-gate]]).
