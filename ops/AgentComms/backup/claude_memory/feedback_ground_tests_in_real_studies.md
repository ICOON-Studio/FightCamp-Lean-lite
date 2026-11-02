---
name: feedback_ground_tests_in_real_studies
description: "Operator 2026-09-13: a test that claims realism is grounded in REAL studies before it is written - every rule prints its study, the real number and the range; no study means commission one, never invent a bound"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: dcae606d-261c-4855-90ed-17977ad9bf59
  modified: 2026-09-13T11:52:03.130Z
---

Operator, 2026-09-13, verbatim: *"i want your tests to be based on reality, how you compare results
from your tests with real studies, when you have not done real studies to give ground to your tests,
does that make sense? i mean the space between exchanges should have been in your test from the very
first test. take this as advice"*

Said while S4a's step-0 presentation-realism test was being designed. The presentation tests before it
(seam, playback, speed, fidelity) asserted occurrence and policy but never compared the RHYTHM the
player sees with a real bout, although JPES 2016's time-motion numbers (active 1.2±0.8 s, inactive
2.3±1.8 s) were available - so a clip every 1.1 s with no neutral time shipped green for weeks.

**Why:** a test with an invented bound only agrees with the code it was written next to; comparing
against a real measured bout is the only thing that makes "realistic" falsifiable.

**How to apply:**
- Before writing any test that claims realism (timing, movement, physics, rates), list the real studies
  that ground each assertion. Each rule line in the output names the study, the real value (mean±SD,
  sample) and the range it allows, beside the measured value.
- A quantity with no study is labelled NO STUDY in the test output and a research task is assigned for
  it at once (K29 was the first: time-motion for every discipline, return-to-guard in bouts, hit
  reactions). Never dress an invented number as a real one.
- Where no real-world number can exist (a crossfade length), ground the check in what reality bounds
  instead: joint speeds no faster than the real motion in the clips themselves, feet that do not slide,
  a pelvis that never goes through the floor.
- Grounding comes FIRST, in the first test of a feature - not bolted on after the operator notices.

**AN INVENTED BOUND COSTS MOST WHEN THE THING KEEPS FAILING IT (2026-09-21).**
The Dola clinch pose failed its own assertion three revisions running — the two
fighters' hands must finish **0.10–0.30 m** apart, landing at 1.229 m then
0.693 m. Every revision treated the pose as the thing to fix. **Nobody had ever
checked the 0.10–0.30 m.** Measured against the paired corpus (Q123), real
clinch hands are **0.747 m** apart at p50 and 0.357 m even at p10; the hands
never reach the opponent's neck at all (nearest 0.721 m) and sit 0.443 m BELOW
neck height. The pose had been roughly right for two revisions and was being
driven away from reality by its own gate.

**So: when something fails the same assertion repeatedly, validate the
ASSERTION before iterating again.** Repeated failure reads as evidence the
subject is broken; it is equally evidence the bound was invented. One
measurement against the corpus settled what three authoring passes could not.

Related: [[feedback_gates_must_derive_not_copy]], [[feedback_assert_the_quantity_the_user_sees]],
[[feedback_deadend_means_assign_research]], [[feedback_never_test_identical_fighters]].
