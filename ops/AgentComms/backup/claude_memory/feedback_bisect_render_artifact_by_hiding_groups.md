---
name: feedback-bisect-render-artifact-by-hiding-groups
description: "A visual artefact no probe names - hide each top-level node group, render a crop per arm, tile them; S154 physio \"sheet\" was a light shaft"
metadata:
  node_type: memory
  type: feedback
  originSessionId: e4b47d04-4628-4690-a295-f3be21bda627
  modified: 2026-10-03T08:38:36.248Z
---

When a still shows an artefact (a pale sheet, a ghost box) and mesh/transparency probes find nothing, render the room once
per top-level child with only that child hidden, crop the region, tile the crops into one sheet and look. S154: the physio
door's "washed out" sheet survived SSAO/SSIL/glow/sun-shadow arms and a transparency probe (the probe's filter skipped it);
hiding `LightShaft` alone cleared it - RoomFx's back-wall shaft running along a LEFT-wall window.

**Why:** guessing the cause (lighting, overlay, shadow) cost four render rounds; the hide-each-group sheet answered in one.
**How to apply:** go to the group bisect after one failed guess. Related: [[feedback_bucket_defect_by_clip]],
[[feedback_open_the_output_before_the_gate]].
