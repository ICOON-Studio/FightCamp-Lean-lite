---
name: feedback_ask_what_a_rule_is_for
description: "Before tuning an engine number, ask what the rule is FOR; a number that sits near its real-world anchor can be an accident of a broken mechanism - fix the mechanism, and hold the change if the real mechanism moves the number away"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: db605f39-dfe9-45a3-b55f-992df0d98eb8
  modified: 2026-09-12T23:20:31.382Z
---

Two findings from S1e (2026-09-13) had the same shape, and both looked like numbers
to tune:

- The MMA grappler landed 20.6% of strikes and won 0 of 40. The obvious lever was
  the defence cap. The real defect: the defence bonus summed every defence node
  against every incoming action, so one `wrestling_sprawl` stopped jabs. The fix was
  authored data saying what each defence ANSWERS (`defense_answers`), not a number.
- Judo's parent tree ended 40% ippon against the real 46.2% - apparently fine. It was
  an accident: an invisible ground (100% engine fallback) ate a third of every bout.
  Making the ground real (seats, osaekomi, matte) moved ippon to 68%, because the
  judo tree has no escape node and landed throws nearly always score.

**Why:** a metric can match its anchor for the wrong reason, and a tuning pass on top
of a wrong mechanism bakes the defect in - the operator's standing lesson from R132
(identical fighters) in another form.

**How to apply:** when a rule sums, counts or thresholds, first write down what it
answers and against what (which action, which seat, which population). Measure the
mechanism before comparing to the anchor. If the real mechanism moves the number
AWAY from the anchor, hold the change with the measured reason recorded (S1e kept
judo in `unseated_debt` with the numbers and the one-command apply) and research the
missing piece. When a new constant is introduced, sweep it and put the sweep in the
commit - `SUBMISSION_SWITCH_CARRY` is flat to 0.7 and a cliff after.

Related: [[feedback_never_test_identical_fighters]], [[feedback_gates_must_derive_not_copy]],
[[feedback_assert_the_quantity_the_user_sees]].
