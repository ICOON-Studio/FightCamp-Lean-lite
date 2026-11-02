---
name: feedback_a_gate_that_reads_its_subject_cannot_fail
description: A validator that learns its allowed values from the artefact it validates always passes - check every gate for this before trusting a green result
metadata: 
  node_type: memory
  type: feedback
  originSessionId: ae7d7ea0-43f4-42ae-99e8-02cde6bb42a1
  modified: 2026-09-21T18:02:45.527Z
---

**A gate that derives its expectations from the thing it is checking cannot
fail.** Found three times in one day (2026-09-12), each time hiding real
breakage behind a green result:

1. `Godot/tools/validate_technique_nodes.py` — `_vocabularies()` builds the
   allowed `kind`/`role` set **by scanning the catalogue it is about to
   validate**. Every "validator=OK" reported on the four technique trees
   (U60B, C95, Q65) was worth nothing. Measured against the real contract
   instead, the LIVE catalogue already carried 133 bad roles and 39 bad kinds.
2. `Tools/agent_comms.py sweep` scans only `## Active claims`, so 260 lines of
   finished blocks that had been pasted **above** that heading were invisible
   to it — it reported "nothing finished" for four days while the pile grew.
3. The `handover` block accused Qwen of a false positive. Nothing re-checked
   the accusation against the files, so it would have propagated to every
   future session as fact. It was wrong (R141).

**A SHARPER FORM, AND IT DID NOT MERELY MISS THE DEFECT - IT REQUIRED IT**
(S40, 2026-09-21). `probe_cmu_grip.gd`'s `_check_joint_convention` asserted
"two parents above the elbow node is the humerus". That is a claim about NODE
NAMES — and the names were the very thing that was one off, because
`glb[J] == asf[parent J]`, so the glTF node called `lhumerus` sits at the
SHOULDER. The gate therefore PASSED for the joint pair that was one node distal
and would have FAILED the pair our rig can actually represent. A gate written in
the same vocabulary as the bug cannot fail on that bug; it enforces it. What
replaced it derives the requirement from the map the retarget itself uses —
every source joint must be a key of `CMU_TO_OURS` whose image is the rig joint
it is measured against — so shifting either constant fails by naming the bone
that has no image.

**The habit that found it:** the ASF file DECLARES its bone lengths. Matching
every measured glTF segment against those declarations settled in one command a
joint-convention argument that two stages had conducted in prose. **When a
dispute is about what something IS, look for the file that states it, rather
than reasoning from what things are called.**

**Why:** this is Cursor's U62 root cause — *"every authored claim ships unbound
to the one consumer that would falsify it, so duplicates drift under
self-checking gates and orphans never fail at all."* Nine defects in one day,
every one of them passing a green 262-test suite.

**How to apply:** before trusting any green gate, read how it decides what is
allowed. If the answer comes from the artefact under test, the gate is
decorative — replace its expectations with the CONTRACT document, a second
independent source, or a blind test written from the spec. When you write an
exemption, derive it from a property the data already declares (S1 exempted
range-ladder spread via the `phase_transition` effect: 10 nodes declare it,
exactly the 2 wide ones are among them) rather than from a list of ids, which
rots silently. And pin the honest gap, not just the good number — S1 pinned
"424 of 696 techniques have no legality research" beside the 696, because
pinning only the 696 would have hidden it.

See [[feedback_gates_must_derive_not_copy]], [[feedback_blind_tests_can_collide]]
and [[feedback_assert_the_quantity_the_user_sees]].

**Second instance, 2026-09-21 (S42 grips), and the mutant pass found it.** Every
assertion about the new grip term called `grip_gap` — *the same function the
solver minimises*. The `grip-blend-ignored` mutant (force `blend` to 0.5 instead
of the authored value) **passed every one of them**: solver and check agreed
with each other and were wrong together.

The repair is an assertion DERIVED in the test from raw geometry, not borrowed
from the subject: `blend: 0.0` names the target capsule's `p0`, so the solved
hand must end up nearer `p0` than `p1`. That single independent check is what
turns the mutant red — it fails by exactly 1.

**The habit:** when a test grades a solver, at least one assertion must be
computed from something the solver does not use. Otherwise the test measures
agreement, not correctness. Related: [[feedback_a_control_that_cannot_move]],
[[feedback_prove_contract_tests_with_mutants]].
