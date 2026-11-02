---
name: project-session-s53-2026-09-22
description: "S53 shipped the head sphere; the measurement refused the reason five agents gave for it, and the thorax cap is the last blocker"
metadata: 
  node_type: memory
  type: project
  originSessionId: 26d7030c-3fed-45a3-899d-14c93aa481e2
  modified: 2026-09-22T18:50:28.726Z
---

S53 (2026-09-22, PC) shipped `CapsuleShape.gd` + `ApproachBand.gd` to Codex's
blind C164/C165 contracts, classify-on-load in `FighterCapsules.build_report`,
and `SPHERES_ON_LOAD = ["head"]`. Suite **350/8 at `ae019d67`** — the carried
eight, nothing new.

**The finding: promoting the head did NOT unbury the neck.** 0.0% exposed before
and after, both rigs, every blend, banded and unbanded; only the blocker's name
moved (f01 `neck@0.50`: `head` 67/128 → `thorax` 90/128). It shipped for three
other reasons — head is BALL on 10 of 12 rigs, thorax improved at every blend,
and the removed lobe reached 0.0686 m below the Neck bone.

**S54 is D13's flat cap**: the thorax's hemispherical cap is the only blocker
left. J43 measured the bony thoracic inlet at 45–65 × 90–110 mm, so our thorax
radius is 4.9–5.7× the half-inlet AP. Dola's rule changes only the distance
function — no bone move, no new field. **Her 100% figure is hers and was not run
here**; measure the shoulder girdle in the same run, because her own
self-objection is that flat caps break it.

Open and unsettled: the head sphere radius. Q139 says ours is 1.28× the
anthropometry and the head is an ellipsoid on all twelve rigs; G71 (blind, 37
sources) says shrinking it would be worse and no engine ships an ellipsoid
primitive. The untested settlement is a geometric-mean radius (0.1168 m on f01
vs 0.1256 shipped).

Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_informative_failure_still_does_not_ship]],
[[project_capsule_abstraction_verdict]], [[feedback_defects_live_where_agents_meet]].
