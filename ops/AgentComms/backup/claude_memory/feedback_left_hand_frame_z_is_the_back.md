---
name: feedback_left_hand_frame_z_is_the_back
description: S162d - a hand frame (thumb side x along) points out of the PALM on a right hand and out of the BACK on a left hand; every palm/thumb rule flips sign per side, and a one-sided error masquerades as a clip defect
metadata:
  type: feedback
---

S162d (2026-10-04): the twist probe measured "the left glove's palm faces away from the face" and I rolled the left
glove +70 deg; the operator opened the export in Blender: "this is not correct for a left arm, it is twisted 180
degrees". The probe's palm vector was the frame's Z = thumb_side x along - the back of a LEFT hand (S155 already
recorded that the left glove is the mesh turned half a turn, palm on -Z).

**Why:** mirrored limbs flip the handedness of any frame built from anatomical directions; a measurement that reads
"left wrong, right fine" is the signature of this sign error, not of the animation.

**How to apply:** when a rule names the palm or thumb, write the per-side sign explicitly and assert it in the test on
the DRAWN geometry (glove_cuff_live_test palm-in check, 0.5..0.9); distrust any asymmetric finding until a second,
independent reading (a reference photo beside the render, Blender, the operator) agrees. Related:
[[feedback_measure_the_twist_before_rolling]], [[feedback_render_the_axis_claim]].
