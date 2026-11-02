---
name: project_operator_verdict_foot_lock_2026-09-14
description: "Operator watched the foot lock before/after and saw no difference; named the worst on screen as bodies overlapping, jerky moves, fake punches - S4a's next targets"
metadata: 
  node_type: memory
  type: project
  originSessionId: 770bca84-14d0-41c9-a0db-47e27191ac42
  modified: 2026-09-14T02:22:49.194Z
---

**2026-09-14, after the foot lock merged (`b73ca90`).** The operator watched a side-by-side (same bout, lock off
v on, full-body camera) on the phone: "I do not see any difference before an after footlocker", then "I am on phone
maybe I am wrong". Asked what looks MOST wrong, they picked (multi-select): **bodies overlap, jerky moves, punches
look fake** - and NOT feet sliding.

**Why:** the lock cut measured planted-foot skate by a third (R3 0.172 -> 0.114 m/s), but the slides big enough to
see (stagger travel, the mirrored hook_rear's stance swap) are the ones it releases on. A metric win that the eye
cannot see is not watchability. The three picks each already had a measured cause: the room keeps the men
0.80/0.95/1.10 m apart (INFERENCE bands) against elite 1.23 +- 0.16 m (Schortgen via K29/K50) and in-place punches
only reach from too close (Q97: jabs miss the head 0.3-0.4 m low); joins move joints 2-3.4x the performance (R5/R5b).

**How to apply:** S4a's work after the lock goes to those three, in the operator's words. Instruments first (U95 body
overlap from mesh capsules; Q97's miss split), then fixes grounded in shipped engines: Unreal's Dead Blending for
joins (C119/C120, `FightDeadBlend.gd`), Motion Warping so a strike arrives at its target (C121), push boxes (K50),
real spacing bands (K50). Send a phone-sized close-up when the difference is small, and ask what looks wrong with
AskUserQuestion options rather than guessing. See [[project_watchability_verdict_2026-09-13]],
[[feedback_open_the_output_before_the_gate]].
