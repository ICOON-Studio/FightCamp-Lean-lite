---
name: feedback_open_the_output_before_the_gate
description: A passing gate script is not a verified delivery - on 2026-09-13 six agent deliveries passed their gates and were wrong; every one was caught by opening the PNG or checking a number against physics or a sibling study
metadata: 
  node_type: memory
  type: feedback
  originSessionId: e59fc87e-90ec-4fb6-9117-f1517e8e7314
  modified: 2026-09-29T06:41:11.564Z
---

**2026-09-13, S4a.** Six deliveries passed Claude's own gate scripts and were wrong:
U81's sheet panels were wired to the wrong viewports (a per-cell time label defeated the
"rows identical" check); U82 framed each cell so a floating body looked grounded; U82's t=0 mesh
was a stale capture; U82's fix let the AnimationPlayer keep playing through render waits (retarget
one row ahead of the source); Q83 put pelvises 77 cm through the floor while matching C94 exactly;
C101 used `signed_angle_to` where C100 used the unsigned angle, and concluded "needs IK" - the redo
showed the opposite (a constant rest offset).

**Why:** a gate checks the shape of a delivery and the failures you already imagined. The operator's
eye then caught what no metric measured at all - "head, torso and feet facing differently" is twist,
invisible to a bend angle.

**How to apply:**
- Open at least one real output (Read the PNG, print the worst rows) before merging anything.
- Bound derived numbers by physics and by the sibling study: a spread cannot exceed the largest
  error; a pelvis cannot go through the floor; a walking bob is centimetres.
- When a look finds a defect, add the check that would have caught it to the gate, watch it fail the
  delivery, then send the task back - a redo prompt naming the exact defect lands first time.
- Send the operator the sheets and turn their words into the next measurement.

- **A reproduction's variants must be PROVEN APPLIED (2026-09-13, C105).** Codex's six playback
  variants (blend 0 / 0.2, deterministic on/off...) came back byte-identical, so no transition ever ran,
  and "NOT REPRODUCED" passed a gate that only checked the fields existed. Require two variants that
  must differ to differ, or the gate passes an experiment that never happened.
- **An instrument's reference must not be the data it judges (2026-09-13, R3).** The realism test's
  floor was each man's lowest toe over the bout; once the feet were grounded, ONE mid-blend frame 13 cm
  under the canvas became the floor and R3 printed 0.000 m/s over 0 planted frames - a pass-shaped
  number. Take the reference from physics (the rest pose on the canvas) and count violations separately.

- **A gate that recomputes from the subject's raw rows cannot catch a wrong raw row (2026-09-13, Q89,
  C107).** Q89's check reproduced every statistic from Qwen's samples; the samples had the FBX root
  subtracted, zeroing the very sway being measured. C107's (0, 540] s bound let 51 s bouts through. A
  40-line probe through the same production path (StaggerSmall01 hips 0.722 m) exposed Q89 at once. Pin
  one number to an independent instrument or to exact physics (a decision bout fights 540 s), derive any
  verdict the markdown states from the JSON, and never put an invented bound in a check (a 1.5 m "not a
  reaction" bound failed a legitimately travelling Forward knee clip and stalled the redo).

Related: [[feedback_gate_research_agents]], [[feedback_gates_must_derive_not_copy]],
[[feedback_assert_the_quantity_the_user_sees]], [[feedback_worktree_per_agent]].

- **A reference weighted by screen time moves when the presentation does (2026-09-13, R5).** R5 compared
  join windows with the p99 of every frame of every clip; real time made 78% of those frames idle stance, the
  reference fell, and R5 read 1.76x -> 2.81x with no faster joins. Compare a window with the SAME frames of
  what it should match (R5b), and surface a gate redefinition to the operator rather than making it - they
  ruled "Require both".

- **An agent's summary SENTENCE is wrong more often than its table (2026-09-14): four of fourteen deliveries.**
  All passed their checks. Codex's C113 named the wrong roles as closer (the hooks, the largest change, were
  missing). Qwen's Q94B said "100 checks a minute" for 600, and its Q96 commit message said "halves" for a 69% rise.
  Cursor's U91 said "10-30 deg" for a 10-30% gap. Read the table and the JSON, recompute the one sentence that
  states a verdict, and correct it at collection with a CORRECTED AT COLLECTION line.
- **A distance at a marked instant is not the miss (2026-09-14, C113 -> Q97).** At `_contact_s` the hand was
  0.43-0.48 m from the head, and Claude concluded "range must close". The minimum over the take (one frame earlier)
  put straights at touch distance. Measure the closest frame, split the miss into forward / side / height, then choose.

- **AN AGENT'S RESULTS TABLE IS NOT EVIDENCE THE ARTEFACT RUNS (2026-09-22, S44).** The escalation
  past "the summary sentence is wrong": Dola's round-2 solver shipped a thirteen-row table headed
  "Results — as run". The file throws on its FIRST line of work — the `LIMBS` table writes `jnt:`,
  `buildCapsules` reads `def.joint` — and renders a blank mat. It had NEVER been executed. Repaired
  in two words, not one of the thirteen figures matched: 6 claimed passes were 3, a headline PASS at
  pen 0.0000 was 0.0928, and "hold lift 0.0000, defender hands grounded ✅" was 0.3883 m in the air.
  **So the collect step is LOAD IT AND READ THE CONSOLE before reading a single number.** A blank
  page and a confident table look identical in a chat reply.
- **PERTURB A DOF AND MEASURE THE DISPLACEMENT; DO NOT READ THE SOURCE (same session).** Reading
  found 22 suspicious DOFs; only the measurement proved they were EXACTLY zero rather than merely
  small — and in the next round it showed `head`, `neck` and `torso` at 0.00000 m while the arms
  moved 0.09054 m, which located the defect (one rotation about Y is not a joint; any segment lying
  on that axis through its own joint cannot move). Cheap, and it settles what a code read only
  suspects. Pairs with [[feedback_a_control_that_cannot_move]].
- **S123 (2026-09-29): THREE C223 FALSE PASSES, EVERY ONE CAUGHT ON THE STILLS.** (1) slip counter with piece_cut 0.667
  passed 12/12 rows, but the sheet labelled ~0.9 s of IDLE between the slip and the punch - not a counter. (2) the Mixamo
  "High_Right_Block" catch passed a glove-to-head DISTANCE row while the glove went over the crown (a high cover). (3) a
  guard + Euler-layer catch passed the tightened row on its best frame while the PEAK frame lifted the glove to the
  forehead. A single-best-frame row passes a wrong pose; add an every-frame bound (catch_glove_over_head) and render
  FRONT AND SIDE (yaw=90) stills before certifying any pose move. Rows are made from what the stills showed.
- **A DIAGNOSIS THAT FITS THE NUMBERS CAN STILL BE WRONG (same session).** A `mob` weight term had
  its signs backwards against the file's own comments — an obvious, satisfying finding. Flipping all
  four moved no metric by more than 0.003 m: the term never bound at all. Test the fix before
  reporting the cause. [[feedback_give_every_fix_a_control_arm]]
