---
name: feedback_gate_must_sit_in_the_certification_path
description: "A red instrument OUTSIDE the path that counts progress protects nothing: Q213's clipping FAIL sat beside C223's count for 5 sessions (19/36 was really 1/36)"
metadata:
  node_type: memory
  type: feedback
  originSessionId: 3789a020-1b4a-44ae-a0bb-6a86b94e9301
  modified: 2026-09-29T08:14:53.334Z
---

A gate only protects what it can refuse. S119 built Q213 (the G147 clipping gate) and it read FAIL on the certified clips (1/11)
- recorded in the milestone evidence as "clipping gate = FAIL 0%" - while C223 kept certifying and COUNTING moves without it.
S124 the operator found it from one still ("what is this ???"): the certified jab lunges chest-to-chest; re-judged, 19/36 -> 1/36.

**Why:** a number reported beside a count is read as context; only a row inside the certifying gate stops a move being counted.

**How to apply:** when a new instrument measures a quality the milestone requires, wire it into the gate that PRODUCES the count
(c223_production_gate / c223_sequence_gate rows) in the same session, or state in the count itself "N/36 - clipping unmeasured".
Never let a red quality gate and a green progress count coexist. Also look at a mid-contact still of every certified move from
the GAME camera (the broadcast angle hid the jab arm), not only the side view. Related: [[feedback_open_the_output_before_the_gate]],
[[project_session_S124_2026-09-29]].
