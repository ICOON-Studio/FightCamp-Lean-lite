---
name: feedback-debug-at-the-point-of-write
description: "When a mechanism reports as inert, print the quantity where it is WRITTEN, not where it is reported — that separates 'it did nothing' from 'the reader never saw it'."
metadata:
  type: feedback
---

When a change measures as having **no effect at all**, do not accept it as a
negative result until you have printed the quantity **at the point where it is
written**, not where it is reported.

2026-09-21, S38: `anchor=1` in `probe_cmu_grip.gd` had reported "+8.8% -> +8.8%,
moves the drift not at all" since S35, and it was believed for a whole stage.
A debug compose *inside the bake* showed the hand moving from 0.213 to 0.130 of
its target while the summary table reported no change whatsoever. The bake was
working the entire time. `FightAnchorBake.bake()` writes keys at `i/fps`; the
probe sampled the animation at `anim.length*s/(samples-1)`, and `anim.length`
was 3.6417 s where the grid wanted 3.6583 — so every written key landed between
two measurement samples. Corrected, the mechanism was not neutral, it was
**harmful** (+41.9%).

**Why:** "the mechanism does nothing" is the most believable negative result
there is, so it gets written into a digest and inherited unexamined. Two
independent bugs in one session both presented in exactly that shape. A
write/read grid mismatch is invisible from the reporting end — the numbers look
clean, reproducible and honest.

**How to apply:** before recording any inert result, add one print at the write
site showing the value before and after, and compare it against the reported
column. If they disagree, the instrument is broken, not the mechanism. Cheap
tell: percentiles that are **byte-identical** across a change usually mean the
reader never saw the write, not that the write was neutral.

**THE SIBLING SHAPE: A STALE READ MAKES A CORRECT WRITE LOOK WRONG.** Same day,
third instance. Dola's Blender script set `location.z` and `location.x`
correctly and then measured with `get_bone_world_pos`, which read a stale
`matrix_world` — so it saw both armatures where they were BUILT, reported feet
at −0.770 m, and looked exactly like an inverted sign. `bpy.context.view_layer
.update()` — one line — and the feet land at 0.000 m. In Blender, flush the
depsgraph between moving an object and measuring it.

So the question to ask of any inert or nonsensical result is not "what did the
code do wrong" but **"is the thing reporting this actually looking at the thing
I changed?"** Three bugs in one session, three different systems, one shape.

Related: [[feedback-godot-verification-gate]],
[[feedback-open-the-output-before-the-gate]],
[[feedback-give-every-fix-a-control-arm]],
[[feedback-a-gate-that-reads-its-subject-cannot-fail]].
