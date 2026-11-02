---
name: feedback-render-the-axis-claim
description: S155 - a mesh's handedness/axis claim in a build script was wrong for 6 sessions; render from the named side before trusting any "thumb on +X" comment
metadata:
  type: feedback
---

S155: the Sketchfab glove's build script said "thumb lobe lands on Godot +X" and CCFighterSkin mirrored only the left hand on that claim. The mesh was a LEFT glove: both hands wore the wrong-handed glove from C241 (S147) until the operator saw it (S154). One camera placed on glove +X with the glove see-through showed the hand's own thumb outside the glove and the lobe opposite - minutes of work.

**Why:** an axis/handedness claim in a docstring is an unverified premise; vertex slices alone were ambiguous (the palm lean dominated), and a test written on the same premise passes.

**How to apply:** for any mirrored/handed asset, render it from the side the code CLAIMS (camera in the asset's own frame, solid + see-through with the body part inside) and open the still before tuning anything. A handedness test must read the side from anatomy (index->little knuckle line), not from the code's frame constant, and must go red on the old mirror (S155's first two instrument versions were blind - mutants caught it). Related: [[feedback_fit_the_render_not_a_vertex_dump]], [[feedback_gloves_show_a_still_early]], [[feedback_a_gate_that_reads_its_subject_cannot_fail]].
