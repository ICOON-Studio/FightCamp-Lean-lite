---
name: project-session-s120
description: "S120 - Codex out, Claude owns C223; boxing 11/36 via additive pose layers; body-shot aim fix; female MPFB fighters; ops board fix; operator angry about not knowing which bodies ship"
metadata:
  node_type: memory
  type: project
  originSessionId: b8f0fab2-8425-48bb-b604-aa7c2f5eeaa9
  modified: 2026-09-28T16:50:58.408Z
---

S120 (2026-09-28). Operator: "codex is out of credits you take all the 3d animation design for now".
- Boxing 11/36: rear_hook_body certified by an ADDITIVE POSE LAYER (FightClipPoseLayer.gd) on a certified base +
  strike-warp `pre` span. Method that works: tools/s120_axis_probe.gd (axes) -> tools/s120_layer_solve.gd (hand at contact
  by number) -> one-rig side render (yaw=100) -> bound witness on 4 generated rows. Blind render trials cost ~2 min each.
- Traps found: audition-path `hold_root` on a base certified without it makes a whole-body jump (both hands peak same
  frame); onset x peak is fixed by hand travel, so one uniform warp can't always fit both bands -> `pre` span; the live
  contact helper aimed body shots from the SHOULDER (fixed: clip's own contact fist, latched per strike).
- Female fighters on MPFB (mpfb_build_base.py already took `female`); Tripo twelve no longer used.
- Operator anger: I answered "which models" from memory twice wrong -> [[project-fighter-bodies-in-game]].
- Ops board: roster toggle nulled the snapshot cache -> 80 s rebuild -> "button does nothing"; fixed + disk snapshot.
Next: S121 = nightly reds (Q210 muay_thai_ground nodes first), collect Q214, remaining boxing moves.
