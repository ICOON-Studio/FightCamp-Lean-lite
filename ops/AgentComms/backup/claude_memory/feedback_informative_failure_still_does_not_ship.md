---
name: feedback_informative_failure_still_does_not_ship
description: A change that makes the measured thing worse does not ship because its failure is informative
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 928672c1-cd85-44c1-9dba-06a222f809a3
  modified: 2026-09-22T10:18:11.283Z
---

A fix can be right in principle, be supported by every line of evidence, and
still make the measured quantity worse. When it does, **revert it and record the
measurement** — do not ship it on the grounds that its failure usefully exposed
the next defect.

S48 (2026-09-22): the pelvis capsule had ball ratio 0.824 (worst on the rig),
was the named worst pair on the repaired collar tie, and the anatomy probe said
outright `the capsule is the obstruction`. Deriving it by depth was obviously
correct — a pelvis is not a sphere. It took the pose corpus from **3/13 to
1/13**; `side_control`, `closed_guard` and `mount` all lost passes they had.

**Why:** the pull to ship it anyway is strong precisely *because* the failure is
interesting — it revealed that narrowing the trunk spends its gain on a leg
collision (Q131's live-room cascade, reproduced in the static corpus). That
reasoning is how this project produced four retracted findings.

**How to apply:** revert the change, write the full before/after table into the
module comment and the digest so the next session starts from the number, and
name what has to happen first. Related: [[feedback_give_every_fix_a_control_arm]],
[[feedback_run_the_instrument_on_the_old_tree_first]],
[[feedback_open_the_output_before_the_gate]].
